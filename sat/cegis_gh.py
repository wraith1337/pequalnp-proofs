import sys, json, time, random
from pysat.solvers import Cadical195

# args: edges_json k cap budget_sec
EDGES = [tuple(e) for e in json.loads(sys.argv[1])]
K = int(sys.argv[2]); CAP = int(sys.argv[3]); BUDGET = float(sys.argv[4])
NIN = max(max(e) for e in EDGES) + 1
NT = 1 << NIN

def target(t): return any((t>>u)&1 and (t>>v)&1 for u,v in EDGES)

def build(k, subset):
    nxt=[1]
    def newvar():
        vv=nxt[0]; nxt[0]+=1; return vv
    v = [[newvar() for _ in subset] for _ in range(NIN+k)]
    cls = []
    for n in range(NIN):
        for ti,t in enumerate(subset):
            cls.append([v[n][ti] if (t>>n)&1 else -v[n][ti]])
    s, o = {}, {}
    for i in range(k):
        node = NIN+i
        o[i] = newvar()
        pairs = [(j,kk) for j in range(node) for kk in range(j+1,node)]
        for pr in pairs: s[(i,)+pr] = newvar()
        sv = [s[(i,)+pr] for pr in pairs]
        cls.append(list(sv))
        for a in range(len(sv)):
            for b in range(a+1,len(sv)):
                cls.append([-sv[a],-sv[b]])
        for pr in pairs:
            sv_ = s[(i,)+pr]; j,kk = pr
            for ti,t in enumerate(subset):
                vg, vj, vk = v[node][ti], v[j][ti], v[kk][ti]
                cls.append([-sv_, -o[i], -vg, vj])
                cls.append([-sv_, -o[i], -vg, vk])
                cls.append([-sv_, -o[i], vg, -vj, -vk])
                cls.append([-sv_, o[i], vg, -vj])
                cls.append([-sv_, o[i], vg, -vk])
                cls.append([-sv_, o[i], -vg, vj, vk])
    last = NIN+k-1
    for ti,t in enumerate(subset):
        cls.append([v[last][ti] if target(t) else -v[last][ti]])
    return cls, s, o

def extract(sol, k):
    m = set(sol.get_model())
    out = []
    for i in range(k):
        node = NIN+i
        found=None
        for j in range(node):
            for kk in range(j+1,node):
                if s[(i,j,kk)] in m: found=(j,kk); break
            if found: break
        out.append(('or' if o[i] in m else 'and', found))
    return out

def ev(gates, t):
    vals=[(t>>i)&1 for i in range(NIN)]
    for op,(a,b) in gates:
        vals.append(int((vals[a] or vals[b]) if op=='or' else (vals[a] and vals[b])))
    return vals[-1]

t0=time.time()
random.seed(1337)
subset=set()
for t in range(NT):
    w=bin(t).count('1')
    if w<=2 or w>=NIN: subset.add(t)
while len(subset)<min(NT,CAP): subset.add(random.randrange(NT))
subset=sorted(subset)
print(f"start: n={NIN} edges={len(EDGES)} k={K} subset={len(subset)}", flush=True)
it=0
while time.time()-t0 < BUDGET:
    it+=1
    cls,s,o = build(K, subset)
    with Cadical195(bootstrap_with=cls) as sol:
        sat = sol.solve_limited()   # allow interruption-friendly
    el = time.time()-t0
    if not sat:
        print(f"iter {it}: UNSAT on subset {len(subset)} ({el:.0f}s)", flush=True)
        if len(subset)==NT:
            print("FULL UNSAT", flush=True); break
        subset = list(range(NT))
        continue
    gates = extract(sol, K)
    bad = [t for t in range(NT) if ev(gates,t) != (1 if target(t) else 0)]
    if not bad:
        print(f"CIRCUIT FOUND k={K} ({el:.0f}s)", flush=True)
        for i,(op,pr) in enumerate(gates): print(f"  g{NIN+i} = {op}{pr}", flush=True)
        break
    subset = sorted(set(subset)|set(bad))
    print(f"iter {it}: failed on {len(bad)}, subset={len(subset)} ({el:.0f}s)", flush=True)
else:
    print(f"TIMEOUT after {it} iters, subset={len(subset)}/{NT}", flush=True)
