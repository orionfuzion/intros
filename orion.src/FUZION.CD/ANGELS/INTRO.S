	*************************************
	* Intro      Angels                 *
	* Coder      ORION from FUZION      *
	* Usage      FUZION Compact Disks   *
	* Date       Mars 1992 - CD#137     *
	*                                   *
	* Machine    Atari STE - 1MB RAM    *	
	* TOS        1.62                   *
	* Assembler  GenST v2.09            *
	* Emulator   Steem v3.2             *
	*                                   *
	* Contact    Orion.Fuzion@gmail.com *
	*************************************

magic_number	=	$4545
test	=	0
scr	=	$70000
largeur_centre	=	120
hauteur_centre	=	80
decalage_stars	=	50
nbr_stars	=	180

pt_base	move.l	sp,sav_usp
	lea	scr-$1000,sp
	pea	intro(pc)
	move	#$26,-(sp)
	trap	#14
	addq.l	#6,sp
	move.l	sav_usp(pc),sp

	bra	load
		
intro	bsr	save_all
	bsr	set_scr
	bsr	prec_def_ver
	bsr	prec_def_pos
	bsr	prec_log_def
	bsr	prec_log_pos
	bsr	prec_ret_fnt
	bsr	prec_col
	bsr	prec_neige
	bsr	prec_stars
	bsr	set_reset
	bsr	inter_on
loop	tst.w	tst_tche
	beq.s	loop
	bsr	inter_off
	rts

save_all	move.l	$24(a1),buffer_load+14
	move.l	$44e.w,sav_screen
	move.b	$ffff8260.w,sav_rez+1
	move.b	$ffff820a.w,sav_hz
	movem.l	$ffff8240.w,d0-d7
	movem.l	d0-d7,sav_pal
	lea	$fffffa01.w,a0
	lea	mfp(pc),a1
	moveq	#$e,d0
cop_mfp	move.b	(a0)+,(a1)+
	lea	1(a0),a0
	dbf	d0,cop_mfp
	move.b	8(a0),(a1)+
	move.b	10(a0),(a1)+
	move.b	12(a0),(a1)+
	move.b	14(a0),(a1)+
	move.b	16(a0),(a1)+
	lea	$ffff8800.w,a0
	lea	yam(pc),a1
	moveq	#$f,d0
cop_yam	move.b	d0,(a0)
	move.b	(a0),(a1)+
	dbf	d0,cop_yam
	move.l	$70.w,sav_vbl
	move.l	$120.w,sav_timer_b
	move.l	$110.w,sav_timer_d
	rts

inter_on	moveq	#1,d7
	bsr	vsync
	lea	scr,a0
	move.w	#300*40-1,d0
eff_scr	clr.l	(a0)+
	dbf	d0,eff_scr
	move.w	#$2700,sr
	move.b	#1,$fffffa07.w	
	clr.b	$fffffa09.w
	move.b	#1,$fffffa0b.w
	clr.b	$fffffa0d.w
	move.b	#1,$fffffa13.w
	clr.b	$fffffa15.w
	bsr	set_music
	move.b	#$40,$fffffa17.w
	move.b	#$12,$fffffc02.w
	move.l	#vbl,$70.w
	move.w	#$2300,sr
	rts

inter_off	move.w	#$2700,sr
	lea	mfp(pc),a0
	lea	$fffffa01.w,a1
	moveq	#$e,d0
set_mfp	move.b	(a0)+,(a1)+
	lea	1(a1),a1
	dbf	d0,set_mfp
	move.b	(a0)+,8(a1)
	move.b	(a0)+,10(a1)
	move.b	(a0)+,12(a1)
	move.b	(a0)+,14(a1)
	move.b	(a0)+,16(a1)
	move.l	sav_vbl(pc),$70.w
	move.l	sav_timer_b(pc),$120.w
	move.l	sav_timer_d(pc),$110.w
	move.b	#$8,$fffffc02.w
	move.b	sav_hz(pc),$ffff820a.w
	lea	$ffff8800.w,a0
	move.l	#$0707ffff,(a0)
	move.l	#$08080000,(a0)
	move.l	#$09090000,(a0)
	move.l	#$0a0a0000,(a0)
	move.w	#$2300,sr
	
	moveq	#0,d0
	moveq	#7,d1
cop_col4	moveq	#3,d7
	bsr	vsync
	lea	$ffff8240.w,a0
	moveq	#15,d2
cop_col3	move.w	d0,(a0)+
	dbf	d2,cop_col3
	add.w	#$111,d0
	dbf	d1,cop_col4
	
	move.w	sav_rez(pc),-(sp)
	move.l	sav_screen(pc),-(sp)
	move.l	(sp),-(sp)
	move.w	#5,-(sp)
	trap	#14
	lea	12(sp),sp
	
	movem.l	sav_pal(pc),d0-d7
	movem.l	d0-d7,$ffff8240.w
	move.b	#7,$484.w
	clr.l	$426.w
	clr.l	$42a.w
	
	rts	

set_music	moveq	#test,d1
	lea	$5.w,a0
	cmp.b	#$fc,(a0)
	bne.s	ste
	moveq	#1,d1	
ste	lea	part,a0
	moveq	#1,d0
	jsr	play
	rts	

set_reset	move.l	#$31415926,$426.w
	move.l	#reset_jmp,$42a.w
	rts
	
reset_jmp	lea	scr-$19600,sp
	bsr	re_inst
	bsr	set_neige
	bsr	inter_neige
	
	clr.l	$426.w
	clr.l	$42a.w
	
blk	bra.s	blk
	
re_inst	move.w	#$2700,sr
	
	movem.l	black(pc),d0-d7
	movem.l	d0-d7,$ffff8240.w
	move.b	#2,$ffff820a.w
	clr.b	$ffff8260.w
	lea	scr_neige(pc),a0
	move.b	1(a0),$ffff8201.w
	move.b	2(a0),$ffff8203.w
	move.b	#$13,$fffffc02.w
	
	move.l	#ret_vbl,$70.w
	lea	yam(pc),a0
	lea	$ffff8800.w,a1
	moveq	#$f,d0
set_yam	move.b	d0,(a1)
	move.b	(a0)+,2(a1)
	dbf	d0,set_yam
	
	lea	mfp(pc),a0
	lea	$fffffa01.w,a1
	moveq	#$e,d0
set_mfp_res	move.b	(a0)+,(a1)+
	lea	1(a1),a1
	dbf	d0,set_mfp_res
	move.b	(a0)+,8(a1)
	move.b	(a0)+,10(a1)
	move.b	(a0)+,12(a1)
	move.b	(a0)+,14(a1)
	move.b	(a0)+,16(a1)
	
	move.w	#$2300,sr
	rts
	
set_neige	move.l	buf_neige(pc),a0
	lea	scr-$18600,a1
	moveq	#1,d1
	move.w	#250-1,d0
cop_neige	movem.l	(a0)+,d2-d7/a2-a5
	movem.l	d2-d7/a2-a5,(a1)
	lea	40(a1),a1
	dbf	d0,cop_neige
	lea	scr-$18600,a0
	move.w	#3500,d0
	dbf	d1,cop_neige
	
	rts
	
inter_neige	move.w	#$2700,sr	
	clr.b	$fffffa13.w
	clr.b	$fffffa15.w
	clr.b	$fffffa07.w
	move.l	#vbl_neige,$70.w
	move.w	#$2300,sr
	rts
	
vbl_neige	lea	$ffff8260.w,a5		
	lea	$ffff820a.w,a6		
	moveq	#0,d6		
	moveq	#2,d7		
	
	move.w	#1432,d0
wait_o_h	dbf	d0,wait_o_h
	
	move.b	d6,(a6)
	dcb.w	9,$4e71
	move.b	d7,(a6)
	
	moveq	#14,d2
	lea	-1(a6),a6
	move.b	(a6),d0
wait_scan	move.b	(a6),d1
	cmp.b	d0,d1
	beq.s	wait_scan
	and.b	#%00011111,d1
	sub.b	d1,d2
	lsl.b	d2,d1
	lea	1(a6),a6

	dcb.w	93-3,$4e71
	
	move.w	#226,d0
	
loop_full1	nop
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	dcb.w	89,$4e71
	move.b	d6,(a6)
	move.b    	d7,(a6)
	dcb.w	13,$4e71
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	dcb.w	12-4,$4e71
	dbf	d0,loop_full1
	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	dcb.w	89,$4e71
	move.b	d6,(a6)
	move.b	d7,(a6)
	dcb.w	13,$4e71
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	
	move.b	d6,(a6)
	dcb.w	9,$4e71
	move.b	d7,(a5)
	move.b	d7,(a6)
	move.b	d6,(a5)
	dcb.w	89,$4e71
	move.b	d6,(a6)
	move.b	d7,(a6)
	dcb.w	13,$4e71
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	dcb.w	12-2,$4e71
	
	move.w	#43,d0
	
loop_full2	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	dcb.w	89,$4e71
	move.b	d6,(a6)
	move.b	d7,(a6)
	dcb.w	13,$4e71
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	dcb.w	12-3,$4e71
	dbf	d0,loop_full2
	
	lea	scr_neige(pc),a0
	move.b	1(a0),$ffff8201.w
	move.b	2(a0),$ffff8203.w
	add.l	#$100,(a0)
	cmp.l	#scr-$10000,(a0)
	bne.s	swap_rt
	move.l	#scr-$18600,(a0)
	
swap_rt	movem.l	pal_neige(pc),d0-d7
	movem.l	d0-d7,$ffff8240.w
	
ret_vbl	rte
	
set_scr	dc.w	$a00a
	clr.b	$484.w
	move.b	#$13,$fffffc02.w
	move.w	#$777,d0
	moveq	#7,d1
cop_col2	moveq	#3,d7
	bsr	vsync
	lea	$ffff8240.w,a0
	moveq	#15,d2
cop_col1	move.w	d0,(a0)+
	dbf	d2,cop_col1
	sub.w	#$111,d0
	dbf	d1,cop_col2
	clr	-(sp)
	pea	scr
	move.l	(sp),-(sp)
	move	#5,-(sp)
	trap	#14
	lea	12(sp),sp
	lea	pres_col(pc),a0
	lea	scr+160*92,a1
	move.w	#40*16-1,d0
cop_pres	move.l	(a0)+,(a1)+
	dbf	d0,cop_pres
	
	lea	buf_all(pc),a0
	moveq	#-1,d0
eff_shits	clr.l	(a0)+
	dbf	d0,eff_shits
	
	moveq	#10,d7
	bsr	vsync
	
	move.w	#$2700,sr
	move.l	#vbl_pres,$70.w
	move.w	#$2300,sr
	
	rts
	
vsync	clr.l	$466.w
wait_vbl	cmp.l	$466.w,d7
	bne.s	wait_vbl
	rts
	
vbl_pres	movem.l	d0/a0-a1,-(sp)
	subq.w	#1,att_vbl_p
	bne	ret_vbl_p
	move.w	#4,att_vbl_p
	lea	rot_col(pc),a0
	lea	pt_rot(pc),a1
	add.l	(a1),a0
	subq.l	#2,(a1)
	bne.s	rot_sui
	move.l	#2,(a1)
rot_sui	lea	$ffff8242.w,a1
	moveq	#14,d0
cop_rot_col	move.w	(a0)+,(a1)+
	dbf	d0,cop_rot_col
ret_vbl_p	movem.l	(sp)+,d0/a0-a1
	addq.l	#1,$466.w
	rte
	
prec_def_ver	lea	cd_num(pc),a0
	move.l	buf_def_ver(pc),a1
	move.l	#46*3*28,d0
	add.l	a1,d0
	move.l	d0,buf_def_pos
	moveq	#27,d6
p_d_v2	move.l	a0,a2
	lea	28(a0),a3
	move.b	(a2),d0
	and.b	#$f,d0
	move.b	d0,(a1)+
	moveq	#42,d2
	bsr	p_d_v1
	move.b	(a2),d0
	and.b	#$f0,d0
	move.b	d0,(a1)+
	clr.b	(a1)+
	move.l	a0,a2
	move.l	a0,a3
	clr.b	(a1)+
	moveq	#43,d2
	bsr	p_d_v1
	clr.b	(a1)+
	lea	28(a0),a2
	move.l	a0,a3
	move.b	(a3),d0
	and.b	#$f0,d0
	clr.b	(a1)+
	move.b	d0,(a1)+
	moveq	#42,d2
	bsr	p_d_v1
	move.b	(a3),d0
	and.b	#$f,d0
	move.b	d0,(a1)+
	addq.l	#1,a0
	dbf	d6,p_d_v2
	rts

p_d_v1	move.b	(a3),d0
	and.b	#$f,d0
	move.b	(a2),d1
	and.b	#$f0,d1
	or.b	d0,d1
	move.b	d1,(a1)+
	lea	28(a2),a2
	lea	28(a3),a3
	dbf	d2,p_d_v1
	rts
	
prec_def_pos	lea	sinus_ver(pc),a0
	move.l	buf_def_pos(pc),a1
	move.l	#(end_sinus_ver-sinus_ver)*8+56*8,d0
	add.l	a1,d0
	move.l	d0,buf_log_def
	move.l	a1,a2
	move.l	#160*5+26,d2
lp_prec_def_p	moveq	#0,d0
	move.b	(a0)+,d0
	moveq	#0,d1	
	move.b	(a0),d1
	addq.b	#1,d1
	mulu	#46,d1
	ext.w	d0
	ext.l	d0
	muls	#160,d0
	add.l	d0,d2
	move.l	d2,(a1)+
	move.l	d1,(a1)+
	cmp.b	#$7f,1(a0)
	bne.s	lp_prec_def_p
	move.w	#111,d0
cop_p_d_p	move.l	(a2)+,(a1)+
	dbf	d0,cop_p_d_p
	rts

prec_log_def	lea	logo(pc),a0
	move.l	buf_log_def(pc),a1
	move.l	#42*64*16*3,d0
	add.l	a1,d0
	move.l	d0,buf_log_pos
	move.l	a1,a2
	moveq	#63,d1
p_l_d2	moveq	#19,d0
p_l_d5	clr.w	(a2)+
	dbf	d0,p_l_d5
	moveq	#19,d0
p_l_d1	move.w	(a0)+,(a2)+
	dbf	d0,p_l_d1
	moveq	#19,d0
p_l_d6	clr.w	(a2)+
	dbf	d0,p_l_d6
	dbf	d1,p_l_d2
	move.w	#64*15-1,d1
p_l_d4	roxr.w	d7
	moveq	#59,d0
p_l_d3	move.w	(a1)+,(a2)
	roxr.w	(a2)+
	dbf	d0,p_l_d3
	dbf	d1,p_l_d4
	rts
	
prec_log_pos	lea	sinus_log(pc),a0
	move.l	buf_log_pos(pc),a1
	move.l	#(end_sinus_log-sinus_log)*4,d0
	add.l	a1,d0
	move.l	d0,buf_ret_fnt
	moveq	#0,d1
	move.l	#40,d0
p_l_p3	add.b	(a0)+,d1
	tst.b	d1
	bge.s	p_l_p1
	add.b	#$10,d1
	addq.w	#2,d0
p_l_p1	cmp.b	#$f,d1
	ble.s	p_l_p2
	sub.b	#$10,d1
	subq.w	#2,d0
p_l_p2	move.l	d1,d2
	mulu	#120*64,d2
	add.l	d0,d2
	move.l	d2,(a1)+
	cmp.b	#$7f,(a0)
	bne.s	p_l_p3
	
	rts

prec_ret_fnt	lea	fonts(pc),a0
	move.l	buf_ret_fnt(pc),a3
	move.l	#16*2*16*72,d0
	add.l	a3,d0
	move.l	d0,buf_hbl_col
	moveq	#71,d0
p_r_f4	lea	table_ret_fnt,a1
	move.l	a1,a5
	moveq	#8,d7
	moveq	#1,d6
p_r_f5	moveq	#$f,d1
	sub.b	d7,d1
	asl.w	#1,d1
	lea	0(a3,d1.l),a6
p_r_f3	move.l	a5,a2
	moveq	#0,d1
	move.b	(a1)+,d1
	asl.w	#1,d1
	lea	-2(a0,d1.l),a4
	move.w	(a4),d4
	moveq	#0,d5
	move.l	d7,d2
p_r_f2	moveq	#16,d3
	sub.b	(a2)+,d3
	btst	d3,d4
	beq.s	p_r_f1
	bset	d2,d5
p_r_f1	subq.b	#1,d2
	tst.b	(a2)
	bne.s	p_r_f2
	move.w	d5,(a6)+
	tst.b	(a1)
	bne.s	p_r_f3
	eor.b	#1,d6
	add.l	d6,d7
	lea	1(a1),a1
	move.l	a1,a5
	lea	32(a3),a3
	cmp.b	#$7f,(a1)
	bne.s	p_r_f5
	lea	32(a0),a0
	dbf	d0,p_r_f4
	
	rts
	
prec_neige	move.l	buf_neige(pc),a6
	move.l	#10000,d0
	add.l	a6,d0
	move.l	d0,adr_pos_stars
	move.w	#10000/8-1,d7
cop_n1	move.w	#$11,-(sp)
	trap	#14
	addq.l	#2,sp
	move.l	d0,(a6)+
	move.l	d1,(a6)+
	dbf	d7,cop_n1
	rts	
	
prec_stars	move.l	adr_pos_stars(pc),a6
	move.l	#nbr_stars*8+8,a5
	add.l	a6,a5
	move.l	a5,buf_stars
	move.l	#nbr_stars-1,d7
stars_loop	move	#$11,-(sp)
	trap	#14
	addq.l	#2,sp
	swap	d0
	clr	d0
	swap	d0
	move.l	d0,d2
	divu	#largeur_centre,d0
	swap	d0
	sub.w	#largeur_centre/2,d0
	clr.w	d1
	swap	d1
	divu	#hauteur_centre,d1
	swap	d1
	sub.w	#hauteur_centre/2,d1
	tst.w	d0
	bne.s	no_centre
	tst.w	d1
	beq.s	stars_loop
no_centre	cmp.w	#nbr_stars/2,d7
	bgt.s	star_high
star_low	tst	d1
	bgt.s	y_sui
	neg.w	d1
	bra.s	y_sui
star_high	tst	d1
	blt.w	y_sui
	neg.w	d1
y_sui	divu	#decalage_stars,d2
	clr	d2
	swap	d2
	mulu	#4,d2
	move.l	a5,(a6)
	add.l	d2,(a6)+
	move.l	a5,(a6)+
	move.l	#$100,d2
	ext.l	d0
	asl.w	#8,d0
	ext.l	d1
	asl.w	#8,d1
star_loop	move.l	d0,d5
	move.l	d1,d6
	divs	d2,d5
	divs	d2,d6
	subq.w	#3,d2
	add.w	#160,d5
	ext.l	d5
	add.w	#120,d6
	cmp.w	#319,d5
	bhi.s	star_next
	cmp.w	#240,d6
	bhi.s	star_next
	mulu	#$a0,d6
	divu	#16,d5
	move.w	d5,d3
	clr	d5
	swap	d5
	divu	#8,d5
	add.w	d5,d6
	swap	d5
	neg.w	d5
	addq.w	#7,d5
	move.w	d5,(a5)+
	mulu	#8,d3
	add.w	d3,d6
	move.w	d6,(a5)+
	bra.s	star_loop
star_next	dbf	d7,stars_loop
	move.l	a5,(a6)+
	move.l	a5,(a6)+
	rts	

prec_col	lea	col_stars(pc),a0
	lea	col_def+2(pc),a1
	lea	col_logo+2(pc),a2
	move.l	buf_hbl_col(pc),a4
	move.l	#200*40,d0
	add.l	a4,d0
	move.l	d0,buf_neige
	move.w	#34,d0
	bsr	cop_hbl
	lea	col_text(pc),a1
	move.l	a1,a2
	move.w	#62,d0
	bsr	cop_hbl
	move.l	#hbl1,-8(a4)
	move.l	a4,set_hbl+2
	lea	hbl1(pc),a5
	move.w	(a0)+,2(a5)
	move.w	(a1),8(a5)
	move.w	(a1)+,10(a5)
	move.w	(a2),16(a5)
	move.w	(a2),18(a5)
	move.w	(a2),24(a5)
	move.w	(a2)+,26(a5)
	lea	col(pc),a5
	move.w	(a0)+,2(a5)
	move.w	(a1),8(a5)
	move.w	(a1)+,10(a5)
	move.w	(a2),16(a5)
	move.w	(a2),18(a5)
	move.w	(a2),24(a5)
	move.w	(a2)+,26(a5)
	move.w	#20,d0
	bsr	cop_hbl
	move.l	#hbl3,-8(a4)
	rts
	
cop_hbl	move.w	#$31fc,(a4)+
	move.w	(a0)+,(a4)+
	move.w	#$8242,(a4)+
	move.w	#$21fc,(a4)+
	move.w	(a1),(a4)+
	move.w	(a1)+,(a4)+
	move.w	#$8244,(a4)+
	move.w	#$21fc,(a4)+
	move.w	(a2),(a4)+
	move.w	(a2),(a4)+
	move.w	#$8248,(a4)+
	move.w	#$21fc,(a4)+
	move.w	(a2),(a4)+
	move.w	(a2)+,(a4)+
	move.w	#$824c,(a4)+
	move.w	#$21fc,(a4)+
	lea	8(a4),a5
	move.l	a5,(a4)+
	move.l	#$1204e73,(a4)+
	dbf	d0,cop_hbl
	rts
	
hbl1	move.w	#0,$ffff8242.w
	move.l	#0,$ffff8244.w
	move.l	#0,$ffff8248.w
	move.l	#0,$ffff824c.w
	clr.b	$fffffa1b.w
	move.b	#1,$fffffa21.w
	move.l	#hbl2,$120.w
	move.b	#8,$fffffa1b.w	
	rte
	
hbl2	move.w	#$2700,sr
	movem.l	a0/d0,-(sp)
	lea	$fffffa21.w,a0
	clr.b	$fffffa1b.w
	move.b	#2,(a0)
	move.b	#8,$fffffa1b.w
	move.b	(a0),d0
same_line	cmp.b	(a0),d0
	beq.s	same_line
	clr.b	$ffff820a.w
	dcb.w	18,$4e71
	move.b	#2,$ffff820a.w
col	move.w	#0,$ffff8242.w
	move.l	#0,$ffff8244.w
	move.l	#0,$ffff8248.w
	move.l	#0,$ffff824c.w
	clr.b	$fffffa1b.w
	move.b	#2,$fffffa21.w
set_hbl	move.l	#0,$120.w
	move.b	#8,$fffffa1b.w
	movem.l	(sp)+,a0/d0
	move.w	#$2300,sr
	rte
	
hbl3	rte	
	
vbl	bsr	init
	bsr	def_ver
	bsr	eff_fnt
	bsr	aff_fnt
	bsr	aff_stars
	bsr	move_logo
	bsr	eff_text
	jsr	play+8
	bsr	tche
	rte	
	
init	lea	col_def(pc),a0
	lea	col_logo(pc),a1
	lea	$ffff8244.w,a2
	move.w	(a0),(a2)+
	move.w	(a0),(a2)+
	move.w	(a1),(a2)+
	move.w	(a1),(a2)+
	move.w	(a1),(a2)+
	move.w	(a1),(a2)+
	clr.b	$fffffa1b.w
	move.b	#2,$fffffa21.w
	move.l	buf_hbl_col(pc),$120.w
	move.b	#8,$fffffa1b.w
	rts
	
def_ver	move.l	buf_def_ver(pc),a0
	move.l	buf_def_pos(pc),a1
	lea	scr,a2
	lea	pt_def_pos(pc),a3
	add.l	(a3),a1
	addq.l	#8,(a3)
	cmp.l	#(end_sinus_ver-sinus_ver)*8,(a3)
	bne.s	def_sui
	clr.l	(a3)
def_sui	moveq	#1,d7
	moveq	#27,d0
lp_def	move.l	(a1)+,d1
	move.l	(a1)+,d2
	lea	0(a2,d1.l),a3
	lea	0(a0,d2.l),a4
	clr.b	-160(a3)
	clr.b	160*46(a3)
var	set	0
	rept	46
	move.b	(a4)+,var(a3)
var	set	var+160
	endr
	lea	46*3(a0),a0
	lea	8(a1),a1
	add.l	d7,a2
	eor.b	#6,d7
	dbf	d0,lp_def
	rts
	
move_logo	move.l	buf_log_def(pc),a0
	move.l	buf_log_pos(pc),a1
	lea	pt_log_pos(pc),a2
	add.l	(a2),a1
	addq.l	#4,(a2)
	cmp.l	#(end_sinus_log-sinus_log)*4,(a2)
	bne.s	move_log2
	clr.l	(a2)
move_log2	add.l	(a1),a0
	lea	scr+4,a1
	moveq	#63,d0
var	set	0
move_log3	rept	20
	move.w	(a0)+,var(a1)
var	set	var+8
	endr
	lea	80(a0),a0
	lea	160(a1),a1
	dbf	d0,move_log3
	
	rts
	
eff_fnt	lea	pos_fnt_sav+10(pc),a1
	lea	scr+160*80+2,a2
	moveq	#14,d0
lp_eff	move.l	(a1),d1
	lea	0(a2,d1.l),a3
var	set	0
	rept	16
	clr.w	var(a3)
	clr.w	var+8(a3)
var	set	var+160
	endr
	lea	10(a1),a1
	dbf	d0,lp_eff
	rts
	
aff_fnt	move.l	adr_effet(pc),a0
	lea	pt_table(pc),a2
	cmp.l	#215,(a2)
	beq	no_aff_fnt
	add.l	(a2),a0
	addq.l	#1,(a2)
	lea	pos_fnt_sav+10(pc),a1
	addq.l	#2,(a1)
	
	moveq	#0,d0
	move.b	15(a0),d0
	subq.b	#1,d0
	divu	#20,d0
	move.w	d0,d1
	subq.w	#5,d1
	swap	d0
	sub.w	#9,d0
	ext.l	d1
	mulu	#160,d1
	ext.l	d1
	move.l	#160*16*5+8*9,15*10(a1)
	move.b	#0,15*10+4(a1)
	move.b	d0,15*10+5(a1)
	move.l	d1,15*10+6(a1)
	
	move.l	adr_text(pc),d6
	lea	scr+160*80+2,a2
	move.l	buf_ret_fnt(pc),a3
	moveq	#15,d7	
	
lp_aff_fnt	moveq	#0,d0
	move.b	(a0)+,d0
	beq	no_aff
	exg	d6,a0
	move.b	-1(a0,d0.l),d0
	exg	d6,a0
	sub.b	#$20,d0
	mulu	#16*2*16,d0
	move.l	d7,d1
	mulu	#16*2,d1
	add.l	d1,d0
	move.l	(a1),d1
	moveq	#0,d2
	move.b	4(a1),d2
	add.b	5(a1),d2
	tst.b	d2
	bge.s	a_f2
	subq.l	#8,d1
	add.b	#16,d2
	bra.s	a_f3
a_f2	cmp.b	#$f,d2
	ble.s	a_f3
	addq.l	#8,d1
	sub.b	#16,d2
a_f3	add.l	6(a1),d1
	move.l	d1,-10(a1)
	move.b	d2,-6(a1)
	move.b	5(a1),-5(a1)
	move.l	6(a1),-4(a1)
	lea	0(a3,d0.l),a4
	lea	0(a2,d1.l),a5
	divu	#8,d2
	move.w	d2,d3
	mulu	#8,d3
	swap	d2
	
var	set	0	
	rept	16
	moveq	#0,d0
	move.w	(a4)+,d0
	swap	d0
	lsr.l	d2,d0
	lsr.l	d3,d0
	or.w	d0,var+8(a5)
	swap	d0
	or.w	d0,var(a5)
var	set	var+160
	endr
	
no_aff	lea	10(a1),a1
	dbf	d7,lp_aff_fnt
	
no_aff_fnt	rts
	
eff_text	lea	pt_table(pc),a0
	cmp.l	#215,(a0)
	bne	no_eff_text
	lea	pt_wait(pc),a1
	tst.w	(a1)
	beq.s	eff_sui
	subq.w	#1,(a1)
	bra	no_eff_text
eff_sui	lea	adr_eff_scr(pc),a2
	move.l	(a2),d1
	cmp.l	#160*79,d1
	bne.s	eff_sui2
	move.l	#160*160,(a2)
	move.l	#160*161,4(a2)
	move.w	#32*10,(a1)
	clr.l	(a0)
	lea	pt_text(pc),a0
	move.l	nbr_text(pc),d0
	cmp.l	(a0),d0
	bne.s	txt_sui
	clr.l	(a0)
txt_sui	move.l	(a0),d0
	mulu	#202,d0
	lea	texts(pc),a1
	add.l	d0,a1
	move.l	a1,adr_text
	addq.l	#1,(a0)
	lea	pt_effet(pc),a0
	move.l	nbr_effet(pc),d0
	cmp.l	(a0),d0
	bne.s	effet_sui
	clr.l	(a0)
effet_sui	move.l	(a0),d0
	mulu	#232,d0
	lea	effets(pc),a1
	add.l	d0,a1
	move.l	a1,adr_effet
	addq.l	#1,(a0)	
	bra	no_eff_text
eff_sui2	move.l	4(a2),d2
	lea	scr+4,a3
	lea	0(a3,d1.l),a4
var	set	0
	rept	20
	clr.w	var(a4)
var	set	var+8
	endr
	lea	0(a3,d2.l),a4
var	set	0
	rept	20
	clr.w	var(a4)
var	set	var+8
	endr
	sub.l	#160,(a2)
	add.l	#160,4(a2)
	
no_eff_text	rts		
	
aff_stars	move.l	adr_pos_stars(pc),a0
	lea	scr,a1
	moveq	#0,d2
	move.l	#nbr_stars-1,d0
loop_aff	move.l	(a0),a3
	move.w	(a3)+,d1
	move.w	(a3)+,d2
	lea	0(a1,d2.l),a2
	bclr	d1,(a2)
	addq.l	#4,(a0)
	cmp.l	12(a0),a3
	bne.s	no_bcle
	move.l	4(a0),(a0)
	move.l	(a0),a3
no_bcle	move.w	(a3)+,d1
	move.w	(a3)+,d2
	lea	0(a1,d2.l),a2
	bset	d1,(a2)	
	addq.l	#8,a0	
	dbf	d0,loop_aff
	rts	
	
tche	move.b	$fffffc02.w,d0
f1	cmp.b	#$3b,d0
	bne.s	f2
	move.l	#nom1,nom+2
	bra	tche_on
f2	cmp.b	#$3c,d0
	bne.s	f3
	move.l	#nom2,nom+2
	bra	tche_on
f3	cmp.b	#$3d,d0
	bne.s	return
	move.l	#nom3,nom+2
	bra	tche_on
return	cmp.b	#$1c,d0
	beq.s	tche_on
	rts
tche_on	move.w	#1,tst_tche
	rts
	
load	tst.l	nom+2
	beq	quit
		
	lea	buffer_load(pc),a6

	move.w	#2,-(sp)
nom	pea	0
 	move.w	#$3d,-(sp)
 	trap	#1
 	addq.l	#8,sp
 	tst.w	d0
 	bmi	error
 	move.w	d0,(a6)
 	
 	lea	pt_base(pc),a1
 	move.l	a1,2(a6)
 	lea	-$1c(a1),a1
 	move.l	a1,6(a6)
 	
 	lea	rel_deb(pc),a0
 	lea	-$500(a7),a1
	move.l	a1,a2
 	move.w	#(rel_fin-rel_deb)/4,d0
cop_rel	move.l	(a0)+,(a1)+
 	dbf	d0,cop_rel
 	
 	jmp	(a2)
 	
rel_deb	lea	buffer_load(pc),a6
	bsr	fread
	bsr	protec
	bsr	reloge
	bsr	calc_bp
	
	move.l	6(a6),a0
	movem.l	eff_m(pc),d0-d6
	movem.l	d0-d6,(a0)
	move.l	2(a6),a3
	lea	-$100(a3),a1
	move.l	14(a6),d0
	lea	-$32(a7),a6
	move.l	a4,a2
	
	jmp	(a0)
	
fread	move.l	6(a6),-(sp)
 	pea	$ffffff
 	move.w	(a6),-(sp)
 	move.w	#$3f,-(sp)
 	trap	#1
 	lea	12(sp),sp
 	tst.l	d0
 	bmi	error
 	move.l	d0,10(a6)
 	move.w	(a6),-(sp)
 	move.w	#$3e,-(sp)
 	trap	#1
 	addq.l	#4,sp
 	tst.w	d0
 	bmi	error
 	rts
		
protec	move.l	6(a6),a0
	move.l	a0,a1
	adda.l	10(a6),a1
	cmpi.w	#$601a,(a0)
	beq.s	ret_dec
	cmpi.w	#'FZ',(a0)+
	bne	error
	lea	-1(a1),a2
	move.l	10(a6),d1
	move.l	#'kGsL',d0
	move.w	#magic_number,d2
	move.w	#$cafe,d3
	not.w	$1a(a0)
	
dec_cop	add.l	d1,d0
	eor.w	d0,(a0)
	swap	d0
	sub.w	d2,(a0)
	eor.w	d3,(a0)
	move.w	(a0)+,d3
	cmpa.l	a0,a2
	bgt.s	dec_cop
	
ret_dec	clr.b	(a1)+
	clr.b	(a1)+
	clr.b	(a1)+
	clr.b	(a1)+
	rts

reloge	move.l	6(a6),a0
	tst.w	$1a(a0)
	bne.s	rel_2
	move.l	2(a6),a1
	move.l	a1,d0
	adda.l	2(a0),a1
	adda.l	6(a0),a1
	adda.l	14(a0),a1
	moveq	#0,d1
	move.l	(a1)+,d2
	beq.s	rel_4
rel_3	add.l	d0,$1c(a0,d2.l)
rel_4	move.b	(a1)+,d1
	beq.s	rel_2
	add.l	d1,d2
	cmp.b	#1,d1
	bne.s	rel_3
	addi.l	#$fd,d2
	bra.s	rel_4
rel_2	rts

calc_bp	move.l	2(a6),a1
	move.l	6(a6),a2
	lea	-$100(a1),a0
	move.l	a1,d0
	move.l	2(a2),12(a0)
	add.l	12(a0),d0
	move.l	d0,a5
	move.l	d0,16(a0)
	move.l	6(a2),20(a0)
	add.l	20(a0),d0
	move.l	d0,a4
	move.l	d0,24(a0)
	move.l	10(a2),28(a0)
	rts
	
eff_m	clr.l	(a2)+
	cmpa.l	a2,a7
	bge.s	eff_m
	move.l	a1,4(a7)
	move.l	d0,(a6)
	move.l	a3,6(a6)
	movem.l	(a4),d0-a3
	movem.l	d0-d6,pt_base-28

error	pea	err_sup(pc)
	move	#$26,-(sp)
	trap	#14
	addq.l	#6,sp
quit	clr.w	-(sp)
	trap	#1
	
err_sup	movem.l	$ffff8240.w,d0-d7
	movem.l	d0-d7,-(sp)
	clr.w	-(a7)
	move.b	$ffff8260.w,1(a7)
	dc.w	$a00a
	clr.b	$484.w
	move.w	#1,-(sp)
	pea	-1.w
	move.l	(sp),-(sp)
	move.w	#5,-(sp)
	trap	#14
	lea	12(sp),sp
	move	#$25,-(sp)
	trap	#14
	addq.l	#2,sp
	move.w	#$7,$ffff8240.w
	move.w	#$777,$ffff8246.w
	pea	aff_mes(pc)
	move	#9,-(sp)
	trap	#1
	addq.l	#6,sp
attc	cmp.b	#$39,$fffffc02.w
	bne.s	attc
	pea	-1.w
	move.l	(sp),-(sp)
	move.w	#5,-(sp)
	trap	#14
	lea	12(sp),sp
	move.b	#7,$484.w
	move	#$25,-(sp)
	trap	#14
	addq	#2,sp
	movem.l	(sp)+,d0-d7
	movem.l	d0-d7,$ffff8240.w
	rts
	
aff_mes	dc.b	27,"E",27,"Y",41,32,7
	dc.b	"                               - LOADING ERROR -",10,13
	dc.b	10,13
	dc.b	"                     - MAYBE YOU SHOULD RECOPY THIS DISK -",10,13
	dc.b	10,13
	dc.b	"                          - PRESS SPACE TO CONTINUE -",10,13
	dc.b	0
	even
buffer_load	ds.w	1
	ds.l	4
rel_fin	even

tst_tche	ds.w	1	
pt_rot	dc.l	32*2
att_vbl_p	dc.w	4
black	dcb.w	16,0
pal_neige	dc.w	$000,$111,$000,$222,$000,$333,$000,$777
	dc.w	$666,$000,$333,$000,$222,$000,$111,$000
rot_col	dcb.w	16,0
	dc.w	$000,$111,$222,$333,$444,$555,$666,$777
	dc.w	$777,$666,$555,$444,$333,$222,$111,$000
	dcb.w	16,0
	even	
col_stars	dcb.w	10,$777
	dcb.w	10,$666
	dcb.w	10,$555
	dcb.w	10,$444
	dcb.w	10,$333
	dcb.w	10,$222
	dcb.w	10,$222
	dcb.w	10,$333
	dcb.w	10,$444
	dcb.w	10,$555
	dcb.w	10,$666
	dcb.w	10,$777
	even
col_def	dc.w	$100,$110,$210,$220,$320,$330,$430,$440
	dc.w	$540,$550,$650,$660,$760,$770,$771,$772
	dc.w	$772,$771,$770,$760,$660,$650,$550,$540
	dc.w	$440,$430,$330,$320,$220,$210,$110,$100
	dc.w	$0
	even
col_logo	dc.w	$001,$111,$112,$222,$223,$333,$334,$444
	dc.w	$445,$555,$556,$666,$667,$777,$777,$777
	dc.w	$777,$777,$777,$667,$666,$556,$555,$445
	dc.w	$444,$334,$333,$223,$222,$112,$111,$001
	dcb.w	4,0
col_text	dcb.w	4,0
	dc.w	$207,$217,$227,$237,$247,$257,$267,$277
	dc.w	$277,$267,$257,$247,$237,$227,$217,$207
	dc.w	$307,$317,$327,$337,$347,$357,$367,$377
	dc.w	$377,$367,$357,$347,$337,$327,$317,$307
	dc.w	$407,$417,$427,$437,$447,$457,$467,$477
	dc.w	$477,$467,$457,$447,$437,$427,$417,$407
	dc.w	$507,$517,$527,$537,$547,$557,$567,$577
	dc.w	$577,$567,$557,$547,$537,$527,$517,$507
	dc.w	$607,$617,$627,$637,$647,$657,$667,$677
	dc.w	$677,$667,$657,$647,$637,$627,$617,$607
	dcb.w	8,0
	even
pt_def_pos	ds.l	1
sinus_ver	dc.b	0,0,1,0,1,1,0,1,1,1,0,1,1,1,1,0,1,1,1,0,1,1,0,1,0,0
	dc.b	0,0,-1,0,-1,-1,0,-1,-1,-1,0,-1,-1,-1,-1,0,-1,-1,-1,0,-1,-1,0,-1,0,0
end_sinus_ver	dc.b	$7f
	even
pt_log_pos	ds.l	1
sinus_log	dc.b	14,14,14,12,12,12,12,10,10,10,10,9,9,9,9,8,8,8,8,7,7,7,7,6,6,6,6,5,5,5,5,4,4,4,4,3,3,3,3,2,2,2,2,1,1,1,1,0,1,1,1,0,1,1,0,1,0,0
	dc.b	0,0,-1,0,-1,-1,0,-1,-1,-1,0,-1,-1,-1,-1,-2,-2,-2,-2,-3,-3,-3,-3,-4,-4,-4,-4,-5,-5,-5,-5,-6,-6,-6,-6,-7,-7,-7,-7,-8,-8,-8,-8,-9,-9,-9,-9,-10,-10,-10,-10,-12,-12,-12,-12,-14,-14,-14
	dc.b	-14,-14,-14,-12,-12,-12,-12,-10,-10,-10,-10,-9,-9,-9,-9,-8,-8,-8,-8,-7,-7,-7,-7,-6,-6,-6,-6,-5,-5,-5,-5,-4,-4,-4,-4,-3,-3,-3,-3,-2,-2,-2,-2,-1,-1,-1,-1,0,-1,-1,-1,0,-1,-1,0,-1,0,0
	dc.b	0,0,1,0,1,1,0,1,1,1,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6,7,7,7,7,8,8,8,8,9,9,9,9,10,10,10,10,12,12,12,12,14,14,14
end_sinus_log	dc.b	$7f
	even
table_ret_fnt	dc.b	8,0
	dc.b	1,8,16,0
	dc.b	1,4,8,16,0
	dc.b	1,4,8,12,16,0
	dc.b	1,2,4,8,12,16,0
	dc.b	1,2,4,8,12,14,16,0
	dc.b	1,2,4,6,8,12,14,16,0
	dc.b	1,2,4,6,8,10,12,14,16,0
	dc.b	1,2,3,4,6,8,10,12,14,16,0
	dc.b	1,2,3,4,6,8,10,12,14,15,16,0
	dc.b	1,2,3,4,5,6,8,10,12,14,15,16,0
	dc.b	1,2,3,4,5,6,8,10,12,13,14,15,16,0
	dc.b	1,2,3,4,5,6,7,8,10,12,13,14,15,16,0
	dc.b	1,2,3,4,5,6,7,8,10,11,12,13,14,15,16,0
	dc.b	1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,0
	dc.b	1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,0
	dc.b	$7f
	even
pt_effet	dc.l	1
nbr_effet	dc.l	8
adr_effet	dc.l	effets
effets	dcb.b	15,0
	dc.b	1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
	dc.b	40,60,80,100,120,140,160,180,200
	dc.b	199,198,197,196,195,194,193,192,191,190,189,188,187,186,185,184,183,182,181
	dc.b	161,141,121,101,81,61,41,21
	dc.b	22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39
	dc.b	59,79,99,119,139,159,179
	dc.b	178,177,176,175,174,173,172,171,170,169,168,167,166,165,164,163,162
	dc.b	142,122,102,82,62,42
	dc.b	43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58
	dc.b	78,98,118,138,158
	dc.b	157,156,155,154,153,152,151,150,149,148,147,146,145,144,143
	dc.b	123,103,83,63
	dc.b	64,65,66,67,68,69,70,71,72,73,74,75,76,77
	dc.b	97,117,137
	dc.b	136,135,134,133,132,131,130,129,128,127,126,125,124
	dc.b	104,84
	dc.b	85,86,87,88,89,90,91,92,93,94,95,96
	dc.b	116
	dc.b	115,114,113,112,111,110,109,108,107,106,105
	dc.b	201
	dcb.b	15,0
	even
	dcb.b	15,0
	dc.b	1,21,41,61,81,101,121,141,161,181
	dc.b	182,162,142,122,102,82,62,42,22,2
	dc.b	3,23,43,63,83,103,123,143,163,183
	dc.b	184,164,144,124,104,84,64,44,24,4
	dc.b	5,25,45,65,85,105,125,145,165,185
	dc.b	186,166,146,126,106,86,66,46,26,6
	dc.b	7,27,47,67,87,107,127,147,167,187
	dc.b	188,168,148,128,108,88,68,48,28,8
	dc.b	9,29,49,69,89,109,129,149,169,189
	dc.b	190,170,150,130,110,90,70,50,30,10
	dc.b	11,31,51,71,91,111,131,151,171,191
	dc.b	192,172,152,132,112,92,72,52,32,12
	dc.b	13,33,53,73,93,113,133,153,173,193
	dc.b	194,174,154,134,114,94,74,54,34,14
	dc.b	15,35,55,75,95,115,135,155,175,195
	dc.b	196,176,156,136,116,96,76,56,36,16
	dc.b	17,37,57,77,97,117,137,157,177,197
	dc.b	198,178,158,138,118,98,78,58,38,18
	dc.b	19,39,59,79,99,119,139,159,179,199
	dc.b	200,180,160,140,120,100,80,60,40,20
	dc.b	201
	dcb.b	15,0
	even
	dcb.b	15,0
	dc.b	1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
	dc.b	40,39,38,37,36,35,34,33,32,31,30,29,28,27,26,25,24,23,22,21
	dc.b	41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60
	dc.b	80,79,78,77,76,75,74,73,72,71,70,69,68,67,66,65,64,63,62,61
	dc.b	81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100
	dc.b	120,119,118,117,116,115,114,113,112,111,110,109,108,107,106,105,104,103,102,101
	dc.b	121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140
	dc.b	160,159,158,157,156,155,154,153,152,151,150,149,148,147,146,145,144,143,142,141
	dc.b	161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180
	dc.b	200,199,198,197,196,195,194,193,192,191,190,189,188,187,186,185,184,183,182,181
	dc.b	201
	dcb.b	15,0
	even
	dcb.b	15,0
	dc.b	90,91,92,93,94,95,96,97,98,99,100,120,140,160,180,200
	dc.b	199,198,197,196,195,194,193,192,191,190,189,188,187,186,185,184,183,182,181
	dc.b	161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179
	dc.b	159,158,157,156,155,154,153,152,151,150,149,148,147,146,145,144,143,142,141
	dc.b	121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139
	dc.b	119,118,117,116,115,114,113,112,111,110,109,108,107,106,105,104,103,102,101
	dc.b	81,82,83,84,85,86,87,88,89,69,68,67,66,65,64,63,62,61,41,42,43,44,45,46,47,48,49
	dc.b	29,28,27,26,25,24,23,22,21,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
	dc.b	40,60,80,79,78,77,76,75,74,73,72,71,70,50,51,52,53,54,55,56,57,58,59
	dc.b	39,38,37,36,35,34,33,32,31,30
	dc.b	201
	dcb.b	15,0
	even
	dcb.b	15,0
	dc.b	1,22,43,64,85,106,127,148,169,190,171,152,133,114,95,76,57,38,19,40,59,78,97,116,135
	dc.b	154,173,192,150,129,108,87,66,45,24,3,41,62,83,104,125,146,167,188,131,112,93,74,55
	dc.B	36,17,80,99,118,137,156,175,194,110,89,68,47,26,5,81,102,123,144,165,186,91,72,53,34
	dc.B	15,120,139,158,177,196,70,49,28,7,121,142,163,184,51,32,13,160,179,198,30,9,161,182
	dc.b	11,200,180,159,138,117,96,75,54,33,12,31,50,69,88,107,126,145,164,183,162,141,122
	dc.b	103,84,65,46,27,8,29,71,92,113,134,155,176,197,178,140,119,98,77,56,35,14,52,90,109
	dc.b	128,147,166,185,143,101,82,63,44,25,6,48,111,132,153,174,195,157,100,79,58,37,16
	dc.b	73,130,149,168,187,124,61,42,23,4,67,151,172,193,136,60,39,18,94,170,189,105,21,2,86
	dc.b	191,115,20,10,181,199
	dc.b	201
	dcb.b	15,0
	even
	dcb.b	15,0
	dc.b	1,21,41,61,81,101,121,141,161,181,183,163,143,123,103,83,63,43,23,3
	dc.b	5,25,45,65,85,105,125,145,165,185,187,167,147,127,107,87,67,47,27,7
	dc.b	9,29,49,69,89,109,129,149,169,189,191,171,151,131,111,91,71,51,31,11
	dc.b	13,33,53,73,93,113,133,153,173,193,195,175,155,135,115,95,75,55,35,15
	dc.b	17,37,57,77,97,117,137,157,177,197,199,179,159,139,119,99,79,59,39,19
	dc.b	20,40,60,80,100,120,140,160,180,200,198,178,158,138,118,98,78,58,38,18
	dc.b	16,36,56,76,96,116,136,156,176,196,194,174,154,134,114,94,74,54,34,14
	dc.b	12,32,52,72,92,112,132,152,172,192,190,170,150,130,110,90,70,50,30,10
	dc.b	8,28,48,68,88,108,128,148,168,188,186,166,146,126,106,86,66,46,26,6
	dc.b	4,24,44,64,84,104,124,144,164,184,182,162,142,122,102,82,62,42,22,2
	dc.b	201
	dcb.b	15,0
	even
	dcb.b	15,0
	dc.b	101,121,141,161,181,182,162,142,122,102,103,123,143,163,183,184,164,144,124,104
	dc.b	105,125,145,165,185,186,166,146,126,106,107,127,147,167,187,188,168,148,128,108
	dc.b	109,129,149,169,189,190,170,150,130,110,111,131,151,171,191,192,172,152,132,112
	dc.b	113,133,153,173,193,194,174,154,134,114,115,135,155,175,195,196,176,156,136,116
	dc.b	117,137,157,177,197,198,178,158,138,118,119,139,159,179,199,200,180,160,140,120
	dc.B	100,80,60,40,20,19,39,59,79,99,98,78,58,38,18,17,37,57,77,97,96,76,56,36,16,15
	dc.b	35,55,75,95,94,74,54,34,14,13,33,53,73,93,92,72,52,32,12,11,31,51,71,91,90
	dc.b	70,50,30,10,9,29,49,69,89,88,68,48,28,8,7,27,47,67,87,86,66,46,26,6,5,25,45,65,85
	dc.b	84,64,44,24,4,3,23,43,63,83,82,62,42,22,2,1,21,41,61,81
	dc.b	201
	dcb.b	15,0
	even
	dcb.b	15,0
	dc.b	181
	dc.b	161,182
	dc.b	183,162,141
	dc.b	121,142,163,184
	dc.b	185,164,143,122,101
	dc.b	81,102,123,144,165,186
	dc.b	187,166,145,124,103,82,61
	dc.b	41,62,83,104,125,146,167,188
	dc.b	189,168,147,126,105,84,63,42,21
	dc.b	1,22,43,64,85,106,127,148,169,190
	dc.b	191,170,149,128,107,86,65,44,23,2
	dc.b	3,24,45,66,87,108,129,150,171,192
	dc.b	193,172,151,130,109,88,67,46,25,4
	dc.b	5,26,47,68,89,110,131,152,173,194
	dc.b	195,174,153,132,111,90,69,48,27,6
	dc.b	7,28,49,70,91,112,133,154,175,196
	dc.b	197,176,155,134,113,92,71,50,29,8
	dc.b	9,30,51,72,93,114,135,156,177,198
	dc.b	199,178,157,136,115,94,73,52,31,10
	dc.b	11,32,53,74,95,116,137,158,179,200
	dc.b	180,159,138,117,96,75,54,33,12
	dc.b	13,34,55,76,97,118,139,160
	dc.b	140,119,98,77,56,35,14
	dc.b	15,36,57,78,99,120
	dc.b	100,79,58,37,16
	dc.b	17,38,59,80
	dc.b	60,39,18
	dc.b	19,40
	dc.b	20
	dc.b	201
	dcb.b	15,0
	even
pt_text	dc.l	1
adr_text	dc.l	texts
nbr_text	dc.l	15
	even
texts	dc.b	"[[[[[[[[[[[[[[[[[[[["
	dc.b	"[                  ["
	dc.b	"[     YO FANS !    ["
	dc.b	"[ HERE WE GO AGAIN ["
	dc.b	"[                  ["
	dc.b	"[      FUZION      ["
	dc.b	"[     IS PROUD     ["
	dc.b	"[    TO PRESENT    ["
	dc.b	"[                  ["
	dc.b	"[[[[[[[[[[[[[[[[[[[[ "
	even
	dc.b	"````````````````````"
	dc.b	"`                  `"
	dc.b	"` COMPACT DISK 138 `"
	dc.b	"`                  `"
	dc.b	"`  WICH CONTAINS   `"
	dc.b	"`    FOR YOUR      `"
	dc.b	"`  IMMEASURABLE    `"
	dc.b	"`    PLEASURE      `"
	dc.b	"`                  `"
	dc.b	"```````````````````` "
	even
	dc.b	"\\\\\\\\\\\\\\\\\\\\"
	dc.b	"\                  \"
	dc.b	"\ F1 - POPULOUS II \"
	dc.b	"\                  \"
	dc.b	"\F2 - KID GLOVES II\"
	dc.b	"\                  \"
	dc.b	"\F3 - TROTSKY CRAZY\"
	dc.b	"\                  \"
	dc.b	"\          ENJOY...\"
	dc.b	"\\\\\\\\\\\\\\\\\\\\ "
	EVEN
	dc.b	"********************"
	dc.b	"*                  *"
	dc.b	"*   PRESS RETURN   *"
	DC.B	"*     TO CHECK     *"
	DC.B	"*     THE COPY     *"
	DC.B	"*  AND TO SEE OUR  *"
	DC.B	"*   LATEST MENUS   *"
	DC.B	"*      LIST !      *"
	DC.B	"*                  *"
	DC.B	"******************** "
	even
	dc.B	"]]]]]]]]]]]]]]]]]]]]"
	dc.B	"]POPULOUS 2 CRACKED]"
	DC.B	"]BY ORION OF FUZION]"
	DC.B	"]                  ]"
	DC.B	"]KID GLOVES 2 CRACK]"
	DC.B	"]  BY 1772/FUZION  ]"
	DC.B	"]                  ]"
	dc.b	"] TROSKY CRAZY BY: ]"
	DC.B	"] RUTHLESS/HOTLINE ]"
	DC.B	"]]]]]]]]]]]]]]]]]]]] "
	even
	dc.b	"[[[[[[[[[[[[[[[[[[[["
	dc.b	"[                  ["
	dc.b	"[  THANX FOR SOME  ["
	DC.B	"[   ORIGINALS TO   ["
	DC.B	"[                  ["
	DC.B	"[ BAD BOYS BELGIUM ["
	DC.B	"[       JEJE       ["
	DC.B	"[      VORTEX      ["
	DC.B	"[                  ["
	DC.B	"[[[[[[[[[[[[[[[[[[[[ "
	EVEN
	dc.B	"]]]]]]]]]]]]]]]]]]]]"
	dc.B	"]                  ]"
	DC.B	"]   SUPPLY, MENU   ]"
	DC.B	"]   DESIGNED AND   ]"
	DC.B	"]    MADE UP BY    ]"
	DC.B	"] DRAGON OF FUZION ]"
	DC.B	"]                  ]"
	dc.b	"] ON THE: 04/03/92 ]"
	DC.B	"]                  ]"
	DC.B	"]]]]]]]]]]]]]]]]]]]] "
	even

	dc.b	"********************"
	dc.b	"*                  *"
	dc.b	"*     CREDITS      *"
	DC.B	"*                  *"
	DC.B	"*  INTRO CODED BY  *"
	DC.B	"*      ORION       *"
	DC.B	"*                  *"
	DC.B	"*ART WORK BY MACDOS*"
	DC.B	"*                  *"
	DC.B	"******************** "
	EVEN
	DC.B	"[[[[[[[[[[[[[[[[[[[["
	DC.B	"[                  ["
	DC.B	"[     MUSAX BY     ["
	DC.B	"[  JOCHEN HIPPEL!  ["
	DC.B	"[                  ["
	DC.B	"[    RIPPED BY:    ["
                DC.B	"[                  ["
                DC.B	"[   ORION/FUZION   ["                       
	DC.B	"[                  ["
	DC.B	"[[[[[[[[[[[[[[[[[[[[ "        
	even
	dc.b	"````````````````````"
	dc.b	"`FUZION MEMBERS ARE`"
	dc.b	"`                  `"
	dc.b	"`ORION DRAGON KASAR`"
	dc.b	"`KELVIN MACDOS 1772`"
	dc.b	"`ETERNAL DUMP SQUAT`"
	dc.b	"`INFIRMIER KELLY.X `"
	dc.b	"`ALANPARKER FULCRUM`"
	dc.b	"`    AND SHIRYU    `"
	dc.b	"```````````````````` "
	even
	dc.b	"\\\\\\\\\\\\\\\\\\\\"
	DC.B	"\ BEST REGARDS TO: \"
	DC.B	"\                  \"
	DC.B	"\ REPLICANTS-DOCNO \"
	DC.B	"\ VMAX-TSB-HOTLINE \"
	DC.B	"\ THUNDERBIRDS-BBB \"
	DC.B	"\ SYNDICATE-CELTIK \"
	DC.B	"\ ANIMAL MINE-STAX \"
	DC.B	"\ FOX-NOW5/XTC-MCS \"
	DC.B	"\\\\\\\\\\\\\\\\\\\\ "
	EVEN
	dc.b            "********************"
	dc.b	"* BLUEMAX-FORCE 69 *"
	dc.b	"* NPG-WILDBOYS-RIP *"
	dc.b	"* SUPERIOR-PATCASH *"
	dc.b	"* SPY3-ORION-CORPO *"
	dc.b	"* STREBELS-GENESIS *"
	dc.b	"* VOYAGER-TITANIUM *"
	dc.b	"* ST CNX-REDBARONS *"
	dc.b	"* STARFIRE-QUARTEX *"
	dc.b	"******************** "
	even
	dc.b            "[[[[[[[[[[[[[[[[[[[["
	dc.b	"[ TNS-INNER CIRCLE ["
	dc.b	"[ TLB-DBUG-STRIDER ["
	dc.b	"[ CYNIX-UNITY-MATT ["
	dc.b	"[ AXXIS-RIPPED OFF ["
	dc.b	"[ UNTOUCHABLES-MCA ["
	dc.b	"[ LIGHT-XENEX-NEXT ["
	dc.b	"[ SHARP-JUDGEDREED ["
	dc.b	"[ AND ALL OTHERS.. ["
	dc.b	"[[[[[[[[[[[[[[[[[[[[ "
	even
	dc.b            "````````````````````"
	dc.b	"`                  `"
	dc.b	"`  CONTACT US AT:  `"
	dc.b	"` -FUZION-   BP 66 `"
	dc.b	"`  59420  MOUVAUX  `"
	dc.b	"`     FRANCE !     `"
	DC.B	"`OR ON MINITEL 3615`"
	dc.b	"` RTEL  BAL FUZION `"
	dc.b	"`                  `"
	dc.b	"```````````````````` "
	even
	dc.b	"\\\\\\\\\\\\\\\\\\\\"
	DC.B	"\                  \"
	DC.B	"\   ^_ AND FUZION  \"
	DC.B	"\ ARE GOOD FOR YOU \"
	DC.B	"\                  \"
	DC.B	"\  TIME TO WRAP..  \"
	DC.B	"\                  \"
	DC.B	"\   1992 FRANCE    \"
	DC.B	"\                  \"
	DC.B	"\\\\\\\\\\\\\\\\\\\\ "
	EVEN
nom1	dc.b	"1",0
	even
nom2	dc.b	"2",0
	even
nom3	dc.b	"3",0
	even
sav_usp	ds.l	1
sav_rez	ds.w	1
sav_screen	ds.l	1
sav_hz	ds.w	1
sav_pal	ds.w	16
mfp	ds.b	20
yam	ds.b	16
sav_vbl	ds.l	1
sav_timer_b	ds.l	1
sav_timer_d	ds.l	1
	even
scr_neige	dc.l	scr-$18600
adr_eff_scr	dc.l	160*160,160*161
pt_wait	dc.w	32*10
buf_def_pos	dc.l	0
buf_def_ver	dc.l	buf_all
buf_log_def	dc.l	0
buf_log_pos	dc.l	0
pt_table	ds.l	1
buf_ret_fnt	dc.l	0
buf_neige	dc.l	0
adr_pos_stars	dc.l	0
buf_stars	dc.l	0
buf_hbl_col	dc.l	0
pos_fnt_sav	ds.b	10*17
	even
fonts	incbin	\orion.src\fuzion.cd\angels\16x16_3.fnt
	even
play	incbin	\orion.src\fuzion.cd\angels\wings_2.bin
	even
part	incbin	\orion.src\fuzion.cd\angels\level0.bin
	even
cd_num	incbin	\orion.src\fuzion.cd\angels\cd.dat
	even
logo	incbin	\orion.src\fuzion.cd\angels\log.dat
	even
pres_col	incbin	\orion.src\fuzion.cd\angels\pres_col.dat
	even
buf_all
	end