import Mathlib
import PEqualNP.Defs

namespace PEqualNP.Outside.Dev.Test3037

theorem result : ∀ (x1 : ℕ) (x2 : Fin x1 → Fin x1 → Prop) [x3 : DecidableRel x2],   have x4 : Finset (Fin x1) → Fin (x1 + x1) → Bool := fun (x4 : Finset (Fin x1)) (x5 : Fin (x1 + x1)) => Fin.addCases (fun (x6 : Fin x1) => Decidable.decide ¬∃ x7 ∈ x4, x2 x6 x7) (fun (x6 : Fin x1) => Decidable.decide (x6 ∈ x4)) x5;   ∀ (x5 : Finset (Fin x1)), Fintype.card { x6 : Fin x1 // x4 x5 (Fin.natAdd x1 x6) = Bool.true } = x5.card ∧ ¬∃ (x6 : Fin x1) (x7 : Fin x1), x2 x6 x7 ∧ x4 x5 (Fin.castAdd x1 x6) = Bool.true ∧ x4 x5 (Fin.natAdd x1 x7) = Bool.true := by
  intro n R hR
  dsimp only
  intro S
  constructor
  · simpa using (Fintype.card_coe S)
  · simp only [Fin.addCases_left, Fin.addCases_right, decide_eq_true_eq]
    rintro ⟨u, v, huv, hu, hv⟩
    exact hu ⟨v, hv, huv⟩

end PEqualNP.Outside.Dev.Test3037
