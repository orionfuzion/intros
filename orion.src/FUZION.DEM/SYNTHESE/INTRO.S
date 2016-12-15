	*************************************
	* Demo       Synthese Informatique  *
	* Coder      ORION from FUZION      *
	* Usage      Atari Store in Meaux   *
	* Date       Sept 1990              *
	*                                   *
	* Machine    Atari STE - 1MB RAM    *	
	* TOS        1.62                   *
	* Assembler  GenST v2.09            *
	* Emulator   Steem v3.2             *
	*                                   *
	* Contact    Orion.Fuzion@gmail.com *
	*************************************

	pea	rout
	move	#$26,-(sp)
	trap	#14
	lea	6(sp),sp
	pea	0
	trap	#1
		
rout	movem.l	$ffff8240.w,d0-d7
	movem.l	d0-d7,save_col
	move.l	$44e.w,save_ecr
	move.b	$ffff8260.w,save_rez+1
	dc.w	$a00a
	clr.b	$484.w
	move.b	#2,$ffff820a.w
	clr	-(sp)
	pea	$78000
	pea	$78000
	move	#5,-(sp)
	trap	#14
	lea	12(sp),sp
	lea	pic1+34,a0
	lea	$78000,a1
	move.l	#40*160-1,d0
cop0	move.l	(a0)+,(a1)+
	dbra	d0,cop0
	lea	union1,a0
	lea	$5F644,a1
	lea	end_1,a2
cop_3	move.l	(a0)+,(a1)+
	cmpa.l	a0,a2
	bge	cop_3
	jsr	$5f644
	lea	$fffffa00.w,a0
	lea	save_mfp,a1
	move.b	7(a0),(a1)+
	move.b	9(a0),(a1)+
	move.b	11(a0),(a1)+
	move.b	13(a0),(a1)+
	move.b	15(a0),(a1)+
	move.b	17(a0),(a1)+
	move.b	19(a0),(a1)+
	move.b	21(a0),(a1)+
	move.b	27(a0),(a1)+
	move.b	33(a0),(a1)+
	move.l	$70.w,save_vbl
       	move.l  	$120.w,save_hbl
       	move	#$25,-(sp)
	trap	#14
	lea	2(sp),sp
	move.w	sr,-(sp)
	move.w	#$2700,sr
	and.b	#$fe,$fffffa13.w
	and.b	#$fe,$fffffa0f.w
	and.b	#$fe,$fffffa0b.w
	and.b	#$fe,$fffffa07.w
	clr.b	$fffffa09.w
	move.b 	#8,$fffffa1b.w
	move.b 	#2,$fffffa21.w
	move.l	#newhbl,$120.w
	move.l	#newvbl,$70.w
	or.b	#$01,$fffffa07.w
	or.b	#$01,$fffffa13.w
	bclr	#5,$fffffa09.w
	bclr	#4,$fffffa09.w
	bclr	#3,$fffffa17.w
	move	(sp)+,sr

loop	cmp.b	#$39,$fffffc02.w
	bne	loop

	move	#$25,-(sp)
	trap	#14
	lea	2(sp),sp
	move.w	sr,-(sp)
	move.w	#$2700,sr
	move.l	save_hbl,$120.w
	move.l	save_vbl,$70.w
	lea	$ffff8800.w,a0
	move.l	#$08080000,(a0)
	move.l	#$09090000,(a0)
	move.l	#$0a0a0000,(a0)	
	lea	$fffffa00.w,a1
	lea	save_mfp,a0
	move.b	(a0)+,7(a1)
	move.b	(a0)+,9(a1)
	move.b	(a0)+,11(a1)
	move.b	(a0)+,13(a1)
	move.b	(a0)+,15(a1)
	move.b	(a0)+,17(a1)
	move.b	(a0)+,19(a1)
	move.b	(a0)+,21(a1)
	move.b	(a0)+,27(a1)
	move.b	(a0)+,33(a1)
	move	(sp)+,sr
	move	save_rez,-(sp)
	move.l	save_ecr,-(sp)
	move.l	save_ecr,-(sp)
	move	#$5,-(sp)
	trap	#14
	lea	12(sp),sp
	movem.l	save_col,d0-d7
	movem.l	d0-d7,$ffff8240.w
	move.b	#15,$484.w
	dc.w	$a009
	rts

vsync	move	#$25,-(sp)
	trap	#14
	lea	2(sp),sp
	rts

init_hbl	clr.b	pointeur
	move.l	#buffer2,newhbl+2
	move.l	#buffer_c,c2+2
	movem.l	pic1+2,d0-d7
	movem.l	d0-d7,$ffff8240.w
	rts
	
newvbl	jsr	init_hbl
	jsr	deform
	jsr	scroll
	jsr	$5f64A
	jsr	vu_metre
	rte
	
newhbl	move	buffer2,$ffff8246.w
c2	move	buffer_c,$ffff8258.w
	addq	#2,newhbl+4
	addq	#2,c2+4
	cmpi.b	#75,pointeur
	beq.s	pal3
	addq.b	#1,pointeur
	rte
pal3	movem.l	d0-d1,-(sp)
	move	#$437,$ffff8242.w
	move	#$435,$ffff8244.w
	addq.b	#1,pointeur
	movem.l	(sp)+,d0-d1
	rte

scroll	cmpi.l	#0,stop
	beq	scroll2	
	sub.l	#1,stop
	bra	suite2
scroll2	move.l	pt1,d0
	lea	text,a0
	adda.l	d0,a0
	moveq	#0,d0
	move.b	(a0),d0
	tst	d0
	bne	pause
	clr.l	pt1
	clr.l	pt2
	bra	scroll2
pause	cmpi.b	#$2a,d0
	bne	space
	move.l	#50,stop
	add.l	#1,pt1
	bra	suite2
space	cmpi.b	#$20,d0
	bne	excla
	lea	pic+34+160*32*4+16*9,a0
	bra	suite
excla	cmpi.b	#$21,d0
	bne	inter
	lea	pic+34+160*32*3+16*6,a0
	bra	suite
inter	cmpi.b	#$3f,d0
	bne	dx_pts
	lea	pic+34+160*32*4+16*4,a0
	bra	suite
dx_pts	cmpi.b	#$3a,d0
	bne	pt_virg
	lea	pic+34+160*32*4+16*1,a0
	bra	suite
pt_virg	cmpi.b	#$3b,d0
	bne	virg
	lea	pic+34+160*32*4+16*5,a0
	bra	suite
virg	cmpi.b	#$2c,d0
	bne	par_g
	lea	pic+34+160*32*4+16*3,a0
	bra	suite
par_g	cmpi.b	#$28,d0
	bne	par_d
	lea	pic+34+160*32*3+16*9,a0
	bra	suite
par_d	cmpi.b	#$29,d0
	bne	tiret
	lea	pic+34+160*32*4+16*0,a0
	bra	suite
tiret	cmpi.b	#$2d,d0
	bne	pt
	lea	pic+34+160*32*3+16*7,a0
	bra	suite
pt	cmpi.b	#$2e,d0
	bne	guill
	lea	pic+34+160*32*3+16*8,a0
	bra	suite
guill	cmpi.b	#$27,d0
	bne	lettres_1
	lea	pic+34+160*32*4+16*2,a0
	bra	suite
lettres_1	cmpi.b	#$41,d0
	blt	chiffres
	cmpi.b	#$4b,d0
	bge	lettres_2
	subi.b	#$41,d0
	mulu	#$10,d0
	lea	pic+34+160*32*1+16*0,a0
	adda.l	d0,a0
	bra	suite
lettres_2	cmpi.b	#$55,d0
	bge	lettres_3
	subi.b	#$4b,d0
	mulu	#$10,d0
	lea	pic+34+160*32*2+16*0,a0
	adda.l	d0,a0
	bra	suite
lettres_3	subi.b	#$55,d0
	mulu	#$10,d0
	lea	pic+34+160*32*3+16*0,a0
	adda.l	d0,a0
	bra	suite
chiffres	subi.b	#$30,d0
	mulu	#$10,d0
	lea	pic+34+160*31*0+16*0,a0
	adda.l	d0,a0
	bra	suite
suite	adda.l	pt2,a0
	lea	$78000+160*165,a1
	move.l	#31,d0
cop1	move.b	1(a1),(a1)
	move.b	8(a1),1(a1)
	move.b	9(a1),8(a1)
	move.b	16(a1),9(a1)
	move.b	17(a1),16(a1)
	move.b	24(a1),17(a1)
	move.b	25(a1),24(a1)
	move.b	32(a1),25(a1)
	move.b	33(a1),32(a1)
	move.b	40(a1),33(a1)
	move.b	41(a1),40(a1)
	move.b	48(a1),41(a1)
	move.b	49(a1),48(a1)
	move.b	56(a1),49(a1)
	move.b	57(a1),56(a1)
	move.b	64(a1),57(a1)
	move.b	65(a1),64(a1)
	move.b	72(a1),65(a1)
	move.b	73(a1),72(a1)
	move.b	80(a1),73(a1)
	move.b	81(a1),80(a1)
	move.b	88(a1),81(a1)
	move.b	89(a1),88(a1)
	move.b	96(a1),89(a1)
	move.b	97(a1),96(a1)
	move.b	104(a1),97(a1)
	move.b	105(a1),104(a1)
	move.b	112(a1),105(a1)
	move.b	113(a1),112(a1)
	move.b	120(a1),113(a1)
	move.b	121(a1),120(a1)
	move.b	128(a1),121(a1)
	move.b	129(a1),128(a1)
	move.b	136(a1),129(a1)
	move.b	137(a1),136(a1)
	move.b	144(a1),137(a1)
	move.b	145(a1),144(a1)
	move.b	152(a1),145(a1)
	move.b	153(a1),152(a1)
	move.b	(a0),153(a1)
	move.b	3(a1),2(a1)
	move.b	10(a1),3(a1)
	move.b	11(a1),10(a1)
	move.b	18(a1),11(a1)
	move.b	19(a1),18(a1)
	move.b	26(a1),19(a1)
	move.b	27(a1),26(a1)
	move.b	34(a1),27(a1)
	move.b	35(a1),34(a1)
	move.b	42(a1),35(a1)
	move.b	43(a1),42(a1)
	move.b	50(a1),43(a1)
	move.b	51(a1),50(a1)
	move.b	58(a1),51(a1)
	move.b	59(a1),58(a1)
	move.b	66(a1),59(a1)
	move.b	67(a1),66(a1)
	move.b	74(a1),67(a1)
	move.b	75(a1),74(a1)
	move.b	82(a1),75(a1)
	move.b	83(a1),82(a1)
	move.b	90(a1),83(a1)
	move.b	91(a1),90(a1)
	move.b	98(a1),91(a1)
	move.b	99(a1),98(a1)
	move.b	106(a1),99(a1)
	move.b	107(a1),106(a1)
	move.b	114(a1),107(a1)
	move.b	115(a1),114(a1)
	move.b	122(a1),115(a1)
	move.b	123(a1),122(a1)
	move.b	130(a1),123(a1)
	move.b	131(a1),130(a1)
	move.b	138(a1),131(a1)
	move.b	139(a1),138(a1)
	move.b	146(a1),139(a1)
	move.b	147(a1),146(a1)
	move.b	154(a1),147(a1)
	move.b	155(a1),154(a1)
	move.b	2(a0),155(a1)
	lea	160(a1),a1
	lea	160(a0),a0
	dbra	d0,cop1
	cmp.l	#9,pt2
	bne	pt2b
	clr.l	pt2
	add.l	#1,pt1
	bra	suite2
pt2b	cmp.l	#8,pt2
	bne	pt2c
	move.l	#9,pt2
	bra	suite2
pt2c	cmp.l	#1,pt2
	bne	pt2d
	move.l	#8,pt2
	bra	suite2
pt2d	move.l	#1,pt2
suite2	rts

deform	lea	table_sin,a0
	adda.l 	pt_sin,a0
	addq.l	#1,pt_sin
	cmpi.b	#3,(a0)
	bne	suite0
	clr.l	pt_sin
	lea	table_sin,a0
suite0	lea	$78000,a1
	move.l	#40,d0
loop1	moveq 	#3,d1	
loop2	tst.b 	(a0)
	bne 	suite1
	roxl.w 	152(a1)
	roxl.w 	144(a1)
	roxl.w 	136(a1)
	roxl.w 	128(a1)
	roxl.w 	120(a1)
	roxl.w 	112(a1)
	roxl.w 	104(a1)
	roxl.w 	96(a1)
	roxl.w 	88(a1)
	roxl.w 	80(a1)
	roxl.w 	72(a1)
	roxl.w 	64(a1)
	roxl.w 	56(a1)
	roxl.w 	48(a1)
	roxl.w 	40(a1)
	roxl.w 	32(a1)
	roxl.w 	24(a1)
	roxl.w 	16(a1)
	roxl.w 	8(a1)
	roxl.w 	(a1)
	bra 	suite4
suite1	cmpi.b 	#2,(a0)
	bne 	suite4
	roxr.w 	(a1)
	roxr.w 	8(a1)
	roxr.w 	16(a1)
	roxr.w 	24(a1)
	roxr.w 	32(a1)
	roxr.w 	40(a1)
	roxr.w	48(a1)
	roxr.w 	56(a1)
	roxr.w 	64(a1)
	roxr.w 	72(a1)
	roxr.w 	80(a1)
	roxr.w 	88(a1)
	roxr.w 	96(a1)
	roxr.w 	104(a1)
	roxr.w 	112(a1)
	roxr.w 	120(a1)
	roxr.w 	128(a1)
	roxr.w 	136(a1)
	roxr.w 	144(a1)
	roxr.w 	152(a1)
suite4	lea	2(a1),a1
	dbra 	d1,loop2
	lea	152(a1),a1
	lea	1(a0),a0
	cmpi.b 	#3,(a0)
	bne 	suite3
	lea	table_sin,a0
suite3	dbra 	d0,loop1
	rts
	
vu_metre	moveq	#0,d0
	move.b	#8,$ffff8800.w
	move.b	$ffff8800.w,d0
	andi.b	#$f,d0
	cmp.b	#10,d0
	bge	v1
	move.l	#10,d0
v1	sub	#9,d0
	mulu	#8*160,d0
	lea	$78000+160*80,a0
	lea	$78000+160*128,a1
	sub.l	d0,a1
	jsr	aff_vu
	moveq	#0,d0
	move.b	#9,$ffff8800.w
	move.b	$ffff8800.w,d0
	andi.b	#$f,d0
	cmp.b	#10,d0
	bge	v2
	move.l	#10,d0
v2	sub	#9,d0
	mulu	#8*160,d0
	lea	$78000+160*80+8*2,a0
	lea	$78000+160*128+8*2,a1
	sub.l	d0,a1
	jsr	aff_vu	
	moveq	#0,d0
	move.b	#10,$ffff8800.w
	move.b	$ffff8800.w,d0
	andi.b	#$f,d0
	cmp.b	#10,d0
	bge	v3
	move.l	#10,d0
v3	sub	#9,d0
	mulu	#8*160,d0
	lea	$78000+160*80+8*4,a0
	lea	$78000+160*128+8*4,a1
	sub.l	d0,a1
	jsr	aff_vu
	rts

aff_vu	move.l	#23,d0
black	cmp.l	a0,a1
	ble	red
	clr.l	(a0)
	clr.l	4(a0)
	clr.l	120(a0)
	clr.l	124(a0)
	bra	suite_vu
red	move.l	#$00000000,(a0)
	move.l	#$ffffffff,4(a0)
	move.l	#$00000000,120(a0)
	move.l	#$ffffffff,124(a0)
suite_vu	lea	320(a0),a0
	dbra	d0,black
	rts

table_sin	rept	48
	dc.b	1
	endr
	rept	2
	dc.b	2,2,2,2,2,1,2,1,2,1,2,1,1,1,1,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,1,1,1,1,2,1,2,1,2,1,2,2,2,2,2
	endr
	rept	3
	dc.b	2,2,2,2,1,2,1,2,1,1,1,1,0,1,0,1,0,0,0,0,0,0,0,0,1,0,1,0,1,1,1,1,2,1,2,1,2,2,2,2
	endr
	rept	4
	dc.b	2,2,2,1,2,1,1,1,0,1,0,0,0,0,0,0,1,0,1,1,1,2,1,2,2,2
	endr
	rept	8
	dc.b	2,2,1,1,1,0,0,0,0,1,1,1,2,2
	endr
	rept	32
	dc.b	2,1,1,0,0,1,1,2
	endr
	rept	8
	dc.b	2,2,1,1,1,0,0,0,0,1,1,1,2,2
	endr
	rept	4
	dc.b	2,2,2,1,2,1,1,1,0,1,0,0,0,0,0,0,1,0,1,1,1,2,1,2,2,2
	endr
	rept	3
	dc.b	2,2,2,2,1,2,1,2,1,1,1,1,0,1,0,1,0,0,0,0,0,0,0,0,1,0,1,0,1,1,1,1,2,1,2,1,2,2,2,2
	endr
	rept	2
	dc.b	2,2,2,2,2,1,2,1,2,1,2,1,1,1,1,1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1,1,1,1,1,2,1,2,1,2,1,2,2,2,2,2
	endr
	dc.b	3
pt_sin	dc.l	0
text	DC.B	"HI GUYS !!! ORION FROM FUZION PROUDLY PRESENTS THIS LITTLE SCREEN "
	DC.B	"CODED ESPECIALLY FOR SYNTHESE INFORMATIQUE..... BYE....           ",0
buffer_c	rept	40
	dc.w	$000
	endr
	dc.w	$007,$117,$227,$337,$447,$557,$667,$777
	dc.w	$777,$766,$755,$744,$733,$722,$711,$700
	dc.w	$700,$600,$500,$400,$300,$200,$100,$000
buffer2	rept	76
	dc.w	$333
	endr
	dc.w	$007,$107,$207,$307,$407,$507,$607,$707
	dc.w	$707,$717,$727,$737,$747,$757,$767,$777
	dc.w	$777,$676,$575,$474,$373,$272,$171,$070
	
save_col	ds.l	8
save_ecr	ds.l	1
save_rez	ds.w	1
save_mfp	ds.b	10
save_hbl	ds.l	1
save_vbl	ds.l	1
save_sr	ds.w	1
pointeur	ds.b	1
stop	ds.l	1
pt1	ds.l	1
pt2	ds.l 	1
	even
pic	incbin	\orion.src\fuzion.dem\synthese\font2.pi1
	even
pic1	incbin	\orion.src\fuzion.dem\synthese\synthese.pi1
	even
union1	incbin	\orion.src\fuzion.dem\synthese\union9.mus
end_1
	end