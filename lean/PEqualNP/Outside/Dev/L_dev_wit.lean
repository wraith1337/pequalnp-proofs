import Mathlib
import PEqualNP.Defs

namespace PEqualNP.Outside.Dev.WitTest

open PEqualNP.CircuitLowerBounds PEqualNP.MetaComplexity

/-- The 7-gate monotone circuit for the 5-cycle edge function:
    x1(x0+x2) + x3(x2+x4) + x0x4. -/
def c5circ : Circuit where
  gates := [
    ⟨.or, [0, 2]⟩,   -- w5
    ⟨.and, [1, 5]⟩,  -- w6 = x1*(x0+x2)
    ⟨.or, [2, 4]⟩,   -- w7
    ⟨.and, [3, 7]⟩,  -- w8 = x3*(x2+x4)
    ⟨.and, [0, 4]⟩,  -- w9 = x0*x4
    ⟨.or, [6, 8]⟩,   -- w10
    ⟨.or, [10, 9]⟩   -- w11
  ]
  output := 11

theorem mono : Monotone2 c5circ := by decide

theorem sz : c5circ.size ≤ 7 := by decide

theorem correct : ∀ x : Fin 5 → Bool,
    (c5circ.eval (List.ofFn x) = true ↔
      ∃ u v : Fin 5, (u.val, v.val) ∈ ([(0,1),(1,2),(2,3),(3,4),(4,0)] : List (ℕ × ℕ)) ∧
        x u = true ∧ x v = true) := by decide

end PEqualNP.Outside.Dev.WitTest
