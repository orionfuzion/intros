	*****************************************
	* Intro      Special Mouse              *
	* Coder      ORION from Replicants      *
	* Usage      Replicants Cracks          *
	* Date       Feb 1993                   *
	*                                       *
	* Machine    Atari STE - 1MB RAM        *
	* TOS        1.62                       *
	* Assembler  GenST v2.09                *
	* Emulator   Steem v3.2                 *
	*                                       *
	* Contact    Orion.Replicants@gmail.com *
	*****************************************

	opt	o+,d-

x0	=	160    ( x initial souris )
y0	=	100    ( y initial souris )
x_min	=	0      ( x minimum souris )
y_min	=	42     ( y minimum souris )
x_max	=	320    ( x maximum souris )
y_max	=	274    ( y maximum souris )  
nbr_mouses	=	6      ( nombre de curseurs souris )
decal_mouse	=	12     ( decalage entre les curseurs )
speed_key_m	=	4      ( vitesse du deplacement du curseur souris controlee par le clavier )
nbr_rouleaux	=	10     ( nombre de rouleaux de couleurs )	
decal_roul	=	4      ( decalage entre les rouleaux )
deb_line_ras	=	8      ( debut ligne des rasters )
pos_scroll	=	212    ( debut ligne du scroll )
time_eff_col1	=	400    ( attente entre 2 fondus de rasters )
time_eff_col2	=	3      ( vitesse du fondu de couleurs )
time_eff_col3	=	2      ( idem pour la couleur de selection du trainer )
aff_union	=	1      ( 0:pas de logo union 1:affiche logo union )
haut_reps	=	37     ( hauteur logo replicants )
memory	=	1      ( 0:jeu necessite 1 mega 1:jeu fonctionnant sur 520 )
trainer_mode	=	2      ( 0:pas de trainer 1:trainer 2:mega trainer )
nbr_trainer	=	13     ( nombre d'options au mega trainer )
sensib_mouse	=	8      ( sensibilite souris pour le trainer )
sensib_repeat	=	32     ( temps d'attente pour la repetition des compteurs du mega trainer )
sens_key_tr	=	8      ( sensibilite du clavier pour le trainer )
play_music	=	1      ( 0:pas de music 1:music )
adr_music	=	$6c2ce ( adresse de reloc de la music. pas de reloc si adr_music=0 )
num_music	=	1      ( numero de la music )
offset1_music	=	$19be  ( offset du 1er saut pour la music )
offset2_music	=	$36    ( offset du 2eme saut pour la music )
multi_music	=	1      ( 1:choix des musics pendant l'intro avec f1. 2:pas de choix )
nbr_music	=	3      ( nombre de musics )
after_intro	=	1      ( 0:intro installee sur boot 1:revient au bureau 2:reloge prg inclus )

pt_base	
	ifne	after_intro
	pea	intro(pc)
	move	#$26,-(a7)
	trap	#14
	addq.l	#6,a7
	elseif
	movem.l	d0-a6,-(a7)
	bsr	intro
	movem.l	(a7)+,d0-a6
	rts
	endc
	
	ifne	after_intro=1
	clr.w	-(a7)
	trap	#1
	endc
	
	ifne	after_intro=2
	lea	buffer_prog,a0
	lea	pt_base(pc),a1
	lea	-$100(a1),a2
	bsr	reloge
	bsr	calc_pb
	move.l	$18(a2),a4
	move.l	$10(a2),a5
	lea	-50(a7),a6
	move.l	a2,4(a7)
	
	lea	endcop(pc),a0
	move.l	a1,a3
	move.w	#(endcop-cop_prog)/2-1,d0
cop_cop	move.w	-(a0),-(a3)
	dbf	d0,cop_cop
	
	lea	buffer_prog+$1c,a0
	move.l	a4,d0
	add.l	-$1c+14(a0),d0
	
	jmp	(a3)
	
reloge	movem.l	d0-d2/a0-a2,-(a7)
	tst.w	$1a(a0)
	bne.s	no_reloge
	move.l	2(a0),d0
	add.l	6(a0),d0
	add.l	14(a0),d0
	lea	$1c(a0,d0.l),a2
	moveq	#0,d1
	move.l	a1,d2
	move.l	(a2)+,d0
	beq.s	no_reloge
reloge1	add.l	d2,$1c(a0,d0.l)
reloge2	move.b	(a2)+,d1
	beq.s	no_reloge
	add.l	d1,d0
	cmp.b	#1,d1
	bne.s	reloge1
	add.l	#253,d0
	bra.s	reloge2
no_reloge	movem.l	(a7)+,d0-d2/a0-a2
	rts

calc_pb	movem.l	d0/a1-a2,-(a7)
	move.l	2(a0),d0
	move.l	d0,$c(a2)
	add.l	d0,a1
	move.l	a1,$10(a2)
	move.l	6(a0),d0
	move.l	d0,$14(a2)
	add.l	d0,a1
	move.l	a1,$18(a2)
	move.l	10(a0),$1c(a2)
	movem.l	(a7)+,d0/a1-a2
	rts
	
cop_prog	move.l	(a0)+,(a1)+
	cmp.l	a1,d0
	bgt.s	cop_prog
eff_mem	clr.l	(a1)+
	cmp.l	a1,a7
	bgt.s	eff_mem
	movem.l	-12*4(a1),d0-a3
endcop
	endc
	
intro	bsr	save_all
	ifne	after_intro
	bsr	cl_clav_mouse
	endc
	bsr	set_error
	bsr	set_reset
	bsr	tst_mono
	bsr	set_inter0
	bsr	set_scrs
	ifne	aff_union
	bsr	aff_logo_union
	endc
	bsr	prep_scr1
	ifne	play_music
	bsr	prep_music
	endc
	bsr	prep_rouls
	bsr	prep_sprite
	bsr	sync_high
	bsr	set_inter1
	bsr	main1
	ifne	trainer_mode=2
	tst.w	choice_tr
	beq.s	no_trainer2
	bsr	set_inter2
	bsr	prep_scr2
	bsr	main2
	endc
no_trainer2	bsr	colors_off
	bsr	restore_inter
	ifne 	memory=0
	bsr	tst_memory
	endc
	bsr	restore_scr
	ifne	trainer_mode
	bsr	trainer
	endc
	rts

save_all	lea	$ffff8200.w,a0
	moveq	#0,d0
	movep.w	1(a0),d0
	lsl.l	#8,d0
	move.l	d0,sav_scr
	movem.l	$40(a0),d0-d7
	movem.l	d0-d7,sav_pal
	moveq	#0,d0
	move.b	$60(a0),d0
	and.b	#3,d0
	move.w	d0,sav_rez
	lea	sav_mfp(pc),a0
	move.b	$fffffa07.w,(a0)+
	move.b	$fffffa09.w,(a0)+
	move.b	$fffffa13.w,(a0)+
	move.b	$fffffa15.w,(a0)+
	move.b	$fffffa17.w,(a0)+
	move.b	$fffffa1b.w,(a0)+
	move.b	$fffffa21.w,(a0)+
	lea	sav_vecs(pc),a0
	move.l	$118.w,(a0)+
	move.l	$70.w,(a0)+
	move.l	$68.w,(a0)+
	move.l	$120.w,(a0)+
	lea	$8.w,a0
	lea	sav_error(pc),a1
	moveq	#9,d0
cop_sav_error	move.l	(a0)+,(a1)+
	dbf	d0,cop_sav_error
	rts
	
	ifne	after_intro
cl_clav_mouse	dc.w	$a00a
	clr.b	$484.w
	rts
	endc
	
set_error	move.w	sr,-(a7)
	move.w	#$2700,sr
	lea	error(pc),a0
	lea	$8.w,a1
	moveq	#9,d0
cop_set_error	move.l	a0,(a1)+
	dbf	d0,cop_set_error
	move.w	#$4e73,(a1)
	lea	6(a7),a0
	move.l	a0,sav_sp_error
	rte

error	move.w	#$2700,sr
	move.l	sav_sp_error(pc),a7
	movem.l	black(pc),d0-d7
	movem.l	d0-d7,$ffff8240.w
	bsr	restore_inter
	move.w	sav_rez(pc),d0
	move.l	sav_scr(pc),a0
	bsr	set_scr_rez
	lea	alert_error(pc),a0
	bsr	aff_txt
lp_err_key	move.w	#7,-(a7)
	trap	#1
	addq.l	#2,a7
	swap	d0
	cmp.b	#$39,d0
	bne.s	lp_err_key
	movem.l	black(pc),d0-d7
	movem.l	d0-d7,$ffff8240.w
	bsr	restore_scr
	rts

aff_txt	pea	(a0)
	move.w	#9,-(a7)
	trap	#1
	addq.l	#6,a7
	bsr	vsync
	move.w	#$777,d0
	move.w	d0,$ffff8242.w
	move.w	d0,$ffff8246.w
	move.w	d0,$ffff825e.w
	rts

tst_mono	cmp.w	#2,sav_rez
	blt.s	no_mono
	bsr	vsync
	clr.l	$ffff8240.w
	lea	alert_mono(pc),a0
	bsr.s	aff_txt
	move.w	#$2700,sr
blk_mono	bra.s	blk_mono
no_mono	rts

set_inter0	bsr	clear_kb
	lea	kb_prep(pc),a0
	bsr	set_acia
	bsr	clear_inter
	rts
	
clear_inter	move.w	sr,-(a7)
	move.w	#$2700,sr
	clr.b	$fffffa07.w
	clr.b	$fffffa13.w
	clr.b	$fffffa1b.w
	move.b	#$40,$fffffa09.w
	move.b	#$40,$fffffa15.w
	move.b	#$40,$fffffa17.w
	move.l	#vbl0,$70.w
	move.l	#inter_ret,$68.w
	move.l	#inter_ret,$120.w
	move.l	#key_rout,$118.w
	rte
	
vbl0	addq.l	#1,$466.w
inter_ret	rte

set_reset	move.l	#$31415926,$426.w
	move.l	#reset,$42a.w
	rts
	
reset	lea	$ffff8240.w,a0
	moveq	#7,d0
cl_col_res	clr.l	(a0)+
	dbf	d0,cl_col_res
	move.b	#2,$ffff820a.w
	lea	$600.w,a7
	bsr	clear_yam
	clr.l	$426.w
	clr.l	$42a.w
	lea	$4.w,a0
	move.l	(a0)+,d0
	moveq	#61,d1
err_recop	move.l	d0,(a0)+
	dbf	d1,err_recop
	move.w	#($400-$100)/4-1,d0
eff1	clr.l	(a0)+
	dbf	d0,eff1
	movem.l	-15*4(a0),d0-a6
	move.l	a7,a0
	move.l	a7,a1
	move.l	#$22c020c1,d0
	moveq	#0,d1
	move.l	d0,(a1)+
	jmp	(a7)
	
set_scrs	lea	black(pc),a0
	lea	$ffff8240.w,a1
	lea	table_fade(pc),a2
	bsr	fade_col
	lea	buf_scr+$200,a0
	move.l	a0,d0
	and.l	#$ffff00,d0
	move.l	d0,a0
	add.l	#$bb00,d0
	move.l	a0,scr
	move.l	d0,scr+4
	moveq	#0,d0
	bsr	set_scr_rez
	bsr	clear_scr
	rts

clear_scr	move.w	#$bb00/4-1,d0
clr_scrs	clr.l	(a0)+
	dbf	d0,clr_scrs
	rts

	ifne	aff_union
aff_logo_union	lea	logo_union(pc),a0
	move.l	scr(pc),a1
	add.l	#51*160+24,a1
	moveq	#96,d0
union_lp2	moveq	#27,d1
union_lp1	move.l	(a0)+,(a1)+
	dbf	d1,union_lp1
	lea	48(a1),a1
	dbf	d0,union_lp2
	lea	pal_logo_union(pc),a0
	lea	$ffff8240.w,a1
	lea	table_fade(pc),a2
	bsr	fade_col
	move.w	#100,d0
att_union	cmp.w	#$39,key
	beq.s	end_att_union
	bsr	vsync
	dbf	d0,att_union
end_att_union	lea	black(pc),a0
	lea	$ffff8240.w,a1
	lea	table_fade(pc),a2
	bsr	fade_col
	move.l	scr(pc),a0
	bsr.s	clear_scr
	rts
	endc

prep_scr1	bsr	aff_logo_reps
	bsr	aff_text
	bsr	aff_scr_bdr
	bsr	aff_buttons
	bsr	cop_scr1_scr2
	rts

vsync	clr.l	$466.w
wait_sync	tst.l	$466.w
	beq.s	wait_sync
	rts	
	
set_scr_rez	movem.l	d1/a1,-(a7)
	bsr.s	vsync
	lea	$ffff8200.w,a1
	move.b	d0,$60(a1)
	clr.b	$a(a1)
	moveq	#3,d1
sync_planes	bsr.s	vsync
	dbf	d1,sync_planes
	move.b	#2,$a(a1)
	move.b	d0,$60(a1)
	move.l	a0,d1
	ror.l	#8,d1
	movep.w	d1,1(a1)
	movem.l	(a7)+,d1/a1
	rts
	
aff_logo_reps	lea	reps_logo(pc),a0
	move.l	scr(pc),a1
	lea	160*4(a1),a1
	move.w	#40*haut_reps-1,d0
cop_logo	move.l	(a0)+,(a1)+
	dbf	d0,cop_logo
	rts
	
aff_text	lea	text(pc),a0
	move.l	a0,a1
	moveq	#0,d0
lp_center	tst.b	(a1)
	beq.s	end_center
s_fin_line	cmp.b	#1,(a1)+
	bne.s	s_fin_line
	addq.w	#1,d0
	bra.s	lp_center
end_center	lsl.l	#3,d0
	move.l	#pos_scroll-(haut_reps+4),d1
	sub.l	d0,d1
	lsr.l	#1,d1
	add.l	#haut_reps+4,d1
	mulu	#160,d1
	lea	fonts(pc),a1
	move.l	scr(pc),a2
	add.l	d1,a2
lp_fonts	moveq	#0,d0
s_end_line	cmp.b	#1,0(a0,d0.l)
	beq.s	end_line
	tst.b	0(a0,d0.l)
	beq	end_aff_fnts
	addq.l	#1,d0
	bra.s	s_end_line
end_line	tst.w	d0
	bne.s	lp_sui
	lea	160*8(a2),a2
	addq.l	#1,a0
	bra.s	lp_fonts
lp_sui	moveq	#40,d1
	sub.l	d0,d1
	lsr.l	#1,d1
	bsr	aff_1_line
	bra.s	lp_fonts
end_aff_fnts	rts
	
aff_1_line	movem.l	d0-d5/a1-a4,-(a7)
	move.l	d1,d2
	and.w	#1,d2
	lsr.l	#1,d1
	lsl.l	#3,d1
	add.w	d2,d1
	mulu	#6,d2
	addq.w	#1,d2
lp_line	moveq	#0,d3
	move.b	(a0)+,d3
	sub.b	#$20,d3
	lsl.l	#5,d3
	lea	0(a1,d3.l),a3
	lea	0(a2,d1.l),a4
	moveq	#7,d3
cop_font	move.b	(a3),d4
	or.b	1(a3),d4
	or.b	2(a3),d4
	or.b	3(a3),d4
	not.b	d4
	and.b	d4,(a4)
	move.b	(a3)+,d5
	or.b	d5,(a4)
	and.b	d4,2(a4)
	move.b	(a3)+,d5
	or.b	d5,2(a4)
	and.b	d4,4(a4)
	move.b	(a3)+,d5
	or.b	d5,4(a4)
	and.b	d4,6(a4)
	move.b	(a3)+,d5
	or.b	d5,6(a4)
	lea	160(a4),a4
	dbf	d3,cop_font
	add.w	d2,d1
	eor.w	#6,d2
	cmp.b	#1,(a0)
	bne.s	lp_line
	movem.l	(a7)+,d0-d5/a1-a4
	rts

aff_scr_bdr	lea	scr_bdr(pc),a0
	move.l	scr(pc),a1
	add.l	#pos_scroll*160,a1
	moveq	#0,d0
	bsr	aff_bdr_blk
	lea	17*8(a0),a0
	moveq	#17,d0
	bsr	aff_bdr_blk
	lea	17*8(a0),a0
	moveq	#0,d0
	bsr	aff_bdr_blk
	rts
	
aff_bdr_blk	pea	(a0)
lp_aff_bdr1	moveq	#16,d1
lp_aff_bdr2	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	lea	160-8(a1),a1
	dbf	d1,lp_aff_bdr2
	move.l	(a7),a0
	lea	-17*160+8(a1),a1
	dbf	d0,lp_aff_bdr1
	move.l	(a7)+,a0
	rts

aff_buttons	lea	buttons(pc),a0
	move.l	scr(pc),a1
	add.l	#160*238+32,a1
	moveq	#31,d0
	
	ifne	trainer_mode 
cop_but1	moveq	#7,d1
cop_but2	move.l	(a0)+,(a1)+
	move.l	32*32-4(a0),64-4(a1)
	dbf	d1,cop_but2
	lea	160-32(a1),a1
	dbf	d0,cop_but1
	rts
	elseif
	lea	32(a1),a1
cop_but3	moveq	#7,d1
cop_but4	move.l	(a0)+,(a1)+
	dbf	d1,cop_but4
	lea	160-32(a1),a1
	dbf	d0,cop_but3
	rts
	endc
	
cop_scr1_scr2	move.l	scr(pc),a0
	move.l	scr+4(pc),a1
	move.w	#$bb00/4-1,d0
cop_scr	move.l	(a0)+,(a1)+
	dbf	d0,cop_scr
	rts
	
	ifne	play_music
prep_music	bsr	clear_yam
	ifne	multi_music
	moveq	#0,d0
	move.w	cpt_music,d0
	lea	buf_num_music(pc),a0
	move.b	(a0,d0.l),d0
	move.w	d0,nb_music
	endc
	ifne	adr_music
	lea	music,a0
	lea	adr_music,a1
	move.w	#(end_music-music)/4,d0
cop_music	move.l	(a0)+,(a1)+
	dbf	d0,cop_music
	moveq	#0,d0
	move.w	nb_music,d0
	jsr	adr_music+offset1_music
	move.l	#adr_music+offset2_music,adr_music_rel
	elseif
	moveq	#0,d0
	move.w	nb_music,d0
	jsr	music+offset1_music
	move.l	#music+offset2_music,adr_music_rel
	endc
	rts
	endc

prep_rouls	lea	sinus_roul(pc),a0
	lea	buf_sinus(pc),a1
	lea	nbr_rouleaux*2(a1),a2
lp_prep_rouls	moveq	#0,d0
	move.b	(a0)+,d0
	add.w	#deb_line_ras,d0
	mulu	#2,d0
	move.w	d0,(a1)+
	tst.b	(a0)
	bne.s	lp_prep_rouls
	move.w	#(end_sinus-sinus_roul-nbr_rouleaux)-1,d0
cop_prep_rouls	move.w	(a2)+,(a1)+
	dbf	d0,cop_prep_rouls
	rts

prep_sprite	bsr	dec_sprite
	bsr	prep_eff_blks
	rts
	
dec_sprite	lea	sprite(pc),a0
	lea	buf_sprite(pc),a1
	moveq	#15,d1
lp_pass1	movem.w	(a0)+,d2-d5
	move.w	d2,d6
	or.w	d3,d6
	or.w	d4,d6
	or.w	d5,d6
	not.w	d6
	move.w	d6,(a1)+
	move.w	d6,(a1)+
	movem.w	d2-d5,(a1)
	lea	8(a1),a1
	move.l	#-1,(a1)+
	clr.l	(a1)+
	clr.l	(a1)+
	dbf	d1,lp_pass1
	lea	-24*16(a1),a0
	move.w	#15*16-1,d1
lp_pass2	moveq	#3,d7
	moveq	#0,d2
	moveq	#0,d5
	moveq	#0,d6
lp_pass3	move.w	4(a0),d3
	swap	d3
	move.w	16(a0),d3
	ror.l	#1,d3
	or.w	d3,d6
	move.w	d3,16(a1)
	swap	d3
	or.w	d3,d5
	move.w	d3,4(a1)
	addq.l	#2,a0
	addq.l	#2,a1
	dbf	d7,lp_pass3
	not.w	d5
	not.w	d6
	move.w	d5,-8(a1)
	move.w	d5,-6(a1)
	move.w	d6,4(a1)
	move.w	d6,6(a1)
	lea	16(a0),a0
	lea	16(a1),a1
	dbf	d1,lp_pass2
	rts
	
prep_eff_blks	bsr	save_blocks
	bsr	swap_adr_blk
	bsr	new_coords
	bsr	save_blocks
	bsr	swap_adr_blk
	rts

sync_high	move.w	sr,-(a7)
	move.w	#$2700,sr
	move.b	#1,$fffffa07.w
	move.b	#1,$fffffa13.w
	clr.b	$fffffa09.w
	clr.b	$fffffa15.w
	move.l	#hbl_sync,$68.w
	move.l	#vbl_sync,$70.w
	move.l	#timerb_sync,$120.w
	stop	#$2300
wait_sync_high	cmp.w	#$4e73,vbl_sync
	bne.s	wait_sync_high
	bsr	clear_inter
	subq.b	#2,delay_cpt
	rte

hbl_sync	addq.w	#1,d0
	rte

vbl_sync	move.w	#$2100,sr
	moveq	#0,d0
	move.b	delay_cpt(pc),$fffffa21.w
	move.b	#4,$fffffa1b.w
	rtr
	
timerb_sync	move.w	#$2300,sr
	clr.b	$fffffa1b.w
	subq.b	#1,delay_cpt
	cmp.w	#32,d0
	bne.s	no_sync
	move.w	#$4e73,vbl_sync
no_sync	rtr
	
set_inter1	move.w	#$2300,-(a7)
	move.w	#$2700,sr
	bsr	clear_kb
	lea	kb_mouse(pc),a0
	bsr	set_acia
	move.b	#1,$fffffa07.w
	move.b	#1,$fffffa13.w
	move.l	#vbl_sub1,vbl_sub
	move.l	#vbl,$70.w
	rte
	
clear_kb	btst	#0,$fffffc00.w
	beq.s	empty_kb
	move.b	$fffffc02.w,d0
	bsr	att_acia
	bra.s	clear_kb
empty_kb	rts

set_acia	btst	#1,$fffffc00.w
	beq.s	set_acia
	move.b	(a0)+,d0
	bmi.s	end_kb
	move.b	d0,$fffffc02.w
	bsr	att_acia
	bra.s	set_acia
end_kb	rts

att_acia	moveq	#32,d0
lp_acia	dbf	d0,lp_acia
	rts
	
main1	bsr	cols_on
	bsr	lp_but
	rts

cols_on	lea	pal_logo_reps,a0
	lea	buf_pal_logo(pc),a1
	lea	table_fade(pc),a2
	bsr	fade_col
	lea	pal_scr1(pc),a0
	lea	buf_pal_scr(pc),a1
	lea	table_fade(pc),a2
	bsr	fade_col
	clr.w	eff_col_roul
	rts

fade_col	movem.l	d0/a2,-(a7)
lp_fade_on1	moveq	#time_eff_col2-1,d0
wait_eff	bsr	vsync
	dbf	d0,wait_eff
	bsr	fade_1
	cmp.b	#-1,(a2)
	bne.s	lp_fade_on1
ret_fade	movem.l	(a7)+,d0/a2
	rts
	
fade_1	movem.l	d0/a0-a1/a3,-(a7)
	move.l	a2,a3
	moveq	#15,d0
lp_fade_on2	bsr	fade_2
	addq.l	#2,a0
	addq.l	#2,a1
	dbf	d0,lp_fade_on2
	movem.l	(a7)+,d0/a0-a1/a3
	rts
	
fade_2	movem.l	d1-d3,-(a7)
	move.l	a3,a2
lp_fade_on3	moveq	#0,d1
	move.b	(a2)+,d1
	beq.s	no_more_col
	move.w	(a0),d2
	and.w	#$777,d2
	move.w	(a1),d3
	and.w	#$777,d3
	subq.b	#1,d1
	lsl.w	#2,d1
	lsr.w	d1,d2
	lsr.w	d1,d3
	and.w	#$f,d2
	and.w	#$f,d3
	cmp.w	d2,d3
	beq.s	col_sui
	bgt.s	sub_col
add_col	addq.w	#1,d3
	bra.s	col_sui
sub_col	subq.w	#1,d3
col_sui	lsl.w	d1,d3
	moveq	#$f,d2
	lsl.w	d1,d2
	not.w	d2
	and.w	d2,(a1)
	or.w	d3,(a1)
	bra.s	lp_fade_on3
no_more_col	movem.l	(a7)+,d1-d3
	rts

lp_but	
	ifne	play_music
	ifne	multi_music
	bsr	chg_music
	endc
	endc
	cmp.w	#2,mouse_buttons
	bne.s	lp_but
	move.w	mouse_xy(pc),d0
	move.w	mouse_xy+2(pc),d1
	ifne	trainer_mode=0
	lea	but1(pc),a0
	bsr	tst_but
	bmi.s	lp_but
	rts
	elseif
	lea	but2(pc),a0
	bsr	tst_but
	bmi.s	no_but2
	moveq	#0,d0
	bra.s	but_end
no_but2	lea	but3(pc),a0
	bsr	tst_but
	bmi.s	lp_but
	moveq	#1,d0
but_end	move.w	d0,choice_tr
	rts
	endc

tst_but	moveq	#-1,d2
	cmp.w	(a0)+,d0
	blt.s	no_but
	cmp.w	(a0)+,d1
	blt.s	no_but
	cmp.w	(a0)+,d0
	bgt.s	no_but
	cmp.w	(a0)+,d1
	bgt.s	no_but
	move.l	(a0),a0
	move.w	#$567,(a0)
	moveq	#0,d2
no_but	tst.l	d2
	rts

	ifne	play_music
	ifne	multi_music
chg_music	lea	key(pc),a0
	lea	key_music(pc),a1
	lea	cpt_music(pc),a2
	btst	#7,1(a0)
	beq.s	press_mus
	clr	(a1)
	bra.s	rt_chg_music
press_mus	cmp.w	#$3b,(a0)
	bne.s	rt_chg_music
	tst.w	(a1)
	bne.s	rt_chg_music
	st	(a1)
	addq.w	#1,(a2)
	cmp.w	#nbr_music,(a2)
	ble.s	max_music_ok
	clr	(a2)
max_music_ok	move.l	#vbl_sub2,adr_music_rel
	bsr	prep_music
rt_chg_music	rts
	endc
	endc

	ifne	trainer_mode=2
set_inter2	move.l	#vbl_sub2,vbl_sub
	rts
	
prep_scr2	bsr	fonts_4p_1p
	move.l	scr+4(pc),a0
	bsr	clear_scr
	bsr	aff_block
	bsr	aff_text_tr
	bsr	inv_video_1l
	bsr	scr1_eff
	bsr	scr2_aff
	rts
	
fonts_4p_1p	lea	fonts(pc),a0
	move.w	#59*8-1,d0
lp_fnt_1p	move.b	(a0),d1
	or.b	1(a0),d1
	or.b	2(a0),d1
	or.b	3(a0),d1
	move.b	d1,(a0)+
	clr.b	(a0)+
	clr.b	(a0)+
	clr.b	(a0)+
	dbf	d0,lp_fnt_1p
	rts
	
aff_block	move.l	scr+4(pc),a1
	add.l	adr_block(pc),a1
	lea	buf_blk_tr(pc),a0
	lea	blocks(pc),a3
lp_block2	move.l	a1,a2
lp_block1	moveq	#0,d0
	move.w	(a0)+,d0
	beq.s	end_line_blk
	lsl.l	#6,d0
	lea	-64(a3,d0.l),a4
	move.l	a2,a5
	moveq	#7,d0
cop_blk	move.l	(a4)+,(a5)+
	move.l	(a4)+,(a5)+
	lea	160-8(a5),a5
	dbf	d0,cop_blk
	lea	8(a2),a2
	bra.s	lp_block1
end_line_blk	lea	160*8(a1),a1
	cmp.w	#-1,(a0)
	bne.s	lp_block2
	rts

aff_text_tr	lea	text_tr(pc),a0
	lea	fonts(pc),a1
	move.l	scr+4(pc),a2
	add.l	adr_block(pc),a2
	moveq	#nbr_trainer,d0
lp_aff_fnt_tr	lea	160*8(a2),a2
	moveq	#2,d1
	bsr	aff_1_line
	addq.l	#1,a0
	dbf	d0,lp_aff_fnt_tr
	move.l	scr+4(pc),a2
	add.l	adr_block(pc),a2
	lea	buf_tr(pc),a3
	moveq	#nbr_trainer-1,d0
aff_etat_lp	lea	160*8(a2),a2
	bsr	aff_etat_rt
	lea	12(a3),a3
	dbf	d0,aff_etat_lp
	rts
	
aff_etat_rt	movem.l	d1/a0/a3,-(a7)
	tst.w	(a3)+
	bne.s	tr_type2
tr_type1	tst.w	(a3)
	bne.s	etat_on
	lea	off(pc),a0
	bra.s	aff_etat_tr
etat_on	lea	on(pc),a0
	bra.s	aff_etat_tr
tr_type2	addq.l	#4,a3
	move.w	(a3)+,d1
	move.l	a3,a0
	bsr	set_num_text
aff_etat_tr	moveq	#23,d1
	bsr	aff_1_line
	movem.l	(a7)+,d1/a0/a3
	rts
	
set_num_text	movem.l	d0-d2/a0,-(a7)
	moveq	#2,d0
	move.l	#100,d2
calc_deca	and.l	#$ffff,d1
	divu	d2,d1
	add.b	#$30,d1
	move.b	d1,(a0)+
	swap	d1
	divu	#10,d2
	dbf	d0,calc_deca	
	move.b	#1,(a0)
	movem.l	(a7)+,d0-d2/a0
	rts

inv_video_1l	move.l	scr+4(pc),a2
	add.l	adr_block(pc),a2
	lea	160*8+8(a2),a2
	move.w	pt_cursor(pc),d1
	subq.w	#1,d1
	mulu	#160*8,d1
	lea	0(a2,d1.l),a3
	bsr	plan1_2
	rts

scr1_eff	move.l	scr(pc),a0
	move.l	a0,a1
	add.l	#(haut_reps+4)*160,a0
	add.l	#273*160,a1
	moveq	#(274-(haut_reps+4))/2-1,d0
lp1_scr2	bsr	vsync
	moveq	#39,d1
lp2_scr2	clr.l	(a0)+
	clr.l	(a1)+
	dbf	d1,lp2_scr2
	lea	-160*2(a1),a1
	dbf	d0,lp1_scr2
	rts

scr2_aff	movem.l	pal_scr2(pc),d0-d7
	movem.l	d0-d7,buf_pal_scr
	move.l	scr+4(pc),a0
	move.l	scr(pc),a1
	add.l	#((haut_reps+4)+(274-(haut_reps+4))/2-1)*160,a0
	add.l	#((haut_reps+4)+(274-(haut_reps+4))/2-1)*160,a1
	lea	160(a0),a2
	lea	160(a1),a3
	moveq	#(3+nbr_trainer)*4,d0
lp3_scr2	bsr	vsync
	moveq	#39,d1
lp4_scr4	move.l	(a0)+,(a1)+
	move.l	(a2)+,(a3)+
	dbf	d1,lp4_scr4
	lea	-160*2(a0),a0
	lea	-160*2(a1),a1
	dbf	d0,lp3_scr2
	rts

main2	clr.l	mouse_xy
lp_main2	bsr	vsync
	bsr	cursor_flash
	bsr	cursor_press
	bsr	cursor_move
	ifne	play_music
	ifne	multi_music
	bsr	chg_music
	endc
	endc
	tst.w	att_play
	beq.s	lp_main2
	rts
	
cursor_flash	subq.w	#1,att_eff3
	bne.s	no_swap_col2
	move.w	#time_eff_col3,att_eff3
	move.l	adr_swap_col(pc),a0
	move.l	curs_col(pc),a1
	move.l	adr_tab_fade2(pc),a3
	bsr	fade_2
	cmp.b	#-1,(a2)
	bne.s	no_swap_col
	movem.l	adr_swap_col(pc),a0-a1
	exg	a0,a1
	movem.l	a0-a1,adr_swap_col
	lea	table_fade(pc),a2
no_swap_col	move.l	a2,adr_tab_fade2
no_swap_col2	rts
	
cursor_move	lea	mouse_xy+2(pc),a0
	lea	pt_cursor(pc),a1
	move.w	(a0),d0
	moveq	#0,d1
	move.w	(a1),d1
	cmp.w	#-sensib_mouse,d0
	blt.s	up
	cmp.w	#+sensib_mouse,d0
	ble.s	no_cursor
down	cmp.w	#nbr_trainer+1,d1
	beq.s	clear_cursor
	addq.w	#1,(a1)
	bra.s	cursor_sui
up	cmp.w	#1,d1
	beq.s	clear_cursor
	subq.w	#1,(a1)
cursor_sui	move.l	scr(pc),a2
	add.l	adr_block(pc),a2
	lea	160*8+8(a2),a2
	subq.w	#1,d1
	mulu	#160*8,d1
	lea	0(a2,d1.l),a3
	bsr	plan2_1
	move.w	(a1),d1
	subq.w	#1,d1
	mulu	#160*8,d1
	lea	0(a2,d1.l),a3
	bsr	plan1_2
clear_cursor	clr.w	(a0)
no_cursor	rts

plan2_1	movem.l	d0-d2/a3,-(a7)
	moveq	#7,d0
pl_lp1	moveq	#11,d1
pl_lp2	move.w	(a3),d2
	or.w	4(a3),d2
	or.w	6(a3),d2
	and.w	2(a3),d2
	move.w	d2,2(a3)
	not.w	d2
	or.w	d2,(a3)
	addq.l	#8,a3
	dbf	d1,pl_lp2
	lea	160-(12*8)(a3),a3
	dbf	d0,pl_lp1
	movem.l	(a7)+,d0-d2/a3
	rts
	
plan1_2	movem.l	d0-d2/a3,-(a7)
	moveq	#7,d0
pl_lp3	moveq	#11,d1
pl_lp4	move.w	2(a3),d2
	or.w	4(a3),d2
	or.w	6(a3),d2
	and.w	(a3),d2
	move.w	d2,(a3)
	not.w	d2
	or.w	d2,2(a3)
	addq.l	#8,a3
	dbf	d1,pl_lp4
	lea	160-(12*8)(a3),a3
	dbf	d0,pl_lp3
	movem.l	(a7)+,d0-d2/a3
	rts
	
cursor_press	lea	mouse_buttons(pc),a0
	lea	sensib_r(pc),a1
	lea	etat_repeat(pc),a2
	tst.w	(a0)
	bne.s	repeat_m1
	move.w	#1,(a2)
	clr	(a1)
	bra	no_press
repeat_m1	tst.w	(a1)
	beq.s	repeat_m2
	subq.w	#1,(a1)
	bra	no_press
repeat_m2	cmp.w	#3,(a0)
	beq	no_press
	tst.w	(a2)
	beq.s	repeat_m3
	move.w	#sensib_repeat,(a1)
	clr	(a2)
repeat_m3	lea	pt_cursor(pc),a1
	move.l	scr(pc),a2
	add.l	adr_block(pc),a2
	lea	160*8(a2),a2
	lea	buf_tr(pc),a3
	lea	blocks+4*64(pc),a4
	moveq	#0,d0
	move.w	(a1),d0
	cmp.w	#nbr_trainer+1,d0
	beq	press_play
	subq.w	#1,d0
	move.l	d0,d1
	mulu	#12,d1
	add.l	d1,a3
	mulu	#8*160,d0
	add.l	d0,a2
	lea	88(a2),a5
	moveq	#7,d0
cl_etat_tr	move.l	(a4),(a5)+
	move.l	4(a4),(a5)+
	move.l	(a4),(a5)+
	move.l	4(a4),(a5)+
	lea	160-16(a5),a5
	dbf	d0,cl_etat_tr
	cmp.w	#2,(a0)
	bne.s	press_d
press_g	tst.w	(a3)
	bne.s	type2_2
type1_2	clr	2(a3)
	bra.s	aff_etat_tr2
type2_2	move.w	6(a3),d0
	subq.w	#1,d0
	cmp.w	2(a3),d0
	blt.s	aff_etat_tr2
	move.w	d0,6(a3)
	bra.s	aff_etat_tr2
press_d	tst.w	(a3)
	bne.s	type2_3
type1_3	move.w	#1,2(a3)
	bra.s	aff_etat_tr2
type2_3	move.w	6(a3),d0
	addq.w	#1,d0
	cmp.w	4(a3),d0
	bgt.s	aff_etat_tr2
	move.w	d0,6(a3)
aff_etat_tr2	lea	fonts(pc),a1
	bsr	aff_etat_rt
	lea	88(a2),a3
	bsr	plan1_2_2
no_press	rts

press_play	move.w	#1,att_play
	move.l	curs_col(pc),a0
	move.w	#$777,(a0)
	rts

plan1_2_2	movem.l	d0-d2/a3,-(a7)
	moveq	#7,d0
pl_lp5	moveq	#1,d1
pl_lp6	move.w	2(a3),d2
	or.w	4(a3),d2
	or.w	6(a3),d2
	and.w	(a3),d2
	move.w	d2,(a3)
	not.w	d2
	or.w	d2,2(a3)
	addq.l	#8,a3
	dbf	d1,pl_lp6
	lea	160-(2*8)(a3),a3
	dbf	d0,pl_lp5
	movem.l	(a7)+,d0-d2/a3
	rts	
	endc
	
colors_off	move.w	#1,eff_col_roul
	lea	black(pc),a0
	lea	buf_pal_roul(pc),a1
	lea	table_fade(pc),a2
	bsr	fade_col
	lea	black(pc),a0
	lea	buf_pal_scr(pc),a1
	bsr	fade_col
	lea	black(pc),a0
	lea	buf_pal_logo(pc),a1
	bsr	fade_col
	rts	
	
restore_inter	move.w	#$2300,-(a7)
	move.w	#$2700,sr
	lea	sav_error(pc),a0
	lea	$8.w,a1
	moveq	#9,d0
reset_error	move.l	(a0)+,(a1)+
	dbf	d0,reset_error
	lea	sav_mfp(pc),a0
	move.b	(a0)+,$fffffa07.w
	move.b	(a0)+,$fffffa09.w
	move.b	(a0)+,$fffffa13.w
	move.b	(a0)+,$fffffa15.w
	move.b	(a0)+,$fffffa17.w
	move.b	(a0)+,$fffffa1b.w
	move.b	(a0)+,$fffffa21.w
	bsr	clear_kb
	lea	sav_vecs(pc),a0
	move.l	(a0)+,$118.w
	move.l	(a0)+,$70.w
	move.l	(a0)+,$68.w
	move.l	(a0)+,$120.w
	bsr.s	clear_yam
	rte
	
clear_yam	lea	$ffff8800.w,a0
	move.l	#$1010000,(a0)
	move.l	#$2020000,(a0)
	move.l	#$3030000,(a0)
	move.l	#$4040000,(a0)
	move.l	#$5050000,(a0)
	move.l	#$6060000,(a0)
	move.l	#$707ffff,(a0)
	move.l	#$8080000,(a0)
	move.l	#$9090000,(a0)
	move.l	#$a0a0000,(a0)
	move.l	#$b0b0000,(a0)
	move.l	#$c0c0000,(a0)
	move.l	#$d0d0000,(a0)
	rts

	ifne	memory=0
tst_memory	cmp.l	#$80000,$42e.w
	bgt.s	mem_ok
	move.w	sav_rez(pc),d0
	move.l	sav_scr(pc),a0
	bsr	set_scr_rez
	lea	alert_mem(pc),a0
	bsr	aff_txt
	move.w	#$2700,sr
mem_blk	bra.s	mem_blk
mem_ok	rts
	endc

restore_scr	clr.l	$426.w
	clr.l	$42a.w
	move.w	sav_rez(pc),d0
	move.l	sav_scr(pc),a0
	bsr	set_scr_rez
	move.w	#200*40-1,d0
clear_scr_f	clr.l	(a0)+
	dbf	d0,clear_scr_f
	ifne	after_intro
	move.b	#7,$484.w
	dc.w	$a009
	endc
	lea	sav_pal(pc),a0
	lea	$ffff8240.w,a1
	lea	table_fade(pc),a2
	bsr	fade_col
	rts
	
key_rout	move.w	#$2400,sr
	btst	#0,$fffffc00.w
	beq.s	not_ready1
	move.w	d0,-(a7)
	clr.w	d0
	move.b	$fffffc02.w,d0
	cmp.w	#$f8,d0
	blt.s	keyboard
	cmp.w	#$fb,d0
	bgt.s	no_key
	and.w	#3,d0
	move.w	d0,mouse_buttons
	move.l	#set_mouse_x,$118.w
no_key	move.w	(a7)+,d0
not_ready1	rte
	
keyboard	move.w	d0,key
	move.w	(a7)+,d0
	rte

set_mouse_x	move.w	#$2400,sr
	btst	#0,$fffffc00.w
	beq.s	not_ready2
	move.w	d0,-(a7)
	move.b	$fffffc02.w,d0
	ext.w	d0
	add.w	d0,mouse_xy
	move.l	#set_mouse_y,$118.w
	move.w	(a7)+,d0
not_ready2	rte
	
set_mouse_y	move.w	#$2400,sr
	btst	#0,$fffffc00.w
	beq.s	not_ready3
	move.w	d0,-(a7)
	move.b	$fffffc02.w,d0
	ext.w	d0
	add.w	d0,mouse_xy+2
	move.l	#key_rout,$118.w
	move.w	(a7)+,d0
not_ready3	rte
	
timerb_high	movem.l	d0/a0,-(a7)
	move.w	#$2700,sr
	bclr	#6,$fffffa15.w
	clr.b	$fffffa1b.w
	stop	#$2100
	stop	#$2100
	move.w	#$2700,sr
	moveq	#29,d0
lose_time1	dbf	d0,lose_time1
	clr.b	$ffff820a.w
	moveq	#2,d0
lose_time2	dbf	d0,lose_time2
	move.b	#2,$ffff820a.w
	bset	#6,$fffffa15.w
	move.l	#timerb_pal_scr,$120.w
	move.b	#(haut_reps+4),$fffffa21.w
	move.b	#8,$fffffa1b.w
	movem.l	(a7)+,d0/a0
	rte
	
timerb_pal_scr	move.l	buf_pal_scr,$ffff8240.w
	move.l	buf_pal_scr+4,$ffff8244.w
	move.l	buf_pal_scr+8,$ffff8248.w
	move.l	buf_pal_scr+12,$ffff824c.w
	move.l	buf_pal_scr+16,$ffff8250.w
	move.l	buf_pal_scr+20,$ffff8254.w
	move.l	buf_pal_scr+24,$ffff8258.w
	move.l	buf_pal_scr+28,$ffff825c.w
	clr.b	$fffffa1b.w
	move.l	#timerb_rasters,$120.w
	move.b	#1,$fffffa21.w
	move.b	#8,$fffffa1b.w
	rte
	
timerb_rasters	move.w	$0,$ffff8240.w
	addq.l	#2,timerb_rasters+2
	subq.w	#1,cpt_rasters
	bne.s	no_inst_low
	move.l	#timerb_low,$120.w
no_inst_low	rte

timerb_low	move.w	#$2700,sr
	movem.l	a0-a1/d0,-(sp)
	move.l	timerb_rasters+2(pc),a0
	move.w	(a0)+,$ffff8240.w
	lea	$fffffa21.w,a1
	clr.b	$fffffa1b.w
	move.b	#2,(a1)
	move.b	#8,$fffffa1b.w
	move.b	(a1),d0
lose_time3	cmp.b	(a1),d0
	beq.s	lose_time3
	clr.b	$ffff820a.w
	move.w	(a0)+,$ffff8240.w
	moveq	#3,d0
lose_time4	dbf	d0,lose_time4
	move.b	#2,$ffff820a.w
	clr.b	$fffffa1b.w
	move.l	a0,timerb_rasters2+2
	move.l	#timerb_rasters2,$120.w
	move.b	#1,(a1)
	move.b	#8,$fffffa1b.w
	movem.l	(sp)+,a0-a1/d0
	rte

timerb_rasters2	move.w	$0,$ffff8240.w
	addq.l	#2,timerb_rasters2+2
	subq.w	#1,cpt_ras_fin
	beq.s	fin_ras
	rte
	
fin_ras	clr.b	$fffffa1b.w
	rte
	
vbl	clr.b	$fffffa1b.w
	move.l	#timerb_high,$120.w
	move.b	delay_cpt(pc),$fffffa21.w
	move.b	#4,$fffffa1b.w
	movem.l	d0-a6,-(a7)
	bsr	inits
	bsr	rouleaux
	bsr	key_mouse
	move.l	vbl_sub(pc),a0
	jsr	(a0)
	bsr	col_rouleaux
	ifne	play_music
	move.l	adr_music_rel(pc),a0
	jsr	(a0)
	endc
	movem.l	(a7)+,d0-a6
	rte
	
vbl_sub1	bsr	swap_scr
	bsr	eff_mouses
	bsr	new_coords
	bsr	save_blocks
	bsr	swap_adr_blk
	bsr	scroll
	bsr	aff_mouses
vbl_sub2	rts
	
inits	addq.l	#1,$466.w
	move.l	#buf_col_roul,timerb_rasters+2
	move.w	#227-(haut_reps+4),cpt_rasters
	move.w	#30,cpt_ras_fin
	movem.l	buf_pal_logo(pc),d0-d7
	movem.l	d0-d7,$ffff8240.w
	rts
	
swap_scr	lea	scr(pc),a0
	movem.l	(a0),d0-d1
	exg	d0,d1
	movem.l	d0-d1,(a0)
	ror.l	#8,d0
	lea	$ffff8200.w,a0
	movep.w	d0,1(a0)
	rts
	
key_mouse	move.w	key,d0
	moveq	#speed_key_m,d1
	ifne	trainer_mode=2
	tst.w	choice_tr
	beq.s	no_tr_key
	btst	#7,d0
	beq.s	press
	move.w	#1,wt_key_tr
	bra.s	no_tr_key
press	subq.w	#1,wt_key_tr
	bne.s	k7
	move.w	#sens_key_tr,wt_key_tr
	moveq	#sensib_mouse*2+1,d1
	endc
no_tr_key	lea	mouse_xy(pc),a0
	lea	mouse_buttons(pc),a1
	lea	flag_m_b(pc),a2
	tst.w	(a2)
	beq.s	k1
	clr.w	(a2)
	clr.w	(a1)
k1	cmp.w	#$48,d0
	bne.s	k2
	sub.w	d1,2(a0)
k2	cmp.w	#$50,d0
	bne.s	k3
	add.w	d1,2(a0)
k3	cmp.w	#$4b,d0
	bne.s	k4
	sub.w	d1,(a0)
k4	cmp.w	#$4d,d0
	bne.s	k5
	add.w	d1,(a0)
k5	cmp.w	#$52,d0
	bne.s	k6
	st	(a2)
	move.w	#2,(a1)
k6	cmp.w	#$47,d0
	bne.s	k7
	st	(a2)
	move.w	#1,(a1)
k7	rts	
	
eff_mouses	lea	buf_coord(pc),a0
	lea	scr(pc),a1
	move.l	buf_blocks(pc),a2
	moveq	#nbr_mouses-1,d0
lp_eff_mouses	moveq	#0,d1
	moveq	#0,d2
	movem.w	(a0),d1-d2
	move.l	(a1),a3
	asr.l	#4,d1
	asl.l	#3,d1
	add.l	d1,a3
	mulu	#160,d2
	add.l	d2,a3
	moveq	#15,d1
cop_block	movem.l	(a2),d4-d7
	movem.l	d4-d7,(a3)
	lea	16(a2),a2
	lea	160(a3),a3
	dbf	d1,cop_block
	lea	decal_mouse*4(a0),a0
	dbf	d0,lp_eff_mouses
	rts

new_coords	lea	buf_coord(pc),a0
	lea	4(a0),a1
	move.w	#(nbr_mouses-1)*decal_mouse,d0
cop_coord	move.l	(a1)+,(a0)+
	dbf	d0,cop_coord
	lea	mouse_xy(pc),a1
	move.w	(a1),d0
	move.w	2(a1),d1
	cmp.w	#x_min,d0
	bge.s	x_ok1
	move.w	#x_min,d0
x_ok1	cmp.w	#x_max,d0
	ble.s	x_ok2
	move.w	#x_max,d0
x_ok2	cmp.w	#y_min,d1
	bge.s	y_ok1
	move.w	#y_min,d1
y_ok1	cmp.w	#y_max,d1
	ble.s	y_ok2
	move.w	#y_max,d1
y_ok2	move.w	d0,(a0)+
	move.w	d0,(a1)+
	move.w	d1,(a0)
	move.w	d1,(a1)
	rts

save_blocks	lea	buf_coord(pc),a0
	lea	scr(pc),a1
	move.l	buf_blocks(pc),a2
	moveq	#nbr_mouses-1,d0
lp_save_blks	moveq	#0,d1
	moveq	#0,d2
	movem.w	4(a0),d1-d2
	move.l	(a1),a3
	asr.l	#4,d1
	asl.l	#3,d1
	add.l	d1,a3
	mulu	#160,d2
	add.l	d2,a3
	moveq	#15,d1
cop_sav_block	movem.l	(a3),d4-d7
	movem.l	d4-d7,(a2)
	lea	160(a3),a3
	lea	16(a2),a2
	dbf	d1,cop_sav_block
	lea	decal_mouse*4(a0),a0
	dbf	d0,lp_save_blks
	rts
	
swap_adr_blk	lea	buf_blocks(pc),a0
	movem.l	(a0),d0-d1
	exg	d0,d1
	movem.l	d0-d1,(a0)
	rts
	
aff_mouses	lea	buf_coord(pc),a0
	lea	scr(pc),a1
	lea	buf_sprite(pc),a2
	moveq	#nbr_mouses-1,d0
lp_aff_mouses	moveq	#0,d1
	moveq	#0,d2
	movem.w	4(a0),d1-d2
	move.l	(a1),a4
	mulu	#160,d2
	add.l	d2,a4
	divu	#16,d1
	move.w	d1,d2
	mulu	#8,d2
	add.l	d2,a4
	swap	d1
	mulu	#16*24,d1
	lea	0(a2,d1.l),a3
	moveq	#15,d1
	cmp.w	#152,d2
	beq.s	aff_sprite2
	cmp.w	#160,d2
	beq.s	no_aff
aff_sprite	movem.l	(a3)+,d2-d7
	and.l	d2,(a4)
	or.l	d3,(a4)+
	and.l	d2,(a4)
	or.l	d4,(a4)+
	and.l	d5,(a4)
	or.l	d6,(a4)+
	and.l	d5,(a4)
	or.l	d7,(a4)+
	lea	144(a4),a4
	dbf	d1,aff_sprite
no_aff	lea	decal_mouse*4(a0),a0
	dbf	d0,lp_aff_mouses	
	rts

aff_sprite2	movem.l	(a3)+,d2-d4
	and.l	d2,(a4)
	or.l	d3,(a4)+
	and.l	d2,(a4)
	or.l	d4,(a4)+
	lea	152(a4),a4
	lea	12(a3),a3
	dbf	d1,aff_sprite2
	lea	decal_mouse*4(a0),a0
	dbf	d0,lp_aff_mouses	
	rts
	
rouleaux	lea	buf_col_roul(pc),a0
	move.w	#280/2-1,d0
eff_buf_roul	clr.l	(a0)+
	dbf	d0,eff_buf_roul
	lea	pt_sinus(pc),a0
	move.l	(a0),a1
	cmp.l	#buf_sinus+(end_sinus-sinus_roul)*2,a1
	bne.s	no_cl_pt_sin
	move.l	#buf_sinus+nbr_rouleaux*2,(a0)
no_cl_pt_sin	addq.l	#2,(a0)
	lea	buf_col_roul(pc),a0
	moveq	#nbr_rouleaux-1,d1
cop_rouls	move.w	(a1),d0
	ext.l	d0
	lea	0(a0,d0.l),a2
	lea	buf_pal_roul(pc),a3
	moveq	#15,d2
cop_col_roul	move.w	(a3)+,(a2)+
	dbf	d2,cop_col_roul
	lea	2*decal_roul(a1),a1
	dbf	d1,cop_rouls
	rts
	
col_rouleaux	tst.w	eff_col_roul
	bne.s	no_eff
	tst.w	att_eff
	beq.s	eff
	subq.w	#1,att_eff
	bra.s	no_eff
eff	subq.w	#1,att_eff2
	bne.s	no_eff
	move.w	#time_eff_col2,att_eff2
	move.l	adr_pal_roul(pc),a0
	lea	buf_pal_roul(pc),a1
	move.l	adr_table_fade(pc),a2
	bsr	fade_1
	cmp.b	#-1,(a2)
	bne.s	col_not_done
	lea	32(a0),a0
	lea	table_fade(pc),a2
	move.w	#time_eff_col1,att_eff
	cmp.l	#end_pal_roul,a0
	bne.s	not_again
	lea	pal_rouleaux(pc),a0
not_again	move.l	a0,adr_pal_roul
col_not_done	move.l	a2,adr_table_fade
no_eff	rts

scroll	bsr	dec_buf_scroll
	bsr	aff_scroll
	rts

dec_buf_scroll	lea	pt_new_fnt(pc),a0
	lea	pt_scrtxt(pc),a1
	move.l	(a1),a2
	subq.w	#1,(a0)
	bne.s	scrtxt_ct1
	move.w	#8,(a0)
	addq.l	#1,a2
	tst.b	(a2)
	bne.s	scrtxt_ct1
	lea	scrtxt(pc),a2
scrtxt_ct1	move.l	a2,(a1)
	move.w	(a0),d2
	subq.w	#1,d2
	lea	buf_scroll(pc),a3
	moveq	#0,d0
	move.b	(a2),d0
	sub.b	#$20,d0
	lsl.l	#5,d0
	lea	fonts(pc),a2
	add.l	d0,a2
	moveq	#7,d0
lp_scrtxt1	moveq	#3,d1
lp_scrtxt2	move.b	(a2)+,d3
	lsr.b	d2,d3
	roxr.b	#1,d3
var	set	136
	rept	17
	roxl.w	var(a3)
var	set	var-8	
	endr
	roxl.w	(a3)
	lea	2(a3),a3
	dbf	d1,lp_scrtxt2
	lea	136(a3),a3
	dbf	d0,lp_scrtxt1
	rts
	
aff_scroll	lea	buf_scroll(pc),a0
	move.l	scr(pc),a1
	add.l	#(pos_scroll+4)*160+8,a1
	moveq	#7,d0
cop_scroll1	rept	36
	move.l	(a0)+,(a1)+
	endr
	lea	16(a1),a1
	dbf	d0,cop_scroll1
	rts	

	ifne	trainer_mode
trainer	lea	buf_tr(pc),a0
	lea	$200.w,a1
	moveq	#nbr_trainer-1,d0
lp_cop_t	tst.w	(a0)
	bne.s	cop_t2
cop_t1	tst.w	2(a0)
	beq.s	cl_t
	st	(a1)+
	bra.s	t_cop_ct
cl_t	sf	(a1)+
	bra.s	t_cop_ct
cop_t2	move.b	7(a0),(a1)+
t_cop_ct	lea	12(a0),a0
	dbf	d0,lp_cop_t
	rts
	endc

	even
	ifne	trainer_mode=2
pt_cursor	dc.w	1
adr_tab_fade2	dc.l	table_fade
adr_swap_col	dc.l	buf_pal_scr+3*2
	dc.l	buf_pal_scr+11*2
curs_col	dc.l	buf_pal_scr+2*2
att_eff3	dc.w	time_eff_col3
sensib_r	dc.w	0
etat_repeat	dc.w	1
att_play	dc.w	0
buf_blk_tr	dc.w	1,2,2,2,2,2,2,2,2,2,2,2,2,3,0
	rept	nbr_trainer+1
	dc.w	4,5,5,5,5,5,5,5,5,5,5,5,5,6,0
	endr
	dc.w	7,8,8,8,8,8,8,8,8,8,8,8,8,9,0
	dc.w	-1
	even
adr_block	dc.l	((((274+haut_reps+4)-8*(3+nbr_trainer))/2)*160)+24
buf_tr	dcb.w	6,0
	dcb.w	6,0
	dcb.w	6,0
	dcb.w	6,0
	dc.w	1,1,3,1,0,0
	dc.w	1,0,3,0,0,0
	dc.w	1,0,3,0,0,0
	dc.w	1,0,3,0,0,0
	dc.w	1,0,3,0,0,0
	dc.w	1,0,3,0,0,0
	dc.w	1,0,3,0,0,0
	dc.w	1,0,3,0,0,0
	dc.w	1,1,9,1,0,0
	* type 0 : 0,0,0,0,0,0
	* type 1 : type,level min,level max,level init,0,0
	even
on	dc.b	"ON",1
off	dc.b	"OFF",1
	even
text_tr	dc.b	"INFINITE TIME",1
	dc.b	"INFINITE LIVES",1
	dc.b	"INFINITE ENERGY",1
	dc.b	"INGAME CHEAT MODE",1
	dc.b	"MAGIC POTION 1",1
	dc.b	"MAGIC POTION 2",1
	dc.b	"MAGIC POTION 3",1
	dc.b	"MAGIC POTION 4",1
	dc.b	"MAGIC POTION 5",1
	dc.b	"MAGIC POTION 6",1
	dc.b	"MAGIC POTION 7",1
	dc.b	"MAGIC POTION 8",1
	dc.b	"LEVEL SELECTION",1
	dc.b	"          PLAY",1
	endc
	even
text	dc.b	"ARE PROUD TO BRING YOU",1
	dc.b	1
	dc.b	">>> CREATURES <<<",1
	dc.b	1
	dc.b	"ALL WORK DONE BY ORION",1
	dc.b	"SUPPLY BY A GOOD FRIEND",1
	dc.b	1
	dc.b	"INTRO CODED & DESIGNED BY ORION",1
	dc.b	1
	dc.b	"IF YOU'RE LOOKING FOR GAMES ON :",1
	dc.b	"ATARI ST, AMIGA, PC OR SUPER NINTENDO",1
	dc.b	"THEN CONTACT US AT :",1
	dc.b	1
	dc.b	"- THE REPLICANTS -",1
	dc.b	"BP 66 59420 MOUVAUX FRANCE",1
	dc.b	1
	dc.b	"- THE REPLICANTS -",1
	dc.b	"BP 17 B-4420 MONTEGNEE BELGIUM",1
	dc.b	0
	even
pt_new_fnt	dc.w	1
pt_scrtxt	dc.l	scrtxt-1
buf_scroll	ds.b	8*144
scrtxt	dc.b	"                      THE CRACKIN'MACHINE REPLICANTS FROM THE WELLKNOWN UNION BRING YA      >>> CREATURES <<<     CRACKED, MEGATRAINED, LINKFILED & REPACKED BY ORION.   "
	dc.b	"ORIGINAL SUPPLIED BY A GOOD FRIEND.             LITTLE INTRO CODED BY ORION ( USE MOUSE OR ARROW KEYS TO CONTROL THE CURSOR & F1 TO CHANGE THE MUSIC ).       "
	dc.b	"THE MEMBERS OF THE REPLICANTS ARE AT NOW : ELLFIRE ( SWAPPER, ORIGINAL SUPPLIER & BUSINESS MAN ! ), ORION ( CRACKER & CODER ), CELTIK ( SWAPPER, ORIGINAL SUPPLIER & PROFESSIONAL KILLER ! ), "
	dc.b	"CAMEO ( CRACKER, CODER & X-MOVIES ACTRESS ! ), JACK ( SWAPPER, ORIGINAL SUPPLIER & MAYBE ICS SPY ... ), MR BUG ( CRACKER, CODER & BEER DRINKER ! ), LITTLE GUY ( ORIGINAL SUPPLIER ), SNAKE ( ? ), COBRA ( ? ) & R-AL ( ? )."
	dc.b	"          IF YOU WANT TO BE IN CONTACT WITH US FOR ANY REASONS ( FOR EXAMPLE TO SEND TO US MONEY ... ) THEN WRITE TO :    - THE REPLICANTS -      B.P  66     59420     MOUVAUX       FRANCE        "
	dc.b	"OR WRITE TO      - THE REPLICANTS -    B.P 17    B-4420    MONTEGNEE    BELGIUM         YOU CAN CALL THIS BBS :   RISKY BUSINESS     +44-51 353 02 99       AND THE FRENCH PEOPLE CAN ALSO CALL US "
	dc.b	"AT THIS NUMBER :    48-94-11-11    BOITE VOCALE DAMNED ( SUIVRE LES INSTRUCTIONS ) POUR LAISSER UN MESSAGE, UTILISER LE CODE : 206 270               "
	dc.b	"NOW LET'S START THE GREETINGS :   FUZION ( ESPECIALLY ORION, ELLFIRE & CELTIK ... ), MAD VISION ( SPY3 & DEF KLF ), SYNDICATE ( REDZONE ( THX FOR THE LOGO ) ), TSB ( DOCNO ), PASSWORDS ( LAURENZO ), DIAMOND DESIGN, "
	dc.b	"BAD BOYS BELGIUM, CONAN, ANIMAL MINE, PULSION, PURE ENERGY ( BFG & HARLEQUIN ), D-BUG, CYNIX, ELITE, POMPEY PIRATES, SUPERIOR, MATRIX OF THUNDERFORCE, CYBERNETIX, FANATICS, THE ULTIMATE, SECTION ONE, DEWY, KEOPS, "
	dc.b	"STORM BRINGERS, TRS, GOGO, E.S.C, DNT-CREW, THE RAILBOYS, MCS, TCS & V-TECH                 BIG HELLO TO THESE NICE GUYS : BDS, TRICKLE, HAVOK, LUDOVIC & J.B. OF POSITIVITY, ZAPOVER, THYS ELROY & BLUEMAX          "
	dc.b	"LETHAL FUCK TO THE ICS ( BETTER KNOWN AS : ITALIAN COCK SUCKERS OR FOR FRENCH PEOPLE : INTELLIGENCE COMPLETEMENT SOUS-DEVELOPPEE ... )               LET'S CRACK, LET'S RULE, LET'S WRAP !!!            "
	dc.b	"- REPLICANTS THE 07/02/1993 - ORION SIGNING OFF -                                                      "
	dc.b	0
	even
alert_mono	dc.b	27,"E",27,"Y",32,32
	dc.b	"THIS PROGRAM DOES NOT WORK IN HIGH RESOLUTION !",0
	even
alert_error	dc.b	27,"E",27,"Y",32,32
	dc.b	"SORRY BUT A FATAL ERROR AS OCCURED !",10,13
	dc.b	"HOWEVER YOU CAN PLAY THE GAME",10,13
	dc.b	"BY PRESSING THE SPACE KEY !",10,13
	dc.b	"BUT IF YOU WANT AN INTRO WHICH RUNS",10,13
	dc.b	"ON YOUR COMPUTER YOU CAN WRITE TO ",10,13
	dc.b	"- THE REPLICANTS -",10,13
	dc.b	"BP 66 59420 MOUVAUX FRANCE",10,13
	dc.b	27,"Y",32,32
	dc.b	0
	even
	ifne	memory=0
alert_mem	dc.b	27,"E",27,"Y",32,32
	dc.b	"THIS GAME NEEDS ONE MEGABYTE TO WORK !",0
	even
	endc
	ifne	trainer_mode=0
but1	dc.w	128,238,192,270
	dc.l	buf_pal_scr+8*2
	elseif
but2	dc.w	64,238,128,270
	dc.l	buf_pal_scr+8*2
but3	dc.w	192,238,256,270
	dc.l	buf_pal_scr+9*2
choice_tr	ds.w	1
wt_key_tr	dc.w	sens_key_tr
	endc
	ifne	aff_union
pal_logo_union	dc.w	$000,$027,$555,$333,$222,$772,$752,$742
	dc.w	$632,$237,$777,$005,$553,$453,$442,$432
	endc
pal_logo_reps	dc.w	$000,$200,$300,$410,$520,$631,$742,$752
	dc.w	$764,$775,$070,$070,$070,$070,$070,$070
pal_scr1	dc.w	$0,$770,$660,$550,$440,$330,$220,$110
	dc.w	$123,$123,$012,$123,$234,$345,$456,$567
	ifne	trainer_mode=2
pal_scr2	dc.w	$0,$234,$123,$777,$0,$0,$0,$0
	dc.w	$0,$002,$012,$123,$234,$345,$456,$567
	endc
pal_rouleaux	dc.w	$100,$200,$300,$401,$502,$603,$604,$605
	dc.w	$506,$406,$306,$205,$104,$003,$002,$001
	dc.w	$010,$020,$030,$141,$252,$363,$464,$565
	dc.w	$656,$646,$636,$525,$414,$303,$202,$101
	dc.w	$001,$002,$003,$004,$005,$006,$007,$017
	dc.w	$017,$007,$006,$005,$004,$003,$002,$001
	dc.w	$001,$002,$003,$014,$025,$036,$046,$056
	dc.w	$065,$064,$063,$052,$041,$030,$020,$010
	dc.w	$100,$200,$300,$410,$520,$630,$640,$650
	dc.w	$560,$460,$360,$250,$140,$030,$020,$010
end_pal_roul	even
black	ds.w	16
table_fade	dc.b	3,0,3,0,3,2,0,3,2,0,3,2,1,0,3,2,1,0
	dc.b	3,2,1,0,3,2,1,0,2,1,0,2,1,0,1,0,1,0
	dc.b	-1
	even
buf_pal_logo	ds.w	16
buf_pal_scr	ds.w	16
buf_pal_roul	ds.w	16
buf_coord	rept	2+(nbr_mouses-1)*decal_mouse
	dc.w	x0,y0
	endr
buf_blocks	dc.l	buf_block1
	dc.l	buf_block2
buf_block1	ds.b	16*16*nbr_mouses
buf_block2	ds.b	16*16*nbr_mouses
buf_sprite	ds.b	16*24*16
pt_sinus	dc.l	buf_sinus
adr_pal_roul	dc.l	pal_rouleaux
adr_table_fade	dc.l	table_fade
att_eff2	dc.w	time_eff_col2
att_eff	dc.w	0
eff_col_roul	dc.w	1
sinus_roul	dcb.b	nbr_rouleaux,20
	dc.b	20,20,20,20,20,21,21,22,23,23
	dc.b	24,25,26,28,29,30,32,33,35,36
	dc.b	38,40,42,44,46,48,50,52,55,57
	dc.b	59,62,64,67,70,72,75,77,80,83
	dc.b	86,88,91,94,97,99,102,105,108,111
	dc.b	113,116,119,122,124,127,129,132,135,137
	dc.b	139,142,144,147,149,151,153,155,157,159
	dc.b	161,163,164,166,167,169,170,171,173,174
	dc.b	175,176,176,177,178,178,179,179,179,179
	dc.b	180,179,179,179,179,178,178,177,176,176
	dc.b	175,174,173,171,170,169,167,166,164,163
	dc.b	161,159,157,155,153,151,149,147,144,142
	dc.b	140,137,135,132,129,127,124,122,119,116
	dc.b	113,111,108,105,102,100,97,94,91,88
	dc.b	86,83,80,77,75,72,70,67,64,62
	dc.b	59,57,55,52,50,48,46,44,42,40
	dc.b	38,36,35,33,32,30,29,28,26,25
	dc.b	24,23,23,22,21,21,20,20,20,20
end_sinus	dc.b	0
	even
buf_sinus	ds.w	(buf_sinus-sinus_roul)*2
buf_col_roul	ds.w	280
cpt_rasters	ds.w	1
cpt_ras_fin	ds.w	1
key	ds.w	1
kb_mouse	dc.b	8,$b,1,1,-1
kb_prep	dc.b	$11,$12,$1a,-1
	even
	ifne	play_music
	ifne	multi_music
key_music	ds.w	1
cpt_music	dc.w	num_music
buf_num_music	dc.b	0,1,2,3,4,5
	even
	endc
adr_music_rel	ds.l	1
nb_music	dc.w	num_music
	endc
mouse_xy	dc.w	x0,y0
mouse_buttons	ds.w	1
flag_m_b	ds.w	1
cpt_mouse_xy	ds.w	1
delay_cpt	dc.b	104
	even
vbl_sub	ds.l	1
scr	ds.l	2
sav_pal	ds.w	16
sav_scr	ds.l	1
sav_rez	ds.w	1
sav_mfp	ds.b	8
sav_vecs	ds.l	4
sav_error	ds.l	10
sav_sp_error	ds.l	1
	even
sprite	incbin	\orion.src\reps.crk\mouse\sprite.dat
	even
fonts	incbin	\orion.src\reps.crk\mouse\fonts.dat
	even
reps_logo	incbin	\orion.src\reps.crk\mouse\reps2.dat
	even
buttons	incbin	\orion.src\reps.crk\mouse\buttons.dat
	even
	ifne	trainer_mode=2
blocks	incbin	\orion.src\reps.crk\mouse\blocks.dat
	endc
	even
scr_bdr	incbin	\orion.src\reps.crk\mouse\scr_bdr.dat
	even
	ifne	aff_union
logo_union	incbin	\orion.src\reps.crk\mouse\union.dat
	endc
	even
	ifne	play_music
music	incbin	\orion.src\reps.crk\mouse\monty.mus
end_music
	endc
	even
	ifne	after_intro=2
buffer_prog	;incbin	b:\game
	endc
	even
buf_scr	
	end