Require Import ST.src.stream ST.src.st ST.src.so ST.src.si 
               ST.src.reordering ST.src.siso 
               ST.subtyping.refinement ST.src.reorderingfacts.
From mathcomp Require Import all_ssreflect seq.
From Paco Require Import paco.
Require Import String List.
Import ListNotations.
Require Import Setoid.
Require Import Morphisms.
Require Import Coq.Logic.Classical_Pred_Type Coq.Logic.ClassicalFacts Coq.Logic.Classical_Prop.

(* Require dpdgraph.dpdgraph. *)

Lemma act_eq_neq: forall w w', (act_eq w w' -> False) -> act_neq w w'.
Proof. intros.
       unfold act_eq, act_neq in *.
       apply not_all_ex_not in H.
       destruct H as (a, H).
       exists a.
       unfold iff in H.
       apply not_and_or in H.
       destruct H as [H | H].
       apply imply_to_and in H.
       left. easy.
       apply imply_to_and in H.
       right. easy.
Qed.

Lemma actNeq: forall w1 w2, act_neq w1 w2 -> w1 ~< w2 -> False.
Proof. intros.
       unfold act_neq in H.
       destruct H as ((q,ac), [ (Ha, Hb) | (Ha, Hb)]).
       - case_eq ac; intros.
         + subst. apply Hb.
           punfold H0. inversion H0.
           subst. apply mem_ext in H2.
           case_eq (eqb p q); intros.
           ++ rewrite eqb_eq in H3. subst.
              rewrite h1. apply eq0. right. 
              rewrite(coseq_eq(act (q & [(l, s', w')]))). unfold coseq_id.
              simpl.
              apply CoInSplit1 with (y := (q, rcv)) (ys:= (act w')).
              simpl. easy. easy.
           ++ rewrite eqb_neq in H3.
              unfold act_eq in H2.
              rewrite(coseq_eq(act (p & [(l, s, w)]))) in Ha.
              unfold coseq_id in Ha. simpl in Ha.
              inversion Ha. subst. simpl in H4. inversion H4.
              subst. easy.
              subst. simpl in H4. inversion H4. subst.
              apply H2 in H6.
              rewrite h1 in H6.
              rewrite h1.
              apply eq0.
              apply dsanew in H6.
              destruct H6 as [H6 | H6].
              * left. easy.
              * right.
                rewrite(coseq_eq(act (p & [(l, s', w')]))). unfold coseq_id.
                simpl. 
                apply CoInSplit2 with (y := (p, rcv)) (ys:= (act w')). simpl. easy. easy. easy.
         + subst. apply mem_ext in H2.
           rewrite h0. apply eq0.
           rewrite(coseq_eq(act (p ! [(l, s, w)]))) in Ha. unfold coseq_id in Ha.
           simpl in Ha. inversion Ha.
           subst. easy.
           subst.
           simpl in H3. inversion H3. subst.
           unfold act_eq in H2.
           apply H2 in H5.
           rewrite h0 in H5. apply dsanew in H5.
           destruct H5 as [H5 | H5].
           left. easy.
           right.
           apply CoInSplit2 with (y := (p, snd)) (ys:= (act w')). simpl. easy. easy. easy.
         + subst. rewrite(coseq_eq(act (end))) in Ha.
           unfold coseq_id in Ha. simpl in Ha.
           inversion Ha. subst. easy. subst. easy.
           apply refinementR_mon.
       - subst. apply Hb.
         punfold H0. inversion H0.
         subst. apply mem_ext in H2.
         rewrite(coseq_eq(act (p & [(l, s, w)]))) in Ha.
         unfold coseq_id in Ha. simpl in Ha. 
         inversion Ha. subst. simpl in H3. easy.
         subst. simpl in H3. inversion H3. subst.
         apply H2 in H5.
         rewrite h1 in H5.
         apply dsbnew in H5.
         rewrite h1.
         apply eq0.
         destruct H5 as [H5 | H5].
         left. easy.
         right.
         apply CoInSplit2 with (y := (p, rcv)) (ys:= (act w')). simpl. easy. easy. easy.
         subst. apply mem_ext in H2.
         case_eq (eqb p q); intros.
         ++ rewrite eqb_eq in H3. subst.
            rewrite h0. apply eq0. right.
            rewrite(coseq_eq(act (q ! [(l, s', w')]))). unfold coseq_id. simpl.
            apply CoInSplit1 with (y := (q, snd)) (ys:= (act w')). easy. easy.
         ++ rewrite eqb_neq in H3.
            unfold act_eq in H2.
            rewrite(coseq_eq(act (p ! [(l, s, w)]))) in Ha.
            unfold coseq_id in Ha. simpl in Ha.
            inversion Ha. subst. simpl in H4. inversion H4.
            subst. easy.
            subst. simpl in H4. inversion H4. subst.
            apply H2 in H6.
            rewrite h0 in H6.
            rewrite h0.
            apply eq0.
            apply dsbnew in H6.
            destruct H6 as [H6 | H6].
            left. easy.
            right.
            rewrite(coseq_eq(act (p ! [(l, s', w')]))). unfold coseq_id. simpl.
            apply CoInSplit2 with (y := (p, snd)) (ys:= (act w')). simpl. easy. easy. easy.
         ++ subst. rewrite(coseq_eq(act (end))) in Ha.
             unfold coseq_id in Ha. simpl in Ha.
             inversion Ha. subst. easy. subst. easy.
             apply refinementR_mon.

       - case_eq ac; intros.
         + subst. apply Hb.
           punfold H0. inversion H0.
           subst. apply mem_ext in H2.
           case_eq (eqb p q); intros.
           ++ rewrite eqb_eq in H3. subst.
              rewrite(coseq_eq(act (q & [(l, s, w)]))). unfold coseq_id. simpl.
              apply CoInSplit1 with (y := (q, rcv)) (ys:= (act w)). easy. easy.
           ++ rewrite eqb_neq in H3.
              unfold act_eq in H2.
              rewrite h1 in Ha.
              apply dsanew in Ha.
              assert(In (q, rcv) (actAn p a n) \/ coseqIn (q, rcv) (act w')).
              { destruct Ha. left. easy.
                right.
                inversion H4. subst. simpl in H5.
                inversion H5. subst. easy.
                inversion H5.
                subst. easy.
              }
              apply eq0Anew in H4.
              rewrite h1 in H2.
              apply H2 in H4.
              rewrite(coseq_eq(act (p & [(l, s, w)]))). unfold coseq_id. simpl.
              apply CoInSplit2 with (y := (p, rcv)) (ys:= (act w)). simpl. easy.
              unfold not. intro Hx. apply H3.
              inversion Hx. easy. easy.
              subst.
              unfold act_eq in H2.
              apply mem_ext in H2.
              rewrite h0 in Ha.
              apply dsanew in Ha.
              assert(In (q, rcv) (actBn p b n) \/ coseqIn (q, rcv) (act w')).
              { destruct Ha. left. easy.
                right.
                inversion H3. subst. simpl in H4. easy.
                subst. simpl in H4. inversion H4. subst. easy.
              }
              apply eq0Anew in H3.
              unfold act_eq in H2.
              rewrite h0 in H2.
              apply H2 in H3.
              rewrite(coseq_eq(act (p ! [(l, s, w)]))). unfold coseq_id. simpl.
              apply CoInSplit2 with (y := (p, snd)) (ys:= (act w)). simpl. easy. easy. easy.
              subst. rewrite(coseq_eq(act (end))) in Ha.
              unfold coseq_id in Ha. simpl in Ha.
              inversion Ha. subst. easy. subst. easy.
              apply refinementR_mon.
         + subst.
           apply Hb.
           punfold H0. inversion H0.
           subst. apply mem_ext in H2.
           unfold act_eq in H2.
           rewrite h1 in H2.
           rewrite h1 in Ha.
           apply dsbnew in Ha.
           assert(In (q, snd) (actAn p a n) \/ coseqIn (q, snd) (act w')).
           { destruct Ha. left. easy.
             right.
                inversion H3. subst. simpl in H4. easy.
                subst. simpl in H4. inversion H4. subst. easy.
           }
           apply eq0Anew in H3.
           apply H2 in H3.
           rewrite(coseq_eq(act (p & [(l, s, w)]))). unfold coseq_id. simpl.
           apply CoInSplit2 with (y := (p, rcv)) (ys:= (act w)). simpl. easy. easy. easy.
         + subst.
         case_eq (eqb p q); intros.
         ++ rewrite eqb_eq in H3. subst.
            rewrite(coseq_eq(act (q ! [(l, s, w)]))). unfold coseq_id. simpl.
            apply CoInSplit1 with (y := (q, snd)) (ys:= (act w)). simpl. easy. easy.
         ++ rewrite eqb_neq in H3.
            unfold act_eq in H2.
            apply mem_ext in H2.
            rewrite h0 in Ha.
            apply dsbnew in Ha.
            assert(In (q, snd) (actBn p b n) \/ coseqIn (q, snd) (act w')).
            { destruct Ha.
              left. easy.
              right.
                inversion H4. subst. simpl in H5.
                inversion H5. subst. easy.
                inversion H5.
                subst. easy.
            }
            apply eq0Anew in H4.
            unfold act_eq in H2.
            rewrite h0 in H2.
            apply H2 in H4.
            rewrite(coseq_eq(act (p ! [(l, s, w)]))). unfold coseq_id. simpl.
            apply CoInSplit2 with (y := (p, snd)) (ys:= (act w)). simpl. easy.
            intro Hx. apply H3. inversion Hx. easy. easy.
            subst. rewrite(coseq_eq(act (end))) in Ha.
            unfold coseq_id in Ha. simpl in Ha.
            inversion Ha. subst. easy. subst. easy.
            apply refinementR_mon.
Qed.

Inductive nRefinementN: siso -> siso -> Prop :=
  | n_outN  : forall w w' p b l s P, 
              (coseqIn (p,snd) (act (@und w')) -> False) -> 
              nRefinementN (mk_siso (merge_bp_cont p b (st_send p [(l,s,(@und w))])) P) w'
   | n_inpN  : forall w w' p c l s P, 
              (coseqIn (p,rcv) (act (@und w')) -> False) -> 
              nRefinementN (mk_siso (merge_cp_cont p c (st_receive p [(l,s,(@und w))])) P) w'
  | n_out_rN: forall w w' p b l s P, 
              (coseqIn (p,snd) (act (@und w)) -> False) -> 
              nRefinementN w (mk_siso (merge_bp_cont p b (st_send p [(l,s,(@und w'))])) P)
  | n_inp_rN: forall w w' p c l s P,
              (coseqIn (p,rcv) (act (@und w)) -> False) -> 
              nRefinementN w (mk_siso (merge_cp_cont p c (st_receive p [(l,s,(@und w'))])) P)
  | n_a_lN  : forall w w' p l l' s s' a n P Q,
              l <> l' -> nRefinementN (mk_siso (st_receive p [(l,s,(@und w))]) P) 
                                      (mk_siso (merge_ap_contn p a (st_receive p [(l',s',(@und w'))]) n) Q)
  | n_a_sN  : forall w w' p l s s' a n P Q,
              nsubsort s' s -> 
              nRefinementN (mk_siso (st_receive p [(l,s,(@und w))]) P) 
                           (mk_siso (merge_ap_contn p a (st_receive p [(l,s',(@und w'))]) n) Q)
  | n_a_wN  : forall w w' p l s s' a n P Q R,
              subsort s' s ->
              nRefinementN w (mk_siso (merge_ap_contn p a (@und w') n) P) ->
              nRefinementN (mk_siso (st_receive p [(l,s,(@und w))]) Q) 
                           (mk_siso (merge_ap_contn p a (st_receive p [(l,s',(@und w'))]) n) R)
  | n_i_o_1N: forall w w' p q l l' s s' P Q, nRefinementN (mk_siso (st_receive p [(l,s,(@und w))]) P) 
                                                          (mk_siso (st_send q [(l',s',(@und w'))]) Q)
  | n_i_o_2N: forall w w' p l l' s s' c P Q, isInCp p c = true ->
                                             nRefinementN (mk_siso (st_receive p [(l,s,(@und w))]) P) 
                                                          (mk_siso (merge_cp_cont p c (st_receive p [(l',s',(@und w'))])) Q)
  | n_b_lN  : forall w w' p l l' s s' b n P Q,
              l <> l' -> nRefinementN (mk_siso (st_send p [(l,s,(@und w))]) P) 
                                      (mk_siso (merge_bp_contn p b (st_send p [(l',s',(@und w'))]) n) Q)
  | n_b_sN  : forall w w' p l s s' b n P Q,
              nsubsort s s' -> 
              nRefinementN (mk_siso (st_send p [(l,s,(@und w))]) P) 
                           (mk_siso (merge_bp_contn p b (st_send p [(l,s',(@und w'))]) n) Q)
  | n_b_wN  : forall w w' p l s s' b n P Q R,
              subsort s s' ->
              nRefinementN w (mk_siso (merge_bp_contn p b (@und w') n) P) ->
              nRefinementN (mk_siso (st_send p [(l,s,(@und w))]) Q) 
                           (mk_siso (merge_bp_contn p b (st_send p [(l,s',(@und w'))]) n) R).

Lemma n_inp_lN: forall w w' p l l' s s' P Q,
                l <> l' -> nRefinementN (mk_siso (st_receive p [(l,s,(@und w))]) P) 
                (mk_siso (st_receive p [(l',s',(@und w'))]) Q).
Proof. intros.
       specialize(n_a_lN w w' p l l' s s' (ap_end) 1); intros Hnal.
       simpl in Hnal.
       rewrite apend_an in Hnal.
       apply Hnal.
       easy.
Qed.

Lemma n_inp_sN: forall w w' p l s s' P Q,
                nsubsort s' s -> nRefinementN (mk_siso (st_receive p [(l,s,(@und w))]) P)
                                              (mk_siso (st_receive p [(l,s',(@und w'))]) Q).
Proof. intros.
       specialize(n_a_sN w w' p l s s' (ap_end) 1); intros Hnas.
       simpl in Hnas.
       rewrite apend_an in Hnas.
       apply Hnas.
       easy.
Qed.

Lemma n_inp_wN: forall w w' p l s s' P Q,
                subsort s' s -> nRefinementN w w' -> nRefinementN (mk_siso (st_receive p [(l,s,(@und w))]) P) 
                                                                  (mk_siso (st_receive p [(l,s',(@und w'))]) Q).
Proof. intros.
       specialize(n_a_wN w w' p l s s' (ap_end) 1); intros Hnaw.
       simpl in Hnaw.
       rewrite apend_an in Hnaw.
       rewrite apend_an in Hnaw.
       destruct w'.
       apply Hnaw with (P := sprop).
       easy. easy.
Qed.

Lemma n_out_lN: forall w w' p l l' s s' P Q,
                l <> l' -> nRefinementN (mk_siso (st_send p [(l,s,(@und w))]) P) 
                                        (mk_siso (st_send p [(l',s',(@und w'))]) Q).
Proof. intros.
       specialize(n_b_lN w w' p l l' s s' (bp_end) 1); intros Hnbl.
       simpl in Hnbl.
       rewrite bpend_an in Hnbl.
       apply Hnbl.
       easy.
Qed.

Lemma n_out_sN: forall w w' p l s s' P Q,
                nsubsort s s' -> nRefinementN (mk_siso (st_send p [(l,s,(@und w))]) P) 
                                              (mk_siso (st_send p [(l,s',(@und w'))]) Q).
Proof. intros.
       specialize(n_b_sN w w' p l s s' (bp_end) 1); intros Hnbs.
       simpl in Hnbs.
       rewrite bpend_an in Hnbs.
       apply Hnbs.
       easy.
Qed.

Lemma n_out_wN: forall w w' p l s s' P Q,
                subsort s s' -> nRefinementN w w' -> nRefinementN (mk_siso (st_send p [(l,s,(@und w))]) P) 
                                                                 (mk_siso (st_send p [(l,s',(@und w'))]) Q).
Proof. intros.
       specialize(n_b_wN w w' p l s s' (bp_end) 1); intros Hnbw.
       simpl in Hnbw.
       rewrite bpend_an in Hnbw.
       rewrite bpend_an in Hnbw.
       destruct w'.
       apply Hnbw with (P := sprop).
       easy. easy.
Qed.

Lemma nRefL: forall w w',  (@und w) ~< (@und w') -> (nRefinementN w w' -> False).
Proof. intros w w' H.
       unfold refinement in H.
       punfold H; [ | apply refinementR_mon].
       intro Ha.
       induction Ha; intros.
       {
         inversion H.
         subst. apply H0.
         rewrite <- H2. 
         apply helperBpsnew in H1.
         apply mem_ext in H5.
         unfold act_eq in H5.
         specialize(H5(p,snd)).
         destruct H5 as (H5a,H5b).
         apply H5a in H1.
         rewrite <- mergeeq.
         rewrite hm1a.
         apply eq0Anew.

         rewrite <- mergeeq in H1.
         apply bsd2new in H1.
         right.
         rewrite(coseq_eq(act (p0 & [(l0, s', w'0)]))). unfold coseq_id.
         simpl.
         apply CoInSplit2 with (y := (p0, rcv)) (ys :=(act (w'0))). simpl. easy. easy.
         easy.

         apply H0.
         rewrite <- H2. 
         case_eq(eqb p0 p); intros.
         rewrite eqb_eq in H6. subst.
         rewrite <- mergeeq3.
         rewrite hm1.
         apply eq0Anew.
         right.
         rewrite(coseq_eq(act (p ! [(l0, s', w'0)]))). unfold coseq_id. simpl.
         apply CoInSplit1 with (y := (p, snd)) (ys :=(act (w'0))). simpl. easy. easy.

         rewrite eqb_neq in H6.
         apply bsd3new in H1.
         apply mem_ext in H5.
         unfold act_eq in H5.
         specialize(H5(p,snd)).
         destruct H5 as (H5a,H5b).
         rewrite <- mergeeq3.
         rewrite hm1.
         apply eq0Anew.

         assert(coseqIn (p, snd) (act w0)).
         { easy. }
         apply H5a in H5.

         rewrite <- mergeeq3 in H5.
         rewrite hm1 in H5.
         apply dsbnew in H5.
         destruct H5.
         left. easy.
         right.
         rewrite(coseq_eq(act (p0 ! [(l0, s', w'0)]))). unfold coseq_id. simpl.
         apply CoInSplit2 with (y := (p0, snd)) (ys :=(act (w'0))). simpl. easy.
         intro Hb. apply H6. inversion Hb. easy. easy. easy.

         case_eq b; intros.
         subst.
         rewrite(st_eq(merge_bp_cont p (bp_receivea s0 s1 s2) (p ! [(l, s, und)]))) in H2.
         simpl in H2. easy.
         subst.
         rewrite(st_eq(merge_bp_cont p (bp_send q n s0 s1) (p ! [(l, s, und)]))) in H2.
         simpl in H2. easy.
         subst.
         rewrite(st_eq(merge_bp_cont p (bp_mergea s0 s1 s2 b0) (p ! [(l, s, und)]))) in H2.
         simpl in H2. easy.
         subst.
         rewrite(st_eq(merge_bp_cont p (bp_merge q n s0 s1 b0) (p ! [(l, s, und)]))) in H2.
         simpl in H2. easy.
         subst.
         rewrite bpend_an in H2. easy.
       }
       { inversion H.
         subst.
         apply H0.
         rewrite <- H2.
         case_eq(eqb p p0); intros.
         rewrite eqb_eq in H6. subst.
         rewrite h1.
         apply eq0Anew.
         right.

         rewrite(coseq_eq((act (p0 & [(l0, s', w'0)])))).
         unfold coseq_id. simpl.
         apply CoInSplit1 with (y := (p0, rcv)) (ys := (act w'0)). easy. easy.

         rewrite eqb_neq in H6.
         apply mem_ext in H5.
         unfold act_eq in H5.
         specialize(H5(p,rcv)).
         destruct H5 as (H5a, H5b).
         rewrite h1.
         apply eq0Anew.
         rewrite <- mergeeq in H5a.
         apply helperCpnew in H1.
         apply H5a in H1.
         apply asdnew in H1.
         destruct H1.
         left. easy.

         right.
         rewrite(coseq_eq((act (p0 & [(l0, s', w'0)])))).
         unfold coseq_id. simpl.
         apply CoInSplit2 with (y := (p0, rcv)) (ys := (act w'0)). simpl. easy.
         unfold not. intro Hn.
         apply H6. inversion Hn. easy. easy. easy.

         apply H0.
         rewrite <- H2.
         apply helperCp2new in H1.
         apply mem_ext in H5.
         unfold act_eq in H5.
         specialize(H5(p,rcv)).
         destruct H5 as (H5a, H5b).
         apply H5a in H1.
         rewrite <- mergeeq3 in H1.
         apply bsdnew in H1.
         destruct H1.
         rewrite h0.
         apply eq0Anew.
         left. easy.
         rewrite h0.
         apply eq0Anew.
         right.
         rewrite(coseq_eq((act (p0 ! [(l0, s', w'0)])))).
         unfold coseq_id. simpl.
         apply CoInSplit2 with (y := (p0, snd)) (ys := (act w'0)). easy. easy.
         easy.

         destruct c. 
         rewrite(st_eq(merge_cp_cont p (cp_receive q n s0 s1) (p & [(l, s, und)]))) in H2.
         simpl in H2. easy.
         rewrite(st_eq(merge_cp_cont p (cp_mergea q n s0 s1 c) (p & [(l, s, und)]))) in H2.
         subst. easy.
         rewrite(st_eq( merge_cp_cont p (cp_send s0 s1 s2) (p & [(l, s, und)]))) in H2.
         simpl in H2. easy.
         rewrite(st_eq(merge_cp_cont p (cp_merge s0 s1 s2 c) (p & [(l, s, und)]))) in H2.
         simpl in H2. easy.
         rewrite cpend_an in H2. easy. 
       }
       { inversion H.
         subst.
         apply H0. rewrite <- H1.
         rewrite <- mergeeq2 in H2.
         apply helperApBpnew in H2.
         apply mem_ext in H5.
         unfold act_eq in H5.
         specialize(H5(p,snd)).
         rewrite <- mergeeq2 in H5.
         apply H5 in H2.
         rewrite(coseq_eq(act (p0 & [(l0, s0, w0)]))). unfold coseq_id. simpl.
         apply CoInSplit2 with (y := (p0, rcv)) (ys := (act w0)). simpl. easy. easy.
         easy.

         apply H0. rewrite <- H1.
         case_eq(eqb p p0); intros.
         rewrite eqb_eq in H6.
         subst.
         rewrite(coseq_eq(act (p0 ! [(l0, s0, w0)]))). unfold coseq_id. simpl.
         apply CoInSplit1 with (y := (p0, snd)) (ys := (act w0)). simpl. easy. easy.
         rewrite eqb_neq in H6.
         rewrite <- mergeeq3 in H2.
         apply helperBpBpnew in H2.
         apply mem_ext in H5.
         unfold act_eq in H5.
         specialize(H5(p,snd)).
         rewrite <- mergeeq3 in H5.
         rewrite(coseq_eq(act (p0 ! [(l0, s0, w0)]))). unfold coseq_id. simpl.
         apply CoInSplit2 with (y := (p0, snd)) (ys := (act w0)). simpl. easy.
         intro Hb. apply H6. inversion Hb. easy.
         apply H5. easy. easy.

         destruct b.
         subst. rewrite(st_eq(merge_bp_cont p (bp_receivea s0 s1 s2) (p ! [(l, s, und)]))) in H3.
         simpl in H3. easy.
         subst. rewrite(st_eq(merge_bp_cont p (bp_send q n s0 s1) (p ! [(l, s, und)]))) in H3.
         simpl in H3. easy.
         subst. rewrite(st_eq(merge_bp_cont p (bp_mergea s0 s1 s2 b) (p ! [(l, s, und)]))) in H3.
         simpl in H3. easy.
         subst. rewrite(st_eq(merge_bp_cont p (bp_merge q n s0 s1 b) (p ! [(l, s, und)]))) in H3.
         simpl in H3. easy.
         subst. rewrite(st_eq(merge_bp_cont p bp_end (p ! [(l, s, und)]))) in H3.
         simpl in H3. easy.
       }
       { inversion H.
         subst.
         apply H0. rewrite <- H1.
         apply mem_ext in H5.
         unfold act_eq in H5.
         rewrite <- H1 in H0.
         case_eq(eqb p p0); intro Heq.

         rewrite(coseq_eq(act (p0 & [(l0, s0, w0)]))). unfold coseq_id. simpl.
         rewrite eqb_eq in Heq. subst.
         apply CoInSplit1 with (y := (p0, rcv)) (ys := (act w0)). easy. easy.

         rewrite eqb_neq in Heq.

         (****)
         rewrite <- mergeeq2 in H2, H5.
         specialize(H5(p,rcv)).
         destruct H5 as (H5a,H5b).
         apply helperApCpnew in H2.
         apply H5b in H2.
         rewrite(coseq_eq((act (p0 & [(l0, s0, w0)])))).
         unfold coseq_id. simpl.
         apply CoInSplit2 with (y := (p0, rcv)) (ys := (act w0)). simpl. easy.
         intro Hb. apply Heq. inversion Hb. easy.
         exact H2.
         easy.

         rewrite <- mergeeq3 in H2.
         apply mem_ext in H5.
         specialize(H5(p,rcv)).
         destruct H5 as (H5a,H5b).
         rewrite <- H1 in H0.
         apply H0.
         apply helperBpCpnew in H2.
         apply bsdnew in H2.
         apply eq0Anew in H2.
         rewrite <- h0 in H2.
         apply CoInSplit2 with (y := (p0, snd)) (ys := (act w0)). simpl. easy. easy.
         apply H5b. easy.

         apply H0.
         case_eq c; intros.
         subst.
         rewrite(st_eq(merge_cp_cont p (cp_receive q n s0 s1) (p & [(l, s, und)]))) in H3.
         simpl in H3. easy.
         subst.
         rewrite(st_eq(merge_cp_cont p (cp_mergea q n s0 s1 c0) (p & [(l, s, und)]))) in H3.
         simpl in H3. easy.
         subst.
         rewrite(st_eq(merge_cp_cont p (cp_send s0 s1 s2) (p & [(l, s, und)]))) in H3.
         simpl in H3. easy.
         subst.
         rewrite(st_eq(merge_cp_cont p (cp_merge s0 s1 s2 c0) (p & [(l, s, und)]))) in H3.
         simpl in H3. easy.
         subst. rewrite cpend_an in H3. easy.
       }
       {
         inversion H.
         subst.

         unfold upaco2 in H7.
         destruct H7.
         punfold H1.

         subst.
         rewrite <- mergeeq in H6.
         rewrite <- mergeeq in H6.
         apply merge_eq in H6.
         inversion H6. subst. easy.
         apply refinementR_mon.
         easy.
       }
       { inversion H.
         subst.

         unfold upaco2 in H7.
         destruct H7.
         punfold H1.

         subst.
         rewrite <- mergeeq in H6.
         rewrite <- mergeeq in H6.
         apply merge_eq in H6.
         inversion H6. subst.
         apply ssnssL in H0. easy. easy.
         apply refinementR_mon.
         easy.
       }
       { apply IHHa.
         inversion H. subst.
         unfold upaco2 in H7.
         destruct H7.
         punfold H1. simpl.

         subst.
         rewrite <- mergeeq2 in H6.
         rewrite <- mergeeq2 in H6.
         pose proof H6.
         apply merge_eq in H6.
         rewrite <- mergeeq2 in H8.

         inversion H6. subst.
         apply merge_eq2 in H2.
         rewrite <- mergeeq2.
         rewrite <- mergeeq2 in H1.
         rewrite <- H2.
         easy.
         apply refinementR_mon.
         easy.
       }
       { inversion H.
         subst.
         specialize(case11 n p q a l l' s'0 s' w'0 und H5); intros H11.
         easy.
       }
       { inversion H.
         subst. 
         subst.
         rewrite <- mergeeq2 in H6.
         apply case12_2c2 in H6. easy.
         easy.
       } 
       {
         inversion H.
         subst.

         unfold upaco2 in H7.
         destruct H7.
         punfold H1.

         subst.
         rewrite <- mergeeq3 in H6.
         rewrite <- mergeeq3 in H6.
         apply merge_eq3 in H6.
         inversion H6. subst. easy.
         apply refinementR_mon.
         easy.
       }
       { inversion H.
         subst.
         unfold upaco2 in H7.
         destruct H7.
         punfold H1.

         subst.
         rewrite <- mergeeq3 in H6.
         rewrite <- mergeeq3 in H6.
         apply merge_eq3 in H6.
         inversion H6. subst.
         apply ssnssL in H0. easy. easy.
         apply refinementR_mon.
         easy.
       }
       { apply IHHa.
         inversion H. subst.
         unfold upaco2 in H7.
         destruct H7.
         punfold H1.
         simpl.

         subst.
         rewrite <- mergeeq3 in H6.
         rewrite <- mergeeq3 in H6.
         pose proof H6.
         apply merge_eq3 in H6.
         rewrite <- mergeeq3 in H8.

         inversion H6. subst.
         apply merge_eq4 in H2.

         rewrite <- mergeeq3.
         rewrite <- mergeeq3 in H1.
         rewrite <- H2.
         easy.
         apply refinementR_mon.
         easy.
       }
Qed.

Lemma casen1: forall p l s1 s2 w1 w2 P Q,
subsort s2 s1 ->
(nRefinementN (mk_siso (st_receive p [(l, s1, (@und w1))]) P) 
              (mk_siso (st_receive p [(l, s2, (@und w2))]) Q) -> False) ->
(nRefinementN w1 w2 -> False).
Proof. intros.
       apply H0.
       apply n_inp_wN.
       easy.
       easy.
Qed.

Lemma casen2: forall p l s1 s2 w1 w2 P Q,
  subsort s1 s2 ->
  (nRefinementN (mk_siso (st_send p [(l, s1, (@und w1))]) P)
                (mk_siso (st_send p [(l, s2, (@und w2))]) Q) -> False) ->
  (nRefinementN w1 w2 -> False).
Proof. intros.
       apply H0.
       apply n_out_wN.
       easy.
       easy.
Qed.

Lemma n_a_actNH2: forall p b q a l s w1 w2 P Q (Hw1: singleton w1) (Hw2: singleton w2) (Hw2a: coseqIn (p,snd) (act (merge_ap_cont q a w2)) -> False),
  nRefinementN (mk_siso (merge_bp_cont p b (p ! [(l,s,w1)])) P)
               (mk_siso (merge_ap_cont q a w2) Q).
Proof. intros.
       specialize (n_outN {| und := w1; sprop := Hw1 |} {| und :=  merge_ap_cont q a w2; sprop := Q |} p b l s ); intros HH.
       apply HH. simpl. easy.
Qed.

Lemma n_a_actNH4: forall p b q a l s w1 w2 P Q (Hw1: singleton w1) (Hw2: singleton w2) (Hw2a: coseqIn (p,snd) (act (merge_ap_cont q a w2)) -> False),
  nRefinementN (mk_siso (merge_ap_cont q a w2) Q)
               (mk_siso (merge_bp_cont p b (p ! [(l,s,w1)])) P).
Proof. intros.
       specialize (n_out_rN {| und :=  merge_ap_cont q a w2; sprop := Q |}  {| und := w1; sprop := Hw1 |} p b l s ); intros HH.
       apply HH. simpl. easy.
Qed.

Lemma n_a_actNH1: forall p c q a l s w1 w2 P Q (Hw1: singleton w1) (Hw2: singleton w2) (Hw2a: coseqIn (p,rcv) (act (merge_ap_cont q a w2)) -> False),
  nRefinementN (mk_siso (merge_cp_cont p c (p & [(l,s,w1)])) P)
               (mk_siso (merge_ap_cont q a w2) Q).
Proof. intros.
       specialize (n_inpN {| und := w1; sprop := Hw1 |} {| und :=  merge_ap_cont q a w2; sprop := Q |} p c l s ); intros HH.
       apply HH. simpl. easy.
Qed.

Lemma n_a_actNH3: forall q a p c l s w1 w2 P Q (Hw1: singleton w1) (Hw2: singleton w2) 
                         (Hw2a: coseqIn (p,rcv) (act (merge_ap_cont q a w2)) -> False),
nRefinementN (mk_siso (merge_ap_cont q a w2) Q)
             (mk_siso (merge_cp_cont p c (p & [(l,s,w1)])) P).
Proof. intros.
       specialize (n_inp_rN {| und :=  merge_ap_cont q a w2; sprop := Q |}  {| und := w1; sprop := Hw1 |} p c l s ); intros HH.
       apply HH. simpl. easy.
Qed.

Lemma n_b_actN: forall p l s s' w w' b P Q,
  subsort s s' ->
  (act_neq w (merge_bp_cont p b w')) ->
  nRefinementN (mk_siso (p ! [(l,s,w)]) P)
               (mk_siso (merge_bp_cont p b (p ! [(l,s',w')])) Q).
Proof. intros.
       unfold act_neq in H0.
       destruct H0 as (a1, H0).
       destruct H0 as [H0 | H0].
       destruct a1 as (q,ac).
       destruct H0 as (Ha,Hb).
       case_eq ac; intros.
       + subst.
         assert(singleton w) as Hw.
         { apply extsR in P. easy. }
         assert(singleton w') as Hw'.
         { apply extbpR, extsR in Q. easy. }
         assert(singleton (merge_bp_cont p b w')) as Hpw'.
         { apply extbp. easy. }
         specialize(n_b_wN (mk_siso w Hw) (mk_siso w' Hw') p l s s' b 1 Hpw' P Q H); intro Hn.
         apply Hn.
         simpl.
         specialize(inReceive w q Hw Ha); intros.
         destruct H0 as (c1,(l1,(s1,(w1,IHw1)))).
         generalize dependent Hw.
         subst.
         intros Hw Hn.
         assert(singleton w1) as Hw1.
         { clear Hn. apply extsR, extcpR, extrR in P. easy. }
         specialize(n_inpN (mk_siso w1 Hw1) (mk_siso (merge_bp_cont p b w') Hpw') q c1 l1 s1); intro HNI.
         apply HNI.
         simpl. easy.
       + subst.
         assert(singleton w) as Hw.
         { apply extsR in P. easy. }
         assert(singleton w') as Hw'.
         { apply extbpR, extsR in Q. easy. }
         assert(singleton (merge_bp_cont p b w')) as Hpw'.
         { apply extbp. easy. }
         specialize(n_b_wN (mk_siso w Hw) (mk_siso w' Hw') p l s s' b 1 Hpw' P Q H); intro Hn.
         apply Hn.
         simpl.
         specialize(inSend w q Hw Ha); intros.
         destruct H0 as (b1,(l1,(s1,(w1,IHw1)))).
         generalize dependent Hw.
         subst.
         intros Hw Hn.
         assert(singleton w1) as Hw1.
         { clear Hn. apply extsR, extbpR, extsR in P. easy. }
         specialize(n_outN (mk_siso w1 Hw1) (mk_siso (merge_bp_cont p b w') Hpw') q b1 l1 s1); intro HNI.
         apply HNI.
         simpl. easy.
       destruct a1 as (q,ac).
       destruct H0 as (Ha,Hb).
       case_eq ac; intros.
       + subst.
         assert(singleton w) as Hw.
         { apply extsR in P. easy. }
         assert(singleton w') as Hw'.
         { apply extbpR, extsR in Q. easy. }
         assert(singleton (merge_bp_cont p b w')) as Hpw'.
         { apply extbp. easy. }
         specialize(n_b_wN (mk_siso w Hw) (mk_siso w' Hw') p l s s' b 1 Hpw' P Q H); intro Hn.
         apply Hn.
         simpl.
         specialize(inReceive (merge_bp_cont p b w') q Hpw' Ha); intros.
         destruct H0 as (c1,(l1,(s1,(w1,IHw1)))).
         simpl in Hn.
         generalize dependent Hpw'.
         rewrite IHw1.
         intros Hpw' Hn.
         assert(singleton w1) as Hw1.
         { clear Hn. apply extcpR, extrR in Hpw'. easy. }
         specialize(n_inp_rN (mk_siso w Hw) (mk_siso w1 Hw1) q c1 l1 s1 ); intro HNI.
         apply HNI. easy.
       + subst.
         assert(singleton w) as Hw.
         { apply extsR in P. easy. }
         assert(singleton w') as Hw'.
         { apply extbpR, extsR in Q. easy. }
         assert(singleton (merge_bp_cont p b w')) as Hpw'.
         { apply extbp. easy. }
         specialize(n_b_wN (mk_siso w Hw) (mk_siso w' Hw') p l s s' b 1 Hpw' P Q H); intro Hn.
         apply Hn.
         simpl.
         specialize(inSend (merge_bp_cont p b w') q Hpw' Ha); intros.
         destruct H0 as (b1,(l1,(s1,(w1,IHw1)))).
         simpl in Hn.
         generalize dependent Hpw'.
         rewrite IHw1.
         intros Hpw' Hn.
         assert(singleton w1) as Hw1.
         { clear Hn. apply extbpR, extsR in Hpw'. easy. }
         specialize(n_out_rN (mk_siso w Hw) (mk_siso w1 Hw1) q b1 l1 s1 ); intro HNI.
         apply HNI.
         simpl. easy.
Qed.

Lemma n_a_actN: forall p a l s s' w w' P Q,
  subsort s' s ->
  (act_neq w (merge_ap_cont p a w')) ->
  nRefinementN (mk_siso (p & [(l,s,w)]) P)
               (mk_siso (merge_ap_cont p a (p & [(l,s',w')])) Q).
Proof. intros.
       unfold act_neq in H0.
       destruct H0 as (a1, H0).
       destruct H0 as [H0 | H0].
       destruct a1 as (q,ac).
       destruct H0 as (Ha,Hb).
       case_eq ac; intros.
       + subst.
         assert(singleton w) as Hw.
         { apply extrR in P. easy. }
         assert(singleton w') as Hw'.
         { apply extapR, extrR in Q. easy. }
         assert(singleton (merge_ap_cont p a w')) as Hpw'.
         { apply extap. easy. }
         specialize(n_a_wN (mk_siso w Hw) (mk_siso w' Hw') p l s s' a 1 Hpw' P Q H); intro Hn.
         apply Hn.
         simpl in *.
         specialize(inReceive w q Hw Ha); intros.
         destruct H0 as (c1,(l1,(s1,(w1,IHw1)))).
         generalize dependent Hw.
         subst.
         intros Hw Hn.
         apply n_a_actNH1.
         assert(singleton w1) as Hw1.
         { clear Hn. apply extrR, extcpR, extrR in P. easy. }
         easy. easy. easy.
       + subst.
         assert(singleton w) as Hw.
         { apply extrR in P. easy. }
         assert(singleton w') as Hw'.
         { apply extapR, extrR in Q. easy. }
         assert(singleton (merge_ap_cont p a w')) as Hpw'.
         { apply extap. easy. }
         specialize(n_a_wN (mk_siso w Hw) (mk_siso w' Hw') p l s s' a 1 Hpw' P Q H); intro Hn.
         apply Hn.
         simpl in *.
         specialize(inSend w q Hw Ha); intros.
         destruct H0 as (b1,(l1,(s1,(w1,IHw1)))).
         generalize dependent Hw.
         subst.
         intros Hw Hn.
         apply n_a_actNH2.
         assert(singleton w1) as Hw1.
         {  clear Hn. apply extrR, extbpR, extsR in P. easy. }
         easy. easy. easy.
       destruct a1 as (q,ac).
       destruct H0 as (Ha,Hb).
       case_eq ac; intros.
       + subst.
         assert(singleton w) as Hw.
         { apply extrR in P. easy. }
         assert(singleton w') as Hw'.
         { apply extapR, extrR in Q. easy. }
         assert(singleton (merge_ap_cont p a w')) as Hpw'.
         { apply extap. easy. }
         specialize(n_a_wN (mk_siso w Hw) (mk_siso w' Hw') p l s s' a 1 Hpw' P Q H); intro Hn.
         apply Hn.
         simpl in *.
         specialize(inReceive (merge_ap_cont p a w') q Hpw' Ha); intros.
         destruct H0 as (c1,(l1,(s1,(w1,IHw1)))).
         generalize dependent Hpw'.
         rewrite IHw1.
         intros IHw' Hn.
         specialize (n_a_actNH3 p (ap_end) q c1 l1 s1 w1 w); intros IHn3.
         simpl in IHn3.
         rewrite apend_an in IHn3.
         apply IHn3.
         assert(singleton w1) as Hw1.
         {  clear IHn3 Hn. apply extcpR, extrR in IHw'. easy. }
         easy. easy. easy.
       + subst.
         assert(singleton w) as Hw.
         { apply extrR in P. easy. }
         assert(singleton w') as Hw'.
         { apply extapR, extrR in Q. easy. }
         assert(singleton (merge_ap_cont p a w')) as Hpw'.
         { apply extap. easy. }
         specialize(n_a_wN (mk_siso w Hw) (mk_siso w' Hw') p l s s' a 1 Hpw' P Q H); intro Hn.
         apply Hn.
         simpl in *.
         specialize(inSend (merge_ap_cont p a w') q Hpw' Ha); intros.
         destruct H0 as (b1,(l1,(s1,(w1,IHw1)))).
         generalize dependent Hpw'.
         rewrite IHw1.
         intros IHw' Hn.
         specialize (n_a_actNH4 q b1 p (ap_end) l1 s1 w1 w IHw'); intros IHn3.
         simpl in IHn3.
         rewrite apend_an in IHn3.
         apply IHn3.
         assert(singleton w1) as Hw1.
         {  clear IHn3 Hn. apply extbpR, extsR in IHw'. easy. }
         easy. easy. easy.
Qed.

Lemma nRefRH: forall w w', (nRefinementN w w' -> False) -> (@und w) ~< (@und w').
Proof. destruct w as (w, Pw).
       destruct w' as (w', Pw').
       intro H.
       generalize dependent w.
       generalize dependent w'.
       simpl. pcofix CIH.
       intros.
       specialize(sinv w Pw); intros Hpw.
       destruct Hpw as [Hpw | Hpw].
       destruct Hpw as (p, (l, (s, (w1, (Heq1, Hs1))))).
       {
         specialize(sinv w' Pw'); intros Hpw'.
         destruct Hpw' as [Hpw' | Hpw'].
         destruct Hpw' as (q, (l', (s', (w2, (Heq2, Hs2))))).
         subst.
         case_eq(eqb p q); intro Heq.
         rewrite eqb_eq in Heq.
         case_eq(eqb l l'); intro Heq2.
         rewrite eqb_eq in Heq2.
         specialize(sort_dec s s'); intro Heq3.
         destruct Heq3 as [Heq3 | Heq3].
         subst.
         pfold.

         specialize(classic(act_eq w1 w2)); intros Hact.
         destruct Hact as [Hact | Hact].
         specialize(_sref_b (upaco2 refinementR r) w1 w2 q l' s s' (bp_end) 1); intros HSR.
         rewrite bpend_ann in HSR.
         rewrite bpend_ann in HSR.
         simpl in HSR.
         eapply HSR.
         easy.

         right.
         specialize (CIH w2 Hs2 w1 Hs1). apply CIH.
         simpl.
         specialize (casen2 q l' s s' ({| und := w1; sprop := Hs1 |}) {| und := w2; sprop := Hs2 |} Pw Pw'); intros Hp.
         intros Hp2.
         apply Hp. easy. simpl. exact H0.
         exact Hp2.
         apply mem_ext. easy.
         subst.

         specialize(n_b_actN q l' s s' w1 w2 (bp_end) Pw ); intros HBN.
         rewrite bpend_an in HBN.
         destruct H0.
         apply HBN. easy. rewrite bpend_an. 
         apply act_eq_neq. intro Ha. apply Hact. easy.
         subst.

         specialize (n_out_sN ({| und := w1; sprop := Hs1 |}) {| und := w2; sprop := Hs2 |} q l' s s' Pw Pw'); intro Hn.
         destruct H0.
         apply Hn. easy.
         subst.
         rewrite eqb_neq in Heq2.
         specialize (n_out_lN ({| und := w1; sprop := Hs1 |}) {| und := w2; sprop := Hs2 |} q l l' s s' Pw Pw'); intro Hn.
         destruct H0.
         apply Hn. easy.
         rewrite eqb_neq in Heq.

         specialize(classic (coseqIn (p, snd) (act (q ! [(l', s', w2)])) -> False)); intro Hclass.
         destruct Hclass as [Hclass | Hclass].
         destruct H0.
         specialize (n_outN {| und := w1; sprop := Hs1 |} {| und := q ! [(l', s', w2)]; sprop := Pw' |} p (bp_end) l s ); intros HH.
         rewrite bpend_an in HH.
         simpl in HH. apply HH. easy.
         unfold not in Hclass.
         apply NNPP in Hclass.

         specialize(inSend (q ! [(l', s', w2)]) p Pw' Hclass); intros.
         destruct H as (b,(l1,(s1,(w3,IHw3)))).
         rewrite IHw3.

         case_eq(eqb l l1); intro Heq2.
         rewrite eqb_eq in Heq2. subst.
         specialize(sort_dec s s1); intro Heq3.
         destruct Heq3 as [Heq3 | Heq3].
         pfold.
         specialize(classic (act_eq w1 ((merge_bp_cont p b w3)))); intro Hact.
         destruct Hact as [Hact | Hact].
         specialize(_sref_b (upaco2 refinementR r) w1 w3 p l1 s s1 b 1); intro Hrb.
         simpl in Hrb.
         eapply Hrb. easy.

         assert(singleton w3) as Hs3.
         { revert Pw' H0.
           rewrite IHw3.
           intros Pw'' H0.
           specialize (@extbpR p b (p ! [(l1, s1, w3)]) Pw''); intros Hss.
           specialize (@extsR p l1 s1 w3 Hss); intros Hss2.
           easy. 
         }
         assert(singleton (merge_bp_cont p b w3)) as Pw''.
         { specialize(@extbp p b w3 Hs3); intros Hss. easy. }
         specialize(CIH (merge_bp_cont p b w3) Pw'' w1 Hs1).
         right.
         apply CIH.
         intro h.
         apply H0.
         generalize dependent Pw'.
         rewrite IHw3.
         intros Pw' H0.
         specialize(n_b_wN (mk_siso w1 Hs1) (mk_siso w3 Hs3) p l1 s s1 b 1 Pw'' Pw); intros HN. simpl in HN.
         apply HN. easy. easy.
         apply mem_ext. easy.

         generalize dependent Pw'.
         rewrite IHw3.
         intros Pw'' H0.
         destruct H0.
         apply act_eq_neq in Hact.
         specialize(n_b_actN p l1 s s1 w1 w3 b Pw Pw''); intros HN.
         apply HN. easy. easy.

         generalize dependent Pw'.
         rewrite IHw3.
         intros Pw'' H0.
         destruct H0.
         assert(singleton w3) as Hs3.
         { specialize (@extbpR p b (p ! [(l1, s1, w3)]) Pw''); intros Hss.
           specialize (@extsR p l1 s1 w3 Hss); intros Hss2.
           easy. 
         }
         specialize (n_b_sN (mk_siso w1 Hs1) (mk_siso w3 Hs3) p l1 s s1 b 1 Pw Pw'' Heq3); intros Hn.
         apply Hn.

         rewrite eqb_neq in Heq2.
         generalize dependent Pw'.
         rewrite IHw3.
         intros Pw'' H0.
         destruct H0.
         assert(singleton w3) as Hs3.
         { specialize (@extbpR p b (p ! [(l1, s1, w3)]) Pw''); intros Hss.
           specialize (@extsR p l1 s1 w3 Hss); intros Hss2.
           easy. 
         }
         specialize (n_b_lN (mk_siso w1 Hs1) (mk_siso w3 Hs3) p l l1 s s1 b 1 Pw Pw''); intros Hn.
         apply Hn. easy.

         destruct Hpw' as [Hpw' | Hpw'].
         destruct Hpw' as (q, (l', (s', (w2, (Heq2, Hs2))))).
         subst.

         specialize(classic (coseqIn (p, snd) (act (q & [(l', s', w2)])) -> False)); intro Hclass.
         destruct Hclass as [Hclass | Hclass].
         destruct H0.
         specialize (n_outN {| und := w1; sprop := Hs1 |} {| und := q & [(l', s', w2)]; sprop := Pw' |} p (bp_end) l s ); intros HH.
         rewrite bpend_an in HH.
         simpl in HH. apply HH. easy.

         apply NNPP in Hclass.
         specialize(inSend (q & [(l', s', w2)]) p Pw' Hclass); intros.
         destruct H as (b,(l1,(s1,(w3,IHw3)))).
         generalize dependent Pw'.
         rewrite IHw3.
         intros Pw' H0.

         case_eq(eqb l l1); intro Heq2.
         rewrite eqb_eq in Heq2. subst.
         specialize(sort_dec s s1); intro Heq3.
         destruct Heq3 as [Heq3 | Heq3].
         pfold.
         specialize(classic (act_eq w1 ((merge_bp_cont p b w3)))); intro Hact.
         destruct Hact as [Hact | Hact].
         specialize(_sref_b (upaco2 refinementR r) w1 w3 p l1 s s1 b 1); intro Hrb.
         simpl in Hrb.
         eapply Hrb. easy.

         assert(singleton w3) as Hs3.
         { 
            specialize (@extbpR p b (p ! [(l1, s1, w3)]) Pw'); intros Hss2.
            specialize (@extsR p l1 s1 w3 Hss2); intros Hss3. easy.
         }
         assert(singleton (merge_bp_cont p b w3)) as Pw''.
         { specialize(@extbp p b w3 Hs3); intros Hss. easy. }
         specialize(CIH (merge_bp_cont p b w3) Pw'' w1 Hs1).
         right.
         apply CIH.
         intro h.
         apply H0.

         specialize(n_b_wN (mk_siso w1 Hs1) (mk_siso w3 Hs3) p l1 s s1 b 1 Pw'' Pw); intros HN. simpl in HN.
         apply HN. easy. easy.
         apply mem_ext. easy.

         destruct H0.
         apply act_eq_neq in Hact.
         specialize(n_b_actN p l1 s s1 w1 w3 b Pw Pw'); intros HN.
         apply HN. easy. easy.

         destruct H0.
         assert(singleton w3) as Hs3.
         { specialize (@extbpR p b (p ! [(l1, s1, w3)]) Pw'); intros Hss.
           specialize (@extsR p l1 s1 w3 Hss); intros Hss2.
           easy. 
         }
         specialize (n_b_sN (mk_siso w1 Hs1) (mk_siso w3 Hs3) p l1 s s1 b 1 Pw Pw' Heq3); intros Hn.
         apply Hn.

         rewrite eqb_neq in Heq2.
         destruct H0.
         assert(singleton w3) as Hs3.
         { specialize (@extbpR p b (p ! [(l1, s1, w3)]) Pw'); intros Hss.
           specialize (@extsR p l1 s1 w3 Hss); intros Hss2.
           easy. 
         }
         specialize (n_b_lN (mk_siso w1 Hs1) (mk_siso w3 Hs3) p l l1 s s1 b 1 Pw Pw'); intros Hn.
         apply Hn. easy.

         subst.
         destruct H0.
         specialize(n_outN {| und := w1; sprop := Hs1 |} {| und := end; sprop := Pw' |} p (bp_end) l s); intro Hn.
         rewrite bpend_an in Hn.
         simpl in Hn.
         apply Hn. 
         rewrite(coseq_eq(act st_end)). unfold coseq_id. simpl.
         intro Hf.
         inversion Hf. subst. easy.
         subst. easy.
       }
       destruct Hpw as [Hpw | Hpw].
       destruct Hpw as (p, (l, (s, (w1, (Heq1, Hs1))))).
       { subst.
         specialize(sinv w' Pw'); intros Hpw'.
         destruct Hpw' as [Hpw' | Hpw'].
         destruct Hpw' as (q, (l', (s', (w2, (Heq2, Hs2))))).
         subst.
         specialize(n_i_o_1N {| und := w1; sprop := Hs1 |} {| und := w2; sprop := Hs2 |} p q l l' s s' Pw Pw'); intro Hn.
         destruct H0.
         apply Hn.

         destruct Hpw' as [Hpw' | Hpw'].
         destruct Hpw' as (q, (l', (s', (w2, (Heq2, Hs2))))).
         subst.
         case_eq(eqb p q); intro Heq.
         rewrite eqb_eq in Heq.
         case_eq(eqb l l'); intro Heq2.
         rewrite eqb_eq in Heq2.
         specialize(sort_dec s' s); intro Heq3.
         destruct Heq3 as [Heq3 | Heq3].
         subst.
         pfold.

         specialize(classic(act_eq w1 w2)); intros Hact.
         destruct Hact as [Hact | Hact].
         specialize(_sref_a (upaco2 refinementR r) w1 w2 q l' s s' (ap_end) 1); intros HSR.
         rewrite apend_ann in HSR.
         rewrite apend_ann in HSR.
         simpl in HSR.
         eapply HSR. easy.

         right. 
         apply (CIH w2 Hs2 w1 Hs1).
         intro Hs.
         specialize(casen1 q l' s s' {| und := w1; sprop := Hs1 |} {| und := w2; sprop := Hs2 |} Pw Pw'); intro Hn.
         apply Hn. easy. exact H0. exact Hs.
         subst.
         apply mem_ext. easy.

         specialize(n_a_actN q (ap_end) l' s s' w1 w2); intros HNA.
         destruct H0.
         rewrite apend_an in HNA.
         apply HNA.
         easy. rewrite apend_an.
         apply act_eq_neq.
         intro Hb. apply Hact. easy.

         subst.
         destruct H0.
         specialize(n_inp_sN {| und := w1; sprop := Hs1 |} {| und := w2; sprop := Hs2 |} q l' s s' Pw Pw'); intro Hn.
         apply Hn. easy.
         subst.
         rewrite eqb_neq in Heq2.
         destruct H0.
         specialize(n_inp_lN {| und := w1; sprop := Hs1 |} {| und := w2; sprop := Hs2 |} q l l' s s' Pw Pw'); intro Hn.
         apply Hn. easy.

         rewrite eqb_neq in Heq.

         specialize(classic (coseqIn (p, rcv) (act (q & [(l', s', w2)])) -> False)); intro Hclass.
         destruct Hclass as [Hclass | Hclass].
         destruct H0.
         specialize (n_inpN {| und := w1; sprop := Hs1 |} {| und := q & [(l', s', w2)]; sprop := Pw' |} p (cp_end) l s ); intros HH.
         simpl in HH. rewrite cpend_an in HH. apply HH. easy.

         apply NNPP in Hclass.

         specialize(inReceive (q & [(l', s', w2)]) p Pw' Hclass); intros.
         destruct H as (c,(l1,(s1,(w3,IHw3)))).
         generalize dependent Pw'.
         rewrite IHw3.
         intros Pw' H0.

         case_eq(isInCp p c); intros.
         destruct H0.
         assert(singleton w3) as Hs3.
         { apply extcpR, extrR in Pw'.
           easy.
         }
         specialize(n_i_o_2N (mk_siso w1 Hs1) (mk_siso w3 Hs3) p l l1 s s1 c Pw Pw'); intros HN2.
         apply HN2. easy.

         specialize(Cp2Ap p c (p & [(l1, s1, w3)]) H); intros Hpc.
         destruct Hpc as (a, Hpc).
         generalize dependent Pw'.
         rewrite Hpc.
         intros Pw' H0.

         case_eq(eqb l l1); intro Heq2.
         rewrite eqb_eq in Heq2. subst.
         specialize(sort_dec s1 s); intro Heq3.
         destruct Heq3 as [Heq3 | Heq3].
         pfold.
         specialize(classic (act_eq w1 ((merge_ap_cont p a w3)))); intro Hact.
         destruct Hact as [Hact | Hact].
         specialize(_sref_a (upaco2 refinementR r) w1 w3 p l1 s s1 a 1); intro Hrb.
         simpl in Hrb.
         eapply Hrb. easy.

         assert(singleton (merge_ap_cont p a w3)) as Pw''.
         { specialize(@extapR p a (p & [(l1, s1, w3)]) Pw'); intros Hss.
           specialize(@extrR p l1 s1 w3 Hss); intros Hss2.
           apply extap. easy.
         }
         specialize(CIH (merge_ap_cont p a w3) Pw'' w1 Hs1).
         right.
         apply CIH.
         intro h.
         apply H0.

         assert(singleton w3) as Hs3.
         { specialize(@extapR p a (p & [(l1, s1, w3)]) Pw'); intros Hss.
           specialize(@extrR p l1 s1 w3 Hss); intros Hss2.
           easy.
         }

         specialize(n_a_wN (mk_siso w1 Hs1) (mk_siso w3 Hs3) p l1 s s1 a 1 Pw'' Pw); intros HN. simpl in HN.
         apply HN. easy. easy.
         apply mem_ext. easy.

         destruct H0.
         apply act_eq_neq in Hact.
         specialize(n_a_actN p a l1 s s1 w1 w3 Pw Pw'); intros HN.
         apply HN. easy. easy.

         assert(singleton w3) as Hs3.
         { specialize(@extapR p a (p & [(l1, s1, w3)]) Pw'); intros Hss.
           specialize(@extrR p l1 s1 w3 Hss); intros Hss2.
           easy.
         }

         specialize (n_a_sN (mk_siso w1 Hs1) (mk_siso w3 Hs3) p l1 s s1 a 1 Pw Pw' Heq3); intros Hn.
         destruct H0.
         apply Hn.

         rewrite eqb_neq in Heq2.
         destruct H0.
         assert(singleton w3) as Hs3.
         { specialize (@extapR p a (p & [(l1, s1, w3)]) Pw'); intros Hss.
           specialize (@extrR p l1 s1 w3 Hss); intros Hss2.
           easy. 
         }
         specialize (n_a_lN (mk_siso w1 Hs1) (mk_siso w3 Hs3) p l l1 s s1 a 1 Pw Pw'); intros Hn.
         apply Hn. easy.

         subst.
         destruct H0.
         specialize(n_inpN {| und := w1; sprop := Hs1 |} {| und := end; sprop := Pw' |} p (cp_end) l s); intro Hn.
         simpl in Hn. rewrite cpend_an in Hn.
         apply Hn. 
         rewrite(coseq_eq(act st_end)). unfold coseq_id. simpl.
         intro Hf. inversion Hf; subst; easy. 
       }
       subst.
       { specialize(sinv w' Pw'); intros Hpw'.
         destruct Hpw' as [Hpw' | Hpw'].
         destruct Hpw' as (q, (l', (s', (w2, (Heq2, Hs2))))).
         subst.
         destruct H0.
         specialize(n_out_rN {| und := end; sprop := Pw |} {| und := w2; sprop := Hs2 |} q (bp_end) l' s'); intro Hn.
         rewrite bpend_an in Hn.
         apply Hn. 
         rewrite(coseq_eq(act st_end)). unfold coseq_id. simpl.
         intro Hf. inversion Hf; subst; easy. 
         destruct Hpw' as [Hpw' | Hpw'].
         destruct Hpw' as (q, (l', (s', (w2, (Heq2, Hs2))))).
         subst.

         specialize(n_inp_rN {| und := end; sprop := Pw |} {| und := w2; sprop := Hs2 |} q (cp_end) l' s'); intro Hn.
         destruct H0.
         rewrite cpend_an in Hn.
         apply Hn. 
         rewrite(coseq_eq(act st_end)). unfold coseq_id. simpl.
         intro Hf. inversion Hf; subst; easy. 
         subst.
         pfold. constructor.
       }
Qed.

Lemma contraposition: forall (a b: Prop), (a -> b) <-> ((b -> False) -> (a -> False)).
Proof. split.
       - intros.
         apply H0, H, H1.
       - intros.
         specialize (classic b); intros.
         destruct H1 as [H1 | H1].
         + easy.
         + specialize(H H1 H0). easy.
Qed.

Lemma nRefR: forall w w', ((@und w) ~< (@und w') -> False) -> nRefinementN w w'.
Proof. intros.
       specialize(nRefRH w w'); intro HS.
       rewrite contraposition in HS.
       intros Hb Hc.
       specialize(Hc Hb). easy.
Qed.

(* Print DependGraph completeness. *)

