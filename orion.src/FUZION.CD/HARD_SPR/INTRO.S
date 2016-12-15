	*************************************
	* Intro      Hardscroll & Sprite    *
	* Coder      ORION from FUZION      *
	* Purpose    FUZION Compact Disks   *
	* Date       May 1991 - CD#59       *
	*                                   *
	* Machine    Atari STE - 1MB RAM    *	
	* TOS        1.62                   *
	* Assembler  GenST v2.09            *
	* Emulator   Steem v3.2             *
	*                                   *
	* Contact    Orion.Fuzion@gmail.com *
	*************************************

pause	=	$bffff
scr1	=	$50000	
scr2	=	scr1+$7d00*2+160*56
pos	=	160*10
nbr_spr	=	6	
hauteur	=	25	
decalage	=	5	

p_tbase	lea	pile+$140(pc),sp
	pea	intro(pc)
	move	#$26,-(sp)
	trap	#14
	addq	#6,sp
	bra	charge
		
intro	bsr	save_all
	bsr	col_off
	bsr	reset
	jsr	music
	bsr	set_scr1
	bsr	prec_sprs
	bsr	prec_col
	bsr	set_scr2
	bsr	inter_on
loop	cmp.b	#0,tche
	beq.s	loop	
	bsr	inter_off
	bsr	col_on
	rts

save_all	move.b	$ffff8260.w,d0
	move.b	d0,rez+1
	move.b	d0,rez2+3
	move.b	$ffff820a.w,hz
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
	lea	$8.w,a0
	lea	vecs,a1
	move.l	#252,d0
cop_vecs	move.l	(a0)+,(a1)+
	dbf	d0,cop_vecs
       	rts

col_off	move.l	#$777,d5
	moveq	#7,d7
col0	lea	$ffff8240.w,a5
	moveq	#15,d6
	move	#$25,-(sp)
	trap	#14
	addq	#2,sp
subcol	move.w	d5,(a5)+
	dbf	d6,subcol
	sub.w	#$111,d5
	dbf	d7,col0
	rts

reset	move.l	#$31415926,$426.w
	move.l	#res_jmp,$42a.w
	move.l	$70.w,vbl_s+2
	rts

res_jmp	lea	$77ff8,sp
	move.w	#$2700,sr
vbl_s	move.l	#$0,$70.w
	move.l	#ret_vbl,$120.w
	move.b	#2,$ffff820a.w
	clr	-(sp)
	pea	$78000
	move.l	(sp),-(sp)
	move	#5,-(sp)
	trap	#14
	lea	12(sp),sp
	clr.l	d0
	clr.l	d1
	clr.l	d2
	clr.l	d3
	clr.l	d4
	clr.l	d5
	clr.l	d6
	clr.l	d7
	movem.l	d0-d7,$ffff8240.w
	lea	$ffff8800.w,a0
	move.l	#$08080000,(a0)
	move.l	#$09090000,(a0)
	move.l	#$0a0a0000,(a0)
	pea	res_txt(pc)
	move	#9,-(sp)
	trap	#1
	addq	#6,sp
	move.w	#$777,$ffff825e.w
	clr.l	$426.w
	clr.l	$42a.w
res_blk	bra.s	res_blk
	
set_scr1	dc.w	$a00a
	move.b	#4,$484.w
	lea	$78000,a6
	clr	-(sp)
	pea	(a6)
	move.l	(sp),-(sp)
	move	#5,-(sp)
	trap	#14
	lea	12(sp),sp
	move.b	#$13,$fffffc02.w
	move.b	#2,$ffff820a.w
	lea	pres+34,a0
	move.w	#40*200-1,d0
cop_pres	move.l	(a0)+,(a6)+
	dbf	d0,cop_pres
	move.l	#$1ffff,d0
bcle2	subq.l	#1,d0
	bne.s	bcle2
	moveq	#7,d7
loop_col2	moveq	#3,d6
att_col	move	#$25,-(sp)
	trap	#14
	addq	#2,sp
	dbf	d6,att_col	
	lea	pres+2,a0
	lea	$ffff8240.w,a1
	moveq	#15,d0
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
	dbf	d7,loop_col2
	move.l	#pause,d0
bcle	subq.l	#1,d0
	bne.s	bcle
	moveq	#7,d7
loop_bl2	moveq	#3,d6
att_bl	move	#$25,-(sp)
	trap	#14
	addq	#2,sp
	dbra	d6,att_bl
	lea	$ffff8240.w,a1
	moveq	#15,d0
loop_bl1	clr.l	d1
	clr.l	d3
	move.w	(a1),d3
red2	move.l	d3,d4
	lsr.w	#8,d4
	and.b	#7,d4
	cmp.b	d1,d4
	ble.s	green2
	sub	#$100,d3
green2	move.l	d3,d4
	lsr.b	#4,d4
	and.b	#7,d4
	cmp.b	d1,d4
	ble.s	blue2
	sub	#$10,d3
blue2	move.l	d3,d4
	lsl.b	#4,d4
	lsr.b	#4,d4
	and.b	#7,d4
	cmp.b	d1,d4
	ble.s	bl_ct
	sub	#1,d3
bl_ct	move	d3,(a1)+
	dbf	d0,loop_bl1
	dbf	d7,loop_bl2
	rts
	
set_scr2	lea	scr1,a0
	lea	$80000,a1
eff_mem	clr.l	(a0)+
	cmpa.l	a0,a1
	bne.s	eff_mem	
	lea	pic+34,a0
	lea	160*196(a0),a3
	lea	scr1,a1
	lea	scr2,a4
	lea	160*4(a4),a2
	move.l	#40*200-1,d0
cop_ims	move.l	(a0),(a2)+
	move.l	(a0)+,(a1)+
	dbf	d0,cop_ims
	move.l	#40*4-1,d0
cop_4l	move.l	(a3)+,(a4)+
	dbf	d0,cop_4l
	bsr	hard
 	bsr	hard2
	bsr	aff_spr
	rts
	
prec_sprs	lea	fonts+34+165*160,a0
	lea	deca_sprs,a1
	moveq	#nbr_spr-1,d0
dec_4	moveq	#hauteur-1,d1
cop_let	movem.l	(a0),d4-d7
	movem.l	d4-d5,(a1)
	movem.l	d6-d7,12(a1)
	move.w	(a1)+,d3
	move.w	(a1)+,d4
	move.w	(a1)+,d5
	move.w	(a1)+,d6
	move	d3,d7
	or	d4,d7
	or	d5,d7
	or	d6,d7
	not	d7
	move.w	d7,(a1)+
	move.w	d7,(a1)+
	move.w	(a1)+,d3
	move.w	(a1)+,d4
	move.w	(a1)+,d5
	move.w	(a1)+,d6
	move	d3,d7
	or	d4,d7
	or	d5,d7
	or	d6,d7
	not	d7
	move.w	d7,(a1)+
	move.w	d7,(a1)+
	move.w	(a1)+,d3
	move.w	(a1)+,d4
	move.w	(a1)+,d5
	move.w	(a1)+,d6
	move	d3,d7
	or	d4,d7
	or	d5,d7
	or	d6,d7
	not	d7
	move.w	d7,(a1)+
	move.w	d7,(a1)+
	lea	160(a0),a0
	dbf	d1,cop_let
	lea	-hauteur*36(a1),a2
	moveq	#14,d1
dec_3	moveq	#hauteur-1,d2
dec_2	movem.l	(a2),d4-d5
	movem.l	12(a2),d6-d7
	movem.l	24(a2),a4-a5
	movem.l	d4-d5,(a1)
	movem.l	d6-d7,12(a1)
	movem.l	a4-a5,24(a1)
	clr.l	d4
	roxr	d4
	roxr	(a1)
	roxr	12(a1)
	roxr	24(a1)
	roxr	d4
	roxr	2(a1)
	roxr	14(a1)
	roxr	26(a1)
	roxr	d4
	roxr	4(a1)
	roxr	16(a1)
	roxr	28(a1)
	roxr	d4
	roxr	6(a1)
	roxr	18(a1)
	roxr	30(a1)
	move.w	(a1)+,d3
	move.w	(a1)+,d4
	move.w	(a1)+,d5
	move.w	(a1)+,d6
	move	d3,d7
	or	d4,d7
	or	d5,d7
	or	d6,d7
	not	d7
	move.w	d7,(a1)+
	move.w	d7,(a1)+
	move.w	(a1)+,d3
	move.w	(a1)+,d4
	move.w	(a1)+,d5
	move.w	(a1)+,d6
	move	d3,d7
	or	d4,d7
	or	d5,d7
	or	d6,d7
	not	d7
	move.w	d7,(a1)+
	move.w	d7,(a1)+
	move.w	(a1)+,d3
	move.w	(a1)+,d4
	move.w	(a1)+,d5
	move.w	(a1)+,d6
	move	d3,d7
	or	d4,d7
	or	d5,d7
	or	d6,d7
	not	d7
	move.w	d7,(a1)+
	move.w	d7,(a1)+
	lea	36(a2),a2
	dbf	d2,dec_2
	dbf	d1,dec_3
	lea	-(hauteur*160-16)(a0),a0
	dbf	d0,dec_4
	rts	

prec_col	lea	pic+2,a0
	lea	pal1+32,a1
	bsr	calc_col
	lea	fonts+2,a0
	lea	pal2+32,a1
	bsr	calc_col
	rts
	
calc_col	moveq	#7,d7
loop_col4	moveq	#15,d0
loop_col3	clr.l	d1
	clr.l	d3
	move.w	(a0)+,d1
	move.w	(a1),d3
red3	move.l	d1,d2
	move.l	d3,d4
	lsr.w	#8,d2
	and.b	#7,d2
	lsr.w	#8,d4
	and.b	#7,d4
	cmp.b	d2,d4
	bge.s	green3
	add.w	#$100,d3
green3	move.l	d1,d2
	move.l	d3,d4
	lsr.b	#4,d2
	and.b	#7,d2
	lsr.b	#4,d4
	and.b	#7,d4
	cmp.b	d2,d4
	bge.s	blue3
	add	#$10,d3
blue3	move.l	d1,d2
	move.l	d3,d4
	lsl.b	#4,d2
	lsr.b	#4,d2
	and.b	#7,d2
	lsl.b	#4,d4
	lsr.b	#4,d4
	and.b	#7,d4
	cmp.b	d2,d4
	bge.s	col_ct3
	add	#1,d3
col_ct3	move.w	d3,(a1)+
	dbf	d0,loop_col3
	movem.l	-32(a1),d0-d6/a2
	movem.l	d0-d6/a2,(a1)
	lea	-32(a0),a0
	dbf	d7,loop_col4
	rts

inter_on	move	#$25,-(sp)
	trap	#14
	addq	#2,sp
	move	#$2700,sr
	and.b	#$fe,$fffffa13.w
	and.b	#$fe,$fffffa0f.w
	and.b	#$fe,$fffffa0b.w
	and.b	#$fe,$fffffa07.w
	clr.b	$fffffa09.w
	move.l	#vbl,$70.w
	clr.l	$4d2.w
	or.b	#1,$fffffa07.w
	or.b	#1,$fffffa13.w
	bclr	#5,$fffffa09.w
	bclr	#4,$fffffa09.w
	bclr	#3,$fffffa17.w
	move.b	#$12,$fffffc02.w
	move.w	#$2300,sr
	rts

inter_off	move	#$2700,sr
	lea	vecs,a0
	lea	$8.w,a1
	move.l	#252,d0
set_vecs	move.l	(a0)+,(a1)+
	dbf	d0,set_vecs
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
	lea	$ffff8800.w,a0
	move.l	#$08080000,(a0)
	move.l	#$09090000,(a0)
	move.l	#$0a0a0000,(a0)
	move.b	hz,$ffff820a.w
	move.b	#$08,$fffffc02.w
	move.l	$42e.w,a0
	lea	-$8000(a0),a1
	move.l	a0,top_mem+2
	move	rez,-(sp)
	pea	(a1)
	move.l	(sp),-(sp)
	move	#$5,-(sp)
	trap	#14
	lea	$c(sp),sp
	clr.l	$426.w
	clr.l	$42a.w
	move.b	#7,$484.w
	dc.w	$a009
	move.w	#$2300,sr
	rts

col_on	clr.l	d5
	moveq	#7,d7
col777	lea	$ffff8240.w,a5
	moveq	#15,d6
	move	#$25,-(sp)
	trap	#14
	addq	#2,sp
addcol	move.w	d5,(a5)+
	dbf	d6,addcol
	add.w	#$111,d5
	dbf	d7,col777
	movem.l	pal,d0-d7
	movem.l	d0-d7,$ffff8240.w
	rts

hbl1	cmp.b	#48,pt_ligne
	bne.s	ret1
	move.b 	#$8,$fffffa1b.w
	move.b 	#1,$fffffa21.w
	move.l	#hbl2,$120.w
ret1	addq.b	#1,pt_ligne
	rte

hbl2	cmp.b	#51,pt_ligne
	bne.s	ret2
	move.l	d0,save_d0+2
	moveq	#37,d0
att4	dbf	d0,att4
	clr.b	$ffff820a.w
	moveq	#1,d0
att5	dbf	d0,att5
	move.b	#2,$ffff820a.w
	move.l	pal2+2,$ffff8242.w
	move.l	pal2+6,$ffff8246.w
	move.l	pal2+10,$ffff824a.w
	move.l	pal2+14,$ffff824e.w
	move.l	pal2+18,$ffff8252.w
	move.l	pal2+22,$ffff8256.w
	move.l	pal2+26,$ffff825a.w
	move.w	pal2+30,$ffff825e.w
save_d0	move.l	#0,d0
	move.b	#1,tst_low
	move.l	#hbl3,$120.w
ret2	addq.b	#1,pt_ligne
	rte

hbl3	cmp.b	#88,pt_ligne
	bne.s	ret3
	clr.l	$ffff8240.w
	clr.l	$ffff8244.w
	clr.l	$ffff8248.w
	clr.l	$ffff824c.w
	clr.l	$ffff8250.w
	clr.l	$ffff8254.w
	clr.l	$ffff8258.w
	clr.l	$ffff825c.w
ret3	addq.b	#1,pt_ligne
	rte

vbl	cmp.b	#0,tche
	bne.s	ret_vbl
	bsr	init_vbl
	bsr	hard
	bsr	aff_spr
	bsr	scroll
	bsr	hard2
	bsr	att_tche
	bsr	app_col
	jsr	music+$8
no_low	cmp.b	#1,tst_low
	bne.s	no_low
	bsr	eff_spr
ret_vbl	rte

init_vbl	clr.b	tst_low
	clr.b	pt_ligne
	movem.l	pal1,d0-d7
	movem.l	d0-d7,$ffff8240.w
	move.b 	#$8,$fffffa1b.w
	move.b 	#4,$fffffa21.w
	move.l	#hbl1,$120.w
	rts

hard	lea	scr,a0
	move.l	12(a0),16(a0)
	move.l	(a0),12(a0)
	cmp.b	#0,pt_ecr
	bne.s	ecr2
ecr1	add.l	#$500,scr+4
	cmp.l	#scr1+$7d00+$500,scr+4
	bne.s	ecr1_1
	move.l	#scr1+$500,scr+4
ecr1_1	move.l	scr+4,(a0)
	move.l	#sav1_sprs,pos_sav
	move.b	#1,pt_ecr
	bra.s	ecr_ct
ecr2	add.l	#$500,scr+8
	cmp.l	#scr2+$7d00+$500,scr+8
	bne.s	ecr2_2
	move.l	#scr2+$500,scr+8
ecr2_2	move.l	scr+8,scr
	move.l	#sav2_sprs,pos_sav
	clr.b	pt_ecr
ecr_ct	move.b	1(a0),$ffff8201.w
	move.b	2(a0),$ffff8203.w
	rts

aff_spr	move.l	pt_ver,a0
	cmpi.w	#$7f,(a0)
	bne.s	pt_ct1
	lea	sin_ver,a0
	move.l	a0,pt_ver
pt_ct1	move.l	pt_hor,a1
	cmpi.w	#$7f,(a1)
	bne.s	pt_ct2
	lea	sin_hor,a1
	move.l	a1,pt_hor
pt_ct2	lea	pos1_sprs,a2	
	lea	pos2_sprs,a6
	moveq	#nbr_spr-1,d0
cop_all	move.w	(a2),(a6)+
	move.l	2(a2),(a6)+
	move.w	(a0),d1
	add.w	d1,(a2)
mod8m	tst.w	(a2)
	bge.s	mod8p
	add.w	#16,(a2)
	subq.l	#8,2(a2)
	bra.s	mod8_ct
mod8p	cmpi.w	#15,(a2)
	ble.s	mod8_ct
	sub.w	#16,(a2)
	addq.l	#8,2(a2)
mod8_ct	clr.l	d1
	move.w	(a1),d1
	add.w	#16,d1
	mulu	#160,d1
	sub.l	#160*16,d1
	add.l	d1,2(a2)
	move.l	2(a2),d1
	move.l	scr,a4
	add.l	#pos,a4
	add.l	d1,a4
	move.w	(a2),d1
	mulu	#36*hauteur,d1
	lea	deca_sprs,a3
	move.l	pos_sav,a5
	add.l	d1,a3
	move.l	d0,d1
	move.l	d0,d2
	mulu	#16*36*hauteur,d1
	mulu	#24*hauteur,d2
	add.l	d1,a3
	add.l	d2,a5
	
	moveq	#hauteur-1,d1
cop_sprs	movem.l	(a4),d2-d7
	movem.l	d2-d7,(a5)
	
	movem.l	(a3)+,d2-d7
	and.l	d4,(a4)
	or.l	d2,(a4)+
	and.l	d4,(a4)
	or.l	d3,(a4)+
	
	and.l	d7,(a4)
	or.l	d5,(a4)+
	and.l	d7,(a4)
	or.l	d6,(a4)+
	
	movem.l	(a3)+,d2-d4
	and.l	d4,(a4)
	or.l	d2,(a4)+
	and.l	d4,(a4)
	or.l	d3,(a4)+
	
	lea	136(a4),a4
	lea	24(a5),a5
	dbf	d1,cop_sprs
	
cont	add.l	#decalage*2,a0
	cmp.l	#fin_ver,a0
	blt.s	fin_ct1
	sub.l	#fin_ver-sin_ver,a0
fin_ct1	add.l	#decalage*2,a1
	cmp.l	#fin_hor,a1
	blt.s	fin_ct2
	sub.l	#fin_hor-sin_hor,a1
fin_ct2	addq.l	#6,a2
	dbf	d0,cop_all
	addq.l	#2,pt_ver
	addq.l	#2,pt_hor
	rts

scroll	move.l	scr+16,a2
	add.l	#160*235,a2
	move.l	scr,a3
	add.l	#160*235,a3
pass_1	cmpi.b	#1,pt_pass
	bne.s	pass_2
	move.l	pos_l,a0
	bsr	aff_1
	move.b	#2,pt_pass
	bra.s	pass_cont
pass_2	cmpi.b	#2,pt_pass
	bne.s	pass_3
	move.l	pos_l,a1
	lea	1(a1),a1
	lea	7(a1),a0
	bsr	aff_2
	move.b	#3,pt_pass
	bra.s	pass_cont
pass_3	cmpi.b	#3,pt_pass
	bne.s	pass_4
	move.l	pos_l,a0
	lea	8(a0),a0
	bsr	aff_1
	move.b	#4,pt_pass
	bra.s	pass_cont
pass_4	move.l	pos_l,a1
	lea	9(a1),a1
	bsr	test
	addq.l	#1,pt_1
	move.l	a0,pos_l
	bsr	aff_2
	move.b	#1,pt_pass
pass_cont	rts

test	lea	text1,a0
	adda.l	pt_1,a0
	clr.l	d0
	move.b	(a0),d0
	tst.b	d0
	bne.s	space
	clr.l	pt_1
	bra.s	test
space	cmpi.b	#$20,d0
	bne.s	excla
	lea	fonts+34+160*33*4+16*8,a0
	bra	sui
excla	cmpi.b	#$21,d0
	bne.s	inter
	lea	fonts+34+160*33*3+16*8,a0
	bra	sui
inter	cmpi.b	#$3f,d0
	bne.s	dx_pts
	lea	fonts+34+160*33*3+16*9,a0
	bra	sui
dx_pts	cmpi.b	#$3a,d0
	bne.s	virg
	lea	fonts+34+160*33*4+16*2,a0
	bra	sui
virg	cmpi.b	#$2c,d0
	bne.s	par_g
	lea	fonts+34+160*33*4+16*4,a0
	bra	sui
par_g	cmpi.b	#$28,d0
	bne.s	par_d
	lea	fonts+34+160*33*3+16*6,a0
	bra	sui
par_d	cmpi.b	#$29,d0
	bne.s	tiret
	lea	fonts+34+160*33*3+16*7,a0
	bra	sui
tiret	cmpi.b	#$2d,d0
	bne.s	pt
	lea	fonts+34+160*33*4+16*0,a0
	bra	sui
pt	cmpi.b	#$2e,d0
	bne.s	guill
	lea	fonts+34+160*33*4+16*1,a0
	bra	sui
guill	cmpi.b	#$27,d0
	bne.s	chiffres
	lea	fonts+34+160*33*4+16*3,a0
	bra	sui
chiffres	cmpi.b	#$30,d0
	blt.s	unknow
	cmpi.b	#$39,d0
	bgt.s	lettres_1
	lea	fonts+34+160*33*0+16*0,a0
	subi.b	#$30,d0
	mulu	#$10,d0
	adda.l	d0,a0
	bra	sui
lettres_1	cmpi.b	#$41,d0
	blt.s	unknow
	cmpi.b	#$4b,d0
	bge.s	lettres_2
	subi.b	#$41,d0
	mulu	#$10,d0
	lea	fonts+34+160*33*1,a0
	adda.l	d0,a0
	bra	sui
lettres_2	cmpi.b	#$55,d0
	bge.s	lettres_3
	subi.b	#$4b,d0
	mulu	#$10,d0
	lea	fonts+34+160*33*2,a0
	adda.l	d0,a0
	bra	sui
lettres_3	cmp.b	#$5a,d0
	bgt.s	unknow
	subi.b	#$55,d0
	mulu	#$10,d0
	lea	fonts+34+160*33*3,a0
	adda.l	d0,a0
	bra	sui
unknow	lea	fonts+34+160*33*4+16*8,a0
sui	lea	31*160(a0),a0
	rts

aff_1	move.l	#31,d0
cop_AFF_1	movem.l	8(a2),d1-d7/a4-a6
	movem.l	d1-d7/a4-a6,(a3)
	movem.l	48(a2),d1-d7/a4-a6
	movem.l	d1-d7/a4-a6,40(a3)
	movem.l	88(a2),d1-d7/a4-a6
	movem.l	d1-d7/a4-a6,80(a3)
	movem.l	128(a2),d1-d7/a4
	movem.l	d1-d7/a4,120(a3)
	move.b	(a0),152(a3)
	move.b	1(a0),153(a3)
	move.b	2(a0),154(a3)
	move.b	3(a0),155(a3)
	move.b	4(a0),156(a3)
	move.b	5(a0),157(a3)
	move.b	6(a0),158(a3)
	move.b	7(a0),159(a3)
	lea	-160(a0),a0
	lea	-160(a2),a2
	lea	-160(a3),a3
	dbra	d0,cop_AFF_1
	rts

aff_2	move.l	#31,d0
cop_AFF_2	movem.l	8(a2),d1-d7/a4-a6
	movem.l	d1-d7/a4-a6,(a3)
	movem.l	48(a2),d1-d7/a4-a6
	movem.l	d1-d7/a4-a6,40(a3)
	movem.l	88(a2),d1-d7/a4-a6
	movem.l	d1-d7/a4-a6,80(a3)
	movem.l	128(a2),d1-d7/a4
	movem.l	d1-d7/a4,120(a3)
	move.b	(a1),152(a3)
	move.b	2(a1),154(a3)
	move.b	4(a1),156(a3)
	move.b	6(a1),158(a3)
	move.b	(a0),153(a3)
	move.b	2(a0),155(a3)
	move.b	4(a0),157(a3)
	move.b	6(a0),159(a3)
	lea	-160(a0),a0
	lea	-160(a1),a1
	lea	-160(a2),a2
	lea	-160(a3),a3
	dbra	d0,cop_AFF_2
	rts

hard2	move.l	scr,a0
	lea	160*192(a0),a1
	lea	-160*8(a0),a0
	moveq	#7,d0
cop_8l	movem.l	(a0)+,d1-d7/a2-a4
	movem.l	d1-d7/a2-a4,(a1)
	movem.l	(a0)+,d1-d7/a2-a4
	movem.l	d1-d7/a2-a4,40(a1)
	movem.l	(a0)+,d1-d7/a2-a4
	movem.l	d1-d7/a2-a4,80(a1)
	movem.l	(a0)+,d1-d7/a2-a4
	movem.l	d1-d7/a2-a4,120(a1)
	lea	160(a1),a1
	dbf	d0,cop_8l
	rept	40*4
	clr.l	(a1)+
	endr
	lea	32*160(a1),a1
	rept	40*2
	clr.l	(a1)+
	endr
	rts

att_tche	move.b	$fffffc02.w,d0
f1	cmp.b	#$3b,d0
	bne.s	f2
	move.l	#nom1,nom+2
	bra.s	tche_ok
f2	cmp.b	#$3c,d0
	bne.s	f3
	move.l	#nom2,nom+2
	bra.s	tche_ok
f3	cmp.b	#$3d,d0
	bne.s	esc
	move.l	#nom3,nom+2
	bra.s	tche_ok
esc	cmp.b	#$1,d0
	beq.s	tche_ok2
	rts

tche_ok	move.b	#1,tche
	rts
tche_ok2	move.b	#2,tche
	rts

app_col	cmp.b	#9,pt_col1
	beq	no_col2
	cmp.b	#4,pt_col2
	bne	no_col1
	clr.b	pt_col2
	addq.b	#1,pt_col1
	clr.l	d0
	move.b	pt_col1,d0
	mulu.w	#32,d0
	lea	pal1,a0
	lea	pal2,a1
	move.l	a0,a2
	move.l	a1,a3
	add.l	d0,a2
	add.l	d0,a3
	movem.l	(a2),d0-d7
	movem.l	d0-d7,(a0)
	movem.l	(a3),d0-d7
	movem.l	d0-d7,(a1)
no_col1	addq.b	#1,pt_col2
no_col2	rts
	
eff_spr	move.l	scr+12,a0
	add.l	#pos,a0
	lea	pos2_sprs+nbr_spr*6-4,a1
	cmp.b	#0,pt_ecr
	bne.s	sav_ct
	lea	sav1_sprs,a2
	bra.s	sav_ct2
sav_ct	lea	sav2_sprs,a2
sav_ct2	moveq	#nbr_spr-1,d0
cop_spr0	move.l	a0,a3
	adda.l	(a1),a3
	subq.l	#6,a1
	moveq	#hauteur-1,d1
cop_spr1	movem.l	(a2)+,d2-d7
	movem.l	d2-d7,(a3)
	lea	160(a3),a3
	dbf	d1,cop_spr1
	dbf	d0,cop_spr0
	rts

charge	cmp.b	#2,tche
	beq	quit
	move	#2,-(sp)
nom 	pea	0
 	move	#$3d,-(sp)
 	trap	#1
 	lea	8(sp),sp
 	move.l	d0,d7
 	tst.w	d0
 	bmi	error
top_mem 	lea	$0,a7
 	lea	-$300(a7),a1
 	lea	-$8000(a7),a7
 	move.l	#p_tbase-$100,-(a7)
 	clr.l	-(a7)
 	move.l	a7,save_reg+$3c
 	lea	rel_deb,a0
 	lea	p_tbase,a5
 	move.l	a5,save_reg+$38
	lea	-$1c(a5),a6
	move.l	a1,a2
 	move.l	#(rel_fin-rel_deb)/4+1,d0
cop_rel	move.l	(a0)+,(a1)+
 	dbf	d0,cop_rel
 	jmp	(a2)
 	
rel_deb	lea	save_reg(pc),a4
	bsr	char
	bsr	protec
	bsr	reloge
	bsr	calc_bp
eff_m	clr.l	(a3)+
	cmpa.l	a3,a7
	bgt.s	eff_m
	movem.l	(a4),d0-d7/a0-a7
	jmp	(a6)

char	pea	(a6)
 	pea	$ffffff
 	move.w	d7,-(sp)
 	move.w	#$3f,-(sp)
 	trap	#1
 	lea	12(sp),sp
 	tst.l	d0
 	bmi	error
 	move.l	a6,a0
 	add.l	d0,a0
 	clr.b	(a0)+
 	move.l	a0,d0
 	and.l	#-2,d0
 	move.l	d0,a0
 	move.l	d0,a3
 	clr.l	(a0)+
 	move.w	d7,-(sp)
 	move.w	#$3e,-(sp)
 	trap	#1
 	addq.l	#4,sp
 	tst.w	d0
 	bmi	error
 	rts
		
protec	cmpi.w	#$60fe,(a5)
	bne.s	rel_1
	move.w	4(a6),(a5)
	move.w	(a6),4(a6)
	rts
rel_1	cmpi.w	#$601a,(a6)
	bne.s	error
	rts

reloge	tst.w	$1a(a6)
	bne.s	rel_2
	move.l	a5,a0
	adda.l	2(a6),a0
	move.l	a0,$34(a4)
	adda.l	6(a6),a0
	adda.l	14(a6),a0
	move.l	a0,$30(a4)
	clr.l	d1
	move.l	a5,d2
	move.l	(a0)+,d0
	beq.s	rel_4
rel_3	add.l	d2,0(a5,d0.l)
rel_4	move.b	(a0)+,d1
	beq.s	rel_2
	add.l	d1,d0
	cmp.b	#1,d1
	bne.s	rel_3
	addi.l	#$fd,d0
	bra.s	rel_4
rel_2	rts

calc_bp	lea	-$100(a5),a0
	move.l	a5,d0
	move.l	2(a6),12(a0)
	add.l	12(a0),d0
	move.l	d0,16(a0)
	move.l	6(a6),20(a0)
	add.l	20(a0),d0
	move.l	d0,24(a0)
	move.l	10(a6),28(a0)
	rts

error	pea	err_sup(pc)
	move	#$26,-(sp)
	trap	#14
	addq	#6,sp
quit	clr.l	-(sp)
	trap	#1
	
err_sup	movem.l	$ffff8240.w,d0-d7
	movem.l	d0-d7,-(sp)
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
rez2	move.w	#0,-(sp)
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
	
	even
aff_mes	dc.b	27,"E",27,"Y",41,32,7
	dc.b	"                               - LOADING ERROR -",10,13
	dc.b	10,13
	dc.b	"                     - MAYBE YOU SHOULD RECOPY THIS DISK -",10,13
	dc.b	10,13
	dc.b	"                          - PRESS SPACE TO CONTINUE -",10,13
	dc.b	0
	even
save_reg	ds.l	16
rel_fin

	even
scr	dc.l	scr1
	dc.l	scr1
	dc.l	scr2
	dc.l	0
	dc.l	0
	even
pt_ecr	dc.b	1
tst_low	dc.b	0
pt_ligne	dc.b	0
tche	dc.b	0
	even
pt_ver	dc.l	sin_0
pt_hor	dc.l	sin_02
pos_sav	dc.l	0
sin_0	rept	decalage*nbr_spr
	dc.w	0
	endr
sin_ver	dc.w	1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6,7,7,7,7,8,8,8,8,8,8,8,7,7,7,7,6,6,6,6,5,5,5,5,4,4,4,4,3,3,3,3,2,2,2,2,1,1,1,1
	dc.w	-1,-1,-2,-2,-3,-3,-4,-4,-5,-5,-6,-6,-5,-5,-4,-4,-3,-3,-2,-2,-1,-1
	dc.w	1,1,2,2,3,3,4,4,5,5,6,6,5,5,4,4,3,3,2,2,1,1
	dc.w	-1,-1,-1,-1,-2,-2,-2,-2,-3,-3,-3,-3,-4,-4,-4,-4,-5,-5,-5,-5,-6,-6,-6,-6,-7,-7,-7,-7,-8,-8,-8,-8,-8,-8,-8,-7,-7,-7,-7,-6,-6,-6,-6
	dc.w	-5,-5,-5,-5,-4,-4,-4,-4,-3,-3,-3,-3,-2,-2,-2,-2,-1,-1,-1,-1
	dc.w	1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6,7,7,7,8,8,8,9,9,9,8,8,8,7,7,7,6,6,6,5,5,5,4,4,4,3,3,3,2,2,2,1,1,1
	dc.w	-1,-1,-1,-2,-2,-2,-3,-3,-3,-4,-4,-4,-5,-5,-5,-6,-6,-6,-7,-7,-7,-8,-8,-8,-9,-9,-9,-8,-8,-8,-7,-7,-7,-6,-6,-6,-5,-5,-5,-4,-4,-4,-3,-3,-3,-2,-2,-2,-1,-1,-1
	dc.w	1,1,2,2,3,3,4,4,5,5,6,6,5,5,4,4,3,3,2,2,1,1
	dc.w	-1,-1,-2,-2,-3,-3,-4,-4,-5,-5,-6,-6,-5,-5,-4,-4,-3,-3,-2,-2,-1,-1
	dc.w	1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6,7,7,7,7,8,8,8
	dc.w	8,8,8,7,7,7,7,6,6,6,6,5,5,5,5,4,4,4,4,3,3,3,3,2,2,2,2,1,1,1,1
	dc.w	-1,-1,-1,-1,-2,-2,-2,-2,-3,-3,-3,-3,-4,-4,-4,-4,-5,-5,-5,-5,-6,-6,-6,-6,-7,-7,-7,-7,-8,-8,-8,-8,-8,-8,-7,-7,-7,-7,-6,-6,-6,-6
	dc.w	-5,-5,-5,-5,-4,-4,-4,-4,-3,-3,-3,-3,-2,-2,-2,-2,-1,-1,-1,-1
	dc.w	1,1,2,2,3,3,4,4,5,5,6,6,7,7,6,6,5,5,4,4,3,3,2,2,1,1
	dc.w	-1,-1,-2,-2,-3,-3,-4,-4,-5,-5,-6,-6,-7,-7,-6,-6,-5,-5,-4,-4,-3,-3,-2,-2,-1,-1
fin_ver	dc.w	$7f
sin_02	rept	decalage*nbr_spr
	dc.w	0
	endr
sin_hor	dc.w	1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6,7,7,7,7,6,6,6,5,5,5,4,4,4,3,3,3,2,2,2,1,1,1
	dc.w	-1,-1,-2,-2,-3,-3,-4,-4,-4,-4,-3,-3,-2,-2,-1,-1
	dc.w	1,1,2,2,3,3,4,4,4,4,3,3,2,2,1,1
	dc.w	-1,-1,-1,-2,-2,-2,-3,-3,-3,-4,-4,-4,-5,-5,-5,-6,-6,-6,-7,-7,-7,-7,-6,-6,-6,-5,-5,-5,-4,-4,-4,-3,-3,-3,-2,-2,-2,-1,-1,-1
	dc.w	1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,7,7,6,6,5,5,4,4,3,3,2,2,1,1
	dc.w	-1,-1,-2,-2,-3,-3,-4,-4,-5,-5,-6,-6,-7,-7,-8,-8,-7,-7,-6,-6,-5,-5,-4,-4,-3,-3,-2,-2,-1,-1
	dc.w	1,1,2,2,3,3,4,4,4,4,3,3,2,2,1,1
	dc.w	-1,-1,-2,-2,-3,-3,-4,-4,-4,-4,-3,-3,-2,-2,-1,-1
	dc.w	1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6,7,7,7,7,6,6,6,5,5,5,4,4,4,3,3,3,2,2,2,1,1,1
	dc.w	-1,-1,-1,-2,-2,-2,-3,-3,-3,-4,-4,-4,-5,-5,-5,-6,-6,-6,-7,-7,-7,-7,-6,-6,-6,-5,-5,-5,-4,-4,-4,-3,-3,-3,-2,-2,-2,-1,-1,-1
fin_hor	dc.w	$7f
	even
pt_1	dc.l	0
pos_l	dc.l	fonts+34+160*33*5+16*8
pt_pass	dc.b	0
	even
text1	DC.B	" YO LAMERS !!!   THAT'S NOT TCB ... JUST  O R I O N !!!     "
	DC.B	"    GREAT NO ???   HARD SCROLL ( STF ... ) , BIG AND NICE SPRITES , SCROLLTEXT ( ALL THE PLANS ) IN THE BORDER !!!    "
	DC.B	" IT WAS VERY VERY VERY HARD BUT ...     FUCK !!!!!!!           FINISHED ...                     "
	DC.B	0
	even
nom1	dc.b	"a:\intro.prg",0
nom2	dc.b	"a:\auto\intro.prg",0
nom3	dc.b	"3",0
	even
res_txt	dc.b	27,"E",27,"Y",42,32
	dc.b	"         FUZION RULES FOR EVER !",10,13,0
	even
pt_col1	dc.b	0
pt_col2	dc.b	0
pal1	ds.l	8*10
pal2	ds.l	8*10
	even	
pile	ds.l	$80
pal	ds.l	8
vecs	ds.l	253
mfp	ds.b	20
rez	ds.w	1
hz	ds.b	1
	even	
pos1_sprs	ds.b	6*nbr_spr
pos2_sprs	ds.b	6*nbr_spr
sav1_sprs	ds.b	24*hauteur*nbr_spr
sav2_sprs	ds.b	24*hauteur*nbr_spr
deca_sprs	ds.b	nbr_spr*36*hauteur*16
	even
pres	incbin	\orion.src\fuzion.cd\hard_spr\logo.pi1
pic	incbin	\orion.src\fuzion.cd\hard_spr\pic.pi1
fonts	incbin	\orion.src\fuzion.cd\hard_spr\fonts.pi1
music	incbin	\orion.src\fuzion.cd\hard_spr\lap1.bin
	even
	end