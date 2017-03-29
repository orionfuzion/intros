	lea	blocks+34,a0
	lea	buf,a1
	moveq	#2,d0
cop2	move.w	#47,d1
cop1	movem.l	(a0),d3-d7/a2-a4
	movem.l	d3-d7/a2-a4,(a1)
	lea	160(a0),a0
	lea	32(a1),a1
	dbf	d1,cop1
	lea	-160*48+32(a0),a0
	dbf	d0,cop2
	
	clr.w	-(sp)
	pea	nom
	move.w	#$3c,-(sp)
	trap	#1
	lea	8(sp),sp
	move.w	d0,d7
	
	pea	buf
	move.l	#32*48*3,-(sp)
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
	
nom	dc.b	"blocks.dat",0
	even
blocks	incbin	\gaulle3.pi1
	even
buf	 
	end	
