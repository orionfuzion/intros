	*************************************
	* Intro      Logo behind Scroll     *
	* Coder      ORION from FUZION      *
	* Purpose    FUZION Compact Disks   *
	* Date       Feb 1991 - CD#31       *
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
	
quit	pea	bye
	move	#$26,-(sp)
	trap	#14
	addq	#6,sp
	
	clr.l	-(sp)
	trap	#1
		
intro	bsr	save_all
	bsr	set_scr
	moveq	#1,d0
	bsr	music
	bsr	inter_on
loop	move.b	$fffffc02.w,d0
f1	cmp.b	#$3b,d0
	bne	f2
	move.l	#nom1,nom+2
	bra	bye1
f2	cmp.b	#$3c,d0
	bne	loop
	move.l	#nom2,nom+2
bye1	bsr	inter_off
	rts
	
set_scr	move	#$25,-(sp)
	trap	#14
	lea	2(sp),sp
	dc.w	$a00a
	move.b	#6,$484.w
	movem.l	black,d0-d7
	movem.l	d0-d7,$ffff8240.w
	lea	$70000,a3
	clr	-(sp)
	move.l	a3,-(sp)
	move.l	(sp),-(sp)
	move	#5,-(sp)
	trap	#14
	lea	$c(sp),sp
	move.l	a3,a0
	move.l	#$4000-1,d0
eff_zob	clr.l	(a0)+
	dbf	d0,eff_zob
	lea	pic+34,a0
	move.l	a3,a1
	add.l	#160*5,a1
	move.l	#40*200-1,d0
aff_im	move.l	(a0)+,(a1)+
	dbf	d0,aff_im
	lea	font+34+160*28*5+160,a0
	move.l	a3,a1
	adda.l	#160*210,a1
	move.l	#40*56-1,d0
aff_logo	move.l	(a0)+,(a1)+
	dbf	d0,aff_logo
	rts

new_vbl	clr.w	pt_line
nbr	move.l	#$598,d0
att1	dbf	d0,att1
	clr	$ffff820a.w
	moveq	#1,d0
att2	dbf	d0,att2
	move.b	#2,$ffff820a.w
	bsr	init_vbl
	bsr	scroll
	bsr	music+6
	rte

init_vbl	lea	buf_col,a0
	move.l	a0,hbl2+2
	move.l	#hbl1,$120.w
	movem.l	pic+2,d0-d7
	movem.l	d0-d7,$ffff8240.w
	rts

scroll	bsr	test_let
	bsr	aff_let
	rts
	
test_let	lea	text,a0
	adda.l	pt_text,a0
	clr.l	d0
	move.b	(a0),d0
	tst	d0
	bne.s	space
	clr.l	pt_text
	bra.s	test_let
space	cmpi.b	#$20,d0
	bne.s	excla1
	lea	font+34+160*28*4+16*6,a1
	bra	suite_1
excla1	cmpi.b	#$21,d0
	bne.s	inter1
	lea	font+34+160*28*3+16*6,a1
	bra	suite_1
inter1	cmpi.b	#$3f,d0
	bne.s	dx_pts1
	lea	font+34+160*28*4+16*4,a1
	bra	suite_1
dx_pts1	cmpi.b	#$3a,d0
	bne.s	pt_virg1
	lea	font+34+160*28*4+16*1,a1
	bra	suite_1
pt_virg1	cmpi.b	#$3b,d0
	bne.s	virg1
	lea	font+34+160*28*4+16*5,a1
	bra	suite_1
virg1	cmpi.b	#$2c,d0
	bne.s	par_g1
	lea	font+34+160*28*4+16*3,a1
	bra	suite_1
par_g1	cmpi.b	#$28,d0
	bne.s	par_d1
	lea	font+34+160*28*3+16*9,a1
	bra	suite_1
par_d1	cmpi.b	#$29,d0
	bne.s	tiret1
	lea	font+34+160*28*4+16*0,a1
	bra	suite_1
tiret1	cmpi.b	#$2d,d0
	bne.s	pnt1
	lea	font+34+160*28*3+16*7,a1
	bra	suite_1
pnt1	cmpi.b	#$2e,d0
	bne.s	guill1
	lea	font+34+160*28*3+16*8,a1
	bra	suite_1
guill1	cmpi.b	#$27,d0
	bne.s	lettres_11
	lea	font+34+160*28*4+16*2,a1
	bra	suite_1
lettres_11	cmpi.b	#$41,d0
	blt.s	chiffres_1
	cmpi.b	#$4b,d0
	bge.s	lettres_12
	subi.b	#$41,d0
	mulu	#$10,d0
	lea	font+34+160*28*1,a1
	adda.l	d0,a1
	bra.s	suite_1
lettres_12	cmpi.b	#$55,d0
	bge.s	lettres_13
	subi.b	#$4b,d0
	mulu	#$10,d0
	lea	font+34+160*28*2,a1
	adda.l	d0,a1
	bra.s	suite_1
lettres_13	subi.b	#$55,d0
	mulu	#$10,d0
	lea	font+34+160*28*3,a1
	adda.l	d0,a1
	bra.s	suite_1
chiffres_1	subi.b	#$30,d0
	mulu	#$10,d0
	lea	font+34,a1
	adda.l	d0,a1
suite_1	adda.l	pt_plan,a1
plus_0	cmp.l	#0,pt_plan
	bne.s	plus_1
	move.l	#1,pt_plan
	bra	suite_2
plus_1	cmp.l	#1,pt_plan
	bne.s	plus_8
	move.l	#8,pt_plan
	bra	suite_2
plus_8	cmp.l	#8,pt_plan
	bne.s	plus_9
	move.l	#9,pt_plan
	bra	suite_2
plus_9	move.l	#0,pt_plan
	add.l	#1,pt_text
suite_2	rts

aff_let	lea	$70000+210*160,a0
	move.l	#27,d0
aff_cop	move.b	1+6(a0),+6(a0)
	move.b	8+6(a0),1+6(a0)
	move.b	9+6(a0),8+6(a0)
	move.b	16+6(a0),9+6(a0)
	move.b	17+6(a0),16+6(a0)
	move.b	24+6(a0),17+6(a0)
	move.b	25+6(a0),24+6(a0)
	move.b	32+6(a0),25+6(a0)
	move.b	33+6(a0),32+6(a0)
	move.b	40+6(a0),33+6(a0)
	move.b	41+6(a0),40+6(a0)
	move.b	48+6(a0),41+6(a0)
	move.b	49+6(a0),48+6(a0)
	move.b	56+6(a0),49+6(a0)
	move.b	57+6(a0),56+6(a0)
	move.b	64+6(a0),57+6(a0)
	move.b	65+6(a0),64+6(a0)
	move.b	72+6(a0),65+6(a0)
	move.b	73+6(a0),72+6(a0)
	move.b	80+6(a0),73+6(a0)
	move.b	81+6(a0),80+6(a0)
	move.b	88+6(a0),81+6(a0)
	move.b	89+6(a0),88+6(a0)
	move.b	96+6(a0),89+6(a0)
	move.b	97+6(a0),96+6(a0)
	move.b	104+6(a0),97+6(a0)
	move.b	105+6(a0),104+6(a0)
	move.b	112+6(a0),105+6(a0)
	move.b	113+6(a0),112+6(a0)
	move.b	120+6(a0),113+6(a0)
	move.b	121+6(a0),120+6(a0)
	move.b	128+6(a0),121+6(a0)
	move.b	129+6(a0),128+6(a0)
	move.b	136+6(a0),129+6(a0)
	move.b	137+6(a0),136+6(a0)
	move.b	144+6(a0),137+6(a0)
	move.b	145+6(a0),144+6(a0)
	move.b	152+6(a0),145+6(a0)
	move.b	153+6(a0),152+6(a0)
	
	move.b	(a1),153+6(a0)
	
	move	+6(a0),160+6(a0)
	move	8+6(a0),168+6(a0)
	move	16+6(a0),176+6(a0)
	move	24+6(a0),184+6(a0)
	move	32+6(a0),192+6(a0)
	move	40+6(a0),200+6(a0)
	move	48+6(a0),208+6(a0)
	move	56+6(a0),216+6(a0)
	move	64+6(a0),224+6(a0)
	move	72+6(a0),232+6(a0)
	move	80+6(a0),240+6(a0)
	move	88+6(a0),248+6(a0)
	move	96+6(a0),256+6(a0)
	move	104+6(a0),264+6(a0)
	move	112+6(a0),272+6(a0)
	move	120+6(a0),280+6(a0)
	move	128+6(a0),288+6(a0)
	move	136+6(a0),296+6(a0)
	move	144+6(a0),304+6(a0)
	move	152+6(a0),312+6(a0)
	
	lea	320(a0),a0
	lea	160(a1),a1
	
	dbf	d0,aff_cop
	rts
	
hbl1	cmpi.w	#206,pt_line
	bne.s	ret1
	clr.l	$ffff8240.w
	clr.l	$ffff8244.w
	clr.l	$ffff8248.w
	clr.l	$ffff824c.w
	move.l	font+2,$ffff8250.w
	move.l	font+6,$ffff8254.w
	move.l	font+10,$ffff8258.w
	move	font+14,$ffff825c.w
	move.l	#hbl2,$120.w
ret1	addq.w	#1,pt_line
	rte

hbl2	move.w	buf_col,$ffff825e.w
	cmpi.w	#227,pt_line	* 227
	bne	ret2
	rept	115
	nop
	endr
	clr.b	$ffff820a.w
	rept	8
	nop
	endr
	move.b	#2,$ffff820a.w
ret2	add.l	#2,hbl2+2
	addq.w	#1,pt_line
	rte

save_all	lea	big_buf,a1
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

inter_on	move	#$2700,sr
	and.b	#$fe,$fffffa13.w
	and.b	#$fe,$fffffa0f.w
	and.b	#$fe,$fffffa0b.w
	and.b	#$fe,$fffffa07.w
	*clr.b	$fffffa09.w
	move.b 	#$8,$fffffa1b.w
	move.b 	#1,$fffffa21.w
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
	move	#1,$452.w
	movem.l	black,d0-d7
	movem.l	d0-d7,$ffff8240.w
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
	move.w	#$2300,sr
	move	#$777,$ffff825e.w
	rts

bye	movem.l	big_buf+6,d0-d7
	movem.l	d0-d7,$ffff8240.w
	move.w	#$777,$ffff8240.w
	move.w	#0,$ffff8246.w
	move.b	#7,$484.w
	dc.w	$a009
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
buf_col	rept	4
	dc.w	$000
	endr
	dc.w	$701,$702,$703,$704,$705,$706,$707
	dc.w	$607,$507,$407,$307,$207,$107,$007
	dc.w	$017,$027,$037,$047,$057,$067,$077
	dc.w	$076,$075,$074,$073,$072,$071,$070
	dc.w	$170,$270,$370,$470,$570,$670,$770
	dc.w	$760,$750,$740,$730,$720,$710,$700
	dc.w	$701,$702,$703,$704,$705,$706,$707
	dc.w	$607,$507,$407,$307,$207,$107,$007
	dc.w	$017,$027,$037,$047,$057,$067,$077
	dc.w	$076,$075,$074,$073,$072,$071,$070
	dc.w	$000,$000,$000,$000,$000,$000,$000
	even
text	DC.B	" YO LAMERS !!!   ORION AND DRAGON PRESENT A NEW MEGA CD WITH RANX XEROX AND LOOPZ !!!    "
	DC.B	"  SHITTY INTRO FASTLY CODED BY ORION, PACKS BY HIM AND GRAPHIX BY HIS BROTHER ( AHAHA ) AL !!!!    "
	DC.B	"   MEMBERS ARE : ORION, DRAGON, DOCNO, SQUAT, KASAR, FULCRUM, SPEEDER, KELVIN.....     " 
	DC.B	" HERE'S OUR GREETINGS LIST :    "
	dc.b	" THE REPLICANTS ( MAXI, NTM, ST-WAIKIKI ), ST-CNX ( KRAZY REX ), OVERLANDERS ( ADSO, DOCLANDS AND FURYO ), MAD VISION ( SPY3 ), EQUINOX, HMD ( GLUEV, PARANOID, SINK AND SKYRACE ), IMPACT ( AXIOM, SUNSET ), THE CORPORATION ( STRANGER ), "
	DC.B	"RMA ( ALL FOLKS !! ), BLUE MAX, EMPIRE, FUTUR MINDS ( BOULDOG, SKYLINE ), MCS ( AXEL F. ), DMA ( JINX ), MASTERS, TBC ( SHARPMAN ), BWK ( SERGENT ), LAP, TSB, BAD BOY BELGIUM, VMAX, PENDRAGONS ( FX ), FASHION,"
	DC.B	" MAXX-OUT, SAMOS, MINUTE MAN, TST, FIREHAWKS, NEXT, STARKS, PHENIX, BLACK EAGLE, FELESOFT"
	DC.B	" AND OUR FRIEND JEAN-PATRICE....    " 
	DC.B	" ALSO TO THE FOREIGN CREWS : TCB, TEX, THE LOST BOYS, FOF, MEDWAY BOYS, AUTOMATION, ULM, POMPEY PIRATES, INNER CIRCLE, RIPPED OFF " 	
	DC.B	"          RTEL CLUB FUZION PASS FUZION !!!          LET'S WRAP !!!!                     "
	DC.B	0
	even
pile	ds.l	$80
	even
pt_text	ds.l	1
	even
pt_plan	ds.l	1
	even
pt_line	ds.w	1
	even
pt_col	ds.l	1
	even
big_buf	ds.l	$50
	even
nom1	dc.b	"1",0
	even
nom2	dc.b	"2",0
	even
music	incbin	\orion.src\fuzion.cd\logo_scr\count6.bin
	even
font	incbin	\orion.src\fuzion.cd\logo_scr\ovr_1p.pi1
	even
pic	incbin	\orion.src\fuzion.cd\logo_scr\cd31.pi1
	end