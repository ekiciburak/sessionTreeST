From ST Require Import stream st so si siso.
From mathcomp Require Import all_ssreflect seq.
From Paco Require Import paco.
Require Import String List.
Import ListNotations.
Require Import Setoid.
Require Import Morphisms.

Inductive nRefinement: st -> st -> Prop :=
  | n_out  : forall w w' p l s, 
             CoNInR (p,"!"%string) (act w') -> nRefinement (st_send p [(l,s,w)]) w'
  | n_inp  : forall w w' p l s, 
             CoNInR (p,"?"%string) (act w') -> nRefinement (st_receive p [(l,s,w)]) w'
  | n_out_r: forall w w' p l s, 
             CoNInR (p,"!"%string) (act w) -> nRefinement w (st_send p [(l,s,w')])
  | n_inp_r: forall w w' p l s, 
             CoNInR (p,"?"%string) (act w) -> nRefinement w (st_receive p [(l,s,w')])
  | n_inp_l: forall w w' p l l' s s',
             l <> l' -> nRefinement (st_receive p [(l,s,w)]) (st_receive p [(l',s',w')])
  | n_inp_s: forall w w' p l s s',
             nsubsort s' s -> nRefinement (st_receive p [(l,s,w)]) (st_receive p [(l,s',w')])
  | n_inp_w: forall w w' p l s s',
             subsort s' s -> nRefinement w w' -> nRefinement (st_receive p [(l,s,w)]) (st_receive p [(l,s',w')])
  | n_a_l  : forall w w' p l l' s s' a n,
             l <> l' -> nRefinement (st_receive p [(l,s,w)]) (merge_ap_contn p a (st_receive p [(l',s',w')]) n)
  | n_a_s  : forall w w' p l s s' a n,
             nsubsort s' s -> 
             nRefinement (st_receive p [(l,s,w)]) (merge_ap_contn p a (st_receive p [(l,s',w')]) n)
  | n_a_w  : forall w w' p l s s' a n,
             subsort s' s ->
             nRefinement w (merge_ap_contn p a w' n) ->
             nRefinement (st_receive p [(l,s,w)]) (merge_ap_contn p a (st_receive p [(l,s',w')]) n)
  | n_i_o_1: forall w w' p q l l' s s', nRefinement (st_receive p [(l,s,w)]) (st_send q [(l',s',w')])
  | n_i_o_2: forall w w' p q l l' s s' (a: Ap p) n, nRefinement (st_receive p [(l,s,w)]) (merge_ap_contn p a (st_send q [(l',s',w')]) n)
  | n_out_l: forall w w' p l l' s s',
             l <> l' -> nRefinement (st_send p [(l,s,w)]) (st_send p [(l',s',w')])
  | n_out_s: forall w w' p l s s',
             nsubsort s' s -> nRefinement (st_send p [(l,s,w)]) (st_send p [(l,s',w')])
  | n_out_w: forall w w' p l s s',
             subsort s s' -> nRefinement w w' -> nRefinement (st_send p [(l,s,w)]) (st_send p [(l,s',w')])
  | n_b_l  : forall w w' p l l' s s' b n,
             l <> l' -> nRefinement (st_send p [(l,s,w)]) (merge_bp_contn p b (st_send p [(l',s',w')]) n)
  | n_b_s  : forall w w' p l s s' b n,
             nsubsort s s' -> 
             nRefinement (st_send p [(l,s,w)]) (merge_bp_contn p b (st_send p [(l,s',w')]) n)
  | n_b_w  : forall w w' p l s s' b n,
             subsort s s' ->
             nRefinement w (merge_bp_contn p b w' n) ->
             nRefinement (st_receive p [(l,s,w)]) (merge_bp_contn p b (st_send p [(l,s',w')]) n).

Notation "x '/~<' y" := (nRefinement x y) (at level 50, left associativity).

Lemma eq1a: forall n p q l l' s s' a w w',
  merge_ap_contn p a (p ! [(l,s,w)]) n = q ! [(l',s',w')] -> p = q.
Proof. intro n.
       induction n; intros.
       simpl in H. inversion H. easy.
       case_eq a; intros.
       subst.
       rewrite(siso_eq(merge_ap_contn p (ap_receive q0 n0 s0 s1) (p ! [(l, s, w)]) n.+1)) in H.
       simpl in H. easy.
       subst.
       rewrite(siso_eq(merge_ap_contn p (ap_merge q0 n0 s0 s1 a0) (p ! [(l, s, w)]) n.+1)) in H.
       simpl in H. easy.
       subst.
       rewrite(siso_eq(merge_ap_contn p ap_end (p ! [(l, s, w)]) n.+1)) in H.
       simpl in H. easy.
Qed.

Definition eqbp (a b: (participant*string)) :=
  andb (eqb a.1 b.1) (eqb a.2 b.2).

Lemma eq0: forall l (a: (participant*string)) xs, List.In a l \/ CoInR a xs ->
           CoInR a (appendL l xs).
Proof. intros l.
       induction l; intros.
       destruct H. easy.
       rewrite anl2. easy.
       destruct H.

       inversion H.
       subst.
       rewrite(coseq_eq(appendL (a0 :: l) xs)).
       unfold coseq_id. simpl.
       specialize(CoInSplit1 a0
       (Delay(cocons a0 (appendL l xs)))
       a0
       (appendL l xs)
       ); intro Ha.
       apply Ha. simpl. easy. easy.

       case_eq(eqbp a0 a); intros.
       unfold eqbp in H1.
       rewrite(coseq_eq(appendL (a :: l) xs)).
       unfold coseq_id. simpl.
       specialize(CoInSplit1 a0
       (Delay(cocons a (appendL l xs)))
       a0
       (appendL l xs)
       ); intro Ha.
       apply Ha. simpl.
       destruct a, a0.
       rewrite Bool.andb_true_iff in H1.
       destruct H1.
       rewrite eqb_eq in H1.
       rewrite eqb_eq in H2.
       inversion H1. inversion H2.
       simpl in *. subst.
       easy. easy.

       unfold eqbp in H1.
       rewrite Bool.andb_false_iff in H1.
       destruct H1.
       rewrite(coseq_eq(appendL (a :: l) xs)).
       unfold coseq_id. simpl.
       specialize(CoInSplit2 a0
       (Delay(cocons a (appendL l xs)))
       a
       (appendL l xs)
       ); intro Ha.
       apply Ha. simpl. easy. 
       rewrite eqb_neq in H1.
       unfold not in *.
       intro H2.
       apply H1.
       destruct a, a0. simpl in *.
       inversion H2. easy.
       apply IHl. left. easy.

       rewrite(coseq_eq(appendL (a :: l) xs)).
       unfold coseq_id. simpl.
       specialize(CoInSplit2 a0
       (Delay(cocons a (appendL l xs)))
       a
       (appendL l xs)
       ); intro Ha.
       apply Ha. simpl. easy. 
       rewrite eqb_neq in H1.
       unfold not in *.
       intro H2.
       apply H1.
       destruct a, a0. simpl in *.
       inversion H2. easy.
       apply IHl. left. easy.

       case_eq(eqbp a0 a); intros.
       unfold eqbp in H0.
       rewrite(coseq_eq(appendL (a :: l) xs)).
       unfold coseq_id. simpl.
       specialize(CoInSplit1 a0
       (Delay(cocons a (appendL l xs)))
       a0
       (appendL l xs)
       ); intro Ha.
       apply Ha. simpl.
       destruct a, a0.
       rewrite Bool.andb_true_iff in H0.
       destruct H0.
       rewrite eqb_eq in H0.
       rewrite eqb_eq in H1.
       inversion H0. inversion H1.
       simpl in *. subst.
       easy. easy.

       unfold eqbp in H0.
       rewrite Bool.andb_false_iff in H0.
       destruct H0.
       rewrite(coseq_eq(appendL (a :: l) xs)).
       unfold coseq_id. simpl.
       specialize(CoInSplit2 a0
       (Delay(cocons a (appendL l xs)))
       a
       (appendL l xs)
       ); intro Ha.
       apply Ha. simpl. easy. 
       rewrite eqb_neq in H0.
       unfold not in *.
       intro H1.
       apply H0.
       destruct a, a0. simpl in *.
       inversion H1. easy.
       apply IHl. right. easy.

       rewrite(coseq_eq(appendL (a :: l) xs)).
       unfold coseq_id. simpl.
       specialize(CoInSplit2 a0
       (Delay(cocons a (appendL l xs)))
       a
       (appendL l xs)
       ); intro Ha.
       apply Ha. simpl. easy. 
       rewrite eqb_neq in H0.
       unfold not in *.
       intro H1.
       apply H0.
       destruct a, a0. simpl in *.
       inversion H1. easy.
       apply IHl. right. easy.
Qed.

Lemma eq1b: forall n p b l s w,
CoInR (p, "!"%string) (act (merge_bp_contn p b (p ! [(l, s, w)]) n)).
Proof. intros. rewrite h0.
       apply eq0.
       right.
       rewrite(coseq_eq(act (p ! [(l, s, w)]))).
       unfold coseq_id. simpl.
       specialize(CoInSplit1 (p, "!"%string)
       (Delay(cocons (p, "!"%string) (act w)))
       (p, "!"%string)
       (act w)
       ); intro Ha.
       apply Ha. simpl. easy. easy.
Qed.

Lemma neq1a: forall n p q l l' s s' a w w',
  merge_ap_contn p a (p & [(l,s,w)]) n = q ! [(l',s',w')] -> False.
Proof. intro n.
       induction n; intros.
       simpl in H. inversion H.
       apply (IHn p q l l' s s' a w w').
       subst.
       induction a; intros.
       rewrite(siso_eq( merge_ap_contn p (ap_receive q0 n0 s0 s1) (p & [(l, s, w)]) n.+1)) in H.
       simpl in H. easy.
       rewrite(siso_eq(merge_ap_contn p (ap_merge q0 n0 s0 s1 a) (p & [(l, s, w)]) n.+1)) in H.
       simpl in H. easy.
       rewrite(siso_eq(merge_ap_contn p ap_end (p & [(l, s, w)]) n.+1)) in H.
       simpl in H. easy.
Qed.

Lemma act_rec: forall n p b l s s0 s1 s2 w,
(act (merge_bp_contn p (bp_mergea s s0 s1 b) (p ! [(l, s2, w)]) (n.+1)))
=
Delay (cocons (s, "?"%string) (act (merge_bp_cont p b (merge_bp_contn p (bp_mergea s s0 s1 b) (p ! [(l, s2, w)]) n)))).
Proof. intro n.
       induction n; intros.
       simpl.
       rewrite(coseq_eq(act (merge_bp_cont p (bp_mergea s s0 s1 b) (p ! [(l, s2, w)])))).
       unfold coseq_id. simpl. easy.
       simpl.
       rewrite(coseq_eq(act (merge_bp_cont p (bp_mergea s s0 s1 b) (merge_bp_cont p (bp_mergea s s0 s1 b) (merge_bp_contn p (bp_mergea s s0 s1 b) (p ! [(l, s2, w)]) n))))).
       unfold coseq_id. simpl.
       simpl in IHn.
       easy.
Qed.

Lemma nrefL: forall w w',  w ~< w' -> (w /~< w' -> False).
Proof. intros w w' H.
       unfold refinement in H.
       punfold H; [ | apply refinementR_mon].
       intro Ha.
       induction Ha; intros.
       { inversion H.
         subst.
         apply inOutL in H0. easy.
         rewrite(coseq_eq(act (p ! [(l, s', w'0)]))).
         specialize(CoInSplit1 (p, "!"%string)
         (Delay(cocons (p, "!"%string) (act w'0)))
         (p, "!"%string) 
         (act w'0)
         ); intro Hb.
         apply Hb. simpl. easy. easy.
         apply inOutL in H0. easy.
         rewrite <- H4.
         rewrite h0.
         apply eq0.
         right.
         rewrite(coseq_eq(act (p ! [(l, s', w'0)]))).
         unfold coseq_id. simpl.
         specialize(CoInSplit1 (p, "!"%string)
         (Delay(cocons (p, "!"%string) (act w'0)))
         (p, "!"%string) 
         (act w'0)
         ); intro Ha.
         apply Ha. simpl. easy. easy.
       }
       { inversion H.
         subst.
         apply inOutL in H0. easy.
         rewrite(coseq_eq(act (p & [(l, s', w'0)]))).
         specialize(CoInSplit1 (p, "?"%string)
         (Delay(cocons (p, "?"%string) (act w'0)))
         (p, "?"%string) 
         (act w'0)
         ); intro Hb.
         apply Hb. simpl. easy. easy.
         subst.
         apply inOutL in H0. easy.
         simpl.
         admit.
       }
       { inversion H.
         subst.
         apply inOutL in H0. easy.
         rewrite(coseq_eq(act (p ! [(l, s0, w0)]))).
         unfold coseq_id. simpl.
         specialize(CoInSplit1 (p, "!"%string)
         (Delay(cocons (p, "!"%string) (act w0)))
         (p, "!"%string) 
         (act w0)
         ); intro Hb.
         apply Hb. simpl. easy. easy.
         apply neq1a in H1. easy.

         apply inOutL in H0. easy.
         rewrite <- H4.
         admit.
       }
       
Admitted.
