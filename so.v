From mathcomp Require Import all_ssreflect.
From Paco Require Import paco.
From ST Require Import stream st.
Require Import String List.
Local Open Scope string_scope.
Import ListNotations.

From Paco Require Import paco.
Require Import Setoid.
Require Import Morphisms.

CoInductive so: Type :=
  | so_end    : so 
  | so_receive: participant -> list (label*sort*so) -> so 
  | so_send   : participant -> (label*sort*so)      -> so.

Local Open Scope list_scope.

(* Inductive st2soA (R: st -> so -> Prop): st -> so -> Prop :=
  | st2soA_end: st2soA R st_end so_end
  | st2soA_snd: forall l s x t xs p,
                List.In (l,s,x) xs ->
                R (st_send p [(l,s,x)]) t ->
                st2soA R (st_send p xs) t
  | st2soA_rcv: forall p l s x t xs,
                List.In (l,s,x) xs -> 
                R x t ->
                st2soA R (st_receive p xs) t. *)

Inductive st2so (R: st -> st -> Prop): st -> st -> Prop :=
  | st2so_end: st2so R st_end st_end
  | st2so_snd: forall l s x t xs p,
               List.In (l,s,x) xs ->
               R (st_send p [(l,s,x)]) t ->
               st2so R (st_send p xs) t
  | st2so_rcv: forall p l s t xs ys,
               List.Forall (fun u => R (fst u) (snd u)) (zip xs ys) ->
               R (st_receive p (zip (zip l s) ys)) t ->
               st2so R (st_receive p (zip (zip l s) xs)) t.

Lemma st2so_mon: monotone2 st2so.
Proof. unfold monotone2.
       intros.
       induction IN; intros.
       - apply st2so_end.
       - specialize (st2so_snd r'); intro HS.
         apply HS with (l := l) (s := s) (x := x).
         apply H.
         apply LE, H0.
       - specialize (st2so_rcv r'); intro HS.
         apply HS with (l := l) (s := s) (ys := ys).
         apply Forall_forall.
         intros(x1,x2) Ha.
         simpl.
         apply LE.
         rewrite Forall_forall in H.
         apply (H (x1,x2)).
         apply Ha.
         apply LE, H0.
Qed.

Definition st2soC (s1 s2: st) := paco2 (st2so) bot2 s1 s2.
(* Definition st2soCA (s1: st) (s2: so) := paco2 (st2soA) bot2 s1 s2. *)

#[export]
Declare Instance Equivalence_st2so : Equivalence st2soC.

