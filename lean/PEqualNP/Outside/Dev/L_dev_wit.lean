import Mathlib
import PEqualNP.Defs

namespace PEqualNP.Outside.Dev.WitTest

private def hit (m n : ℕ) (S : Fin m → Finset (Fin n)) (B : Finset (Fin n)) : Finset (Fin m) :=
  Finset.univ.filter (fun i => ∃ x ∈ B, x ∈ S i)

private lemma hit_insert (m n : ℕ) (S : Fin m → Finset (Fin n)) (a : Fin n) (B : Finset (Fin n)) :
    hit m n S (insert a B) = (Finset.univ.filter (fun i => a ∈ S i)) ∪ hit m n S B := by
  ext i
  simp only [hit, Finset.mem_filter, Finset.mem_univ, true_and, Finset.mem_union,
    Finset.mem_insert]
  aesop

theorem result : ∀ (m n r : ℕ) (S : Fin m → Finset (Fin n)),
    (∀ x y : Fin n, x ≠ y → ∃ i : Fin m, x ∈ S i ∧ y ∈ S i) →
    (∀ x : Fin n, (Finset.univ.filter (fun i : Fin m => x ∈ S i)).card = r) →
    ∀ B : Finset (Fin n),
      (Finset.univ.filter (fun i : Fin m => ∃ x ∈ B, x ∈ S i)).card + B.card ≤ B.card * r + 1 := by
  intro m n r S hp hr B
  change (hit m n S B).card + B.card ≤ B.card * r + 1
  induction B using Finset.induction_on with
  | empty => simp [hit]
  | @insert a B ha ih =>
    rw [hit_insert, Finset.card_insert_of_notMem ha]
    by_cases hB : B.Nonempty
    · obtain ⟨b, hb⟩ := hB
      have hab : a ≠ b := by intro h; exact ha (h ▸ hb)
      obtain ⟨i, hai, hbi⟩ := hp a b hab
      have hi : i ∈ (Finset.univ.filter (fun j => a ∈ S j)) ∩ hit m n S B := by
        simp only [Finset.mem_inter, Finset.mem_filter, Finset.mem_univ, true_and, hit]
        exact ⟨hai, b, hb, hbi⟩
      have hone : 1 ≤ ((Finset.univ.filter (fun j => a ∈ S j)) ∩ hit m n S B).card :=
        Finset.one_le_card.mpr ⟨i, hi⟩
      have hc := Finset.card_union_add_card_inter (Finset.univ.filter (fun j => a ∈ S j)) (hit m n S B)
      rw [hr a] at hc
      nlinarith
    · have he : B = ∅ := Finset.not_nonempty_iff_eq_empty.mp hB
      subst B
      simp [hit, hr]

end PEqualNP.Outside.Dev.WitTest
