	*****************************************
	* Demo       Bombonne II Demo           *
	* Coder      ORION from Replicants      *
	* Usage      Reps copy-party slide show *
	* Date       July 1992                  *
	* Note       Insert the original        *
	*            Bombonne II demo disk in   *
	*            drive A before starting    *
	*            the demo (it provides the  *
	*            pictures)                  *
	*                                       *
	* Machine    Atari STE - 1MB RAM        *
	* TOS        1.62                       *
	* Assembler  GenST v2.09                *
	* Emulator   Steem v3.2                 *
	*                                       *
	* Contact    Orion.Replicants@gmail.com *
	*****************************************

scr1	=	$f8000
tst_st	=	1
mvol	=	$80
a_data	=	20
parts_stf	=	5
len_stf	=	41
inc_stf	=	$1234de0
len_ste	=	100
inc_ste	=	$8efb4e
nbr_pass	=	19

pt_base	move.l	a7,sav_a7
	lea	scr1-$100,a7
	pea	intro(pc)
	move.w	#$26,-(sp)
	trap	#14
	addq.l	#6,sp
	move.l	sav_a7,a7
	
	clr.w	-(sp)
	trap	#1

intro	bsr	save_all
	bsr	reset
	bsr	set_scr
	bsr	load_scr1
	bsr	tst_type_st
	bsr	inter_on
	bsr	loop2
att_clav	cmp.b	#$b9,$fffffc02.w
	bne.s	att_clav
	bsr	inter_off
	rts
	
save_all	move.w	#$2700,sr
	move.l	$24(a1),sav_usp
	move.l	$44e.w,sav_screen
	move.b	$ffff8260.w,sav_rez+1
	move.b	$ffff820a.w,sav_hz
	movem.l	$ffff8240.w,d0-d7
	movem.l	d0-d7,sav_pal
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
	move.l	$70.w,sav_vbl
	move.l	$120.w,sav_timer_b
	move.l	$134.w,sav_timer_d
	move.w	#$2300,sr
	rts
	
reset	move.l	#$31415926,$426.w
	move.l	#jmp_reset,$42a.w
	rts
	
jmp_reset	move	#$2700,sr
	lea	$80000,a7
	lea	$ffff8240.w,a0
	moveq	#7,d0
cl_r_c	clr.l	(a0)+
	dbf	d0,cl_r_c
	clr.b	$ffff8260.w
	move.b	#2,$ffff820a.w
	move.b	#$7,$ffff8201.w
	move.b	#$80,$ffff8203.w
	move.l	eff(pc),$c.w
	move.l	$4.w,$8.w
	lea	$10.w,a0
	jmp	$c.w
	
eff	clr.l	(a0)+
	bra.s	eff
	
inter_on	move.w	#$2700,sr
	clr.b	$fffffa07.w
	clr.b	$fffffa09.w
	clr.b	$fffffa0b.w
	clr.b	$fffffa0d.w
	clr.b	$fffffa13.w
	clr.b	$fffffa15.w
	bsr	mus_on
	move.l	#vbl,$70.w
	move.w	#$2300,sr
	rts
	
inter_off	move.w	#$2700,sr
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
	move.l	sav_vbl,$70.w
	move.l	sav_timer_b,$120.w
	move.l	sav_timer_d,$134.w
	move.b	#$8,$fffffc02.w
	move.b	sav_hz,$ffff820a.w
	lea	$ffff8800.w,a0
	move.l	#$0707ffff,(a0)
	move.l	#$08080000,(a0)
	move.l	#$09090000,(a0)
	move.l	#$0a0a0000,(a0)
	tst.b	st
	beq.s	stf
	clr.b	$ffff8901.w
stf	move.w	#$2300,sr
	move.w	sav_rez,-(sp)
	move.l	sav_screen,-(sp)
	move.l	(sp),-(sp)
	move.w	#5,-(sp)
	trap	#14
	lea	12(sp),sp
	movem.l	sav_pal,d0-d7
	movem.l	d0-d7,$ffff8240.w
	move.b	#7,$484.w
	rts	
	
set_scr	dc.w	$a00a
	clr.b	$484.w
	move.w	#$777,d0
	moveq	#7,d1
cop_col2	moveq	#3,d7
	bsr	vsync
	lea	$ffff8240.w,a0
	moveq	#15,d2
cop_col1	move.w	d0,(a0)+
	dbf	d2,cop_col1
	sub.w	#$111,d0
	dbf	d1,cop_col2
	clr	-(sp)
	pea	scr1
	move.l	(sp),-(sp)
	move.w	#5,-(sp)
	trap	#14
	lea	12(sp),sp
	move.l	#$2ffff,d0
wait_l	subq.l	#1,d0
	bne.s	wait_l
	rts
	
tst_type_st	moveq	#tst_st,d0
	lea	$5.w,a0
	cmp.b	#$fc,(a0)
	bne.s	ste
	moveq	#0,d0
ste	move.b	d0,st
	rts

err_scr1	move.w	$ffff8240.w,-(sp)
lp_scr1	move.w	#7,$ffff8240.w
	cmp.b	#$39,$fffffc02.w
	bne.s	lp_scr1
	move.w	(sp)+,$ffff8240.w
	bra.s	lp_lnk
	
load_scr1	lea	name_lnk,a0
lp_lnk	bsr	prep_lnk
	tst.l	d0
	bmi.s	err_scr1
	lea	nom1,a2
	bsr	load
	rts
	
prep_lnk	movem.l	d0-a5,-(sp)
	st	$43e.w
	bsr	set_reg
	bsr	fnd_link
	sf	$43e.w
	movem.l	(sp)+,d0-a5
	moveq	#0,d0
	rts
	
fnd_link	lea	buf_sec,a0
	moveq	#0,d0
	bsr	read_sector
	
	moveq	#0,d1
	move.b	16(a0),d0
	move.b	22(a0),d1
	mulu	d1,d0
	addq.w	#1,d0
	move.b	17(a0),d1
	lsr.b	#4,d1
	move.w	d0,12(a5)
	add.w	d1,12(a5)
	move.b	24(a0),9(a5)
	move.b	26(a0),11(a5)
	
	move.l	(a5),a1
	bsr	search
	lea	28(a0),a0
	move.b	-(a0),d0
	lsl.w	#8,d0
	move.b	-(a0),d0
	subq.w	#2,d0
	add.w	d0,d0
	add.w	d0,12(a5)
	rts
	
search	bsr	read_sector
	move.w	#16,d2
	bsr	search2
	tst.w	d2
	bmi.s	no_found2
	rts
no_found2	lea	-$200(a0),a0
	addq.w	#1,d0
	subq.w	#1,d1
	bne.s	search
	bra	read_err

load	movem.l	d0-a5,-(a7)
load_go	move.l	a2,a0
	lea	buf_scr,a1
	bsr	dma
	tst.l	d0
	bmi	error
	move.l	a1,a0
	bsr	depack
	movem.l	(a7)+,d0-a5
	rts
	
error	move.w	$ffff8240.w,-(sp)
lp_space	move.w	#7,$ffff8240.w
	cmp.b	#$39,$fffffc02.w
	bne.s	lp_space
	move.w	(sp)+,$ffff8240.w
	movem.l	(sp),d0-a5
	bra.s	load_go
	
dma	movem.l	d0-a5,-(sp)
	st	$43e.w
	bsr	set_reg
	bsr	fopen
	bsr	fread
	sf	$43e.w
	movem.l	(sp)+,d0-a5
	moveq	#0,d0	
	rts
	
set_reg	lea	$ffff8604.w,a4
	lea	buffer_dma,a5
	move.l	a0,(a5)
	move.l	a1,4(a5)
	lea	4(a7),a2
	move.l	a2,22(a5)
	rts
	
fopen	lea	names,a0
	move.l	(a5),a1
	move.l	#19,d2
	bsr	search2
	tst.w	d2
	bmi	read_err
	move.l	20(a0),14(a5)
	move.l	24(a0),18(a5)
	rts
	
search2	movem.l	d0-d1/d3/a1-a3,-(sp)
name_sea2	subq.w	#1,d2
	bmi.s	no_found1
	move.l	a1,a2
	move.l	a0,a3
	moveq	#11,d0
name_sea1	move.b	(a2)+,d3
	beq.s	no_found1
	or.b	#$20,d3
	or.b	#$20,(a3)
	cmp.b	(a3)+,d3
	dbne	d0,name_sea1
	lea	32(a0),a0
	dbeq	d0,name_sea2
	lea	-32(a0),a0
no_found1	movem.l	(sp)+,d0-d1/d3/a1-a3
	rts
	
fread	move.l	14(a5),d2
	move.l	18(a5),d3
	divu	#$200,d2
	moveq	#0,d0
	move.w	d2,d0
	add.w	12(a5),d0
	clr.w	d2
	swap	d2
	lea	buf_sec,a0
	bsr	read_sector
	lea	0(a0,d2.l),a1
	move.l	4(a5),a2
	neg.w	d2
	add.w	#$200,d2
	cmp.l	d2,d3
	bgt.s	fread1
	move.l	d3,d2
fread1	sub.w	d2,d3
fread6	move.b	(a1)+,(a2)+
	subq.w	#1,d2
	bne.s	fread6
	move.l	a2,a0
	divu	#$200,d3
	moveq	#0,d1
	move.w	d3,d1
	clr.w	d3
	swap	d3
fread3	addq.w	#1,d0
	tst.w	d1
	beq.s	fread2
	subq.w	#1,d1
	bsr	read_sector
	lea	$200(a0),a0
	bra.s	fread3
fread2	tst.w	d3
	beq.s	fread5
	move.l	a0,a2
	lea	buf_sec,a0
	bsr	read_sector
fread4	move.b	(a0)+,(a2)+
	subq.l	#1,d3
	bne.s	fread4
fread5	rts
	
read_sector	movem.l	d0-d3,-(sp)
	divu	8(a5),d0
	moveq	#0,d1
	move.w	d0,d1
	swap	d0
	addq.w	#1,d0
	divu	10(a5),d1
	move.l	d1,d2
	swap	d2
	neg.w	d2
	addq.w	#5,d2
	move.w	sr,d3
	or.w	#$700,sr
	move.b	#$e,$ffff8800.w
	move.b	d2,$ffff8802.w
	move.w	d3,sr
	moveq	#1,d2
	move.w	#$86,2(a4)
	divu	d2,d2
	move.w	d1,(a4)
	divu	d2,d2
	move.w	#$80,2(a4)
	divu	d2,d2
	move.w	#$13,(a4)
	bsr.s	tst_etat
	move.w	#$84,2(a4)
	divu	d2,d2
	move.w	d0,(a4)
	divu	d2,d2
	move.w	#$90,2(a4)
	move.w	#$190,2(a4)
	move.w	#$90,2(a4)
	divu	d2,d2	
	move.w	#1,(a4)
	divu	d2,d2
	move.l	a0,d3
	move.b	d3,9(a4)
	lsr.l	#8,d3
	move.b	d3,7(a4)
	lsr.l	#8,d3
	move.b	d3,5(a4)
	move.w	#$80,2(a4)
	divu	d2,d2
	move.w	#$80,(a4)
	bsr.s	tst_etat
	move.w	(a4),d0
	and.w	#$70,d0
	bne.s	read_err
	movem.l	(sp)+,d0-d3
	rts
	
read_err	move.l	22(a5),a7
	movem.l	(sp)+,d0-a5
	moveq	#-33,d0
	rts
	
tst_etat	moveq	#8,d3
	swap	d3
tst1	subq.l	#1,d3
	beq.s	read_err
	btst	#5,$fffffa01.w
	bne.s	tst1
	rts
	
MODE:	EQU	1
PIC_ALGO:	EQU	0
DEC_SPACE:	EQU	$200
RESTORE_SPACE:	EQU	0

depack	movem.l	d0-a5,-(a7)
	move.l	a0,a2
	lea	buf_sec,a1
	add.l	4(a0),a2
	move.w	#$200-1,d0
cop1	move.b	(a2)+,(a1)+
	dbf	d0,cop1	
	bsr	dec
	move.w	#$200-1,d0
cop2	move.b	-(a1),-(a2)
	dbf	d0,cop2
	movem.l	(a7)+,d0-a5
	rts
	
dec	movem.l	d0-a5,-(a7)
	cmp.l	#"ATM5",(a0)+
	bne	not_packed
	move.l	(a0),(a7)
	link	a2,#-28
	move.l	(a0)+,d0
	ifne	MODE
	lea	4(a0,d0.l),a5
	move.l	d0,-(a7)
	elseif
	move.l	a1,a5
	add.l	d0,a5
	endc
	move.l	a5,a4
	ifne	MODE
	ifne	DEC_SPACE
	lea	DEC_SPACE(a4),a5
	endc
	endc
	lea	-$c(a4),a4
	move.l	(a0)+,d0
	move.l	a0,a3
	add.l	d0,a3
	ifne	PIC_ALGO
	moveq	#0,d0
	move.b	-(a3),d0
	move	d0,-2(a2)
	ifne	RESTORE_SPACE
	lsl	#2,d0
	sub	d0,a4
	endc
	elseif
	ifne	RESTORE_SPACE
	clr	-2(a2)
	endc
	subq	#1,a3
	endc
	ifne	RESTORE_SPACE
	
	lea	buf_sec,a3
	
	move	-2(a2),d0
	lsl	#2,d0
	add	#DEC_SPACE+$C,d0
	bra.s	.save
.save_m:	move.b	(a4)+,(a3)+
	subq	#1,d0
.save:	bne.s	.save_m
	movem.l	a3-a4,-(a7)
	endc
	ifne	PIC_ALGO
	pea	(a5)
	endc
	clr.l	-(a7)
	move.b	-(a3),d7
	bra	take_type
decrunch:	move	d3,d5
take_lenght:	add.b	d7,d7
.cont_take:	dbcs	d5,take_lenght
	beq.s	.empty1
	bcc.s	.next_cod
	sub	d3,d5
	neg	d5
	bra.s	.do_copy1
.next_cod:	moveq	#3,d6
	bsr.s	get_bit2
	beq.s	.next_cod1
	bra.s	.do_copy
.next_cod1:	moveq	#7,d6
	bsr.s	get_bit2
	beq.s	.next_cod2
	add	#15,d5
	bra.s	.do_copy
.empty1:	move.b	-(a3),d7
	addx.b	d7,d7
	bra.s	.cont_take
.next_cod2:	moveq	#13,d6
	bsr.s	get_bit2
	add	#255+15,d5
.do_copy:	add	d3,d5
.do_copy1:	lea	decrun_table(pc),a4
	move	d5,d2
	bne.s	bigger
	add.b	d7,d7
	bne.s	.not_empty
	move.b	-(a3),d7
	addx.b	d7,d7
.not_empty:	bcs.s	.ho_kesako
	moveq	#1,d6
	bra.s	word
.ho_kesako:	moveq	#3,d6
	bsr.s	get_bit2
	tst.b	-28(a2)
	beq.s	.ho_kesako1
	move.b	10-28(a2,d5.w),-(a5)
	bra	tst_end
.ho_kesako1:	move.b	(a5),d0
	btst	#3,d5
	bne.s	.ho_kesako2
	bra.s	.ho_kesako3
.ho_kesako2:	add.b	#$f0,d5
.ho_kesako3:	sub.b	d5,d0
	move.b	d0,-(a5)
	bra	tst_end
get_bit2:	clr	d5
.get_bits:	add.b	d7,d7
	beq.s	.empty
.cont:	addx	d5,d5
	dbf	d6,.get_bits
	tst	d5
	rts
.empty:	move.b	-(a3),d7
	addx.b	d7,d7
	bra.s	.cont
bigger:	moveq	#2,d6
word:	bsr.s	get_bit2
contus:	move	d5,d4
	move.b	14(a4,d4.w),d6
	ext	d6
	tst.b	1-28(a2)
	bne.s	.spe_ofcod1
	addq	#4,d6
	bra.s	.nospe_ofcod1
.spe_ofcod1:	bsr.s	get_bit2
	move	d5,d1
	lsl	#4,d1
	moveq	#2,d6
	bsr.s	get_bit2
	cmp.b	#7,d5
	blt.s	.take_orof
	moveq	#0,d6
	bsr.s	get_bit2
	beq.s	.its_little
	moveq	#2,d6
	bsr.s	get_bit2
	add	d5,d5
	or	d1,d5
	bra.s	.spe_ofcod2
.its_little:	or.b	2-28(a2),d1
	bra.s	.spe_ofcod3
.take_orof:	or.b	3-28(a2,d5.w),d1
.spe_ofcod3:	move	d1,d5
	bra.s	.spe_ofcod2
.nospe_ofcod1:	bsr.s	get_bit2
.spe_ofcod2:	add	d4,d4
	beq.s	.first
	add	-2(a4,d4.w),d5
.first:	lea	1(a5,d5.w),a4
	move.b	-(a4),-(a5)
.copy_same:	move.b	-(a4),-(a5)
	dbf	d2,.copy_same
	bra.s	tst_end
make_jnk:	add.b	d7,d7
	bne.s	.not_empty
	move.b	-(a3),d7
	addx.b	d7,d7
.not_empty:	bcs.s	string
	move.b	-(a3),-(a5)
tst_end:	cmp.l	(a7),a5
	bne.s	make_jnk
	cmp.l	a3,a0
	beq.s	work_done
take_type:	moveq	#0,d6
	bsr	get_bit2
	beq.s	.nospe_ofcod
	move.b	-(a3),d0
	lea	2-28(a2),a1
	move.b	d0,(a1)+
	moveq	#1,d1
	moveq	#6,d2
.next:	cmp.b	d0,d1
	bne.s	.no_off_4b
	addq	#2,d1
.no_off_4b:	move.b	d1,(a1)+
	addq	#2,d1
	dbf	d2,.next
	st	1-28(a2)
	bra.s	.spe_ofcod
.nospe_ofcod:	sf	1-28(a2)
.spe_ofcod:	moveq	#0,d6
	bsr	get_bit2
	beq.s	.relatif
	lea	10-28(a2),a1
	moveq	#15,d0
.next_f:	move.b	-(a3),(a1)+
	dbf	d0,.next_f
	st	-28(a2)
	bra.s	.freq
.relatif:	sf	-28(a2)
.freq:	clr	d3
	move.b	-(a3),d3
	move.b	-(a3),d0
	lsl	#8,d0
	move.b	-(a3),d0
	move.l	a5,(a7)
	ext.l	d0
	sub.l	d0,(a7)
	bra.s	make_jnk
string:	bra	decrunch
work_done:	addq.l	#4,a7
	ifne	PIC_ALGO
	move.l	(a7)+,a0
	pea	(a2)
	bsr.s	decod_picture
	move.l	(a7)+,a2
	endc
	ifne	RESTORE_SPACE
	movem.l	(a7)+,a3-a4
	endc
	ifne	MODE
	move.l	(a7)+,d0
	bsr	copy_decrun
	endc
	ifne	RESTORE_SPACE
	move	-2(a2),d0
	lsl	#2,d0
	add	#DEC_SPACE+$C,d0
	bra.s	.restore
.restore_m:	move.b	-(a3),-(a4)
	subq	#1,d0
.restore:	bne.s	.restore_m
	endc
	unlk	a2
not_packed:	movem.l	(a7)+,d0-a5
 	rts
decrun_table:	dc.w	32,32+64,32+64+256,32+64+256+512,32+64+256+512+1024
	dc.w	32+64+256+512+1024+2048,32+64+256+512+1024+2048+4096
	dc.b	0,1,3,4,5,6,7,8
	ifne	PIC_ALGO
decod_picture:	move	-2(a2),d7
.next_picture:	dbf	d7,.decod_algo
	rts
.decod_algo:	move.l	-(a0),d0
	lea	0(a5,d0.l),a1
.no_odd:	lea	$7d00(a1),a2
.next_planes:	moveq	#3,d6
.next_word:	move	(a1)+,d0
	moveq	#3,d5
.next_bits:	add	d0,d0
	addx	d1,d1
	add	d0,d0
	addx	d2,d2
	add	d0,d0
	addx	d3,d3
	add	d0,d0
	addx	d4,d4
	dbf	d5,.next_bits
	dbf	d6,.next_word
	movem	d1-d4,-8(a1)
	cmp.l	a1,a2
	bne.s	.next_planes
	bra.s	.next_picture
	endc
	ifne	MODE
copy_decrun:	lsr.l	#4,d0
	lea	-12(a3),a3
.copy_decrun:	rept	4
	move.l	(a5)+,(a3)+
	endr
	dbf	d0,.copy_decrun
	rts
	endc
	rts	
	
loop2	lea	pt_pass,a0
	move.l	(a0),d0
	addq.l	#1,(a0)
	lea	big_table,a1
	mulu	#4*3,d0
	add.l	d0,a1
	move.l	(a1)+,a2
	bsr	scroll	
	move.l	(a1)+,a2
	bsr	effet
	move.l	(a1)+,a2
	bsr	load
	bsr	eff_scr
	cmp.l	#nbr_pass,(a0)
	bne.s	loop2
	lea	scroll_fin,a2
	bsr	scroll
	clr.l	pt_pass
	bra	loop2
	rts
	
scroll	movem.l	d0-a5,-(a7)
	move.w	#$777,pal+2
	move.l	#16,pt_scroll
	clr.l	pt_text
	move.l	#1,gener+2
lp_scroll2	bsr	vsync2
	lea	pos_fnt,a3
	move.l	(a3),a1
	lea	pt_scroll,a0
	add.l	(a0),a1
gener	add.l	#1,(a0)
	eor.l	#6,gener+2
	cmp.l	#17,(a0)
	bne.s	scroll_ct
	move.l	#1,(a0)
	
	lea	pt_text,a0
	move.l	(a0),d0
	addq.l	#1,(a0)
	move.l	a2,a1
	add.l	d0,a1
	cmp.b	#-1,(a1)
	beq	fin_scroll
	moveq	#0,d0
	move.b	(a1),d0
	sub.b	#$20,d0
	lsl.l	#2,d0
	lea	table,a0
	add.l	d0,a0
	lea	fonts+34,a1
	add.l	(a0),a1
	move.l	a1,(a3)
	
scroll_ct	lea	scr1+160*90,a3
	
	moveq	#20,d0
var	set	0
lp_scroll	rept	19
	move.b	1+var(a3),var(a3)
	move.b	8+var(a3),1+var(a3)
var	set	var+8
	endr
	move.b	153(a3),152(a3)
	move.b	(a1),153(a3)
	lea	160(a3),a3
	lea	160(a1),a1
	dbf	d0,lp_scroll
	bra	lp_scroll2

fin_scroll	movem.l	(a7)+,d0-a5
	rts	
	
eff_scr	movem.l	d0-a5,-(a7)
wait_pt_vbl	cmp.w	#600,pt_vbl
	blt.s	wait_pt_vbl
	moveq	#7,d7
loop_bl2	bsr	vsync2
	bsr	vsync2
	bsr	vsync2
	lea	pal,a1
	moveq	#15,d0
loop_bl1	clr.l	d1
	clr.l	d3
	move.w	(a1),d3
	and.w	#$fff,d3
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
	lea	scr1,a0
	move.w	#200*40-1,d0
clear_scr1	clr.l	(a0)+
	dbf	d0,clear_scr1
	movem.l	(a7)+,d0-a5
	rts	

effet	movem.l	d0-a5,-(a7)
	clr.w	pt_vbl
	clr.l	pt1
	movem.l	buf_scr+2,d0-d7
	movem.l	d0-d7,pal
	move.l	#230-1,d0
lp_effet	bsr	vsync2
	bsr	app
	dbf	d0,lp_effet
	movem.l	(a7)+,d0-a5
	rts
	
vsync2	clr	vbl_flag
lp_vbl	tst.w	vbl_flag
	beq.s	lp_vbl
	rts
	
app	movem.l	d0-a5,-(a7)
	
	lea	pt1,a0
	move.l	(a0),d0
	addq.l	#1,(a0)
	move.l	a2,a0
	moveq	#0,d7	
	
loop1	moveq	#0,d1
	move.b	0(a0,d0.l),d1
	beq.s	next
	subq.l	#1,d1
	divu	#20,d1
	move.l	d1,d2
	clr.w	d1
	swap	d1
	mulu	#160*20,d2
	mulu	#8,d1
	move.l	d7,d3
	mulu	#2*20,d3
	lea	circle,a1
	add.l	d3,a1
	lea	scr1,a2
	add.l	d1,a2
	add.l	d2,a2
	lea	buf_scr+34,a3
	add.l	d1,a3
	add.l	d2,a3
	moveq	#19,d3
	
loopb	move.w	(a1)+,d1
	move.w	(a3)+,d2
	and.w	d1,d2
	move.w	d2,(a2)+
	move.w	(a3)+,d2
	and.w	d1,d2
	move.w	d2,(a2)+
	move.w	(a3)+,d2
	and.w	d1,d2
	move.w	d2,(a2)+
	move.w	(a3)+,d2
	and.w	d1,d2
	move.w	d2,(a2)+
	lea	152(a3),a3
	lea	152(a2),a2
	dbf	d3,loopb
	
next	addq.l	#1,d0
	addq.l	#1,d7
	cmp.b	#7,d7
	bne.s	loop1

	movem.l	(a7)+,d0-a5
	rts
	
vsync	clr.l	$466.w
wait_sync	cmp.l	$466.w,d7
	bgt.s	wait_sync
	rts
		
mus_on	cmp.b	#1,st
	bne.s	stf_run_1
	move.l	#$4e714e71,st_ch_1
	move.l	#inc_ste,st_ch_2+2
	bsr.s	ste_replay_routs
	bra.s	mus_on_2
stf_run_1	move.l	#$06020080,st_ch_1
	move.l	#inc_stf,st_ch_2+2
	bsr.s	stf_replay_routs
mus_on_2	bsr	vol	
	bsr	incrcal	
	bsr	clearym	
	jsr	init	
	jsr	prepare	
	rts

ste_replay_routs
	move.l	#stereo,jmp_music+2
	move.b	#2,$FFFF8921.w
	move.l	samp1,d0
	move.l	d0,d1
	add.l	#len_ste*2*5,d1
	movea	#$8900,a0
	movep.l	d0,1(a0)
	movep.l	d1,$d(a0)
	move	#1,(a0)
	rts
	
stf_replay_routs
	bset	#5,$fffffa07.w
	bset	#5,$fffffa13.w
	clr.b	$FFFFFA19.w
	move.b	#A_DATA,$FFFFFA1F.w
	move.b	#2,$FFFFFA19.w
	move.l	#play_stf,jmp_music+2
	lea	out_inter,a0
	moveq	#0,d0
	move.b	out,d0
	lsl.w	#2,d0
	move.l	(a0,d0.w),$134.w
	lea	sample1,a6
	move.b	#$40,$fffffa17.w
	rts
	
vbl	movem.l	d0-a5,-(a7)
	bsr	init_vbl
jmp_music	jsr	$0	
	movem.l	(a7)+,d0-a5
	rte	
	
init_vbl	tst.b	st
	bne.s	ste2
stf2	movea.l	samp1,a6
	bra.s	st_ct
ste2	move.l	samp1,d0
	move.l	d0,d1
	add.l	#len_ste*2*5,d1
	movea	#$8900,a0
	movep.l	d0,1(a0)
	movep.l	d1,$d(a0)
	move	#1,(a0)
	move.l	samp1,d0
	move.l	samp2,samp1
	move.l	d0,samp2
st_ct	addq.w	#1,pt_vbl
	move.w	#1,vbl_flag
	movem.l	pal,d0-d7
	movem.l	d0-d7,$ffff8240.w
	rts
		
clearym	moveq	#$0A,d0
._1	move.b	d0,$FFFF8800.w
	clr.b	$FFFF8802.w
	dbra	d0,._1	
	clr.b	$FFFF8800.w
	clr.b	$FFFF8802.w
	move.b	#7,$FFFF8800.w
	move.b	#$FF,$FFFF8802.w
	rts
	
vol	moveq	#64,d0
	lea	vtabend,a0
ploop	move.w	#255,d1
mloop	move.w	d1,d2
	ext.w	d2
	muls	d0,d2
	divs	#MVOL,d2
st_ch_1	add.b	#$80,d2	
	move.b	d2,-(a0)
	dbra	d1,mloop
	dbra	d0,ploop
	rts

incrcal	lea	stab,a0
	move.w	#$30,d1
	move.w	#$39F-$30,d0
st_ch_2	move.l	#INC_stf,d2
recalc	swap	d2
	moveq	#0,d3
	move.w	d2,d3
	divu	d1,d3
	move.w	d3,d4
	swap	d4
	swap	d2
	move.w	d2,d3
	divu	d1,d3
	move.w	d3,d4
	move.l	d4,(a0)+
	addq.w	#1,d1
	dbra	d0,recalc
	rts

stereo	movem.l	d0-a6,-(sp)
	jsr	music
	move	#5,-(sp)
rep_stereo	lea	itab,a5
	lea	vtab,a3
	moveq	#0,d0
	moveq	#0,d4
v1	movea.l	wiz2lc,a0
	move.w	wiz2pos,d0
	move.w	wiz2frc,d1
	move.w	aud2per,d7
	add.w	d7,d7
	add.w	d7,d7
	move.w	0(a5,d7.w),d2
	movea.w	2(a5,d7.w),a4
	move.w	aud2vol,d7
	asl.w	#8,d7
	lea	0(a3,d7.w),a2
	movea.l	wiz3lc,a1
	move.w	wiz3pos,d4
	move.w	wiz3frc,d5
	move.w	aud3per,d7
	add.w	d7,d7
	add.w	d7,d7
	move.w	0(a5,d7.w),d6
	movea.w	2(a5,d7.w),a5
	move.w	aud3vol,d7
	asl.w	#8,d7
	lea	0(a3,d7.w),a3
	movea.l	samp1,a6
add_ste_1	adda.w	#0,a6
	moveq	#0,d3
	REPT 	LEN_ste
	add.w	a4,d1
	addx.w	d2,d0
	add.w	a5,d5
	addx.w	d6,d4
	move.b	0(a0,d0.l),d3
	move.b	0(a2,d3.w),d7
	move.b	0(a1,d4.l),d3
	add.b	0(a3,d3.w),d7
	move.w	d7,(a6)+
	ENDR
	cmp.l	wiz2len,d0
	blt.s	.ok2
	sub.w	wiz2rpt,d0
.ok2	move.w	d0,wiz2pos
	move.w	d1,wiz2frc
	cmp.l	wiz3len,d4
	blt.s	.ok3
	sub.w	wiz3rpt,d4
.ok3	move.w	d4,wiz3pos
	move.w	d5,wiz3frc
	lea	itab,a5
	lea	vtab,a3
	moveq	#0,d0
	moveq	#0,d4
v2	movea.l	wiz1lc,a0
	move.w	wiz1pos,d0
	move.w	wiz1frc,d1
	move.w	aud1per,d7
	add.w	d7,d7
	add.w	d7,d7
	move.w	0(a5,d7.w),d2
	movea.w	2(a5,d7.w),a4
	move.w	aud1vol,d7
	asl.w	#8,d7
	lea	0(a3,d7.w),a2
	movea.l	wiz4lc,a1
	move.w	wiz4pos,d4
	move.w	wiz4frc,d5
	move.w	aud4per,d7
	add.w	d7,d7
	add.w	d7,d7
	move.w	0(a5,d7.w),d6
	movea.w	2(a5,d7.w),a5
	move.w	aud4vol,d7
	asl.w	#8,d7
	lea	0(a3,d7.w),a3
	movea.l	samp1,a6
add_ste_2	adda.w	#0,a6
	moveq	#0,d3
	REPT 	LEN_ste
	add.w	a4,d1
	addx.w	d2,d0
	add.w	a5,d5
	addx.w	d6,d4
	move.b	0(a0,d0.l),d3
	move.b	0(a2,d3.w),d7
	move.b	0(a1,d4.l),d3
	add.b	0(a3,d3.w),d7
	move.b	d7,(a6)
	addq.w	#2,a6
	ENDR
	cmp.l	wiz1len,d0
	blt.s	.ok1
	sub.w	wiz1rpt,d0
.ok1	move.w	d0,wiz1pos
	move.w	d1,wiz1frc
	cmp.l	wiz4len,d4
	blt.s	.ok4
	sub.w	wiz4rpt,d4
.ok4	move.w	d4,wiz4pos
	move.w	d5,wiz4frc
	add.w	#len_ste*2,add_ste_1+2
	add.w	#len_ste*2,add_ste_2+2
	subq.w	#1,(sp)
	bne	rep_stereo
	lea	2(sp),sp
	clr.w	add_ste_1+2
	clr.w	add_ste_2+2
	movem.l	(sp)+,d0-a6
	rts

play_stf	movem.l	d0-d4/a0-a4,-(sp)
	bsr	music
	move.l	samp2,d0
	move.l	samp1,samp2
	move.l	d0,samp1
	move	#parts_stf+1,-(sp)
rep_play_stf	lea	itab,a2
	lea	vtab,a4
	moveq	#0,d1
v1_2	movea.l	wiz1lc,a0
	move.w	wiz1pos,d1
	move.w	wiz1frc,d0
	move.w	aud1per,d4
	add.w	d4,d4
	add.w	d4,d4
	move.w	0(a2,d4.w),d3
	move.w	2(a2,d4.w),d2
	move.w	aud1vol,d4
	asl.w	#8,d4
	lea	0(a4,d4.w),a1
	moveq	#0,d4
	movea.l	samp1,a3
add_stf_1	adda.w	#0,a3
	REPT 	LEN_stf
	add.w	d2,d0
	addx.w	d3,d1
	move.b	0(a0,d1.l),d4
	move.b	0(a1,d4.w),d4
	move.w	d4,(a3)+
	ENDR
	cmp.l	wiz1len,d1
	blt.s	.ok1
	sub.w	wiz1rpt,d1
.ok1	move.w	d1,wiz1pos
	move.w	d0,wiz1frc
v2_2	movea.l	wiz2lc,a0
	move.w	wiz2pos,d1
	move.w	wiz2frc,d0
	move.w	aud2per,d4
	add.w	d4,d4
	add.w	d4,d4
	move.w	0(a2,d4.w),d3
	move.w	2(a2,d4.w),d2
	move.w	aud2vol,d4
	asl.w	#8,d4
	lea	0(a4,d4.w),a1
	moveq	#0,d4
	movea.l	samp1,a3
	bsr	v234
	cmp.l	wiz2len,d1
	blt.s	.ok2
	sub.w	wiz2rpt,d1
.ok2	move.w	d1,wiz2pos
	move.w	d0,wiz2frc
v3	movea.l	wiz3lc,a0
	move.w	wiz3pos,d1
	move.w	wiz3frc,d0
	move.w	aud3per,d4
	add.w	d4,d4
	add.w	d4,d4
	move.w	0(a2,d4.w),d3
	move.w	2(a2,d4.w),d2
	move.w	aud3vol,d4
	asl.w	#8,d4
	lea	0(a4,d4.w),a1
	moveq	#0,d4
	movea.l	samp1,a3
	bsr	v234
	cmp.l	wiz3len,d1
	blt.s	.ok3
	sub.w	wiz3rpt,d1
.ok3	move.w	d1,wiz3pos
	move.w	d0,wiz3frc
v4	movea.l	wiz4lc,a0
	move.w	wiz4pos,d1
	move.w	wiz4frc,d0
	move.w	aud4per,d4
	add.w	d4,d4
	add.w	d4,d4
	move.w	0(a2,d4.w),d3
	move.w	2(a2,d4.w),d2
	move.w	aud4vol,d4
	asl.w	#8,d4
	lea	0(a4,d4.w),a1
	moveq	#0,d4
	movea.l	samp1,a3
	bsr.s	v234
	cmp.l	wiz4len,d1
	blt.s	.ok4
	sub.w	wiz4rpt,d1
.ok4	move.w	d1,wiz4pos
	move.w	d0,wiz4frc
	add.w	#len_stf*2,add_stf_1+2
	add.w	#len_stf*2,add_stf_2+2
	subq.w	#1,(sp)
	bne	rep_play_stf
	clr.w	add_stf_1+2
	clr.w	add_stf_2+2
	lea	2(sp),sp
	movem.l	(sp)+,d0-d4/a0-a4
	rts
v234	
add_stf_2	adda.w	#0,a3
	REPT 	LEN_stf
	add.w	d2,d0
	addx.w	d3,d1
	move.b	0(a0,d1.l),d4
	move.b	0(a1,d4.w),d4
	add.w	d4,(a3)+
	ENDR
	rts

play_vec_st_replay
	move.l	a0,-(sp)
	move.w	(a6)+,d7
	lsr.w	#2,d7
	lea	$fffa0000,a0
	move.b	0(a0,d7.w),d7
	move.l	(sp)+,a0
	rte
	
play_vec_mv16	move.l	a0,-(sp)
	move.w	(a6)+,d7
	add.w	d7,d7
	add.w	d7,d7
	lea	$fffa0000,a0
	move.b	0(a0,d7.w),d7
	move.l	(sp)+,a0
	rte
	
prepare	lea	workspc,a6
	movea.l	samplestarts,a0
	movea.l	end_of_samples,a1
tostack	move.w	-(a1),-(a6)
	cmpa.l	a0,a1			; Move all samples to stack
	bgt.s	tostack
	lea	samplestarts,a2
	lea	data,a1
	movea.l	(a2),a0			; Start of samples
	movea.l	a0,a5			; Save samplestart in a5
ch_8	moveq	#$1e,d7
roop	move.l	a0,(a2)+			; Sampleposition
	tst.w	$2A(a1)
	beq.s	samplok			; Len=0 -> no sample
	tst.w	$2E(a1)			; Test repstrt
	bne.s	repne			; Jump if not zero
repeq	move.w	$2A(a1),d0			; Length of sample
	move.w	d0,d4
	subq.w	#1,d0
	movea.l	a0,a4
fromstk	move.w	(a6)+,(a0)+
	dbra	d0,fromstk
	bra.s	rep
repne	move.w	$2E(a1),d0
	move.w	d0,d4
	subq.w	#1,d0
	movea.l	a6,a4
get1st	move.w	(a4)+,(a0)+
	dbra	d0,get1st
	adda.w	$2A(a1),a6			; Move a6 to next sample
	adda.w	$2A(a1),a6
rep	movea.l	a0,a5
	moveq	#0,d1
toosmal	movea.l	a4,a3
	move.w	$30(a1),d0
	subq.w	#1,d0
moverep	move.w	(a3)+,(a0)+
	addq.w	#2,d1
	dbra	d0,moverep
	cmp.w	#320,d1			; Must be > 320
	blt.s	toosmal
	move.w	#320/2-1,d2
last320	move.w	(a5)+,(a0)+
	dbra	d2,last320
done	add.w	d4,d4
	move.w	d4,$2A(a1)			; length
	move.w	d1,$30(a1)			; Replen
	clr.w	$2E(a1)
samplok	lea	$1E(a1),a1
	dbra	d7,roop
	cmp.l	#workspc,a0
	bgt.s	.nospac
	rts
.nospac	illegal

init	lea	data,a0
	cmp.l	#'M.K.',$438(a0)
	bne.s	inst_15
	move	#$3b8,ch_1+2
	move.l	#$43c,ch_2+2
	move.b	#$1e,ch_3+1
	move.b	#$1e,ch_8+1
	move	#$3b8,ch_4+2
	move	#$43c,ch_5+2
	move.l	#data+$3b6,ch_6+2	
	move.l	#data+$3b7,ch_7+2
	bra.s	suite_init
inst_15	move	#$1d8,ch_1+2
	move.l	#$258,ch_2+2
	move.b	#$e,ch_3+1
	move.b	#$e,ch_8+1
	move	#$1d8,ch_4+2
	move	#$258,ch_5+2
	move.l	#data+$1d6,ch_6+2	
	move.l	#data+$1d7,ch_7+2
suite_init
ch_1	lea	$3B8(a0),a1
	moveq	#$7F,d0
	moveq	#0,d1
loop	move.l	d1,d2
	subq.w	#1,d0
lop2	move.b	(a1)+,d1
	cmp.b	d2,d1
	bgt.s	loop
	dbra	d0,lop2
	addq.b	#1,d2
	lea	samplestarts,a1
	asl.l	#8,d2
	asl.l	#2,d2
ch_2	add.l	#$43C,d2
	add.l	a0,d2
	movea.l	d2,a2
ch_3	moveq	#$1E,d0
lop3	clr.l	(a2)
	move.l	a2,(a1)+
	moveq	#0,d1
	move.w	42(a0),d1
	add.l	d1,d1
	adda.l	d1,a2
	adda.l	#$1E,a0
	dbra	d0,lop3
	move.l	a2,end_of_samples	
	rts

music	lea	data,a0
	addq.w	#$1,counter
	move.w	counter,d0
	cmp.w	speed,d0
	blt.s	nonew
	clr.w	counter
	bra	getnew
nonew	lea	voice1,a4
	lea	aud1lc,a3
	bsr	checkcom
	move.b	$13(a4),level
	lea	voice2,a4
	lea	aud2lc,a3
	bsr	checkcom
	move.b	$13(a4),level+1
	lea	voice3,a4
	lea	aud3lc,a3
	bsr	checkcom
	move.b	$13(a4),level+2
	lea	voice4,a4
	lea	aud4lc,a3
	bsr	checkcom
	move.b	$13(a4),level+3
	bra	endr

arpeggio	moveq	#0,d0
	move.w	counter,d0
	divs	#$3,d0
	swap	d0
	tst.w	d0
	beq.s	arp2
	cmp.w	#$2,d0
	beq.s	arp1
	moveq	#0,d0
	move.b	$3(a4),d0
	lsr.b	#4,d0
	bra.s	arp3
arp1	moveq	#0,d0
	move.b	$3(a4),d0
	and.b	#$F,d0
	bra.s	arp3
arp2	move.w	$10(a4),d2
	bra.s	arp4
arp3	add.w	d0,d0
	moveq	#0,d1
	move.w	$10(a4),d1
	lea	periods,a0
	moveq	#$24,d4
arploop	move.w	0(a0,d0.w),d2
	cmp.w	(a0),d1
	bge.s	arp4
	addq.l	#2,a0
	dbra	d4,arploop
	rts

arp4	move.w	d2,$6(a3)
	rts

getnew	lea	data,a0
	lea	$C(a0),a2
ch_4	lea	$3B8(a0),a1
ch_5	lea	$43c(a0),a0	
	moveq	#0,d0
	move.l	d0,d1
	move.b	songpos,d0
	move.b	0(a1,d0.w),d1
	asl.l	#8,d1
	asl.l	#2,d1
	add.w	pattpos,d1
	clr.w	dmacon
	lea	aud1lc,a3
	lea	voice1,a4
	bsr.s	playvoice
	lea	aud2lc,a3
	lea	voice2,a4
	bsr.s	playvoice
	lea	aud3lc,a3
	lea	voice3,a4
	bsr.s	playvoice
	lea	aud4lc,a3
	lea	voice4,a4
	bsr.s	playvoice
	bra	setdma

playvoice	move.l	0(a0,d1.l),(a4)
	addq.l	#4,d1
	moveq	#0,d2
	move.b	$2(a4),d2
	and.b	#$F0,d2
	lsr.b	#4,d2
	move.b	(a4),d0
	and.b	#$F0,d0
	or.b	d0,d2
	tst.b	d2
	beq.s	setregs
	moveq	#0,d3
	lea	samplestarts,a1
	move.l	d2,d4
	subq.l	#$1,d2
	asl.l	#2,d2
	mulu	#$1E,d4
	move.l	0(a1,d2.l),$4(a4)
	move.w	0(a2,d4.l),$8(a4)
	move.w	$2(a2,d4.l),$12(a4)
	move.w	$4(a2,d4.l),d3
	tst.w	d3
	beq.s	noloop
	move.l	$4(a4),d2
	add.w	d3,d3
	add.l	d3,d2
	move.l	d2,$A(a4)
	move.w	$4(a2,d4.l),d0
	add.w	$6(a2,d4.l),d0
	move.w	d0,8(a4)
	move.w	$6(a2,d4.l),$E(a4)
	move.w	$12(a4),$8(a3)
	bra.s	setregs

noloop	move.l	$4(a4),d2
	add.l	d3,d2
	move.l	d2,$A(a4)
	move.w	$6(a2,d4.l),$E(a4)
	move.w	$12(a4),$8(a3)
setregs	move.w	(a4),d0
	and.w	#$FFF,d0
	beq	checkcom2
	move.b	$2(a4),d0
	and.b	#$F,d0
	cmp.b	#$3,d0
	bne.s	setperiod
	bsr	setmyport
	bra	checkcom2

setperiod	move.w	(a4),$10(a4)
	andi.w	#$FFF,$10(a4)
	move.w	$14(a4),d0
	move.w	d0,dmactrl
	clr.b	$1B(a4)
	move.l	$4(a4),(a3)
	move.w	$8(a4),$4(a3)
	move.w	$10(a4),d0
	and.w	#$FFF,d0
	move.w	d0,$6(a3)
	move.w	$14(a4),d0
	or.w	d0,dmacon
	bra	checkcom2

setdma	move.w	dmacon,d0
	btst	#0,d0			
	beq.s	wz_nch1			
	move.l	aud1lc,wiz1lc	
	moveq	#0,d1			
	moveq	#0,d2			
	move.w	aud1len,d1	
	move.w	voice1+$E,d2	
	add.l	d2,d1			
	move.l	d1,wiz1len		
	move.w	d2,wiz1rpt		
	clr.w	wiz1pos			

wz_nch1	btst	#1,d0			
	beq.s	wz_nch2			
	move.l	aud2lc,wiz2lc	
	moveq	#0,d1			
	moveq	#0,d2			
	move.w	aud2len,d1		
	move.w	voice2+$E,d2	
	add.l	d2,d1			
	move.l	d1,wiz2len		
	move.w	d2,wiz2rpt		
	clr.w	wiz2pos			

wz_nch2	btst	#2,d0			
	beq.s	wz_nch3			
	move.l	aud3lc,wiz3lc	
	moveq	#0,d1			
	moveq	#0,d2			
	move.w	aud3len,d1		
	move.w	voice3+$E,d2	
	add.l	d2,d1			
	move.l	d1,wiz3len		
	move.w	d2,wiz3rpt		
	clr.w	wiz3pos			

wz_nch3	btst	#3,d0			
	beq.s	wz_nch4			
	move.l	aud4lc,wiz4lc	
	moveq	#0,d1			
	moveq	#0,d2			
	move.w	aud4len,d1		
	move.w	voice4+$E,d2	
	add.l	d2,d1			
	move.l	d1,wiz4len		
	move.w	d2,wiz4rpt		
	clr.w	wiz4pos			

wz_nch4	addi.w	#$10,pattpos
	cmpi.w	#$400,pattpos
	bne.s	endr
nex	clr.w	pattpos
	clr.b	break
	addq.b	#1,songpos
	andi.b	#$7F,songpos
	move.b	songpos,d1
ch_6	cmp.b	data+$3B6,d1
	bne.s	endr
ch_7	move.b	data+$3B7,songpos
endr:	tst.b	break
	bne.s	nex
	rts

setmyport	move.w	(a4),d2
	and.w	#$FFF,d2
	move.w	d2,$18(a4)
	move.w	$10(a4),d0
	clr.b	$16(a4)
	cmp.w	d0,d2
	beq.s	clrport
	bge.s	rt
	move.b	#$1,$16(a4)
	rts

clrport	clr.w	$18(a4)
rt	rts

myport	move.b	$3(a4),d0
	beq.s	myslide
	move.b	d0,$17(a4)
	clr.b	$3(a4)
myslide	tst.w	$18(a4)
	beq.s	rt
	moveq	#0,d0
	move.b	$17(a4),d0
	tst.b	$16(a4)
	bne.s	mysub
	add.w	d0,$10(a4)
	move.w	$18(a4),d0
	cmp.w	$10(a4),d0
	bgt.s	myok
	move.w	$18(a4),$10(a4)
	clr.w	$18(a4)

myok	move.w	$10(a4),$6(a3)
	rts

mysub	sub.w	d0,$10(a4)
	move.w	$18(a4),d0
	cmp.w	$10(a4),d0
	blt.s	myok
	move.w	$18(a4),$10(a4)
	clr.w	$18(a4)
	move.w	$10(a4),$6(a3)
	rts

vib	move.b	$3(a4),d0
	beq.s	vi
	move.b	d0,$1A(a4)

vi	move.b	$1B(a4),d0
	lea	sin,a1
	lsr.w	#$2,d0
	and.w	#$1F,d0
	moveq	#0,d2
	move.b	0(a1,d0.w),d2
	move.b	$1A(a4),d0
	and.w	#$F,d0
	mulu	d0,d2
	lsr.w	#$6,d2
	move.w	$10(a4),d0
	tst.b	$1B(a4)
	bmi.s	vibmin
	add.w	d2,d0
	bra.s	vib2

vibmin	sub.w	d2,d0
vib2	move.w	d0,$6(a3)
	move.b	$1A(a4),d0
	lsr.w	#$2,d0
	and.w	#$3C,d0
	add.b	d0,$1B(a4)
	rts

nop:	move.w	$10(a4),$6(a3)
	rts

checkcom	move.w	$2(a4),d0
	and.w	#$FFF,d0
	beq.s	nop
	move.b	$2(a4),d0
	and.b	#$F,d0
	tst.b	d0
	beq	arpeggio
	cmp.b	#$1,d0
	beq.s	portup
	cmp.b	#$2,d0
	beq	portdown
	cmp.b	#$3,d0
	beq	myport
	cmp.b	#$4,d0
	beq	vib
	cmp.b	#$5,d0
	beq	port_toneslide
	cmp.b	#$6,d0
	beq	vib_toneslide
	move.w	$10(a4),$6(a3)
	cmp.b	#$A,d0
	beq.s	volslide
	rts

volslide	moveq	#0,d0
	move.b	$3(a4),d0
	lsr.b	#4,d0
	tst.b	d0
	beq.s	voldown
	add.w	d0,$12(a4)
	cmpi.w	#$40,$12(a4)
	bmi.s	vol2
	move.w	#$40,$12(a4)
vol2	move.w	$12(a4),$8(a3)
	rts

voldown	moveq	#0,d0
	move.b	$3(a4),d0
	and.b	#$F,d0
	sub.w	d0,$12(a4)
	bpl.s	vol3
	clr.w	$12(a4)
vol3	move.w	$12(a4),$8(a3)
	rts

portup	moveq	#0,d0
	move.b	$3(a4),d0
	sub.w	d0,$10(a4)
	move.w	$10(a4),d0
	and.w	#$FFF,d0
	cmp.w	#$71,d0
	bpl.s	por2
	andi.w	#$F000,$10(a4)
	ori.w	#$71,$10(a4)
por2	move.w	$10(a4),d0
	and.w	#$FFF,d0
	move.w	d0,$6(a3)
	rts

port_toneslide	bsr	myslide
	bra.s	volslide

vib_toneslide	bsr	vi
	bra.s	volslide

portdown	clr.w	d0
	move.b	$3(a4),d0
	add.w	d0,$10(a4)
	move.w	$10(a4),d0
	and.w	#$FFF,d0
	cmp.w	#$358,d0
	bmi.s	por3
	andi.w	#$F000,$10(a4)
	ori.w	#$358,$10(a4)
por3	move.w	$10(a4),d0
	and.w	#$FFF,d0
	move.w	d0,$6(a3)
	rts

checkcom2	move.b	$2(a4),d0
	and.b	#$F,d0
	cmp.b	#$D,d0
	beq.s	pattbreak
	cmp.b	#$B,d0
	beq.s	posjmp
	cmp.b	#$C,d0
	beq.s	setvol
	cmp.b	#$F,d0
	beq.s	setspeed
	rts

pattbreak	st	break
	rts

posjmp	move.b	$3(a4),d0
	subq.b	#$1,d0
	move.b	d0,songpos
	st	break
	rts

setvol	moveq	#0,d0
	move.b	$3(a4),d0
	cmp.w	#$40,d0
	ble.s	vol4
	move.b	#$40,$3(a4)
vol4	move.b	$3(a4),$9(a3)
	move.b	$3(a4),$13(a4)
	rts

setspeed	cmpi.b	#$1F,$3(a4)
	ble.s	sets
	move.b	#$1F,$3(a4)
sets	move.b	$3(a4),d0
	beq.s	rts2
	move.w	d0,speed
	clr.w	counter
rts2	rts

play_vec_stf	movem.l	d5-d7,-(a7)
	move.w	(a6)+,d7
	lsl.w	#4,d7
	movem.l	snd_tab(pc,d7.w),d5-d7
	movem.l	d5-d7,$FFFF8800.w
	movem.l	(a7)+,d5-d7
	rte

	even
snd_tab	REPT 	384
	DC.L 	$08000F00,$09000A00,$0A000000,0
	ENDR
	DC.L 	$08000F00,$09000A00,$0A000000,0
	DC.L 	$08000F00,$09000A00,$0A000000,0
	DC.L 	$08000F00,$09000900,$0A000900,0
	DC.L 	$08000F00,$09000900,$0A000900,0
	DC.L 	$08000F00,$09000900,$0A000800,0
	DC.L 	$08000F00,$09000900,$0A000800,0
	DC.L 	$08000F00,$09000800,$0A000700,0
	DC.L 	$08000F00,$09000800,$0A000700,0
	DC.L 	$08000E00,$09000B00,$0A000D00,0
	DC.L 	$08000E00,$09000B00,$0A000D00,0
	DC.L 	$08000E00,$09000D00,$0A000B00,0
	DC.L 	$08000E00,$09000D00,$0A000B00,0
	DC.L 	$08000E00,$09000A00,$0A000D00,0
	DC.L 	$08000E00,$09000A00,$0A000D00,0
	DC.L 	$08000E00,$09000C00,$0A000C00,0
	DC.L 	$08000E00,$09000C00,$0A000C00,0
	DC.L 	$08000E00,$09000D00,$0A000A00,0
	DC.L 	$08000E00,$09000D00,$0A000A00,0
	DC.L 	$08000E00,$09000D00,$0A000900,0
	DC.L 	$08000E00,$09000D00,$0A000900,0
	DC.L 	$08000E00,$09000D00,$0A000800,0
	DC.L 	$08000E00,$09000D00,$0A000800,0
	DC.L 	$08000E00,$09000D00,$0A000700,0
	DC.L 	$08000E00,$09000D00,$0A000700,0
	DC.L 	$08000E00,$09000D00,$0A000000,0
	DC.L 	$08000E00,$09000D00,$0A000000,0
	DC.L 	$08000B00,$09000E00,$0A000C00,0
	DC.L 	$08000B00,$09000E00,$0A000C00,0
	DC.L 	$08000E00,$09000B00,$0A000C00,0
	DC.L 	$08000E00,$09000B00,$0A000C00,0
	DC.L 	$08000E00,$09000C00,$0A000B00,0
	DC.L 	$08000E00,$09000C00,$0A000B00,0
	DC.L 	$08000A00,$09000E00,$0A000C00,0
	DC.L 	$08000A00,$09000E00,$0A000C00,0
	DC.L 	$08000E00,$09000A00,$0A000C00,0
	DC.L 	$08000E00,$09000A00,$0A000C00,0
	DC.L 	$08000E00,$09000C00,$0A000A00,0
	DC.L 	$08000E00,$09000C00,$0A000A00,0
	DC.L 	$08000E00,$09000900,$0A000C00,0
	DC.L 	$08000E00,$09000900,$0A000C00,0
	DC.L 	$08000E00,$09000C00,$0A000900,0
	DC.L 	$08000E00,$09000C00,$0A000900,0
	DC.L 	$08000E00,$09000C00,$0A000800,0
	DC.L 	$08000E00,$09000C00,$0A000800,0
	DC.L 	$08000E00,$09000C00,$0A000800,0
	DC.L 	$08000E00,$09000C00,$0A000700,0
	DC.L 	$08000E00,$09000C00,$0A000700,0
	DC.L 	$08000E00,$09000C00,$0A000600,0
	DC.L 	$08000E00,$09000C00,$0A000300,0
	DC.L 	$08000D00,$09000D00,$0A000B00,0
	DC.L 	$08000D00,$09000D00,$0A000B00,0
	DC.L 	$08000D00,$09000D00,$0A000B00,0
	DC.L 	$08000E00,$09000B00,$0A000A00,0
	DC.L 	$08000E00,$09000B00,$0A000A00,0
	DC.L 	$08000D00,$09000C00,$0A000C00,0
	DC.L 	$08000D00,$09000C00,$0A000C00,0
	DC.L 	$08000D00,$09000C00,$0A000C00,0
	DC.L 	$08000D00,$09000D00,$0A000A00,0
	DC.L 	$08000D00,$09000D00,$0A000A00,0
	DC.L 	$08000E00,$09000B00,$0A000800,0
	DC.L 	$08000E00,$09000B00,$0A000800,0
	DC.L 	$08000E00,$09000B00,$0A000800,0
	DC.L 	$08000D00,$09000D00,$0A000900,0
	DC.L 	$08000D00,$09000D00,$0A000900,0
	DC.L 	$08000E00,$09000A00,$0A000900,0
	DC.L 	$08000E00,$09000A00,$0A000900,0
	DC.L 	$08000D00,$09000D00,$0A000800,0
	DC.L 	$08000D00,$09000D00,$0A000700,0
	DC.L 	$08000D00,$09000D00,$0A000600,0
	DC.L 	$08000D00,$09000D00,$0A000600,0
	DC.L 	$08000E00,$09000900,$0A000900,0
	DC.L 	$08000E00,$09000900,$0A000900,0
	DC.L 	$08000E00,$09000800,$0A000900,0
	DC.L 	$08000E00,$09000800,$0A000900,0
	DC.L 	$08000E00,$09000900,$0A000800,0
	DC.L 	$08000E00,$09000900,$0A000800,0
	DC.L 	$08000E00,$09000700,$0A000900,0
	DC.L 	$08000E00,$09000900,$0A000700,0
	DC.L 	$08000E00,$09000900,$0A000700,0
	DC.L 	$08000E00,$09000900,$0A000600,0
	DC.L 	$08000E00,$09000900,$0A000600,0
	DC.L 	$08000E00,$09000800,$0A000700,0
	DC.L 	$08000E00,$09000800,$0A000700,0
	DC.L 	$08000E00,$09000800,$0A000600,0
	DC.L 	$08000E00,$09000800,$0A000600,0
	DC.L 	$08000E00,$09000800,$0A000400,0
	DC.L 	$08000E00,$09000800,$0A000400,0
	DC.L 	$08000E00,$09000700,$0A000500,0
	DC.L 	$08000E00,$09000700,$0A000400,0
	DC.L 	$08000E00,$09000700,$0A000300,0
	DC.L 	$08000E00,$09000600,$0A000400,0
	DC.L 	$08000E00,$09000600,$0A000300,0
	DC.L 	$08000E00,$09000500,$0A000400,0
	DC.L 	$08000E00,$09000500,$0A000200,0
	DC.L 	$08000E00,$09000400,$0A000200,0
	DC.L 	$08000E00,$09000300,$0A000200,0
	DC.L 	$08000E00,$09000000,$0A000000,0
	DC.L 	$08000D00,$09000B00,$0A000A00,0
	DC.L 	$08000D00,$09000B00,$0A000A00,0
	DC.L 	$08000A00,$09000C00,$0A000C00,0
	DC.L 	$08000A00,$09000C00,$0A000C00,0
	DC.L 	$08000C00,$09000A00,$0A000C00,0
	DC.L 	$08000D00,$09000900,$0A000B00,0
	DC.L 	$08000D00,$09000900,$0A000B00,0
	DC.L 	$08000D00,$09000B00,$0A000900,0
	DC.L 	$08000D00,$09000B00,$0A000900,0
	DC.L 	$08000D00,$09000B00,$0A000900,0
	DC.L 	$08000D00,$09000A00,$0A000A00,0
	DC.L 	$08000D00,$09000A00,$0A000A00,0
	DC.L 	$08000900,$09000C00,$0A000C00,0
	DC.L 	$08000C00,$09000C00,$0A000900,0
	DC.L 	$08000C00,$09000C00,$0A000900,0
	DC.L 	$08000C00,$09000C00,$0A000900,0
	DC.L 	$08000800,$09000C00,$0A000C00,0
	DC.L 	$08000800,$09000C00,$0A000C00,0
	DC.L 	$08000C00,$09000C00,$0A000800,0
	DC.L 	$08000C00,$09000C00,$0A000800,0
	DC.L 	$08000D00,$09000B00,$0A000400,0
	DC.L 	$08000D00,$09000B00,$0A000400,0
	DC.L 	$08000C00,$09000C00,$0A000700,0
	DC.L 	$08000C00,$09000C00,$0A000600,0
	DC.L 	$08000C00,$09000C00,$0A000600,0
	DC.L 	$08000C00,$09000C00,$0A000500,0
	DC.L 	$08000D00,$09000A00,$0A000700,0
	DC.L 	$08000D00,$09000A00,$0A000600,0
	DC.L 	$08000D00,$09000A00,$0A000600,0
	DC.L 	$08000D00,$09000A00,$0A000500,0
	DC.L 	$08000D00,$09000900,$0A000800,0
	DC.L 	$08000C00,$09000B00,$0A000900,0
	DC.L 	$08000B00,$09000B00,$0A000B00,0
	DC.L 	$08000D00,$09000800,$0A000800,0
	DC.L 	$08000D00,$09000800,$0A000800,0
	DC.L 	$08000C00,$09000B00,$0A000800,0
	DC.L 	$08000D00,$09000900,$0A000500,0
	DC.L 	$08000D00,$09000900,$0A000400,0
	DC.L 	$08000D00,$09000800,$0A000600,0
	DC.L 	$08000C00,$09000B00,$0A000700,0
	DC.L 	$08000D00,$09000700,$0A000700,0
	DC.L 	$08000C00,$09000B00,$0A000600,0
	DC.L 	$08000B00,$09000B00,$0A000A00,0
	DC.L 	$08000800,$09000A00,$0A000C00,0
	DC.L 	$08000C00,$09000B00,$0A000200,0
	DC.L 	$08000C00,$09000A00,$0A000800,0
	DC.L 	$08000C00,$09000B00,$0A000000,0
	DC.L 	$08000D00,$09000600,$0A000400,0
	DC.L 	$08000D00,$09000500,$0A000500,0
	DC.L 	$08000C00,$09000900,$0A000900,0
	DC.L 	$08000D00,$09000500,$0A000400,0
	DC.L 	$08000B00,$09000B00,$0A000900,0
	DC.L 	$08000D00,$09000400,$0A000300,0
	DC.L 	$08000B00,$09000A00,$0A000A00,0
	DC.L 	$08000C00,$09000A00,$0A000500,0
	DC.L 	$08000C00,$09000900,$0A000800,0
	DC.L 	$08000B00,$09000B00,$0A000800,0
	DC.L 	$08000C00,$09000A00,$0A000000,0
	DC.L 	$08000C00,$09000A00,$0A000000,0
	DC.L 	$08000C00,$09000900,$0A000700,0
	DC.L 	$08000B00,$09000B00,$0A000700,0
	DC.L 	$08000C00,$09000900,$0A000600,0
	DC.L 	$08000B00,$09000A00,$0A000900,0
	DC.L 	$08000B00,$09000B00,$0A000600,0
	DC.L 	$08000A00,$09000A00,$0A000A00,0
	DC.L 	$08000B00,$09000B00,$0A000500,0
	DC.L 	$08000B00,$09000A00,$0A000800,0
	DC.L 	$08000B00,$09000B00,$0A000200,0
	DC.L 	$08000C00,$09000700,$0A000700,0
	DC.L 	$08000C00,$09000800,$0A000400,0
	DC.L 	$08000C00,$09000700,$0A000600,0
	DC.L 	$08000B00,$09000900,$0A000900,0
	DC.L 	$08000A00,$09000A00,$0A000900,0
	DC.L 	$08000C00,$09000600,$0A000600,0
	DC.L 	$08000C00,$09000700,$0A000300,0
	DC.L 	$08000B00,$09000A00,$0A000500,0
	DC.L 	$08000B00,$09000900,$0A000800,0
	DC.L 	$08000B00,$09000A00,$0A000300,0
	DC.L 	$08000A00,$09000A00,$0A000800,0
	DC.L 	$08000B00,$09000A00,$0A000000,0
	DC.L 	$08000B00,$09000900,$0A000700,0
	DC.L 	$08000B00,$09000800,$0A000800,0
	DC.L 	$08000A00,$09000900,$0A000900,0
	DC.L 	$08000A00,$09000A00,$0A000700,0
	DC.L 	$08000C00,$09000100,$0A000100,0
	DC.L 	$08000A00,$09000A00,$0A000600,0
	DC.L 	$08000B00,$09000800,$0A000700,0
	DC.L 	$08000A00,$09000A00,$0A000500,0
	DC.L 	$08000A00,$09000900,$0A000800,0
	DC.L 	$08000A00,$09000A00,$0A000400,0
	DC.L 	$08000A00,$09000A00,$0A000300,0
	DC.L 	$08000A00,$09000A00,$0A000200,0
	DC.L 	$08000900,$09000900,$0A000900,0
	DC.L 	$08000A00,$09000800,$0A000800,0
	DC.L 	$08000B00,$09000800,$0A000100,0
	DC.L 	$08000A00,$09000900,$0A000600,0
	DC.L 	$08000B00,$09000700,$0A000400,0
	DC.L 	$08000A00,$09000900,$0A000500,0
	DC.L 	$08000900,$09000900,$0A000800,0
	DC.L 	$08000A00,$09000900,$0A000300,0
	DC.L 	$08000A00,$09000800,$0A000600,0
	DC.L 	$08000900,$09000900,$0A000700,0
	DC.L 	$08000A00,$09000900,$0A000000,0
	DC.L 	$08000900,$09000800,$0A000800,0
	DC.L 	$08000A00,$09000800,$0A000400,0
	DC.L 	$08000900,$09000900,$0A000600,0
	DC.L 	$08000A00,$09000800,$0A000100,0
	DC.L 	$08000900,$09000900,$0A000500,0
	DC.L 	$08000900,$09000800,$0A000700,0
	DC.L 	$08000800,$09000800,$0A000800,0
	DC.L 	$08000900,$09000800,$0A000600,0
	DC.L 	$08000900,$09000900,$0A000200,0
	DC.L 	$08000900,$09000700,$0A000700,0
	DC.L 	$08000900,$09000900,$0A000000,0
	DC.L 	$08000800,$09000800,$0A000700,0
	DC.L 	$08000900,$09000700,$0A000600,0
	DC.L 	$08000800,$09000800,$0A000600,0
	DC.L 	$08000900,$09000800,$0A000200,0
	DC.L 	$08000900,$09000600,$0A000600,0
	DC.L 	$08000800,$09000700,$0A000700,0
	DC.L 	$08000800,$09000800,$0A000400,0
	DC.L 	$08000800,$09000700,$0A000600,0
	DC.L 	$08000800,$09000800,$0A000200,0
	DC.L 	$08000700,$09000700,$0A000700,0
	DC.L 	$08000800,$09000600,$0A000600,0
	DC.L 	$08000800,$09000700,$0A000400,0
	DC.L 	$08000700,$09000700,$0A000600,0
	DC.L 	$08000800,$09000600,$0A000500,0
	DC.L 	$08000800,$09000600,$0A000400,0
	DC.L 	$08000700,$09000600,$0A000600,0
	DC.L 	$08000700,$09000700,$0A000400,0
	DC.L 	$08000800,$09000500,$0A000400,0
	DC.L 	$08000600,$09000600,$0A000600,0
	DC.L 	$08000700,$09000600,$0A000400,0
	DC.L 	$08000700,$09000500,$0A000500,0
	DC.L 	$08000600,$09000600,$0A000500,0
	DC.L 	$08000600,$09000600,$0A000400,0
	DC.L 	$08000600,$09000500,$0A000500,0
	DC.L 	$08000600,$09000600,$0A000200,0
	DC.L 	$08000600,$09000500,$0A000400,0
	DC.L 	$08000500,$09000500,$0A000500,0
	DC.L 	$08000600,$09000500,$0A000200,0
	DC.L 	$08000500,$09000500,$0A000400,0
	DC.L 	$08000500,$09000400,$0A000400,0
	DC.L 	$08000500,$09000500,$0A000200,0
	DC.L 	$08000400,$09000400,$0A000400,0
	DC.L 	$08000400,$09000400,$0A000300,0
	DC.L 	$08000400,$09000400,$0A000200,0
	DC.L 	$08000400,$09000300,$0A000300,0
	DC.L 	$08000300,$09000300,$0A000300,0
	DC.L 	$08000300,$09000300,$0A000200,0
	DC.L 	$08000300,$09000200,$0A000200,0
	DC.L 	$08000200,$09000200,$0A000200,0
	DC.L 	$08000200,$09000200,$0A000100,0
	DC.L 	$08000100,$09000100,$0A000100,0
	DC.L 	$08000200,$09000100,$0A000000,0
	DC.L 	$08000100,$09000100,$0A000000,0
	DC.L 	$08000100,$09000000,$0A000000,0
	DC.L 	$08000000,$09000000,$0A000000,0
	REPT 	384
	DC.L 	$08000000,$09000000,$0A000000,0
	ENDR
	even
sav_usp	ds.l	1
sav_a7	ds.l	1
sav_rez	ds.w	1
sav_screen	ds.l	1
sav_hz	ds.w	1
sav_pal	ds.w	16
mfp	ds.b	20
sav_vbl	ds.l	1
sav_timer_b	ds.l	1
sav_timer_d	ds.l	1
	even
wiz1lc	DC.L 	sample1
wiz1len	DC.L 	320	
wiz1rpt	DC.W 	320
wiz1pos	DC.W 	0
wiz1frc	DC.W 	0
wiz2lc	DC.L 	sample1
wiz2len	DC.L 	320
wiz2rpt	DC.W 	320
wiz2pos	DC.W 	0
wiz2frc	DC.W 	0
wiz3lc	DC.L 	sample1
wiz3len	DC.L 	320
wiz3rpt	DC.W 	320
wiz3pos	DC.W 	0
wiz3frc	DC.W 	0
wiz4lc	DC.L 	sample1
wiz4len	DC.L 	320
wiz4rpt	DC.W 	320
wiz4pos	DC.W 	0
wiz4frc	DC.W 	0
aud1lc	DC.L 	dummy
aud1len	DC.W 	0
aud1per	DC.W 	0
aud1vol	DC.W 	0
	DS.W 	3
aud2lc	DC.L 	dummy
aud2len	DC.W 	0
aud2per	DC.W 	0
aud2vol	DC.W 	0
	DS.W 	3
aud3lc	DC.L 	dummy
aud3len	DC.W 	0	
aud3per	DC.W 	0
aud3vol	DC.W 	0
	DS.W 	3
aud4lc	DC.L 	dummy
aud4len	DC.W 	0
aud4per	DC.W 	0
aud4vol	DC.W 	0
dmactrl	DC.W 	0
dummy	DC.L 	0
samp1	DC.L 	sample1
samp2	DC.L 	sample2
sample1	ds.w	len_ste*5
sample2	ds.w	len_ste*5
level	ds.b	4
out_inter	dc.l	play_vec_stf,play_vec_st_replay,play_vec_mv16
end_of_samples	DC.L 	0
itab	DS.L 	$30
stab	DS.L 	$3A0-$30
vtab	DS.B 	65*256	
vtabend	even
sin	DC.B 	$00,$18,$31,$4A,$61,$78,$8D,$A1,$B4,$C5,$D4,$E0,$EB,$F4,$FA,$FD
	DC.B 	$FF,$FD,$FA,$F4,$EB,$E0,$D4,$C5,$B4,$A1,$8D,$78,$61,$4A,$31,$18
	even
periods	DC.W 	$0358,$0328,$02FA,$02D0,$02A6,$0280,$025C,$023A,$021A,$01FC,$01E0
	DC.W 	$01C5,$01AC,$0194,$017D,$0168,$0153,$0140,$012E,$011D,$010D,$FE
	DC.W 	$F0,$E2,$D6,$CA,$BE,$B4,$AA,$A0,$97,$8F,$87
	DC.W 	$7F,$78,$71,$00,$00
speed	DC.W 	$06	
counter	DC.W 	$00
songpos	DC.B 	$00
break	DC.B 	$00
pattpos	DC.W 	$00
dmacon	DC.W 	$00
samplestarts	DS.L 	$1F
voice1	DS.W 	10
	DC.W 	$01
	DS.W 	3
voice2	DS.W 	10
	DC.W 	$02
	DS.W 	3
voice3	DS.W 	10
	DC.W 	$04
	DS.W 	3
voice4	DS.W 	10
	DC.W 	$08
	DS.W 	3
st	dc.b	0
out	dc.b	0
	even
buffer_dma	ds.l	2
	dc.w	10,2
	dc.w	0
	ds.l	3
	even
pt_pass	ds.l	1
table1	dcb.b	7,0
	dc.b	1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
	dc.b	40,60,80,100,120,140,160,180,200
	dc.b	199,198,197,196,195,194,193,192,191,190,189,188,187,186,185,184,183,182,181
	dc.b	161,141,121,101,81,61,41,21
	dc.b	22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39
	dc.b	59,79,99,119,139,159,179
	dc.b	178,177,176,175,174,173,172,171,170,169,168,167,166,165,164,163,162
	dc.b	142,122,102,82,62,42
	dc.b	43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58
	dc.b	78,98,118,138,158
	dc.b	157,156,155,154,153,152,151,150,149,148,147,146,145,144,143
	dc.b	123,103,83,63
	dc.b	64,65,66,67,68,69,70,71,72,73,74,75,76,77
	dc.b	97,117,137
	dc.b	136,135,134,133,132,131,130,129,128,127,126,125,124
	dc.b	104,84
	dc.b	85,86,87,88,89,90,91,92,93,94,95,96
	dc.b	116
	dc.b	115,114,113,112,111,110,109,108,107,106,105
	dc.b	201
	dcb.b	20,0
	even
table2	dcb.b	15,0
	dc.b	1,21,41,61,81,101,121,141,161,181
	dc.b	182,162,142,122,102,82,62,42,22,2
	dc.b	3,23,43,63,83,103,123,143,163,183
	dc.b	184,164,144,124,104,84,64,44,24,4
	dc.b	5,25,45,65,85,105,125,145,165,185
	dc.b	186,166,146,126,106,86,66,46,26,6
	dc.b	7,27,47,67,87,107,127,147,167,187
	dc.b	188,168,148,128,108,88,68,48,28,8
	dc.b	9,29,49,69,89,109,129,149,169,189
	dc.b	190,170,150,130,110,90,70,50,30,10
	dc.b	11,31,51,71,91,111,131,151,171,191
	dc.b	192,172,152,132,112,92,72,52,32,12
	dc.b	13,33,53,73,93,113,133,153,173,193
	dc.b	194,174,154,134,114,94,74,54,34,14
	dc.b	15,35,55,75,95,115,135,155,175,195
	dc.b	196,176,156,136,116,96,76,56,36,16
	dc.b	17,37,57,77,97,117,137,157,177,197
	dc.b	198,178,158,138,118,98,78,58,38,18
	dc.b	19,39,59,79,99,119,139,159,179,199
	dc.b	200,180,160,140,120,100,80,60,40,20
	dc.b	201
	dcb.b	20,0
	even
table3	dcb.b	15,0
	dc.b	1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
	dc.b	40,39,38,37,36,35,34,33,32,31,30,29,28,27,26,25,24,23,22,21
	dc.b	41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60
	dc.b	80,79,78,77,76,75,74,73,72,71,70,69,68,67,66,65,64,63,62,61
	dc.b	81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100
	dc.b	120,119,118,117,116,115,114,113,112,111,110,109,108,107,106,105,104,103,102,101
	dc.b	121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140
	dc.b	160,159,158,157,156,155,154,153,152,151,150,149,148,147,146,145,144,143,142,141
	dc.b	161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180
	dc.b	200,199,198,197,196,195,194,193,192,191,190,189,188,187,186,185,184,183,182,181
	dc.b	201
	dcb.b	20,0
	even
table4	dcb.b	15,0
	dc.b	90,91,92,93,94,95,96,97,98,99,100,120,140,160,180,200
	dc.b	199,198,197,196,195,194,193,192,191,190,189,188,187,186,185,184,183,182,181
	dc.b	161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179
	dc.b	159,158,157,156,155,154,153,152,151,150,149,148,147,146,145,144,143,142,141
	dc.b	121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139
	dc.b	119,118,117,116,115,114,113,112,111,110,109,108,107,106,105,104,103,102,101
	dc.b	81,82,83,84,85,86,87,88,89,69,68,67,66,65,64,63,62,61,41,42,43,44,45,46,47,48,49
	dc.b	29,28,27,26,25,24,23,22,21,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
	dc.b	40,60,80,79,78,77,76,75,74,73,72,71,70,50,51,52,53,54,55,56,57,58,59
	dc.b	39,38,37,36,35,34,33,32,31,30
	dc.b	201
	dcb.b	20,0
	even
table5	dcb.b	15,0
	dc.b	1,22,43,64,85,106,127,148,169,190,171,152,133,114,95,76,57,38,19,40,59,78,97,116,135
	dc.b	154,173,192,150,129,108,87,66,45,24,3,41,62,83,104,125,146,167,188,131,112,93,74,55
	dc.B	36,17,80,99,118,137,156,175,194,110,89,68,47,26,5,81,102,123,144,165,186,91,72,53,34
	dc.B	15,120,139,158,177,196,70,49,28,7,121,142,163,184,51,32,13,160,179,198,30,9,161,182
	dc.b	11,200,180,159,138,117,96,75,54,33,12,31,50,69,88,107,126,145,164,183,162,141,122
	dc.b	103,84,65,46,27,8,29,71,92,113,134,155,176,197,178,140,119,98,77,56,35,14,52,90,109
	dc.b	128,147,166,185,143,101,82,63,44,25,6,48,111,132,153,174,195,157,100,79,58,37,16
	dc.b	73,130,149,168,187,124,61,42,23,4,67,151,172,193,136,60,39,18,94,170,189,105,21,2,86
	dc.b	191,115,20,10,181,199
	dc.b	201
	dcb.b	20,0
	even
table6	dcb.b	15,0
	dc.b	1,21,41,61,81,101,121,141,161,181,183,163,143,123,103,83,63,43,23,3
	dc.b	5,25,45,65,85,105,125,145,165,185,187,167,147,127,107,87,67,47,27,7
	dc.b	9,29,49,69,89,109,129,149,169,189,191,171,151,131,111,91,71,51,31,11
	dc.b	13,33,53,73,93,113,133,153,173,193,195,175,155,135,115,95,75,55,35,15
	dc.b	17,37,57,77,97,117,137,157,177,197,199,179,159,139,119,99,79,59,39,19
	dc.b	20,40,60,80,100,120,140,160,180,200,198,178,158,138,118,98,78,58,38,18
	dc.b	16,36,56,76,96,116,136,156,176,196,194,174,154,134,114,94,74,54,34,14
	dc.b	12,32,52,72,92,112,132,152,172,192,190,170,150,130,110,90,70,50,30,10
	dc.b	8,28,48,68,88,108,128,148,168,188,186,166,146,126,106,86,66,46,26,6
	dc.b	4,24,44,64,84,104,124,144,164,184,182,162,142,122,102,82,62,42,22,2
	dc.b	201
	dcb.b	20,0
	even
table7	dcb.b	15,0
	dc.b	101,121,141,161,181,182,162,142,122,102,103,123,143,163,183,184,164,144,124,104
	dc.b	105,125,145,165,185,186,166,146,126,106,107,127,147,167,187,188,168,148,128,108
	dc.b	109,129,149,169,189,190,170,150,130,110,111,131,151,171,191,192,172,152,132,112
	dc.b	113,133,153,173,193,194,174,154,134,114,115,135,155,175,195,196,176,156,136,116
	dc.b	117,137,157,177,197,198,178,158,138,118,119,139,159,179,199,200,180,160,140,120
	dc.B	100,80,60,40,20,19,39,59,79,99,98,78,58,38,18,17,37,57,77,97,96,76,56,36,16,15
	dc.b	35,55,75,95,94,74,54,34,14,13,33,53,73,93,92,72,52,32,12,11,31,51,71,91,90
	dc.b	70,50,30,10,9,29,49,69,89,88,68,48,28,8,7,27,47,67,87,86,66,46,26,6,5,25,45,65,85
	dc.b	84,64,44,24,4,3,23,43,63,83,82,62,42,22,2,1,21,41,61,81
	dc.b	201
	dcb.b	20,0
	even
table8	dcb.b	15,0
	dc.b	181
	dc.b	161,182
	dc.b	183,162,141
	dc.b	121,142,163,184
	dc.b	185,164,143,122,101
	dc.b	81,102,123,144,165,186
	dc.b	187,166,145,124,103,82,61
	dc.b	41,62,83,104,125,146,167,188
	dc.b	189,168,147,126,105,84,63,42,21
	dc.b	1,22,43,64,85,106,127,148,169,190
	dc.b	191,170,149,128,107,86,65,44,23,2
	dc.b	3,24,45,66,87,108,129,150,171,192
	dc.b	193,172,151,130,109,88,67,46,25,4
	dc.b	5,26,47,68,89,110,131,152,173,194
	dc.b	195,174,153,132,111,90,69,48,27,6
	dc.b	7,28,49,70,91,112,133,154,175,196
	dc.b	197,176,155,134,113,92,71,50,29,8
	dc.b	9,30,51,72,93,114,135,156,177,198
	dc.b	199,178,157,136,115,94,73,52,31,10
	dc.b	11,32,53,74,95,116,137,158,179,200
	dc.b	180,159,138,117,96,75,54,33,12
	dc.b	13,34,55,76,97,118,139,160
	dc.b	140,119,98,77,56,35,14
	dc.b	15,36,57,78,99,120
	dc.b	100,79,58,37,16
	dc.b	17,38,59,80
	dc.b	60,39,18
	dc.b	19,40
	dc.b	20
	dc.b	201
	dcb.b	20,0
	even
pt1	dc.l	0
vbl_flag	ds.w	1
pt_vbl	ds.w	1
pal	ds.l	8
pt_scroll	dc.l	9
pos_fnt	dc.l	0
pt_text	dc.l	0
table	dc.l	160*21*4+16*4,160*21*3+16*9
	dc.l	160*21*4+16*4,160*21*4+16*4,160*21*4+16*4,160*21*4+16*4,160*21*4+16*4
	dc.l	160*21*4+16*3,160*21*4+16*6,160*21*4+16*7
	dc.l	160*21*4+16*4,160*21*4+16*4
	dc.l	160*21*4+16*5,160*21*4+16*0,160*21*3+16*6
	dc.l	160*21*4+16*4
	dc.l	160*21*0+16*0,160*21*0+16*1,160*21*0+16*2,160*21*0+16*3,160*21*0+16*4,160*21*0+16*5,160*21*0+16*6,160*21*0+16*7,160*21*0+16*8,160*21*0+16*9
	dc.l	160*21*3+16*7	
	dc.l	160*21*4+16*4,160*21*4+16*4,160*21*4+16*4,160*21*4+16*4
	dc.l	160*21*3+16*7
	dc.l	160*21*4+16*4
	dc.l	160*21*1+16*0,160*21*1+16*1,160*21*1+16*2,160*21*1+16*3,160*21*1+16*4,160*21*1+16*5,160*21*1+16*6,160*21*1+16*7,160*21*1+16*8,160*21*1+16*9
	dc.l	160*21*2+16*0,160*21*2+16*1,160*21*2+16*2,160*21*2+16*3,160*21*2+16*4,160*21*2+16*5,160*21*2+16*6,160*21*2+16*7,160*21*2+16*8,160*21*2+16*9
	dc.l	160*21*3+16*0,160*21*3+16*1,160*21*3+16*2,160*21*3+16*3,160*21*3+16*4,160*21*3+16*5
	even
big_table	dc.l	scroll1,table1,nom2
	dc.l	scroll2,table2,nom3
	dc.l	scroll3,table3,nom4
	dc.l	scroll4,table4,nom5
	dc.l	scroll5,table5,nom6
	dc.l	scroll6,table6,nom7
	dc.l	scroll7,table7,nom8
	dc.l	scroll8,table8,nom9
	dc.l	scroll9,table1,nom10
	dc.l	scroll10,table2,nom11
	dc.l	scroll11,table3,nom12
	dc.l	scroll12,table4,nom13
	dc.l	scroll13,table5,nom14
	dc.l	scroll14,table6,nom15
	dc.l	scroll15,table7,nom16
	dc.l	scroll16,table8,nom17
	dc.l	scroll17,table1,nom18
	dc.l	scroll18,table2,nom19
	dc.l	scroll19,table3,nom1
	even
name_lnk	dc.b	"pictureslnk",0
	even
nom1	dc.b	"reps.pi1",0
	even
nom2	dc.b	"reps02.pi1",0
	even
nom3	dc.b	"cameodos.pi1",0
	even
nom4	dc.b	"celtik.pi1",0
	even
nom5	dc.b	"orion03.pi1",0
	even
nom6	dc.b	"david03.pi1",0
	even
nom7	dc.b	"orion.pi1",0
	even
nom8	dc.b	"orion02.pi1",0
	even	
nom9	dc.b	"celtik01.pi1",0
	even
nom10	dc.b	"celtik02.pi1",0
	even
nom11	dc.b	"david02.pi1",0
	even
nom12	dc.b	"david.pi1",0
	even	
nom13	dc.b	"celtik04.pi1",0
	even
nom14	dc.b	"paydisk.pi1",0
	even
nom15	dc.b	"orion06.pi1",0
	even
nom16	dc.b	"cameokk.pi1",0
	even	
nom17	dc.b	"orion04.pi1",0
	even
nom18	dc.b	"orion05p.pi1",0
	even
nom19	dc.b	"reps03.pi1",0
	even	
scroll1	dc.b	"  THE REPLICANTS PRESENT :   THE BOMBONNE DEMO AT ORION H.Q.                ",-1
	even
scroll2	dc.b	"  REPLICANTS MEMBERS HERE WERE :  ORION, CAMEO, CELTIK AND ELLFIRE ...                  ",-1
	even	 
scroll3	dc.b	"  AT THE BEGINNING OF THE PARTY CAMEO HAS ALREADY STARTED TO CRACK ...                    ",-1
	even	
scroll4	dc.b	"  CELTIK HAD SOME BAD INFLUENCE ON CAMEO'S WORK ...                   ",-1
	even
scroll5	dc.b	"  CAMEO NEEDED HELP AS CELTIK WAS MENACING HIM, SO ORION ARRIVED ...                        ",-1
	even	
scroll6	dc.b	"  ELLFIRE WAS ON THE PHONE ON A CONFERENCE ...                     ",-1
	even	
scroll7	dc.b	"  ORION WAS DOING SENSIBLE SOCCER FILE VERSION ...                     ",-1
	even
scroll8	dc.b	"  HERE IS A ZOOM OF WHAT HE THOUGHT ABOUT IT ...                       ",-1
	even	
scroll9	dc.b	"  CELTIK THREATS TO BROKE VROOM DATA DISK IF CAMEO DOESN'T HURRY UP ...                     ",-1
	even		
scroll10	dc.b	"  NOW THE DISK IS DAMAGED ...                 ",-1
	even
scroll11	dc.b	"  ELLFIRE CANNOT REALISE THAT THE ORIGINAL IS BROKEN ....                ",-1
	even
scroll12	dc.b	"  HE IS NOW AFRAID AS WE'LL HAVE TO GO AND GET IT AGAIN ....                        ",-1
	even
scroll13	dc.b	"  CELTIK IS SELLING ALL THE NEW STUFF IN THE STREET, CONTACT HIM ON   3615 RTEL   BAL CELTIK                  ",-1
	even
scroll14	dc.b	"  NOW WE ARE SELLING THE ORIGINAL OF D-GENERATION TO A BIG LAMER ....                    ",-1
	even
scroll15	dc.b	"  ORION IS REALLY HAPPY ABOUT ALL THE MONEY THE REPLICANTS GOT ...                 ",-1
	even		
scroll16	dc.b	"  AFTER A HARD DAY WORKING, CAMEO IS NOW HAVING SOME RELAXATION IN THE TOILETS ...  SPREADING A LOT OF SHIT ...                    ",-1
	even
scroll17	dc.b	"  ONE REPLICANTS CRACKER BECAME MAD AFTER TRYING TO CRACK VROOM DATA ON THE DESTROYED DISK BY CELTIK ....                   ",-1
	even
scroll18	dc.b	"  TOO LATE FOR HIM, BIG SMILE TO THE CAMERA, IT'S TIME FOR THE PSYCHIATRICAL HOSPITAL ....             ",-1
	even	
scroll19	dc.b	"  ORION, CAMEO, ELLFIRE AND CELTIK AS CAMERAMAN ARE WAVING YOU GOODBYE ....                        ",-1
	even		
scroll_fin	dc.b	"   CREDITS :  INTRO CODING, FOOD AND COOKING BY ORION, FONTS BY MACDOS, PICS BY CELTIK.        GREETINGS TO :   FUZION, CYNIX, ICS, ELITE, SUPERIOR, T S B, POMPEY PIRATES, PURE ENERGY, SPY3 OF MAD VISION PULSION " 
	dc.b	"AND OTHERS...         SOME LITTLE HI TO THYS ELROY, BLUEMAX, RAIL BOY, TRICKLE, KALISTE, HAVOK, FRANTZ, SHARP, STAR X, GOGO, LAURENZO, CRAZY BOY AND INFIRMIER ....       "
	DC.B	"   STUFF USED IN THIS PARTY :   5 KGS OF SPAGHETTI, 20 LITERS OF COOL DRINK, AND LOTSA CRISPS AND CAKES...    CONTACT US, SEND FOOD AND MONEY AT :       - THE REPLICANTS -     BP 66      59420 MOUVAUX    FRANCE         "
	DC.B	"    SEE YA SOON ........                                    ",-1
	even
fonts	incbin	\orion.src\reps.dem\bombonne\mac1p.pi1
	even
circle	incbin	\orion.src\reps.dem\bombonne\balls
	even
names	incbin	\orion.src\reps.dem\bombonne\names
	even
data	incbin	\orion.src\reps.dem\bombonne\cool.mod
	even
	ds.l	10000
workspc	ds.w	1
	even
buf_sec	ds.b	512
	even
buf_scr	
	end	