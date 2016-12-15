	*************************************
	* Intro      2 Scrolls              *
	* Coder      ORION from FUZION      *
	* Usage      FUZION Compact Disks   *
	* Date       Spring 1990 - CD#5     *
	*                                   *
	* Machine    Atari STE - 1MB RAM    *	
	* TOS        1.62                   *
	* Assembler  GenST v2.09            *
	* Emulator   Steem v3.2             *
	*                                   *
	* Contact    Orion.Fuzion@gmail.com *
	*************************************

	clr.l	-(sp)
	move.W	#$20,-(sp)
	trap	#1
	addq.l	#6,sp
	
	move.w	#$222,$ff8240
	dc.w	$a00a
	clr.b	$fffa09
	move.b	#6,$484
	
	move.w	#2,-(sp)
	trap	#14
	addq.l	#2,sp	
	move.l	d0,adr1
	add.w	#177*160,d0
	move.l	d0,adr2
	sub.w	#176*160,d0
	move.l	d0,adr3
	sub.w	#160+$8000,d0
	move.l	d0,adr4
	
	clr.l	$24
	clr.l	$10
	clr.w	-(sp)
	move.l	adr1,-(sp)
	move.l	adr1,-(sp)
	move.w	#5,-(sp)	
	trap	#14
	lea	$c(sp),sp

	lea	image(pc),a0
	move.l	a0,-(sp)
	lea	$22(a0),a0
	move.l	adr4,a1
	move.l	a0,a2
	add.l	#182*160,a2
cp	move.l	(a0)+,(a1)+
	clr.b	$fffa09
	cmp.l	a0,a2
	bge	cp
	move.l	(sp)+,a0
	movem.l	2(a0),d0-d7
	movem.l	d0-d7,$ff8240
	
	moveq 	#0,d0		
	jsr	music
	move.l	#test2,$4d2
	
	bclr 	#4,$fffa09
	bclr 	#5,$fffa09
	bclr 	#0,$fffa13
	bclr 	#0,$fffa0f
	bclr 	#0,$fffa0b
	bclr 	#0,$fffa07	

	pea rout(pc)
	move	#1,-(a7)
	move	#8,-(a7)
	move	#1,-(a7)
	move	#$1f,-(a7)
	trap 	#14
	lea 	12(a7),a7

	bset 	#0,$fffa13
	move.l	#test3,$4e2	

effet	moveq	#1,d6
slide1	move.l	adr1,a2
	move.l	a2,a3
	add.l	#$3de0,a2
	add.l	#$3e80,a3
	move.l	a2,a0
	move.l	a3,a1
	sub.l	#$7fd0+48,a0
	sub.l	#$7fd0+48,a1
	moveq	#$63,d7
	addq.w	#1,d6
	cmpi.w	#$64,d6
	bhi	att
	moveq	#$32,d5
slide2	add.w	d6,d5
	cmpi.w	#$64,d5
	bcs.s	spreader
	subi.w	#$64,d5
	movem.l	a0-a3,-(sp)
	moveq	#9,d0
aff	move.l	(a0)+,(a2)+
	move.l	(a0)+,(a2)+
	move.l	(a0)+,(a2)+
	move.l	(a0)+,(a2)+
	move.l	(a1)+,(a3)+
	move.l	(a1)+,(a3)+
	move.l	(a1)+,(a3)+
	move.l	(a1)+,(a3)+
	dbra	d0,aff
	movem.l	(sp)+,a0-a3
	sub.l	#$a0,a2
	add.l	#$a0,a3
spreader	sub.l	#$a0,a0
	add.l	#$a0,a1
	dbra	d7,slide2
	move.w	#$25,-(sp)
	trap	#14
	lea	2(sp),sp
	bra	slide1

att	
	move.b	$fffc02,d0
	cmp.b	#$3b,d0
	beq	end
	cmp.b	#$3c,d0
	beq	end
	cmp.b	#$3d,d0
	beq	end
	cmp.b	#$3e,d0
	beq	end
	jsr	scroll2
	jsr	scroll1
	move.w	#37,-(sp)
	trap	#14
	addq.l	#2,sp	
	jmp	att
end	
	move.b	d0,$40000
	
	clr.l	$4d2
	clr.l	$4e2
	move	#8,-(sp)
	move	#$1a,-(sp)
	trap	#14
	addq.l	#4,sp
	
	lea	$ff8800,a0
	move.l	#$08080000,(a0)
	move.l	#$09090000,(a0)
	move.l	#$0a0a0000,(a0)
	
	move.b	#15,$484
	move.b	#$64,$fffa09
	
	pea	text3
	move.w	#9,-(sp)
	trap	#1
	addq.l	#6,sp
	
	move.w	#$777,$ff8244
	move.w	#$888,nbr
cont1	sub.w	#$111,nbr
	move.w	nbr,$ff8240
	cmp.w	#$000,nbr
	beq	cont2
	rept	5
	move.w	#37,-(sp)
	trap	#14
	addq.l	#2,sp
	endr	
	jmp	cont1
cont2 	
 	clr.l -(sp)
 	trap #1
test1
	cmp.b	#$0,$fffa09
	beq	ok
	clr.l	$24
	clr.l	$10
	clr.b	$fffa09
	pea	text4
	move.w	#9,-(a7)
	trap	#1
	addq.l	#6,sp
	move.w	#$000,$ff8240
	move.w	#$777,$ff8242
fuck	jmp	fuck
ok	rts
test2	
	jsr	test1
	move.l	#music+$60,$4d2
	rts
test3
	jsr	test1
	move.l	#color,$4e2
	bset	#0,$fffa07
	bsr	color
	rts
color	
	movem.l	a0-a1,-(a7)
	movem.l	d0/a0,-(sp)
	move	pos,d0
	move.l	#degrade,a0
	mulu	#2,d0
	lea	scr,a2
	add.l	d0,a2
	rept	199
	move	(a0)+,(a2)+
	endr
	movem.l	(sp)+,d0/a0
	lea	scr,a0
	move.l	a0,pointeur
	movem.l	(sp)+,a0-a1
	rts
rout
	jsr	test1
	move.l	a0,-(a7)
	move.l	pointeur,a0
	move.w	(a0),$ff8250
	addq.l	#2,pointeur
	cmp.l	#fin,pointeur
	bne	cont
	move.l	#scr,pointeur
cont
	bclr	#0,$fffa0f	
	move.l	(a7)+,a0
	rte
		
scroll1	MOVE.W 	#0,D0
 	BNE	scrol3
 	MOVE.W 	#16,scroll1+2
scpek2	MOVE.B 	ascci,D0
 	BNE 	scrol4
 	MOVE.L 	#ascci-1,scpek2+2
 	MOVEQ 	#32,D0
scrol4	ADDQ.L 	#1,scpek2+2
 	SUB.B 	#32,D0
 	LSL.W 	#5,D0
 	LEA 	font,A0
 	ADD.W 	D0,A0
 	LEA 	buff+40,A1
 	MOVEM.W 	(A0)+,D0-D7
 	MOVE.W 	D0,(A1)
 	MOVE.W 	D1,42(A1)
 	MOVE.W 	D2,84(A1)
 	MOVE.W 	D3,126(A1)
 	MOVE.W 	D4,168(A1)
 	MOVE.W 	D5,210(A1)
 	MOVE.W 	D6,252(A1)
 	MOVE.W 	D7,294(A1)
 	MOVEM.W 	(A0)+,D0-D7
 	MOVE.W 	D0,336(A1)
 	MOVE.W 	D1,378(A1)
 	MOVE.W 	D2,420(A1)
 	MOVE.W 	D3,462(A1)
 	MOVE.W 	D4,504(A1)
 	MOVE.W 	D5,546(A1)
 	MOVE.W 	D6,588(A1)
 	MOVE.W 	D7,630(A1)
scrol3	SUBQ.W 	#1,scroll1+2
 	LEA 	buff+42,A0
 	MOVEQ 	#84,D0
 	MOVEQ 	#16,D1
scrol2	MOVE 	#0,CCR
	ROXL.W 	-(A0)
 	ROXL.W 	-(A0)
 	ROXL.W 	-(A0)
 	ROXL.W 	-(A0)
 	ROXL.W 	-(A0)
	ROXL.W 	-(A0)
 	ROXL.W 	-(A0)
 	ROXL.W 	-(A0)
 	ROXL.W 	-(A0)
 	ROXL.W 	-(A0)
 	ROXL.W 	-(A0)
 	ROXL.W 	-(A0)
 	ROXL.W 	-(A0)
 	ROXL.W 	-(A0)
 	ROXL.W 	-(A0)
 	ROXL.W 	-(A0)
 	ROXL.W 	-(A0)
 	ROXL.W 	-(A0)
 	ROXL.W 	-(A0)
 	ROXL.W 	-(A0)
 	ROXL.W 	-(A0)
 	ADD.W 	D0,A0
 	DBRA 	D1,scrol2
	move.l	adr2,a6
 	MOVE.L 	A6,A1
scpek3	LEA 	wobtab,A2
 	LEA 	buff,A0
 	MOVEQ 	#0,D3
 	MOVEQ 	#6,D2
 	MOVEQ 	#19,D0
scrol1	MOVE.L 	A6,A1
 	ADD.W 	(A2)+,A1
 	ADD.W 	D2,A1
 	MOVE.B 	D3,-320(A1)
 	MOVE.B 	D3,-160(A1)
 	MOVE.B 	(A0),(A1)
 	MOVE.B 	42(A0),160(A1)
 	MOVE.B 	84(A0),320(A1)
 	MOVE.B 	126(A0),480(A1)
 	MOVE.B 	168(A0),640(A1)
 	MOVE.B 	210(A0),800(A1)
 	MOVE.B 	252(A0),960(A1)
 	MOVE.B 	294(A0),1120(A1)
 	MOVE.B 	336(A0),1280(A1)
 	MOVE.B 	378(A0),1440(A1)
 	MOVE.B 	420(A0),1600(A1)
 	MOVE.B 	462(A0),1760(A1)
 	MOVE.B 	504(A0),1920(A1)
 	MOVE.B 	546(A0),2080(A1)
 	MOVE.B 	588(A0),2240(A1)
 	MOVE.B 	630(A0),2400(A1)
 	MOVE.B 	D3,2560(A1)
 	MOVE.B 	D3,2720(A1)
 	ADDQ.W 	#1,D2
 	MOVE.L 	A6,A1
 	ADD.W 	(A2)+,A1
 	ADD.W 	D2,A1
 	ADDQ.W 	#1,A0
 	MOVE.B 	D3,-320(A1)
 	MOVE.B 	D3,-160(A1)
 	MOVE.B 	(A0),(A1)
 	MOVE.B 	42(A0),160(A1)
	MOVE.B 	84(A0),320(A1)
 	MOVE.B 	126(A0),480(A1)
 	MOVE.B 	168(A0),640(A1)
 	MOVE.B 	210(A0),800(A1)
 	MOVE.B 	252(A0),960(A1)
 	MOVE.B 	294(A0),1120(A1)
 	MOVE.B 	336(A0),1280(A1)
 	MOVE.B 	378(A0),1440(A1)
 	MOVE.B 	420(A0),1600(A1)
 	MOVE.B 	462(A0),1760(A1)
 	MOVE.B 	504(A0),1920(A1)
 	MOVE.B 	546(A0),2080(A1)
 	MOVE.B 	588(A0),2240(A1)
 	MOVE.B 	630(A0),2400(A1)
 	MOVE.B 	D3,2560(A1)
 	MOVE.B 	D3,2720(A1)
 	ADDQ.W 	#1,A0
	ADDQ.W 	#7,D2
 	DBRA 	D0,scrol1
	CMP.L 	#wobtab+960,scpek3+2
 	BNE 	scrol5
	MOVE.L 	#wobtab-2,scpek3+2
scrol5	ADDQ.L 	#2,scpek3+2
 	RTS

scroll2	cmp.w	#16,pt1_2
	blt.s	scrl2
	clr.w	pt1_2
	moveq	#0,d0
set_t2	move.l	pt_txt_2,a0
	move.b	(a0),d0
	bpl.s	new_t2
	move.l	#text_2,pt_txt_2
	bra.s	set_t2
new_t2	addq.l	#1,pt_txt_2
	cmp.w	#8,d0
	bgt.s	decal2
	move.w	d0,ptb
	bra.s	set_t2
decal2	sub.b	#$20,d0
	asl.w	#5,d0
	lea	font,a0
	add.l	d0,a0
	lea	buffer2_2,a1
	move.l	(a0),(a1)
	move.l	4(a0),4(a1)
	move.l	8(a0),8(a1)
	move.l	$c(a0),$c(a1)
	move.l	$10(a0),$10(a1)
	move.l	$14(a0),$14(a1)
	move.l	$18(a0),$18(a1)
	move.l	$1c(a0),$1c(a1)
scrl2	move.l	adr3,a0
	lea	buffer2_2,a1
	moveq	#16,d0
	move.w	ptb,pt2
	subq.w	#1,pt2
rox_all2	move.w	pt2,d1
rx_part2	roxl	(a1)
	roxl	$9e(a0)
	roxl	$96(a0)
	roxl	$8e(a0)
	roxl	$86(a0)
	roxl	$7e(a0)
	roxl	$76(a0)
	roxl	$6e(a0)
	roxl	$66(a0)
	roxl	$5e(a0)
	roxl	$56(a0)
	roxl	$4e(a0)
	roxl	$46(a0)
	roxl	$3e(a0)
	roxl	$36(a0)
	roxl	$2e(a0)
	roxl	$26(a0)
	roxl	$1e(a0)
	roxl	$16(a0)
	roxl	$e(a0)
	roxl	6(a0)
	dbra	d1,rx_part2
	lea	2(a1),a1
	lea	160(a0),a0
	dbra	d0,rox_all2
	move.w	ptb,d0
	add.w	d0,pt1_2
	rts

ascci	dc.b	" HI GUYS !!! ORION FROM FUZION PROUDLY PRESENTS HIS NEW INTRO !!!          ",0
wobtab	ds.l	1
table1	incbin	\orion.src\fuzion.cd\2scrolls\wob_4
	ds.l	1
buff	ds.l	512
ptb	dc.w	$2
pt1_2	ds.w	1
pt2	dc.w	1
pt_txt_2	dc.l	text_2
text_2	DC.B	"          - DARKLIGHT -                     - ORION -                     - THE DRAGON -                     "
	dc.b	"- FULCRUM -                     - KHEOPS -                     - DOCTOR NO -           "
	dc.b	$ff 
buffer2_2	ds.l	256
degrade	dc.w	$707,$717,$727,$737,$747,$757,$767,$777
	dc.w	$767,$757,$747,$737,$727,$717,$707
	rept	163
	dc.w	$321
	endr
	dc.w	$030,$040,$050,$060,$070
	dc.w	$171,$272,$373,$474,$575,$676
	dc.w	$575,$474,$373,$272,$171,$070
	dc.w	$060,$050,$040,$030
pos	dc.w	0
nbr	ds.w	1
scr	ds.w	200
adr1	ds.l	1
adr2	ds.l	1
adr3	ds.l	1
adr4	ds.l	1
pointeur	dc.l	scr	
fin
text3	dc.b	27,"E",27,"b",2,27,"Y",44,45,"Please wait ...",27,"b",1,0
text4	dc.b	27,"E",27,"b",1,27,"Y",44,42,"GO FUCK YOURSELF !!!",0
	even
font	incbin	\orion.src\fuzion.cd\2scrolls\font_3
image	incbin	\orion.src\fuzion.cd\2scrolls\pic.pi1
	even
music	incbin	\orion.src\fuzion.cd\2scrolls\warhawk.bin
endm
	end