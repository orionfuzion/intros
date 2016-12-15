
	clr.l	-(sp)
	move	#$20,-(sp)
	trap	#1
	addq	#6,sp
	
	dc.w	$a00a
	move.b	#7,$484.w
	clr	-(sp)
	pea	-1.w
	move.l	(sp),-(sp)
	move	#5,-(sp)
	trap	#14
	lea	12(sp),sp
	clr	$ffff825e.w
	
	lea	title(pc),a0
	bsr	aff
	bsr	tche
	
	move.w	#3,-(sp)
	move.w	#$e,-(sp)
	trap	#1
	addq	#4,sp
	
	pea	dta(pc)
	move.w	#$1a,-(sp)
	trap	#1
	addq	#6,sp
	
	pea	dir(pc)
	move	#$3b,-(a7)
	trap	#1
	addq.l	#6,a7
	
	clr.w	-(sp)
	pea	nom(pc)
	move.w	#$4e,-(sp)
	trap	#1
	addq	#8,sp
	tst	d0
	bne	fin
	
	lea	buffer(pc),a5
	lea	buf_tab(pc),a4
	moveq	#0,d5
	
loop	lea	txt(pc),a0
	bsr	aff
	lea	dta+30(pc),a6
	move.l	a6,a0
	bsr	aff
	lea	nbr(pc),a0
	add.b	#1,14(a0)
	cmp.b	#$3a,14(a0)
	bne.s	ct
	move.b	#$30,14(a0)
	add.b	#1,13(a0)
ct	bsr	aff

	move.w	#$2,-(sp)
	pea	(a6)
	move.w	#$3d,-(sp)
	trap	#1
	addq	#8,sp
	move.l	d0,d7
	
	pea	(a5)
	pea	$fffff
	move.w	d7,-(sp)
	move.w	#$3f,-(sp)
	trap	#1
	lea	12(sp),sp
	move.l	d0,d6
	
	move.w	d7,-(sp)
	move	#$3e,-(sp)
	trap	#1
	addq	#4,sp
	
	move.l	a6,a0
	move.l	a4,a1
	
cop_n	move.b	(a0)+,(a1)+
	bne.s	cop_n
	
	lea	20(a4),a4
	move.l	d5,(a4)
	move.l	d6,4(a4)
	lea	12(a4),a4
	
	addq.l	#1,d6
	and.l	#-2,d6
	add.l	d6,a5
	add.l	d6,d5
	
	move.w	#$4f,-(sp)
	trap	#1
	addq	#2,sp
	tst	d0
	beq	loop
	
	bsr	tche
	
	move.w	#0,-(sp)
	move.w	#$e,-(sp)
	trap	#1
	addq	#4,sp
	
	
	clr.w	-(sp)
	pea	nam_fil(pc)
	move.w	#$3c,-(sp)
	trap	#1
	lea	8(sp),sp
	move.w	d0,d7
	
	pea	buffer(pc)
	move.l	d5,-(a7)
	move.w	d7,-(sp)
	move	#$40,-(sp)
	trap	#1
	lea	12(sp),sp
	
	move.w	d7,-(sp)
	move	#$3e,-(sp)
	trap	#1
	addq	#4,sp	
	
	bsr	tche
	
	clr.w	-(sp)
	pea	nam_tab(pc)
	move.w	#$3c,-(sp)
	trap	#1
	lea	8(sp),sp
	move.w	d0,d7
	
	sub.l	#buf_tab,a4
	pea	buf_tab(pc)
	pea	(a4)
	move.w	d7,-(sp)
	move	#$40,-(sp)
	trap	#1
	lea	12(sp),sp
	
	move.w	d7,-(sp)
	move	#$3e,-(sp)
	trap	#1
	addq	#4,sp	
	
	bsr	tche
	
fin	clr.l	-(sp)
	trap	#1	
	
aff	pea	(a0)
	move	#9,-(sp)
	trap	#1
	addq	#6,sp
	rts	

tche	eor.w	#$070,$ffff8240.w
	move	#7,-(sp)
	trap	#1
	addq.l	#2,sp
	eor.w	#$070,$ffff8240.w
	rts

dir	dc.b	"d:\megafun3.bis\",0	
	even
nom	dc.b	"*.*",0
	even
title	dc.b	27,"E",27,"Y",32,32
	dc.b	"            - FILE LINKER -",0
	even
txt	dc.b	27,"Y",36,32,"WORKING ON FILE :                ",27,"Y",36,50,0
	even
nbr	dc.b	27,"Y",38,32,"NUMBER : 00",0
	even
dta	ds.b	44
	even
nam_fil	dc.b	"a:\pictures.lnk",0
	even
nam_tab	dc.b	"a:\names",0
	even
buf_tab	ds.b	2000
buffer
	end	
