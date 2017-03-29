	*************************************
	* Intro      Soundtrack & Zoom Text *
	* Coder      ORION from FUZION      *
	* Usage      Fuzion/Reps Cracks     *
	* Date       Summer 1992            *
	*                                   *
	* Machine    Atari STE - 1MB RAM    *	
	* TOS        1.62                   *
	* Assembler  GenST v2.09            *
	* Emulator   Steem v3.2             *
	*                                   *
	* Contact    Orion.Fuzion@gmail.com *
	*************************************

scr1	=	$f0000
scr2	=	scr1+$7d00
tst_st	=	1
mvol	=	$80
a_data	=	20
parts_stf	=	5
len_stf	=	41
inc_stf	=	$1234de0
len_ste	=	100
inc_ste	=	$8efb4e

pt_base	move.l	a7,sav_a7
	lea	scr1-$100,a7
	pea	intro(pc)
	move.w	#$26,-(sp)
	trap	#14
	addq.l	#6,sp
	move.l	sav_a7,a7
	
	clr	-(sp)
	trap	#1
	
	bsr	relog_prog
	bsr	calc_base_p	
	
	lea	pt_base(pc),a3
	movem.l	cop_prog(pc),d0-d7/a0
	movem.l	d0-d7/a0,-36(a3)
	lea	-$32(a7),a6
	lea	buffer_prog+$1c,a0
	move.l	a3,a1
	lea	-$100(a3),a2
	move.l	sav_usp,d0
	jmp	-36(a3)
	
relog_prog	lea	buffer_prog,a0
	tst	$1a(a0)
	bne.s	fin_reloge
	lea	$1c(a0),a1
	move.l	a1,a2
	add.l	2(a0),a2
	add.l	6(a0),a2
	add.l	14(a0),a2
	moveq	#0,d1
	lea	pt_base(pc),a0
	move.l	a0,d2
	move.l	(a2)+,d0
	beq.s	fin_reloge
reloge_1	add.l	d2,0(a1,d0.l)
reloge_2	move.b	(a2)+,d1
	beq.s	fin_reloge
	add.l	d1,d0
	cmp.b	#1,d1
	bne.s	reloge_1
	addi.l	#253,d0
	bra.s	reloge_2
fin_reloge	rts

calc_base_p	lea	pt_base(pc),a0
	move.l	a0,d0
	lea	-$100(a0),a0
	lea	buffer_prog,a1
	move.l	2(a1),12(a0)
	add.l	12(a0),d0
	move.l	d0,a5
	move.l	d0,16(a0)
	move.l	6(a1),20(a0)
	add.l	20(a0),d0
	move.l	d0,a4
	move.l	d0,24(a0)
	move.l	10(a1),28(a0)
	rts

cop_prog	move.l	(a0)+,(a1)+
	cmpa.l	a1,a4
	bgt.s	cop_prog
eff_mem	clr.l	(a1)+
	cmpa.l	a1,a7
	bgt.s	eff_mem
	move.l	a2,4(a7)
	move.l	a3,6(a6)
	move.l	d0,(a6)
	movem.l	-$100(a1),d0-d7/a0-a3
	movem.l	d0-d7/a0,pt_base-36

intro	bsr	save_all
	bsr	set_scr
	bsr	prec_ret_fnt
	bsr	prec_col
	bsr	tst_type_st
	bsr	inter_on
	bsr	loop_key
	bsr	inter_off
	rts
	
save_all	move.w	#$2700,sr
	move.l	$24(a1),sav_usp
	move.l	$44e.w,sav_screen
	move.b	$ffff8260.w,sav_rez+1
	move.b	$ffff820a.w,sav_hz
	movem.l	$ffff8240.w,d0-d7
	movem.l	d0-d7,sav_pal
	lea	$fffffa01.w,a0
	lea	mfp,a1
	moveq	#$e,d0
cop_mfp	move.b	(a0)+,(a1)+
	lea	1(a0),a0
	dbf	d0,cop_mfp
	move.b	8(a0),(a1)+
	move.b	10(a0),(a1)+
	move.b	12(a0),(a1)+
	move.b	14(a0),(a1)+
	move.b	16(a0),(a1)+
	move.l	$70.w,sav_vbl
	move.l	$120.w,sav_timer_b
	move.l	$134.w,sav_timer_d
	move.w	#$2300,sr
	rts
	
inter_on	move.w	#$2700,sr
	move.b	#1,$fffffa07.w	
	clr.b	$fffffa09.w
	move.b	#1,$fffffa0b.w
	clr.b	$fffffa0d.w
	move.b	#1,$fffffa13.w
	clr.b	$fffffa15.w
	bsr	mus_on
	move.b	#$40,$fffffa17.w
	move.b	#$12,$fffffc02.w
	move.l	#vbl,$70.w
	move.w	#$2300,sr
	rts
	
inter_off	move.w	#$2700,sr
	lea	mfp,a0
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
	move.l	sav_vbl,$70.w
	move.l	sav_timer_b,$120.w
	move.l	sav_timer_d,$134.w
	move.b	#$8,$fffffc02.w
	move.b	sav_hz,$ffff820a.w
	lea	$ffff8800.w,a0
	move.l	#$0707ffff,(a0)
	move.l	#$08080000,(a0)
	move.l	#$09090000,(a0)
	move.l	#$0a0a0000,(a0)
	tst.b	st
	beq.s	stf
	clr.b	$ffff8901.w
stf	move.w	#$2300,sr
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
	move.w	sav_rez,-(sp)
	move.l	sav_screen,-(sp)
	move.l	(sp),-(sp)
	move.w	#5,-(sp)
	trap	#14
	lea	12(sp),sp
	movem.l	sav_pal,d0-d7
	movem.l	d0-d7,$ffff8240.w
	move.b	#7,$484.w
	rts	
	
set_scr	dc.w	$a00a
	clr.b	$484.w
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
	pea	scr1
	move.l	(sp),-(sp)
	move.w	#5,-(sp)
	trap	#14
	lea	12(sp),sp
	lea	pic+34,a0
	lea	scr1,a1
	move.w	#40*200-1,d0
cop_pic	move.l	(a0)+,(a1)+
	dbf	d0,cop_pic
	move.w	#40*200-1,d0
eff_scr2	clr.l	(a1)+
	dbf	d0,eff_scr2
	move.l	#$2ffff,d0
wait_l	subq.l	#1,d0
	bne.s	wait_l
	lea	pic+2,a2
	bsr	col_on
	rts
	
col_on	lea	$fffff8240.w,a3
	moveq	#15,d6
	moveq	#7,d5
loop_col2	move.l	a2,a0
	move.l	a3,a1
	moveq	#3,d7
	bsr	vsync
	move.l	d6,d0
loop_col1	moveq	#0,d1
	moveq	#0,d3
	move.w	(a0)+,d1
	and.w	#$777,d1
	move.w	(a1),d3
	and.w	#$777,d3
red	move.l	d1,d2
	move.l	d3,d4
	lsr.w	#8,d2
	lsr.w	#8,d4
	cmp.b	d2,d4
	bge.s	green
	add	#$100,d3
green	move.l	d1,d2
	move.l	d3,d4
	lsr.b	#4,d2
	lsr.b	#4,d4
	cmp.b	d2,d4
	bge.s	blue
	add	#$10,d3
blue	move.l	d1,d2
	move.l	d3,d4
	lsl.b	#4,d2
	lsr.b	#4,d2
	lsl.b	#4,d4
	lsr.b	#4,d4
	cmp.b	d2,d4
	bge.s	col_ct
	addq	#1,d3
col_ct	move	d3,(a1)+
	dbf	d0,loop_col1
	dbf	d5,loop_col2
	rts
	
tst_type_st	moveq	#tst_st,d0
	lea	$5.w,a0
	cmp.b	#$fc,(a0)
	bne.s	ste
	moveq	#0,d0
ste	move.b	d0,st
	sub.w	d0,hbl_set+2
	rts
	
loop_key	moveq	#0,d0
	move.b	$fffffc02.w,d0
	tst.b	st
	bne.s	no_fct
	cmp.b	#$3b,d0
	blt.s	no_fct
	cmp.b	#$3d,d0
	bgt.s	no_fct
	sub.b	#$3b,d0
	lsl.w	#2,d0
	lea	out_inter,a0
	move.l	(a0,d0.w),$134.w
no_fct	cmpi.b	#$39,d0
	bne.s	loop_key
	rts
	
vsync	clr.l	$466.w
wait_sync	cmp.l	$466.w,d7
	bgt.s	wait_sync
	rts
		
mus_on	cmp.b	#1,st
	bne.s	stf_run_1
	move.l	#$4e714e71,st_ch_1
	move.l	#inc_ste,st_ch_2+2
	bsr.s	ste_replay_routs
	bra.s	mus_on_2
stf_run_1	move.l	#$06020080,st_ch_1
	move.l	#inc_stf,st_ch_2+2
	bsr.s	stf_replay_routs
mus_on_2	bsr	vol	
	bsr	incrcal	
	bsr	clearym	
	jsr	init	
	jsr	prepare	
	rts

ste_replay_routs
	move.l	#stereo,jmp_music+2
	move.b	#2,$FFFF8921.w
	move.l	samp1,d0
	move.l	d0,d1
	add.l	#len_ste*2*5,d1
	movea	#$8900,a0
	movep.l	d0,1(a0)
	movep.l	d1,$d(a0)
	move	#1,(a0)
	rts
	
stf_replay_routs
	bset	#5,$fffffa07.w
	bset	#5,$fffffa13.w
	clr.b	$FFFFFA19.w
	move.b	#a_data,$FFFFFA1F.w
	move.b	#2,$FFFFFA19.w
	move.l	#play_stf,jmp_music+2
	lea	out_inter,a0
	moveq	#0,d0
	move.b	out,d0
	lsl.w	#2,d0
	move.l	(a0,d0.w),$134.w
	lea	sample1,a6
	rts
	
prec_ret_fnt	lea	fonts,a0
	lea	buf_ret_fnt,a3
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
	
prec_col	lea	col_txt,a0
	lea	buf_col,a1
	move.w	#105,d0
p_col1	move.w	(a0),(a1)+
	move.w	(a0)+,(a1)+
	dbf	d0,p_col1
	move.w	#105,d0
p_col2	move.l	(a0)+,(a1)+
	dbf	d0,p_col2
	rts
	
hbl1	clr.b	$fffffa1b.w
hbl_set	move.b	#3,$fffffa21.w
	move.l	#hbl2,$120.w
	move.b	#8,$fffffa1b.w	
	rte
	
hbl2	move.l	buf_col,$ffff8242.w
	move.w	$ffff8242.w,$ffff8246.w
	addq.w	#4,hbl2+4
	rte
	
vbl	bsr	init_hbl
	bsr	hard
	bsr	eff_fnt
	bsr	aff_fnt
	bsr	eff_text
jmp_music	jsr	$0
	rte
	
hard	lea	tab_ver,a0
	add.l	pt_tab,a0
	addq.l	#1,pt_tab
	cmp.l	#(end_tab_ver-tab_ver),pt_tab
	bne.s	tab_ct
	clr.l	pt_tab
tab_ct	moveq	#0,d0
	move.b	(a0),d0
	add.b	d0,pos_hbl
	muls	#$500,d0
	ext.l	d0
	add.l	d0,pos_scr
	move.b	pos_scr+1,$ffff8201.w
	move.b	pos_scr+2,$ffff8203.w
	rts	
	
init_hbl	tst.b	st
	bne.s	ste2
stf2	movea.l	samp1,a6
	bra.s	st_ct
ste2	move.l	samp1,d0
	move.l	d0,d1
	add.l	#len_ste*2*5,d1
	movea	#$8900,a0
	movep.l	d0,1(a0)
	movep.l	d1,$d(a0)
	move	#1,(a0)
	move.l	samp1,d0
	move.l	samp2,samp1
	move.l	d0,samp2
st_ct	lea	buf_col,a0
	add.l	pt_col,a0
	move.l	s_hbl1,d0
	add.l	d0,pt_col
	eor.l	#4,s_hbl1
	cmp.l	#106*4,pt_col
	bne.s	col_sui
	clr.l	pt_col
col_sui	move.l	a0,hbl2+2
	moveq	#0,d0
	move.b	pos_hbl,d0
	neg.w	d0
	muls	#8,d0
	add.w	#210,d0
	sub.w	s_hbl2,d0
	eor.w	#1,s_hbl2
	clr.b	$fffffa1b.w
	move.b	d0,$fffffa21.w
	move.l	#hbl1,$120.w
	move.b	#8,$fffffa1b.w
	movem.l	pic+2,d0-d3
	movem.l	d0-d3,$ffff8240.w
	movem.l	pic+2+4*4,d0-d3
	movem.l	d0-d3,$ffff8250.w
	rts
	
eff_fnt	lea	pos_fnt_sav+10,a1
	lea	scr2+160*20,a2
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
	
aff_fnt	cmp.w	#5,pos_hbl
	ble	no_aff_fnt
	move.l	adr_effet,a0
	lea	pt_table,a2
	cmp.l	#215,(a2)
	beq	no_aff_fnt
	add.l	(a2),a0
	addq.l	#1,(a2)
	lea	pos_fnt_sav+10,a1
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
	
	move.l	adr_text,a4
	lea	scr2+160*20,a2
	lea	buf_ret_fnt,a3
	moveq	#15,d4	
	
lp_aff_fnt	moveq	#0,d0
	move.b	(a0)+,d0
	beq	no_aff
	move.b	-1(a4,d0.l),d0
	sub.b	#$20,d0
	mulu	#16*2*16,d0
	move.l	d4,d1
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
	
	movem.l	a2-a3,-(sp)
	add.l	d0,a3
	add.l	d1,a2
	divu	#8,d2
	move.w	d2,d3
	mulu	#8,d3
	swap	d2
var	set	0	
	rept	16
	moveq	#0,d0
	move.w	(a3)+,d0
	swap	d0
	lsr.l	d2,d0
	lsr.l	d3,d0
	or.w	d0,var+8(a2)
	swap	d0
	or.w	d0,var(a2)
var	set	var+160
	endr
	movem.l	(sp)+,a2-a3
	
no_aff	lea	10(a1),a1
	dbf	d4,lp_aff_fnt
	
no_aff_fnt	rts
	
eff_text	lea	pt_table,a0
	cmp.l	#215,(a0)
	bne	no_eff_text
	lea	pt_wait,a1
	tst.w	(a1)
	beq.s	eff_sui
	subq.w	#1,(a1)
	bra	no_eff_text
eff_sui	lea	adr_eff_scr,a2
	move.l	(a2),d1
	cmp.l	#160*19,d1
	bne.s	eff_sui2
	move.l	#160*100,(a2)
	move.l	#160*101,4(a2)
	move.w	#32*10,(a1)
	clr.l	(a0)
	lea	pt_text,a0
	move.l	nbr_text,d0
	cmp.l	(a0),d0
	bne.s	txt_sui
	clr.l	(a0)
txt_sui	move.l	(a0),d0
	mulu	#202,d0
	lea	texts,a1
	add.l	d0,a1
	move.l	a1,adr_text
	addq.l	#1,(a0)
	lea	pt_effet,a0
	move.l	nbr_effet,d0
	cmp.l	(a0),d0
	bne.s	effet_sui
	clr.l	(a0)
effet_sui	move.l	(a0),d0
	mulu	#232,d0
	lea	effets,a1
	add.l	d0,a1
	move.l	a1,adr_effet
	addq.l	#1,(a0)	
	bra	no_eff_text
eff_sui2	move.l	4(a2),d2
	lea	scr2+2,a3
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
		
clearym	moveq	#$0A,d0
._1	move.b	d0,$FFFF8800.w
	clr.b	$FFFF8802.w
	dbra	d0,._1	
	clr.b	$FFFF8800.w
	clr.b	$FFFF8802.w
	move.b	#7,$FFFF8800.w
	move.b	#$FF,$FFFF8802.w
	rts
	
vol	moveq	#64,d0
	lea	vtabend,a0
ploop	move.w	#255,d1
mloop	move.w	d1,d2
	ext.w	d2
	muls	d0,d2
	divs	#mvol,d2
st_ch_1	add.b	#$80,d2	
	move.b	d2,-(a0)
	dbra	d1,mloop
	dbra	d0,ploop
	rts

incrcal	lea	stab,a0
	move.w	#$30,d1
	move.w	#$39F-$30,d0
st_ch_2	move.l	#inc_stf,d2
recalc	swap	d2
	moveq	#0,d3
	move.w	d2,d3
	divu	d1,d3
	move.w	d3,d4
	swap	d4
	swap	d2
	move.w	d2,d3
	divu	d1,d3
	move.w	d3,d4
	move.l	d4,(a0)+
	addq.w	#1,d1
	dbra	d0,recalc
	rts

stereo	movem.l	d0-a6,-(sp)
	jsr	music
	move	#5,-(sp)
rep_stereo	lea	itab,a5
	lea	vtab,a3
	moveq	#0,d0
	moveq	#0,d4
v1	movea.l	wiz2lc,a0
	move.w	wiz2pos,d0
	move.w	wiz2frc,d1
	move.w	aud2per,d7
	add.w	d7,d7
	add.w	d7,d7
	move.w	0(a5,d7.w),d2
	movea.w	2(a5,d7.w),a4
	move.w	aud2vol,d7
	asl.w	#8,d7
	lea	0(a3,d7.w),a2
	movea.l	wiz3lc,a1
	move.w	wiz3pos,d4
	move.w	wiz3frc,d5
	move.w	aud3per,d7
	add.w	d7,d7
	add.w	d7,d7
	move.w	0(a5,d7.w),d6
	movea.w	2(a5,d7.w),a5
	move.w	aud3vol,d7
	asl.w	#8,d7
	lea	0(a3,d7.w),a3
	movea.l	samp1,a6
add_ste_1	adda.w	#0,a6
	moveq	#0,d3
	REPT 	len_ste
	add.w	a4,d1
	addx.w	d2,d0
	add.w	a5,d5
	addx.w	d6,d4
	move.b	0(a0,d0.l),d3
	move.b	0(a2,d3.w),d7
	move.b	0(a1,d4.l),d3
	add.b	0(a3,d3.w),d7
	move.w	d7,(a6)+
	ENDR
	cmp.l	wiz2len,d0
	blt.s	.ok2
	sub.w	wiz2rpt,d0
.ok2	move.w	d0,wiz2pos
	move.w	d1,wiz2frc
	cmp.l	wiz3len,d4
	blt.s	.ok3
	sub.w	wiz3rpt,d4
.ok3	move.w	d4,wiz3pos
	move.w	d5,wiz3frc
	lea	itab,a5
	lea	vtab,a3
	moveq	#0,d0
	moveq	#0,d4
v2	movea.l	wiz1lc,a0
	move.w	wiz1pos,d0
	move.w	wiz1frc,d1
	move.w	aud1per,d7
	add.w	d7,d7
	add.w	d7,d7
	move.w	0(a5,d7.w),d2
	movea.w	2(a5,d7.w),a4
	move.w	aud1vol,d7
	asl.w	#8,d7
	lea	0(a3,d7.w),a2
	movea.l	wiz4lc,a1
	move.w	wiz4pos,d4
	move.w	wiz4frc,d5
	move.w	aud4per,d7
	add.w	d7,d7
	add.w	d7,d7
	move.w	0(a5,d7.w),d6
	movea.w	2(a5,d7.w),a5
	move.w	aud4vol,d7
	asl.w	#8,d7
	lea	0(a3,d7.w),a3
	movea.l	samp1,a6
add_ste_2	adda.w	#0,a6
	moveq	#0,d3
	REPT 	len_ste
	add.w	a4,d1
	addx.w	d2,d0
	add.w	a5,d5
	addx.w	d6,d4
	move.b	0(a0,d0.l),d3
	move.b	0(a2,d3.w),d7
	move.b	0(a1,d4.l),d3
	add.b	0(a3,d3.w),d7
	move.b	d7,(a6)
	addq.w	#2,a6
	ENDR
	cmp.l	wiz1len,d0
	blt.s	.ok1
	sub.w	wiz1rpt,d0
.ok1	move.w	d0,wiz1pos
	move.w	d1,wiz1frc
	cmp.l	wiz4len,d4
	blt.s	.ok4
	sub.w	wiz4rpt,d4
.ok4	move.w	d4,wiz4pos
	move.w	d5,wiz4frc
	add.w	#len_ste*2,add_ste_1+2
	add.w	#len_ste*2,add_ste_2+2
	subq.w	#1,(sp)
	bne	rep_stereo
	lea	2(sp),sp
	clr.w	add_ste_1+2
	clr.w	add_ste_2+2
	movem.l	(sp)+,d0-a6
	rts

play_stf	movem.l	d0-d4/a0-a4,-(sp)
	bsr	music
	move.l	samp2,d0
	move.l	samp1,samp2
	move.l	d0,samp1
	move	#parts_stf+1,-(sp)
rep_play_stf	lea	itab,a2
	lea	vtab,a4
	moveq	#0,d1
v1_2	movea.l	wiz1lc,a0
	move.w	wiz1pos,d1
	move.w	wiz1frc,d0
	move.w	aud1per,d4
	add.w	d4,d4
	add.w	d4,d4
	move.w	0(a2,d4.w),d3
	move.w	2(a2,d4.w),d2
	move.w	aud1vol,d4
	asl.w	#8,d4
	lea	0(a4,d4.w),a1
	moveq	#0,d4
	movea.l	samp1,a3
add_stf_1	adda.w	#0,a3
	REPT 	len_stf
	add.w	d2,d0
	addx.w	d3,d1
	move.b	0(a0,d1.l),d4
	move.b	0(a1,d4.w),d4
	move.w	d4,(a3)+
	ENDR
	cmp.l	wiz1len,d1
	blt.s	.ok1
	sub.w	wiz1rpt,d1
.ok1	move.w	d1,wiz1pos
	move.w	d0,wiz1frc
v2_2	movea.l	wiz2lc,a0
	move.w	wiz2pos,d1
	move.w	wiz2frc,d0
	move.w	aud2per,d4
	add.w	d4,d4
	add.w	d4,d4
	move.w	0(a2,d4.w),d3
	move.w	2(a2,d4.w),d2
	move.w	aud2vol,d4
	asl.w	#8,d4
	lea	0(a4,d4.w),a1
	moveq	#0,d4
	movea.l	samp1,a3
	bsr	v234
	cmp.l	wiz2len,d1
	blt.s	.ok2
	sub.w	wiz2rpt,d1
.ok2	move.w	d1,wiz2pos
	move.w	d0,wiz2frc
v3	movea.l	wiz3lc,a0
	move.w	wiz3pos,d1
	move.w	wiz3frc,d0
	move.w	aud3per,d4
	add.w	d4,d4
	add.w	d4,d4
	move.w	0(a2,d4.w),d3
	move.w	2(a2,d4.w),d2
	move.w	aud3vol,d4
	asl.w	#8,d4
	lea	0(a4,d4.w),a1
	moveq	#0,d4
	movea.l	samp1,a3
	bsr	v234
	cmp.l	wiz3len,d1
	blt.s	.ok3
	sub.w	wiz3rpt,d1
.ok3	move.w	d1,wiz3pos
	move.w	d0,wiz3frc
v4	movea.l	wiz4lc,a0
	move.w	wiz4pos,d1
	move.w	wiz4frc,d0
	move.w	aud4per,d4
	add.w	d4,d4
	add.w	d4,d4
	move.w	0(a2,d4.w),d3
	move.w	2(a2,d4.w),d2
	move.w	aud4vol,d4
	asl.w	#8,d4
	lea	0(a4,d4.w),a1
	moveq	#0,d4
	movea.l	samp1,a3
	bsr.s	v234
	cmp.l	wiz4len,d1
	blt.s	.ok4
	sub.w	wiz4rpt,d1
.ok4	move.w	d1,wiz4pos
	move.w	d0,wiz4frc
	add.w	#len_stf*2,add_stf_1+2
	add.w	#len_stf*2,add_stf_2+2
	subq.w	#1,(sp)
	bne	rep_play_stf
	clr.w	add_stf_1+2
	clr.w	add_stf_2+2
	lea	2(sp),sp
	movem.l	(sp)+,d0-d4/a0-a4
	rts
v234	
add_stf_2	adda.w	#0,a3
	REPT 	len_stf
	add.w	d2,d0
	addx.w	d3,d1
	move.b	0(a0,d1.l),d4
	move.b	0(a1,d4.w),d4
	add.w	d4,(a3)+
	ENDR
	rts

play_vec_st_replay
	move.l	a0,-(sp)
	move.w	(a6)+,d7
	lsr.w	#2,d7
	lea	$fffa0000,a0
	move.b	0(a0,d7.w),d7
	move.l	(sp)+,a0
	rte
	
play_vec_mv16	move.l	a0,-(sp)
	move.w	(a6)+,d7
	add.w	d7,d7
	add.w	d7,d7
	lea	$fffa0000,a0
	move.b	0(a0,d7.w),d7
	move.l	(sp)+,a0
	rte
	
prepare	lea	workspc,a6
	movea.l	samplestarts,a0
	movea.l	end_of_samples,a1
tostack	move.w	-(a1),-(a6)
	cmpa.l	a0,a1			; Move all samples to stack
	bgt.s	tostack
	lea	samplestarts,a2
	lea	data,a1
	movea.l	(a2),a0			; Start of samples
	movea.l	a0,a5			; Save samplestart in a5
ch_8	moveq	#$1e,d7
roop	move.l	a0,(a2)+			; Sampleposition
	tst.w	$2A(a1)
	beq.s	samplok			; Len=0 -> no sample
	tst.w	$2E(a1)			; Test repstrt
	bne.s	repne			; Jump if not zero
repeq	move.w	$2A(a1),d0			; Length of sample
	move.w	d0,d4
	subq.w	#1,d0
	movea.l	a0,a4
fromstk	move.w	(a6)+,(a0)+
	dbra	d0,fromstk
	bra.s	rep
repne	move.w	$2E(a1),d0
	move.w	d0,d4
	subq.w	#1,d0
	movea.l	a6,a4
get1st	move.w	(a4)+,(a0)+
	dbra	d0,get1st
	adda.w	$2A(a1),a6			; Move a6 to next sample
	adda.w	$2A(a1),a6
rep	movea.l	a0,a5
	moveq	#0,d1
toosmal	movea.l	a4,a3
	move.w	$30(a1),d0
	subq.w	#1,d0
moverep	move.w	(a3)+,(a0)+
	addq.w	#2,d1
	dbra	d0,moverep
	cmp.w	#320,d1			; Must be > 320
	blt.s	toosmal
	move.w	#320/2-1,d2
last320	move.w	(a5)+,(a0)+
	dbra	d2,last320
done	add.w	d4,d4
	move.w	d4,$2A(a1)			; length
	move.w	d1,$30(a1)			; Replen
	clr.w	$2E(a1)
samplok	lea	$1E(a1),a1
	dbra	d7,roop
	cmp.l	#workspc,a0
	bgt.s	.nospac
	rts
.nospac	illegal

init	lea	data,a0
	cmp.l	#'M.K.',$438(a0)
	bne.s	inst_15
	move	#$3b8,ch_1+2
	move.l	#$43c,ch_2+2
	move.b	#$1e,ch_3+1
	move.b	#$1e,ch_8+1
	move	#$3b8,ch_4+2
	move	#$43c,ch_5+2
	move.l	#data+$3b6,ch_6+2	
	move.l	#data+$3b7,ch_7+2
	bra.s	suite_init
inst_15	move	#$1d8,ch_1+2
	move.l	#$258,ch_2+2
	move.b	#$e,ch_3+1
	move.b	#$e,ch_8+1
	move	#$1d8,ch_4+2
	move	#$258,ch_5+2
	move.l	#data+$1d6,ch_6+2	
	move.l	#data+$1d7,ch_7+2
suite_init
ch_1	lea	$3B8(a0),a1
	moveq	#$7F,d0
	moveq	#0,d1
loop	move.l	d1,d2
	subq.w	#1,d0
lop2	move.b	(a1)+,d1
	cmp.b	d2,d1
	bgt.s	loop
	dbra	d0,lop2
	addq.b	#1,d2
	lea	samplestarts,a1
	asl.l	#8,d2
	asl.l	#2,d2
ch_2	add.l	#$43C,d2
	add.l	a0,d2
	movea.l	d2,a2
ch_3	moveq	#$1E,d0
lop3	clr.l	(a2)
	move.l	a2,(a1)+
	moveq	#0,d1
	move.w	42(a0),d1
	add.l	d1,d1
	adda.l	d1,a2
	adda.l	#$1E,a0
	dbra	d0,lop3
	move.l	a2,end_of_samples	
	rts

music	lea	data,a0
	addq.w	#$1,counter
	move.w	counter,d0
	cmp.w	speed,d0
	blt.s	nonew
	clr.w	counter
	bra	getnew
nonew	lea	voice1,a4
	lea	aud1lc,a3
	bsr	checkcom
	move.b	$13(a4),level
	lea	voice2,a4
	lea	aud2lc,a3
	bsr	checkcom
	move.b	$13(a4),level+1
	lea	voice3,a4
	lea	aud3lc,a3
	bsr	checkcom
	move.b	$13(a4),level+2
	lea	voice4,a4
	lea	aud4lc,a3
	bsr	checkcom
	move.b	$13(a4),level+3
	bra	endr

arpeggio	moveq	#0,d0
	move.w	counter,d0
	divs	#$3,d0
	swap	d0
	tst.w	d0
	beq.s	arp2
	cmp.w	#$2,d0
	beq.s	arp1
	moveq	#0,d0
	move.b	$3(a4),d0
	lsr.b	#4,d0
	bra.s	arp3
arp1	moveq	#0,d0
	move.b	$3(a4),d0
	and.b	#$F,d0
	bra.s	arp3
arp2	move.w	$10(a4),d2
	bra.s	arp4
arp3	add.w	d0,d0
	moveq	#0,d1
	move.w	$10(a4),d1
	lea	periods,a0
	moveq	#$24,d4
arploop	move.w	0(a0,d0.w),d2
	cmp.w	(a0),d1
	bge.s	arp4
	addq.l	#2,a0
	dbra	d4,arploop
	rts

arp4	move.w	d2,$6(a3)
	rts

getnew	lea	data,a0
	lea	$C(a0),a2
ch_4	lea	$3B8(a0),a1
ch_5	lea	$43c(a0),a0	
	moveq	#0,d0
	move.l	d0,d1
	move.b	songpos,d0
	move.b	0(a1,d0.w),d1
	asl.l	#8,d1
	asl.l	#2,d1
	add.w	pattpos,d1
	clr.w	dmacon
	lea	aud1lc,a3
	lea	voice1,a4
	bsr.s	playvoice
	lea	aud2lc,a3
	lea	voice2,a4
	bsr.s	playvoice
	lea	aud3lc,a3
	lea	voice3,a4
	bsr.s	playvoice
	lea	aud4lc,a3
	lea	voice4,a4
	bsr.s	playvoice
	bra	setdma

playvoice	move.l	0(a0,d1.l),(a4)
	addq.l	#4,d1
	moveq	#0,d2
	move.b	$2(a4),d2
	and.b	#$F0,d2
	lsr.b	#4,d2
	move.b	(a4),d0
	and.b	#$F0,d0
	or.b	d0,d2
	tst.b	d2
	beq.s	setregs
	moveq	#0,d3
	lea	samplestarts,a1
	move.l	d2,d4
	subq.l	#$1,d2
	asl.l	#2,d2
	mulu	#$1E,d4
	move.l	0(a1,d2.l),$4(a4)
	move.w	0(a2,d4.l),$8(a4)
	move.w	$2(a2,d4.l),$12(a4)
	move.w	$4(a2,d4.l),d3
	tst.w	d3
	beq.s	noloop
	move.l	$4(a4),d2
	add.w	d3,d3
	add.l	d3,d2
	move.l	d2,$A(a4)
	move.w	$4(a2,d4.l),d0
	add.w	$6(a2,d4.l),d0
	move.w	d0,8(a4)
	move.w	$6(a2,d4.l),$E(a4)
	move.w	$12(a4),$8(a3)
	bra.s	setregs

noloop	move.l	$4(a4),d2
	add.l	d3,d2
	move.l	d2,$A(a4)
	move.w	$6(a2,d4.l),$E(a4)
	move.w	$12(a4),$8(a3)
setregs	move.w	(a4),d0
	and.w	#$FFF,d0
	beq	checkcom2
	move.b	$2(a4),d0
	and.b	#$F,d0
	cmp.b	#$3,d0
	bne.s	setperiod
	bsr	setmyport
	bra	checkcom2

setperiod	move.w	(a4),$10(a4)
	andi.w	#$FFF,$10(a4)
	move.w	$14(a4),d0
	move.w	d0,dmactrl
	clr.b	$1B(a4)
	move.l	$4(a4),(a3)
	move.w	$8(a4),$4(a3)
	move.w	$10(a4),d0
	and.w	#$FFF,d0
	move.w	d0,$6(a3)
	move.w	$14(a4),d0
	or.w	d0,dmacon
	bra	checkcom2

setdma	move.w	dmacon,d0
	btst	#0,d0			
	beq.s	wz_nch1			
	move.l	aud1lc,wiz1lc	
	moveq	#0,d1			
	moveq	#0,d2			
	move.w	aud1len,d1	
	move.w	voice1+$E,d2	
	add.l	d2,d1			
	move.l	d1,wiz1len		
	move.w	d2,wiz1rpt		
	clr.w	wiz1pos			

wz_nch1	btst	#1,d0			
	beq.s	wz_nch2			
	move.l	aud2lc,wiz2lc	
	moveq	#0,d1			
	moveq	#0,d2			
	move.w	aud2len,d1		
	move.w	voice2+$E,d2	
	add.l	d2,d1			
	move.l	d1,wiz2len		
	move.w	d2,wiz2rpt		
	clr.w	wiz2pos			

wz_nch2	btst	#2,d0			
	beq.s	wz_nch3			
	move.l	aud3lc,wiz3lc	
	moveq	#0,d1			
	moveq	#0,d2			
	move.w	aud3len,d1		
	move.w	voice3+$E,d2	
	add.l	d2,d1			
	move.l	d1,wiz3len		
	move.w	d2,wiz3rpt		
	clr.w	wiz3pos			

wz_nch3	btst	#3,d0			
	beq.s	wz_nch4			
	move.l	aud4lc,wiz4lc	
	moveq	#0,d1			
	moveq	#0,d2			
	move.w	aud4len,d1		
	move.w	voice4+$E,d2	
	add.l	d2,d1			
	move.l	d1,wiz4len		
	move.w	d2,wiz4rpt		
	clr.w	wiz4pos			

wz_nch4	addi.w	#$10,pattpos
	cmpi.w	#$400,pattpos
	bne.s	endr
nex	clr.w	pattpos
	clr.b	break
	addq.b	#1,songpos
	andi.b	#$7F,songpos
	move.b	songpos,d1
ch_6	cmp.b	data+$3B6,d1
	bne.s	endr
ch_7	move.b	data+$3B7,songpos
endr:	tst.b	break
	bne.s	nex
	rts

setmyport	move.w	(a4),d2
	and.w	#$FFF,d2
	move.w	d2,$18(a4)
	move.w	$10(a4),d0
	clr.b	$16(a4)
	cmp.w	d0,d2
	beq.s	clrport
	bge.s	rt
	move.b	#$1,$16(a4)
	rts

clrport	clr.w	$18(a4)
rt	rts

myport	move.b	$3(a4),d0
	beq.s	myslide
	move.b	d0,$17(a4)
	clr.b	$3(a4)
myslide	tst.w	$18(a4)
	beq.s	rt
	moveq	#0,d0
	move.b	$17(a4),d0
	tst.b	$16(a4)
	bne.s	mysub
	add.w	d0,$10(a4)
	move.w	$18(a4),d0
	cmp.w	$10(a4),d0
	bgt.s	myok
	move.w	$18(a4),$10(a4)
	clr.w	$18(a4)

myok	move.w	$10(a4),$6(a3)
	rts

mysub	sub.w	d0,$10(a4)
	move.w	$18(a4),d0
	cmp.w	$10(a4),d0
	blt.s	myok
	move.w	$18(a4),$10(a4)
	clr.w	$18(a4)
	move.w	$10(a4),$6(a3)
	rts

vib	move.b	$3(a4),d0
	beq.s	vi
	move.b	d0,$1A(a4)

vi	move.b	$1B(a4),d0
	lea	sin,a1
	lsr.w	#$2,d0
	and.w	#$1F,d0
	moveq	#0,d2
	move.b	0(a1,d0.w),d2
	move.b	$1A(a4),d0
	and.w	#$F,d0
	mulu	d0,d2
	lsr.w	#$6,d2
	move.w	$10(a4),d0
	tst.b	$1B(a4)
	bmi.s	vibmin
	add.w	d2,d0
	bra.s	vib2

vibmin	sub.w	d2,d0
vib2	move.w	d0,$6(a3)
	move.b	$1A(a4),d0
	lsr.w	#$2,d0
	and.w	#$3C,d0
	add.b	d0,$1B(a4)
	rts

nop:	move.w	$10(a4),$6(a3)
	rts

checkcom	move.w	$2(a4),d0
	and.w	#$FFF,d0
	beq.s	nop
	move.b	$2(a4),d0
	and.b	#$F,d0
	tst.b	d0
	beq	arpeggio
	cmp.b	#$1,d0
	beq.s	portup
	cmp.b	#$2,d0
	beq	portdown
	cmp.b	#$3,d0
	beq	myport
	cmp.b	#$4,d0
	beq	vib
	cmp.b	#$5,d0
	beq	port_toneslide
	cmp.b	#$6,d0
	beq	vib_toneslide
	move.w	$10(a4),$6(a3)
	cmp.b	#$A,d0
	beq.s	volslide
	rts

volslide	moveq	#0,d0
	move.b	$3(a4),d0
	lsr.b	#4,d0
	tst.b	d0
	beq.s	voldown
	add.w	d0,$12(a4)
	cmpi.w	#$40,$12(a4)
	bmi.s	vol2
	move.w	#$40,$12(a4)
vol2	move.w	$12(a4),$8(a3)
	rts

voldown	moveq	#0,d0
	move.b	$3(a4),d0
	and.b	#$F,d0
	sub.w	d0,$12(a4)
	bpl.s	vol3
	clr.w	$12(a4)
vol3	move.w	$12(a4),$8(a3)
	rts

portup	moveq	#0,d0
	move.b	$3(a4),d0
	sub.w	d0,$10(a4)
	move.w	$10(a4),d0
	and.w	#$FFF,d0
	cmp.w	#$71,d0
	bpl.s	por2
	andi.w	#$F000,$10(a4)
	ori.w	#$71,$10(a4)
por2	move.w	$10(a4),d0
	and.w	#$FFF,d0
	move.w	d0,$6(a3)
	rts

port_toneslide	bsr	myslide
	bra.s	volslide

vib_toneslide	bsr	vi
	bra.s	volslide

portdown	clr.w	d0
	move.b	$3(a4),d0
	add.w	d0,$10(a4)
	move.w	$10(a4),d0
	and.w	#$FFF,d0
	cmp.w	#$358,d0
	bmi.s	por3
	andi.w	#$F000,$10(a4)
	ori.w	#$358,$10(a4)
por3	move.w	$10(a4),d0
	and.w	#$FFF,d0
	move.w	d0,$6(a3)
	rts

checkcom2	move.b	$2(a4),d0
	and.b	#$F,d0
	cmp.b	#$D,d0
	beq.s	pattbreak
	cmp.b	#$B,d0
	beq.s	posjmp
	cmp.b	#$C,d0
	beq.s	setvol
	cmp.b	#$F,d0
	beq.s	setspeed
	rts

pattbreak	st	break
	rts

posjmp	move.b	$3(a4),d0
	subq.b	#$1,d0
	move.b	d0,songpos
	st	break
	rts

setvol	moveq	#0,d0
	move.b	$3(a4),d0
	cmp.w	#$40,d0
	ble.s	vol4
	move.b	#$40,$3(a4)
vol4	move.b	$3(a4),$9(a3)
	move.b	$3(a4),$13(a4)
	rts

setspeed	cmpi.b	#$1F,$3(a4)
	ble.s	sets
	move.b	#$1F,$3(a4)
sets	move.b	$3(a4),d0
	beq.s	rts2
	move.w	d0,speed
	clr.w	counter
rts2	rts

play_vec_stf	move.w	(a6)+,d7
	lsl.w	#4,d7
	movem.l	snd_tab(pc,d7.w),d5-d7
	movem.l	d5-d7,$FFFF8800.w
	rte

	even
snd_tab	REPT 	384
	DC.L 	$08000F00,$09000A00,$0A000000,0
	ENDR
	DC.L 	$08000F00,$09000A00,$0A000000,0
	DC.L 	$08000F00,$09000A00,$0A000000,0
	DC.L 	$08000F00,$09000900,$0A000900,0
	DC.L 	$08000F00,$09000900,$0A000900,0
	DC.L 	$08000F00,$09000900,$0A000800,0
	DC.L 	$08000F00,$09000900,$0A000800,0
	DC.L 	$08000F00,$09000800,$0A000700,0
	DC.L 	$08000F00,$09000800,$0A000700,0
	DC.L 	$08000E00,$09000B00,$0A000D00,0
	DC.L 	$08000E00,$09000B00,$0A000D00,0
	DC.L 	$08000E00,$09000D00,$0A000B00,0
	DC.L 	$08000E00,$09000D00,$0A000B00,0
	DC.L 	$08000E00,$09000A00,$0A000D00,0
	DC.L 	$08000E00,$09000A00,$0A000D00,0
	DC.L 	$08000E00,$09000C00,$0A000C00,0
	DC.L 	$08000E00,$09000C00,$0A000C00,0
	DC.L 	$08000E00,$09000D00,$0A000A00,0
	DC.L 	$08000E00,$09000D00,$0A000A00,0
	DC.L 	$08000E00,$09000D00,$0A000900,0
	DC.L 	$08000E00,$09000D00,$0A000900,0
	DC.L 	$08000E00,$09000D00,$0A000800,0
	DC.L 	$08000E00,$09000D00,$0A000800,0
	DC.L 	$08000E00,$09000D00,$0A000700,0
	DC.L 	$08000E00,$09000D00,$0A000700,0
	DC.L 	$08000E00,$09000D00,$0A000000,0
	DC.L 	$08000E00,$09000D00,$0A000000,0
	DC.L 	$08000B00,$09000E00,$0A000C00,0
	DC.L 	$08000B00,$09000E00,$0A000C00,0
	DC.L 	$08000E00,$09000B00,$0A000C00,0
	DC.L 	$08000E00,$09000B00,$0A000C00,0
	DC.L 	$08000E00,$09000C00,$0A000B00,0
	DC.L 	$08000E00,$09000C00,$0A000B00,0
	DC.L 	$08000A00,$09000E00,$0A000C00,0
	DC.L 	$08000A00,$09000E00,$0A000C00,0
	DC.L 	$08000E00,$09000A00,$0A000C00,0
	DC.L 	$08000E00,$09000A00,$0A000C00,0
	DC.L 	$08000E00,$09000C00,$0A000A00,0
	DC.L 	$08000E00,$09000C00,$0A000A00,0
	DC.L 	$08000E00,$09000900,$0A000C00,0
	DC.L 	$08000E00,$09000900,$0A000C00,0
	DC.L 	$08000E00,$09000C00,$0A000900,0
	DC.L 	$08000E00,$09000C00,$0A000900,0
	DC.L 	$08000E00,$09000C00,$0A000800,0
	DC.L 	$08000E00,$09000C00,$0A000800,0
	DC.L 	$08000E00,$09000C00,$0A000800,0
	DC.L 	$08000E00,$09000C00,$0A000700,0
	DC.L 	$08000E00,$09000C00,$0A000700,0
	DC.L 	$08000E00,$09000C00,$0A000600,0
	DC.L 	$08000E00,$09000C00,$0A000300,0
	DC.L 	$08000D00,$09000D00,$0A000B00,0
	DC.L 	$08000D00,$09000D00,$0A000B00,0
	DC.L 	$08000D00,$09000D00,$0A000B00,0
	DC.L 	$08000E00,$09000B00,$0A000A00,0
	DC.L 	$08000E00,$09000B00,$0A000A00,0
	DC.L 	$08000D00,$09000C00,$0A000C00,0
	DC.L 	$08000D00,$09000C00,$0A000C00,0
	DC.L 	$08000D00,$09000C00,$0A000C00,0
	DC.L 	$08000D00,$09000D00,$0A000A00,0
	DC.L 	$08000D00,$09000D00,$0A000A00,0
	DC.L 	$08000E00,$09000B00,$0A000800,0
	DC.L 	$08000E00,$09000B00,$0A000800,0
	DC.L 	$08000E00,$09000B00,$0A000800,0
	DC.L 	$08000D00,$09000D00,$0A000900,0
	DC.L 	$08000D00,$09000D00,$0A000900,0
	DC.L 	$08000E00,$09000A00,$0A000900,0
	DC.L 	$08000E00,$09000A00,$0A000900,0
	DC.L 	$08000D00,$09000D00,$0A000800,0
	DC.L 	$08000D00,$09000D00,$0A000700,0
	DC.L 	$08000D00,$09000D00,$0A000600,0
	DC.L 	$08000D00,$09000D00,$0A000600,0
	DC.L 	$08000E00,$09000900,$0A000900,0
	DC.L 	$08000E00,$09000900,$0A000900,0
	DC.L 	$08000E00,$09000800,$0A000900,0
	DC.L 	$08000E00,$09000800,$0A000900,0
	DC.L 	$08000E00,$09000900,$0A000800,0
	DC.L 	$08000E00,$09000900,$0A000800,0
	DC.L 	$08000E00,$09000700,$0A000900,0
	DC.L 	$08000E00,$09000900,$0A000700,0
	DC.L 	$08000E00,$09000900,$0A000700,0
	DC.L 	$08000E00,$09000900,$0A000600,0
	DC.L 	$08000E00,$09000900,$0A000600,0
	DC.L 	$08000E00,$09000800,$0A000700,0
	DC.L 	$08000E00,$09000800,$0A000700,0
	DC.L 	$08000E00,$09000800,$0A000600,0
	DC.L 	$08000E00,$09000800,$0A000600,0
	DC.L 	$08000E00,$09000800,$0A000400,0
	DC.L 	$08000E00,$09000800,$0A000400,0
	DC.L 	$08000E00,$09000700,$0A000500,0
	DC.L 	$08000E00,$09000700,$0A000400,0
	DC.L 	$08000E00,$09000700,$0A000300,0
	DC.L 	$08000E00,$09000600,$0A000400,0
	DC.L 	$08000E00,$09000600,$0A000300,0
	DC.L 	$08000E00,$09000500,$0A000400,0
	DC.L 	$08000E00,$09000500,$0A000200,0
	DC.L 	$08000E00,$09000400,$0A000200,0
	DC.L 	$08000E00,$09000300,$0A000200,0
	DC.L 	$08000E00,$09000000,$0A000000,0
	DC.L 	$08000D00,$09000B00,$0A000A00,0
	DC.L 	$08000D00,$09000B00,$0A000A00,0
	DC.L 	$08000A00,$09000C00,$0A000C00,0
	DC.L 	$08000A00,$09000C00,$0A000C00,0
	DC.L 	$08000C00,$09000A00,$0A000C00,0
	DC.L 	$08000D00,$09000900,$0A000B00,0
	DC.L 	$08000D00,$09000900,$0A000B00,0
	DC.L 	$08000D00,$09000B00,$0A000900,0
	DC.L 	$08000D00,$09000B00,$0A000900,0
	DC.L 	$08000D00,$09000B00,$0A000900,0
	DC.L 	$08000D00,$09000A00,$0A000A00,0
	DC.L 	$08000D00,$09000A00,$0A000A00,0
	DC.L 	$08000900,$09000C00,$0A000C00,0
	DC.L 	$08000C00,$09000C00,$0A000900,0
	DC.L 	$08000C00,$09000C00,$0A000900,0
	DC.L 	$08000C00,$09000C00,$0A000900,0
	DC.L 	$08000800,$09000C00,$0A000C00,0
	DC.L 	$08000800,$09000C00,$0A000C00,0
	DC.L 	$08000C00,$09000C00,$0A000800,0
	DC.L 	$08000C00,$09000C00,$0A000800,0
	DC.L 	$08000D00,$09000B00,$0A000400,0
	DC.L 	$08000D00,$09000B00,$0A000400,0
	DC.L 	$08000C00,$09000C00,$0A000700,0
	DC.L 	$08000C00,$09000C00,$0A000600,0
	DC.L 	$08000C00,$09000C00,$0A000600,0
	DC.L 	$08000C00,$09000C00,$0A000500,0
	DC.L 	$08000D00,$09000A00,$0A000700,0
	DC.L 	$08000D00,$09000A00,$0A000600,0
	DC.L 	$08000D00,$09000A00,$0A000600,0
	DC.L 	$08000D00,$09000A00,$0A000500,0
	DC.L 	$08000D00,$09000900,$0A000800,0
	DC.L 	$08000C00,$09000B00,$0A000900,0
	DC.L 	$08000B00,$09000B00,$0A000B00,0
	DC.L 	$08000D00,$09000800,$0A000800,0
	DC.L 	$08000D00,$09000800,$0A000800,0
	DC.L 	$08000C00,$09000B00,$0A000800,0
	DC.L 	$08000D00,$09000900,$0A000500,0
	DC.L 	$08000D00,$09000900,$0A000400,0
	DC.L 	$08000D00,$09000800,$0A000600,0
	DC.L 	$08000C00,$09000B00,$0A000700,0
	DC.L 	$08000D00,$09000700,$0A000700,0
	DC.L 	$08000C00,$09000B00,$0A000600,0
	DC.L 	$08000B00,$09000B00,$0A000A00,0
	DC.L 	$08000800,$09000A00,$0A000C00,0
	DC.L 	$08000C00,$09000B00,$0A000200,0
	DC.L 	$08000C00,$09000A00,$0A000800,0
	DC.L 	$08000C00,$09000B00,$0A000000,0
	DC.L 	$08000D00,$09000600,$0A000400,0
	DC.L 	$08000D00,$09000500,$0A000500,0
	DC.L 	$08000C00,$09000900,$0A000900,0
	DC.L 	$08000D00,$09000500,$0A000400,0
	DC.L 	$08000B00,$09000B00,$0A000900,0
	DC.L 	$08000D00,$09000400,$0A000300,0
	DC.L 	$08000B00,$09000A00,$0A000A00,0
	DC.L 	$08000C00,$09000A00,$0A000500,0
	DC.L 	$08000C00,$09000900,$0A000800,0
	DC.L 	$08000B00,$09000B00,$0A000800,0
	DC.L 	$08000C00,$09000A00,$0A000000,0
	DC.L 	$08000C00,$09000A00,$0A000000,0
	DC.L 	$08000C00,$09000900,$0A000700,0
	DC.L 	$08000B00,$09000B00,$0A000700,0
	DC.L 	$08000C00,$09000900,$0A000600,0
	DC.L 	$08000B00,$09000A00,$0A000900,0
	DC.L 	$08000B00,$09000B00,$0A000600,0
	DC.L 	$08000A00,$09000A00,$0A000A00,0
	DC.L 	$08000B00,$09000B00,$0A000500,0
	DC.L 	$08000B00,$09000A00,$0A000800,0
	DC.L 	$08000B00,$09000B00,$0A000200,0
	DC.L 	$08000C00,$09000700,$0A000700,0
	DC.L 	$08000C00,$09000800,$0A000400,0
	DC.L 	$08000C00,$09000700,$0A000600,0
	DC.L 	$08000B00,$09000900,$0A000900,0
	DC.L 	$08000A00,$09000A00,$0A000900,0
	DC.L 	$08000C00,$09000600,$0A000600,0
	DC.L 	$08000C00,$09000700,$0A000300,0
	DC.L 	$08000B00,$09000A00,$0A000500,0
	DC.L 	$08000B00,$09000900,$0A000800,0
	DC.L 	$08000B00,$09000A00,$0A000300,0
	DC.L 	$08000A00,$09000A00,$0A000800,0
	DC.L 	$08000B00,$09000A00,$0A000000,0
	DC.L 	$08000B00,$09000900,$0A000700,0
	DC.L 	$08000B00,$09000800,$0A000800,0
	DC.L 	$08000A00,$09000900,$0A000900,0
	DC.L 	$08000A00,$09000A00,$0A000700,0
	DC.L 	$08000C00,$09000100,$0A000100,0
	DC.L 	$08000A00,$09000A00,$0A000600,0
	DC.L 	$08000B00,$09000800,$0A000700,0
	DC.L 	$08000A00,$09000A00,$0A000500,0
	DC.L 	$08000A00,$09000900,$0A000800,0
	DC.L 	$08000A00,$09000A00,$0A000400,0
	DC.L 	$08000A00,$09000A00,$0A000300,0
	DC.L 	$08000A00,$09000A00,$0A000200,0
	DC.L 	$08000900,$09000900,$0A000900,0
	DC.L 	$08000A00,$09000800,$0A000800,0
	DC.L 	$08000B00,$09000800,$0A000100,0
	DC.L 	$08000A00,$09000900,$0A000600,0
	DC.L 	$08000B00,$09000700,$0A000400,0
	DC.L 	$08000A00,$09000900,$0A000500,0
	DC.L 	$08000900,$09000900,$0A000800,0
	DC.L 	$08000A00,$09000900,$0A000300,0
	DC.L 	$08000A00,$09000800,$0A000600,0
	DC.L 	$08000900,$09000900,$0A000700,0
	DC.L 	$08000A00,$09000900,$0A000000,0
	DC.L 	$08000900,$09000800,$0A000800,0
	DC.L 	$08000A00,$09000800,$0A000400,0
	DC.L 	$08000900,$09000900,$0A000600,0
	DC.L 	$08000A00,$09000800,$0A000100,0
	DC.L 	$08000900,$09000900,$0A000500,0
	DC.L 	$08000900,$09000800,$0A000700,0
	DC.L 	$08000800,$09000800,$0A000800,0
	DC.L 	$08000900,$09000800,$0A000600,0
	DC.L 	$08000900,$09000900,$0A000200,0
	DC.L 	$08000900,$09000700,$0A000700,0
	DC.L 	$08000900,$09000900,$0A000000,0
	DC.L 	$08000800,$09000800,$0A000700,0
	DC.L 	$08000900,$09000700,$0A000600,0
	DC.L 	$08000800,$09000800,$0A000600,0
	DC.L 	$08000900,$09000800,$0A000200,0
	DC.L 	$08000900,$09000600,$0A000600,0
	DC.L 	$08000800,$09000700,$0A000700,0
	DC.L 	$08000800,$09000800,$0A000400,0
	DC.L 	$08000800,$09000700,$0A000600,0
	DC.L 	$08000800,$09000800,$0A000200,0
	DC.L 	$08000700,$09000700,$0A000700,0
	DC.L 	$08000800,$09000600,$0A000600,0
	DC.L 	$08000800,$09000700,$0A000400,0
	DC.L 	$08000700,$09000700,$0A000600,0
	DC.L 	$08000800,$09000600,$0A000500,0
	DC.L 	$08000800,$09000600,$0A000400,0
	DC.L 	$08000700,$09000600,$0A000600,0
	DC.L 	$08000700,$09000700,$0A000400,0
	DC.L 	$08000800,$09000500,$0A000400,0
	DC.L 	$08000600,$09000600,$0A000600,0
	DC.L 	$08000700,$09000600,$0A000400,0
	DC.L 	$08000700,$09000500,$0A000500,0
	DC.L 	$08000600,$09000600,$0A000500,0
	DC.L 	$08000600,$09000600,$0A000400,0
	DC.L 	$08000600,$09000500,$0A000500,0
	DC.L 	$08000600,$09000600,$0A000200,0
	DC.L 	$08000600,$09000500,$0A000400,0
	DC.L 	$08000500,$09000500,$0A000500,0
	DC.L 	$08000600,$09000500,$0A000200,0
	DC.L 	$08000500,$09000500,$0A000400,0
	DC.L 	$08000500,$09000400,$0A000400,0
	DC.L 	$08000500,$09000500,$0A000200,0
	DC.L 	$08000400,$09000400,$0A000400,0
	DC.L 	$08000400,$09000400,$0A000300,0
	DC.L 	$08000400,$09000400,$0A000200,0
	DC.L 	$08000400,$09000300,$0A000300,0
	DC.L 	$08000300,$09000300,$0A000300,0
	DC.L 	$08000300,$09000300,$0A000200,0
	DC.L 	$08000300,$09000200,$0A000200,0
	DC.L 	$08000200,$09000200,$0A000200,0
	DC.L 	$08000200,$09000200,$0A000100,0
	DC.L 	$08000100,$09000100,$0A000100,0
	DC.L 	$08000200,$09000100,$0A000000,0
	DC.L 	$08000100,$09000100,$0A000000,0
	DC.L 	$08000100,$09000000,$0A000000,0
	DC.L 	$08000000,$09000000,$0A000000,0
	REPT 	384
	DC.L 	$08000000,$09000000,$0A000000,0
	ENDR
	even
sav_usp	ds.l	1
sav_a7	ds.l	1
sav_rez	ds.w	1
sav_screen	ds.l	1
sav_hz	ds.w	1
sav_pal	ds.w	16
mfp	ds.b	20
sav_vbl	ds.l	1
sav_timer_b	ds.l	1
sav_timer_d	ds.l	1
	even
wiz1lc	DC.L 	sample1
wiz1len	DC.L 	320	
wiz1rpt	DC.W 	320
wiz1pos	DC.W 	0
wiz1frc	DC.W 	0
wiz2lc	DC.L 	sample1
wiz2len	DC.L 	320
wiz2rpt	DC.W 	320
wiz2pos	DC.W 	0
wiz2frc	DC.W 	0
wiz3lc	DC.L 	sample1
wiz3len	DC.L 	320
wiz3rpt	DC.W 	320
wiz3pos	DC.W 	0
wiz3frc	DC.W 	0
wiz4lc	DC.L 	sample1
wiz4len	DC.L 	320
wiz4rpt	DC.W 	320
wiz4pos	DC.W 	0
wiz4frc	DC.W 	0
aud1lc	DC.L 	dummy
aud1len	DC.W 	0
aud1per	DC.W 	0
aud1vol	DC.W 	0
	DS.W 	3
aud2lc	DC.L 	dummy
aud2len	DC.W 	0
aud2per	DC.W 	0
aud2vol	DC.W 	0
	DS.W 	3
aud3lc	DC.L 	dummy
aud3len	DC.W 	0	
aud3per	DC.W 	0
aud3vol	DC.W 	0
	DS.W 	3
aud4lc	DC.L 	dummy
aud4len	DC.W 	0
aud4per	DC.W 	0
aud4vol	DC.W 	0
dmactrl	DC.W 	0
dummy	DC.L 	0
samp1	DC.L 	sample1
samp2	DC.L 	sample2
sample1	ds.w	len_ste*5
sample2	ds.w	len_ste*5
level	ds.b	4
out_inter	dc.l	play_vec_stf,play_vec_st_replay,play_vec_mv16
end_of_samples	DC.L 	0
itab	DS.L 	$30
stab	DS.L 	$3A0-$30
vtab	DS.B 	65*256	
vtabend	even
sin	DC.B 	$00,$18,$31,$4A,$61,$78,$8D,$A1,$B4,$C5,$D4,$E0,$EB,$F4,$FA,$FD
	DC.B 	$FF,$FD,$FA,$F4,$EB,$E0,$D4,$C5,$B4,$A1,$8D,$78,$61,$4A,$31,$18
	even
periods	DC.W 	$0358,$0328,$02FA,$02D0,$02A6,$0280,$025C,$023A,$021A,$01FC,$01E0
	DC.W 	$01C5,$01AC,$0194,$017D,$0168,$0153,$0140,$012E,$011D,$010D,$FE
	DC.W 	$F0,$E2,$D6,$CA,$BE,$B4,$AA,$A0,$97,$8F,$87
	DC.W 	$7F,$78,$71,$00,$00
speed	DC.W 	$06	
counter	DC.W 	$00
songpos	DC.B 	$00
break	DC.B 	$00
pattpos	DC.W 	$00
dmacon	DC.W 	$00
samplestarts	DS.L 	$1F
voice1	DS.W 	10
	DC.W 	$01
	DS.W 	3
voice2	DS.W 	10
	DC.W 	$02
	DS.W 	3
voice3	DS.W 	10
	DC.W 	$04
	DS.W 	3
voice4	DS.W 	10
	DC.W 	$08
	DS.W 	3
st	dc.b	0
out	dc.b	0
	even
col_txt	dc.w	$737,$736,$735,$734,$733,$732,$731,$730
	dc.w	$630,$640,$540,$550,$450,$460,$360,$370
	dc.w	$371,$271,$272,$172,$173,$073,$074,$075
	dc.w	$076,$077,$177,$277,$377,$477,$577,$677
	dc.w	$777,$776,$775,$774,$773,$772,$771,$770
	dc.w	$670,$570,$470,$370,$270,$170,$070,$071
	dc.w	$061,$062,$052,$053,$043,$044,$034,$035
	dc.w	$025,$026,$016,$017,$007,$107,$207,$307
	dc.w	$407,$406,$506,$505,$605,$604,$704,$703
	dc.w	$713,$613,$623,$523,$533,$433,$443,$343
	dc.w	$353,$253,$263,$163,$173,$073,$074,$075
	dc.w	$076,$077,$067,$057,$047,$037,$027,$017
	dc.w	$007,$107,$207,$307,$407,$507,$607,$707
	dc.w	$717,$727
buf_col	ds.w	106*2*2+4
pt_col	ds.l	1
tab_ver	dcb.b	50,0
	dcb.b	25,1
	dcb.b	400,0
	dcb.b	25,-1
	dcb.b	100,0
	dcb.b	20,1
	dcb.b	15,-1
	dcb.b	20,1
	dcb.b	400,0
	dcb.b	25,-1
	dcb.b	25,1
	dcb.b	25,-1
	dcb.b	25,1
	dcb.b	400,0
	dcb.b	25,-1
	dcb.b	50,0
end_tab_ver	even
pt_tab	ds.l	1
pos_hbl	dc.w	0
pos_scr	dc.l	scr1
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
adr_eff_scr	dc.l	160*100,160*101
s_hbl1	dc.l	4
s_hbl2	dc.w	1
pt_wait	dc.w	32*10
pt_table	ds.l	1
pos_fnt_sav	ds.b	10*17
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
nbr_text	dc.l	23
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
	dc.b	"` NO BUDDIES LAND  `"
	dc.b	"` ```````````````  `"
	dc.b	"`                  `"
	dc.b	"`      FROM        `"
	dc.b	"`                  `"
	dc.b	"` EXPOSE SOFTWARE  `"
	dc.b	"`                  `"
	dc.b	"```````````````````` "
	even
	dc.b	"\\\\\\\\\\\\\\\\\\\\"
	dc.b	"\                  \"
	dc.b	"\      CRACKED     \"
	dc.b	"\       FILED      \"
	dc.b	"\    MEGATRAINED   \"
	dc.b	"\                  \"
	dc.b	"\     BY FUZION    \"
	dc.b	"\ CRACKING SERVICE \"
	dc.b	"\                  \"
	dc.b	"\\\\\\\\\\\\\\\\\\\\ "
	EVEN
	dc.b	"********************"
	dc.b	"*                  *"
	dc.b	"*   LITTLE INTRO   *"
	DC.B	"*  FASTLY CODED BY *"
	DC.B	"*      FUZION      *"
	DC.B	"*                  *"
	DC.B	"*  GREAT MUSAX BY  *"
	DC.B	"*       MOBY       *"
	DC.B	"*                  *"
	DC.B	"******************** "
	even
	dc.b	"````````````````````"
	dc.b	"`                  `"
	dc.b	"`  ENJOY THE MEGA  `"
	dc.b	"` SOUND ON THE STE `"
	dc.b	"`  OR THE SHITTY   `"
	dc.b	"`SOUND IF YOU HAVE `"
	dc.b	"`  A SHITTY STF..  `"
	dc.b	"` ROUTS BY WIZCAT! `"
	dc.b	"`                  `"
	dc.b	"```````````````````` "
	even
	dc.B	"]]]]]]]]]]]]]]]]]]]]"
	dc.B	"]                  ]"
	DC.B	"]  DIS GAME COULD  ]"
	DC.B	"]    HAVE BEEN     ]"
	DC.B	"]CRACKED BY BUST OF]"
	DC.B	"]  ICS BUT HE WAS  ]"
	DC.B	"]TOO LAME TO DO IT!]"
	dc.b	"] SORRY MAURICE... ]"
	DC.B	"]                  ]"
	DC.B	"]]]]]]]]]]]]]]]]]]]] "
	even
	dc.b	"[[[[[[[[[[[[[[[[[[[["
	dc.b	"[                  ["
	dc.b	"[ BEST REGARDS TO: ["
	DC.B	"[                  ["
	DC.B	"[ ILLEGAL,ZAE,NEXT ["
	DC.B	"[ AND ZARATHOUSTRA ["
	DC.B	"[FOR DIS NICE GAME!["
	DC.B	"[BUT A POOR PROTECT["
	DC.B	"[                  ["
	DC.B	"[[[[[[[[[[[[[[[[[[[[ "
	EVEN
	dc.B	"]]]]]]]]]]]]]]]]]]]]"
	dc.B	"]                  ]"
	DC.B	"]  HEY EXPOSE YOU  ]"
	DC.B	"] SAID IN THE GAME ]"
	DC.B	"] THIS PROTECT WAS ]"
	DC.B	"]    THE END OF    ]"
	DC.B	"] CRACKING... NEXT ]"
	dc.b	"]  TIME MAYBE...?  ]"
	DC.B	"]                  ]"
	DC.B	"]]]]]]]]]]]]]]]]]]]] "
	even
	dc.b	"********************"
	dc.b	"*                  *"
	dc.b	"* ANYWAY IF WE HAD *"
	DC.B	"* NOT DONE IT,SOME *"
	DC.B	"* BODY ELSE WOULD  *"
	DC.B	"* HAVE... CRACKING *"
	DC.B	"* IS CRACKING, YOU *"
	DC.B	"*WILL NOT CHANGE IT*"
	DC.B	"*                  *"
	DC.B	"******************** "
	EVEN
	DC.B	"[[[[[[[[[[[[[[[[[[[["
	DC.B	"[                  ["
	DC.B	"[AND I DO NOT THINK["
	DC.B	"[  WE ARE THE ONLY ["
	DC.B	"[ONES TO CRACK THIS["
	DC.B	"[ GAME, MAYBE JUST ["
                DC.B	"[ THE ONLY ONES TO ["
                DC.B	"[    SIGN IT ...   ["                       
	DC.B	"[                  ["
	DC.B	"[[[[[[[[[[[[[[[[[[[[ "        
	even
	dc.b	"````````````````````"
	dc.b	"`  FUZION MEMBERS  `"
	dc.b	"`ORION ELLFIRE BVCA`"
	dc.b	"`TURBO KELVIN KASAR`"
	dc.b	"`ST FOREVER THE FOX`"
	dc.b	"`INFIRMIER  FULCRUM`"
	dc.b	"`ALANPARKER KELLY.X`"
	dc.b	"`MACDOS SHIRYU DUMP`"
	DC.B	"`    AND SQUAT!    `"
	dc.b	"```````````````````` "
	even
	dc.b	"\\\\\\\\\\\\\\\\\\\\"
	DC.B	"\                  \"
	DC.B	"\ BEST REGARDS TO: \"
	DC.B	"\                  \"
	DC.B	"\   DOCNO OF TSB   \"
	DC.B	"\  SNAKE AND R.AL  \"
	DC.B	"\  OF REPLICANTS!  \"
	DC.B	"\ CELTIK & BLUEMAX \"
	DC.B	"\                  \"
	DC.B	"\\\\\\\\\\\\\\\\\\\\ "
	EVEN
	dc.b            "********************"
	dc.b	"*                  *"
	dc.b	"*      CYNIX       *"
	dc.b	"*     QUARTEX      *"
	dc.b	"*      D-BUG       *"
	dc.b	"*   THUNDERBIRDS   *"
	dc.b	"*  WANDERER & ALL  *"
	dc.b	"*  FROM SUPERIOR!  *"
	dc.b	"*                  *"
	dc.b	"******************** "
	even
	dc.b            "[[[[[[[[[[[[[[[[[[[["
	dc.b	"[                  ["
	dc.b	"[      UNITY       ["
	dc.b	"[  PENGUIN AND ALL ["
	dc.b	"[  OF ANIMAL MINE! ["
	dc.b	"[      ELITE       ["
	dc.b	"[ TICK TOCK/FALCON ["
	dc.b	"[  OF PURE ENERGY  ["
	dc.b	"[                  ["
	dc.b	"[[[[[[[[[[[[[[[[[[[[ "
	even
	dc.b            "````````````````````"
	dc.b	"`                  `"
	dc.b	"`   DUX OF STAX    `"
	dc.b	"`TITANIC TARZAN OF `"
	dc.b	"`      R.I.P       `"
	dc.b	"`  XENEX-DEMOZONE  `"
	DC.B	"` BEVERLY HILL COP `"
	dc.b	"`    FROM MCS!     `"
	dc.b	"`                  `"
	dc.b	"```````````````````` "
	even
	dc.b	"\\\\\\\\\\\\\\\\\\\\"
	DC.B	"\                  \"
	DC.B	"\SPY3 OF MAD VISION\"
	DC.B	"\    KID/FMC-CNX   \"
	DC.B	"\ BAD BOYS BELGIUM \"
	DC.B	"\     SYNDICATE    \"
	DC.B	"\   YOGI/FORCE 69  \"
	DC.B	"\      DNT-CREW    \"
	DC.B	"\                  \"
	DC.B	"\\\\\\\\\\\\\\\\\\\\ "
	EVEN
	dc.b            "********************"
	dc.b	"*                  *"
	dc.b	"*  SPIKE OF ORION  *"
	dc.b	"*    AXXIS & NPG   *"
	dc.b	"*POWERMAN/WILD BOYS*"
	dc.b	"*     ST-REBELS    *"
	dc.b	"*  CAPTAIN CANCER  *"
	dc.b	"*  OF GENESIS INC  *"
	dc.b	"*                  *"
	dc.b	"******************** "
	even
	dc.b            "[[[[[[[[[[[[[[[[[[[["
	dc.b	"[                  ["
	dc.b	"[ MATT/UNTOUCHABLES["
	dc.b	"[       PHF        ["
	dc.b	"[ THE LAZY PHANTOM ["
	dc.b	"[ OF INNER CIRCLE! ["
	dc.b	"[    RIPPED OFF    ["
	dc.b	"[  THE LOST BOYS   ["
	dc.b	"[                  ["
	dc.b	"[[[[[[[[[[[[[[[[[[[[ "
	even
	dc.b            "````````````````````"
	dc.b	"`                  `"
	dc.b	"`      GENESIS     `"
	dc.b	"`   THE VOYAGERS   `"
	dc.b	"`  THE MEGABUSTERS `"
	dc.b	"`   MEGA THANX TO  `"
	DC.B	"` PAT CASH FOR WHAT`"
	dc.b	"`    YOU KNOW !!   `"
	dc.b	"`                  `"
	dc.b	"```````````````````` "
	even
	dc.B	"]]]]]]]]]]]]]]]]]]]]"
	dc.B	"]                  ]"
	DC.B	"]   PHENIX - TBC   ]"
	DC.B	"]   ST-CONNEXION   ]"
	DC.B	"]        FM        ]"
	DC.B	"]    RED BARONS    ]"
	DC.B	"] LAURENZO - CONAN ]"
	dc.b	"]   ELLE2 - CORPO  ]"
	DC.B	"]                  ]"
	DC.B	"]]]]]]]]]]]]]]]]]]]] "
	even
	dc.b            "********************"
	dc.b	"*                  *"
	dc.b	"*    FUCK OFF TO   *"
	dc.b	"*DEF KLF/MAD VISION*"
	dc.b	"*                  *"
	dc.b	"*  WE HEARD ABOUT  *"
	dc.b	"* LAME MESSAGES IN *"
	dc.b	"*THE MASSIVE ATTACK*"
	dc.b	"*                  *"
	dc.b	"******************** "
	even
	dc.b            "````````````````````"
	dc.b	"`                  `"
	dc.b	"`  HEY FACTORIP !  `"
	dc.b	"`  NOW THAT WE'VE  `"
	dc.b	"` DONE IT, YOU CAN `"
	dc.b	"` RIP IT, AND MAKE `"
	DC.B	"` YOUR OWN VERSION `"
	dc.b	"` AS USUAL.LAMERS! `"
	dc.b	"`                  `"
	dc.b	"```````````````````` "
	even
	dc.b	"\\\\\\\\\\\\\\\\\\\\"
	DC.B	"\                  \"
	DC.B	"\TO HAVE OUR LATEST\"
	DC.B	"\CRACKS OR GREAT CD\"
	DC.B	"\WRITE TO OUR USUAL\"
	DC.B	"\      ADRESS!     \"
	DC.B	"\    1992 FUZION   \"
	DC.B	"\    LET'S WRAP!   \"
	DC.B	"\                  \"
	DC.B	"\\\\\\\\\\\\\\\\\\\\ "
	EVEN

pic	incbin	\orion.src\fuzion.crk\sndtrack\fuzion01.pi1
	even
buffer_prog	*incbin	b:\*.prg
	even
fonts	incbin	\orion.src\fuzion.crk\sndtrack\16x16_3.fnt
buf_ret_fnt	ds.b	16*2*16*72
	even
data	incbin	\orion.src\fuzion.crk\sndtrack\awes.mod
	ds.b	20000
workspc	ds.w	1
	end
