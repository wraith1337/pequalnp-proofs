import Mathlib
import PEqualNP.Defs

namespace PEqualNP.Outside.Dev.WitTest

open PEqualNP.CircuitLowerBounds PEqualNP.MetaComplexity

private lemma edgeConsW (x : Fin 5 → Bool) (a b : ℕ) (ha : a < 5) (hb : b < 5) (es : List (ℕ × ℕ)) :
    (∃ u v : Fin 5, (u.val, v.val) ∈ (a, b) :: es ∧ x u = true ∧ x v = true) ↔
    (x ⟨a, ha⟩ = true ∧ x ⟨b, hb⟩ = true) ∨
      ∃ u v : Fin 5, (u.val, v.val) ∈ es ∧ x u = true ∧ x v = true := by
  constructor
  · rintro ⟨u, v, h, hu, hv⟩
    rcases List.mem_cons.mp h with h | h
    · obtain ⟨h1, h2⟩ := Prod.mk.inj h
      exact Or.inl ⟨(show u = ⟨a, ha⟩ from Fin.ext h1) ▸ hu, (show v = ⟨b, hb⟩ from Fin.ext h2) ▸ hv⟩
    · exact Or.inr ⟨u, v, h, hu, hv⟩
  · rintro (⟨h1, h2⟩ | ⟨u, v, h, hu, hv⟩)
    · exact ⟨⟨a, ha⟩, ⟨b, hb⟩, List.mem_cons_self, h1, h2⟩
    · exact ⟨u, v, List.mem_cons_of_mem _ h, hu, hv⟩

/-- x1(x0+x2) + x3(x2+x4) + x0x4 : 7 gates for the 5-cycle edge function. -/
def c5circ : Circuit where
  gates := [
    ⟨.or, [0, 2]⟩,
    ⟨.and, [1, 5]⟩,
    ⟨.or, [2, 4]⟩,
    ⟨.and, [3, 7]⟩,
    ⟨.and, [0, 4]⟩,
    ⟨.or, [6, 8]⟩,
    ⟨.or, [10, 9]⟩
  ]
  output := 11

theorem test587 : ∀ C : Circuit, C = c5circ → Monotone2 C ∧ C.size ≤ 7 ∧
    (∀ x : Fin 5 → Bool, (C.eval (List.ofFn x) = true ↔
      ∃ u v : Fin 5, (u.val, v.val) ∈ ([(0,1),(1,2),(2,3),(3,4),(4,0)] : List (ℕ × ℕ)) ∧
        x u = true ∧ x v = true)) := by
  rintro C rfl
  refine ⟨?_, by decide, ?_⟩
  · intro gate hg
    simp only [c5circ, List.mem_cons, List.not_mem_nil, or_false] at hg
    rcases hg with rfl | rfl | rfl | rfl | rfl | rfl | rfl <;> exact ⟨by simp, by decide⟩
  · intro x
    have hx : List.ofFn x = [x 0, x 1, x 2, x 3, x 4] := rfl
    rw [hx]
    simp only [c5circ, Circuit.eval, Circuit.wires, List.foldl_cons, List.foldl_nil,
      List.map_cons, List.map_nil, List.cons_append, List.nil_append,
      GateOp.eval, List.any_cons, List.any_nil, List.all_cons, List.all_nil, id_eq,
      List.getD, List.getElem?_cons_zero, List.getElem?_cons_succ, Option.getD_some,
      Bool.or_false, Bool.and_true]
    rw [edgeConsW x 0 1 (by decide) (by decide)]
    rw [edgeConsW x 1 2 (by decide) (by decide)]
    rw [edgeConsW x 2 3 (by decide) (by decide)]
    rw [edgeConsW x 3 4 (by decide) (by decide)]
    rw [edgeConsW x 4 0 (by decide) (by decide)]
    simp only [List.not_mem_nil, false_and, exists_false, or_false,
      Bool.or_eq_true_iff, Bool.and_eq_true_iff]
    simp only [and_or_left, or_and_right]
    apply Iff.of_eq
    ac_rfl

end PEqualNP.Outside.Dev.WitTest
