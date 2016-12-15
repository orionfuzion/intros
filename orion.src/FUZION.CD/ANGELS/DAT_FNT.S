	lea	fnt,a0
	lea	buf_fnt+34,a1
	moveq	#3,d0
c3	moveq	#19,d1
c2	moveq	#15,d2
c1	move.w	(a0)+,(a1)
	lea	160(a1),a1
	dbf	d2,c1
	lea	-16*160+8(a1),a1
	dbf	d1,c2
	lea	16*160(a1),a1
	dbf	d0,c3
	
	clr.w	-(sp)
	pea	nom
	move.w	#$3c,-(sp)
	trap	#1
	lea	8(sp),sp
	move.w	d0,d7
	
	pea	buf_fnt
	pea	32034
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
	
nom	dc.b	"fnt_16_1.pi1",0
	even
fnt	incbin	16x16.fnt
buf_fnt	dc.w	0,0,$777
	dcb.w	13,0
	dc.w	$777
	ds.b	32000
	end
	