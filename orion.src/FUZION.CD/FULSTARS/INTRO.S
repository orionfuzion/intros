	*************************************
	* Intro      Full Stars             *
	* Coder      ORION from FUZION      *
	* Usage      FUZION Compact Disks   *
	* Date       Nov 1991 - CD#96       *
	*                                   *
	* Machine    Atari STE - 1MB RAM    *	
	* TOS        1.62                   *
	* Assembler  GenST v2.09            *
	* Emulator   Steem v3.2             *
	*                                   *
	* Contact    Orion.Fuzion@gmail.com *
	*************************************

magic_number	=	$1234
largeur_centre	=	180
hauteur_centre	=	120
decalage_stars	=	50
nbr_stars	=	454 
numero_music	=	1
offset_music	=	8
voix_music	=	1
volume	=	13
scr	=	$70000
	
p_tbase	move.l	sp,save_usp
	lea	scr-$1000,sp
	pea	intro(pc)
	move	#$26,-(sp)
	trap	#14
	addq.l	#6,sp
	move.l	save_usp,sp
	bra	load
		
intro	bsr	save_all
	bsr	save_reset
	bsr	set_scr
	bsr	prec_colors
	bsr	prec_text
	bsr	prec_stars
	moveq	#numero_music,d0
	bsr	music
	bsr	set_scr2
	bsr	set_reset
	bsr	inter_on
loop	tst.w	tst_tche
	beq.s	loop
	bsr	clear
	rts
	
save_all	move.w	#$2700,sr
	move.l	$24(a1),set_usp+2
	move.b 	$ffff8260.w,rez+1
	move.l	$44e.w,screen
	movem.l	$ffff8240.w,d0-d7
	movem.l	d0-d7,save_pal
	move.l	$70.w,save_vbl
	move.b	$fffffa13.w,mfp1
	move.b	$fffffa15.w,mfp2
	move.b	$fffffa07.w,mfp3
	clr.b	$fffffa13.w
	clr.b	$fffffa15.w
	clr.b	$fffffa07.w
	move.b	#$12,$fffffc02.w
	move.l	#vbl_prec,$70.w
	move.w	#$2300,sr
	rts

save_reset	lea	4(sp),a0
	move.l	a0,sp_reset
	lea	$fffffa01.w,a0
	lea	mfp_reset(pc),a1
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
	rts
	
set_reset	move.l	#$31415926,$426.w
	move.l	#re_inst,$42a.w
	rts

re_inst	move.l	sp_reset,a7
	move.w	#$2700,sr
	move.b	#$fe,$ffff820a.w
	clr.b	$ffff8260.w
	move.l	#scr,d0
	lsr.l	#8,d0
	move.b	d0,$ffff8203.w
	lsr.l	#8,d0
	move.b	d0,$ffff8201.w
	movem.l	pal_stars,d0-d3
	movem.l	d0-d3,$ffff8240.w
	lea	yam_reset(pc),a0
	lea	$ffff8800.w,a1
	moveq	#$f,d0
set_yam	move.b	d0,(a1)
	move.b	(a0)+,2(a1)
	dbf	d0,set_yam
	lea	mfp_reset(pc),a0
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
	move.b	#$12,$fffffc02.w
	move.l	#vbl,$70.w
	move.w	#1,$452.w
	move.w	#$2300,sr
	bra	loop
	
set_scr	moveq	#7,d3
	move.w	#$777,d2
lp_col2	moveq	#2,d1
att1	bsr	vsync
	dbf	d1,att1
	lea	$ffff8240.w,a0
	moveq	#15,d0
lp_col1	move.w	d2,(a0)+
	dbf	d0,lp_col1
	sub.w	#$111,d2
	dbf	d3,lp_col2
	dc.w	$a00a
	clr	$484.w
	clr.b	$ffff8260.w
	lea	scr,a0
	move.l	a0,d0
	lsr.l	#8,d0
	move.b	d0,$ffff8203.w
	lsr.l	#8,d0
	move.b	d0,$ffff8201.w
	move.w	#40*200-1,d0
eff_scr1	clr.l	(a0)+
	dbf	d0,eff_scr1
	
	move.w	#$777,$ffff8242.w
	bsr	wait_nice
	
	rts

wait_nice	moveq	#20,d0
att3	bsr	vsync
	dbf	d0,att3
	rts
	
vsync	clr.w	wait_vbl
att_vbl	tst.w	wait_vbl
	beq.s	att_vbl
	rts
 
vbl_prec	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#1,wait_vbl
	bsr	big_num
	movem.l	(sp)+,d0-d7/a0-a6
 	rte
 
big_num	subq.w	#1,att_big
	bne.s	rt_big
	move.w	#25,att_big
	lea	fonts+8*21,a0
	suba.l	pos_big_fnt,a0
	addq.l	#8,pos_big_fnt
	lea	scr+10*160+8*2,a1
	moveq	#0,d1
	moveq	#0,d2
	not.w	d2
	moveq	#6,d4
lp_big2	moveq	#7,d0
	moveq	#7,d3
lp_big1	btst	d0,(a0)
	beq.s	aff_tr
	move.w	d2,d5
	bra.s	big_ct1
aff_tr	move.w	d1,d5
big_ct1	moveq	#24,d6
lp_big3	move.w	d5,(a1)
	move.w	d5,8(a1)
	lea	160(a1),a1
	dbf	d6,lp_big3
	lea	-25*160+16(a1),a1	
	subq.w	#1,d0
	dbf	d3,lp_big1
	lea	1(a0),a0
	lea	160*24+16*2(a1),a1
	dbf	d4,lp_big2
	
rt_big	rts
 
prec_colors	move.l	adr_buf_col,a0
	move.l	a0,d0
	add.l	#2*6*8*34,d0
	move.l	d0,adr_buf_text
	lea	deb_col,a1
	moveq	#33,d0
cop_col2	moveq	#7,d1
cop_col	move.w	(a1),(a0)+
	move.w	(a1),(a0)+
	move.w	(a1),(a0)+
	move.w	(a1),(a0)+
	move.w	(a1),(a0)+
	move.w	(a1)+,(a0)+
	dbf	d1,cop_col
	lea	-16(a1),a1
	dbf	d0,cop_col2
	
	rts

prec_text	move.l	adr_buf_text,a0
	move.l	a0,d0
	add.l	#(fin_text-text)*6,d0
	move.l	d0,adr_pos_stars
	moveq	#0,d0
	
	lea	text(pc),a1
	lea	166,a2
	move.l	a2,a3
	moveq	#7,d4
	
lp_txt	cmp.b	#1,(a1)
	beq	l_plus_1
	tst.b	(a1)
	beq	fin_txt
	move.l	a1,a4
	moveq	#0,d1
	moveq	#0,d2
lp_1lp	cmp.b	#1,(a4)
	beq.s	lp_1lp_stop	
	tst.b	(a4)+
	beq.s	lp_1lp_stop
	addq.w	#1,d1	
	bra.s	lp_1lp
lp_1lp_stop	neg.w	d1
	add.w	#52,d1
	divu	#2,d1
	move.w	d1,d2
	swap	d1
	add.w	d1,d2
	divu	#2,d2
	move.w	d2,d1
	swap	d2
	mulu	#8,d1
	add.w	d2,d1
	add.l	d1,a3
	
	tst.w	d2
	beq.s	lop_1l
	moveq	#1,d4
	
lop_1l	moveq	#0,d0
	move.b	(a1)+,d0
	sub.w	#$20,d0
	mulu	#8,d0
	move.w	d0,(a0)+
	move.l	a3,(a0)+
	eor.w	#6,d4
	add.l	d4,a3
	cmp.b	#1,(a1)
	beq.s	l_plus_1
	tst.b	(a1)
	bne.s	lop_1l
	
fin_txt 	move.w 	#-1,(a0)+
	move.l	#-10*230,(a0)
	rts
	
l_plus_1	lea	230*8(a2),a2
	move.l	a2,a3
	lea	1(a1),a1
	moveq	#7,d4
	bra	lp_txt

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
	add.w	#224,d5
	ext.l	d5
	add.w	#130,d6
	cmp.w	#447,d5
	bhi.s	star_next
	cmp.w	#259,d6
	bhi.s	star_next
	mulu	#230,d6
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

set_scr2	move.w	#-1,att_big
	bsr	wait_nice
	clr	$ffff8242.w
	lea	scr,a0
	move.w	#115*136-1,d0
eff_scr2	clr.l	(a0)+
	dbf	d0,eff_scr2
	movem.l	pal_stars,d0-d3
	movem.l	d0-d3,$ffff8240.w 
	bsr	wait_nice
	
	rts
	
inter_on	move.w	#$2700,sr
	move.l	#vbl,$70.w
	move.w	#$2300,sr
	rts
	
clear	move.w	#$2700,sr
	move.l	save_vbl,$70.w
	move.b	mfp1,$fffffa13.w
	move.b	mfp2,$fffffa15.w
	move.b	mfp3,$fffffa07.w
	move.b	#$8,$fffffc02.w
	lea	$ffff8800.w,a0
	move.l	#$08080000,(a0)
	move.l	#$09090000,(a0)
	move.l	#$0a0a0000,(a0)
	clr.l	$426.w
	clr.l	$42a.w
	
	moveq	#7,d7
	moveq	#0,d6
lp_col3	lea	$ffff8240.w,a6
	moveq	#15,d5
lp_col4	move.w	d6,(a6)+
	dbf	d5,lp_col4
	moveq	#2,d4
att2	move	#$25,-(sp)
	trap	#14
	lea	2(sp),sp
	dbf	d4,att2
	add.w	#$111,d6
	dbf	d7,lp_col3
	
	move.w	rez,-(sp)
	move.l	screen,-(sp)
	move.l	(sp),-(sp)
	move	#5,-(sp)
	trap	#14
	lea	12(sp),sp
	
	movem.l	save_pal,d0-d7
	movem.l	d0-d7,$ffff8240.w
	move.b	#7,$484.w
	move.w	#$2300,sr
	rts

vbl	lea	$ffff8260.w,a5		
	lea	$ffff820a.w,a6	
	lea	$ffff8250.w,a0
	move.l	adr_buf_col,a4
	move.l	a0,d5	
	moveq	#0,d6		
	moveq	#2,d7		
	
	move.w	#1430,d0
wait_o_h	dbf	d0,wait_o_h
	nop
	
	move.b	d6,(a6)
	dcb.w	9,$4e71
	move.b	d7,(a6)
	
	moveq	#14,d2
	lea	-1(a6),a6
	move.b	(a6),d0
wait_scan	move.b	(a6),d1
	cmp.b	d0,d1
	beq.s	wait_scan
	and.b	#%00011111,d1
	sub.b	d1,d2
	lsl.b	d2,d1
	lea	1(a6),a6

	dcb.w	93-2-9-1,$4e71
	
	move.l	adr_pos_stars,a0
	lea	scr+160,a1	
	moveq	#0,d2	
 	move.w	#226,d0	
	
loop_aff	move.l	d5,a2
	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)

	move.l	(a4)+,(a2)+
	move.l	(a4)+,(a2)+
	move.l	(a4)+,(a2)+
	
	move.l	(a0),a3	
	move.w	(a3)+,d1	
	move.w	(a3)+,d2	
	lea	0(a1,d2.l),a2	
	bclr	d1,(a2)	
	addq.l	#4,(a0)	
	cmp.l	12(a0),a3	
	bne	no_bcle1	
	move.l	4(a0),a3	
	move.l	a3,(a0)	
	move.w	(a3)+,d1	
	move.w	(a3)+,d2	
	lea	0(a1,d2.l),a2	
	bset	d1,(a2)	
	addq.l	#8,a0	
	
	move.l	(a0),a3	
	move.w	(a3)+,d1	
	move.w	(a3)+,d2	
	lea	0(a1,d2.l),a2	
	bclr	d1,(a2)	
	addq.l	#4,(a0)	
	cmp.l	12(a0),a3	
	bne	no_bcle2	
	
	move.b	d6,(a6)
	move.b    	d7,(a6)
	
	move.l	4(a0),a3	
	move.l	a3,(a0)	
	move.w	(a3)+,d1	
	move.w	(a3)+,d2	
	addq.l	#8,a0	
	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	
	nop		
	lea	0(a1,d2.l),a2	
	bset	d1,(a2)	
	dbf	d0,loop_aff	
	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	bra	stars_sui
	
	rte
	
no_bcle1	dcb.w	8,$4e71	
	move.w	(a3)+,d1	
	move.w	(a3)+,d2	
	lea	0(a1,d2.l),a2	
	bset	d1,(a2)	
	addq.l	#8,a0	
	
	move.l	(a0),a3	
	move.w	(a3)+,d1	
	move.w	(a3)+,d2	
	lea	0(a1,d2.l),a2	
	bclr	d1,(a2)	
	addq.l	#4,(a0)	
	cmp.l	12(a0),a3	
	bne	no_bcle2	
	
	move.b	d6,(a6)
	move.b    	d7,(a6)
	
	move.l	4(a0),a3	
	move.l	a3,(a0)	
	move.w	(a3)+,d1	
	move.w	(a3)+,d2	
	addq.l	#8,a0	
	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	
	nop		
	lea	0(a1,d2.l),a2	
	bset	d1,(a2)	
	dbf	d0,loop_aff	
	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	bra	stars_sui
	
	rte
	
no_bcle2	nop 
	move.b	d6,(a6)
	move.b    	d7,(a6)
	
	dcb.w	7,$4e71	
	move.w	(a3)+,d1	
	move.w	(a3)+,d2	
	addq.l	#8,a0	
	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	
	nop		
	lea	0(a1,d2.l),a2	
	bset	d1,(a2)	
	dbf	d0,loop_aff
	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	bra	stars_sui
	
	rte
	
stars_sui	move.l	d5,a2
	move.l	(a4)+,(a2)+
	move.l	(a4)+,(a2)+
	move.l	(a4)+,(a2)+
	dcb.w	89-3-16,$4e71
	move.b	d6,(a6)
	move.b	d7,(a6)
	dcb.w	13,$4e71
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	
	move.b	d6,(a6)
	dcb.w	9,$4e71
	move.b	d7,(a5)
	move.b	d7,(a6)
	move.b	d6,(a5)
	move.l	d5,a2
	move.l	(a4)+,(a2)+
	move.l	(a4)+,(a2)+
	move.l	(a4)+,(a2)+
	dcb.w	89-16,$4e71
	move.b	d6,(a6)
	move.b	d7,(a6)
	dcb.w	13,$4e71
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	dcb.w	12-2,$4e71
	
	move.w	#32,d0
	
loop_full2	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	move.l	d5,a2
	move.l	(a4)+,(a2)+
	move.l	(a4)+,(a2)+
	move.l	(a4)+,(a2)+
	dcb.w	89-16,$4e71
	move.b	d6,(a6)
	move.b	d7,(a6)
	dcb.w	13,$4e71
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	dcb.w	12-3,$4e71
	dbf	d0,loop_full2
	
	bsr	tche
	bsr	aff_text
	bsr	music+offset_music
	bsr	vu_cligne
	
	rte
	
tche	move.b	$fffffc02.w,d0
f1	cmp.b	#$3b,d0
	bne.s	f2
	move.l	#nom1,nom+2
	bra	tche_on
f2	cmp.b	#$3c,d0
	bne.s	f3
	move.l	#nom2,nom+2
	bra	tche_on	
f3	cmp.b	#$3d,d0
	bne.s	return
	move.l	#nom3,nom+2
	bra	tche_on
return	cmp.b	#$1c,d0
	bne.s	tche_off
	move.w	#2,tst_tche
	bra.s	tche_on_2
tche_on	move.w	#1,tst_tche
tche_on_2	move.l	save_vbl,$70.w
tche_off	rts

aff_text	subq.w	#1,att_text
	bne	rt_text
	move.w	#3,att_text
	move.l	adr_buf_text,a0
	lea	pt_text,a1
	adda.l	(a1),a0
	cmp.w	#-1,(a0)
	beq.s	rt_text
	addq.l	#6,(a1)
	moveq	#0,d0
	move.w	(a0)+,d0
	lea	fonts,a1
	adda.l	d0,a1
	lea	scr,a2
	move.l	a2,a3
	adda.l	(a0),a2
	adda.l	6(a0),a3
	move.b	(a1)+,(a2)
	move.b	(a1)+,230(a2)
	move.b	(a1)+,230*2(a2)
	move.b	(a1)+,230*3(a2)
	move.b	(a1)+,230*4(a2)
	move.b	(a1)+,230*5(a2)
	move.b	(a1)+,230*6(a2)
	move.b	(a1)+,230*7(a2)
	
	move.b	#$7f,d1
	move.b	d1,230*0(a3)
	move.b	d1,230*1(a3)
	move.b	d1,230*2(a3)
	move.b	d1,230*3(a3)
	move.b	d1,230*4(a3)
	move.b	d1,230*5(a3)
	move.b	d1,230*6(a3)
	
rt_text	rts
	
vu_cligne	lea	$ffff8800.w,a0
	move.b	#8+voix_music-1,(a0)
	move.b	(a0),d0
	cmp.b	#volume,d0
	blt.s	light_off
	move.b	#$e,(a0)
	move.b	#0,2(a0)
	rts
light_off	move.b	#$e,(a0)
	move.b	#2,2(a0)
cligne_ret	rts
	
load	cmp.w	#1,tst_tche
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
set_usp	move.l	#0,0(a6)
	move.l	a1,6(a6)
	movem.l	-500(a3),d0-d7/a0-a3
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
adr_buf_col	dc.l	buffer
adr_buf_text	dc.l	0
adr_pos_stars	dc.l	0
adr_buf_stars	dc.l	0
	even
pal_stars	dc.w	$000,$222,$444,$444,$666,$666,$666,$666
deb_col	dc.w 	$023,$034,$045,$056,$045,$034,$023,$012
	even
wait_vbl	dc.w	0
pos_big_fnt	dc.l	0
att_big	dc.w	60
tst_tche	dc.w	0
fonts	dc.b	$00,$00,$00,$00,$00,$00,$00,$00
	dc.b	$18,$18,$18,$18,$00,$18,$00,$00
	dc.b	$66,$66,$66,$00,$00,$00,$00,$00
	dc.b	$66,$ff,$66,$66,$ff,$66,$00,$00
	dc.b	$3e,$60,$3c,$06,$7c,$18,$00,$00
	dc.b	$66,$6c,$18,$30,$66,$46,$00,$00
	dc.b	$38,$6c,$38,$70,$de,$cc,$76,$00
	dc.b	$38,$38,$38,$18,$30,$00,$00,$00
	dc.b	$0e,$1c,$18,$18,$1c,$0e,$00,$00
	dc.b	$70,$38,$18,$18,$38,$70,$00,$00
	dc.b	$66,$3c,$ff,$3c,$66,$00,$00,$00
	dc.b	$18,$18,$7e,$18,$18,$00,$00,$00
	dc.b	$00,$00,$00,$00,$18,$18,$30,$00
	dc.b	$00,$00,$7e,$00,$00,$00,$00,$00
	dc.b	$00,$00,$00,$00,$18,$18,$00,$00
	dc.b	$06,$0c,$18,$30,$60,$40,$00,$00
	dc.b	$7c,$e6,$ee,$f6,$fe,$fe,$7c,$00
	dc.b	$38,$78,$38,$38,$fe,$fe,$fe,$00
	dc.b	$7c,$ce,$1c,$78,$fe,$fe,$fe,$00
	dc.b	$7e,$06,$1c,$c6,$fe,$fe,$7c,$00
	dc.b	$1c,$3c,$7c,$dc,$fe,$fe,$1c,$00
	dc.b	$fe,$e0,$fc,$06,$e6,$fe,$7c,$00
	dc.b	$7c,$e0,$fc,$e6,$fe,$fe,$7c,$00
	dc.b	$fe,$0e,$1e,$3c,$7c,$f8,$f8,$00
	dc.b	$7c,$ee,$7c,$ee,$fe,$fe,$7c,$00
	dc.b	$7c,$e6,$7e,$0e,$fe,$fc,$f8,$00
	dc.b	$38,$38,$38,$00,$38,$38,$38,$00
	dc.b	$00,$18,$18,$00,$18,$18,$30,$00
	dc.b	$0c,$18,$30,$18,$0c,$06,$00,$00
	dc.b	$00,$fe,$fe,$00,$fe,$fe,$00,$00
	dc.b	$30,$18,$0c,$18,$30,$60,$00,$00
	dc.b	$3c,$66,$0c,$18,$00,$18,$00,$00
	dc.b	$3c,$66,$6e,$6e,$60,$7e,$3e,$00
	dc.b	$38,$7c,$6c,$c6,$de,$de,$de,$00
	dc.b	$f8,$cc,$f8,$cc,$fe,$fe,$fc,$00
	dc.b	$7c,$e6,$c0,$e6,$fe,$fe,$7c,$00
	dc.b	$f8,$ec,$e6,$ee,$fe,$fe,$fc,$00
	dc.b	$f0,$c0,$f8,$c0,$fe,$fe,$fe,$00
	dc.b	$fe,$f0,$fc,$f0,$f0,$f0,$f0,$00
	dc.b	$7c,$e0,$ec,$e6,$fe,$fe,$7c,$00
	dc.b	$e6,$e6,$e6,$fe,$e6,$e6,$e6,$00
	dc.b	$fe,$38,$38,$38,$fe,$fe,$fe,$00
	dc.b	$06,$06,$e6,$e6,$fe,$fe,$7c,$00
	dc.b	$e4,$ec,$f8,$f8,$fc,$ee,$ee,$00
	dc.b	$c0,$c0,$c0,$c0,$fe,$fe,$fe,$00
	dc.b	$c6,$ee,$fe,$fe,$fe,$e6,$e6,$00
	dc.b	$e6,$e6,$f6,$fe,$fe,$ee,$e6,$00
	dc.b	$7c,$e6,$e6,$e6,$fe,$fe,$7c,$00
	dc.b	$fc,$e6,$e6,$fe,$fc,$f0,$f0,$00
	dc.b	$7c,$e6,$e6,$ee,$fc,$fe,$7e,$00
	dc.b	$fc,$e6,$e6,$fe,$fc,$ee,$ee,$00
	dc.b	$7c,$e0,$7c,$0e,$fe,$fe,$fc,$00
	dc.b	$fe,$fe,$fe,$38,$38,$38,$38,$00
	dc.b	$e6,$e6,$e6,$e6,$fe,$fe,$fe,$00
	dc.b	$e6,$e6,$e6,$e6,$7c,$7c,$38,$00
	dc.b	$e6,$e6,$e6,$fe,$fe,$ee,$c6,$00
	dc.b	$e6,$e6,$3c,$3c,$fe,$e6,$e6,$00
	dc.b	$e6,$e6,$fe,$7c,$38,$38,$38,$00
	dc.b	$7e,$1c,$38,$70,$fe,$fe,$fe,$00
	even
pt_text	dc.l	0
att_text	dc.w	3
text	dc.b	1
	dc.b	"THE MEGAMIGHTY FUZION PRESENTS",1
	dc.b	1
	dc.b	"- THE CD#94 -",1
	dc.b	1
	dc.b	"WHICH CONTAINS THE FOLLOWING GAMES :",1
	dc.b	1
	dc.b	"F1 - BOSTON BOMB CLUB",1
	dc.b	1
	dc.b	"F2 - WILD WHEELS",1
	dc.b	1
	dc.b	"BOSTON BOMB CLUB WAS CRACKED BY M.C.A.",1
	dc.b	"WILD WHEELS WAS CRACKED BY SNAKE OF THE REPLICANTS",1
	dc.b	"AND PACKED BY ORION FROM FUZION",1
	dc.b	1
	dc.b	"THIS LITTLE INTRO WAS DONE BY ORION FROM FUZION",1
	dc.b	1
	dc.b	"THE MEMBERS OF FUZION ARE : DRAGON, ORION, KELVIN",1
	dc.b	"KASAR, ETERNAL, MACDOS, SQUAT, FULCRUM, INFIRMIER",1
	dc.b	"DOCNO, KELLY X, SHIRYU AND DIEU",1
	dc.b	1 
	dc.b	"WE SEND OUR GREETINGS TO : THE REPLICANTS",1
	dc.b	"(CAMEO, SNAKE, ST WAIKIKI, MAXI, ILLEGAL)",1 
	dc.b	"AWESOME, SYNDICATE, POMPEY PIRATES, REANIMATORS",1
	dc.b	"FOF, XENEX, WILD BOYS, RIPPED OFF, INNER CIRCLE",1
	dc.b	"BBC, VMAX, ST-CONNEXION, HOTLINE, BLUE MAX, CELTIK",1
	dc.b	"IMPACT, BUSHWACKERS, EQUINOX, THUNDERBIRDS, CONAN",1
 	dc.b	"FUTURE MINDS, LOST BOYS, VOYAGERS AND THE OTHERS ...",1   
 	dc.b	1
 	dc.b	"CONTACT US AT : FUZION B.P 66 59420 MOUVAUX FRANCE",1
 	dc.b	1
 	dc.b	"FUZION RULES FOR EVER !!!" 
fin_text	dc.b	0
	even
nom1	dc.b	"1",0
	even
nom2	dc.b	"2",0
	even
nom3	dc.b	"3",0
 	even
ssp	ds.l	1
save_usp	ds.l	1
sp_reset	ds.l	1
rez	ds.w	1
screen	ds.l	1
save_pal	ds.l	8
save_vbl	ds.l	1
mfp1	ds.b	1
mfp2	ds.b	1
mfp3	ds.b	1
mfp_reset	ds.b	20
yam_reset	ds.b	16
	even
music	incbin	\orion.src\fuzion.cd\fulstars\joch3.bin
	even
buffer
	end	