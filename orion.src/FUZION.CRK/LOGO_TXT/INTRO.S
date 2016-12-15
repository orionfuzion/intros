	*************************************
	* Intro      Logo & Text            *
	* Coder      ORION from FUZION      *
	* Usage      Fuzion Cracks          *
	* Date       Summer or Autumn 1990  *
	*                                   *
	* Machine    Atari STE - 1MB RAM    *	
	* TOS        1.62                   *
	* Assembler  GenST v2.09            *
	* Emulator   Steem v3.2             *
	*                                   *
	* Contact    Orion.Fuzion@gmail.com *
	*************************************

scr	=	$60000

p_tbase	move.l	a7,save_reg+$3c
	pea	intro
	move	#$26,-(sp)
	trap	#14
	addq	#6,sp
	;bra	#run
	clr.l	-(sp)
	trap	#1
		
intro	bsr	save_all
	bsr	set_scr
	moveq	#1,d0
	jsr	music
	bsr	inter_on
	bsr	col_on
loop	cmp.b	#$39,$fffffc02.w
	bne.s	loop
	bsr	inter_off
	*bsr	decrunc
	rts
	
set_scr	move	#$25,-(sp)
	trap	#14
	addq	#2,sp
	dc.w	$a00a
	movem.l	black,d0-d7
	movem.l	d0-d7,$ffff8240.w
	bclr	#0,$484.w
	lea	scr,a6
	clr	-(sp)
	move.l	a6,-(a7)
	move.l	a6,-(a7)
	move	#5,-(sp)
	trap	#14
	lea	$c(sp),sp
	move.l	a6,a0
	move.l	#$3000,d0
eff_ecr	clr.l	(a0)+
	dbf	d0,eff_ecr
	lea	fonts,a0
	move.l	a6,a1
	move.l	#40*49-1,d0
aff_logo	move.l	(a0)+,(a1)+
	dbf	d0,aff_logo
	lea	text,a0
	lea	scr+160*50,a1
	move.l	a1,pt_ecr
	move.l	#1,adtn
loop_txt	clr.l	d0
	clr.l	d1
	move.b	(a0),d0
	add.l	#1,a0
	cmp.b	#1,d0
	bne.s	jmp_ct
	add.l	#160*8,pt_ecr
	move.l	pt_ecr,a1
	move.l	#1,adtn
	bra	loop_txt
jmp_ct	cmp.b	#0,d0
	beq	fin_txt
lettres	cmp.b	#$5b,d0
	bge	space
	cmp.b	#$40,d0
	ble	chiffres
	sub.b	#$41,d0
	move.b	d0,d1
	add.b	#1,d1
	divu	#2,d0
	divu	#2,d1
	cmp.b	d0,d1
	bne.s	impair1
pair1	mulu	#8,d0
	add.l	#160*8,d0
	bra	suite
impair1	mulu	#8,d0
	add.l	#160*8+1,d0
	bra	suite
chiffres	cmp.b	#$20,d0
	ble	space
	sub.b	#$21,d0
	move.b	d0,d1
	add.b	#1,d1
	divu	#2,d0
	divu	#2,d1
	cmp.b	d0,d1
	bne.s	impair2
pair2	mulu	#8,d0
	bra	suite
impair2	mulu	#8,d0
	add.l	#1,d0
	bra	suite
space	move.l	#144,d0	
suite	lea	fonts+160*49,a2
	add.l	d0,a2
	move.l	a1,a3
	moveq	#7,d2
aff_letter	move.b	(a2),(a3)
	move.b	2(a2),2(a3)
	move.b	4(a2),4(a3)
	move.b	6(a2),6(a3)
	lea	160(a2),a2
	lea	160(a3),a3
	dbf	d2,aff_letter
	adda.l	adtn,a1
	eor.l	#6,adtn
	bra	loop_txt
fin_txt	rts

col_on	moveq	#7,d7
loop_col2	moveq	#3,d6
att_col	move	#$25,-(sp)
	trap	#14
	addq	#2,sp
	dbra	d6,att_col	
	lea	pal+2,a0
	lea	$ffff8242.w,a1
	moveq	#14,d0
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
	lea	buf_ras+37*2,a0
	move	$ffff8242.w,(a0)
	move	$ffff8248.w,2(a0)
	move	$ffff824e.w,4(a0)
	move	$ffff8250.w,6(a0)
	move	$ffff8244.w,8(a0)
	move	$ffff8244.w,10(a0)
	move	$ffff8242.w,12(a0)
	move	$ffff8242.w,14(a0)
	move	$ffff8244.w,16(a0)
	move	$ffff8244.w,18(a0)
	move	$ffff8244.w,20(a0)
	dbf	d7,loop_col2
	rts

new_vbl	bsr	init_vbl
	bsr	over_high
	bsr	music+6
	rte

over_high	move.l	#$589,d0
att1	dbf	d0,att1
	rept	17
	nop
	endr
	clr	$ffff820a.w
	moveq	#1,d0
att2	dbf	d0,att2
	move.b	#2,$ffff820a.w
	rts
	
init_vbl	clr	pt_line
	move.l	#buf_ras,hbl1+2
	move.l	#hbl1,$120.w
	rts
	
hbl1	move	buf_ras,$ffff8240.w
	cmpi	#50,pt_line
	bgt.s	ras_off
	addq	#2,hbl1+4
	addq	#1,pt_line
	rte
	
ras_off	addq	#1,pt_line
	move.l	#hbl2,$120.w
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
ret	addq	#1,pt_line
	rte

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
	move	#1,$452.w
	lea	big_buf+6,a0
	movem.l	(a0),d0-d7
	*movem.l	black,d0-d7
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
	move	#$25,-(sp)
	trap	#14
	addq	#2,sp
	move.w	(sp)+,sr
	rts
	
decrunc	lea	dettp(pc),a0	
	lea	$140.w,a1		
	move.l	$84.w,$bc.w
	move.l	a1,$84.w
	move	#(fin-dettp)/2-1,d0
.1	move.w	(a0)+,(a1)+
	dbra	d0,.1
	rts

dettp	movem.l	d0-d5/a0-a3/a6,-(sp)
	lea	44+6(sp),a6
	btst	#13,44(sp)
	bne.s	.supervs
	move.l	usp,a6
.supervs	cmpi	#$3f,(a6)
	bne.s	.noread
	move.l	8(a6),-(sp)
	move.l	4(a6),-(sp)
	move.l	(a6),-(sp)
	trap	#15
	lea	12(sp),sp
	tst.l	d0
	bmi.s	.error
	move.l	8(a6),a0
	bsr.s	depack
.error	move.l	d0,(sp)
	movem.l	(sp)+,d0-d5/a0-a3/a6
	rte

.noread	movem.l	(sp)+,d0-d5/a0-a3/a6
	move.l	$bc.w,-(sp)
	rts

depack	movem.l	d0-d7/a0-a6,-(a7)
	move	$ffff8240.w,d5
	cmpi.l	#'Ice!',(a0)+
	bne.s	Ice0a
	move.l	(a0)+,d0
	lea	-8(a0,d0.l),a5
	move.l	(a0)+,(a7)
	lea	$6c(a0),a4
	movea.l	a4,a6
	adda.l	(a7),a6
	movea.l	a6,a3
	movea.l	a6,a1
	lea	depack+$22e+$c(pc),a2
	moveq	#$77,d0
Ice00	move.b	-(a1),-(a2)
	dbf	d0,Ice00
	bsr	Ice01
	bsr.s	Ice02
	move	d5,$ffff8240.w
	bsr	Ice03
	bcc.s	Ice04
	movea.l	a3,a1
	move.w	#$f9f,d7
Ice05	moveq	#3,d6
Ice06	move.w	-(a1),d4
	moveq	#3,d5
Ice07	add.w	d4,d4
	addx.w	d0,d0
	add.w	d4,d4
	addx.w	d1,d1
	add.w	d4,d4
	addx.w	d2,d2
	add.w	d4,d4
	addx.w	d3,d3
	dbf	d5,Ice07
	dbf	d6,Ice06
	movem.w	d0-d3,(a1)
	dbf	d7,Ice05
Ice04	move.l	(a7),d0
	lea	-$78(a4),a1
Ice08	move.b	(a4)+,(a1)+
	dbf	d0,Ice08
	subi.l	#$10000,d0
	bpl.s	Ice08
	moveq	#$77,d0
	lea	depack+$22e+$c(pc),a2
Ice09	move.b	-(a2),-(a3)
	dbf	d0,Ice09
Ice0a	movem.l	(a7)+,d0-d7/a0-a6
	rts
Ice02	bsr.s	Ice03
	bcc.s	Ice0b
	moveq	#0,d1
	bsr.s	Ice03
	bcc.s	Ice0c
	lea	tble1(pc),a1
	moveq	#4,d3
Ice0d	move.l	-(a1),d0
	bsr.s	Ice0e
	swap	d0
	cmp.w	d0,d1
	dbne	d3,Ice0d
	add.l	$14(a1),d1
Ice0c	move.b	-(a5),-(a6)
	move	d0,$ffff8240.w
	dbf	d1,Ice0c
Ice0b	cmpa.l	a4,a6
	bgt.s	Ice0f
	rts
Ice01	moveq	#3,d0
Ice10	move.b	-(a5),d7
	ror.l	#8,d7
	dbf	d0,Ice10
	rts
Ice11	move.w	a5,d7
	btst	#0,d7
	bne.s	Ice12
	move.l	-(a5),d7
	addx.l	d7,d7
	bra.s	Ice13
Ice12	move.l	-5(a5),d7
	lsl.l	#8,d7
	move.b	-(a5),d7
	subq.l	#3,a5
	add.l	d7,d7
	bset	#0,d7
	bra.s	Ice13
Ice03	add.l	d7,d7
	beq.s	Ice14
	rts
Ice14	move.w	a5,d7
	btst	#0,d7
	bne.s	Ice15
	move.l	-(a5),d7
	addx.l	d7,d7
	rts
Ice15	move.l	-5(a5),d7
	lsl.l	#8,d7
	move.b	-(a5),d7
	subq.l	#3,a5
	add.l	d7,d7
	bset	#0,d7
	rts
Ice0e	moveq	#0,d1
Ice16	add.l	d7,d7
	beq.s	Ice11
Ice13	addx.w	d1,d1
	dbf	d0,Ice16
	rts
Ice0f	lea	Ice17(pc),a1
	moveq	#3,d2
Ice18	bsr.s	Ice03
	dbcc	d2,Ice18
	moveq	#0,d4
	moveq	#0,d1
	move.b	1(a1,d2.w),d0
	ext.w	d0
	bmi.s	Ice19
	bsr.s	Ice0e
Ice19	move.b	6(a1,d2.w),d4
	add.w	d1,d4
	beq.s	Ice1a
	lea	Ice1b(pc),a1
	moveq	#1,d2
Ice1c	bsr.s	Ice03
	dbcc	d2,Ice1c
	moveq	#0,d1
	move.b	1(a1,d2.w),d0
	ext.w	d0
	bsr.s	Ice0e
	add.w	d2,d2
	add.w	6(a1,d2.w),d1
	bra.s	Ice1d
Ice1a	moveq	#0,d1
	moveq	#5,d0
	moveq	#0,d2
	bsr.s	Ice03
	bcc.s	Ice1e
	moveq	#8,d0
	moveq	#$40,d2
Ice1e	bsr.s	Ice0e
	add.w	d2,d1
Ice1d	lea	2(a6,d4.w),a1
	adda.w	d1,a1
	move.b	-(a1),-(a6)
Ice1f	move.b	-(a1),-(a6)
	dbf	d4,Ice1f
	bra	Ice02
	dc.b 	$7f,$ff,$00,$0e,$00,$ff,$00,$07
	dc.b 	$00,$07,$00,$02,$00,$03,$00,$01
	dc.b 	$00,$03,$00,$01
tble1	dc.b 	$00,$00,$01,$0d,$00,$00,$00,$0e
	dc.b 	$00,$00,$00,$07,$00,$00,$00,$04
	dc.b 	$00,$00,$00,$01
Ice17	dc.b 	$09,$01,$00,$ff,$ff,$08,$04,$02
	dc.b 	$01,$00
Ice1b	dc.b 	$0b,$04,$07,$00,$01,$20,$00,$00
	dc.b 	$00,$20
fin	
	even
	
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
	move.l	a6,a1
	lea	game,a0
	lea	end_game,a2
cop_game	move.l	(a0)+,(a1)+
	cmpa.l	a0,a2
	bge.s	cop_game
	lea	rel_1(pc),a2
rel_2	clr.l	(a1)+
	cmpa.l	a1,a2
	bge.s	rel_2
	tst	$1a(a6)
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
buf_ras	rept	52
	dc.w	$000
	endr
pal	dc.w	$000,$122,$233,$344,$455,$566,$677,$777
	dc.w	$232,$343,$454,$565,$676,$000,$000,$000
	even
big_buf	ds.l	80
	even
pt_line	ds.w	1
	even
adtn	ds.l	1
pt_ecr	ds.l	1
pt_text	ds.l	1
	even
tche_t	dc.b	1
	even
text	DC.B	1
	DC.B	"            PROUDLY PRESENTS",1
	DC.B	1
	DC.B	"          - PRINCE OF PERSIA -",1
	DC.B	1
	DC.B	"        CRACKED BY ARIOCH FROM V.8",1
	DC.B	"  PACKED ON 1 DISK BY ORION FROM FUZION",1
	DC.B	" (FOR THE PROTECTION,DRINK THE POTION F)",1
	DC.B	"   LITTLE CODE FOR THIS INTRO BY ORION",1
	DC.B	1
	DC.B	"       THE MEMBERS OF FUZION ARE :",1
	DC.B	"   THE DRAGON, FULCRUM, DOCNO, SQUAT,",1
	DC.B	"   SPEEDER, KASAR, ORION AND KELVIN!",1
	DC.B	1
	DC.B	"       WE SEND OUR GREETINGS TO :",1 
	DC.B	"  THE REPLICANTS ( MAXI AND NTM !!! )",1
	DC.B	" PENDRAGONS, THE LOST BOYS, AUTOMATION",1
	DC.B	" BLACK EAGLE, BUSHWACKERS ( SEARGENT )",1
	DC.B	" LAP, FOF, FUTUR MINDS ( BOULDOG ), TCB",1 
	DC.B	" ST_CONNEXION, EQUINOX, MADNESS, MACDOS",1
	DC.B	"MAD VISION, MINUTE MAN, MCS, OVERLANDERS",1
	DC.B	" FELESOFT ( TMS ), POMPEY PIRATES, TEX",1
	DC.B	"THE EMPIRE, RANDOM ACCESS, TBC, TSB, HMD",1
	DC.B 	" CST, DMA, FASHION, STRIDER, IMPACT, TST",1
	DC.B	1
	DC.B	"      CONTACT US ON RTEL BAL FUZION" 
 	DC.B	0
	even
	
music	incbin	\orion.src\fuzion.crk\logo_txt\count3.bin
	even
fonts	incbin	\orion.src\fuzion.crk\logo_txt\shaolin.fnt
	even
game	;incbin	a:\*.prg
	even
end_game
	end