	*************************************
	* Intro      Vertical Scrolls       *
	* Coder      ORION from FUZION      *
	* Purpose    FUZION Compact Disks   *
	* Date       Sept 1990 - CD#13      *
	*                                   *
	* Machine    Atari STE - 1MB RAM    *	
	* TOS        1.62                   *
	* Assembler  GenST v2.09            *
	* Emulator   Steem v3.2             *
	*                                   *
	* Contact    Orion.Fuzion@gmail.com *
	*************************************

p_tbase	lea	-$100(sp),a0
	move.l	#128,d0
eff_pile	clr.l	(a0)+
	dbra	d0,eff_pile
	lea	p_tbase,a0
	lea	-$100(a0),a0
	move.l	a0,4(sp)
	move.l	sp,save_reg+$3c
	lea	-$100(sp),sp
	pea	intro
	move	#$26,-(sp)
	trap	#14
	lea	6(sp),sp
	bra	run

intro	bsr	save_all
	bsr	reset
	bsr	set_scr1
	bsr	set_music
	bsr	inter_on
f1	cmpi.b	#$3b,$fffffc02.w
	bne.s	f2
	move.l	#nom1,nom+2
	bra	fin
f2	cmpi.b	#$3c,$fffffc02.w
	bne.s	f3
	move.l	#nom2,nom+2
	bra	fin
f3	cmpi.b	#$3d,$fffffc02.w
	bne.s	f4
	move.l	#nom3,nom+2
	bra	fin
f4	cmpi.b	#$3e,$fffffc02.w
	bne.s	f1
	move.l	#nom4,nom+2
fin	bsr	inter_off
	bsr	set_scr2
	bsr	tst_fic
	rts
	
save_all	movem.l	$ffff8240.w,d0-d7
	movem.l	d0-d7,save_col
	move.l	$44e.w,save_ecr
	move.b	$ffff8260.w,save_rez+1
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
       	rts
       
reset	move.l	#$31415926,$426.w
	move.l	#$200,$42a.w
	lea	start_res(pc),a0
	lea	end_res(pc),a2
	move	#$200,a1
cop_res	move.l	(a0)+,(a1)+
	cmpa.l	a0,a2
	bge.s	cop_res
	rts
start_res	move	#$2700,sr
	move.l	$436.w,a0
	lea	-4(a0),sp
	clr.l	$426.w
	clr.l	$42a.w
	clr	-(sp)
	pea	$78000
	pea	$78000
	move	#$5,-(sp)
	trap	#14
	lea	$1c(sp),sp
	move.b	#$2,$ffff820a.w
	lea	$ffff8800.w,a0
	move.l	#$08080000,(a0)
	move.l	#$09090000,(a0)
	move.l	#$0a0a0000,(a0)
	pea	text_res(pc)
	move	#9,-(a7)
	trap	#1
	lea	6(sp),sp
	lea	$ffff8240.w,a0
	move	#$070,$1e(a0)
loop_res	move	#$001,(a0)
	move	#$002,(a0)
	move	#$003,(a0)
	move	#$004,(a0)
	move	#$005,(a0)
	move	#$006,(a0)
	move	#$007,(a0)
	move	#$505,(a0)
	rept	8
	nop
	endr
	jmp	loop_res(pc)
text_res	dc.b	27,"E",27,"Y",44,40,"FUZION IS GOOD FOR YOU !",0
end_res

set_scr1	dc.w	$a00a
	clr.b	$484.w
	clr	-(sp)
	pea	$78000
	pea	$78000
	move	#5,-(sp)
	trap	#14
	lea	12(sp),sp
	move	#$25,-(sp)
	trap	#14
	lea	2(sp),sp
	movem.l	pal1,d0-d7
	movem.l	d0-d7,$ffff8240.w
	move.b	#2,$ffff820a.w
	pea	text3
	move	#$9,-(sp)
	trap	#1
	lea	6(sp),sp
	move	#$777,$ffff825e.w
	move.l	#50,d5
att_deb	jsr	vsync
	subq.l	#1,d5
	tst	d5
	bne.s	att_deb
	move	#$777,d5
eff_col1	move	d5,$ffff825e.w
	subi	#$111,d5
	rept	5
	jsr	vsync
	endr
	tst	d5
	bne.s	eff_col1
	clr	$ffff825e.w
	lea	pic1+34,a0
	lea	$78000+160*1,a1
	move.l	#40*150-1,d0
cop_pic	move.l	(a0)+,(a1)+
	dbra	d0,cop_pic
	rts

set_music	moveq	#1,d0
	move.w	#$4e71,music+$90
	jsr	music
	move.l	#music+8,adr_mus+2
	rts
	
inter_on	move	#$25,-(sp)
	trap	#14
	lea	2(sp),sp
	move	sr,-(sp)
	move	#$2700,sr
	and.b	#$fe,$fffffa13.w
	and.b	#$fe,$fffffa0f.w
	and.b	#$fe,$fffffa0b.w
	and.b	#$fe,$fffffa07.w
	clr.b	$fffffa09.w
	move.b 	#$8,$fffffa1b.w
	move.b 	#$2,$fffffa21.w
	move.l	#newhbl,$120.w
	move.l	#newvbl,$70.w
	or.b	#1,$fffffa07.w
	or.b	#1,$fffffa13.w
	bclr	#5,$fffffa09.w
	bclr	#4,$fffffa09.w
	bclr	#3,$fffffa17.w
	move	#$25,-(sp)
	trap	#14
	lea	2(sp),sp
	move.w	(sp)+,sr
	movem.l	pal2,d0-d7
	movem.l	d0-d7,$ffff8240.w
	rts

inter_off	move	#$25,-(sp)
	trap	#14
	lea	2(sp),sp
	move	sr,-(sp)
	move	#$2700,sr
	move.l	save_hbl,$120.w
	move.l	save_vbl,$70.w
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
	move	#$25,-(sp)
	trap	#14
	lea	2(sp),sp
	move.w	(sp)+,sr
	lea	$ffff8800.w,a0
	move.l	#$08080000,(a0)
	move.l	#$09090000,(a0)
	move.l	#$0a0a0000,(a0)
	movem.l	pal1,d0-d7
	movem.l	d0-d7,$ffff8240.w
	rts

set_scr2	clr	-(sp)
	move.l	save_ecr,-(sp)
	move.l	save_ecr,-(sp)
	move	#$5,-(sp)
	trap	#14
	lea	12(sp),sp
	pea	text2
	move	#$9,-(sp)
	trap	#1
	lea	6(sp),sp
	move	#$777,$ffff825e.w
	move	#$777,d5
eff_col2	move	d5,$ffff8240.w
	subi	#$111,d5
	rept	5
	jsr	vsync
	endr
	tst	d5
	bne.s	eff_col2
	clr	$ffff8240.w
	rts
	
tst_fic	move	#2,-(sp)
nom 	pea	0
 	move	#$3d,-(sp)
 	trap	#1
 	lea	8(sp),sp
 	tst	d0
 	bmi.s	bye
 	rts
 	
bye	move	save_rez,-(sp)
	move.l	save_ecr,-(sp)
	move.l	save_ecr,-(sp)
	move	#$5,-(sp)
	trap	#14
	lea	12(sp),sp
	movem.l	save_col,d0-d7
	movem.l	d0-d7,$ffff8240.w
	move.b	#$f,$484.w
	dc.w	$a009
	pea	0
	trap	#1

vsync	move	#$25,-(sp)
	trap	#14
	lea	2(sp),sp
	rts

newvbl	*move	#$700,$ffff8240.w
	jsr	init_hbl
	jsr	scroll
	*move	#$770,$ffff8240.w
	jsr	deform
	*move	#$707,$ffff8240.w
adr_mus	jsr	$0
	*move	#$070,$ffff8240.w
	jsr	vu_metre
	*move	#$000,$ffff8240.w
	rte

init_hbl	move.l	#buffer,newhbl+2
	rts
	
newhbl	move	buffer,$ffff8252.w
	addq	#2,newhbl+4
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
pause	cmpi.b	#$23,d0
	bne	space
	move.l	#50,stop
	add.l	#1,pt1
	bra	suite2
space	cmpi.b	#$20,d0
	bne	excla
	lea	pic+34+160*35*4+16*6,a0
	bra	suite
excla	cmpi.b	#$21,d0
	bne	inter
	lea	pic+34+160*35*3+16*8,a0
	bra	suite
inter	cmpi.b	#$3f,d0
	bne	dx_pts
	lea	pic+34+160*35*4+16*4,a0
	bra	suite
dx_pts	cmpi.b	#$3a,d0
	bne	virg
	lea	pic+34+160*35*4+16*2,a0
	bra	suite
virg	cmpi.b	#$2c,d0
	bne	par_g
	lea	pic+34+160*35*4+16*3,a0
	bra	suite
par_g	cmpi.b	#$28,d0
	bne	par_d
	lea	pic+34+160*35*3+16*6,a0
	bra	suite
par_d	cmpi.b	#$29,d0
	bne	tiret
	lea	pic+34+160*35*3+16*7,a0
	bra	suite
tiret	cmpi.b	#$2d,d0
	bne	pt
	lea	pic+34+160*35*3+16*9,a0
	bra	suite
pt	cmpi.b	#$2e,d0
	bne	guill
	lea	pic+34+160*35*4+16*0,a0
	bra	suite
guill	cmpi.b	#$27,d0
	bne	lettres_1 	
	lea	pic+34+160*35*4+16*1,a0
	bra	suite
lettres_1	cmpi.b	#$41,d0
	blt	chiffres
	cmpi.b	#$4b,d0
	bge	lettres_2
	subi.b	#$41,d0
	mulu	#$10,d0
	lea	pic+34+160*35*1,a0
	adda.l	d0,a0
	bra	suite
lettres_2	cmpi.b	#$55,d0
	bge	lettres_3
	subi.b	#$4b,d0
	mulu	#$10,d0
	lea	pic+34+160*35*2,a0
	adda.l	d0,a0
	bra	suite
lettres_3	subi.b	#$55,d0
	mulu	#$10,d0
	lea	pic+34+160*35*3,a0
	adda.l	d0,a0
	bra	suite
chiffres	subi.b	#$30,d0
	mulu	#$10,d0
	lea	pic+34+160*35*0,a0
	adda.l	d0,a0
suite	adda.l	pt2,a0
cop1	lea	$78000,a4
	lea	$78000+160*2,a2
	move.l	#98,d0
cop2	movem.l	(a2),d1-d4
	movem.l	d1-d4,(a4)
	movem.l	d1-d4,144(a4)
	movem.l	160(a2),d1-d4
	movem.l	d1-d4,160(a4)
	movem.l	d1-d4,304(a4)
	lea	320(a4),a4
	lea	320(a2),a2
	dbra	d0,cop2
	movem.l	(a0),d1-d4
	movem.l	d1-d4,(a4)
	movem.l	d1-d4,144(a4)
	movem.l	160(a0),d1-d4
	movem.l	d1-d4,160(a4)
	movem.l	d1-d4,304(a4)
	add.l	#320,pt2
	cmp.l	#320*18,pt2
	bne	suite2
	clr.l	pt2
	addq.l	#1,pt1
suite2	rts
	
deform	lea	table_sin,a3
	adda.l 	pt_sin,a3
	addq.l	#1,pt_sin
	cmpi.b	#3,(a3)
	bne.s	suite0
	clr.l	pt_sin
	lea	table_sin,a3
suite0	lea	$78000+160*1,a1
	move.l	#30,d0
loop1	moveq 	#3,d1	
loop2	tst.b 	(a3)
	bne.s 	suite1
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
	bra.s 	suite4
suite1	cmpi.b 	#2,(a3)
	bne.s 	suite4
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
suite4	lea	2(a1),a1
	dbra 	d1,loop2
	lea	152(a1),a1
	lea	1(a3),a3
	cmpi.b 	#3,(a3)
	bne.s 	suite3
	lea	table_sin,a3
suite3	dbra	d0,loop1
	
vu_metre	moveq	#0,d0
	move.b	#8,$ffff8800.w
	move.b	$ffff8800.w,d0
	andi.b	#$f,d0
	cmp.b	#10,d0
	bge	v1
	move.l	#10,d0
v1	sub	#9,d0
	mulu	#8*160,d0
	lea	$78000+160*150+8*6,a0
	lea	$78000+160*198+8*6,a1
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
	lea	$78000+160*150+8*9,a0
	lea	$78000+160*198+8*9,a1
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
	lea	$78000+160*150+8*12,a0
	lea	$78000+160*198+8*12,a1
	sub.l	d0,a1
	jsr	aff_vu
	rts

aff_vu	move.l	#23,d0
black	cmp.l	a0,a1
	ble	red
	clr.l	(a0)
	clr.l	4(a0)
	clr.l	8(a0)
	clr.l	12(a0)
	bra	suite_vu
red	move.l	#$ffff0000,(a0)
	move.l	#$0000ffff,4(a0)
	move.l	#$ffff0000,8(a0)
	move.l	#$0000ffff,12(a0)
suite_vu	lea	320(a0),a0
	dbra	d0,black
	rts

run 	lea	rel_8,a0
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
 	move	d0,-(sp)
 	move	#$3f,-(sp)
 	trap	#1
 	lea	12(sp),sp
 	move	d7,-(sp)
 	move	#$3e,-(sp)
 	trap	#1
 	lea	4(sp),sp
	cmpi.b	#$60,(a6)
	beq.s	rel_3
	move.b	$20(a6),d0
	move.b	$23(a6),$20(a6)
	move.b	d0,$23(a6)
	move.b	$21(a6),d0
	move.b	$22(a6),$21(a6)
	move.b	d0,$22(a6)
rel_3	tst	$1a(a6)
	bne.s	rel_4
	move.l	a5,a2
	adda.l	2(a6),a2
	adda.l	6(a6),a2
	adda.l	14(a6),a2
	clr	d1
	move.l	a5,a0
	move.l	a0,d6
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
	lea	rel_1(pc),a0
	lea	-$40(a0),a0
	lea	rel_8(pc),a1
	lea	$40(a1),a1
	jmp	p_tbase-20
rel_7	clr.l	(a0)+
	cmpa.l	a0,a1
	bge.s	rel_7
	move.l	#0,a0
	move.l	#0,a1
	nop
save_reg	ds.l	16
rel_8

table_sin	rept	66
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
pal1	dc.w	$000,$000,$000,$000,$000,$000,$000,$000
	dc.w	$000,$000,$000,$000,$000,$000,$000,$000
pal2	dc.w	$000,$111,$222,$333,$444,$555,$666,$777
	dc.w	$007,$007,$000,$000,$000,$000,$000,$000
buffer	dc.w	$707,$717,$727,$737,$747,$757,$767,$777
	dc.w	$667,$557,$447,$337,$227,$117,$007
	rept	60
	dc.w	$000
	endr
	dc.w	$700,$700,$710,$720,$730,$730
	dc.w	$740,$750,$760,$760,$770,$770
	dc.w	$770,$670,$670,$570,$470,$370
	dc.w	$370,$270,$170,$170,$070,$070
	
text	dc.b	"HELLO FOLKS THIS IS ORION ON THE KEYBOARD AND HE SAYS   HAVE A NICE DAY   BYE  #        ",0
text3	dc.b	27,"E",27,"Y",44,41,"FUZION IS GOOD FOR YOU !",0
text2	dc.b	27,"E",27,"Y",44,47,"PLEASE WAIT",0
nom1	dc.b	"a:\game.*",0
nom2	dc.b	"a:\game.*",0
nom3	dc.b	"a:\game.*",0
nom4	dc.b	"a:\game.*",0
	
save_col	ds.l	8
save_ecr	ds.l	1
save_rez	ds.w	1
save_mfp	ds.b	10
save_vbl	ds.l	1
save_hbl	ds.l	1
no_rep	ds.b	1
stop	ds.l	1
pt1	ds.l	1
pt2	ds.l 	1
	even
music	incbin	\orion.src\fuzion.cd\scro_ver\madmax_6.mus
	even
pic	incbin	\orion.src\fuzion.cd\scro_ver\fonts.pi1
	even
pic1	incbin	\orion.src\fuzion.cd\scro_ver\logo.pi1
	even
	end