	*************************************
	* Intro      F.I.D.                 *
	* Coder      ORION from FUZION      *
	* Usage      FUZION Compact Disks   *
	* Date       Nov 1991 - CD#100      *
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
num1_music	=	6
num2_music	=	2
num3_music	=	4
num4_music	=	8
test	=	3

p_tbase	move.l	sp,sav_usp
	lea	scr1-$1000,sp
	pea	intro(pc)
	move	#$26,-(sp)
	trap	#14
	addq.l	#6,sp
	move.l	sav_usp(pc),sp
	bra	load
	
intro	bsr	save_all
	bsr	black
	bsr	set_reset
	bsr	prec_stars
	bsr	present
	bsr	set_scrs
	bsr	main_on
	bsr	pal_scr_on
loop	cmp.b	#$39,$fffffc02.w
	bne.s	loop
	bsr	pal_scr_off
	bsr	main_off
	bsr	choice
	bsr	re_inst
	rts

save_all	move.l	$24(a1),ssp+2
	lea	4(sp),a0
	move.l	a0,sp_reset
	move.l	$44e.w,sav_screen
	move.b	$ffff8260.w,sav_rez+1
	movem.l	$ffff8240.w,d0-d7
	movem.l	d0-d7,sav_pal
	lea	$fffffa01.w,a0
	lea	sav_mfp(pc),a1
	moveq	#$e,d0
cop_mfp	move.b	(a0)+,(a1)+
	lea	1(a0),a0
	dbf	d0,cop_mfp
	move.b	8(a0),(a1)+
	move.b	10(a0),(a1)+
	move.b	12(a0),(a1)+
	move.b	14(a0),(a1)+
	move.b	16(a0),(a1)+
	lea	$ffff8800.w,a0
	lea	yam_reset(pc),a1
	moveq	#$f,d0
cop_yam	move.b	d0,(a0)
	move.b	(a0),(a1)+
	dbf	d0,cop_yam
	move.l	$70.w,sav_vbl
	move.l	$120.w,sav_timer_b
	move.l	$114.w,sav_timer_c
	rts

main_on	move.w	#$2700,sr
	move.b	#1,$fffffa07.w	
	clr.b	$fffffa09.w
	move.b	#1,$fffffa0b.w
	clr.b	$fffffa0d.w
	move.b	#1,$fffffa13.w
	clr.b	$fffffa15.w
	clr.b	$fffffa1b.w
	bsr	set_music
	moveq	#num2_music,d0
	jsr	music
	move.b	#$40,$fffffa17.w
	move.b	#$74,$fffffa23.w
	move.l	#vbl,$70.w
	move.b	#$12,$fffffc02.w
	move.w	#$2300,sr
	rts
	
pal_scr_on	lea	pic+2,a2
	lea	pal_pic,a3
	moveq	#15,d6
	bsr	col_on
	lea	pal_fonts,a2
	lea	pal_fnts,a3
	moveq	#15,d6
	bsr	col_on
	rts

pal_scr_off	lea	pal_black(pc),a2
	lea	pal_fnts(pc),a3
	moveq	#15,d6
	bsr	col_off
	lea	pal_black(pc),a2
	lea	pal_pic(pc),a3
	moveq	#15,d6
	bsr	col_off
	rts
	
main_off	move.w	#$2700,sr
	bsr	music_off
	move.l	sav_timer_b(pc),$120.w
	move.l	#vbl_wait,$70.w
	move.w	#$2300,sr
	rts
	
music_off	lea	sav_mfp(pc),a0
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
	move.b	#$c0,$fffffa23.w
	move.l	sav_timer_c(pc),$114.w
	lea	$ffff8800.w,a0
	move.l	#$0707ffff,(a0)
	move.l	#$08080000,(a0)
	move.l	#$09090000,(a0)
	move.l	#$0a0a0000,(a0)
	rts
	
choice	bsr	vsync
	lea	scr1,a0
	move.l	a0,d0
	lsr.l	#8,d0
	move.b	d0,$ffff8203.w
	lsr.l	#8,d0
	move.b	d0,$ffff8201.w
	lea	pic_logo+34,a1
	move.w	#130*40-1,d0
cop_logo	move.l	(a1)+,(a0)+
	dbf	d0,cop_logo
	move.w	#270*40-1,d0
eff_pic	clr.l	(a0)+
	dbf	d0,eff_pic
	
	bsr	att_log
	
	move.w	#$2700,sr
	bsr	set_music
	moveq	#num3_music,d0
	jsr	music
	move.l	#play,$70.w
	move.b	#$40,$fffffa17.w
	move.b	#$74,$fffffa23.w
	move.w	#$2300,sr
	
	lea	pic_logo+2+2*7,a2
	lea	$ffff8240+2*7,a3
	moveq	#8,d6
	bsr	col_on
	
	bsr	att_log
	
	lea	pic_logo+2+2,a2
	lea	$ffff8240+2,a3
	moveq	#5,d6
	bsr	col_on
	
	bsr	att_log
	
	lea	pic_logo+34+160*130,a0
	lea	scr1+160*130,a1
	move.w	#69,d0
cop_60l_log	move.w	#39,d1
	bsr	vsync
cop_1l_log	move.l	(a0)+,(a1)+
	dbf	d1,cop_1l_log
	dbf	d0,cop_60l_log
	
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
	bne.s	tche
	move.b	#1,tst_tche
tche_ok	addq.b	#1,tst_tche	

	move.w	#$2700,sr
	bsr	music_off
	move.l	#vbl_wait,$70.w
	move.w	#$2300,sr
	
	lea	scr1,a0
	moveq	#24,d1
cop_h_s	bsr	vsync
	move.l	a0,d0
	lsr.l	#8,d0
	move.b	d0,$ffff8203.w
	lsr.l	#8,d0
	move.b	d0,$ffff8201.w
	lea	160*8(a0),a0
	dbf	d1,cop_h_s
	
	movem.l	pal_black(pc),d0-d7
	movem.l	d0-d7,$ffff8240.w
	
	bsr	att_log
	
	rts	
	
play	movem.l	d0-a6,-(sp)
	move.w	#1,tst_vsync
	jsr	music+4
	movem.l	(sp)+,d0-a6
	rte
	
att_log	move.l	#$2ffff,d0
sub_att	subq.l	#1,d0
	bne.s	sub_att	
	rts
	
re_inst	lea	white_pal(pc),a2
	lea	$ffff8240.w,a3
	moveq	#15,d6
	bsr	col_on
	move.w	#$2700,sr
	move.l	sav_vbl(pc),$70.w
	move.b	#$64,$fffffa09.w
	move.b	#$8,$fffffc02.w
	move.w	#$2300,sr
	move.w	sav_rez(pc),-(sp)
	move.l	sav_screen(pc),-(sp)
	move.l	(sp),-(sp)
	move.w	#5,-(sp)
	trap	#14
	lea	12(sp),sp
	movem.l	sav_pal(pc),d0-d7
	movem.l	d0-d7,$ffff8240.w
	move.b	#7,$484.w
	clr.l	$426.w
	clr.l	$42a.w
	rts	

set_reset	move.l	#$31415926,$426.w
	move.l	#jmp_reset,$42a.w
	rts

jmp_reset	move.l	sp_reset,a7
	move.w	#$2700,sr
	move.b	#$13,$fffffc02.w
	move.b	#$fe,$ffff820a.w
	clr.b	$ffff8260.w
	movem.l	pal_black(pc),d0-d7
	movem.l	d0-d7,$ffff8240.w
	lea	scr1,a0
	move.l	a0,d0
	lsr.l	#8,d0
	move.b	d0,$ffff8203.w
	lsr.l	#8,d0
	move.b	d0,$ffff8201.w
	move.w	#200*40-1,d0
eff_scr_reset	clr.l	(a0)+
	dbf	d0,eff_scr_reset
	lea	yam_reset(pc),a0
	lea	$ffff8800.w,a1
	moveq	#$f,d0
set_yam	move.b	d0,(a1)
	move.b	(a0)+,2(a1)
	dbf	d0,set_yam
	bsr	music_off
	bsr	set_music
	moveq	#num4_music,d0
	jsr	music
	move.l	#play,$70.w
	move.w	#$2300,sr
	lea	reset_text(pc),a6
	bsr	aff_text
	move.l	#$fffff,d0
loop_reset	subq.l	#1,d0
	bne.s	loop_reset
	clr.l	$42a.w
	clr.l	$426.w
	move.l	$4.w,a0
	jmp	(a0)
	
vsync	clr.w	tst_vsync
att_vsync	tst.w	tst_vsync
	beq.s	att_vsync
	rts
	
vbl_wait	move.w	#1,tst_vsync
	rte	
	
black	move.w	#$2700,sr
	move.l	#vbl_wait,$70.w
	move.w	#$2300,sr
	lea	pal_black(pc),a2
	lea	$ffff8240.w,a3
	moveq	#15,d6
	bsr	col_off
	bsr	vsync
	dc.w	$a00a
	clr.b	$484.w
	clr.b	$ffff8260.w
	lea	scr1,a0
	move.l	a0,d0
	lsr.l	#8,d0
	move.b	d0,$ffff8203.w
	lsr.l	#8,d0
	move.b	d0,$ffff8201.w
	move.w	#200*40-1,d0
eff_ecr	clr.l	(a0)+
	dbf	d0,eff_ecr
	rts
	
present	move.w	#$2700,sr
	bsr	set_music
	moveq	#num1_music,d0
	jsr	music
	move.l	#vbl_stars,$70.w
	move.b	#$40,$fffffa17.w
	move.b	#$74,$fffffa23.w
	move.b	#$13,$fffffc02.w
	move.w	#$2300,sr
	bsr	vsync
	movem.l	pal_stars(pc),d0-d3
	movem.l	d0-d3,$ffff8250.w
	
	lea	pal_stars(pc),a2
	lea	$ffff8240.w,a3
	moveq	#7,d6
	bsr	col_on
	
	lea	pro_text(pc),a6
	
loop_text	lea	pal_stars(pc),a2
	lea	$ffff8250.w,a3
	moveq	#7,d6
	bsr	col_off
	
	move.l	#$2ffff,d0
att_bl_txt	subq.l	#1,d0
	bne.s	att_bl_txt
	
	bsr	aff_text	
	
	move.l	#$affff,d0
att_txt	subq.l	#1,d0
	bne.s	att_txt
	
	tst.b	(a6)
	bne	loop_text
	
	lea	pal_stars(pc),a2
	lea	$ffff8250.w,a3
	moveq	#7,d6
	bsr	col_off
	
	lea	pal_black(pc),a2
	lea	$ffff8240.w,a3
	moveq	#15,d6
	bsr	col_off
	
	move.w	#$2700,sr
	move.l	#vbl_wait,$70.w
	bsr	music_off
	move.w	#$2300,sr
	bsr	vsync
	
	bsr	att_log
	
	rts
	
aff_text	lea	ltl_fnt,a1
	lea	scr1+160*92+6,a3
	
cop_1li	moveq	#0,d0
	move.b	(a6)+,d0
	cmp.b	#$20,d0
	bne	let
	move.w	#$40,d0
let	sub.b	#$40,d0
	mulu	#32,d0
	lea	0(a1,d0.l),a2
	move.l	a3,a4
	moveq	#15,d1
cop_let	move.w	(a2)+,(a4)
	lea	160(a4),a4
	dbf	d1,cop_let
	lea	8(a3),a3
	cmp.b	#1,(a6)
	bne.s	cop_1li
	addq.l	#1,a6
	
	lea	pal_text(pc),a2
	lea	$ffff8250.w,a3
	moveq	#7,d6
	bsr	col_on
	
	rts	
	
col_on	moveq	#7,d7
loop_col2	move.l	a2,a0
	move.l	a3,a1
	moveq	#3,d0
loop_col3	bsr	vsync
	dbf	d0,loop_col3
	move.l	d6,d0
loop_col1	moveq	#0,d1
	moveq	#0,d3
	move.w	(a0)+,d1
	and.w	#$777,d1
	move.w	(a1),d3
	and.w	#$777,d3
red	move.l	d1,d2
	move.l	d3,d4
	lsr.w	#8,d2
	lsr.w	#8,d4
	cmp.b	d2,d4
	bge.s	green
	add	#$100,d3
green	move.l	d1,d2
	move.l	d3,d4
	lsr.b	#4,d2
	lsr.b	#4,d4
	cmp.b	d2,d4
	bge.s	blue
	add	#$10,d3
blue	move.l	d1,d2
	move.l	d3,d4
	lsl.b	#4,d2
	lsr.b	#4,d2
	lsl.b	#4,d4
	lsr.b	#4,d4
	cmp.b	d2,d4
	bge.s	col_ct
	addq	#1,d3
col_ct	move	d3,(a1)+
	dbf	d0,loop_col1
	dbf	d7,loop_col2
	rts
	
col_off	moveq	#7,d7
loop_col2_b	move.l	a2,a0
	move.l	a3,a1
	moveq	#3,d0
loop_col3_b	bsr	vsync
	dbf	d0,loop_col3_b
	move.l	d6,d0
loop_col1_b	moveq	#0,d1
	moveq	#0,d3
	move.w	(a0)+,d1
	and.w	#$777,d1
	move.w	(a1),d3
	and.w	#$777,d3
red_b	move.l	d1,d2
	move.l	d3,d4
	lsr.w	#8,d2
	lsr.w	#8,d4
	cmp.b	d2,d4
	ble.s	green_b
	sub	#$100,d3
green_b	move.l	d1,d2
	move.l	d3,d4
	lsr.b	#4,d2
	lsr.b	#4,d4
	cmp.b	d2,d4
	ble.s	blue_b
	sub	#$10,d3
blue_b	move.l	d1,d2
	move.l	d3,d4
	lsl.b	#4,d2
	lsr.b	#4,d2
	lsl.b	#4,d4
	lsr.b	#4,d4
	cmp.b	d2,d4
	ble.s	col_ct_b
	subq	#1,d3
col_ct_b	move	d3,(a1)+
	dbf	d0,loop_col1_b
	dbf	d7,loop_col2_b
	rts
	
vbl_stars	movem.l	d0-a6,-(sp)
	move.w	#1,tst_vsync
	bsr	aff_stars
	jsr	music+4
	movem.l	(sp)+,d0-a6
	rte	
	
set_scrs	lea	pic+34,a0
	lea	scr1,a1
	lea	scr2,a2
	move.w	#200*40-1,d0
cop_pic	move.l	(a0),(a1)+
	move.l	(a0)+,(a2)+
	dbf	d0,cop_pic
	move.w	#45*40-1,d0
eff_over_bas	clr.l	(a1)+
	clr.l	(a2)+
	dbf	d0,eff_over_bas
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

vbl	movem.l	d0-a6,-(sp)
	bsr	init
	bsr	scroll
	bsr	anim_blk
	bsr	music+4
	movem.l	(sp)+,d0-a6
	rte

hbl	move.w	#$2700,sr
	movem.l	a0/d0,-(sp)
	lea	$fffffa21.w,a0
	move.b	(a0),d0
same_line	cmp.b	(a0),d0
	beq.s	same_line
	clr.b	$ffff820a.w
	dcb.w	18,$4e71
	move.b	#2,$ffff820a.w
	clr.b	$fffffa1b.w
	lea	pal_fnts(pc),a0
	move.l	(a0)+,$ffff8240.w
	move.l	(a0)+,$ffff8244.w
	move.l	(a0)+,$ffff8248.w
	move.l	(a0)+,$ffff824c.w
	move.l	(a0)+,$ffff8250.w
	move.l	(a0)+,$ffff8254.w
	move.l	(a0)+,$ffff8258.w
	move.l	(a0)+,$ffff825c.w
	movem.l	(sp)+,a0/d0
	move.w	#$2300,sr
	rte
	
init	move.w	#1,tst_vsync
	clr.b	$fffffa1b.w	
	move.b	#199,$fffffa21.w
	move.l	#hbl,$120.w
	move.b	#8,$fffffa1b.w		
	lea	scr(pc),a0
	move.l	(a0),sav_scr
	eor.w	#1,swap_ec
	tst.w	swap_ec
	beq.s	ec2
ec1	move.l	#scr2,(a0)
	bra.s	ec_sui
ec2	move.l	#scr1,(a0)
ec_sui	move.b	1(a0),$ffff8201.w
	move.b	2(a0),$ffff8203.w
	movem.l	pal_pic,d0-d7
	movem.l	d0-d7,$ffff8240.w
	rts

aff_stars	move.l	adr_pos_stars,a0
	lea	scr1,a1
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
	move.l	4(a0),a3
	move.l	a3,(a0)
no_bcle	move.w	(a3)+,d1
	move.w	(a3)+,d2
	lea	0(a1,d2.l),a2
	bset	d1,(a2)	
	addq.l	#8,a0	
	dbf	d0,loop_aff
	rts

scroll	lea	pt_scroll(pc),a0
	add.w	#1,(a0)
	cmp.w	#4,(a0)
	bne.s	let_ct
	clr.w	(a0)
	lea	text(pc),a0
	lea	pt_text(pc),a1
	adda.l	(a1),a0
	tst.b	(a0)
	bne.s	txt_sui
	clr.l	(a1)
	lea	text(pc),a0
txt_sui	addq.l	#1,(a1)
	moveq	#0,d0
	move.b	(a0),d0
	sub.w	#$20,d0
	mulu	#2,d0
	lea	table_letters(pc),a0
	adda.l	d0,a0
	moveq	#0,d0
	move.w	(a0),d0
	move.l	d0,a2
	lea	pos_letter(pc),a0
	move.l	(a0),a1
	move.l	a2,(a0)
	bra	aff_scroll
	
let_ct	lea	pos_letter(pc),a0
	move.l	(a0),d0
	move.l	d0,d1
	and.l	#-2,d1
	cmp.l	d0,d1
	bne.s	impair
pair	addq.l	#1,d1
	bra.s	txt_sui2
impair	addq.l	#8,d1
txt_sui2	move.l	d1,(a0)
	move.l	d0,a1
	move.l	d1,a2
	
aff_scroll	lea	fonts(pc),a0
	adda.l	a0,a1
	adda.l	a0,a2
	move.l	scr,a0
	lea	160*204(a0),a0
	moveq	#31,d0
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
	lea	16(a1),a1
	lea	16(a2),a2
	dbf	d0,cop_aff_scroll
	rts
	
anim_blk	subq.w	#1,att_blk
	bne.s	ret_blk
	move.w	#8,att_blk
	lea	blocks,a0
	move.l	scr,a1
	move.l	sav_scr,a2
	lea	160*80+40(a1),a1
	lea	160*80+40(a2),a2
	lea	pt_blk(pc),a3
	cmp.l	#3,(a3)
	bne.s	no_loop_blk
	clr.l	(a3)
no_loop_blk	move.l	(a3),d0
	addq.l	#1,(a3)
	mulu	#32*48,d0
	adda.l	d0,a0
	moveq	#47,d0
cop_blk	movem.l	(a0)+,d1-d7/a3
	movem.l	d1-d7/a3,(a1)
	movem.l	d1-d7/a3,(a2)
	lea	160(a2),a2
	lea	160(a1),a1
	dbf	d0,cop_blk
ret_blk	rts

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
 	move.w	#(rel_fin-rel_deb)/4,d0
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
	lea	8(a7),a2
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
	movem.l	-$300(a3),d0-d7/a0-a3
	movem.l	d0-d7/a1,p_tbase-36

error	pea	err_sup(pc)
	move	#$26,-(sp)
	trap	#14
	addq.l	#6,sp
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
pal_fonts	dc.w	$000,$110,$120,$130,$140,$150,$361,$111
	dc.w	$222,$333,$562,$444,$664,$555,$666,$767
pal_pic	dcb.w	16,0
pal_fnts	dcb.w	16,0
pal_text	dcb.w	8,$777
white_pal	dcb.w	16,$777
pal_black	dcb.w	16,0
	even
swap_ec	dc.w	0
scr	dc.l	scr1
sav_scr	dc.l	0
	even
tst_tche	dc.b	0
	even
table_letters	dc.w	16*32*45,16*32*36
	dcb.w	5,16*32*45
	dc.w	16*32*44,16*32*37,16*32*38
	dcb.w	2,16*32*45
	dc.w	16*32*40,16*32*39,16*32*41
	dc.w	16*32*45
	dc.w	16*32*0,16*32*1,16*32*2,16*32*3,16*32*4,16*32*5,16*32*6,16*32*7,16*32*8,16*32*9
	dc.w	16*32*42
	dcb.w	4,16*32*45
	dc.w	16*32*43
	dc.w	16*32*45
	dc.w	16*32*10,16*32*11,16*32*12,16*32*13,16*32*14,16*32*15,16*32*16,16*32*17,16*32*18,16*32*19
	dc.w	16*32*20,16*32*21,16*32*22,16*32*23,16*32*24,16*32*25,16*32*26,16*32*27,16*32*28,16*32*29
	dc.w	16*32*30,16*32*31,16*32*32,16*32*33,16*32*34,16*32*35
pt_scroll	dc.w	3
pt_text	dc.l	0
pos_letter	dc.l	16*32*45
text	DC.B	"   YEAHHHHH        F.I.D  :   FACTORY  IS  DEAD  !!!      MENU 100 IS THE REAL OCCASION TO MAKE THINGS CLEAR ABOUT A FEW FRENCH PEOPLE WHO PISS US OFF ....   FIRST OF ALL AND MAINLY FACTORY, AND WE ARE NOT THE ONLY ONES "
	DC.B	"WHO DO NOT LIKE THEM, JUST HAVE A LOOK AT THE PICTURE ...     ANYWAY THIS IS NOT THE ONLY OCCASION YOU'LL HAVE TO SEE DIS INTRO, JUST WATCH OUT FOR THE LATEST REPLICANTS CRACKS BY CAMEO FOR EXAMPLE ....       "
	DC.B	"  FACTORY THE NEW NAME IN THE BUSINESS ....  POOR LAMERS !!      FACTORY THE LAME NAME IN THE BUSINESS ...    WITH LAME CRACKS AND LAME MENUS, HOW COULD YA BE THE NEW NAME ??    FACTORY CAN ONLY BE ASSOCIATED WITH LAME "
	DC.B	"PRODUCTS ...        "
	dc.b	"   FUCK ALSO TO DEE NASTY.   HE DOESN'T DO ANYTHING AND JUST PISS OFF PEOPLE ...   LAST NEWS FROM PARIS : HE'S STILL TRYING "
	DC.B	"TO CRACK MATRIX MARAUDER ....   L A M E  !!     AND HE WANTS TO CREATE A NEW FRENCH CRACKING CREW SUPERIOR ...  AS FACTORY WANTED TOO ...   YOU MAY ALL LAUGH !!    HEY DEE NASTY, YOU'RE SO FRUSTRATED YOU SHOULD GO AND "
	DC.B	"SEE A PSYCHIATRIST ....            "
	DC.B	"    USUAL FUCK TO  Z U U L  FOR THEIR NEVERENDING LAME WORK AND LAME MENTALITY ....    AND TO JORDAN CORP ESPECIALLY LEX WHO PISS US OFF AND THINKS HE IS SUPERIOR TO EVERY "
	DC.B	"ONE ...  ( ACTUALLY HE'S 15 YEARS OLD AND IS LOST ALONE IN PARIS, HIS FATHER HAS BEEN LOOKING FOR HIM FOR 2 DAYS, IT IS TRUE !! )        ZUUL, FACTORY, DEE NASTY AND JORDAN CORP :   THE LATEST LAMERS ON THE HACKIN'ST "
	DC.B	"SCENE ....       IF YOU THINK THEY ARE LAME, YOU'RE SO RIGHT ...          "
	DC.B	"            ANYWAY FUCK OFF TO ANY PEOPLE WHO SLAG US ....   PRESS SPACE TO CONTINUE ...    WRAP TIME !                        "
	dc.b	0
	even
pro_text	DC.B	" IT IS THE TWENTYTH ",1
	DC.B	"       CENTURY      ",1
	DC.B	"  ALL THE FRANCE IS ",1
	DC.B	"  CONTROLLED BY FID ",1
	DC.B	"         BUT        ",1
	DC.B	"  A POOR VILLAGE OF ",1
	DC.B	" LAMERS STILL RESIST",1
	DC.B	"     TO THE FID     ",1
	DC.B	"      FOR THEM      ",1
	DC.B	"   THE END IS NEAR  ",1 
	DC.B	0
	even
reset_text	dc.b	"   HAVE A NICE DAY  ",1,0
	even
tst_vsync	dc.w	0
pt_blk	dc.l	0
att_blk	dc.w	1
	even
nom1	dc.b	"1.prg",0
	even
nom2	dc.b	"2.prg",0
	even
nom3	dc.b	"3.prg",0
	even	
adr_pos_stars	dc.l	buf_all
adr_buf_stars	dc.l	0
	even
sav_usp	ds.l	1
sp_reset	ds.l	1
sav_rez	ds.w	1
sav_screen	ds.l	1
sav_pal	ds.w	16
sav_mfp	ds.b	20
yam_reset	ds.b	16
sav_vbl	ds.l	1
sav_timer_b	ds.l	1
sav_timer_c	ds.l	1
	even
fonts	incbin	\orion.src\fuzion.cd\cd_100\fonts.dat
	even
ltl_fnt	dcb.w	16,0
	incbin	\orion.src\fuzion.cd\cd_100\ltl_fnt.dat
	even
music	incbin	\orion.src\fuzion.cd\cd_100\turric2.bin
	even
pic	incbin	\orion.src\fuzion.cd\cd_100\gaulle3.pi1
	even
blocks	incbin	\orion.src\fuzion.cd\cd_100\blocks.dat
	even
pic_logo	incbin	\orion.src\fuzion.cd\cd_100\cd100.pi1
	even
buf_all
	end