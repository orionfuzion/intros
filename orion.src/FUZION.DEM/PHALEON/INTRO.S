	*************************************
	* Demo       STE Soundtrack Screen  *
	* Coder      ORION from FUZION      *
	* Usage      Originally for the     *
	*            Phaleon Demo           *
	* Date       Spring 1991            *
	*                                   *
	* Machine    Atari STE - 1MB RAM    *	
	* TOS        1.62                   *
	* Assembler  GenST v2.09            *
	* Emulator   Steem v3.2             *
	*                                   *
	* Contact    Orion.Fuzion@gmail.com *
	*************************************
	
	movem.l	d0-d7/a0-a7,regs
	lea	pile+$140,sp
	move.w	sr,d0
	btst	#$d,d0
	bne.s	super 
	dc.w	$a00a                     
	pea	screen
	move	#$26,-(sp)
	trap	#14
	addq	#6,sp
	bra.s	fin
super	bsr.s	screen
set_pile	movem.l	regs,d0-d7/a0-a7
	jmp	(a0)
fin	clr.l	-(sp)
	trap	#1
	
screen	jsr	save_all
	jsr	set_black
	jsr	test_ste
	jsr	init_muzexx
	jsr	set_scrs
	jsr	inter_on
loop	cmp.b	#$39,$fffffc02.w
	bne.s	loop
	jsr	effet_fin
	jsr	inter_off
	rts

test_ste	lea	$ffff820f.w,a0
	move.b	#$50,(a0)
	cmpi.b	#$50,(a0)
	beq	ste
	lea	$78000,a0
	move.l	#40*200-1,d0
eff_scr	clr.l	(a0)+
	dbf	d0,eff_scr
	lea	stf_mes,a0
	lea	$78000+160*86,a1
	move.l	#40*27-1,d0
cop_mess	move.l	(a0)+,(a1)+
	dbf	d0,cop_mess
	move.w	#$777,$ffff8242.w
loop2	cmp.b	#$39,$fffffc02.w
	bne.s	loop2
	jsr	inter_off
	addq	#4,sp
ste	clr.b	$ffff820f.w
	rts	
	
set_scrs	lea	pic+34,a0
	lea	$60900,a1
	lea	$68600,a2
	lea	$70300,a3
	lea	$78000,a4
	move.l	#7999,d0
cop	move.l	(a0),(a1)+
	move.l	(a0),(a2)+
	move.l	(a0),(a3)+
	move.l	(a0)+,(a4)+
	dbra	d0,cop
	move.l	#$07770777,d0
	move.l	d0,d1
	move.l	d1,d2
	move.l	d2,d3
	movem.l	d0-d3,$ffff8250.w
	rts

set_black	clr.l	d0
	clr.l	d1
	clr.l	d2
	clr.l	d3
	clr.l	d4
	clr.l	d5
	clr.l	d6
	clr.l	d7
	movem.l	d0-d7,$ffff8240.w
	clr.b	$ffff8260.w
	move.b	#2,$ffff820a.w
	move.b	#$07,$ffff8201.w
	move.b	#$80,$ffff8203.w
	rts
	
new_hbl1	cmp.b	#1,pt_vbl
	beq.s	ok
	cmp.b	#2,pt_vbl
	beq.s	ok
	cmp.b	#3,pt_vbl
	bne.s	hbl1_ret
ok	move.b 	#8,$fffffa1b.w
	move.b 	#3,$fffffa21.w
	move.l	#new_hbl2,$120.w
hbl1_ret	rte

new_hbl2	move.l	buf_col,$ffff8250.w
	move.l	$ffff8250.w,$ffff8254.w
	move.l	$ffff8250.w,$ffff8258.w
	move.l	$ffff8250.w,$ffff825c.w
	addq	#4,new_hbl2+4
	rte

effet_fin	clr.l	$4d2.w
	clr.w	$ffff8900.w
	move.b	#$64,$fffffa09.w
	move.l	adr_scr,a5
	lea	160*200(a5),a6
	move.w	#100,cpt_fin
	movem.l	a5-a6,reg_fin
	move.l	#cop_eff,$4d2.w
att_effet	tst.l	$4d2.w
	bne.s	att_effet
	rts
	
cop_eff	move.l	#buf_col,new_hbl2+2
	move.b 	#8,$fffffa1b.w
	eor.b	#1,$fffffa21.w
	move.l	#new_hbl1,$120.w
	move.b	adr_scr+1,$ffff8205.w
	move.b	adr_scr+2,$ffff8207.w
	move.b	adr_scr+3,$ffff8209.w
	movem.l	reg_fin,a5-a6
	move.l	#40-1,d5
eff_line	clr.l	(a5)+
	clr.l	-(a6)
	dbf	d5,eff_line
	subq.w	#1,cpt_fin
	tst.w	cpt_fin
	bne.s	effet_ret
	clr.l	$4d2.w
effet_ret	movem.l	a5-a6,reg_fin
	rts

vbl0	move.l	#buf_col,new_hbl2+2
	move.b 	#8,$fffffa1b.w
	eor.b	#1,$fffffa21.w
	move.l	#new_hbl1,$120.w
	jsr	scrolls
	cmp.b	#1,pt_vbl
	bne.s	vbl2
vbl1	jsr	musix
	bra	ret_vbl
vbl2	cmp.b	#3,pt_vbl
	bne.s	ret_vbl
	add.b	#1,pt_col_go
	cmp.b	#4,pt_col_go
	bne.s	no_go
	clr.b	pt_col_go
	jsr	col_on
no_go	jsr	musix
ret_vbl	rts

save_all	move.b	$ffff8260.w,rez
	move.b	$ffff8201.w,scr01
	move.b	$ffff8203.w,scr03
	move.b	$ffff820a.w,hertz
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
	lea	$60.w,a0
	lea	vecs,a1
	move.l	#$37,d0
cop_vecs	move.l	(a0)+,(a1)+
	dbf	d0,cop_vecs
       	rts

inter_off	move	#$2700,sr
	lea	vecs,a0
	lea	$60.w,a1
	move.l	#$37,d0
set_vecs	move.l	(a0)+,(a1)+
	dbf	d0,set_vecs
	clr.l	$4d2.w
	clr	$ffff8900.w
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
	move.b	rez,$ffff8260.w
	move.b	hertz,$ffff820a.w
	clr.l	d0
	move.b	scr01,d0
	move.b	d0,$ffff8201.w
	lsl.l	#8,d0
	move.b	scr03,d0
	move.b	d0,$ffff8203.w
	lsl.l	#8,d0
	move.l	d0,a0
	move.l	#40*200-1,d0
effa_scr	clr.l	(a0)+
	dbf	d0,effa_scr
	movem.l	pal,d0-d7
	movem.l	d0-d7,$ffff8240.w
	*move.b	#7,$484.w
	move.w	#$2300,sr
	rts

inter_on	move	#$2700,sr
	and.b	#$fe,$fffffa13.w
	and.b	#$fe,$fffffa0f.w
	and.b	#$fe,$fffffa0b.w
	and.b	#$fe,$fffffa07.w
	clr.b	$fffffa09.w
	move.b 	#8,$fffffa1b.w
	move.b 	#3,$fffffa21.w
	move.l	#new_hbl1,$120.w
	move.l	#vbl0,$4d2.w
	or.b	#1,$fffffa07.w
	or.b	#1,$fffffa13.w
	bclr	#5,$fffffa09.w
	bclr	#4,$fffffa09.w
	bclr	#3,$fffffa17.w
	move.w	#1,$452.w
	move.w	#$2300,sr
	rts

col_on	lea	pic+2,a0
	lea	$ffff8240.w,a1
	moveq	#7,d0
loop_col1	clr.l	d1
	clr.l	d3
	move.w	(a0)+,d1
	move.w	(a1),d3
red	move.l	d1,d2
	move.l	d3,d4
	lsr.w	#8,d2
	and.b	#7,d2
	lsr.w	#8,d4
	and.b	#7,d4
	cmp.b	d2,d4
	bge.s	green
	add	#$100,d3
green	move.l	d1,d2
	move.l	d3,d4
	lsr.b	#4,d2
	and.b	#7,d2
	lsr.b	#4,d4
	and.b	#7,d4
	cmp.b	d2,d4
	bge.s	blue
	add	#$10,d3
blue	move.l	d1,d2
	move.l	d3,d4
	lsl.b	#4,d2
	lsr.b	#4,d2
	and.b	#7,d2
	lsl.b	#4,d4
	lsr.b	#4,d4
	and.b	#7,d4
	cmp.b	d2,d4
	bge.s	col_ct
	add	#1,d3
col_ct	move	d3,(a1)+
	dbf	d0,loop_col1
	add.b	#1,pt_col_on
	cmp.b	#8,pt_col_on
	bne.s	ret_col
	move.b	#1,pt_vbl
ret_col	rts

scrolls	eor.b	#1,pt_pass
	tst.b	pt_pass
	bne	pass_2
pass_1	move.l	let,a0
	lea	1(a0),a1
	bra	pass_cont
	
pass_2	move.l	let,a0
	lea	1(a0),a0
	addq.l	#8,let
	addq.b	#1,pt_let
	cmp.b	#4,pt_let
	bne	no_chg_let
	bsr	test_let
	add.l	#1,pt_text
	move.l	a1,let
	clr.b	pt_let
no_chg_let	move.l	let,a1
	
pass_cont	lea	table1,a2
	add.l	#1,pt_table
	adda.l	pt_table,a2
	clr.l	d0
	move.b	(a2),d0
	cmp.b	#3,d0
	bne	table_ct
table_adr	move.b	table1,d0
	move.l	#1,pt_table
table_ct	add.b	-1(a2),d0
	add.b	#4,d0
	mulu	#$a0,d0
	
	tst.b	pt_scr
	bne	scr_2
scr_1	move.l	adr_scl1,a2
	add.l	d0,adr_scl1
	move.l	adr_scl1,a3
	add.l	#640,adr_scr1
	cmp.l	#$68600,adr_scr1
	bne	ok_scr1
	sub.l	#$7d00,a3
	sub.l	#$7d00,adr_scl1
	sub.l	#$7d00,adr_scr1
ok_scr1	move.l	adr_scr1,adr_scr
	move.b	#1,pt_scr
	bra	hard_ct
scr_2	move.l	adr_scl2,a2
	add.l	d0,adr_scl2
	move.l	adr_scl2,a3
	add.l	#640,adr_scr2
	cmp.l	#$78000,adr_scr2
	ble	ok_scr2
	sub.l	#$7d00,a3
	sub.l	#$7d00,adr_scl2
	sub.l	#$7d00,adr_scr2
ok_scr2	move.l	adr_scr2,adr_scr
	clr.b	pt_scr
hard_ct	move.b	adr_scr+1,$ffff8205.w
	move.b	adr_scr+2,$ffff8207.w
	move.b	adr_scr+3,$ffff8209.w
	
	move.l	#27,d0
cop_aff	move	8+6(a2),6(a3)
	move	16+6(a2),8+6(a3)
	move	24+6(a2),16+6(a3)
	move	32+6(a2),24+6(a3)
	move	40+6(a2),32+6(a3)
	move	48+6(a2),40+6(a3)
	move	56+6(a2),48+6(a3)
	move	64+6(a2),56+6(a3)
	move	72+6(a2),64+6(a3)
	move	80+6(a2),72+6(a3)
	move	88+6(a2),80+6(a3)
	move	96+6(a2),88+6(a3)
	move	104+6(a2),96+6(a3)
	move	112+6(a2),104+6(a3)
	move	120+6(a2),112+6(a3)
	move	128+6(a2),120+6(a3)
	move	136+6(a2),128+6(a3)
	move	144+6(a2),136+6(a3)
	move	152+6(a2),144+6(a3)
	move.b	(a0),152+6(a3)
	move.b	(a1),153+6(a3)
	lea	-160(a3),a3
	lea	-160(a2),a2
	move	8+6(a2),6(a3)
	move	16+6(a2),8+6(a3)
	move	24+6(a2),16+6(a3)
	move	32+6(a2),24+6(a3)
	move	40+6(a2),32+6(a3)
	move	48+6(a2),40+6(a3)
	move	56+6(a2),48+6(a3)
	move	64+6(a2),56+6(a3)
	move	72+6(a2),64+6(a3)
	move	80+6(a2),72+6(a3)
	move	88+6(a2),80+6(a3)
	move	96+6(a2),88+6(a3)
	move	104+6(a2),96+6(a3)
	move	112+6(a2),104+6(a3)
	move	120+6(a2),112+6(a3)
	move	128+6(a2),120+6(a3)
	move	136+6(a2),128+6(a3)
	move	144+6(a2),136+6(a3)
	move	152+6(a2),144+6(a3)
	move.b	(a0),152+6(a3)
	move.b	(a1),153+6(a3)
	lea	-160(a0),a0
	lea	-160(a1),a1
	lea	-160(a2),a2
	lea	-160(a3),a3
	dbra	d0,cop_aff
	move.l	#5,d0
eff_l1	clr	6(a3)
	clr	8+6(a3)
	clr	16+6(a3)
	clr	24+6(a3)
	clr	32+6(a3)
	clr	40+6(a3)
	clr	48+6(a3)
	clr	56+6(a3)
	clr	64+6(a3)
	clr	72+6(a3)
	clr	80+6(a3)
	clr	88+6(a3)
	clr	96+6(a3)
	clr	104+6(a3)
	clr	112+6(a3)
	clr	120+6(a3)
	clr	128+6(a3)
	clr	136+6(a3)
	clr	144+6(a3)
	clr	152+6(a3)
	lea	-160(a3),a3
	dbra	d0,eff_l1
	move.l	adr_scr,a3
	adda.l	#$7a80,a3
	move.l	#3,d0
eff_l2	clr	6(a3)
	clr	8+6(a3)
	clr	16+6(a3)
	clr	24+6(a3)
	clr	32+6(a3)
	clr	40+6(a3)
	clr	48+6(a3)
	clr	56+6(a3)
	clr	64+6(a3)
	clr	72+6(a3)
	clr	80+6(a3)
	clr	88+6(a3)
	clr	96+6(a3)
	clr	104+6(a3)
	clr	112+6(a3)
	clr	120+6(a3)
	clr	128+6(a3)
	clr	136+6(a3)
	clr	144+6(a3)
	clr	152+6(a3)
	lea	160(a3),a3
	dbra	d0,eff_l2
	rts

test_let	clr.l	d0
text_adr	lea	text,a1
	adda.l	pt_text,a1
	move.b	(a1),d0
	tst.b	d0
	bne.s	vbl1_set
	move.l	#blabla,text_adr+2
	clr.l	pt_text
	bra.s	test_let
vbl1_set	cmp.b	#1,d0
	bne.s	vbl2_set
	move.b	#1,pt_vbl
	add.l	#1,pt_text
	bra	test_let
vbl2_set	cmp.b	#2,d0
	bne.s	vbl3_set
	move.l	#table_line+1,table_adr+2
	move.l	#table_line,pass_cont+2
	add.l	#1,pt_text
	bra	test_let
vbl3_set	cmp.b	#3,d0
	bne.s	vbl4_set
	move.b	#2,pt_vbl
	add.l	#1,pt_text
	bra	test_let
vbl4_set	cmp.b	#4,d0
	bne.s	space
	move.b	#3,pt_vbl
	add.l	#1,pt_text
	bra	test_let
space	cmpi.b	#$20,d0
	bne.s	excla
	lea	font+34+160*28*8+32*2,a1
	bra	suite_1
excla	cmpi.b	#$21,d0
	bne.s	inter
	lea	font+34+160*28*7+32*1,a1
	bra	suite_1
inter	cmpi.b	#$3f,d0
	bne.s	dx_pts
	lea	font+34+160*28*8+32*4,a1
	bra	suite_1
dx_pts	cmpi.b	#$3a,d0
	bne.s	virg
	lea	font+34+160*28*8+32*1,a1
	bra	suite_1
virg	cmpi.b	#$2c,d0
	bne.s	par_g
	lea	font+34+160*28*7+32*2,a1
	bra	suite_1
par_g	cmpi.b	#$28,d0
	bne.s	par_d
	lea	font+34+160*28*7+32*4,a1
	bra	suite_1
par_d	cmpi.b	#$29,d0
	bne.s	tiret
	lea	font+34+160*28*8+32*0,a1
	bra	suite_1
tiret	cmpi.b	#$2d,d0
	bne.s	pnt
	lea	font+34+160*28*8+32*3,a1
	bra	suite_1
pnt	cmpi.b	#$2e,d0
	bne.s	guill
	lea	font+34+160*28*7+32*3,a1
	bra	suite_1
guill	cmpi.b	#$27,d0
	bne.s	lettres_1
	lea	font+34+160*28*7+160*17+32*2,a1
	bra	suite_1
lettres_1	cmpi.b	#$41,d0
	blt	chiffres_1
	cmpi.b	#$46,d0
	bge.s	lettres_2
	subi.b	#$41,d0
	mulu	#$20,d0
	lea	font+34+160*28*2,a1
	adda.l	d0,a1
	bra	suite_1
lettres_2	cmpi.b	#$4b,d0
	bge.s	lettres_3
	subi.b	#$46,d0
	mulu	#$20,d0
	lea	font+34+160*28*3,a1
	adda.l	d0,a1
	bra	suite_1
lettres_3	cmpi.b	#$50,d0
	bge.s	lettres_4
	subi.b	#$4b,d0
	mulu	#$20,d0
	lea	font+34+160*28*4,a1
	adda.l	d0,a1
	bra	suite_1	
lettres_4	cmpi.b	#$55,d0
	bge.s	lettres_5
	subi.b	#$50,d0
	mulu	#$20,d0
	lea	font+34+160*28*5,a1
	adda.l	d0,a1
	bra	suite_1	
lettres_5	cmpi.b	#$5a,d0
	bge.s	z
	subi.b	#$55,d0
	mulu	#$20,d0
	lea	font+34+160*28*6,a1
	adda.l	d0,a1
	bra	suite_1	
z	cmpi.b	#$5a,d0
	bne.s	unknow
	lea	font+34+160*28*7,a1
	bra	suite_1
chiffres_1	cmp.b	#$30,d0
	blt	unknow
	cmp.b	#$35,d0
	bge.s	chiffres_2
	subi.b	#$30,d0
	mulu	#$20,d0
	lea	font+34,a1
	adda.l	d0,a1
	bra	suite_1
chiffres_2	cmp.b	#$3a,d0
	bge.s	unknow
	subi.b	#$35,d0
	mulu	#$20,d0
	lea	font+34+160*28,a1
	adda.l	d0,a1
	bra	suite_1
unknow	lea	font+34+160*28*8+32*2,a1
suite_1	lea	160*27(a1),a1
	rts
	
init_muzexx
	LEA	SAVE_INT(PC),A1
	LEA	$FFFF8200.W,A0
	MOVEP	$1(A0),D0
	MOVE	D0,4(A1)
	LEA	SEQ(PC),A0
	LEA	PAT(PC),A1
	LEA	NBR_INS(PC),A2
	LEA	MUZEXX,A3
	MOVE	#$1D8,(A0)
	MOVE	#$258,(A1)
	MOVE	#15,(A2)
	CMP.L	#'M.K.',$438(A3)
	BNE	REAL_DOCs_MODULE
	MOVE	#$3B8,(A0)
	MOVE	#$43C,(A1)
	MOVE	#31,(A2)
REAL_DOCs_MODULE

	LEA	MUZEXX,A0
	ADD	SEQ(PC),A0
	MOVE.L	#$80,D0
	MOVEQ	#0,D1
INIT_MUZEXX1
	MOVE.L	D1,D2
	SUBQ	#1,D0
INIT_MUZEXX2
	MOVE.B	(A0)+,D1
	CMP.B	D2,D1
	BGT.S	INIT_MUZEXX1
	DBF	D0,INIT_MUZEXX2
	ADDQ.B	#1,D2
	SWAP	D2
	LSR.L	#6,D2
	LEA	MUZEXX,A0
	ADD	PAT,A0
	ADD.L	D2,A0
	LEA	20+MUZEXX,A1
	LEA	16+INS,A2
	MOVE	NBR_INS(PC),D0
	SUBQ	#1,D0
INIT_MUZEXX3
	MOVE.L	A0,4(A2)
	MOVEQ	#0,D1
	MOVE	22(A1),D1
	LSL.L	#1,D1
	MOVE.L	D1,(A2)
	ADD.L	D1,A0
	MOVEQ	#0,D1
	MOVE	24(A1),D1
	BEQ	INIT_MUZEXX4
	SUBQ	#1,D1
INIT_MUZEXX4
	MOVE	D1,12(A2)
	MOVEQ	#0,D1
	MOVE	28(A1),D1
	LSL.L	#1,D1
	CMP.L	#2,D1
	BNE	INIT_MUZEXX5
	MOVEQ	#0,D1
INIT_MUZEXX5
	SWAP	D1
	MOVE.L	D1,8(A2)
	LEA	30(A1),A1
	LEA	16(A2),A2
	DBRA	D0,INIT_MUZEXX3

	LEA	16+INS,A0
	MOVEQ	#0,D0
	MOVE	4+SAVE_INT(PC),D0
	LSL.L	#8,D0
	SUB.L	#$8000,D0
	MOVE.L	D0,A2
	MOVE	NBR_INS(PC),D0
	SUBQ	#1,D0
REVERSE
	MOVE.L	(A0),D1
	BEQ	END_REVERSE_THIS_INS
	SUBQ.L	#1,D1
	MOVE.L	D1,D2
	MOVE.L	4(A0),A3
REV_1
	MOVE.B	(A3)+,d5
	add.B	#$80,d5
	LSR.W	#1,d5
	add.b	#$80/2,d5	* Si la musique sature,supprimez
			* cette ligne et ajoutez
			* SUB.B #$80,D4
			* SUB.B #$80,D5  en ligne 523
			* Mais la routine prendra plus
			* de temps
	move.b	d5,(a2)+
	DBRA	D1,REV_1
	MOVE.L	4(A0),A3
REV_2
	MOVE.B	-(A2),(A3)+
	DBRA	D2,REV_2
END_REVERSE_THIS_INS
	LEA	16(A0),A0
	DBRA	D0,REVERSE

	LEA 	MU,A0
	MOVE.W	#2520,D0
CCLR	MOVE.L 	#0,(A0)+
	DBF	D0,CCLR
 	
	MOVE.W	#2,$FF8920   ;sound-mode
		    	  ;00 6250hz
			  ;1  12517hz
			  ;2  25033hz
			  ;3  50066hz
			  ; mono +128 

	LEA	MUSIQUE_END,A0	
	MOVE.L	A0,MFIN
	MOVE.L	A0,D0
	MOVE.W	D0,$FF8912
	ROR.L	#8,D0
	MOVE.W	D0,$FF8910
	ROR.L	#8,D0
	MOVE.W	D0,$FF890E

	LEA	MU,A0
	MOVE.L	A0,SA4
	MOVE.L	A0,MDEB
	MOVE.L	A0,D0
	MOVE.W	D0,$FF8906
	ROR.L	#8,D0
	MOVE.W	D0,$FF8904
	ROR.L	#8,D0
	MOVE.W	D0,$FF8902
	MOVE.L	#$33fc0003,rt
	MOVE.L	#$00ff8900,rt+4
ON	MOVE	#6,SPD+2
	MOVE.B	#6,SPEED
	MOVE.B	#1,POS
	LEA	MUZEXX,A0
	ADD	SEQ(PC),A0
	LEA	-2(A0),A0
	MOVE.B	(A0)+,TRK
	MOVE.L	A0,MUS+2
	LEA	OFF(PC),A0
	LEA	OFF(PC),A1
	LEA	OFF(PC),A2
	LEA	OFF(PC),A3
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	CLR.L	V0+2
	CLR.L	V1+2
	CLR.L	V2+2
	CLR.L	V3+2
	CLR.L	F0+2
	CLR.L	F1+2
	CLR.L	F2+2
	CLR.L	F3+2
	MOVE.W	#20160/4,D0
	LEA	MU,A0
CLRR	MOVE.L	#0,(A0)+
	DBF 	D0,CLRR
	MOVE.W	#$7FF,$FFFF8924
	MOVE.W	#$486,$FFFF8922
	;MOVE.W	#$44A,$FFFF8922
	rts

L0	MOVE.L	#0,D0
F0	MOVE.L	#0,V0+2
	BRA.S	V1
L1	MOVE.L	#0,D1
F1	MOVE.L	#0,V1+2
	BRA.S	V2
L2	MOVE.L	#0,D2
F2	MOVE.L	#0,V2+2
	BRA.S	V3
L3	MOVE.L	#0,D3
F3	MOVE.L	#0,V3+2
	BRA.S	OUT
AMIGA	
	MOVE.L	SA4,A4
;AMM
	MOVEQ	#0,D7
	MOVE.W	#504,D6
AM2
	SWAP	D0					;2 DOUBLE CYCLES	
	SWAP	D1					;2
	SWAP	D2					;2
	SWAP	D3					;2
V0	SUB.L	#0,D0					;8
	BMI.S	L0					;4
V1	SUB.L	#0,D1					;8
	BMI.S	L1					;4
V2	SUB.L	#0,D2					;8
	BMI.S	L2					;4
V3	SUB.L	#0,D3					;8
	BMI.S	L3					;4
OUT	SWAP	D0					;2
	SWAP	D1					;2
	SWAP	D2					;2
	SWAP	D3					;2
	MOVE.B	0(A0,D0),D4				;7
	MOVE.B	0(A2,D2),D5				;7
	ADD.B	0(A1,D1),D4				;7
	ADD.B	0(A3,D3),D5				;7	
 *	La ligne 525 est ici
	MOVE.B	D4,(A4)+			
	MOVE.B	D5,(A4)+
	DBF 	D6,AM2					;5
	CMP.L	MFIN,A4
	BLE	AM5
	MOVE.L	MDEB,A4	
AM5	MOVE.L 	A4,SA4
rt	MOVE.W 	#3,$FF8900
	MOVE.W	#$4E75,rt	* ceci evite le bug durant
			* les 6 premieres minutes
	RTS

SA4	DC.L	0
MDEB	DC.L	0
MFIN	DC.L	0

musix	MOVEM.L	D0-D7/A0-A6,-(A7)
	MOVEM.L	REGIS,D0-D6/A0-A6
	JSR	AMIGA
	SUBQ.B	#1,SPEED
	BEQ.S	PLAY
	JSR	EFFECT
END_VBL
	MOVEM.L	D0-D6/A0-A6,REGIS
	MOVEM.L	(A7)+,D0-D7/A0-A6
	RTS

PLAY
NO_KEYBOARD1
	MOVEM.L	D0-D1/A0-A5,-(SP)
SPD	MOVE.B	#6,SPEED
	SUBQ.B	#1,POS
	BNE	NO_NEW_PATTERN
	MOVE.B	#64,POS
	ADDQ.L	#1,MUS+2
	SUBQ.B	#1,TRK
	BMI	RESTART
	MOVEQ	#0,D0
MUS	MOVE.B	$0,D0
	SWAP	D0
	LSR.L	#6,D0
	LEA	MUZEXX,A0
	ADD	PAT(PC),A0
	ADD.L	D0,A0
	MOVE.L	A0,ADD_IN_PAT
NO_NEW_PATTERN
	MOVE.L	ADD_IN_PAT(PC),A0
	LEA	FRQ,A1
	LEA	INS,A2
	LEA	COMMAND(PC),A3
	LEA	VOICE0(PC),A4
	BSR	LOAD_VOICE
	LEA	VOICE1(PC),A4
	BSR	LOAD_VOICE
	LEA	VOICE2(PC),A4
	BSR	LOAD_VOICE
	LEA	VOICE3(PC),A4
	BSR	LOAD_VOICE
	MOVE.L	A0,ADD_IN_PAT
	MOVEM.L	(SP)+,D0-D1/A0-A5
* ADDRESS ALL 4 VOICES
	MOVEM.L	D4/A5,-(SP)
	LEA	VOICE0(PC),A5
	TST.B	20(A5)
	BEQ.S	CONT0
	MOVE.L	(A5),D0
	MOVE.L	4(A5),A0
	MOVE.L	8(A5),D4
	MOVE.L	D4,L0+2
	MOVE.L	12(A5),D4
	MOVE.L	D4,V0+2
	MOVE.L	16(A5),D4
	MOVE.L	D4,F0+2
CONT0
	CLR.B	20(A5)
	LEA	VOICE1(PC),A5
	TST.B	20(A5)
	BEQ.S	CONT1
	MOVE.L	(A5),D1
	MOVE.L	4(A5),A1
	MOVE.L	8(A5),D4
	MOVE.L	D4,L1+2
	MOVE.L	12(A5),D4
	MOVE.L	D4,V1+2
	MOVE.L	16(A5),D4
	MOVE.L	D4,F1+2
CONT1
	CLR.B	20(A5)
	LEA	VOICE2(PC),A5
	TST.B	20(A5)
	BEQ.S	CONT2
	MOVE.L	(A5),D2
	MOVE.L	4(A5),A2
	MOVE.L	8(A5),D4
	MOVE.L	D4,L2+2
	MOVE.L	12(A5),D4
	MOVE.L	D4,V2+2
	MOVE.L	16(A5),D4
	MOVE.L	D4,F2+2
CONT2
	CLR.B	20(A5)
	LEA	VOICE3(PC),A5
	TST.B	20(A5)
	BEQ.S	CONT3
	MOVE.L	(A5),D3
	MOVE.L	4(A5),A3
	MOVE.L	8(A5),D4
	MOVE.L	D4,L3+2
	MOVE.L	12(A5),D4
	MOVE.L	D4,V3+2
	MOVE.L	16(A5),D4
	MOVE.L	D4,F3+2
CONT3
	CLR.B	20(A5)
	MOVEM.L	(SP)+,D4/A5
	BRA	END_VBL

LOAD_VOICE
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVE	D0,30(A4)
	MOVE	(A0)+,D0
	BEQ.S	COMMAND?
	BTST	#12,D0
	BEQ.S	CONT_FRQ
	AND	#$FFF,D0
	MOVE	#$100,D1
CONT_FRQ
	MOVE.B	#1,20(A4)
	MOVE	D0,24(A4)
	ADD	D0,D0
	ADD	D0,D0		; d0=frequence
	MOVE.L	(A1,D0.W),D0
	MOVE.L	D0,12(A4)
	TST.L	16(A4)
	BEQ.S	CONT_LOAD_FRQ
	MOVE.L	D0,16(A4)
CONT_LOAD_FRQ
	OR.B	(A0),D1
	AND	#$FF0,D1	; d1=numero de l'instrument
	BEQ.S	COMMAND?
	MOVE.L	12(A4),16(A4)
	MOVE.L	0(A2,D1.W),(A4)
	MOVE.L	4(A2,D1.W),4(A4)
	MOVE.L	8(A2,D1.W),8(A4)
	BNE.S	REPEAT
	CLR.L	16(A4)
REPEAT
COMMAND?
	MOVE	(A0)+,D0
	MOVE.B	d0,D1
	AND	#$F00,D0
	LSR	#6,D0
	MOVE.L	(A3,D0.W),A5
	JMP	(A5)

NO_COMMAND
	RTS

ARPEGGIO
	TST.B	D1
	BEQ.S	NO_ARPEGGIO
	MOVE.B	#0,22(A4)
	MOVE.B	D1,23(A4)
	MOVE.B	#1,21(A4)		*ARPEGGIO COUNTER
	MOVE	#1,30(A4)
NO_ARPEGGIO
	RTS

PORTAMENTO_UP
	MOVE.B	#1,22(A4)
	MOVE.B	D1,23(A4)
	MOVE	#1,30(A4)
	RTS

PORTAMENTO_DOWN
	MOVE.B	#2,22(A4)
	MOVE.B	D1,23(A4)
	MOVE	#1,30(A4)
	RTS

POSITION_JUMP
	LEA	MUZEXX,A5
	ADD	SEQ(PC),A5
	LEA	-1(A5),A5
	MOVE.B	#1,POS
	MOVE.L	A5,D0
	ADD.L	D1,D0
	MOVE.L	D0,MUS+2
	MOVE.B	-1(A5),D0
	SUB	D1,D0
	MOVE.B	D0,TRK
	RTS

SET_VOLUME
	TST.B	D1
	BNE.S	NO_CHANGE			*NO REAL TIME VOLUME VARIATION
	CLR.L	12(A4)				*IN THIS VERSION! MAYBE
	MOVE.B	#1,20(A4)			*SOME OTHER DAY...
NO_CHANGE
	RTS

PATTERN_BREAK
	MOVE.B	#1,POS
	RTS

SET_FILTER
	RTS

SET_SPEED
	MOVE.B	D1,SPD+3
	MOVE.B	D1,SPEED
	RTS

COMMAND	DC.L	ARPEGGIO,PORTAMENTO_UP,PORTAMENTO_DOWN,NO_COMMAND
	DC.L	NO_COMMAND,NO_COMMAND,NO_COMMAND,NO_COMMAND
	DC.L	NO_COMMAND,NO_COMMAND,NO_COMMAND,POSITION_JUMP
	DC.L	SET_VOLUME,PATTERN_BREAK,SET_FILTER,SET_SPEED

EFFECT
	MOVEM.L	D4-D6/A4-A6,-(SP)
	LEA	FRQ,A5
	LEA	VOICE0(PC),A6
	TST	30(A6)
	BEQ.S	CONT_EFFECT1
	BSR	DO_EFFECT
	MOVE.L	26(A6),V0+2
	TST.L	F0+2
	BEQ.S	CONT_EFFECT1
	MOVE.L	26(A6),F0+2
CONT_EFFECT1
	LEA	VOICE1(PC),A6
	TST	30(A6)
	BEQ.S	CONT_EFFECT2
	BSR	DO_EFFECT
	MOVE.L	26(A6),V1+2
	TST.L	F1+2
	BEQ.S	CONT_EFFECT2
	MOVE.L	26(A6),F1+2
CONT_EFFECT2
	LEA	VOICE2(PC),A6
	TST	30(A6)
	BEQ.S	CONT_EFFECT3
	BSR	DO_EFFECT
	MOVE.L	26(A6),V2+2
	TST.L	F2+2
	BEQ.S	CONT_EFFECT3
	MOVE.L	26(A6),F2+2
CONT_EFFECT3
	LEA	VOICE3(PC),A6
	TST	30(A6)
	BEQ.S	CONT_EFFECT4
	BSR	DO_EFFECT
	MOVE.L	26(A6),V3+2
	TST.L	F3+2
	BEQ.S	CONT_EFFECT4
	MOVE.L	26(A6),F3+2
CONT_EFFECT4
	MOVEM.L	(SP)+,D4-D6/A4-A6
	RTS

DO_EFFECT
	MOVE.B	22(A6),D4
	BEQ.S	ARPEGGIO_ROUT
	CMP.B	#1,D4
	BEQ.S	PORTUP
	CMP.B	#2,D4
	BEQ.S	PORTDOWN
	RTS

PORTUP
	MOVEQ	#0,D4
	MOVE.B	23(A6),D4
	MOVE	24(A6),D5
	SUB	D4,D5
	CMP	#$71,D5
	BPL.S	OK_PORTUP
	MOVEQ	#$71,D5
OK_PORTUP
	MOVE	D5,24(A6)
	ADD	D5,D5
	ADD	D5,D5
	MOVE.L	(A5,D5),26(A6)
	RTS

PORTDOWN
	MOVEQ	#0,D4
	MOVE.B	23(A6),D4
	MOVE	24(A6),D5
	ADD	D4,D5
	CMP	#$358,D5
	BMI.S	OK_PORTDOWN
	MOVE	#$358,D5
OK_PORTDOWN
	MOVE	D5,24(A6)
	ADD	D5,D5
	ADD	D5,D5
	MOVE.L	(A5,D5),26(A6)
	RTS

ARPEGGIO_ROUT
	MOVE.B	21(A6),D4
	CMP.B	#1,D4
	BEQ.S	ARP_ROUT1
	CMP.B	#2,D4
	BEQ.S	ARP_ROUT2
	CMP.B	#3,D4
	BEQ.S	ARP_ROUT3
	CMP.B	#4,D4
	BEQ.S	ARP_ROUT1
	CMP.B	#5,D4
	BEQ.S	ARP_ROUT2
	RTS

ARP_ROUT1
	MOVEQ	#0,D4
	MOVE.B	23(A6),D4
	LSR.B	#4,D4
	BRA.S	ARP_ROUT
ARP_ROUT2
	MOVEQ	#0,D4
	MOVE.B	23(A6),D4
	AND.B	#$0F,D4
	BRA.S	ARP_ROUT
ARP_ROUT3
	MOVE	24(A6),D6
	BRA.S	END_ARP_ROUT2
ARP_ROUT
	ADD	D4,D4
	MOVE	24(A6),D5
	LEA	ARPEGGIO_DATA(PC),A4
ARP_LOOP
	CMP	(A4),D5
	BEQ.S	END_ARP_ROUT1
	LEA	2(A4),A4
	BRA.S	ARP_LOOP
END_ARP_ROUT1
	MOVE	(A4,D4),D6
END_ARP_ROUT2
	ADD	D6,D6
	ADD	D6,D6
	MOVE.L	(A5,D6),26(A6)
	ADDQ.B	#1,21(A6)
	RTS

RESTART
	MOVEM.L	(SP)+,D0-D1/A0-A5
	MOVE	#6,SPD+2 
	MOVE.B	#6,SPEED
	MOVE.B	#1,POS
	LEA	MUZEXX,A0
	ADD	SEQ,A0
	LEA	-2(A0),A0
	MOVE.B	(A0)+,TRK
	MOVE.L	A0,MUS+2
	LEA	OFF,A0
	LEA	OFF,A1
	LEA	OFF,A2
	LEA	OFF,A3
	MOVEQ	#0,D0
	MOVEQ	#0,D1
	MOVEQ	#0,D2
	MOVEQ	#0,D3
	CLR.L	V0+2
	CLR.L	V1+2
	CLR.L	V2+2
	CLR.L	V3+2
	CLR.L	F0+2
	CLR.L	F1+2
	CLR.L	F2+2
	CLR.L	F3+2
	BRA	PLAY

	even
buf_col	rept	2
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
text	dc.b	"  YO FANS !!! HERE YOU SEE THE FUZION'S STE SOUNDTRACK SCREEN !!!     IF YOU THINK THAT'S ALL YOU ARE WRONG ... LET'S MOVE UP AND DOWN ...     ",2
	DC.B	"  AND NOW .... WOULD YOU LIKE SOME COLORS ??? READY ... LET'S GO !!!     ",3
	DC.B	"  NICE RASTERS BUT I DON'T HEAR THE ZIKMU !!!    SO PUMP UP THE VOLUME OF YOUR HIFI SYSTEM !!!!!!          ",1
	DC.B	"  NICE SOUND ....   STEREO , 25 KHZ , AND WITHOUT ANY BUGS !! ( THANX TO AXEL F. FOR THE ROUT. )    SORRY BUT WE CAN'T DO ANYTHING OTHER ....  BYE .... LET'S WRAP !!! "
	DC.B	"                    DON'T WORRY , THAT'S NOT ALL !!!!!!   I THINK YOU'LL BE SURPRISED ...   WAIT AND SEE...      MEGA ",4,"HARD SCROLL !!!   "    
blabla	DC.B	" WELL ... THIS SCREEN WAS CODED BY ORION IN ONE NIGHT ... THE GFX WAS DONE BY SQUAT AND THE MUZIX WAS RIPPED FROM THE GAME 'IMPOSSAMOL' ... GREAT MUZAK MIXED BY BEN DAGLISH  "
	DC.B	"   NOW , SOME WORDS ABOUT FUZION ...  WE HAVE LEAVED THE TSG ALLIANCE ( THE STRANGLERS... ) ....   WE ARE NOW INDEPENDANT ... AND IT'S BETTER ...      "
	DC.B       "   THIS SCREEN IS NOT AS MERVELLOUS AS A TCB OR TLB SCREEN .... BUT WE ARE A RECENT CREW , OUR CODERS HAVEN'T REALLY TIME TO CODE , AND OUR PRINCIPAL OCCUPATION IS TO COMPACT GAMES TO DO SOME GREAT COMPILATIONS .... "
	DC.B       "  FROM SOMEWHERE ELSE YOU CAN CONSULT OUR LIST OF COMPILATIONS ON RTEL BAL CD1 , CD2 , CD3 .... AND YOU CAN CONTACT US ON CLUB FUZION PASS FUZION ....   ELSE , WE CRACK TOO ... BECAUSE WE HAVE A NEW CRACKER .....  "
	DC.B       "    NOW, THE LIST OF OUR MEMBERS....   ORION ( CODER, CRACKER AND CD ) , FULCRUM ( SWAPPER, CD AND SOME GFX ) , SQUAT ( GREAT GRAPHIX MAN ) , KASAR ( CODER FROM OUR SOUTH-EAST SECTION ) , KELVIN ( MEGA FILES CRACKER ) , THE"
	DC.B       " DRAGON ( SWAPPER AND CD ) , DOCNO ( SWAPPER ) , SPEEDER ( CODER AND SLEEPER ) .............  "
           DC.B       "     HUMMMMMM   WE WOULD LIKE TO THANKS THE CREW ' NEXT ', ESPECIALY MIT AND PULSAR .... WHO HAVE USED THIS SCREEN IN THEIR GIGA ' PHALEON ' DEMO ...... WHICH IS AN EXELLENT DEMO... I THINK..."
           DC.B	"     SOME HI TO :  THE REPLICANTS ( MAXI... MES 10 DISCS !!!, NTM ( WHO CAN DIE NOW !! ), ILLEGAL AND ST-WAIKIKI ), MINUTE MAN , MAD VISION ( SPEE TRUIE...), RMA ( THANKS SYNAPS AND SNIPPER ),"
	DC.B       " THE GUILD ( CHAMOUSSSE, BOULBOOT, SONY, SKYLINE, HELLRIZER... ), HMD ( A SCREEN FOR YOUR DEMO ? ), LEGACY ( FURY AND VICKERS ),  MASTERS ( SKAVEN ), ZARATHUSTRA ( AND HIS EXELLENT TT ), RIPPED OFF ( STICK ... ), "
	DC.B	" TITANIUM ( STF62 DIT LA FOUINE ), EMPIRE ( TEC, DEMONIARK... SORRY REGLIS, AIRWOLF ), FRAISINE, VMAX ( ICE AND TST-DO ), GUDUL, ARTHUR VON B., ALTAIR, MAXXOUT, ESC ( ACB, TSB, BAD BOYS ), BLUE-NAZ,"
	DC.B	" ST-CNX ( SIMPA VOTRE RUBRIQUE DANS STMAG ), OVR ( ADSO ET TOUS LES AUTRES ), LAP, MCS ( AXEL F. ), DMA ( JINKS ), BWK ( SERGENT ), PENDRAGONS ( FX ), MACDOS, TST, STRIDER, FASHION, MADNESS, TBC, PHENIX ( OXYGINETTE AND MR40 ), "
	DC.B       " AND COUGAR ( WHO DRIVES US AND COOKS SOME MODULES )...   "
	DC.B	" GREETINGS TO TLB ( SAMMY JOE ), AUTOMATION, FOF, INNER CIRCLE ( COUNT ZERO... ), ENGLISH CORPORATION ( ZIPPY, ...) AND GERMANIC ALLIANCE ( BMT... )....... "
	DC.B	" LITTLE FUCK TO FREDDY ( LE ROI DU KARIBOOW, ON S'EST BIEN FOUTU DE TOI A BETHUNE...  ), HEAVY KILLERS ( PULFION... EXOSTAR ON THE DWARFS LAND... LAMERS!!!! ), ZUUL ( ET VOS RUMEURS A LA CON... ), PHANTASM (  RIPPERS OF BOOT )"
	DC.B       "      YOU CAN WRITE TO:     FUZION     B.P. 5 1 0 9 9  PIRAE   ILE DE TAHITI   POLYNESIE FRANCAISE   ( THANKS PARANOIDS )    BYE ..... FULCRUM AND ORION 1991 ..........                               ",0
	
	even
pt_pass	dc.b	0
pt_let	dc.b	3
	even
adr_scr1	dc.l	$60680
adr_scr2	dc.l	$701c0
adr_scr	dc.l	0
adr_scl1	dc.l	$60680+160*130
adr_scl2	dc.l	$701c0+160*130
pt_table	dc.l	0
pt_scr	dc.l	1
pt_text	dc.l	0
let	dc.l	font+34+160*28*8+32*2
table_line	dc.b	0
	rept	52
	dc.b	1
	endr
	rept	10
	dc.b	0
	endr
	rept	104
	dc.b	-1
	endr
	rept	10
	dc.b	0
	endr
	rept	52
	dc.b	1
	endr
	dc.b	3
	even
table1	dc.b	0,0,3
	even
OFF	DC.L	0
SPEED	DC.B	0
POS	DC.B	0
TRK	DC.B	0
	even
ARPEGGIO_DATA DC.W	$0358,$0328,$02FA,$02D0,$02A6,$0280,$025C
	DC.W	$023A,$021A,$01FC,$01E0,$01C5,$01AC,$0194,$017D
	DC.W	$0168,$0153,$0140,$012E,$011D,$010D,$00FE,$00F0
	DC.W	$00E2,$00D6,$00CA,$00BE,$00B4,$00AA,$00A0,$0097
	DC.W	$008F,$0087,$007F,$0078,$0071,$0000,$0000,$0000
	even
pt_vbl	ds.b	1
pt_col_on	ds.b	1
pt_col_go	ds.b	1
	even
pile	ds.l	$80
rez	ds.b	1
hertz	ds.b	1
scr01	ds.b	1
scr03	ds.b	1
	even
reg_fin	ds.l	2
cpt_fin	ds.w	1
pal	ds.w	16
mfp	ds.b	20
	even
vecs	ds.l	38
regs	ds.l	16
	even
SEQ	DS.W	1
PAT	DS.W	1
NBR_INS	DS.W	1
SAVE_INT	DS.L	17
VOICE0	DS.L	8
VOICE1	DS.L	8
VOICE2	DS.L	8
VOICE3	DS.L	8
ADD_IN_PAT	DS.L	1
REGIS	DS.L	14
INS	DS.L	32*4
MU	DS.W	504*50
MUSIQUE_END ds.l	10
	even
MUZEXX	INCBIN	'\orion.src\fuzion.dem\phaleon\imposaml.MOD',0
	even
FRQ	incbin 	'\orion.src\fuzion.dem\phaleon\25_khz.frq',0
	even
font	incbin	'\orion.src\fuzion.dem\phaleon\font.pi1',0
	even
pic	incbin	'\orion.src\fuzion.dem\phaleon\serpent.pi1',0
	even
stf_mes	incbin	'\orion.src\fuzion.dem\phaleon\stf_mes.pi1',0
	
	end
