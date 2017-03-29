	*************************************
	* Intro      Multi-Dir Scroll       *
	* Coder      ORION from FUZION      *
	* Purpose    FUZION Compact Disks   *
	* Date       March 1991 - CD#39     *
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
	pea	intro(pc)
	move	#$26,-(sp)
	trap	#14
	addq.l	#6,sp
	move.l	save_reg+$3c,sp
char	bra	run
quit	clr.w	-(sp)
	trap	#1
		
intro	bsr	save_all
	bsr	col_off
	bsr	set_scr
	bsr	prec_mot
	bsr	set_mus
	bsr	inter_on
loop	tst.w	tche
	beq.s	loop
	bsr	inter_off
	bsr	col_on
	rts
	
att_tche	move.b	$fffffc02.w,d0
f1	cmpi.b	#$3b,d0
	bne.s	f2
	move.l	#nom1,nom+2
	bra	tche_ok
f2	cmpi.b	#$3c,d0
	bne.s	f3
	move.l	#nom2,nom+2
	bra	tche_ok
f3	cmpi.b	#$3d,d0
	bne.s	esc
	move.l	#nom3,nom+2
	bra	tche_ok
esc	cmpi.b	#1,d0
	beq.s	tche_ok
	rts
	
tche_ok	move.w	#$ffff,tche
	rts

col_off	move.l	#$777,d5
	moveq	#7,d7
col0	lea	$ffff8240.w,a5
	moveq	#15,d6
	move	#$25,-(sp)
	trap	#14
	addq	#2,sp
subcol	move.w	d5,(a5)+
	dbf	d6,subcol
	sub.w	#$111,d5
	dbf	d7,col0
	rts
	
col_on	clr.l	d5
	moveq	#7,d7
col777	lea	$ffff8240.w,a5
	moveq	#15,d6
	move	#$25,-(sp)
	trap	#14
	addq	#2,sp
addcol	move.w	d5,(a5)+
	dbf	d6,addcol
	add.w	#$111,d5
	dbf	d7,col777
	movem.l	pal,d0-d7
	movem.l	d0-d7,$ffff8240.w
	rts

set_scr	dc.w	$a00a
	move.b	#6,$484.w
	move.b	#$12,$fffffc02.w
	clr	-(sp)
	pea	$55000
	move.l	(sp),-(sp)
	move	#5,-(sp)
	trap	#14
	lea	12(sp),sp
	move.b	#2,$ffff820a.w
	lea	$55000,a0
	move.l	#$ac00-1,d0
eff_zob	clr.l	(a0)+
	dbf	d0,eff_zob
	lea	textpic+34,a0
	lea	$68000+160*4,a1
	lea	$74000+160*4,a2
	move.l	#4000-1,d0
cop_txt	move.w	(a0),4(a1)
	move.w	(a0),4(a2)
	lea	8(a0),a0
	lea	8(a1),a1
	lea	8(a2),a2
	dbf	d0,cop_txt
	lea	font+34+160*141,a0
	lea	$68000+160*209,a1
	lea	$74000+160*209,a2
	move.l	#40*8-1,d0
cop_bar	move.l	160*8(a0),160*43(a1)
	move.l	160*8(a0),160*43(a2)
	move.l	(a0),(a1)+
	move.l	(a0)+,(a2)+
	dbf	d0,cop_bar
	rts

new_vbl	tst.w	tche	
	bne.s	ret_vbl
	bsr	init_vbl
	bsr	over_high
	bsr	init_col
	bsr	att_tche
	bsr	multi
	bsr	scroll
	bsr	set_scre
	move.w	#700,d0
over_blk	dbf	d0,over_blk
	jsr	music+$e
ret_vbl	rte

init_vbl	clr.w	pt_line
	move.b 	#$8,$fffffa1b.w
	move.l	#hbl1,$120.w
	move.b 	#4,$fffffa21.w
	movem.l	pal_mot,d0-d3
	movem.l	d0-d3,$ffff8240.w
	move.b	scr+1,$ffff8201.w
	move.b	scr+2,$ffff8203.w
	rts

over_high	move.l	#$580,d0
att1	dbf	d0,att1
	clr	$ffff820a.w
	moveq	#1,d0
att2	dbf	d0,att2
	move.b	#2,$ffff820a.w
	rts

init_col	addq.l	#2,pt_col
	cmp.l	#84,pt_col
	bne.s	col_cont
	clr.l	pt_col
col_cont	move.l	pt_col,d0
	mulu	#2,d0
	lea	buf_col,a0
	adda.l	d0,a0
	move.l	a0,hbl1+2
	rts
	
set_scre	cmp.l	#$74000,scr
	bne.s	set_scr2
	move.l	#$68000,scr
	bra	ret_scr
set_scr2	move.l	#$74000,scr
ret_scr	rts
	
hbl1	move.l	buf_col,$ffff8248.w
	move.l	$ffff8248.w,$ffff824c.w
	cmpi.w	#51,pt_line
	ble.s	ret1
	move.w	font+4,$ffff8242.w
	move.l	font+6,$ffff8244.w
	move.l	font+10,$ffff8248.w
	move.l	font+14,$ffff824c.w
	move.l	font+18,$ffff8250.w
	move.l	font+22,$ffff8254.w
	move.l	font+26,$ffff8258.w
	move.l	font+30,$ffff825c.w
	move.b 	#$8,$fffffa1b.w
	move.l	#hbl2,$120.w
	move.b 	#1,$fffffa21.w
ret1	addq.w	#1,pt_line
	addq.l	#4,hbl1+2
	rte
	
hbl2	cmpi.w	#68,pt_line
	bne.s	ret2
	move.l	d7,save_d7+2
nbr	moveq	#37,d7
att4	dbf	d7,att4
	clr.b	$ffff820a.w
	moveq	#1,d7
att5	dbf	d7,att5
	move.b	#2,$ffff820a.w
save_d7	move.l	#0,d7
	move.b 	#$8,$fffffa1b.w
	move.l	#hbl3,$120.w
	move.b 	#1,$fffffa21.w
ret2	addq.w	#1,pt_line
	rte

hbl3	rte

set_mus	moveq	#0,d0
	jsr	music
	rts

prec_mot	lea	motif,a0
	lea	adr_pre,a1
	move.l	#63,d1
loop_all	moveq	#39,d0
loop_ver	move.l	(a0),(a1)
	move.l	8(a0),8(a1)
	move.l	16(a0),16(a1)
	move.l	24(a0),d6
	move.l	d6,24(a1)
	swap.w	d6
	roxr.w	d6
	roxr.w	(a1)
	roxr.w	8(a1)
	roxr.w	16(a1)
	roxr.w	24(a1)
	swap.w	d6
	roxr.w	d6
	roxr.w	2(a1)
	roxr.w	10(a1)
	roxr.w	18(a1)
	roxr.w	26(a1)
	lea	32(a0),a0
	lea	32(a1),a1
	dbf	d0,loop_ver
	dbf	d1,loop_all
	rts
	
multi	lea	sin_h,a0
	adda.l	pt_sin_h,a0
	cmpi.b	#$7f,(a0)
	bne.s	ct_sin_h
	clr.l	pt_sin_h
	lea	sin_h,a0
ct_sin_h	add.l	#1,pt_sin_h
	lea	pos_h,a1
	move.b	(a0),d0
	add.b	d0,(a1)
	tst.b	(a1)
	bge.s	plus_h
	add.b	#64,(a1)
	bra.s	moins_h
plus_h	cmp.b	#63,(a1)
	ble.s	moins_h
	sub.b	#64,(a1)
moins_h	clr.l	d0
	move.b	(a1),d0
	mulu	#32*40,d0
	lea	motif,a0
	adda.l	d0,a0
	
	lea	sin_v,a1
	adda.l	pt_sin_v,a1
	cmpi.b	#$7f,(a1)
	bne.s	ct_sin_v
	clr.l	pt_sin_v
	lea	sin_v,a1
ct_sin_v	add.l	#1,pt_sin_v
	lea	pos_v,a2
	move.b	(a1),d1
	add.b	d1,(a2)
	tst.b	(a2)
	bge.s	plus_v
	add.b	#40,(a2)
	bra.s	moins_v
plus_v	cmp.b	#39,(a2)
	ble.s	moins_v
	sub.b	#40,(a2)
moins_v	move.l	a0,a1
	clr.l	d0
	move.b	(a2),d0
	move.l	d0,d1
	mulu	#32,d0
	adda.l	d0,a0
	move.l	d1,d0
	neg.b	d0
	add.b	#39,d0
	
	move.l	scr,a2
	adda.l	#160*4,a2
cop_mot1	move.l	(a0),(a2)
	move.l	8(a0),8(a2)
	move.l	16(a0),16(a2)
	move.l	24(a0),24(a2)
	lea	32(a0),a0
	lea	160(a2),a2
	dbf	d0,cop_mot1
	
cop_mot2	move.l	(a1),(a2)
	move.l	8(a1),8(a2)
	move.l	16(a1),16(a2)
	move.l	24(a1),24(a2)
	lea	32(a1),a1
	lea	160(a2),a2
	dbf	d1,cop_mot2
	
	move.l	scr,a0
	adda.l	#160*4,a0
	move.l	#39,d7
	
all_mo2	move.l	(a0),d1
	move.l	8(a0),d2
	move.l	16(a0),d3
	move.l	24(a0),d4

	move.l	d1,32(a0)
	move.l	d2,40(a0)
	move.l	d3,48(a0)
	move.l	d4,56(a0)
	
	move.l	d1,64(a0)
	move.l	d2,72(a0)
	move.l	d3,80(a0)
	move.l	d4,88(a0)
	
	move.l	d1,96(a0)
	move.l	d2,104(a0)
	move.l	d3,112(a0)
	move.l	d4,120(a0)
	
	move.l	d1,128(a0)
	move.l	d2,136(a0)
	move.l	d3,144(a0)
	move.l	d4,152(a0)
	
	move.l	d1,160*40(a0)
	move.l	d2,160*40+8(a0)
	move.l	d3,160*40+16(a0)
	move.l	d4,160*40+24(a0)
	
	move.l	d1,160*40+32(a0)
	move.l	d2,160*40+40(a0)
	move.l	d3,160*40+48(a0)
	move.l	d4,160*40+56(a0)
	
	move.l	d1,160*40+64(a0)
	move.l	d2,160*40+72(a0)
	move.l	d3,160*40+80(a0)
	move.l	d4,160*40+88(a0)
	
	move.l	d1,160*40+96(a0)
	move.l	d2,160*40+104(a0)
	move.l	d3,160*40+112(a0)
	move.l	d4,160*40+120(a0)
	
	move.l	d1,160*40+128(a0)
	move.l	d2,160*40+136(a0)
	move.l	d3,160*40+144(a0)
	move.l	d4,160*40+152(a0)
	
	move.l	d1,160*40*2(a0)
	move.l	d2,160*40*2+8(a0)
	move.l	d3,160*40*2+16(a0)
	move.l	d4,160*40*2+24(a0)
	
	move.l	d1,160*40*2+32(a0)
	move.l	d2,160*40*2+40(a0)
	move.l	d3,160*40*2+48(a0)
	move.l	d4,160*40*2+56(a0)
	
	move.l	d1,160*40*2+64(a0)
	move.l	d2,160*40*2+72(a0)
	move.l	d3,160*40*2+80(a0)
	move.l	d4,160*40*2+88(a0)
	
	move.l	d1,160*40*2+96(a0)
	move.l	d2,160*40*2+104(a0)
	move.l	d3,160*40*2+112(a0)
	move.l	d4,160*40*2+120(a0)
	
	move.l	d1,160*40*2+128(a0)
	move.l	d2,160*40*2+136(a0)
	move.l	d3,160*40*2+144(a0)
	move.l	d4,160*40*2+152(a0)
	
	move.l	d1,160*40*3(a0)
	move.l	d2,160*40*3+8(a0)
	move.l	d3,160*40*3+16(a0)
	move.l	d4,160*40*3+24(a0)
	
	move.l	d1,160*40*3+32(a0)
	move.l	d2,160*40*3+40(a0)
	move.l	d3,160*40*3+48(a0)
	move.l	d4,160*40*3+56(a0)
	
	move.l	d1,160*40*3+64(a0)
	move.l	d2,160*40*3+72(a0)
	move.l	d3,160*40*3+80(a0)
	move.l	d4,160*40*3+88(a0)
	
	move.l	d1,160*40*3+96(a0)
	move.l	d2,160*40*3+104(a0)
	move.l	d3,160*40*3+112(a0)
	move.l	d4,160*40*3+120(a0)
	
	move.l	d1,160*40*3+128(a0)
	move.l	d2,160*40*3+136(a0)
	move.l	d3,160*40*3+144(a0)
	move.l	d4,160*40*3+152(a0)
	
	move.l	d1,160*40*4(a0)
	move.l	d2,160*40*4+8(a0)
	move.l	d3,160*40*4+16(a0)
	move.l	d4,160*40*4+24(a0)
	
	move.l	d1,160*40*4+32(a0)
	move.l	d2,160*40*4+40(a0)
	move.l	d3,160*40*4+48(a0)
	move.l	d4,160*40*4+56(a0)
	
	move.l	d1,160*40*4+64(a0)
	move.l	d2,160*40*4+72(a0)
	move.l	d3,160*40*4+80(a0)
	move.l	d4,160*40*4+88(a0)
	
	move.l	d1,160*40*4+96(a0)
	move.l	d2,160*40*4+104(a0)
	move.l	d3,160*40*4+112(a0)
	move.l	d4,160*40*4+120(a0)
	
	move.l	d1,160*40*4+128(a0)
	move.l	d2,160*40*4+136(a0)
	move.l	d3,160*40*4+144(a0)
	move.l	d4,160*40*4+152(a0)
	
	lea	160(a0),a0
	
	dbf	d7,all_mo2
	
	rts
	
scroll	
pass_1	cmpi.b	#1,pt_pass
	bne.s	pass_2
	move.l	pos,a0
	move.l	scr,a2
	adda.l	#160*221,a2
	jsr	aff_1
	move.b	#2,pt_pass
	bra	pass_cont
pass_2	cmpi.b	#2,pt_pass
	bne.s	pass_3
	move.l	pos,a1
	lea	1(a1),a1
	lea	7(a1),a0
	move.l	scr,a2
	adda.l	#160*221,a2
	jsr	aff_2
	move.b	#3,pt_pass
	bra.s	pass_cont
pass_3	cmpi.b	#3,pt_pass
	bne.s	pass_4
	move.l	pos,a0
	lea	8(a0),a0
	move.l	scr,a2
	adda.l	#160*221,a2
	jsr	aff_1
	move.b	#4,pt_pass
	bra.s	pass_cont
pass_4	move.l	pos,a1
	lea	9(a1),a1
	jsr	test
	add.l	#1,pt_1
	move.l	a0,pos
	move.l	scr,a2
	adda.l	#160*221,a2
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
	lea	font+34+160*28*4+16*6,a0
	bra	sui
excla	cmpi.b	#$21,d0
	bne.s	inter
	lea	font+34+160*28*3+16*6,a0
	bra	sui
inter	cmpi.b	#$3f,d0
	bne.s	dx_pts
	lea	font+34+160*28*4+16*4,a0
	bra	sui
dx_pts	cmpi.b	#$3a,d0
	bne.s	virg
	lea	font+34+160*28*4+16*1,a0
	bra	sui
virg	cmpi.b	#$2c,d0
	bne.s	pt_virg
	lea	font+34+160*28*4+16*3,a0
	bra	sui
pt_virg	cmpi.b	#$3b,d0
	bne.s	guil
	lea	font+34+160*28*4+16*5,a0
	bra	sui
guil	cmpi.b	#$27,d0
	bne.s	par_g
	lea	font+34+160*28*4+16*2,a0
	bra	sui
par_g	cmpi.b	#$28,d0
	bne.s	par_d
	lea	font+34+160*28*3+16*9,a0
	bra	sui
par_d	cmpi.b	#$29,d0
	bne.s	tiret
	lea	font+34+160*28*4+16*0,a0
	bra	sui
tiret	cmpi.b	#$2d,d0
	bne.s	pt
	lea	font+34+160*28*3+16*7,a0
	bra	sui
pt	cmpi.b	#$2e,d0
	bne.s	lettres_1
	lea	font+34+160*28*3+16*8,a0
	bra	sui
lettres_1	cmpi.b	#$41,d0
	blt.s	chiffres
	cmpi.b	#$4b,d0
	bge.s	lettres_2
	subi.b	#$41,d0
	mulu	#$10,d0
	lea	font+34+160*28*1,a0
	adda.l	d0,a0
	bra	sui
lettres_2	cmpi.b	#$55,d0
	bge.s	lettres_3
	subi.b	#$4b,d0
	mulu	#$10,d0
	lea	font+34+160*28*2,a0
	adda.l	d0,a0
	bra	sui
lettres_3	cmpi.b	#$5b,d0
	bge.s	inconu
	subi.b	#$55,d0
	mulu	#$10,d0
	lea	font+34+160*28*3,a0
	adda.l	d0,a0
	bra	sui
chiffres	cmpi.b	#$30,d0
	blt.s	inconu
	cmpi.b	#$39,d0
	bgt.s	inconu
	subi.b	#$30,d0
	mulu	#$10,d0
	lea	font+34+160*28*0,a0
	adda.l	d0,a0
	bra	sui
inconu	lea	font+34+160*28*4+16*6,a0
sui	rts

aff_1	move.l	#26,d0
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
	move.b	(a0),152(a2)
	move.b	1(a0),153(a2)
	move.b	2(a0),154(a2)
	move.b	3(a0),155(a2)
	move.b	4(a0),156(a2)
	move.b	5(a0),157(a2)
	move.b	6(a0),158(a2)
	move.b	7(a0),159(a2)
	lea	160(a0),a0
	lea	160(a2),a2
	dbra	d0,cop_AFF_1
	rts

aff_2	move.l	#26,d0
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

save_all	move.b	$ffff8260.w,rez+1
	move.b	$ffff820a.w,hz
	move.l	$44e.w,screen
	movem.l	$ffff8240.w,d0-d7
	movem.l	d0-d7,pal
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
	lea	$8.w,a0
	lea	vecs,a1
	move.l	#252,d0
cop_vecs	move.l	(a0)+,(a1)+
	dbf	d0,cop_vecs
       	rts

inter_on	move	#$2700,sr
	move	#$25,-(sp)
	trap	#14
	addq.l	#2,sp
	and.b	#$fe,$fffffa13.w
	and.b	#$fe,$fffffa0f.w
	and.b	#$fe,$fffffa0b.w
	and.b	#$fe,$fffffa07.w
	clr.b	$fffffa09.w
	move.b 	#$8,$fffffa1b.w
	move.b 	#4,$fffffa21.w
	move.l	#hbl1,$120.w
	move.l	#new_vbl,$70.w
	or.b	#1,$fffffa07.w
	or.b	#1,$fffffa13.w
	bclr	#5,$fffffa09.w
	bclr	#4,$fffffa09.w
	bclr	#3,$fffffa17.w
	move.w	#$2300,sr
	rts

inter_off	move	#$2700,sr
	move.b	#$5,$ffff8201.w
	move.b	#$50,$ffff8203.w
	lea	vecs,a0
	lea	$8.w,a1
	move.l	#252,d0
set_vecs	move.l	(a0)+,(a1)+
	dbf	d0,set_vecs
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
	lea	$ffff8800.w,a0
	move.l	#$08080000,(a0)
	move.l	#$09090000,(a0)
	move.l	#$0a0a0000,(a0)
	move.b	#$8,$fffffc02.w
	move.b	hz,$ffff820a.w
	move	rez,-(sp)
	move.l	screen,-(sp)
	move.l	(sp),-(sp)
	move	#$5,-(sp)
	trap	#14
	lea	$c(sp),sp
	move.b	#7,$484.w
	move.w	#$2300,sr
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
 	
run 	jsr	tst_fic
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

scr	dc.l	$74000
pt_col	ds.l	1
buf_col	rept	3
	dc.w	$700,$700,$710,$710,$720,$720,$730
	dc.w	$730,$740,$740,$750,$750,$760,$760
	dc.w	$770,$770,$670,$670,$570,$570,$470
	dc.w	$470,$370,$370,$270,$270,$170,$170
	dc.w	$070,$070,$071,$071,$072,$072,$073
	dc.w	$073,$074,$074,$075,$075,$076,$076
	dc.w	$077,$077,$067,$067,$057,$057,$047
	dc.w	$047,$037,$037,$027,$027,$017,$017
	dc.w	$007,$007,$107,$107,$207,$207,$307
	dc.w	$307,$407,$407,$507,$507,$607,$607
	dc.w	$707,$707,$706,$706,$705,$705,$704
	dc.w	$704,$703,$703,$702,$702,$701,$701
	endr
	even
text1	DC.B	" HI BOYS AND GIRLS ....      FUZION PRESENTS YOU A NEW CD WITH  GREAT COURTS 2, 9 LIVES AND MEGA RIPPER ....      GREAT COURTS 2 WAS CRACKED BY THE REPLICANTS AND PACKED BY ORION FROM FUZION, 9 LIVES WAS PACKED BY MAD VISION, "
	DC.B	"THE MEGA RIPPER WAS CODED BY KELVIN AND KASAR FROM FUZION .....        "
	DC.B	"  MEMBERS ARE :   THE DRAGON ( SWAPPER AND CD ), ORION ( CODER AND DEBUGER ), FULCRUM ( SWAPPER AND CD ), KASAR ( CODER ), KELVIN ( CRACKER AND CODER ), MACDOS ( GRAPHIST ), SQUAT ( GRAPHIST ), DOCNO ( SWAPPER ), COUGAR ( NEW "
	DC.B	"MUSICIAN :  LISTEN TO CD 47, 51, 53 AND 54 !! ) AND SPEEDER ( CODER ) ......       "
	DC.B	"  CREDITS GO TO :  INTRO CODED BY ORION, GRAFIX BY MACDOS, CD DESIGNED BY DRAGON, MUSAX BY DAVID WHITAKER FROM THE GAME DAN DARE 3 .....     "
	dc.B	"     HI TO ALL OUR FRIENDS IN FRANCE AND OVER EUROPE .....      "
	DC.B	"     SEE YOU SOON !!      EXAMS TIME ....   LET'S WRAP .........                                                                   "
	DC.B	0
	even
pt_pass	dc.b	4
	even
pos	dc.l	font+34+160*28*4+16*6
pt_1	ds.l	1
pt_line	ds.w	1
pal_mot	dc.w	$000,$213,$324,$435
sin_h	dc.b	1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4,5,5,5,5,5,6,6,6,6,6,7,7,7,7,7,8,8,8,8,8,9,9,9,9,9,10,10,10,10,10
	dc.b	10,10,10,10,10,9,9,9,9,9,8,8,8,8,8,7,7,7,7,7,6,6,6,6,6,5,5,5,5,5,4,4,4,4,4,3,3,3,3,3,2,2,2,2,2,1,1,1,1,1
	dc.b	0,0,0,0,0,0,0,0,0,0
	dc.b	-1,-1,-1,-1,-1,-2,-2,-2,-2,-2,-3,-3,-3,-3,-3,-4,-4,-4,-4,-4,-5,-5,-5,-5,-5,-6,-6,-6,-6,-6,-7,-7,-7,-7,-7,-8,-8,-8,-8,-8,-9,-9,-9,-9,-9,-10,-10,-10,-10,-10
	dc.b	-10,-10,-10,-10,-10,-9,-9,-9,-9,-9,-8,-8,-8,-8,-8,-7,-7,-7,-7,-7,-6,-6,-6,-6,-6,-5,-5,-5,-5,-5,-4,-4,-4,-4,-4,-3,-3,-3,-3,-3,-2,-2,-2,-2,-2,-1,-1,-1,-1,-1
	dc.b	0,0,0,0,0,0,0,0,0,0
	dc.b	$7f
	even
pt_sin_h	ds.l	1
pos_h	ds.b	1
	even
sin_v	dc.b	1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4,5,5,5,5,5,6,6,6,6,6,7,7,7,7,7,8,8,8,8,8
	dc.b	8,8,8,8,8,7,7,7,7,7,6,6,6,6,6,5,5,5,5,5,4,4,4,4,4,3,3,3,3,3,2,2,2,2,2,1,1,1,1,1
	dc.b	0,0,0,0,0,0,0,0,0,0,0
	dc.b	-1,-1,-1,-1,-1,-2,-2,-2,-2,-2,-3,-3,-3,-3,-3,-4,-4,-4,-4,-4,-5,-5,-5,-5,-5,-6,-6,-6,-6,-6,-7,-7,-7,-7,-7,-8,-8,-8,-8,-8
	dc.b	-8,-8,-8,-8,-8,-7,-7,-7,-7,-7,-6,-6,-6,-6,-6,-5,-5,-5,-5,-5,-4,-4,-4,-4,-4,-3,-3,-3,-3,-3,-2,-2,-2,-2,-2,-1,-1,-1,-1,-1
	dc.b	0,0,0,0,0,0,0,0,0,0,0
	dc.b	$7f
	even
pt_sin_v	ds.l	1
pos_v	ds.b	1
	even
tche	ds.w	1
	even
over_tst	ds.w	1
	even
pile	ds.l	$80
	even
pal	ds.l	8
vecs	ds.l	253
mfp	ds.b	20
	even
screen	ds.l	1
rez	ds.w	1
hz	ds.b	1
	even
nom1	dc.b	"1",0
	even
nom2	dc.b	"2",0
	even
nom3	dc.b	"3",0
	even
font	incbin	\orion.src\fuzion.cd\multi\ovr.pi1
	even
textpic	incbin	\orion.src\fuzion.cd\multi\cd57.pi1
	even
music	incbin	\orion.src\fuzion.cd\multi\dan.bin
end_mus
	even
motif	incbin	\orion.src\fuzion.cd\multi\motif.pic
adr_pre	ds.l	1
	end
