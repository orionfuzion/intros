	lea	spr+34,a0
	lea	buf_log,a1
	moveq	#39,d0
cop	movem.l	(a0)+,d1-d7/a2-a4
	movem.l	d1-d7/a2-a4,(a1)
	movem.l	(a0)+,d1-d7/a2-a4
	movem.l	d1-d7/a2-a4,40(a1)
	lea	80(a0),a0
	lea	80(a1),a1
	dbf	d0,cop
	
	clr.w	-(sp)
	pea	nom
	move.w	#$3c,-(sp)
	trap	#1
	lea	8(sp),sp
	move.w	d0,d7
	
	pea	buf_log
	move.l	#80*40,-(sp)
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
	
spr	incbin	logo.pi1
buf_log	ds.b	40*80
nom	dc.b	"logo.dat",0