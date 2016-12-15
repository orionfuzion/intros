	lea	fnt+34,a0
	lea	buf_fnt,a1
	moveq	#2,d0
c3	moveq	#19,d1
c2	moveq	#15,d2
c1	move.w	(a0),(a1)+
	lea	160(a0),a0
	dbf	d2,c1
	lea	-16*160+8(a0),a0
	dbf	d1,c2
	lea	16*160(a0),a0
	dbf	d0,c3
	moveq	#4,d1
c5	moveq	#15,d2
c4	move.w	(a0),(a1)+
	lea	160(a0),a0
	dbf	d2,c4
	lea	-16*160+8(a0),a0
	dbf	d1,c5
	
	clr.w	-(sp)
	pea	nom
	move.w	#$3c,-(sp)
	trap	#1
	lea	8(sp),sp
	move.w	d0,d7
	
	pea	buf_fnt
	pea	65*32
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
	
nom	dc.b	"16x16_3.fnt",0
	even
fnt	incbin	"fnt_16.pi1"
buf_fnt	ds.b	32*65
	end
	