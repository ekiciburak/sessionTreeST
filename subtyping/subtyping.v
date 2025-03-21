Require Import ST.src.stream ST.src.st ST.src.so ST.src.si ST.src.reordering 
               ST.src.siso ST.types.local ST.subtyping.refinement ST.src.reorderingfacts.
From mathcomp Require Import all_ssreflect seq ssrnat.
From Paco Require Import paco.
Require Import String List.
Import ListNotations.
Require Import Setoid.
Require Import Morphisms.
Require Import Coq.Logic.Classical_Pred_Type Coq.Logic.ClassicalFacts Coq.Logic.Classical_Prop.
Require Import ProofIrrelevance.

Fixpoint listSisoPRef (l: list (siso*siso)): Prop :=
  match l with
    | nil            => True
    | cons (W,W') xs => (exists d1, exists d2, (forall n, refinement (merge_dpf_contn d1 (@und W) n) (merge_dpf_contn d2 (@und W') n))) /\ listSisoPRef xs
  end.

Fixpoint decomposeL (l: list (siso*siso)) (s: st) (s': st): Prop :=
  match l with
    | nil            => True
    | cons (W,W') xs => st2sisoC (@und W) s /\ st2sisoC (@und W') s' /\ decomposeL xs s s'
  end.

Definition subtype (T T': st): Prop := exists (l: list (siso*siso)), decomposeL l T T' /\ listSisoPRef l.

Fixpoint listSisoPRef2 (l: list (siso*siso)): Prop :=
  match l with
    | nil            => True
    | cons (W,W') xs => (exists d1, exists d2, (forall n, (merge_dpf_contn d1 (@und W) n) ~<  (merge_dpf_contn d2 (@und W') n))) /\ listSisoPRef2 xs
  end.

Definition subtype2 (T T': st): Prop := exists (l: list (siso*siso)), decomposeL l T T' /\ listSisoPRef2 l.

(* Fixpoint listSisoPRef3A (l: list (siso*siso)): Prop :=
  match l with
    | nil            => True
    | cons (W,W') xs => (exists b1, exists b2, (forall n, refinement3 (merge_bpf_contn b1 (@und W) n)  (merge_bpf_contn b2 (@und W') n))) /\ listSisoPRef3A xs
  end.

Definition subtype3A (T T': st): Prop := exists (l: list (siso*siso)), decomposeL l T T' /\ listSisoPRef3A l. *)

Definition subltype (T T': local) := subtype (lt2st T) (lt2st T').

(* Definition subltype2 (T T': local) (T1 T2: st) (P: lt2stC T T1) (Q: lt2stC T' T2) := subtype2 T1 T2. *)


