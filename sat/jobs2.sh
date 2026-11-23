#!/bin/bash
# C7 k=9 full-set: exact min-circuit question; 608 bound says >=10. UNSAT at 9 supports 608.
C7='[[0,1],[1,2],[2,3],[3,4],[4,5],[5,6],[6,0]]'
# Q3 cube: candidate graph for L-meta-617 ("3-c...", <=10 gates). 8 vertices, 12 edges.
Q3='[[0,1],[0,2],[0,4],[1,3],[1,5],[2,3],[2,6],[3,7],[4,5],[4,6],[5,7],[6,7]]'
echo "=== C7 k=9 (full 128 assignments)"
python3 sat/cegis_gh.py "$C7" 9 128 2400
echo "=== Q3 k=10 (candidate for L-meta-617)"
python3 sat/cegis_gh.py "$Q3" 10 56 2400
