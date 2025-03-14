From mathcomp Require Import all_ssreflect.
From Paco Require Import paco.
Require Import ST.src.stream ST.processes.process ST.types.local.
Require Import String List.
Local Open Scope string_scope.
Import ListNotations.

(* session trees *)
CoInductive st: Type :=
  | st_end    : st
  | st_receive: participant -> list (label*sort*st) -> st
  | st_send   : participant -> list (label*sort*st) -> st.

Inductive st_equiv (R: st -> st -> Prop): st -> st -> Prop :=
  | eq_st_end: st_equiv R st_end st_end
  | eq_st_rcv: forall p l s xs ys,
               List.Forall (fun u => R (fst u) (snd u)) (zip xs ys) ->
               st_equiv R (st_receive p (zip (zip l s) xs)) (st_receive p (zip (zip l s) ys))
  | eq_st_snd: forall p l s xs ys,
               List.Forall (fun u => R (fst u) (snd u)) (zip xs ys) ->
               st_equiv R (st_send p (zip (zip l s) xs)) (st_send p (zip (zip l s) ys)).

Definition st_equivC: st -> st -> Prop := fun s1 s2 => paco2 st_equiv bot2 s1 s2.

Notation "p '&' l" := (st_receive p l) (at level 50, left associativity).
Notation "p '!' l" := (st_send p l) (at level 50, left associativity).
Notation "'B'" :=  sbool (at level 50, left associativity).
Notation "'()'" :=  sunit (at level 50, left associativity).
Notation "'I'" :=  sint (at level 50, left associativity). 
Notation "'N'" :=  snat (at level 50, left associativity).
Notation "'end'" :=  st_end (at level 50, left associativity).

Definition st_id (s: st): st :=
  match s with
    | st_end         => st_end
    | st_receive p l => st_receive p l
    | st_send p l    => st_send p l
  end.

Lemma st_eq: forall s, s = st_id s.
Proof. intro s; destruct s; easy. Defined.

Inductive lt2st (R: local -> st -> Prop): local -> st -> Prop :=
  | lt2st_end: lt2st R lt_end st_end
  | lt2st_rcv: forall p l s xs ys,
               length xs = length ys ->
               List.Forall (fun u => R (fst u) (snd u)) (zip xs ys) ->
               lt2st R (lt_receive p (zip (zip l s) xs)) (st_receive p (zip (zip l s) ys))
  | lt2st_snd: forall p l s xs ys,
               length xs = length ys ->
               List.Forall (fun u => R (fst u) (snd u)) (zip xs ys) ->
               lt2st R (lt_send p (zip (zip l s) xs)) (st_send p (zip (zip l s) ys))
  | lt2st_mu : forall l t,
               lt2st R (unfold_muL (lt_mu l)) t ->
               lt2st R (lt_mu l) t.

Definition lt2stC l t := paco2 lt2st bot2 l t.

Lemma lt2st_mon: monotone2 lt2st.
Proof. unfold monotone2.
       intros.
       induction IN; intros.
       - apply lt2st_end.
       - specialize (lt2st_rcv r'); intro HS.
         apply HS with (l := l) (s := s). easy.
         apply Forall_forall.
         intros (lt,st) H1. simpl in H1. simpl.
         rewrite Forall_forall in H0. simpl in H0.
         specialize (H0 (lt,st)). simpl in H0.
         apply LE, H0. exact H1.
       - specialize (lt2st_snd r'); intro HS.
         apply HS with (l := l) (s := s). easy.
         apply Forall_forall.
         intros (lt,st) H1. simpl in H1. simpl.
         rewrite Forall_forall in H0. simpl in H0.
         specialize (H0 (lt,st)). simpl in H0.
         apply LE, H0. exact H1.
       - apply lt2st_mu. exact IHIN.
Qed.

(*
Check lt_send.
Check lt_var 0.

Let lr := lt_mu (lt_send "p" [("l",sint,(lt_var 0))] ).
Let lr2 := Eval simpl in unfold_muL lr.
Eval simpl in unfold_muL lr2.
Print lr.
Print lr2.  *)

Definition sort_eqb (s1 s2: local.sort): bool :=
  match (s1,s2) with
    | (sunit, sunit) => true
    | (sbool, sbool) => true
    | (sint, sint)   => true
    | (snat, snat)   => true
    | _              => false
  end.

Fixpoint pathsel (u: label) (v: local.sort) (l: list (label*local.sort*st)): st :=
  match l with
    | (lbl,s,x)::xs => if andb (eqb u lbl) (sort_eqb v s) then x else pathsel u v xs
    | nil           => st_end
  end.


