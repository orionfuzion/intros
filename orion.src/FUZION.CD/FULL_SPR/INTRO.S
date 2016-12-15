	*************************************
	* Intro      Fullscreen & Sprite    *
	* Coder      ORION from FUZION      *
	* Purpose    FUZION Compact Disks   *
	* Date       Oct 1991 - CD#91       *
	*                                   *
	* Machine    Atari STE - 1MB RAM    *	
	* TOS        1.62                   *
	* Assembler  GenST v2.09            *
	* Emulator   Steem v3.2             *
	*                                   *
	* Contact    Orion.Fuzion@gmail.com *
	*************************************
	
magic_number	=	$1973
scr1	=	$e0000
scr2	=	scr1+$10000
pos_ver	=	6
pos_hor	=	64
pos_scr	=	203
numero_music	=	1
offset_music	=	$6
voix_music	=	1
volume	=	13
	
p_tbase	move.l	sp,save_usp
	lea	scr1-$1000,sp
	pea	intro(pc)
	move	#$26,-(sp)
	trap	#14
	addq.l	#6,sp
	move.l	save_usp,sp
	jmp	load
		
intro	bsr	save_all
	bsr	reset
	bsr	present
	bsr	set_scr
	bsr	pre_dec_spr
	bsr	pre_sin_ver
	bsr	pre_sin_hor
	bsr	pre_txt
	bsr	pre_scr_ver
	moveq	#numero_music,d0
	jsr	music
	bsr	inter_on
loop	tst.b	tst_tche
	beq.s	loop
	bsr	clear
	rts
	
save_all	move.w	#$2700,sr
	move.l	$24(a1),ssp+2
	move.b	$ffff8260.w,rez+1
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
	move.w	#$2300,sr
	rts

present	move	#$777,d6
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
	move.l	#$40000,d0
att0	subq.l	#1,d0
	bne.s	att0
	
	dc.w	$a00a
	move.b	#6,$484.w
	clr	-(sp)
	pea	scr1
	move.l	(sp),-(sp)
	move	#5,-(sp)
	trap	#14
	lea	12(sp),sp
	lea	pres,a0
	bsr	effet_col
	rts

effet_col	lea	scr1+160*90,a1
	move.w	#20*20-1,d0
cop_pres	move.l	(a0)+,(a1)
	lea	8(a1),a1
	dbf	d0,cop_pres
	
	moveq	#0,d6
	moveq	#7,d7
cop_col1	moveq	#4,d5
vsync1	move	#$25,-(sp)
	trap	#14
	addq	#2,sp
	dbf	d5,vsync1
	move.w	d6,$ffff8242.w
	move.w	d6,$ffff8246.w
	add.w	#$111,d6
	dbf	d7,cop_col1
	move.l	#$80000,d0
att1	subq.l	#1,d0
	bne.s	att1
	
	moveq	#0,d6
	moveq	#7,d7
	move	#$777,d5
cop_col2	moveq	#4,d4
vsync2	move	#$25,-(sp)
	trap	#14
	addq	#2,sp
	dbf	d4,vsync2
	move.w	d5,$ffff8242.w
	move.w	d6,$ffff8244.w
	add.w	#$111,d6
	sub.w	#$111,d5
	dbf	d7,cop_col2
	move.l	#$80000,d0
att2	subq.l	#1,d0
	bne.s	att2
	
	moveq	#7,d7
	move	#$777,d6
cop_col3	moveq	#5,d5
vsync3	move	#$25,-(sp)
	trap	#14
	addq	#2,sp
	dbf	d5,vsync3
	move.w	d6,$ffff8244.w
	move.w	d6,$ffff8246.w
	sub.w	#$111,d6
	dbf	d7,cop_col3
	
	rts
	
set_scr	lea	scr1,a0
	lea	scr2,a1
	move.w	#$3fff,d0
eff_mem	clr.l	(a0)+
	clr.l	(a1)+
	dbf	d0,eff_mem
	lea	pic+32,a0
	lea	scr1+160,a1
	lea	scr2+160,a2
	move	#11499,d0
cop_im	move.l	(a0),(a1)+
	move.l	(a0)+,(a2)+
	dbf	d0,cop_im
	move.l	#scr1,d0
	move.l	#scr2,d1
	eor.l	d0,d1
	move.l	d1,ecr_eor	
	rts
	
reset	move.l	#$31415926,$426.w
	move.l	#res_jmp,$42a.w
	rts
	
res_jmp	lea	$4000.w,a7
	move.w	#$2700,sr
	move.l	save_vbl,$70.w
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
	move.l	#$08080000,(a0)
	move.l	#$09090000,(a0)
	move.l	#$0a0a0000,(a0)
	clr	$ffff8260.w
	move.b	#2,$ffff820a.w
	lea	scr1,a0
	move.l	a0,d0
	lsr.l	#8,d0
	move.b	d0,$ffff8203.w
	lsr.l	#8,d0
	move.b	d0,$ffff8201.w
	move.w	#40*200-1,d0
eff_scr	clr.l	(a0)+
	dbf	d0,eff_scr
	move.l	#$30000,d0
att4	subq.l	#1,d0
	bne.s	att4
	lea	reset_txt,a0
	bsr	effet_col
	lea	music,a0
	lea	scr2+$10000,a1
eff_all	clr.l	(a0)+
	cmpa.l	a0,a1
	bgt.s	eff_all
	clr.l	$42a.w
	clr.l	$426.w
	move.l	$4.w,a0
	jmp	(a0)
	
pre_dec_spr	move.l	adr_buf_dec_spr,a0
	move.l	#132*40*16,a1
	adda.l	a0,a1
	move.l	a1,a3
	move.l	a1,adr_buf_sin_ver
	lea	sprite,a2
	move.l	#39,d0
cop_spr	movem.l	(a2)+,d1-d7
	movem.l	d1-d7,(a1)
	movem.l	(a2)+,d1-d7
	movem.l	d1-d7,28(a1)
	movem.l	(a2)+,d1-d6
	movem.l	d1-d6,56(a1)
	clr.l	80(a1)
	clr.l	84(a1)
	lea	88(a1),a1
	dbf	d0,cop_spr
	moveq	#15,d0
dec_16_all	move.l	a3,a1
	moveq	#39,d1
dec_all_line	moveq	#10,d2
masque_1_line	movem.w	(a1)+,d3-d6
	move.w	d3,d7
	or.w	d4,d7
	or.w	d5,d7
	or.w	d6,d7
	not.w	d7
	move.w	d7,(a0)+
	move.w	d7,(a0)+
	movem.w	d3-d6,(a0)
	addq.l	#8,a0
	dbf	d2,masque_1_line
	lea	-88(a1),a1
	moveq	#3,d2
dec_1_line	moveq	#0,d3
	roxr	d3
	roxr	(a1)
	roxr	8(a1)
	roxr	16(a1)
	roxr	24(a1)
	roxr	32(a1)
	roxr	40(a1)
	roxr	48(a1)
	roxr	56(a1)
	roxr	64(a1)
	roxr	72(a1)
	roxr	80(a1)
	addq.l	#2,a1
	dbf	d2,dec_1_line
	lea	80(a1),a1	
	dbf	d1,dec_all_line
	dbf	d0,dec_16_all
	rts

pre_sin_ver	lea	sin_ver,a0
	move.l	adr_buf_sin_ver,a1
	move.l	#(end_sin_ver-sin_ver)*4,d0
	add.l	a1,d0
	move.l	d0,adr_buf_sin_hor
	move.l	#pos_ver*230,d1
loop_sin_ver	moveq	#0,d0
	move.b	(a0)+,d0
	add.b	#16,d0
	mulu	#230,d0
	sub.w	#230*16,d0
	add.w	d0,d1
	move.l	d1,(a1)+
	cmp.b	#$7f,(a0)
	bne.s	loop_sin_ver
	rts
	
pre_sin_hor	lea	sin_hor,a0
	move.l	adr_buf_sin_hor,a1
	move.l	a1,a2
	move.l	#(end_sin_hor-sin_hor)*8+40*8,d0
	add.l	a1,d0
	move.l	d0,adr_buf_txt
	moveq	#0,d0
	move.l	#160+pos_hor,d1
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
	mulu.w	#132*40,d2
	move.l	d1,(a1)+
	move.l	d2,(a1)+
	cmp.b	#$7f,(a0)
	bne.s	loop_sin_hor
	move.w	#40*2-1,d0
recop_deb	move.l	(a2)+,(a1)+
	dbf	d0,recop_deb
	rts

pre_txt	lea	text,a0
	move.l	adr_buf_txt,a1
	move.w	#32*16*45,(a1)+
	move.l	#(text_end-text)*8+2,d0
	add.l	a1,d0
	move.l	d0,adr_buf_scr_ver
cop_pos_let	moveq	#0,d0
	move.b	(a0)+,d0
	tst.b	d0
	beq	txt_fin
numbers	cmp.b	#$30,d0
	blt.s	par_g
	cmp.b	#$39,d0
	bgt.s	letters
	sub.b	#$30,d0
	mulu	#16*32,d0
	bra	txt_sui
letters	cmp.b	#$41,d0
	blt.s	par_g
	cmp.b	#$5a,d0
	bgt	space
	sub.b	#$41,d0
	mulu	#16*32,d0
	add.w	#32*16*10,d0
	bra	txt_sui
par_g	cmp.b	#$28,d0
	bne.s	par_d
	move	#32*16*36,d0
	bra	txt_sui
par_d	cmp.b	#$29,d0
	bne.s	excla
	move	#32*16*37,d0
	bra	txt_sui
excla	cmp.b	#$21,d0
	bne.s	inter
	move	#32*16*38,d0
	bra	txt_sui	
inter	cmp.b	#$3f,d0
	bne.s	tiret
	move	#32*16*39,d0
	bra	txt_sui	
tiret	cmp.b	#$2d,d0
	bne.s	pt
	move	#32*16*40,d0
	bra	txt_sui	
pt	cmp.b	#$2e,d0
	bne.s	dx_pt
	move	#32*16*41,d0
	bra	txt_sui
dx_pt	cmp.b	#$3a,d0
	bne.s	guil
	move	#32*16*42,d0
	bra	txt_sui
guil	cmp.b	#$27,d0
	bne.s	virg
	move	#32*16*43,d0
	bra	txt_sui
virg	cmp.b	#$2c,d0
	bne.s	space
	move	#32*16*44,d0
	bra	txt_sui
space	move	#32*16*45,d0
txt_sui	move.w	d0,(a1)+
	addq	#1,d0
	move.w	d0,(a1)+
	addq	#7,d0
	move.w	d0,(a1)+
	addq	#1,d0
	move.w	d0,(a1)+
	bra	cop_pos_let
txt_fin	move	#32*16*45,(a1)
	rts

pre_scr_ver	lea	scroll_ver,a0
	move.l	adr_buf_scr_ver,a1
	move.l	#160+230*pos_scr,d1
loop_scr_ver	moveq	#0,d0
	move.b	(a0)+,d0
	add.b	#16,d0
	mulu	#230,d0
	sub.w	#230*16,d0
	add.w	d0,d1
	move.l	d1,(a1)+
	cmp.b	#$7f,(a0)
	bne.s	loop_scr_ver
	rts
	
inter_on	move.w	#$2700,sr
	move.l	#vbl,$70.w
	move	#$25,-(sp)
	trap	#14
	addq.l	#2,sp
	move.w	#$2300,sr
	rts
	
clear	move.w	#$2700,sr
	move.l	save_vbl,$70.w
	move.b	mfp1,$fffffa13.w
	move.b	mfp2,$fffffa15.w
	move.b	mfp3,$fffffa07.w
	move.b	#$8,$fffffc02.w
	lea	$ffff8800.w,a0
	move.b	#$e,(a0)
	move.b	#2,2(a0)
	move.l	#$08080000,(a0)
	move.l	#$09090000,(a0)
	move.l	#$0a0a0000,(a0)
	
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
	
	move.w	rez,-(sp)
	move.l	screen,-(sp)
	move.l	(sp),-(sp)
	move	#5,-(sp)
	trap	#14
	lea	12(sp),sp
	
	movem.l	save_pal,d0-d7
	movem.l	d0-d7,$ffff8240.w
	move.b	#7,$484.w
	clr.l	$42a.w
	clr.l	$426.w
	move.w	#$2300,sr
	rts

vbl
swap_scr	lea	scr,a0
	move.l	(a0),sav_scr
	move.l	ecr_eor,d0
	eor.l	d0,(a0)
	move.b	1(a0),$ffff8201.w
	move.b	2(a0),$ffff8203.w
	lea	$ffff8260.w,a5		
	lea	$ffff820a.w,a6		
	moveq	#0,d6		
	moveq	#2,d7		
	
aff_spr	move.l	scr,a0		
	move.l	adr_buf_sin_ver,a1
	lea	pt_ver,a2
	cmp.l	#(end_sin_ver-sin_ver)*4,(a2)
	bne.s	ver_ct	
	clr.l	(a2)	
	bra.s	ver_ct2	
ver_ct	dcb.w	5+2,$4e71
ver_ct2	adda.l	(a2),a1	
	move.l	old_ver1,old_ver2
	move.l	(a2),old_ver1		
	add.l	#4,(a2)		
	add.l	(a1),a0		
	move.l	adr_buf_sin_hor,a1
	move.l	adr_buf_dec_spr,a2
	lea	pt_hor,a3		
	cmp.l	#(end_sin_hor-sin_hor)*8,(a3)
	bne.s	hor_ct		
	clr.l	(a3)		
	bra.s	hor_ct2		
hor_ct	dcb.w	5+2,$4e71
hor_ct2	adda.l	(a3),a1		
	move.l	old_hor1,old_hor2	
	move.l	(a3),old_hor1		
	add.l	#8,(a3)		

	rept	12
	move.l	a0,a4		
	adda.l	(a1)+,a4		
	move.l	a2,a3		
	adda.l	(a1)+,a3		
	movem.l	(a3)+,d0-d5		
	and.l	d0,(a4)		
	or.l	d1,(a4)+		
	and.l	d0,(a4)
	or.l	d2,(a4)+
	and.l	d3,(a4)
	or.l	d4,(a4)+
	and.l	d3,(a4)
	or.l	d5,(a4)+
	movem.l	(a3)+,d0-d5
	and.l	d0,(a4)
	or.l	d1,(a4)+
	and.l	d0,(a4)	
	or.l	d2,(a4)+
	and.l	d3,(a4)
	or.l	d4,(a4)+
	and.l	d3,(a4)	
	or.l	d5,(a4)+
	movem.l	(a3)+,d0-d5
	and.l	d0,(a4)
	or.l	d1,(a4)+
	and.l	d0,(a4)
	or.l	d2,(a4)+
	and.l	d3,(a4)
	or.l	d4,(a4)+
	and.l	d3,(a4)
	or.l	d5,(a4)+
	movem.l	(a3)+,d0-d5
	and.l	d0,(a4)
	or.l	d1,(a4)+	
	and.l	d0,(a4)
	or.l	d2,(a4)+
	and.l	d3,(a4)
	or.l	d4,(a4)+	
	and.l	d3,(a4)
	or.l	d5,(a4)+
	movem.l	(a3)+,d0-d5
	and.l	d0,(a4)
	or.l	d1,(a4)+
	and.l	d0,(a4)
	or.l	d2,(a4)+
	and.l	d3,(a4)
	or.l	d4,(a4)+
	and.l	d3,(a4)
	or.l	d5,(a4)+
	movem.l	(a3)+,d0-d2
	and.l	d0,(a4)
	or.l	d1,(a4)+
	and.l	d0,(a4)
	or.l	d2,(a4)+
	lea	132(a2),a2	
	lea	230(a0),a0	
	endr
	
	move.l	a0,a4	
	adda.l	(a1)+,a4	
	move.l	a2,a3	
	adda.l	(a1)+,a3	
	movem.l	(a3)+,d0-d5	
	and.l	d0,(a4)	
	or.l	d1,(a4)+	
	and.l	d0,(a4)
	or.l	d2,(a4)+
	and.l	d3,(a4)
	or.l	d4,(a4)+
	and.l	d3,(a4)
	or.l	d5,(a4)+
	movem.l	(a3)+,d0-d5
	and.l	d0,(a4)
	or.l	d1,(a4)+
	and.l	d0,(a4)	
	or.l	d2,(a4)+
	and.l	d3,(a4)
	or.l	d4,(a4)+
	and.l	d3,(a4)	
	or.l	d5,(a4)+
	movem.l	(a3)+,d0-d5
	and.l	d0,(a4)
	or.l	d1,(a4)+
	and.l	d0,(a4)
	or.l	d2,(a4)+
	and.l	d3,(a4)
	or.l	d4,(a4)+
	and.l	d3,(a4)
	or.l	d5,(a4)+
	movem.l	(a3)+,d0-d5
	and.l	d0,(a4)
	or.l	d1,(a4)+	
	and.l	d0,(a4)
	or.l	d2,(a4)+
	and.l	d3,(a4)
	or.l	d4,(a4)+	
	and.l	d3,(a4)
	or.l	d5,(a4)+
	movem.l	(a3)+,d0-d5
	and.l	d0,(a4)
	or.l	d1,(a4)+
	and.l	d0,(a4)
	or.l	d2,(a4)+
	and.l	d3,(a4)
	or.l	d4,(a4)+
	and.l	d3,(a4)
	or.l	d5,(a4)+
	
	dcb.w	58,$4e71
	
	move.b	d6,(a6)
	dcb.w	9,$4e71
	move.b	d7,(a6)
	
	move.b	#14,d2
	lea	-1(a6),a6
	move.b	(a6),d0
wait_scan	move.b	(a6),d1
	cmp.b	d0,d1
	beq.s	wait_scan
	and.b	#%00011111,d1
	sub.b	d1,d2
	lsl.b	d2,d1
	lea	1(a6),a6

	movem.l	(a3)+,d0-d2
	and.l	d0,(a4)
	or.l	d1,(a4)+
	and.l	d0,(a4)
	or.l	d2,(a4)+
	lea	132(a2),a2
	lea	230(a0),a0
	dcb.w	93-33,$4e71
	
	rept	27
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	move.l	a0,a4	
	adda.l	(a1)+,a4	
	move.l	a2,a3	
	adda.l	(a1)+,a3	
	movem.l	(a3)+,d0-d5	
	and.l	d0,(a4)	
	or.l	d1,(a4)+	
	and.l	d0,(a4)
	or.l	d2,(a4)+
	and.l	d3,(a4)
	or.l	d4,(a4)+
	and.l	d3,(a4)
	or.l	d5,(a4)+
	movem.l	(a3)+,d0-d5
	and.l	d0,(a4)
	nop
	nop
	nop
	nop
	move.b	d6,(a6)
	move.b	d7,(a6)
	or.l	d1,(a4)+
	and.l	d0,(a4)	
	nop
	nop
	nop
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	or.l	d2,(a4)+
	and.l	d3,(a4)	
	nop
	nop
	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	or.l	d4,(a4)+
	and.l	d3,(a4)	
	or.l	d5,(a4)+
	movem.l	(a3)+,d0-d5
	and.l	d0,(a4)
	or.l	d1,(a4)+
	and.l	d0,(a4)
	or.l	d2,(a4)+
	and.l	d3,(a4)
	or.l	d4,(a4)+
	and.l	d3,(a4)
	or.l	d5,(a4)+
	movem.l	(a3)+,d0-d5
	nop
	nop
	nop
	nop
	move.b	d6,(a6)
	move.b	d7,(a6)
	and.l	d0,(a4)
	or.l	d1,(a4)+	
	nop
	nop
	nop
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	and.l	d0,(a4)
	or.l	d2,(a4)+
	nop
	nop
	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	and.l	d3,(a4)
	or.l	d4,(a4)+	
	and.l	d3,(a4)
	or.l	d5,(a4)+
	movem.l	(a3)+,d0-d5
	and.l	d0,(a4)
	or.l	d1,(a4)+
	and.l	d0,(a4)
	or.l	d2,(a4)+
	and.l	d3,(a4)
	or.l	d4,(a4)+
	and.l	d3,(a4)
	or.l	d5,(a4)+
	movem.l	(a3)+,d0-d2
	and.l	d0,(a4)
	move.b	d6,(a6)
	move.b	d7,(a6)
	or.l	d1,(a4)+
	and.l	d0,(a4)
	nop
	nop
	nop
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	or.l	d2,(a4)+
	lea	132(a2),a2	
	lea	230(a0),a0	
	nop
	nop
	nop
	endr
	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
aff_scroll	move.l	adr_buf_scr_ver,a0
	lea	pt_buf_scr,a2		
	cmp.l	#(end_scr_ver-scroll_ver)*4,(a2)
	bne.s	scr_ct		
	clr.l	(a2)		
	bra.s	scr_ct2		
scr_ct	dcb.w	5+2,$4e71
scr_ct2	adda.l	(a2),a0		
	move.l	(a0),a0		
	move.l	old_scr1,a1		
	move.l	old_scr2,old_scr1	
	move.l	a0,old_scr2		
	add.l	#4,(a2)		
	move.l	scr,d1		
	add.l	d1,a0		
	add.l	d1,a1		
	move.l	adr_buf_txt,a4		
	lea	pt_buf_txt,a3		
	dcb.w	89-73,$4e71
	move.b	d6,(a6)
	move.b	d7,(a6)
	dcb.w	13,$4e71
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	dcb.w	12,$4e71
	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	cmp.l	#(text_end-text)*8,(a3)
	bne.s	txt_ct		
	clr.l	(a3)		
	bra.s	txt_ct2		
txt_ct	dcb.w	5+2,$4e71
txt_ct2	adda.l	(a3),a4		
	add.l	#2,(a3)		
	moveq	#0,d0		
	lea	fonts,a2		
	move.l	a2,a3		
	move.w	(a4)+,d0		
	add.l	d0,a2		
	move.w	(a4),d0		
	add.l	d0,a3		
	cmpa.l	a1,a0		
	bgt	down		
	dcb.w	45,$4e71
	move.b	d6,(a6)
	move.b	d7,(a6)
	dcb.w	13,$4e71
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	dcb.w	12,$4e71
	
	rept	32
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	8(a1),d0-d5/a4		
	movem.l	d0-d5/a4,(a0)		
	movem.l	28+8(a1),d0-d5/a4	
	movem.l	d0-d5/a4,28(a0)		
	movem.l	56+8(a1),d0-d5/a4	
	nop
	nop
	move.b	d6,(a6)
	move.b	d7,(a6)
	movem.l	d0-d4,56(a0)		
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	d5/a4,76(a0)		
	nop
	nop
	nop
	nop
	nop
	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	84+8(a1),d0-d5/a4	
	movem.l	d0-d5/a4,84(a0)		
	movem.l	112+8(a1),d0-d5/a4	
	movem.l	d0-d5/a4,112(a0)	
	movem.l	140+8(a1),d0-d5/a4	
	nop
	move.b	d6,(a6)
	move.b	d7,(a6)
	movem.l	d0-d4,140(a0)		
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	d5/a4,160(a0)
	nop
	nop
	nop
	nop
	nop
	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	168+8(a1),d0-d5/a4	
	movem.l	d0-d5/a4,168(a0)	
	movem.l	196+8(a1),d0-d4		
	movem.l	d0-d4,196(a0)		
	lea	216(a0),a0		
	move.b	(a2),(a0)+		
	move.b	(a3),(a0)+		
	move.b	2(a2),(a0)+		
	move.b	2(a3),(a0)+		
	move.b	4(a2),(a0)+		
	move.b	4(a3),(a0)+		
	nop
	nop
	nop
	move.b	d6,(a6)
	move.b	d7,(a6)
	move.b	6(a2),(a0)+	
	move.b	6(a3),(a0)+	
	lea	6(a0),a0	
	lea	230(a1),a1	
	nop
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	lea	16(a2),a2	
	lea	16(a3),a3	
	dcb.w	8,$4e71
	endr

	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	moveq	#0,d0
	move.l	d0,d1
	move.l	d0,d2
	move.l	d0,d3
	move.l	d0,d4
	move.l	d0,d5
	move.l	d0,a1
	move.l	d0,a2
	move.l	d0,a3
	move.l	d0,a4
	dcb.w	89-10,$4e71
	move.b	d6,(a6)
	move.b	d7,(a6)
	dcb.w	13,$4e71
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	dcb.w	12-3,$4e71		
	bra	scr_sui
	
down	lea	31*230(a0),a0
	lea	31*230(a1),a1
	lea	31*16(a2),a2
	lea	31*16(a3),a3
	dcb.w	46-8,$4e71
	move.b	d6,(a6)
	move.b	d7,(a6)
	dcb.w	13,$4e71
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	dcb.w	12,$4e71
	
	rept	32
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	8(a1),d0-d5/a4		
	movem.l	d0-d5/a4,(a0)		
	movem.l	28+8(a1),d0-d5/a4	
	movem.l	d0-d5/a4,28(a0)		
	movem.l	56+8(a1),d0-d5/a4	
	nop
	nop
	move.b	d6,(a6)
	move.b	d7,(a6)
	movem.l	d0-d4,56(a0)		
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	d5/a4,76(a0)		
	nop
	nop
	nop
	nop
	nop
	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	84+8(a1),d0-d5/a4	
	movem.l	d0-d5/a4,84(a0)		
	movem.l	112+8(a1),d0-d5/a4	
	movem.l	d0-d5/a4,112(a0)	
	movem.l	140+8(a1),d0-d5/a4	
	nop
	move.b	d6,(a6)
	move.b	d7,(a6)
	movem.l	d0-d4,140(a0)		
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	d5/a4,160(a0)
	nop
	nop
	nop
	nop
	nop
	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	168+8(a1),d0-d5/a4	
	movem.l	d0-d5/a4,168(a0)	
	movem.l	196+8(a1),d0-d4		
	movem.l	d0-d4,196(a0)		
	lea	216(a0),a0		
	move.b	(a2),(a0)+		
	move.b	(a3),(a0)+		
	move.b	2(a2),(a0)+		
	move.b	2(a3),(a0)+		
	move.b	4(a2),(a0)+		
	move.b	4(a3),(a0)+		
	nop
	nop
	nop
	move.b	d6,(a6)
	move.b	d7,(a6)
	move.b	6(a2),(a0)+		
	move.b	6(a3),(a0)+		
	lea	-454(a0),a0		
	lea	-230(a1),a1		
	nop
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	lea	-16(a2),a2		
	lea	-16(a3),a3		
	dcb.w	8,$4e71
	endr
	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	moveq	#0,d0
	move.l	d0,d1
	move.l	d0,d2
	move.l	d0,d3
	move.l	d0,d4
	move.l	d0,d5
	move.l	d0,a1
	move.l	d0,a2
	move.l	d0,a3
	move.l	d0,a4
	lea	-230*7(a0),a0
	dcb.w	89-12,$4e71
	move.b	d6,(a6)
	move.b	d7,(a6)
	dcb.w	13,$4e71
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	dcb.w	12,$4e71		
	
scr_sui	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	d0-d5/a1-a4,(a0)	
	movem.l	d0-d5/a1-a4,40(a0)	
	movem.l	d0-d5/a1-a4,80(a0)	
	movem.l	d0-d5/a1-a3,120(a0)	
	move.b	d6,(a6)
	move.b	d7,(a6)
	movem.l	d0-d4,156(a0)		
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	d0-d3,176(a0)		
	nop
	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	d0-d5/a1-a2,192(a0)	
	lea	230(a0),a0		
	movem.l	d0-d5/a1-a4,(a0)	
	movem.l	d0-d5/a1-a4,40(a0)	
	movem.l	d0-d5/a1-a4,80(a0)	
	move.b	d6,(a6)
	move.b	d7,(a6)
	movem.l	d0-d4,120(a0)		
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	d0-d3,140(a0)		
	nop
	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	d0-d5/a1-a4,156(a0)	
	movem.l	d0-d5/a1,196(a0)	
	lea	230(a0),a0		
	movem.l	d0-d5/a1-a4,(a0)	
	movem.l	d0-d5/a1-a4,40(a0)	
	nop
	nop
	move.b	d6,(a6)
	move.b	d7,(a6)
	movem.l	d0-d4,80(a0)		
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	d0-d3,100(a0)		
	nop
	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	d0-d5/a1-a4,116(a0)	
	movem.l	d0-d5/a1-a4,156(a0)	
	movem.l	d0-d5/a1,196(a0)	
	lea	230(a0),a0		
	movem.l	d0-d5/a1-a4,(a0)	
	nop
	nop
	move.b	d6,(a6)
	move.b	d7,(a6)
	movem.l	d0-d4,40(a0)		
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	d0-d3,60(a0)		
	nop
	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	d0-d5/a1-a4,76(a0)	
	movem.l	d0-d5/a1-a4,116(a0)	
	movem.l	d0-d5/a1-a4,156(a0)	
	movem.l	d0-d5/a1,196(a0)	
	lea	230(a0),a0		
	nop
	move.b	d6,(a6)
	move.b	d7,(a6)
	movem.l	d0-d4,(a0)		
	nop
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	d0-d3,20(a0)		
	nop
	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	d0-d5/a1-a4,36(a0)	
	movem.l	d0-d5/a1-a4,76(a0)	
	movem.l	d0-d5/a1-a4,116(a0)	
	movem.l	d0-d5/a1-a2,156(a0)	
	nop
	move.b	d6,(a6)
	move.b	d7,(a6)
	movem.l	d0-d4,188(a0)		
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	d0-d3,208(a0)		
	nop
	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	lea	230(a0),a0		
	movem.l	d0-d5/a1-a4,(a0)	
	movem.l	d0-d5/a1-a4,40(a0)	
	movem.l	d0-d5/a1-a4,80(a0)	
	movem.l	d0-d5/a1-a2,120(a0)	
	move.b	d6,(a6)
	move.b	d7,(a6)
	movem.l	d0-d4,152(a0)		
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	d0-d3,172(a0)		
	nop
	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	d0-d5/a1-a3,188(a0)	
	lea	230(a0),a0		
	movem.l	d0-d5/a1-a4,(a0)	
	movem.l	d0-d5/a1-a4,40(a0)	
	movem.l	d0-d5/a1-a3,80(a0)	
	move.b	d6,(a6)
	move.b	d7,(a6)
	movem.l	d0-d4,116(a0)		
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	d0-d3,136(a0)		
	nop
	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	d0-d5/a1-a4,152(a0)	
	movem.l	d0-d5/a1-a2,192(a0)	
	lea	230(a0),a0		
	movem.l	d0-d5/a1-a4,(a0)	
	movem.l	d0-d5/a1-a4,40(a0)	
	move.b	d6,(a6)
	move.b	d7,(a6)
	movem.l	d0-d4,80(a0)		
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	d0-d3,100(a0)		
	nop
	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	d0-d5/a1-a4,116(a0)	
	movem.l	d0-d5/a1-a4,156(a0)	
	movem.l	d0-d5/a1,196(a0)	
	lea	230(a0),a0		
	dcb.w	24,$4e71
	move.b	d6,(a6)
	move.b	d7,(a6)
	dcb.w	13,$4e71
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	dcb.w	12,$4e71
	
eff_spr	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	move.l	adr_buf_sin_ver,a0
	add.l	old_ver2,a0		
	move.l	adr_buf_sin_hor,a1
	add.l	old_hor2,a1	
	move.l	(a0),a0	
	move.l	a0,a2	
	add.l	sav_scr,a0	
	add.l	#pic+32-160,a2	
	dcb.w	89-36,$4e71
	move.b	d6,(a6)
	move.b	d7,(a6)
	dcb.w	13,$4e71
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	dcb.w	12,$4e71
			
	rept	3
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	move.l	a0,a3		
	adda.l	(a1),a3	
	move.l	a2,a4	
	adda.l	(a1),a4	
	movem.l	(a4)+,d1-d5	
	movem.l	d1-d5,(a3)	
	movem.l	(a4)+,d1-d5	
	movem.l	d1-d5,20(a3)	
	movem.l	(a4)+,d1-d5	
	movem.l	d1-d5,40(a3)	
	nop
	nop
	move.b	d6,(a6)
	move.b	d7,(a6)
	movem.l	(a4)+,d1-d5	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	dcb.w	12,$4e71
	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	d1-d5,60(a3)	
	move.l	(a4)+,80(a3)	
	move.l	(a4)+,84(a3)	
	addq.l	#8,a1	
	lea	230(a0),a0	
	lea	230(a2),a2	
	move.l	a0,a3	
	adda.l	(a1),a3	
	move.l	a2,a4	
	adda.l	(a1),a4	
	movem.l	(a4)+,d1-d5	
	movem.l	d1-d5,(a3)	
	movem.l	(a4)+,d1-d5	
	dcb.w	10,$4e71
	move.b	d6,(a6)
	move.b	d7,(a6)
	movem.l	d1-d5,20(a3)	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	dcb.w	12,$4e71
	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	(a4)+,d1-d5	
	movem.l	d1-d5,40(a3)	
	movem.l	(a4)+,d1-d5	
	movem.l	d1-d5,60(a3)	
	move.l	(a4)+,80(a3)	
	move.l	(a4)+,84(a3)	
	addq.l	#8,a1	
	lea	230(a0),a0	
	lea	230(a2),a2	
	dcb.w	19,$4e71
	move.b	d6,(a6)
	move.b	d7,(a6)
	dcb.w	13,$4e71
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	dcb.w	12,$4e71
	endr
		
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	pal_fnt,d1-d5
	movem.l	d1-d5,$ffff8240.w
	movem.l	pal_fnt+20,d1-d3
	movem.l	d1-d3,$ffff8254.w
	dcb.w	89-48,$4e71
	move.b	d6,(a6)
	move.b	d7,(a6)
	dcb.w	13,$4e71
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	dcb.w	12,$4e71
			
	rept	8
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	move.l	a0,a3	
	adda.l	(a1),a3	
	move.l	a2,a4	
	adda.l	(a1),a4	
	movem.l	(a4)+,d1-d5	
	movem.l	d1-d5,(a3)	
	movem.l	(a4)+,d1-d5	
	movem.l	d1-d5,20(a3)	
	movem.l	(a4)+,d1-d5	
	movem.l	d1-d5,40(a3)	
	nop
	nop
	move.b	d6,(a6)
	move.b	d7,(a6)
	movem.l	(a4)+,d1-d5	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	dcb.w	12,$4e71
	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	d1-d5,60(a3)	
	move.l	(a4)+,80(a3)	
	move.l	(a4)+,84(a3)	
	addq.l	#8,a1	
	lea	230(a0),a0	
	lea	230(a2),a2	
	move.l	a0,a3	
	adda.l	(a1),a3	
	move.l	a2,a4	
	adda.l	(a1),a4	
	movem.l	(a4)+,d1-d5	
	movem.l	d1-d5,(a3)	
	movem.l	(a4)+,d1-d5	
	dcb.w	10,$4e71
	move.b	d6,(a6)
	move.b	d7,(a6)
	movem.l	d1-d5,20(a3)	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	dcb.w	12,$4e71
	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	(a4)+,d1-d5	
	movem.l	d1-d5,40(a3)	
	movem.l	(a4)+,d1-d5	
	movem.l	d1-d5,60(a3)	
	move.l	(a4)+,80(a3)	
	move.l	(a4)+,84(a3)	
	addq.l	#8,a1	
	lea	230(a0),a0	
	lea	230(a2),a2	
	dcb.w	19,$4e71
	move.b	d6,(a6)
	move.b	d7,(a6)
	dcb.w	13,$4e71
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	dcb.w	12,$4e71
	endr
			
	rept	2
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	dcb.w	89,$4e71
	move.b	d6,(a6)
	move.b	d7,(a6)
	dcb.w	13,$4e71
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	dcb.w	12,$4e71
	endr
	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	dcb.w	89,$4e71
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
	dcb.w	89,$4e71
	move.b	d6,(a6)
	move.b	d7,(a6)
	dcb.w	13,$4e71
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	dcb.w	12,$4e71
	
	rept	9
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	move.l	a0,a3	
	adda.l	(a1),a3	
	move.l	a2,a4	
	adda.l	(a1),a4	
	movem.l	(a4)+,d1-d5	
	movem.l	d1-d5,(a3)	
	movem.l	(a4)+,d1-d5	
	movem.l	d1-d5,20(a3)	
	movem.l	(a4)+,d1-d5	
	movem.l	d1-d5,40(a3)	
	nop
	nop
	move.b	d6,(a6)
	move.b	d7,(a6)
	movem.l	(a4)+,d1-d5	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	dcb.w	12,$4e71
	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	d1-d5,60(a3)	
	move.l	(a4)+,80(a3)	
	move.l	(a4)+,84(a3)	
	addq.l	#8,a1	
	lea	230(a0),a0	
	lea	230(a2),a2	
	move.l	a0,a3	
	adda.l	(a1),a3	
	move.l	a2,a4	
	adda.l	(a1),a4	
	movem.l	(a4)+,d1-d5	
	movem.l	d1-d5,(a3)	
	movem.l	(a4)+,d1-d5	
	dcb.w	10,$4e71
	move.b	d6,(a6)
	move.b	d7,(a6)
	movem.l	d1-d5,20(a3)	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	dcb.w	12,$4e71
	
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	movem.l	(a4)+,d1-d5	
	movem.l	d1-d5,40(a3)	
	movem.l	(a4)+,d1-d5	
	movem.l	d1-d5,60(a3)	
	move.l	(a4)+,80(a3)	
	move.l	(a4)+,84(a3)	
	addq.l	#8,a1	
	lea	230(a0),a0	
	lea	230(a2),a2	
	dcb.w	19,$4e71
	move.b	d6,(a6)
	move.b	d7,(a6)
	dcb.w	13,$4e71
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	dcb.w	12,$4e71
	endr
	
	rept	3
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	dcb.w	89,$4e71
	move.b	d6,(a6)
	move.b	d7,(a6)
	dcb.w	13,$4e71
	move.b	d7,(a5)
	nop
	move.b	d6,(a5)
	dcb.w	12,$4e71
	endr
	
	movem.l	pic,d0-d7
	movem.l	d0-d7,$ffff8240.w
	
	move.b	$fffffc02.w,d0
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
	bra.s	set_vbl2
tche_ok	move.b	#1,tst_tche	
set_vbl2	move.l	#vbl_ret,$70.w
tche_sui	jsr	music+offset_music
	lea	$ffff8800.w,a0
	move.b	#8+voix_music-1,(a0)
	move.b	(a0),d0
	cmp.b	#volume,d0
	blt.s	light_off
	move.b	#$e,(a0)
	move.b	#0,2(a0)
	rte
light_off	move.b	#$e,(a0)
	move.b	#2,2(a0)
vbl_ret	rte
	
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
	even
sin_ver	dc.b	0,0,0,1,0,0,1,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6,5,5,5,5,4,4,4,4,3,3,3,3,2,2,2,2,1,1,1,1,0,1,0,0,1
	dc.b	0,0,0,-1,0,0,-1,0,-1,-1,-1,-1,-2,-2,-2,-2,-3,-3,-3,-3,-4,-4,-4,-4,-5,-5,-5,-5,-6,-6,-6,-6,-5,-5,-5,-5,-4,-4,-4,-4,-3,-3,-3,-3,-2,-2,-2,-2,-1,-1,-1,-1,0,-1,0,0,-1
	dc.b	0,0,0,1,0,0,1,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6,5,5,5,5,4,4,4,4,3,3,3,3,2,2,2,2,1,1,1,1,0,1,0,0,1
	dc.b	0,0,0,-1,0,0,-1,0,-1,-1,-1,-1,-2,-2,-2,-2,-3,-3,-3,-3,-4,-4,-4,-4,-5,-5,-5,-5,-6,-6,-6,-6,-5,-5,-5,-5,-4,-4,-4,-4,-3,-3,-3,-3,-2,-2,-2,-2,-1,-1,-1,-1,0,-1,0,0,-1
	dc.b	0,0,0,1,0,0,1,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,5,5,5,5,4,4,4,4,3,3,3,3,2,2,2,2,1,1,1,1,0,1,0,0,1
	dc.b	0,0,0,-1,0,0,-1,0,-1,-1,-1,-1,-2,-2,-2,-2,-3,-3,-3,-3,-4,-4,-4,-4,-5,-5,-5,-5,-4,-4,-4,-4,-3,-3,-3,-3,-2,-2,-2,-2,-1,-1,-1,-1,0,-1,0,0,-1
	dc.b	0,0,0,1,0,0,1,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,4,4,4,4,3,3,3,3,2,2,2,2,1,1,1,1,0,1,0,0,1
	dc.b	0,0,0,-1,0,0,-1,0,-1,-1,-1,-1,-2,-2,-2,-2,-3,-3,-3,-3,-4,-4,-4,-4,-3,-3,-3,-3,-2,-2,-2,-2,-1,-1,-1,-1,0,-1,0,0,-1
	dc.b	0,0,0,1,0,0,1,0,1,1,1,1,2,2,2,2,3,3,3,3,3,3,3,3,2,2,2,2,1,1,1,1,0,1,0,0,1
	dc.b	0,0,0,-1,0,0,-1,0,-1,-1,-1,-1,-2,-2,-2,-2,-3,-3,-3,-3,-2,-2,-2,-2,-1,-1,-1,-1,0,-1,0,0,-1
	dc.b	0,0,0,1,0,0,1,0,1,1,1,1,2,2,2,2,3,3,3,3,2,2,2,2,1,1,1,1,0,1,0,0,1
	dc.b	0,0,0,-1,0,0,-1,0,-1,-1,-1,-1,-2,-2,-2,-2,-3,-3,-3,-3,-3,-3,-3,-3,-2,-2,-2,-2,-1,-1,-1,-1,0,-1,0,0,-1
	dc.b	0,0,0,1,0,0,1,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,3,3,3,3,2,2,2,2,1,1,1,1,0,1,0,0,1
	dc.b	0,0,0,-1,0,0,-1,0,-1,-1,-1,-1,-2,-2,-2,-2,-3,-3,-3,-3,-4,-4,-4,-4,-4,-4,-4,-4,-3,-3,-3,-3,-2,-2,-2,-2,-1,-1,-1,-1,0,-1,0,0,-1
	dc.b	0,0,0,1,0,0,1,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,4,4,4,4,3,3,3,3,2,2,2,2,1,1,1,1,0,1,0,0,1
	dc.b	0,0,0,-1,0,0,-1,0,-1,-1,-1,-1,-2,-2,-2,-2,-3,-3,-3,-3,-4,-4,-4,-4,-5,-5,-5,-5,-5,-5,-5,-5,-4,-4,-4,-4,-3,-3,-3,-3,-2,-2,-2,-2,-1,-1,-1,-1,0,-1,0,0,-1
	dc.b	0,0,0,1,0,0,1,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6,5,5,5,5,4,4,4,4,3,3,3,3,2,2,2,2,1,1,1,1,0,1,0,0,1
	dc.b	0,0,0,-1,0,0,-1,0,-1,-1,-1,-1,-2,-2,-2,-2,-3,-3,-3,-3,-4,-4,-4,-4,-5,-5,-5,-5,-6,-6,-6,-6,-5,-5,-5,-5,-4,-4,-4,-4,-3,-3,-3,-3,-2,-2,-2,-2,-1,-1,-1,-1,0,-1,0,0,-1
	dc.b	0,0,0,1,0,0,1,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6,5,5,5,5,4,4,4,4,3,3,3,3,2,2,2,2,1,1,1,1,0,1,0,0,1
	dc.b	0,0,0,-1,0,0,-1,0,-1,-1,-1,-1,-2,-2,-2,-2,-3,-3,-3,-3,-4,-4,-4,-4,-5,-5,-5,-5,-6,-6,-6,-6,-5,-5,-5,-5,-4,-4,-4,-4,-3,-3,-3,-3,-2,-2,-2,-2,-1,-1,-1,-1,0,-1,0,0,-1
end_sin_ver	dc.b	$7f
	even
sin_hor	dcb.b	40*4,0
	rept	1
	dc.b	-7,-7,-7,-7,-6,-6,-6,-6,-5,-5,-5,-5,-4,-4,-4,-4,-3,-3,-3,-3,-2,-2,-2,-2,-1,-1,-1,-1,0,-1,-1,-1,0,-1,-1,0,-1,0,0,-1,0,0,0
	dc.b	0,0,0,1,0,0,1,0,1,1,0,1,1,1,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6,7,7,7,7
	dc.b	7,7,7,7,6,6,6,6,5,5,5,5,4,4,4,4,3,3,3,3,2,2,2,2,1,1,1,1,0,1,1,1,0,1,1,0,1,0,0,1,0,0,0
	dc.b	0,0,0,-1,0,0,-1,0,-1,-1,0,-1,-1,-1,0,-1,-1,-1,-1,-2,-2,-2,-2,-3,-3,-3,-3,-4,-4,-4,-4,-5,-5,-5,-5,-6,-6,-6,-6,-7,-7,-7,-7
	endr
	rept	6
	dc.b	-6,-5,-4,-3,-2,-1
	dc.b	0,1,2,3,4,5,6
	dc.b	6,5,4,3,2,1,0
	dc.b	-1,-2,-3,-4,-5,-6
	endr
	rept	3
	dcb.b	11,-8
	dc.b	-7,-6,-5,-4,-3,-2,-1,0
	dc.b	0,1,2,3,4,5,6,7
	dcb.b	22,8
	dc.b	7,6,5,4,3,2,1,0
	dc.b	0,-1,-2,-3,-4,-5,-6,-7
	dcb.b	11,-8
	endr
	rept	2
	dc.b	-6,-6,-6,-6,-6,-5,-5,-5,-5,-5,-4,-4,-4,-4,-4,-3,-3,-3,-3,-3,-2,-2,-2,-2,-2,-1,-1,-1,-1,-1
	dc.b	1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4,5,5,5,5,5,6,6,6,6,6
	dc.b	6,6,6,6,6,5,5,5,5,5,4,4,4,4,4,3,3,3,3,3,2,2,2,2,2,1,1,1,1,1
	dc.b	-1,-1,-1,-1,-1,-2,-2,-2,-2,-2,-3,-3,-3,-3,-3,-4,-4,-4,-4,-4,-5,-5,-5,-5,-5,-6,-6,-6,-6,-6
	endr
	rept	6
	dc.b	-3,-3,-2,-2,-1,-1,0
	dc.b	1,1,2,2,3,3,3,3,2,2,1,1,0
	dc.b	-1,-1,-2,-2,-3,-3,0
	endr
	rept	10
	dc.b	-2,-1
	dc.b	1,2,2,1
	dc.b	-1,-2
	endr
	rept	2
	dc.b	-3,-3,-3,-4,-4,-4,-5,-5,-5,-6,-6,-6,-5,-5,-5,-4,-4,-4,-3,-3,-3,-2,-2,-2,-1,-1,-1
	dc.b	1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6,5,5,5,4,4,4,3,3,3
	dc.b	3,3,3,4,4,4,5,5,5,6,6,6,5,5,5,4,4,4,3,3,3,2,2,2,1,1,1
	dc.b	-1,-1,-1,-2,-2,-2,-3,-3,-3,-4,-4,-4,-5,-5,-5,-6,-6,-6,-5,-5,-5,-4,-4,-4,-3,-3,-3
	endr	
	dc.b	-3,-3,-3,-4,-4,-4,-5,-5,-5,-6,-6,-6,-7,-7,-7,-6,-5,-4,-3,-2,-1	
	rept	5
	dc.b	-2,-2,-2,-2,-2,-2,-2,-2
	dc.b	2,2,2,2,2,2,2,2
	endr
	dc.b	3,3,3,4,4,4,5,5,5,6,6,6,7,7,7,7,7,7
	dcb.b	9,8
	dc.b	7,6,5,4,2
	rept	5
	dc.b	-2,-2,-2,-2,-2,-2,-2,-2
	dc.b	2,2,2,2,2,2,2,2
	endr
	dc.b	-2,-4,-5,-6,-7
	dcb.b	9,-8
	rept	8
	dc.b	-8,-6,-4,-2
	dc.b	2,4,6,8
	dc.b	8,6,4,2
	dc.b	-2,-4,-6,-8
	endr
end_sin_hor	dc.b	$7f
	even
old_ver1	dc.l	0
old_ver2	dc.l	0
old_hor1	dc.l	0
old_hor2	dc.l	0
pt_ver	dc.l	0
pt_hor	dc.l	0
scr	dc.l	scr2
sav_scr	dc.l	0
ecr_eor	dc.l	0
text	DC.B	" YO !!!!     HERE STRIKES BACK  O R I O N  FROM  F U Z I O N   "
	DC.B	"WITH A NEW GREAT INTRO FOR FUZION'S CD !!!        SPRITE AND DEFORMTION OF A BIG LOGO ( 160X40 IN 4 PLANS ) , "
	DC.B	"AND A MOVING SCROLLTEXT ( 32X32 IN 4 PLANS TOO )       AND ALL ...... IN FULLSCREEN !!!!!     "
	DC.B	"     GREAT NO ?????    "
	DC.B	" ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789 '(!),?.                        "
text_end	dc.b	0
	even
scroll_ver	dc.b	0,0,0,0,1,0,0,0,1,0,0,1,0,1,1,2,2,2,3,3,3,4
	dc.b	-4,-3,-3,-3,-2,-2,-2,-1,-1,0,-1,0,0,-1,0,0,0,-1,0,0,0,0
end_scr_ver	dc.b	$7f
	even
pal_fnt	dc.w	$000,$776,$777,$666,$555,$444,$333,$222
	dc.w	$111,$665,$554,$443,$332,$221,$110,$777
old_scr1	dc.l	pos_scr*230
old_scr2	dc.l	pos_scr*230
pt_buf_scr	dc.l	0
pt_buf_txt	dc.l	0
adr_buf_dec_spr	dc.l	buf_all
adr_buf_sin_ver	dc.l	0
adr_buf_sin_hor	dc.l	0
adr_buf_txt	dc.l	0
adr_buf_scr_ver	dc.l	0
nom1	dc.b	"1.prg",0
	even
nom2	dc.b	"2.prg",0
	even	
nom3	dc.b	"3.prg",0
	even
save_usp	ds.l	1
rez	ds.w	1
screen	ds.l	1
save_pal	ds.l	8
save_vbl	ds.l	1
mfp1	ds.b	1
mfp2	ds.b	1
mfp3	ds.b	1
tst_tche	ds.b	1
	even
reset_txt	incbin	\orion.src\fuzion.cd\full_spr\reset.dat
	even
music	incbin	\orion.src\fuzion.cd\full_spr\count2b.bin
	even
pic	incbin	\orion.src\fuzion.cd\full_spr\pic.dat
	even
pres	incbin	\orion.src\fuzion.cd\full_spr\pres.dat
	even
fonts	incbin	\orion.src\fuzion.cd\full_spr\fonts.dat
	even
buf_all	
sprite	incbin	\orion.src\fuzion.cd\full_spr\logo.dat

	end