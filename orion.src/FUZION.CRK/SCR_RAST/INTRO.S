	**************************************
	* Intro      Vertical Rasters Scroll *
	* Coder      ORION from FUZION       *
	* Usage      Fuzion Cracks           *
	* Date       August 1990             *
	*                                    *
	* Machine    Atari STE - 1MB RAM     *	
	* TOS        1.62                    *
	* Assembler  GenST v2.09             *
	* Emulator   Steem v3.2              *
	*                                    *
	* Contact    Orion.Fuzion@gmail.com  *
	**************************************

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
loop	cmpi.b	#$39,$fffffc02.w
 	bne.s	loop
	bsr	inter_off
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
	pea 	$78000
	pea	$78000
	move	#5,-(sp)
	trap	#14	
	lea	$c(sp),sp
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
	lea	pic,a0
	lea	$78000+160*30,a1
	move.l	#40*140-1,d0
cop1	move.l	(a0)+,(a1)+
	dbra	d0,cop1
	rts
	
set_music	moveq 	#1,d0
	jsr	music
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
 	pea	nom
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

newvbl	jsr	inithbl
	jsr	scroll_2
	jsr	vu_metre
	jsr	orion
	jsr	fuzion
	jsr	scroll
	jsr	music+8
	rte
	
inithbl	move	#$21f9,c2
	move.l	#buffer,c2+2
	move.l	#buffer+4,c3+2
	move.l	#buffer+8,c4+2
	movem.l	pal2,d0-d7
	movem.l	d0-d7,$ffff8240.w
	rts
		
newhbl	
c2	move.l	buffer,$ffff8254.w
c3	move.l	buffer+4,$ffff8258.w
c4	move	buffer+8,$ffff825c.w
	addi.w	#10,c2+4
	addi.w	#10,c3+4
	addi.w	#10,c4+4
	cmpi.l	#buffer+10*82,c2+2
	bne.s	fin_hbl
	move	pal3,$ffff8242.w
	move	pal3+2,$ffff8244.w
	move	pal3+4,$ffff8246.w
	move	pal3+6,$ffff8248.w
	move	pal3+8,$ffff824a.w
	move	pal3+10,$ffff824c.w
	move	pal3+12,$ffff824e.w
	move	#$4e73,c2
fin_hbl	bclr	#0,$fffffa0f.w
	rte

fuzion	move.l	adr_logo,a0
	lea	table_line,a1
	adda.l	pt_line,a1
	cmpi.b	#3,(a1)
	bne.s	line1
	clr.l	pt_line
	lea	table_line,a1
line1	cmp.b	#2,(a1)
	bne.s	up
down	adda.l	#25*160,a0
	lea	160(a0),a1
	move.l	#25,d0
cop_down	movem.l	(a0),d1-d7/a3-a5
	movem.l	d1-d7/a3-a5,(a1)
	movem.l	40(a0),d1-d6
	movem.l	d1-d6,40(a1)
	lea	-160(a1),a1
	lea	-160(a0),a0
	dbra	d0,cop_down
	add.l	#160,adr_logo
	bra.s	suite5
up	tst.b	(a1)
	bne.s	suite5
	lea	-160(a0),a1
	move.l	#25,d0
cop_up	movem.l	(a0),d1-d7/a3-a5
	movem.l	d1-d7/a3-a5,(a1)
	movem.l	40(a0),d1-d6
	movem.l	d1-d6,40(a1)
	lea	160(a1),a1
	lea	160(a0),a0
	dbra	d0,cop_up
	sub.l	#160,adr_logo
suite5	addq.l	#1,pt_line
	lea	table_sin,a0
	adda.l 	pt_sin,a0
	addq.l	#1,pt_sin
	cmpi.b	#3,(a0)
	bne.s	suite0
	clr.l	pt_sin
	lea	table_sin,a0
suite0	move.l	adr_logo,a1
	move.l	#25,d0
loop1	move.l 	#3,d1	
loop2	tst.b 	(a0)
	bne.s 	suite12
	roxl.w 	56(a1)
	roxl.w 	48(a1)
	roxl.w 	40(a1)
	roxl.w 	32(a1)
	roxl.w 	24(a1)
	roxl.w 	16(a1)
	roxl.w 	8(a1)
	roxl.w 	(a1)
	bra.s 	suite22
suite12	cmpi.b 	#2,(a0)
	bne.s 	suite22
	roxr.w 	(a1)
	roxr.w 	8(a1)
	roxr.w 	16(a1)
	roxr.w 	24(a1)
	roxr.w 	32(a1)
	roxr.w 	40(a1)
	roxr.w	48(a1)
	roxr.w 	56(a1)
suite22	lea	2(a1),a1
	dbra 	d1,loop2
	lea	152(a1),a1
	lea	1(a0),a0
	cmpi.b 	#3,(a0)
	bne.s 	suite32
	lea	table_sin,a0
suite32	dbra 	d0,loop1
	rts

orion	lea	vu_pic+160*100+8*0,a0
	lea	orio,a2
	lea	orio_pt,a3
	moveq	#4,d1
set_car	move.l	(a2),a1
	jsr	aff_car
down1	cmp.b	#0,(a3)
	bne.s	up1
	add.l	#160,(a2)
	cmp.l	#$78000+160*100,(a2)
	blt.s	cont
	move.b	#1,(a3)
	bra.s	cont
up1	sub.l	#160,(a2)
	cmp.l	#$78000+160*60,(a2)
	bge.s	cont
	move.b	#0,(a3)	
cont	addq.l	#8,a0
	lea	4(a2),a2
	lea	1(a3),a3
	dbra	d1,set_car
	rts

aff_car	move.l	(a0),(a1)
	move.l	4(a0),4(a1)
	move.l	160(a0),160(a1)
	move.l	164(a0),164(a1)
	move.l	320(a0),320(a1)
	move.l	324(a0),324(a1)
	move.l	480(a0),480(a1)
	move.l	484(a0),484(a1)
	move.l	640(a0),640(a1)
	move.l	644(a0),644(a1)
	move.l	800(a0),800(a1)
	move.l	804(a0),804(a1)
	move.l	960(a0),960(a1)
	move.l	964(a0),964(a1)
	move.l	1120(a0),1120(a1)
	move.l	1124(a0),1124(a1)
	move.l	1280(a0),1280(a1)
	move.l	1284(a0),1284(a1)
	move.l	1440(a0),1440(a1)
	move.l	1444(a0),1444(a1)
	move.l	1600(a0),1600(a1)
	move.l	1604(a0),1604(a1)
	move.l	1760(a0),1760(a1)
	move.l	1764(a0),1764(a1)
	move.l	1920(a0),1920(a1)
	move.l	1924(a0),1924(a1)
	move.l	2080(a0),2080(a1)
	move.l	2084(a0),2084(a1)
	move.l	2240(a0),2240(a1)
	move.l	2244(a0),2244(a1)
	move.l	2400(a0),2400(a1)
	move.l	2404(a0),2404(a1)
	move.l	2560(a0),2560(a1)
	move.l	2564(a0),2564(a1)
	move.l	2720(a0),2720(a1)
	move.l	2724(a0),2724(a1)
	move.l	2880(a0),2880(a1)
	move.l	2884(a0),2884(a1)
	move.l	3040(a0),3040(a1)
	move.l	3044(a0),3044(a1)
	move.l	3200(a0),3200(a1)
	move.l	3204(a0),3204(a1)
	move.l	3360(a0),3360(a1)
	move.l	3364(a0),3364(a1)
	move.l	3520(a0),3520(a1)
	move.l	3524(a0),3524(a1)	
	move.l	3680(a0),3680(a1)
	move.l	3684(a0),3684(a1)
	move.l	3840(a0),3840(a1)
	move.l	3844(a0),3844(a1)
	move.l	4000(a0),4000(a1)
	move.l	4004(a0),4004(a1)
	rts
	
vu_metre	clr	d0
	move.b	#8,$ff8800
	move.b	$ff8800,d0
	lea	$78000+160*0+8*4,a1
va0	cmp.b	#10,d0
	bgt.s	va1
	lea	vu_pic,a0
	bra.s	suite1
va1	cmp.b	#11,d0
	bgt.s	va2
	lea	vu_pic+32,a0
	bra.s	suite1
va2	cmp.b	#12,d0
	bgt.s	va3
	lea	vu_pic+64,a0
	bra.s	suite1
va3	cmp.b	#13,d0
	bgt.s	va4
	lea	vu_pic+96,a0
	bra.s	suite1
va4	lea	vu_pic+128,a0
suite1	jsr	aff_vu
	clr	d0
	move.b	#9,$ff8800
	move.b	$ff8800,d0
	lea	$78000+160*0+8*8,a1
vb0	cmp.b	#10,d0
	bgt.s	vb1
	lea	vu_pic+160*32,a0
	bra.s	suite2
vb1	cmp.b	#11,d0
	bgt.s	vb2
	lea	vu_pic+32+160*32,a0
	bra.s	suite2
vb2	cmp.b	#12,d0
	bgt.s	vb3
	lea	vu_pic+64+160*32,a0
	bra.s	suite2
vb3	cmp.b	#13,d0
	bgt.s	vb4
	lea	vu_pic+96+160*32,a0
	bra.s	suite2
vb4	lea	vu_pic+128+160*32,a0
suite2	jsr	aff_vu
	clr	d0
	move.b	#$a,$ff8800
	move.b	$ff8800,d0
	lea	$78000+160*0+8*12,a1
vc0	cmp.b	#10,d0
	bgt.s	vc1
	lea	vu_pic+160*64,a0
	bra.s	suite3
vc1	cmp.b	#11,d0
	bgt.s	vc2
	lea	vu_pic+32+160*64,a0
	bra.s	suite3
vc2	cmp.b	#12,d0
	bgt.s	vc3
	lea	vu_pic+64+160*64,a0
	bra.s	suite3
vc3	cmp.b	#13,d0
	bgt.s	vc4
	lea	vu_pic+96+160*64,a0
	bra.s	suite3
vc4	lea	vu_pic+128+160*64,a0
suite3	jsr	aff_vu
	
aff_vu	movem.l	(a0),d0-d7
	movem.l	d0-d7,(a1)
	movem.l	160(a0),d0-d7
	movem.l	d0-d7,160(a1)
	movem.l	320(a0),d0-d7
	movem.l	d0-d7,320(a1)
	movem.l	480(a0),d0-d7
	movem.l	d0-d7,480(a1)
	movem.l	640(a0),d0-d7
	movem.l	d0-d7,640(a1)
	movem.l	800(a0),d0-d7
	movem.l	d0-d7,800(a1)
	movem.l	960(a0),d0-d7
	movem.l	d0-d7,960(a1)
	movem.l	1120(a0),d0-d7
	movem.l	d0-d7,1120(a1)
	movem.l	1280(a0),d0-d7
	movem.l	d0-d7,1280(a1)
	movem.l	1440(a0),d0-d7
	movem.l	d0-d7,1440(a1)
	movem.l	1600(a0),d0-d7
	movem.l	d0-d7,1600(a1)
	movem.l	1760(a0),d0-d7
	movem.l	d0-d7,1760(a1)
	movem.l	1920(a0),d0-d7
	movem.l	d0-d7,1920(a1)
	movem.l	2080(a0),d0-d7
	movem.l	d0-d7,2080(a1)
	movem.l	2240(a0),d0-d7
	movem.l	d0-d7,2240(a1)
	movem.l	2400(a0),d0-d7
	movem.l	d0-d7,2400(a1)
	movem.l	2560(a0),d0-d7
	movem.l	d0-d7,2560(a1)
	movem.l	2720(a0),d0-d7
	movem.l	d0-d7,2720(a1)
	movem.l	2880(a0),d0-d7
	movem.l	d0-d7,2880(a1)
	movem.l	3040(a0),d0-d7
	movem.l	d0-d7,3040(a1)
	movem.l	3200(a0),d0-d7
	movem.l	d0-d7,3200(a1)
	movem.l	3360(a0),d0-d7
	movem.l	d0-d7,3360(a1)
	movem.l	3520(a0),d0-d7
	movem.l	d0-d7,3520(a1)
	movem.l	3680(a0),d0-d7
	movem.l	d0-d7,3680(a1)
	movem.l	3840(a0),d0-d7
	movem.l	d0-d7,3840(a1)
	movem.l	4000(a0),d0-d7
	movem.l	d0-d7,4000(a1)
	movem.l	4160(a0),d0-d7
	movem.l	d0-d7,4160(a1)
	movem.l	4320(a0),d0-d7
	movem.l	d0-d7,4320(a1)
	movem.l	4480(a0),d0-d7
	movem.l	d0-d7,4480(a1)
	movem.l	4640(a0),d0-d7
	movem.l	d0-d7,4640(a1)
	movem.l	4800(a0),d0-d7
	movem.l	d0-d7,4800(a1)
	movem.l	4960(a0),d0-d7
	movem.l	d0-d7,4960(a1)
	rts
	
scroll	
pass_1	cmpi.b	#1,pt_pass
	bne.s	pass_2
	move.l	pos,a0
	lea	buff1+152,a1
	lea	$78000+160*167+152,a2
	jsr	aff_1
	move.b	#2,pt_pass
	bra	pass_cont
pass_2	cmpi.b	#2,pt_pass
	bne.s	pass_3
	move.l	pos,a1
	lea	1(a1),a1
	lea	7(a1),a0
	lea	buff2+152,a2
	lea	$78000+160*167+152,a3
	jsr	aff_2
	move.b	#3,pt_pass
	bra.s	pass_cont
pass_3	cmpi.b	#3,pt_pass
	bne.s	pass_4
	move.l	pos,a0
	lea	8(a0),a0
	lea	buff1+152,a1
	lea	$78000+160*167+152,a2
	jsr	aff_1
	move.b	#4,pt_pass
	bra.s	pass_cont
pass_4	move.l	pos,a1
	lea	9(a1),a1
	jsr	test
	add.l	#1,pt_1
	move.l	a0,pos
	lea	buff2+152,a2
	lea	$78000+160*167+152,a3
	jsr	aff_2
	move.b	#1,pt_pass
pass_cont	rts

test	lea	text1,a0
	adda.l	pt_1,a0
	clr.l	d0
	move.b	(a0),d0
	tst.b	d0
	bne.s	pause2
	clr.l	pt_1
	bra.s	test
pause2	cmpi.b	#$23,d0
	bne.s	plus2
	move.l	#50,stop
	add.l	#1,pt_1
	bra	sui
plus2	cmpi.b	#$2b,d0
	bne.s	egal2
	lea	FONT+34+160*32*4+16*3,a0
	bra	sui
egal2	cmpi.b	#$3d,d0
	bne.s	space2
	lea	FONT+34+160*32*3+16*8,a0
	bra	sui
space2	cmpi.b	#$20,d0
	bne.s	excla2
	lea	FONT+34+160*32*4+16*3,a0
	bra	sui
excla2	cmpi.b	#$21,d0
	bne.s	inter2
	lea	FONT+34+160*32*3+16*6,a0
	bra	sui
inter2	cmpi.b	#$3f,d0
	bne.s	dx_pts2
	lea	FONT+34+160*32*3+16*9,a0
	bra	sui
dx_pts2	cmpi.b	#$3a,d0
	bne.s	pt_virg2
	lea	FONT+34+160*32*3+16*7,a0
	bra	sui
pt_virg2	cmpi.b	#$3b,d0
	bne.s	virg2
	lea	FONT+34+160*32*4+16*8,a0
	bra	sui
virg2	cmpi.b	#$2c,d0
	bne.s	par_g2
	lea	FONT+34+160*32*4+16*5,a0
	bra	sui
par_g2	cmpi.b	#$28,d0
	bne.s	par_d2
	lea	FONT+34+160*32*4+16*1,a0
	bra	sui
par_d2	cmpi.b	#$29,d0
	bne.s	tiret2
	lea	FONT+34+160*32*4+16*2,a0
	bra	sui
tiret2	cmpi.b	#$2d,d0
	bne.s	pOt2
	lea	FONT+34+160*32*4+16*6,a0
	bra	sui
pOt2	cmpi.b	#$2e,d0
	bne.s	guill2
	lea	FONT+34+160*32*4+16*7,a0
	bra	sui
guill2	cmpi.b	#$27,d0
	bne.s	lettres_1
	lea	FONT+34+160*32*4+16*0,a0
	bra	sui
lettres_1	cmpi.b	#$41,d0
	blt.s	chiffres2
	cmpi.b	#$4b,d0
	bge.s	lettres_2
	subi.b	#$41,d0
	mulu	#$10,d0
	lea	FONT+34+160*32*1,a0
	adda.l	d0,a0
	bra	sui
lettres_2	cmpi.b	#$55,d0
	bge.s	lettres_3
	subi.b	#$4b,d0
	mulu	#$10,d0
	lea	FONT+34+160*32*2,a0
	adda.l	d0,a0
	bra	sui
lettres_3	subi.b	#$55,d0
	mulu	#$10,d0
	lea	FONT+34+160*32*3,a0
	adda.l	d0,a0
	bra	sui
chiffres2	subi.b	#$30,d0
	mulu	#$10,d0
	lea	FONT+34+160*32*0,a0
	adda.l	d0,a0
sui	rts

aff_1	move.l	#31,d0
cop_AFF_1	movem.l	-144(a1),d1-d7/a3-a6
	movem.l	d1-d7/a3-a6,-152(a1)
	movem.l	d1-d7/a3-a6,-152(a2)
	movem.l	-100(a1),d1-d7/a3-a6
	movem.l	d1-d7/a3-a6,-108(a1)
	movem.l	d1-d7/a3-a6,-108(a2)
	movem.l	-56(a1),d1-d7/a3-a6
	movem.l	d1-d7/a3-a6,-64(a1)
	movem.l	d1-d7/a3-a6,-64(a2)
	movem.l	-12(a1),d1-d5
	movem.l	d1-d5,-20(a1)
	movem.l	d1-d5,-20(a2)

	movem.l	(a0),d1-d2
	movem.l	d1-d2,(a1)
	movem.l	d1-d2,(a2)
	lea	160(a0),a0
	lea	160(a1),a1
	lea	160(a2),a2
	dbra	d0,cop_AFF_1
	rts

aff_2	move.l	#31,d0
cop_AFF_2	movem.l	-144(a2),d1-d7/a4-a6
	movem.l	d1-d7/a4-a6,-152(a2)
	movem.l	d1-d7/a4-a6,-152(a3)
	movem.l	-104(a2),d1-d7/a4-a6
	movem.l	d1-d7/a4-a6,-112(a2)
	movem.l	d1-d7/a4-a6,-112(a3)
	movem.l	-64(a2),d1-d7/a4-a6
	movem.l	d1-d7/a4-a6,-72(a2)
	movem.l	d1-d7/a4-a6,-72(a3)
	movem.l	-24(a2),d1-d7/a4
	movem.l	d1-d7/a4,-32(a2)
	movem.l	d1-d7/a4,-32(a3)
	
	move.b	(a1),(a2)
	move.b	2(a1),2(a2)
	move.b	4(a1),4(a2)
	move.b	6(a1),6(a2)
	move.b	(a0),1(a2)
	move.b	2(a0),3(a2)
	move.b	4(a0),5(a2)
	move.b	6(a0),7(a2)
	move.b	(a1),(a3)
	move.b	2(a1),2(a3)
	move.b	4(a1),4(a3)
	move.b	6(a1),6(a3)
	move.b	(a0),1(a3)
	move.b	2(a0),3(a3)
	move.b	4(a0),5(a3)
	move.b	6(a0),7(a3)
	lea	160(a0),a0
	lea	160(a1),a1
	lea	160(a2),a2
	lea	160(a3),a3
	dbra	d0,cop_AFF_2
	rts
	
scroll_2	cmpi.l	#0,stop
	beq.s	scroll2	
	sub.l	#1,stop
	bra	suit2
scroll2	move.l	pt1,d0
	lea	text,a0
	adda.l	d0,a0
	moveq	#0,d0
	move.b	(a0),d0
	tst	d0
	bne.s	pause
	clr.l	pt1
	clr.l	pt2
	clr.l	pt3
	bra.s	scroll2
pause	cmpi.b	#$2a,d0
	bne.s	space
	move.l	#50,stop
	add.l	#1,pt1
	bra	suit2
space	cmpi.b	#$20,d0
	bne.s	excla
	lea	c_space,a0
	bra	suite
excla	cmpi.b	#$21,d0
	bne.s	inter
	lea	c_excla,a0
	bra	suite
inter	cmpi.b	#$3f,d0
	bne.s	dx_pts
	lea	c_inter,a0
	bra	suite
dx_pts	cmpi.b	#$3a,d0
	bne.s	pt_virg
	lea	c_dx_pts,a0
	bra	suite
pt_virg	cmpi.b	#$3b,d0
	bne.s	virg
	lea	c_pt_virg,a0
	bra	suite
virg	cmpi.b	#$2c,d0
	bne.s	par_g
	lea	c_virg,a0
	bra	suite
par_g	cmpi.b	#$28,d0
	bne.s	par_d
	lea	c_par_g,a0
	bra	suite
par_d	cmpi.b	#$29,d0
	bne.s	tiret
	lea	c_par_d,a0
	bra.s	suite
tiret	cmpi.b	#$2d,d0
	bne.s	pt
	lea	c_tiret,a0
	bra.s	suite
pt	cmpi.b	#$2e,d0
	bne.s	guill
	lea	c_pt,a0
	bra.s	suite
guill	cmpi.b	#$27,d0
	bne.s	diese
	lea	c_guill,a0
	bra.s	suite
diese	cmpi.b	#$23,d0
	bne.s	div
	lea	c_diese,a0
	bra.s	suite
div	cmpi.b	#$2f,d0
	bne.s	plus
	lea	c_div,a0
	bra.s	suite	
plus	cmpi.b	#$2b,d0
	bne.s	lettres	
	lea	c_plus,a0
	bra.s	suite
lettres	cmpi.b	#$41,d0
	blt.s	chiffres
	subi.b	#$41,d0
	mulu	#8*10,d0
	lea	c_a,a0
	adda.l	d0,a0
	bra.s	suite
chiffres	subi.b	#$30,d0
	mulu	#8*10,d0
	lea	c_0,a0
	adda.l	d0,a0
suite	lea	buffer,a1
	lea	buffer+10,a2
	move.l	#20,d0
cop3	movem.l	(a2),d2-d7/a3-a6
	movem.l	d2-d7/a3-a6,(a1)
	lea	40(a2),a2
	lea	40(a1),a1
	dbf	d0,cop3
	adda.l	pt2,a0
	lea	buffer,a1
	movem.l	(a0),d0-d2
	movem.l	d0-d2,820(a1)
	add.l	#1,pt3
	cmp.l	#2,pt3
	bne.s	suit2
	clr.l	pt3
	add.l	#10,pt2
	cmp.l	#8*10,pt2
	bne.s	suit2
	clr.l	pt2
	add.l	#1,pt1
suit2	rts

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

pal2	dc.w	$000,$111,$222,$333,$444,$555,$666,$500
	dc.w	$700,$765,$000,$000,$000,$000,$000,$777
pal1	dc.w	$000,$000,$000,$000,$000,$000,$000,$000
	dc.w	$000,$000,$000,$000,$000,$000,$000,$000
	
c_space	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$000,$000,$000
	
c_0	dc.w	$777,$777,$777,$777,$777
	dc.w	$677,$677,$000,$000,$677
	dc.w	$577,$577,$000,$000,$577
	dc.w	$477,$000,$477,$000,$477
	dc.w	$377,$000,$377,$000,$377
	dc.w	$277,$000,$000,$277,$277
	dc.w	$177,$177,$177,$177,$177
	dc.w	$000,$000,$000,$000,$000

c_1	dc.w	$000,$000,$777,$000,$000
	dc.w	$000,$667,$667,$000,$000
	dc.w	$557,$557,$557,$000,$000
	dc.w	$447,$000,$447,$000,$000
	dc.w	$000,$000,$337,$000,$000
	dc.w	$000,$000,$227,$000,$000
	dc.w	$117,$117,$117,$117,$117
	dc.w	$000,$000,$000,$000,$000	
	
c_2	dc.w	$777,$777,$777,$777,$000
	dc.w	$000,$000,$000,$000,$676
	dc.w	$000,$000,$000,$000,$575
	dc.w	$000,$474,$474,$474,$474
	dc.w	$373,$000,$000,$000,$000
	dc.w	$272,$000,$000,$000,$000
	dc.w	$171,$171,$171,$171,$171
	dc.w	$000,$000,$000,$000,$000
	
c_3	dc.w	$777,$777,$777,$777,$777
	dc.w	$000,$000,$000,$000,$776
	dc.w	$000,$000,$000,$000,$775
	dc.w	$774,$774,$774,$774,$000
	dc.w	$000,$000,$000,$000,$773
	dc.w	$000,$000,$000,$000,$772
	dc.w	$771,$771,$771,$771,$000
	dc.w	$000,$000,$000,$000,$000

c_4	dc.w	$000,$000,$777,$000,$000
	dc.w	$000,$766,$766,$000,$000
	dc.w	$755,$000,$755,$000,$000
	dc.w	$744,$000,$744,$000,$000
	dc.w	$733,$733,$733,$733,$733
	dc.w	$000,$000,$722,$000,$000
	dc.w	$000,$000,$711,$000,$000
	dc.w	$000,$000,$000,$000,$000

c_5	dc.w	$777,$777,$777,$777,$777
	dc.w	$767,$000,$000,$000,$000
	dc.w	$757,$000,$000,$000,$000
	dc.w	$747,$747,$747,$747,$000
	dc.w	$000,$000,$000,$000,$737
	dc.w	$000,$000,$000,$000,$727
	dc.w	$717,$717,$717,$717,$000
	dc.w	$000,$000,$000,$000,$000
	
c_6	dc.w	$000,$777,$777,$777,$777
	dc.w	$766,$000,$000,$000,$000
	dc.w	$755,$000,$000,$000,$000
	dc.w	$744,$744,$744,$744,$000
	dc.w	$733,$000,$000,$000,$733
	dc.w	$722,$000,$000,$000,$722
	dc.w	$000,$711,$711,$711,$000
	dc.w	$000,$000,$000,$000,$000
	
c_7	dc.w	$777,$777,$777,$777,$777
	dc.w	$000,$000,$000,$000,$676
	dc.w	$000,$000,$000,$575,$575
	dc.w	$000,$000,$474,$474,$000
	dc.w	$000,$373,$373,$000,$000
	dc.w	$272,$272,$000,$000,$000
	dc.w	$171,$000,$000,$000,$000
	dc.w	$000,$000,$000,$000,$000
	
c_8	dc.w	$000,$777,$777,$777,$000
	dc.w	$677,$000,$000,$000,$677
	dc.w	$577,$000,$000,$000,$577
	dc.w	$000,$477,$477,$477,$000
	dc.w	$377,$000,$000,$000,$377
	dc.w	$277,$000,$000,$000,$277
	dc.w	$000,$177,$177,$177,$000
	dc.w	$000,$000,$000,$000,$000

c_9	dc.w	$000,$777,$777,$777,$000
	dc.w	$776,$000,$000,$000,$776
	dc.w	$775,$000,$000,$000,$775
	dc.w	$000,$774,$774,$774,$774
	dc.w	$000,$000,$000,$000,$773
	dc.w	$000,$000,$000,$000,$772
	dc.w	$771,$771,$771,$771,$000
	dc.w	$000,$000,$000,$000,$000
	
c_A	dc.w	$777,$777,$777,$777,$777
	dc.w	$767,$000,$000,$000,$767
	dc.w	$757,$000,$000,$000,$757
	dc.w	$747,$747,$747,$747,$747
	dc.w	$737,$000,$000,$000,$737
	dc.w	$727,$000,$000,$000,$727
	dc.w	$717,$000,$000,$000,$717
	dc.w	$000,$000,$000,$000,$000
	
c_B	dc.w	$777,$777,$777,$777,$000
	dc.w	$676,$000,$000,$000,$676
	dc.w	$575,$000,$000,$000,$575
	dc.w	$474,$474,$474,$474,$474
	dc.w	$373,$000,$000,$000,$373
	dc.w	$272,$000,$000,$000,$272
	dc.w	$171,$171,$171,$171,$000
	dc.w	$000,$000,$000,$000,$000

c_C	dc.w	$777,$777,$777,$777,$777
	dc.w	$667,$000,$000,$000,$667
	dc.w	$557,$000,$000,$000,$000
	dc.w	$447,$000,$000,$000,$000
	dc.w	$337,$000,$000,$000,$000
	dc.w	$227,$000,$000,$000,$227
	dc.w	$117,$117,$117,$117,$117
	dc.w	$000,$000,$000,$000,$000
	
c_D	dc.w	$777,$777,$777,$777,$000
	dc.w	$766,$000,$000,$000,$766
	dc.w	$755,$000,$000,$000,$755
	dc.w	$744,$000,$000,$000,$744
	dc.w	$733,$000,$000,$000,$733
	dc.w	$722,$000,$000,$000,$722
	dc.w	$711,$711,$711,$711,$000
	dc.w	$000,$000,$000,$000,$000
	
c_E	dc.w	$777,$777,$777,$777,$777
	dc.w	$776,$000,$000,$000,$000
	dc.w	$775,$000,$000,$000,$000
	dc.w	$774,$774,$774,$774,$774
	dc.w	$773,$000,$000,$000,$000
	dc.w	$772,$000,$000,$000,$000
	dc.w	$771,$771,$771,$771,$771
	dc.w	$000,$000,$000,$000,$000
	
c_F	dc.w	$777,$777,$777,$777,$777
	dc.w	$677,$000,$000,$000,$000
	dc.w	$577,$000,$000,$000,$000
	dc.w	$477,$477,$477,$477,$000
	dc.w	$377,$000,$000,$000,$000
	dc.w	$277,$000,$000,$000,$000
	dc.w	$177,$000,$000,$000,$000
	dc.w	$000,$000,$000,$000,$000
	
c_G	dc.w	$777,$777,$777,$777,$777
	dc.w	$767,$000,$000,$000,$000
	dc.w	$757,$000,$000,$000,$000
	dc.w	$747,$000,$747,$747,$747
	dc.w	$737,$000,$000,$000,$737
	dc.w	$727,$000,$000,$000,$727
	dc.w	$717,$717,$717,$717,$717
	dc.w	$000,$000,$000,$000,$000
	
c_H	dc.w	$777,$000,$000,$000,$777
	dc.w	$676,$000,$000,$000,$676
	dc.w	$575,$000,$000,$000,$575
	dc.w	$474,$474,$474,$474,$474
	dc.w	$373,$000,$000,$000,$373
	dc.w	$272,$000,$000,$000,$272
	dc.w	$171,$000,$000,$000,$171
	dc.w	$000,$000,$000,$000,$000

c_I	dc.w	$000,$777,$777,$777,$000
	dc.w	$000,$000,$667,$000,$000
	dc.w	$000,$000,$557,$000,$000
	dc.w	$000,$000,$447,$000,$000
	dc.w	$000,$000,$337,$000,$000
	dc.w	$000,$000,$227,$000,$000
	dc.w	$000,$117,$117,$117,$000
	dc.w	$000,$000,$000,$000,$000
	
c_J	dc.w	$777,$777,$777,$777,$777
	dc.w	$000,$000,$766,$000,$000
	dc.w	$000,$000,$755,$000,$000
	dc.w	$000,$000,$744,$000,$000
	dc.w	$000,$000,$733,$000,$000
	dc.w	$000,$000,$722,$000,$000
	dc.w	$711,$711,$711,$000,$000
	dc.w	$000,$000,$000,$000,$000
	
c_K	dc.w	$777,$000,$000,$000,$777
	dc.w	$776,$000,$000,$776,$000
	dc.w	$775,$000,$775,$000,$000
	dc.w	$774,$774,$000,$000,$000
	dc.w	$773,$000,$773,$000,$000
	dc.w	$772,$000,$000,$772,$000
	dc.w	$771,$000,$000,$000,$771
	dc.w	$000,$000,$000,$000,$000
	
c_L	dc.w	$777,$000,$000,$000,$000
	dc.w	$677,$000,$000,$000,$000
	dc.w	$577,$000,$000,$000,$000
	dc.w	$477,$000,$000,$000,$000
	dc.w	$377,$000,$000,$000,$000
	dc.w	$277,$000,$000,$000,$000
	dc.w	$177,$177,$177,$177,$177
	dc.w	$000,$000,$000,$000,$000
	
c_M	dc.w	$777,$000,$000,$000,$777
	dc.w	$767,$767,$000,$767,$767
	dc.w	$757,$757,$757,$757,$757
	dc.w	$747,$000,$747,$000,$747
	dc.w	$737,$000,$000,$000,$737
	dc.w	$727,$000,$000,$000,$727
	dc.w	$717,$000,$000,$000,$717
	dc.w	$000,$000,$000,$000,$000
	
c_N	dc.w	$777,$000,$000,$000,$777
	dc.w	$676,$676,$000,$000,$676
	dc.w	$575,$575,$575,$000,$575
	dc.w	$474,$000,$474,$474,$474
	dc.w	$373,$000,$000,$373,$373
	dc.w	$272,$000,$000,$000,$272
	dc.w	$171,$000,$000,$000,$171
	dc.w	$000,$000,$000,$000,$000

c_O	dc.w	$777,$777,$777,$777,$777
	dc.w	$667,$000,$000,$000,$667
	dc.w	$557,$000,$000,$000,$557
	dc.w	$447,$000,$000,$000,$447
	dc.w	$337,$000,$000,$000,$337
	dc.w	$227,$000,$000,$000,$227
	dc.w	$117,$117,$117,$117,$117
	dc.w	$000,$000,$000,$000,$000

c_P	dc.w	$777,$777,$777,$777,$777
	dc.w	$766,$000,$000,$000,$766
	dc.w	$755,$000,$000,$000,$755
	dc.w	$744,$744,$744,$744,$744
	dc.w	$733,$000,$000,$000,$000
	dc.w	$722,$000,$000,$000,$000
	dc.w	$711,$000,$000,$000,$000
	dc.w	$000,$000,$000,$000,$000
	
c_Q	dc.w	$000,$777,$777,$777,$000
	dc.w	$776,$000,$000,$000,$776
	dc.w	$775,$000,$000,$000,$775
	dc.w	$774,$000,$000,$000,$774
	dc.w	$773,$000,$773,$000,$773
	dc.w	$772,$000,$000,$772,$772
	dc.w	$000,$771,$771,$771,$771
	dc.w	$000,$000,$000,$000,$000
	
c_R	dc.w	$777,$777,$777,$777,$777
	dc.w	$677,$000,$000,$000,$677
	dc.w	$577,$000,$000,$000,$577
	dc.w	$477,$477,$477,$477,$477
	dc.w	$377,$377,$377,$000,$000
	dc.w	$277,$000,$277,$277,$000
	dc.w	$177,$000,$000,$177,$177
	dc.w	$000,$000,$000,$000,$000
	
c_S	dc.w	$000,$777,$777,$777,$777
	dc.w	$767,$000,$000,$000,$000
	dc.w	$757,$000,$000,$000,$000
	dc.w	$747,$747,$747,$747,$747
	dc.w	$000,$000,$000,$000,$737
	dc.w	$000,$000,$000,$000,$727
	dc.w	$717,$717,$717,$717,$000
	dc.w	$000,$000,$000,$000,$000
	
c_T	dc.w	$777,$777,$777,$777,$777
	dc.w	$000,$000,$676,$000,$000
	dc.w	$000,$000,$575,$000,$000
	dc.w	$000,$000,$474,$000,$000
	dc.w	$000,$000,$373,$000,$000
	dc.w	$000,$000,$272,$000,$000
	dc.w	$000,$000,$171,$000,$000
	dc.w	$000,$000,$000,$000,$000

c_U	dc.w	$777,$000,$000,$000,$777
	dc.w	$667,$000,$000,$000,$667
	dc.w	$557,$000,$000,$000,$557
	dc.w	$447,$000,$000,$000,$447
	dc.w	$337,$000,$000,$000,$337
	dc.w	$227,$000,$000,$000,$227
	dc.w	$117,$117,$117,$117,$117
	dc.w	$000,$000,$000,$000,$000

c_V	dc.w	$777,$000,$000,$000,$777
	dc.w	$766,$000,$000,$000,$766
	dc.w	$755,$000,$000,$000,$755
	dc.w	$744,$000,$000,$000,$744
	dc.w	$733,$733,$000,$744,$744
	dc.w	$000,$722,$722,$722,$000
	dc.w	$000,$000,$711,$000,$000
	dc.w	$000,$000,$000,$000,$000
	
c_W	dc.w	$777,$000,$000,$000,$777
	dc.w	$776,$000,$000,$000,$776
	dc.w	$775,$000,$000,$000,$775
	dc.w	$774,$000,$774,$000,$774
	dc.w	$773,$773,$773,$773,$773
	dc.w	$772,$772,$000,$772,$772
	dc.w	$771,$000,$000,$000,$771
	dc.w	$000,$000,$000,$000,$000
	
c_X	dc.w	$777,$000,$000,$000,$777
	dc.w	$677,$667,$000,$677,$677
	dc.w	$000,$577,$577,$577,$000
	dc.w	$000,$000,$477,$000,$000
	dc.w	$000,$377,$377,$377,$000
	dc.w	$277,$277,$000,$277,$277
	dc.w	$177,$000,$000,$000,$177
	dc.w	$000,$000,$000,$000,$000
	
c_Y	dc.w	$777,$000,$000,$000,$777
	dc.w	$767,$000,$000,$000,$767
	dc.w	$757,$757,$000,$757,$757
	dc.w	$000,$747,$747,$747,$000
	dc.w	$000,$000,$737,$000,$000
	dc.w	$000,$000,$727,$000,$000
	dc.w	$000,$000,$717,$000,$000
	dc.w	$000,$000,$000,$000,$000
	
c_Z	dc.w	$777,$777,$777,$777,$777
	dc.w	$000,$000,$000,$000,$676
	dc.w	$000,$000,$000,$575,$575
	dc.w	$000,$000,$474,$474,$000
	dc.w	$000,$373,$373,$000,$000
	dc.w	$272,$272,$000,$000,$000
	dc.w	$171,$171,$171,$171,$171
	dc.w	$000,$000,$000,$000,$000
	
c_excla	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$676,$000,$000
	dc.w	$000,$000,$575,$000,$000
	dc.w	$000,$000,$474,$000,$000
	dc.w	$000,$000,$373,$000,$000
	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$171,$000,$000
	dc.w	$000,$000,$000,$000,$000

c_inter	dc.w	$000,$777,$777,$777,$000
	dc.w	$000,$776,$000,$776,$000
	dc.w	$000,$000,$000,$775,$000
	dc.w	$000,$000,$774,$774,$000
	dc.w	$000,$000,$773,$000,$000
	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$771,$000,$000
	dc.w	$000,$000,$000,$000,$000
	
c_dx_pts	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$767,$000,$000
	dc.w	$000,$000,$757,$000,$000
	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$737,$000,$000
	dc.w	$000,$000,$727,$000,$000
	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$000,$000,$000
	
c_pt_virg	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$677,$000,$000
	dc.w	$000,$000,$577,$000,$000
	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$377,$000,$000
	dc.w	$000,$000,$277,$000,$000
	dc.w	$000,$177,$000,$000,$000
	dc.w	$000,$000,$000,$000,$000
	
c_virg	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$667,$000,$000
	dc.w	$000,$000,$557,$000,$000
	dc.w	$000,$000,$447,$000,$000
	dc.w	$000,$000,$337,$000,$000
	dc.w	$000,$000,$227,$000,$000
	dc.w	$000,$117,$000,$000,$000
	dc.w	$000,$000,$000,$000,$000

c_par_g	dc.w	$000,$777,$777,$000,$000
	dc.w	$000,$766,$000,$000,$000
	dc.w	$000,$755,$000,$000,$000
	dc.w	$000,$744,$000,$000,$000
	dc.w	$000,$733,$000,$000,$000
	dc.w	$000,$722,$000,$000,$000
	dc.w	$000,$711,$711,$000,$000
	dc.w	$000,$000,$000,$000,$000
	
c_par_d	dc.w	$000,$000,$777,$777,$000
	dc.w	$000,$000,$000,$776,$000
	dc.w	$000,$000,$000,$775,$000
	dc.w	$000,$000,$000,$774,$000
	dc.w	$000,$000,$000,$773,$000
	dc.w	$000,$000,$000,$772,$000
	dc.w	$000,$000,$771,$771,$000
	dc.w	$000,$000,$000,$000,$000
	
c_tiret	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$447,$447,$447,$000
	dc.w	$000,$337,$337,$337,$000
	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$000,$000,$000

c_pt	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$747,$000,$000
	dc.w	$000,$000,$737,$000,$000
	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$000,$000,$000
	
c_guill	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$677,$000,$000
	dc.w	$000,$000,$577,$000,$000
	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$000,$000,$000

c_diese	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$777,$000,$777,$000
	dc.w	$767,$767,$767,$767,$767
	dc.w	$000,$757,$000,$757,$000
	dc.w	$000,$747,$000,$747,$000
	dc.w	$737,$737,$737,$737,$737
	dc.w	$000,$727,$000,$727,$000
	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$000,$000,$000
	
c_div	dc.w	$000,$000,$000,$000,$777
	dc.w	$000,$000,$000,$677,$677
	dc.w	$000,$000,$577,$577,$000
	dc.w	$000,$477,$477,$000,$000
	dc.w	$377,$377,$000,$000,$000
	dc.w	$277,$000,$000,$000,$000
	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$000,$000,$000
	
c_plus	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$767,$000,$000
	dc.w	$000,$000,$757,$000,$000
	dc.w	$000,$747,$747,$747,$000
	dc.w	$000,$000,$737,$000,$000
	dc.w	$000,$000,$727,$000,$000
	dc.w	$000,$000,$000,$000,$000
	dc.w	$000,$000,$000,$000,$000
	
TEXT	DC.B	" TSG IS AN ALLIANCE BETWEEN   - FUZION -   - HEMOROIDS -   - IMPACT -     "
	DC.B	" THE MEMBERS OF FUZION ARE :   ORION   DRAGON   FULCRUM   SPEEDER   DARKLIGHT   DOCNO   SQUAT        "
	DC.B	" THE MEMBERS OF HEMOROIDS ARE :   SKYRACE   CKAOS   GLUEV   PARANOIDS   SINK   SKYHAWK   SAMOS   WOODY   DOCTOR BIT       "
	DC.B	" THE MEMBERS OF IMPACT ARE :   AXIOM   DAD   HELLRIZER   AND THE OTHERS....      SEE YOU SOON........         ",0

text1	dc.b	"HELLO FOLKS !!! HERE YOU SEE THE NEW-MEGA-GREAT-INTRO CODED BY ORION ( THE DEVIL ! ) "
	DC.B	"I THINK THIS IS THE FINAL VERSION ( I HOPE ... ) SO SEE YOU SOON FOR A NEXT GREAT INTRO !!!              ",0

pt_pass	dc.b	4
pos	dc.l	buff1

orio	dc.l	$78000+160*60+8*14
	dc.l	$78000+160*68+8*15
	dc.l	$78000+160*76+8*16
	dc.l	$78000+160*84+8*17
	dc.l	$78000+160*92+8*18
orio_pt	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
	dc.b	0
att_col	dc.l	200

*pal3	dc.w	$300,$400,$510,$520,$630,$640,$750
pal3	dc.w	$003,$004,$015,$025,$036,$046,$057
*pal3	dc.w	$030,$040,$051,$052,$063,$064,$075

buffer3	dc.w	$220,$330,$440,$550,$660,$770,$770
	dc.w	$770,$770,$660,$550,$440,$330,$220,$000
	
buffer4	dc.w	$020,$030,$040,$050,$060,$070,$070
	dc.w	$070,$070,$060,$050,$040,$030,$020,$000
	
	dc.w	$202,$303,$404,$505,$606,$707,$707
	dc.w	$707,$707,$606,$505,$404,$303,$202,$000
	
	dc.w	$200,$300,$400,$500,$600,$700,$700
	dc.w	$700,$700,$600,$500,$400,$300,$200,$000
	
	dc.w	$222,$333,$444,$555,$666,$777,$777
	dc.w	$777,$777,$666,$555,$444,$333,$222,$000
	
	dc.w	$022,$033,$044,$055,$066,$077,$077
	dc.w	$077,$077,$066,$055,$044,$033,$022,$000
	
	dc.w	$220,$330,$440,$550,$660,$770,$770
	dc.w	$770,$770,$660,$550,$440,$330,$220,$000
	
	dc.w	$117,$227,$337,$447,$557,$667,$777
	dc.w	$777,$766,$755,$744,$733,$722,$711,$000
	
	dc.w	$ffff

table_sin	rept	48
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
	rept	6
	dc.b	2,1,1,2,1,1,1,1,1,1,0,1,1,0
	dc.b	0,1,1,0,1,1,1,1,1,1,2,1,1,2
	endr	
	rept	32
	dc.b	1
	endr
	rept	8
	dc.b	0
	endr
	rept	32
	dc.b	1
	endr
	rept	8
	dc.b	2
	endr
	rept	32
	dc.b	1
	endr
	rept	8
	dc.b	2
	endr
	rept	32
	dc.b	1
	endr
	rept	8
	dc.b	0
	endr
	dc.b	3
pt_sin	dc.l	0
adr_logo	dc.l	$78000+160*69	*50 - 88
table_line	dc.b	2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,1,1,2,1,1,1,2,1,1,1,1
	dc.b	1,1,1,1,0,1,1,1,0,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,1,0,1,1,1,0,1,1,1,1
	dc.b	1,1,1,1,2,1,1,1,2,1,1,2,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
	dc.b	3
	
pt_line	dc.l	0
text3	dc.b	27,"E",27,"Y",44,41,"FUZION IS GOOD FOR YOU !",0
text2	dc.b	27,"E",27,"Y",44,47,"PLEASE WAIT",0
nom	dc.b	"a:\game.*",0
	
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
pt3	ds.l	1
buffer	ds.l	420
pt_1	ds.l	1
buff1	ds.l	40*32
buff2	ds.l	40*32
	even
music	incbin	\orion.src\fuzion.crk\scr_rast\slam1
	even
vu_pic	incbin	\orion.src\fuzion.crk\scr_rast\vu.pi1
	even
pic	incbin	\orion.src\fuzion.crk\scr_rast\scr.pi1
	even
font	incbin	\orion.src\fuzion.crk\scr_rast\tlb.pi1
	end