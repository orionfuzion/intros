	lea	title+34,a0
	lea	buf,a1
	move.l	#119,d1
cop_120l	moveq	#11,d0
cop_1l	move.w	(a0),(a1)+
	addq.l	#8,a0
	dbf	d0,cop_1l
	lea	64(a0),a0
	dbf	d1,cop_120l
	
	clr.w	-(sp)
	pea	nom
	move.w	#$3c,-(sp)
	trap	#1
	lea	8(sp),sp
	move.w	d0,d7
	
	pea	buf
	move.l	#24*120,-(sp)
	move.w	d7,-(sp)
	move	#$40,-(sp)
	trap	#1
	lea	12(sp),sp
	
	move.w	d7,-(sp)
	move	#$3e,-(sp)
	trap	#1
	addq	#4,sp	
	
	clr.l	-(sp)
	trap	#1
	
title	incbin	title.pi1
buf	ds.b	24*120
nom	dc.b	"title.dat",0	