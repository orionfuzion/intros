	*************************************
	* Intro      20-38                  *
	* Coder      ORION from FUZION      *
	* Usage      FUZION Compact Disks   *
	* Date       Nov 1990 - CD#20       *
	*                                   *
	* Machine    Atari STE - 1MB RAM    *	
	* TOS        1.62                   *
	* Assembler  GenST v2.09            *
	* Emulator   Steem v3.2             *
	*                                   *
	* Contact    Orion.Fuzion@gmail.com *
	*************************************

p_tbase	move.l	sp,save_reg+$3c
	lea	pile+$140,sp
	pea	intro
	move	#$26,-(sp)
	trap	#14
	addq	#6,sp
	move.l	save_reg+$3c,sp
	bra	run
quit	addq.l	#4,sp
	clr.l	-(sp)
	trap	#1
		
intro	bsr	save_all
	bsr	set_scr
	bsr	preca_def
	moveq	#1,d0
	jsr	music
	bsr	inter_on
loop	move.b	$fffffc02.w,d0
t1	cmp.b	#$6d,d0
	bne	t2
	move.l	#nom1,nom+2
	bra	bye1
t2	cmp.b	#$6e,d0
	bne	t3
	move.l	#nom2,nom+2
	bra	bye1
t3	cmp.b	#$6f,d0
	bne	t4
	move.l	#nom3,nom+2
	bra	bye1
t4	cmp.b	#$6a,d0
	bne	t5
	move.l	#nom4,nom+2
	bra	bye1
t5	cmp.b	#$6b,d0
	bne	t6
	move.l	#nom5,nom+2
	bra	bye1
t6	cmp.b	#$6c,d0
	bne	t7
	move.l	#nom6,nom+2
	bra	bye1
t7	cmp.b	#$67,d0
	bne	f1
	move.l	#nom7,nom+2
	bra	bye1
f1	cmp.b	#$3b,d0
	bne	f2
	move.l	#nomf1,nom+2
	bra	bye1
f2	cmp.b	#$3c,d0
	bne	f3
	move.l	#nomf2,nom+2
	bra	bye1
f3	cmp.b	#$3d,d0
	bne	f4
	move.l	#nomf3,nom+2
	bra	bye1
f4	cmp.b	#$3e,d0
	bne	f5
	move.l	#nomf4,nom+2
	bra	bye1
f5	cmp.b	#$3f,d0
	bne	f6
	move.w	#0,big_buf
	move.l	#nomf5,nom+2
	bra	bye1
f6	cmp.b	#$40,d0
	bne	f7
	move.l	#nomf6,nom+2
	bra	bye1
f7	cmp.b	#$41,d0
	bne	loop
	move.l	#nomf7,nom+2

bye1	bsr	inter_off
	rts
	
set_scr	move	#$25,-(sp)
	trap	#14
	lea	2(sp),sp
	dc.w	$a00a
	bclr	#0,$484.w
	*move.b	#$12,$fffffc02.w
	movem.l	black,d0-d7
	movem.l	d0-d7,$ffff8240.w
	clr	-(sp)
	move.l	scr,-(sp)
	move.l	scr,-(sp)
	move	#$5,-(sp)
	trap	#14
	lea	$c(sp),sp
	lea	$60000,a0
	move.l	#$7f00,d0
eff_zob	clr.l	(a0)+
	dbf	d0,eff_zob
	lea	pic+34,a0
	move.l	scr,d0
	move.l	d0,a1
	adda.l	#160*29,a1
	eor.l	#$1d000,d0
	move.l	d0,a2
	adda.l	#160*29,a2
	move.l	#7999,d0
cop_im	move.l	(a0),(a1)+
	move.l	(a0)+,(a2)+
	dbf	d0,cop_im
	rts

new_vbl	clr	pt_line
nbr	move.l	#$598,d0
att1	dbf	d0,att1
	nop
	clr	$ffff820a.w
	moveq	#1,d0
att2	dbf	d0,att2
	move.b	#2,$ffff820a.w
	bsr	init_vbl
	bsr	deform
	bsr	scroll
	jsr	music+6
	bsr	vu_metre
	rte

init_vbl	addq.l	#1,pt_col
	cmp.l	#42,pt_col
	bne.s	col_cont
	clr.l	pt_col
col_cont	move.l	pt_col,d0
	mulu	#2,d0
	lea	buf_col,a0
	adda.l	d0,a0
	move.l	a0,set_log_pa+2
	move.l	#buf_vu,set_vu_pa+2
	move.l	#hbl1,$120.w
	movem.l	pal_logo,d0-d3
	movem.l	d0-d3,$ffff8240.w
	movem.l	d0-d3,$ffff8250.w
	eor.l	#$1d000,scr
	move.b	scr+1,$ffff8201.w
	move.b	scr+2,$ffff8203.w
	rts
	
hbl1	cmpi	#26,pt_line
	ble.s	set_log_pa
	move.l	pic+2,$ffff8240.w
	move.l	pic+6,$ffff8244.w
	move.l	pic+10,$ffff8248.w
	move.l	pic+14,$ffff824c.w
	move.l	pic+18,$ffff8250.w
	move.l	pic+22,$ffff8254.w
	move.l	pic+26,$ffff8258.w
	move.l	pic+30,$ffff825c.w
	addq	#1,pt_line
	move.l	#hbl2,$120.w
	rte
	
set_log_pa	move	buf_col,$ffff824e.w
	move	$ffff824e.w,$ffff825e.w
set_vu_pa	move	buf_vu,$ffff8250.w
	addq	#2,set_log_pa+4
	addq	#2,set_vu_pa+4
	addq	#1,pt_line
	rte
	
hbl2	cmpi	#198+29,pt_line
	bne	ret
	rept	118
	nop
	endr
	clr.b	$ffff820a.w
	rept	8
	nop
	endr
	move.b	#2,$ffff820a.w
	move.l	font+2,$ffff8240.w
	move.l	font+6,$ffff8244.w
	move.l	font+10,$ffff8248.w
	move.l	font+14,$ffff824c.w
	move.l	font+18,$ffff8250.w
	move.l	font+22,$ffff8254.w
	move.l	font+26,$ffff8258.w
	move.l	font+30,$ffff825c.w
ret	addq	#1,pt_line
	rte

deform	lea	table_sin,a3
	adda.l 	pt_sin,a3
	cmpi.b	#3,(a3)
	bne.s	sin_ct
	clr.l	pt_sin
	lea	table_sin,a3
sin_ct	lea	pos_def,a4
	move.l	#deb_def,d5
	move.l	scr,d2
	lea	adr_line,a2
	move.l	#24,d1
loop_def	clr.l	d0
	move.b	(a3),d0
	subq.b	#1,d0
	add.b	d0,(a4)
	cmp.b	#-1,(a4)
	bne.s	modu_1
	sub.l	#8,(a2)
	move.b	#7,(a4)
modu_1	cmp.b	#8,(a4)
	bne.s	modu_2
	add.l	#8,(a2)
	clr.b	(a4)
modu_2	move.b	(a4),d0
	mulu	#88,d0
	movea.l	d5,a0
	adda.l	d0,a0
	move.l	d2,a1
	adda.l	(a2),a1
	clr.l	-8(a1)
	clr	-4(a1)
	move.l	(a0),(a1)
	move	4(a0),4(a1)
	move.l	8(a0),8(a1)
	move	12(a0),12(a1)
	move.l	16(a0),16(a1)
	move	20(a0),20(a1)
	move.l	24(a0),24(a1)
	move	28(a0),28(a1)
	move.l	32(a0),32(a1)
	move	36(a0),36(a1)
	move.l	40(a0),40(a1)
	move	44(a0),44(a1)
	move.l	48(a0),48(a1)
	move	52(a0),52(a1)
	move.l	56(a0),56(a1)
	move	60(a0),60(a1)
	move.l	64(a0),64(a1)
	move	68(a0),68(a1)
	move.l	72(a0),72(a1)
	move	76(a0),76(a1)
	move.l	80(a0),80(a1)
	move	84(a0),84(a1)
	clr.l	88(a1)
	clr	92(a1)
	lea	1(a4),a4
	add.l	#88*8,d5
	lea	4(a2),a2
	lea	1(a3),a3
	add.l	#160,d2
	cmp.b	#3,(a3)
	bne.s	sin2_ct
	lea	table_sin,a3
sin2_ct	dbf	d1,loop_def
	add.l	#1,pt_sin
	rts
	
preca_def	lea	font+34+160*33*3+80,a0
	lea	deb_def,a1
	move.l	#24,d3
dec_log	movem.l	(a0),d4-d7/a3-a6
	movem.l	d4-d7/a3-a6,(a1)
	movem.l	32(a0),d4-d7/a3-a6
	movem.l	d4-d7/a3-a6,32(a1)
	movem.l	64(a0),d4-d7
	movem.l	d4-d7,64(a1)
	move.l	#6,d2
dec_li1	movem.l	(a1),d5-d7/a2-a6
	movem.l	d5-d7/a2-a6,88(a1)
	movem.l	32(a1),d5-d7/a2-a6
	movem.l	d5-d7/a2-a6,120(a1)
	movem.l	64(a1),d5-d7/a3-a5
	movem.l	d5-d7/a3-a5,152(a1)
	move.l	#1,d4
dec2	move.l	#3,d0
dec_pl	clr.l	d7
	roxr	d7
	move.l	#10,d1
dec_li2	roxr	88(a1)
	lea	8(a1),a1
	dbf	d1,dec_li2
	lea	-86(a1),a1
	dbf	d0,dec_pl
	lea	-8(a1),a1
	dbf	d4,dec2
	lea	88(a1),a1
	dbf	d2,dec_li1
	lea	88(a1),a1
	lea	160(a0),a0
	dbf	d3,dec_log
	rts
scroll	
pass_1	cmpi.b	#1,pt_pass
	bne.s	pass_2
	move.l	pos,a0
	move.l	scr,a2
	adda.l	#160*232,a2
	jsr	aff_1
	move.b	#2,pt_pass
	bra	pass_cont
pass_2	cmpi.b	#2,pt_pass
	bne.s	pass_3
	move.l	pos,a1
	lea	1(a1),a1
	lea	7(a1),a0
	move.l	scr,a2
	adda.l	#160*232,a2
	jsr	aff_2
	move.b	#3,pt_pass
	bra.s	pass_cont
pass_3	cmpi.b	#3,pt_pass
	bne.s	pass_4
	move.l	pos,a0
	lea	8(a0),a0
	move.l	scr,a2
	adda.l	#160*232,a2
	jsr	aff_1
	move.b	#4,pt_pass
	bra.s	pass_cont
pass_4	move.l	pos,a1
	lea	9(a1),a1
	jsr	test
	add.l	#1,pt_1
	move.l	a0,pos
	move.l	scr,a2
	adda.l	#160*232,a2
	jsr	aff_2
	move.b	#1,pt_pass
pass_cont	rts

test	lea	text1,a0
	adda.l	pt_1,a0
	clr.l	d0
	move.b	(a0),d0
	tst.b	d0
	bne.s	space
	clr.l	pt_1
	bra.s	test
space	cmpi.b	#$20,d0
	bne.s	excla
	lea	font+34+160*33*4+16*0,a0
	bra	sui
excla	cmpi.b	#$21,d0
	bne.s	inter
	lea	font+34+160*33*2+16*8,a0
	bra	sui
inter	cmpi.b	#$3f,d0
	bne.s	dx_pts
	lea	font+34+160*33*2+16*9,a0
	bra	sui
dx_pts	cmpi.b	#$3a,d0
	bne.s	virg
	lea	font+34+160*33*3+16*2,a0
	bra	sui
virg	cmpi.b	#$2c,d0
	bne.s	par_g
	lea	font+34+160*33*3+16*4,a0
	bra	sui
par_g	cmpi.b	#$28,d0
	bne.s	par_d
	lea	font+34+160*33*2+16*6,a0
	bra	sui
par_d	cmpi.b	#$29,d0
	bne.s	tiret
	lea	font+34+160*33*2+16*7,a0
	bra	sui
tiret	cmpi.b	#$2d,d0
	bne.s	pt
	lea	font+34+160*33*3+16*0,a0
	bra	sui
pt	cmpi.b	#$2e,d0
	bne.s	guill
	lea	font+34+160*33*3+16*1,a0
	bra	sui
guill	cmpi.b	#$27,d0
	bne.s	lettres_1
	lea	font+34+160*33*3+16*3,a0
	bra	sui
lettres_1	cmpi.b	#$41,d0
	blt.s	sui
	cmpi.b	#$4b,d0
	bge.s	lettres_2
	subi.b	#$41,d0
	mulu	#$10,d0
	lea	font+34+160*33*0,a0
	adda.l	d0,a0
	bra	sui
lettres_2	cmpi.b	#$55,d0
	bge.s	lettres_3
	subi.b	#$4b,d0
	mulu	#$10,d0
	lea	font+34+160*33*1,a0
	adda.l	d0,a0
	bra	sui
lettres_3	subi.b	#$55,d0
	mulu	#$10,d0
	lea	font+34+160*33*2,a0
	adda.l	d0,a0
	bra	sui
sui	rts

aff_1	move.l	#31,d0
cop_AFF_1	movem.l	8(a2),d1-d7/a3-a4
	movem.l	d1-d7/a3-a4,(a2)
	movem.l	44(a2),d1-d7/a3-a4
	movem.l	d1-d7/a3-a4,36(a2)
	movem.l	80(a2),d1-d7/a3-a4
	movem.l	d1-d7/a3-a4,72(a2)
	movem.l	116(a2),d1-d7/a3-a4
	movem.l	d1-d7/a3-a4,108(a2)
	move.l	152(a2),144(a2)
	move.l	156(a2),148(a2)
	move.l	(a0),152(a2)
	move.l	4(a0),156(a2)
	lea	160(a0),a0
	lea	160(a2),a2
	dbra	d0,cop_AFF_1
	rts

aff_2	move.l	#31,d0
cop_AFF_2	movem.l	8(a2),d1-d7/a3-a4
	movem.l	d1-d7/a3-a4,(a2)
	movem.l	44(a2),d1-d7/a3-a4
	movem.l	d1-d7/a3-a4,36(a2)
	movem.l	80(a2),d1-d7/a3-a4
	movem.l	d1-d7/a3-a4,72(a2)
	movem.l	116(a2),d1-d7/a3-a4
	movem.l	d1-d7/a3-a4,108(a2)
	move.l	152(a2),144(a2)
	move.l	156(a2),148(a2)
	move.b	(a1),152(a2)
	move.b	2(a1),154(a2)
	move.b	4(a1),156(a2)
	move.b	6(a1),158(a2)
	move.b	(a0),153(a2)
	move.b	2(a0),155(a2)
	move.b	4(a0),157(a2)
	move.b	6(a0),159(a2)
	lea	160(a0),a0
	lea	160(a1),a1
	lea	160(a2),a2
	dbra	d0,cop_AFF_2
	rts

vu_metre	clr.l	d0
	move.b	#8,$ffff8800.w
	move.b	$ffff8800.w,d0
	andi.b	#$f,d0
	cmp.b	#8,d0
	bge.s	v1
	moveq	#8,d0
v1	subq	#7,d0
	mulu	#3*160,d0
	move.l	scr,a0
	lea	326(a0),a0
	lea	$dc0(a0),a1
	sub.l	d0,a1
	bsr	aff_vu
	
	clr.l	d0
	move.b	#9,$ffff8800.w
	move.b	$ffff8800.w,d0
	andi.b	#$f,d0
	cmp.b	#8,d0
	bge.s	v2
	moveq	#8,d0
v2	subq	#7,d0
	mulu	#3*160,d0
	move.l	scr,a0
	lea	342(a0),a0
	lea	$dc0(a0),a1
	sub.l	d0,a1
	bsr	aff_vu
	
	clr.l	d0
	move.b	#10,$ffff8800.w
	move.b	$ffff8800.w,d0
	andi.b	#$f,d0
	cmp.b	#8,d0
	bge.s	v3
	moveq	#8,d0
v3	subq	#7,d0
	mulu	#3*160,d0
	move.l	scr,a0
	lea	358(a0),a0
	lea	$dc0(a0),a1
	sub.l	d0,a1
	bsr	aff_vu
	rts

aff_vu	moveq	#23,d0
zob2	cmpa.l	a1,a0
	bge.s	aff_li
	clr	(a0)
	clr	120(a0)
	bra.s	sui_vu
aff_li	move	#$ffff,(a0)
	move	#$ffff,120(a0)
sui_vu	lea	160(a0),a0
	dbra	d0,zob2
	rts

save_all	move	#$25,-(sp)
	trap	#14
	addq	#2,sp
	lea	big_buf,a1
	move.b	$ffff8260.w,1(a1)
	move.l	$44e.w,2(a1)
	movem.l	$ffff8240.w,d0-d7
	movem.l	d0-d7,6(a1)
	lea	$fffffa01.w,a0
	lea	38(a1),a1
	moveq	#$e,d0
cop_mfp	move.b	(a0)+,(a1)+
	lea	1(a0),a0
	dbf	d0,cop_mfp
	move.b	8(a0),(a1)+
	move.b	10(a0),(a1)+
	move.b	12(a0),(a1)+
	move.b	14(a0),(a1)+
	move.b	16(a0),(a1)+
	lea	$60.w,a0
	move.l	#$37,d0
cop_vecs	move.l	(a0)+,(a1)+
	dbf	d0,cop_vecs
       	rts

inter_on	move	sr,-(sp)
	move	#$2700,sr
	move	#$25,-(sp)
	trap	#14
	addq	#2,sp
	and.b	#$fe,$fffffa13.w
	and.b	#$fe,$fffffa0f.w
	and.b	#$fe,$fffffa0b.w
	and.b	#$fe,$fffffa07.w
	clr.b	$fffffa09.w
	move.b 	#$8,$fffffa1b.w
	move.b 	#1,$fffffa21.w
	move.l	#hbl1,$120.w
	move.l	#new_vbl,$70.w
	or.b	#1,$fffffa07.w
	or.b	#1,$fffffa13.w
	bclr	#5,$fffffa09.w
	bclr	#4,$fffffa09.w
	bclr	#3,$fffffa17.w
	move	#$25,-(sp)
	trap	#14
	addq	#2,sp
	move.w	(sp)+,sr
	rts

inter_off	move	sr,-(sp)
	move	#$2700,sr
	move	#$25,-(sp)
	trap	#14
	addq	#2,sp
	lea	big_buf+58,a0
	lea	$60.w,a1
	move.l	#$37,d0
set_vecs	move.l	(a0)+,(a1)+
	dbf	d0,set_vecs
	lea	big_buf+38,a0
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
	movem.l	big_buf+6,d0-d7
	movem.l	d0-d7,$ffff8240.w
	*move.b	#$8,$fffffc02.w
	move.b	#7,$484.w
	move	big_buf,-(sp)
	move.l	big_buf+2,-(sp)
	move.l	(sp),-(sp)
	move	#$5,-(sp)
	trap	#14
	lea	$c(sp),sp
	lea	$ffff8800,a0
	move.l	#$08080000,(a0)
	move.l	#$09090000,(a0)
	move.l	#$0a0a0000,(a0)
	dc.w	$a009
	move	#$25,-(sp)
	trap	#14
	addq	#2,sp
	move.w	(sp)+,sr
	rts

tst_fic	move	#2,-(sp)
nom 	pea	0
 	move	#$3d,-(sp)
 	trap	#1
 	lea	8(sp),sp
 	move.l	d0,d7
 	tst	d0
 	bmi	quit
 	rts
 	
run 	bsr	tst_fic
	lea	rel_8,a0
 	lea	rel_1,a1
cop4 	move.l	-(a0),-(a7)
 	cmpa.l	a0,a1
 	ble.s	cop4
 	jmp	(a7)
 	nop
 	nop
rel_1	lea	p_tbase,a5
	lea	-$1c(a5),a6
	move.l	a6,a0
	lea	rel_1(pc),a2
rel_2	clr.l	(a0)+
	cmpa.l	a0,a2
	bge.s	rel_2
	move.l	a6,-(sp)
 	pea	$ffffff
 	move	d7,-(sp)
 	move	#$3f,-(sp)
 	trap	#1
 	lea	12(sp),sp
 	move	d7,-(sp)
 	move	#$3e,-(sp)
 	trap	#1
 	lea	4(sp),sp
	cmpi.w	#$60fe,(a5)
	bne.s	rel_3
	move.w	4(a6),(a5)
	move.w	(a6),4(a6)
rel_3	tst	$1a(a6)
	bne.s	rel_4
	move.l	a5,a2
	adda.l	2(a6),a2
	adda.l	6(a6),a2
	adda.l	14(a6),a2
	clr.l	d1
	move.l	a5,d6
	move.l	(a2)+,d0
	beq.s	rel_4
rel_5	add.l	d6,0(a5,d0.l)
rel_6	move.b	(a2)+,d1
	beq.s	rel_4
	add.l	d1,d0
	cmp.b	#1,d1
	bne.s	rel_5
	addi.l	#$fd,d0
	bra.s	rel_6
rel_4	lea	-$100(a5),a0
	move.l	a5,d0
	move.l	2(a6),12(a0)
	add.l	12(a0),d0
	move.l	d0,16(a0)
	move.l	6(a6),20(a0)
	add.l	20(a0),d0
	move.l	d0,24(a0)
	move.l	10(a6),28(a0)
	lea	rel_7(pc),a0
	lea	8(a6),a1
	move.l	#4,d0
rel_9	move.l	(a0)+,(a1)+
	dbra	d0,rel_9	
	movem.l	save_reg(pc),d0-d7/a0-a7
	move.l	#p_tbase-$100,4(a7)
	lea	rel_1(pc),a0
	lea	-$50(a0),a0
	lea	rel_8(pc),a1
	jmp	p_tbase-20
rel_7	clr.l	(a0)+
	cmpa.l	a0,a1
	bge.s	rel_7
	move.l	#0,a0
	move.l	#0,a1
	nop
save_reg	ds.l	16
rel_8

black	dc.w	$000,$000,$000,$000,$000,$000,$000,$000
	dc.w	$000,$000,$000,$000,$000,$000,$000,$000
buf_col	rept	2
	dc.w	$700,$710,$720,$730,$740,$750,$760
	dc.w	$770,$670,$570,$470,$370,$270,$170
	dc.w	$070,$071,$072,$073,$074,$075,$076
	dc.w	$077,$067,$057,$047,$037,$027,$017
	dc.w	$007,$107,$207,$307,$407,$507,$607
	dc.w	$707,$706,$705,$704,$703,$702,$701
	endr
buf_vu	dc.w	$770,$670,$570,$470,$370,$270,$170,$070
	dc.w	$070,$071,$072,$073,$074,$075,$076,$077
	dc.w	$077,$177,$277,$377,$477,$577,$677,$777
adr_line	rept	25
	dc.l	160*1+40
	endr
scr	dc.l	$74000
table_sin	rept	36
	dc.b	1
	endr
	rept	4
	dc.b	2,2,2,2,2,1,2,1,2,1,2,1,1,1,1,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,1,1,1,1,2,1,2,1,2,1,2,2,2,2,2
	endr
	rept	2
	dc.b	2,2,2,2,1,2,1,2,1,1,1,1,0,1,0,1,0,0,0,0,0,0,0,0,1,0,1,0,1,1,1,1,2,1,2,1,2,2,2,2
	endr
	rept	4
	dc.b	2,2,2,1,2,1,1,1,0,1,0,0,0,0,0,0,1,0,1,1,1,2,1,2,2,2
	endr
	rept	8
	dc.b	2,2,1,1,1,0,0,0,0,1,1,1,2,2
	endr
	rept	24
	dc.b	2,1,1,0,0,1,1,2
	endr
	rept	24
	dc.b	1
	endr
	rept	30
	dc.b	0
	endr
	rept	24
	dc.b	1
	endr
	rept	2
	dc.b	2,2,2,2,1,2,1,2,1,1,1,1,0,1,0,1,0,0,0,0,0,0,0,0,1,0,1,0,1,1,1,1,2,1,2,1,2,2,2,2
	endr
	rept	24
	dc.b	1
	endr
	rept	60
	dc.b	2
	endr
	rept	24
	dc.b	1
	endr
	rept	2
	dc.b	2,2,2,2,1,2,1,2,1,1,1,1,0,1,0,1,0,0,0,0,0,0,0,0,1,0,1,0,1,1,1,1,2,1,2,1,2,2,2,2
	endr
	rept	24
	dc.b	1
	endr
	rept	30
	dc.b	0
	endr
	rept	24
	dc.b	1
	endr
	rept	50
	dc.b	0,2
	endr
	rept	28
	dc.b	0,1,2,1
	endr
	rept	8
	dc.b	2,2,1,1,1,0,0,0,0,1,1,1,2,2
	endr
	rept	4
	dc.b	2,2,2,1,2,1,1,1,0,1,0,0,0,0,0,0,1,0,1,1,1,2,1,2,2,2
	endr
	rept	2
	dc.b	2,2,2,2,1,2,1,2,1,1,1,1,0,1,0,1,0,0,0,0,0,0,0,0,1,0,1,0,1,1,1,1,2,1,2,1,2,2,2,2
	endr
	rept	4
	dc.b	2,2,2,2,2,1,2,1,2,1,2,1,1,1,1,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,1,1,1,1,2,1,2,1,2,1,2,2,2,2,2
	endr
	rept	24
	dc.b	1
	endr
	rept	12
	dc.b	2,1,2,0,2,1,2
	endr
	rept	24
	dc.b	1
	endr
	rept	24
	dc.b	0,1,0,2,0,1,0
	endr
	rept	24
	dc.b	1
	endr
	rept	12
	dc.b	2,1,2,0,2,1,2
	endr
	rept	24
	dc.b	1
	endr
	rept	10
	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,2,2,2,2,2,2,2,2,2
	endr
	dc.b	3
	even
pt_sin	dc.l	0
pal_logo	;dc.w	$000,$765,$210,$321,$432,$543,$654,$776
		dc.w	$000,$025,$035,$146,$256,$367,$567,$700
text1	DC.B	"  YEAH !!!    THE DRAGON AND MAC-DOS FROM FUZION PRESENT YOU THE SOUNDTRACK COMPIL, THIS"
	DC.B	" COMPIL FEATURES THE BEST SOUNDTRACKERS AVAILABLE FOR YOUR COLLECTION ! "
	DC.B	"          "
	DC.B	" THE CREDITS GO TO :   INTRO CODED BY ORION, GRAPHIX DESIGNED BY MAC-DOS, COMPIL DESIGNED BY THE DRAGON, MUSAX BY MAD MAX RIPPED FROM THE GAME 'PREHISTORIC TALE' ......     "
	DC.B	"  THE MEMBERS OF FUZION ARE AT NOW :  ORION, THE DRAGON, SQUAT, KASAR, SPEEDER, KELVIN, DOCNO, FULCRUM, MAC-DOS, PHIL GOOD ..... "
	DC.B	"    YOU CAN FIND SOME ROUTS AND DOCS IN THE FOLDERS ON THIS DISK FOR SEVERAL SOUNDTRACKERS ......   WE ALSO INCLUDED THE ROUTINE FOR ICE, JAM AND JEK PACKED MODULES, BUT IT'S "
	DC.B	"NOT COMPATIBLE WITH ALL THE SOUNDTRACKERS AND PLAYERS ......   JUST HAVE A LOOK AT THE DOCS ON THIS DISK ......    "
	DC.B	"  A BIG HELLO TO OUR RTEL SPREADERS :   DARDEVILS, MCP, INFIRMIER ......   "
	DC.B	" THE GREETINGS GO TO ( NO ORDER ! ) : THE REPLICANTS ( MAXI, NTM, ST-WAIKIKI, ILLEGAL ), MAD VISION ( THANX FOR THE ESION SOUNDTRACKER ! ), ST-CNX,"
 	DC.B	" OVR, AUTOMATION, EQUINOX, TCR ( STRANGER ), NEXT ( MIT, LAP ), BLUEMAX, CELTIK, MEDWAY BOYS,"
 	DC.B	" FOF, HMD, THE GUILD ( FM, FIREHAWKS, IMPACT ), BABAR, DNT CREW, MCS ( AXEL F. ), RIPPED OFF, TBC, VMAX, EMPIRE, TITANIUM, FASHION, ESC, FELESOFT, DAMS ( RANX, RDQ ), BBC"
	DC.B	", POMPEY PIRATES, SEWER SOFTWARE, TCB, TLB, THUNDERBIRDS .......      "
	DC.B	"   AND ALL WE HAVE FORGOTTEN ( SORRY !!! ) ............. "
	DC.B	"  IF YOU WANT TO CONTACT US, YOU CAN FIND A FILE ON THIS DISK WITH OUR ADRESS AND THE LIST OF OUR LAST COMPILS ......   " 
	DC.B	"      LET'S ZAP !!! .................                                                     "
	DC.B	0
pt_pass	dc.b	4
	even
pos	dc.l	font+34+160*33*4+16*0
	even
pt_1	ds.l	1
pt_col	ds.l	1	
pos_def	ds.b	25
	even
deb_def	ds.b	88*8*25
	even
pt_line	ds.w	1
	even
pile	ds.l	$80
	even
big_buf	ds.l	$50
	even
nom1	dc.b	"1",0
	even
nom2	dc.b	"2",0
	even
nom3	dc.b	"3",0
	even
nom4	dc.b	"4",0
	even
nom5	dc.b	"5",0
	even
nom6	dc.b	"6",0
	even
nom7	dc.b	"7",0
	even
nomf1	dc.b	"f1",0
	even
nomf2	dc.b	"f2",0
	even
nomf3	dc.b	"f3",0
	even
nomf4	dc.b	"f4",0
	even
nomf5	dc.b	"f5",0
	even
nomf6	dc.b	"f6",0
	even
nomf7	dc.b	"f7",0
	even

font	incbin	\orion.src\fuzion.cd\20_38\font2.pi1
	even
pic	incbin	\orion.src\fuzion.cd\20_38\cd20.pi1
	even
music	incbin	\orion.src\fuzion.cd\20_38\count5.bin
	end
