	*************************************
	* Intro      Digidrum               *
	* Coder      ORION from FUZION      *
	* Purpose    FUZION Compact Disks   *
	* Date       August 1991 - CD#77    *
	*                                   *
	* Machine    Atari STE - 1MB RAM    *	
	* TOS        1.62                   *
	* Assembler  GenST v2.09            *
	* Emulator   Steem v3.2             *
	*                                   *
	* Contact    Orion.Fuzion@gmail.com *
	*************************************

magic_number	=	$1973
largeur_centre	=	120
hauteur_centre	=	80
decalage_stars	=	50
nbr_stars	=	120
scr1	=	$6b000
scr2	=	scr1+$a000	
num_music	=	$2
test	=	3

p_tbase	move.l	sp,sav_usp
	lea	scr1-$1000,sp
	pea	intro(pc)
	move	#$26,-(sp)
	trap	#14
	addq.l	#6,sp
	move.l	sav_usp,sp
	bra	load
	
intro	bsr	save_all
	bsr	reset
	bsr	pres_on
	bsr	prec_title
	bsr	prec_sin_hor
	bsr	prec_col
	bsr	prec_stars
	bsr	pres_off
	bsr	inter_on
loop	tst.b	tst_tche
	beq.s	loop
	bsr	inter_off
	rts

save_all	move.l	$24(a1),ssp+2
	move.l	$44e.w,sav_screen
	move.b	$ffff8260.w,sav_rez+1
	move.b	$ffff820a.w,sav_hz
	movem.l	$ffff8240.w,d0-d7
	movem.l	d0-d7,sav_pal
	lea	sav_mfp,a0
	move.b	$fffffa07.w,(a0)+
	move.b	$fffffa09.w,(a0)+
	move.b	$fffffa0b.w,(a0)+
	move.b	$fffffa0d.w,(a0)+
	move.b	$fffffa13.w,(a0)+
	move.b	$fffffa15.w,(a0)+
	move.b	$fffffa17.w,(a0)+
	move.b	$fffffa1b.w,(a0)+
	move.b	$fffffa1d.w,(a0)+
	move.b	$fffffa21.w,(a0)+
	move.l	$70.w,sav_vbl
	move.l	$120.w,sav_timer_b
	move.l	$114.w,sav_timer_c
	rts

inter_on	move.w	#$2700,sr
	move.b	#1,$fffffa07.w	
	clr.b	$fffffa09.w
	move.b	#1,$fffffa0b.w
	clr.b	$fffffa0d.w
	move.b	#1,$fffffa13.w
	clr.b	$fffffa15.w
	clr.b	$fffffa1b.w
	bsr	set_music
	move.b	#$40,$fffffa17.w
	move.b	#$74,$fffffa23.w
	move.l	#vbl,$70.w
	move	#$25,-(sp)
	trap	#14
	addq.l	#2,sp
	move.w	#$2300,sr
	move.b	#$12,$fffffc02.w
	rts

inter_off	move.w	#$2700,sr
	lea	sav_mfp,a0
	move.b	(a0)+,$fffffa07.w
	move.b	(a0)+,$fffffa09.w
	move.b	(a0)+,$fffffa0b.w
	move.b	(a0)+,$fffffa0d.w
	move.b	(a0)+,$fffffa13.w
	move.b	(a0)+,$fffffa15.w
	move.b	(a0)+,$fffffa17.w
	move.b	(a0)+,$fffffa1b.w
	move.b	(a0)+,$fffffa1d.w
	move.b	(a0)+,$fffffa21.w
	move.b	#$c0,$fffffa23.w
	move.l	sav_vbl,$70.w
	move.l	sav_timer_b,$120.w
	move.l	sav_timer_c,$114.w
	move.b	#$8,$fffffc02.w
	move.b	sav_hz,$ffff820a.w
	lea	$ffff8800.w,a0
	move.l	#$0707ffff,(a0)
	move.l	#$08080000,(a0)
	move.l	#$09090000,(a0)
	move.l	#$0a0a0000,(a0)
	clr.l	$426.w
	clr.l	$42a.w
	moveq	#0,d6
	moveq	#7,d7
cop_col4	lea	$ffff8240.w,a0
	moveq	#15,d0
col_16_2	move.w	d6,(a0)+
	dbf	d0,col_16_2
	add.w	#$111,d6
	moveq	#4,d5
vsync4	move	#$25,-(sp)
	trap	#14
	addq	#2,sp
	dbf	d5,vsync4
	dbf	d7,cop_col4
	move.w	sav_rez,-(sp)
	move.l	sav_screen,-(sp)
	move.l	(sp),-(sp)
	move.w	#5,-(sp)
	trap	#14
	lea	12(sp),sp
	movem.l	sav_pal,d0-d7
	movem.l	d0-d7,$ffff8240.w
	move.b	#7,$484.w
	move.w	#$2300,sr
	rts	

reset	move.l	#$31415926,$426.w
	move.l	#res_jmp,$42a.w
	rts
	
res_jmp	lea	p_tbase(pc),sp
	move.w	#$2700,sr
	move.l	sav_vbl,$70.w
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	moveq	#0,d3
	moveq	#0,d4
	moveq	#0,d5
	moveq	#0,d6
	moveq	#0,d7
	movem.l	d0-d7,$ffff8240.w
	lea	$ffff8800.w,a0
	move.l	#$0707ffff,(a0)
	move.l	#$08080000,(a0)
	move.l	#$09090000,(a0)
	move.l	#$0a0a0000,(a0)
	clr.b	$ffff8260.w
	move.b	#2,$ffff820a.w
	move.l	#scr1,d0
	lsr.l	#8,d0
	move.b	d0,$ffff8203.w
	lsr.l	#8,d0
	move.b	d0,$ffff8201.w
	lea	title,a0
	lea	scr2+$a000,a1
eff_scr	clr.l	(a0)+
	cmpa.l	a0,a1
	bgt.s	eff_scr
	lea	res_txt,a0
	lea	scr1+160*96,a1
	move.w	#7*20-1,d0
cop_res	move.w	(a0)+,(a1)
	lea	8(a1),a1
	dbf	d0,cop_res
	bsr	eff_col1
	clr.l	$42a.w
	clr.l	$426.w
block	bra.s	block
	
pres_on	move.b	#$13,$fffffc02.w
	move	#$777,d6
	moveq	#7,d7
cop_col0	moveq	#4,d5
vsync0	move	#$25,-(sp)
	trap	#14
	addq	#2,sp
	dbf	d5,vsync0
	lea	$ffff8240.w,a0
	moveq	#15,d0
col_16	move.w	d6,(a0)+
	dbf	d0,col_16
	sub.w	#$111,d6
	dbf	d7,cop_col0
	dc.w	$a00a
	move.b	#6,$484.w
	clr	-(sp)
	pea	scr1
	move.l	(sp),-(sp)
	move	#5,-(sp)
	trap	#14
	lea	12(sp),sp	
	move.l	#$2ffff,d0
att1	subq.l	#1,d0
	bne.s	att1
	lea	pres,a0
	lea	scr1+160*90,a1
	move.w	#20*20-1,d0
cop_pres	move.w	(a0)+,(a1)
	lea	8(a1),a1
	dbf	d0,cop_pres
eff_col1	moveq	#0,d6
	moveq	#7,d7
cop_col1	moveq	#4,d5
vsync1	move	#$25,-(sp)
	trap	#14
	addq	#2,sp
	dbf	d5,vsync1
	move.w	d6,$ffff8242.w
	add.w	#$111,d6
	dbf	d7,cop_col1
	rts
	
pres_off	moveq	#7,d7
	move	#$777,d6
cop_col2	moveq	#4,d4
vsync2	move	#$25,-(sp)
	trap	#14
	addq	#2,sp
	dbf	d4,vsync2
	move.w	d6,$ffff8242.w
	sub.w	#$111,d6
	dbf	d7,cop_col2
	moveq	#0,d1
	lea	scr1,a0
	move.w	#$4fff,d0
eff_mem	move.l	d1,(a0)+
	dbf	d0,eff_mem
	move.l	#$3ffff,d0
att2	subq.l	#1,d0
	bne.s	att2
	rts
	
set_music	jsr	music+$c
	moveq	#test,d0
	lea	$ffff820f.w,a0
	move.b	#$50,(a0)
	cmpi.b	#$50,(a0)
	beq.s	ste
	moveq	#1,d0
ste	clr.b	(a0)
	jsr	music+8
	moveq	#num_music,d0	
	jsr	music
	rts	
	
prec_stars	move.l	adr_pos_stars,a6
	move.l	a6,a5
	adda.l	#nbr_stars*8+8,a5
	move.l	a5,adr_buf_stars
	move.l	#nbr_stars-1,d7
stars_loop	move	#$11,-(sp)
	trap	#14
	addq.l	#2,sp
	swap	d0
	clr	d0
	swap	d0
	move.l	d0,d2
	divu	#largeur_centre,d0
	swap	d0
	sub.w	#largeur_centre/2,d0
	clr.w	d1
	swap	d1
	divu	#hauteur_centre,d1
	swap	d1
	sub.w	#hauteur_centre/2,d1
	tst.w	d0
	bne.s	no_centre
	tst.w	d1
	beq.s	stars_loop
no_centre	cmp.w	#nbr_stars/2,d7
	bgt.s	star_high
star_low	tst	d1
	bgt.s	y_sui
	neg.w	d1
	bra.s	y_sui
star_high	tst	d1
	blt.w	y_sui
	neg.w	d1
y_sui	divu	#decalage_stars,d2
	clr	d2
	swap	d2
	mulu	#4,d2
	move.l	a5,(a6)
	add.l	d2,(a6)+
	move.l	a5,(a6)+
	move.l	#$100,d2
	ext.l	d0
	asl.w	#8,d0
	ext.l	d1
	asl.w	#8,d1
star_loop	move.l	d0,d5
	move.l	d1,d6
	divs	d2,d5
	divs	d2,d6
	subq.w	#3,d2
	add.w	#$a0,d5
	ext.l	d5
	add.w	#$64,d6
	cmp.w	#319,d5
	bhi.s	star_next
	cmp.w	#199,d6
	bhi.s	star_next
	mulu	#$a0,d6
	divu	#16,d5
	move.w	d5,d3
	clr	d5
	swap	d5
	divu	#8,d5
	add.w	d5,d6
	swap	d5
	neg.w	d5
	addq.w	#7,d5
	move.w	d5,(a5)+
	mulu	#8,d3
	add.w	d3,d6
	cmp.w	#$90,d2
	bgt.s	chg_col1
	addq.w	#4,d6
	bra.s	no_chg_col
chg_col1	cmp.w	#$d0,d2
	bgt.s	no_chg_col
	addq.w	#2,d6
no_chg_col	move.w	d6,(a5)+
	bra.s	star_loop
star_next	dbf	d7,stars_loop
	move.l	a5,(a6)+
	move.l	a5,(a6)+
	rts

prec_title	lea	title,a0
	move.l	adr_buf_title,a1
	move.l	a1,d0
	add.l	#26*120*16,d0
	move.l	d0,adr_buf_sin_hor
	move.l	a1,a2
	move.w	#119,d0
cop_title1	movem.l	(a0)+,d2-d7
	movem.l	d2-d7,(a1)
	lea	24(a1),a1
	clr.w	(a1)+
	dbf	d0,cop_title1
	move.l	a2,a0
	move.w	#14,d0
dec_16	move.w	#119,d1
dec_120l	movem.l	(a0),d3-d7/a2
	movem.l	d3-d7/a2,26*120(a0)
	move.w	24(a0),120*26+24(a0)
	lea	120*26(a0),a0
	moveq	#0,d2
	roxr	d2
	rept	13
	roxr	(a0)+
	endr
	lea	-120*26(a0),a0
	dbf	d1,dec_120l
	dbf	d0,dec_16
	rts

prec_sin_hor	lea	sin_hor,a0
	move.l	adr_buf_sin_hor,a1
	move.l	a1,d0
	add.l	#(end_sin_hor-sin_hor)*8+120*8,d0
	move.l	d0,adr_buf_col_tit
	move.l	a1,a2
	moveq	#0,d0
	move.l	#160*56+32+6,d1
loop_sin_hor	add.b	(a0)+,d0
	cmp.b	#$f,d0
	ble.s	modulo
	sub.b	#$f,d0
	addq.w	#8,d1
	bra.s	modulo_sui
modulo	tst.b	d0
	bge.s	modulo_sui
	add.b	#$f,d0
	subq.w	#8,d1
modulo_sui	move.l	d0,d2
	mulu.w	#26*120,d2
	move.l	d1,(a1)+
	move.l	d2,(a1)+
	cmp.b	#$7f,(a0)
	bne.s	loop_sin_hor
	move.w	#120*2-1,d0
recop_deb	move.l	(a2)+,(a1)+
	dbf	d0,recop_deb
	rts

prec_col	lea	col_title,a0
	move.l	adr_buf_col_tit,a1
	move.l	a1,d0
	add.l	#(end_col-col_title)*8,d0
	move.l	d0,adr_pos_stars
	move.l	a1,a2
cop_col	move.w	(a0),(a1)+
	move.w	(a0),(a1)+
	move.w	(a0),(a1)+
	move.w	(a0)+,(a1)+
	tst.w	(a0)
	bne.s	cop_col
	move.l	a1,a3
cop_colb	move.l	(a2)+,(a3)+
	cmpa.l	a2,a1
	bgt.s	cop_colb
	rts

vbl	bsr	init
	bsr	aff_stars
	bsr	aff_title
	bsr	scroll
	jsr	music+4
	bsr	vu_meter
	bsr	tche
	rte

hbl1	move.l	$0,$ffff8250.w
	move.l	$ffff8250.w,$ffff8254.w
	move.l	$ffff8250.w,$ffff8258.w
	move.l	$ffff8250.w,$ffff825c.w
	addq.l	#4,hbl1+2
	subq.w	#1,pt_line
	bne.s	ret1
	clr.b	$fffffa1b.w	
	move.b	#19,$fffffa21.w
	move.l	#hbl2,$120.w
	move.b	#8,$fffffa1b.w
ret1	rte

hbl2	clr.b	$fffffa1b.w	
	move.b	#1,$fffffa21.w
	move.l	#hbl3,$120.w
	move.w	#120,pt_line
	move.b	#8,$fffffa1b.w
	rte
	
hbl3	move.l	$0,$ffff8250.w
	move.l	$ffff8250.w,$ffff8254.w
	move.l	$ffff8250.w,$ffff8258.w
	move.l	$ffff8250.w,$ffff825c.w
	addq.l	#4,hbl3+2
	subq.w	#1,pt_line
	bne.s	ret3
	clr.b	$fffffa1b.w	
	move.b	#25,$fffffa21.w
	move.l	#hbl4,$120.w
	move.b	#8,$fffffa1b.w
ret3	rte

hbl4	move.w	#$2700,sr
	movem.l	a0/d0,-(sp)
	lea	$fffffa21.w,a0
	move.b	(a0),d0
same_line	cmp.b	(a0),d0
	beq.s	same_line
	clr.b	$ffff820a.w
	dcb.w	18,$4e71
	move.b	#2,$ffff820a.w
	clr.b	$fffffa1b.w
	move.w	fonts+4,$ffff8242.w
	move.l	fonts+6,$ffff8244.w
	move.l	fonts+10,$ffff8248.w
	move.l	fonts+14,$ffff824c.w
	movem.l	(sp)+,a0/d0
	move.w	#$2300,sr
	rte
	
init	move.w	#35,pt_line
	move.l	adr_buf_col_tit,a0
	add.l	pt_col,a0
	addq.l	#4,pt_col
	cmp.l	#119*4,pt_col
	bne.s	no_bcle_col
	clr.l	pt_col
no_bcle_col	move.l	a0,hbl3+2
	move.l	#buf_col_vu,hbl1+2
	clr.b	$fffffa1b.w	
	move.b	#1,$fffffa21.w
	move.l	#hbl1,$120.w
	move.b	#8,$fffffa1b.w		
	lea	scr,a0
	move.l	(a0),sav_scr
	eor.w	#1,swap_ec
	tst.w	swap_ec
	beq.s	ec2
ec1	move.l	#scr2,(a0)
	bra.s	ec_sui
ec2	move.l	#scr1,(a0)
ec_sui	move.b	1(a0),$ffff8201.w
	move.b	2(a0),$ffff8203.w
	movem.l	pal_stars,d0-d3
	movem.l	d0-d3,$ffff8240.w
	rts

aff_stars	move.l	adr_pos_stars,a0
	move.l	scr,a1
	move.l	sav_scr,a4
	moveq	#0,d2
	move.l	#nbr_stars-1,d0
loop_aff	move.l	(a0),a3
	move.w	(a3)+,d1
	move.w	(a3)+,d2
	lea	0(a1,d2.l),a2
	bclr	d1,(a2)
	addq.l	#4,(a0)
	cmp.l	12(a0),a3
	bne.s	no_bcle
	move.l	4(a0),(a0)
	move.l	(a0),a3
no_bcle	move.w	(a3)+,d1
	move.w	(a3)+,d2
	lea	0(a4,d2.l),a2
	bset	d1,(a2)	
	addq.l	#8,a0	
	dbf	d0,loop_aff
	rts

aff_title	move.l	scr,a0
	move.l	adr_buf_sin_hor,a1
	move.l	adr_buf_title,a2
	lea	pt_hor,a3
	cmp.l	#(end_sin_hor-sin_hor)*8,(a3)
	bne.s	hor_ct
	clr.l	(a3)
hor_ct	adda.l	(a3),a1
	addq.l	#8,(a3)
	moveq	#119,d0
cop_aff_spr	move.l	a0,a4
	adda.l	(a1)+,a4
	move.l	a2,a3
	adda.l	(a1)+,a3
	move.w	(a3)+,(a4)
	move.w	(a3)+,8(a4)
	move.w	(a3)+,16(a4)
	move.w	(a3)+,24(a4)
	move.w	(a3)+,32(a4)
	move.w	(a3)+,40(a4)
	move.w	(a3)+,48(a4)
	move.w	(a3)+,56(a4)
	move.w	(a3)+,64(a4)
	move.w	(a3)+,72(a4)
	move.w	(a3)+,80(a4)
	move.w	(a3)+,88(a4)
	move.w	(a3)+,96(a4)
	lea	26(a2),a2
	lea	160(a0),a0
	dbf	d0,cop_aff_spr
	rts
	
scroll	add.w	#1,pt_scroll
	cmp.w	#5,pt_scroll
	bne.s	let_ct
	clr.w	pt_scroll
	lea	text,a0
	adda.l	pt_txt,a0
	tst.b	(a0)
	bne.s	txt_sui
	clr.l	pt_txt
	lea	text,a0
txt_sui	addq.l	#1,pt_txt
	moveq	#0,d0
	move.b	(a0),d0
	sub.w	#$20,d0
	mulu	#2,d0
	lea	table_letters,a0
	adda.l	d0,a0
	moveq	#0,d0
	move.w	(a0),d0
	move.l	d0,a2
	move.l	pos_letter,a1
	move.l	a2,pos_letter
	bra	aff_scroll
	
let_ct	move.l	pos_letter,d0
	move.l	d0,d1
	and.l	#-2,d1
	cmp.l	d0,d1
	bne.s	impair
pair	addq.l	#1,d1
	bra.s	txt_sui2
impair	addq.l	#8,d1
txt_sui2	move.l	d1,pos_letter
	move.l	d0,a1
	move.l	d1,a2
	
aff_scroll	lea	fonts+34,a0
	adda.l	a0,a1
	adda.l	a0,a2
	move.l	scr,a0
	adda.l	#160*202,a0
	moveq	#29,d0
cop_aff_scroll	movem.l	8(a0),d1-d7/a3-a5
	movem.l	d1-d7/a3-a5,(a0)
	movem.l	48(a0),d1-d7/a3-a5
	movem.l	d1-d7/a3-a5,40(a0)
	movem.l	88(a0),d1-d7/a3-a5
	movem.l	d1-d7/a3-a5,80(a0)
	movem.l	128(a0),d1-d7/a3
	movem.l	d1-d7/a3,120(a0)
	movep.l	0(a1),d1
	movep.l	d1,152(a0)
	movep.l	0(a2),d1
	movep.l	d1,153(a0)
	lea	160(a0),a0
	lea	160(a1),a1
	lea	160(a2),a2
	dbf	d0,cop_aff_scroll
	rts
	
vu_meter	lea	$ffff8800.w,a0
	move.l	scr,a1
	adda.l	#160*17+6,a1
	lea	vols,a4
	moveq	#8,d6
	moveq	#2,d7
	move.w	#$ffff,d4
voix3	moveq	#0,d0
	move.b	d6,(a0)
	move.b	(a0),d0
	cmp.b	(a4),d0
	bge.s	v_p
	cmp.b	#7,(a4)
	beq.s	v_m
	subq.b	#1,(a4)
v_m	move.b	(a4),d0
	bra.s	v_ct
v_p	cmp.b	#15,d0
	ble.s	v1_p_ok
	move.b	#15,d0
v1_p_ok	move.b	d0,(a4)
v_ct	subq.b	#7,d0
	mulu	#2,d0	
	moveq	#16,d1
	sub.w	d0,d1
	move.l	a1,a2
	move.l	a1,a3
aff_1v	move.w	d4,(a2)
	move.w	d4,(a3)
	move.w	d4,120(a2)
	move.w	d4,120(a3)
	lea	160(a2),a2
	lea	-160(a3),a3
	dbf	d0,aff_1v
eff_1v	clr.w	(a2)
	clr.w	(a3)
	clr.w	120(a2)
	clr.w	120(a3)
	lea	-160(a3),a3
	lea	160(a2),a2
	dbf	d1,eff_1v
	lea	16(a1),a1
	lea	1(a4),a4
	addq	#1,d6
	dbf	d7,voix3
	rts
	
tche	move.b	$fffffc02.w,d0
f1	cmp.b	#$3b,d0
	bne.s	f2
	move.l	#nom1,nom+2
	bra	tche_ok
f2	cmp.b	#$3c,d0
	bne.s	f3
	move.l	#nom2,nom+2
	bra	tche_ok
f3	cmp.b	#$3d,d0
	bne.s	return
	move.l	#nom3,nom+2
	bra	tche_ok
return	cmp.b	#$1c,d0
	bne.s	tche_sui
	move.b	#2,tst_tche
	bra.s	tche_sui
tche_ok	move.b	#1,tst_tche	
tche_sui	rts

load	cmp.b	#1,tst_tche
	bne	quit
	move.w	#2,-(sp)
nom 	pea	0
 	move.w	#$3d,-(sp)
 	trap	#1
 	addq.l	#8,sp
 	tst.w	d0
 	bmi	error
 	move.w	d0,d7
 	lea	rel_deb(pc),a0
 	lea	-$500(a7),a1
	move.l	a1,a3
 	move.l	#(rel_fin-rel_deb)/4,d0
cop_rel	move.l	(a0)+,(a1)+
 	dbf	d0,cop_rel
 	lea	p_tbase,a1
	lea	-$1c(a1),a2
 	jmp	(a3)
 	
rel_deb	bsr	char
	bsr	protec
	bsr	reloge
	bsr	calc_bp
	movem.l	eff_m(pc),d0-d7/a2
	movem.l	d0-d7/a2,-36(a1)
	lea	-$32(a7),a6
	move.l	a7,a2
	adda.l	#$8008,a2
	lea	-$100(a1),a0
	move.l	a4,a3
	jmp	-36(a1)
	
char	pea	(a2)
 	pea	$ffffff
 	move.w	d7,-(sp)
 	move.w	#$3f,-(sp)
 	trap	#1
 	lea	12(sp),sp
 	tst.l	d0
 	bmi	error
 	move.l	a2,a5
 	adda.l	d0,a5
 	move.l	d0,d6
 	move.w	d7,-(sp)
 	move.w	#$3e,-(sp)
 	trap	#1
 	addq.l	#4,sp
 	tst.w	d0
 	bmi	error
 	rts
		
protec	cmpi.w	#$601a,(a2)
	beq	ret_dec
	cmpi.w	#'FZ',(a2)
	bne	error
	lea	2(a2),a0
	lea	-1(a5),a4
	move.l	d6,d1
	move.l	#'kGsL',d0
	move.w	#magic_number,d2
	move.w	#$cafe,d3
	not.w	$1c(a2)
	
dec_cop	add.l	d1,d0
	eor.w	d0,(a0)
	swap	d0
	sub.w	d2,(a0)
	eor.w	d3,(a0)
	move.w	(a0)+,d3
	cmpa.l	a0,a4
	bgt.s	dec_cop
	
ret_dec	clr.b	(a5)+
	clr.b	(a5)+
	clr.b	(a5)+
	clr.b	(a5)+
	rts

reloge	tst.w	$1a(a2)
	bne.s	rel_2
	move.l	a1,a0
	adda.l	2(a2),a0
	adda.l	6(a2),a0
	adda.l	14(a2),a0
	moveq	#0,d1
	move.l	a1,d2
	move.l	(a0)+,d0
	beq.s	rel_4
rel_3	add.l	d2,0(a1,d0.l)
rel_4	move.b	(a0)+,d1
	beq.s	rel_2
	add.l	d1,d0
	cmp.b	#1,d1
	bne.s	rel_3
	addi.l	#$fd,d0
	bra.s	rel_4
rel_2	rts

calc_bp	lea	-$100(a1),a0
	move.l	a1,d0
	move.l	2(a2),12(a0)
	add.l	12(a0),d0
	move.l	d0,a5
	move.l	d0,16(a0)
	move.l	6(a2),20(a0)
	add.l	20(a0),d0
	move.l	d0,a4
	move.l	d0,24(a0)
	move.l	10(a2),28(a0)
	rts
	
eff_m	clr.l	(a3)+
	cmpa.l	a3,a2
	bgt.s	eff_m
	move.l	a0,4(a7)
ssp	move.l	#0,0(a6)
	move.l	a1,6(a6)
	movem.l	-60(a3),d0-d7/a0-a3
	movem.l	d0-d7/a1,p_tbase-36

error	pea	err_sup(pc)
	move	#$26,-(sp)
	trap	#14
	addq	#6,sp
quit	clr.l	-(sp)
	trap	#1
	
err_sup	movem.l	$ffff8240.w,d0-d7
	movem.l	d0-d7,-(sp)
	clr.w	-(a7)
	move.b	$ffff8260.w,1(a7)
	dc.w	$a00a
	move.b	#4,$484.w
	move.w	#1,-(sp)
	pea	-1.w
	move.l	(sp),-(sp)
	move.w	#5,-(sp)
	trap	#14
	lea	12(sp),sp
	move	#$25,-(sp)
	trap	#14
	addq	#2,sp
	move.w	#$7,$ffff8240
	move.w	#$777,$ffff8246.w
	pea	aff_mes(pc)
	move	#9,-(sp)
	trap	#1
	addq	#6,sp
attc	cmp.b	#$39,$fffffc02.w
	bne.s	attc
	pea	-1.w
	move.l	(sp),-(sp)
	move.w	#5,-(sp)
	trap	#14
	lea	12(sp),sp
	move.b	#7,$484.w
	move	#$25,-(sp)
	trap	#14
	addq	#2,sp
	movem.l	(sp)+,d0-d7
	movem.l	d0-d7,$ffff8240.w
	rts
	
aff_mes	dc.b	27,"E",27,"Y",41,32,7
	dc.b	"                               - LOADING ERROR -",10,13
	dc.b	10,13
	dc.b	"                     - MAYBE YOU SHOULD RECOPY THIS DISK -",10,13
	dc.b	10,13
	dc.b	"                          - PRESS SPACE TO CONTINUE -",10,13
	dc.b	0
	even
rel_fin
pal_stars	dc.w	$000,$222,$444,$444,$666,$666,$666,$666
col_title	dc.w	$017,$027,$037,$047,$057,$067,$077
	dc.w	$076,$075,$074,$073,$072,$071,$070
	dc.w	$170,$270,$370,$470,$570,$670,$770
	dc.w	$760,$750,$740,$730,$720,$710,$700
	dc.w	$701,$702,$703,$704,$705,$706,$707
	dc.w	$717,$727,$737,$747,$757,$767,$777
	dc.w	$776,$775,$774,$773,$772,$771,$770
	dc.w	$661,$552,$443,$344,$245,$146,$047
	dc.w	$037,$027,$017,$007
end_col	dc.w	0
pt_col	dc.l	0
buf_col_vu	dc.w	$001,$001,$011,$011,$012,$012,$022,$022
	dc.w	$023,$023,$033,$033,$034,$034,$044,$044
	dc.w	$045,$045,$055,$055,$056,$056,$066,$066
	dc.w	$067,$067,$077,$077,$177,$177,$277,$277
	dc.w	$277,$277,$177,$177,$077,$077,$067,$067
	dc.w	$066,$066,$056,$056,$055,$055,$045,$045
	dc.w	$044,$044,$034,$034,$033,$033,$023,$023
	dc.w	$022,$022,$012,$012,$011,$011,$001,$001
	dc.w	$000,$000,$000,$000,$000,$000,$000,$000
pt_line	dc.w	0
	even
sin_hor	dcb.b	120,0
	rept	1
	dc.b	4,4,4,4,4,4,3,3,3,3,3,3,2,2,2,2,2,2,1,1,1,1,1,1
	dc.b	-1,-1,-1,-1,-1,-1,-2,-2,-2,-2,-2,-2,-3,-3,-3,-3,-3,-3,-4,-4,-4,-4,-4,-4
	dc.b	-4,-4,-4,-4,-4,-4,-3,-3,-3,-3,-3,-3,-2,-2,-2,-2,-2,-2,-1,-1,-1,-1,-1,-1
	dc.b	1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4
	endr
	rept	1
	dc.b	4,4,4,4,4,3,3,3,3,3,2,2,2,2,2,1,1,1,1,1
	dc.b	-1,-1,-1,-1,-1,-2,-2,-2,-2,-2,-3,-3,-3,-3,-3,-4,-4,-4,-4,-4
	dc.b	-4,-4,-4,-4,-4,-3,-3,-3,-3,-3,-2,-2,-2,-2,-2,-1,-1,-1,-1,-1
	dc.b	1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4
	endr
	rept	1
	dc.b	4,4,4,4,3,3,3,3,2,2,2,2,1,1,1,1
	dc.b	-1,-1,-1,-1,-2,-2,-2,-2,-3,-3,-3,-3,-4,-4,-4,-4
	dc.b	-4,-4,-4,-4,-3,-3,-3,-3,-2,-2,-2,-2,-1,-1,-1,-1
	dc.b	1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4
	endr
	rept	2
	dc.b	4,4,4,3,3,3,2,2,2,1,1,1
	dc.b	-1,-1,-1,-2,-2,-2,-3,-3,-3,-4,-4,-4
	dc.b	-4,-4,-4,-3,-3,-3,-2,-2,-2,-1,-1,-1
	dc.b	1,1,1,2,2,2,3,3,3,4,4,4
	endr
	rept	3
	dc.b	4,4,3,3,2,2,1,1
	dc.b	-1,-1,-2,-2,-3,-3,-4,-4
	dc.b	-4,-4,-3,-3,-2,-2,-1,-1
	dc.b	1,1,2,2,3,3,4,4
	endr
	rept	4
	dc.b	4,3,2,1
	dc.b	-1,-2,-3,-4
	dc.b	-4,-3,-2,-1
	dc.b	1,2,3,4
	endr
	dcb.b	120,0
	rept	2
	dcb.b	16,2
	dc.b	2,2,2,2,1,2,2,2,1,2,2,1,2,1,1,1,1,0,1,1,1,0,1,1,0,1,0,0,0,0
	dc.b	-1,0,-1,-1,0,-1,-1,-1,0,-1,-1,-1,-1,-2,-1,-2,-2,-1,-2,-2,-2,-1,-2,-2,-2,-2
	dcb.b	32,-2
	dc.b	-2,-2,-2,-2,-1,-2,-2,-2,-1,-2,-2,-1,-2,-1,-1,-1,-1,0,-1,-1,-1,0,-1,-1,0,-1
	dc.b	0,0,0,0,1,0,1,1,0,1,1,1,0,1,1,1,1,2,1,2,2,1,2,2,2,1,2,2,2,2
	dcb.b	16,2
	endr
	rept	2
	dc.b	1,1,1,2,2,2,3,3,3,2,2,2,1,1,1
	dc.b	1,1,1,2,2,2,3,3,3,2,2,2,1,1,1
	dc.b	-1,-1,-1,-2,-2,-2,-3,-3,-3,-2,-2,-2,-1,-1,-1
	dc.b	-1,-1,-1,-2,-2,-2,-3,-3,-3,-2,-2,-2,-1,-1,-1
	dc.b	-1,-1,-1,-2,-2,-2,-3,-3,-3,-2,-2,-2,-1,-1,-1
	dc.b	-1,-1,-1,-2,-2,-2,-3,-3,-3,-2,-2,-2,-1,-1,-1
	dc.b	1,1,1,2,2,2,3,3,3,2,2,2,1,1,1
	dc.b	1,1,1,2,2,2,3,3,3,2,2,2,1,1,1
	endr
	dcb.b	120,0
	rept	30
	dc.b	1,2,1,-1,-2,-1
	endr
	rept	4
	dcb.b	10,2
	dc.b	2,2,2,1,2,1,1,2,1,1,1,0,1,0,0,1,0,0,0
	dc.b	-1,0,0,-1,0,-1,-1,-1,-2,-1,-1,-2,-1,-2,-2,-2
	dcb.b	20,-2
	dc.b	-2,-2,-2,-1,-2,-1,-1,-2,-1,-1,-1,0,-1,0,0,-1,0,0,0
	dc.b	0,0,0,1,0,0,1,0,1,1,1,2,1,1,2,1,2,2,2
	dcb.b	10,2
	endr
	rept	25
	dc.b	3,2,1,-1,-2,-3,-2,-1,1,2
	endr
	dcb.b	120,0
	rept	2
	dc.b	5,5,5,4,4,4,4,4,3,3,3,3,3,2,2,2,2,2,1,1,1,1,1,0,0,0,0,0
	dc.b	-1,-1,-1,-1,-1,-2,-2,-2,-2,-2,-3,-3,-3,-3,-3,-4,-4,-4,-4,-4,-5,-5,-5
	dc.b	-5,-5,-5,-4,-4,-4,-4,-4,-3,-3,-3,-3,-3,-2,-2,-2,-2,-2,-1,-1,-1,-1,-1
	dc.b	0,0,0,0,0,1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4,5,5,5
	endr
end_sin_hor	dc.b	$7f
	even
pt_hor	dc.l	0
	even
swap_ec	dc.w	0
scr	dc.l	scr1
sav_scr	dc.l	0
vols	dc.b	7,7,7
	even
tst_tche	dc.b	0
	even
table_letters	dc.w	160*31*5+80,160*31*3+40
	dcb.w	5,160*31*5+80
	dc.w	160*31*3+57,160*31*5+57,160*31*5+40
	dcb.w	2,160*31*5+80
	dc.w	160*31*3+137,160*31*5+80,160*31*3+120,160*31*5+80
	dc.w	160*31*4+0,160*31*4+17,160*31*4+40,160*31*4+57,160*31*4+80,160*31*4+97,160*31*4+120,160*31*4+137
	dc.w	160*31*5+0,160*31*5+17,160*31*3+97
	dcb.w	4,160*31*5+80
	dc.w	160*31*3+80,160*31*5+80
	dc.w	0,17,40,57,80,97,120,137
	dc.w	160*31+0,160*31+17,160*31+40,160*31+57,160*31+80,160*31+97,160*31+120,160*31+137
	dc.w	160*31*2+0,160*31*2+17,160*31*2+40,160*31*2+57,160*31*2+80,160*31*2+97,160*31*2+120,160*31*2+137
	dc.w	160*31*3+0,160*31*3+17
pt_scroll	dc.w	4
pt_txt	dc.l	0
pos_letter	dc.l	160*31*5+80
text	dc.b	"   EXCLUSIVE OFFER !!  PRESS RETURN FOR INFORMATIONS ...         YO FANS !!      HOLLIDAYS ARE FINISHED, ORION AND DRAGON STRIKE BACK WITH MENU 77 WICH CONTAINS :       "
	DC.B	"  DARKMAN ( HACKED BY CAMEO ), INTERNATIONAL CHAMPIONSHIP ATHLETICS ( PACKED BY ORION, SUPPLY BY OUR FRIEND ... ) AND PUZZNIC ( WORK BY CAMEO, SUPPLY BY DRAGON ) ...     "
	DC.B	"  DIS NEW INTRO WAS FASTLY CODED BY ORION, GRAFIX BY MACDOS AND MUSAX BY MAD MAX ( STE OWNERS WILL APRECIATE IT ... )        "
	DC.B	"  IF YOU WANT TO CONTACT US, READ ALL SCROLL ...     PRESS RETURN FOR THE DOCS OF DARKMAN AND PUZZNIC       "
	DC.B	" WE SEND OUR GREETINGS TO :      "
	DC.B	"   THE REPLICANTS ( CAMEO ( THANX FOR ALL STEF ), STWAIKIKI ( THANX FOR THE PIN'S ), MAXI AND ILLEGAL ) "
	DC.B	"   XENEX ( THANX FOR THE MENU, RAMSES XIII ) "
	DC.B	"   THE WILD BOYS ( NICE MEETING YOU POWERMAN, NICE DEMO TOO ... ) "
	DC.B	"   AUTOMATION ( HEY MOB, ARE YOU SLEEPING ? ) "
	DC.B	"   MAD VISION ( HI SPY 3 ) "
	DC.B	"   THE SYNDICATE ( FLOSSY FROM THE REANIMATORS, ONIXUS FROM HORIZON ) "
	DC.B	"   RIPPED OFF ( HELLO BILBO AND STICK, SORRY I COULDN'T COME, A NEXT TIME MAYBE ... ) "
	DC.B	"   INNER CIRCLE ( PHANTOM, MASTER ( NICE MEETING YOU, I WAIT YOUR REPLY ), COUNT ZERO ) "
	DC.B	"   BBC ( THE PILOT, I'LL CALL YOU WHEN YOU'LL BE BACK HOME !! ) "
	DC.B	"   AWESOME ( RUTHLESS AND SCORPION, NICE MENUS GUYS, SEND WHAT I ASKED PLEASE SCORPION ... ) "
	DC.B	"   FOF ( WANDERER, NICE MENUS, KEEP SENDING ... ) "
	DC.B	"   ST-CONNEXION ( KRAZY REX AND VANTAGE ) "
	DC.B	"   VMAX ( ALTAIR, ICE, TST D0, COMTE 0 ) "
	DC.B	"   NEW POWER GENERATION ( TGA, DO YOU LIKE ALL THESE DEMOS FILE VERSIONS ? ) "
	DC.B	"   BAD BOYS BELGIUM ( DO YOU GET OUR MENUS QUICKLY ? OTHERWISE GET IN TOUCH ... ) "
	DC.B	"   HOTLINE ( GREAT MUSAX LOTUS ) "
	DC.B	"   BLUE MAX ( SEE YA ) "
	DC.B	"   CELTIK ( ALWAYS ON HOLLIDAYS ? ) "
	DC.B	"   THYS ELROY "
	DC.B	"   IMPACT ( SUNSET, TOXIC, ARE YOU SLEEPING ? ) "
	DC.B	"   BUSHWACKERS ( HI SERGENT, WHAT ABOUT THE TRANSBEAUCE 2 DISK 1 ? ) "
	DC.B	"   POMPEY PIRATES ( GET IN TOUCH, THE ADRESS IS COMING ... ) "
	DC.B	"   BVCA ( HI GUY ) "
	DC.B	"   NEXT ( MIT, ZAE, LAP, SCREEN BY SPEEDER SOON HOPEFULLY ) "
	DC.B	"   STARFIRES ( ORACLE AND BOXER ) "
	DC.B	"   THE NAPALM SOLDIERS ( HI HAWK, SEND DISKS IF YOU WANT MENUS ... ) "
	DC.B	"   LIGHT ( HI LEVIATHAN, YOUR STE MODULE DISK PLAYER IS JUST SO GREAT, SEND ME YOUR MEGA DEMO WHEN FINISHED ... ) "
	DC.B	"   TRITON ( OVERLANDERS ESPECIALLY BEETLEJUICE AND FX FROM PENDRAGONS ) "
	DC.B	"   TVI ( AVENGER OF NEWLINE, THANX FOR WRITING, BUT STILL WAITING YOUR REPLY ... ) "
	DC.B	"   MCODER "
	DC.B	"   MCP "
	DC.B	"   INFIRMIER "
	DC.B	"   THE STORM BROTHERS ( ESPECIALLY ZINE, SEND INVITATIONS FOR THE TSB 2 ! ) "
	DC.B	"   EQUINOX "
	DC.B	"   STAX ( HI MATT, THANX FOR SPREADING IN GERMANY ) "
	DC.B	"   FUSION ( :AMIGA CREW    SEND YOUR PRODUCTS !! ) "
	DC.B	"   SOLARIS ( :AMIGA CREW    HI ROY, SEND YOUR DEMO ) "
	DC.B	"   THE THUNDERBIRDS ( THANX JACK FOR THE MENU ) "
	DC.B	"   FUTUR MINDS ( BOULDOG ) " 
	DC.B	"   FIREHAWKS ( SAMOS AND JUDI ) "
	DC.B	"   FOREIGNER ( THANX FOR THE MENU ... FINISH IT SOON ! ) "
	DC.B	"   FMC CONNEXION ( KILLER D ) "
	DC.B	"   HIJACK ( TRY TO GET THE ENGLISH STUFF I ASKED ... ) "
	DC.B	"   ZE PROZES "
	DC.B	"   FASHION ( TIGER, SEND MY DISKS BACK !!  MOST PEOPLE THINK CRACKIN' MUSEX 2 ISN'T BETTER, SORRY ... ) " 
	DC.B	"   MASTERS ( SKAVEN, IS YOUR CREW DEAD ? ) "
	DC.B	"   MCS ( AXEL FOLLET AND OTHERS, SORRY NO TIME TO CODE A SCREEN FOR YOUR DEMO ... ) "
	DC.B	"   LEGACY ( FURY AND VICKERS, NOTHING NEW ? ) "
	DC.B	"   ST QUI VEUT "
	DC.B	"   OFFBEAT "
	DC.B	"   DMA ( JINX, GOOD DCK ... ) "
	DC.B	"   DELIGHT ( AXE, GREAT PACKERS !! ) "
	DC.B	"   THE LOST BOYS ( SAMMY JOE, WHAT ABOUT MAGGIE 6 ? ) "
	DC.B	"   TITANIC TARZANS FROM ICELAND ( THANX FOR WRITING ... ) "
	DC.B	"   BLACK EAGLE "
	DC.B	"   MAXX STYLE "
	DC.B	"   NASTY MC "
	DC.B	"   VOYAGERS ( RESCATOR, NINJA ONE ) "
	DC.B	"   TITANIUM ( STF62 AND STE59 ) "
	DC.B	"   BABAR ( NICE GRAFIX ) "
	DC.B	"   THE BLACK CATS ( DOCPROF, AND THE OTHERS ) "
	DC.B	"   CONAN ( ARF, HAPPY ? ) "
	DC.B	"   THE SOURCE "
	DC.B	"   PHENIX ( SEE YA AT TSB 2 ) "		
	DC.B	"   DNT CREW ( FLIPS, AXIOM, NICE SCREEN ) "		
	DC.B	"   RANDOM ACCESS ( DEAD CREW ... ? ) "
	DC.B	"    THAT'S ALL FOR THIS TIME ...      SO WRITE TO:     FUZION    BP 66      59420  MOUVAUX     FRANCE       I REPEAT:        FUZION      BP 66     59420  MOUVAUX     FRANCE       "
	DC.B	"    WRAP TIME ....                                              "	 
	dc.b	0
	even
nom1	dc.b	"1.prg",0
	even
nom2	dc.b	"2.prg",0
	even
nom3	dc.b	"3.prg",0
	even	
adr_buf_title	dc.l	buf_all
adr_buf_sin_hor	dc.l	0
adr_buf_col_tit	dc.l	0
adr_pos_stars	dc.l	0
adr_buf_stars	dc.l	0
	even
reg_o	ds.l	2
sav_usp	ds.l	1
sav_rez	ds.w	1
sav_screen	ds.l	1
sav_hz	ds.w	1
sav_pal	ds.w	16
sav_mfp	ds.b	10
sav_vbl	ds.l	1
sav_timer_b	ds.l	1
sav_timer_c	ds.l	1
	even
res_txt	incbin	\orion.src\fuzion.cd\digidrum\res.dat
	even
title	incbin	\orion.src\fuzion.cd\digidrum\title.dat
	even
pres	incbin	\orion.src\fuzion.cd\digidrum\pres.dat
	even
fonts	incbin	\orion.src\fuzion.cd\digidrum\fonts.pi1
	even
music	incbin	\orion.src\fuzion.cd\digidrum\turric1.bin
	even
buf_all
	end