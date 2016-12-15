	lea	fnt+34,a0
	lea	buf,a1
		
	moveq	#19,d1	
cop2	moveq	#15,d0
cop1	move.w	(a0),(a1)+
	lea	160(a0),a0
	dbf	d0,cop1
	lea	-160*16+8(a0),a0
	dbf	d1,cop2
	
	lea	fnt+34+160*16,a0
		
	moveq	#5,d1	
cop4	moveq	#15,d0
cop3	move.w	(a0),(a1)+
	lea	160(a0),a0
	dbf	d0,cop3
	lea	-160*16+8(a0),a0
	dbf	d1,cop4
	
	clr.w	-(sp)
	pea	nom
	move.w	#$3c,-(sp)
	trap	#1
	lea	8(sp),sp
	move.w	d0,d7
	
	pea	buf
	move.l	#32*26,-(sp)
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
	
nom	dc.b	"ltl_fnt.dat",0
	even
fnt	incbin	ltl_fnt.pi1
	even
buf	 
	end	