	lea	pic+34,a0
	lea	pic+34+160*21,a1
	lea	buf,a2
	
	move.w	#20*20-1,d0
cop	move.w	(a0),(a2)+
	move.w	(a1),(a2)+
	lea	8(a0),a0
	lea	8(a1),a1
	dbf	d0,cop
	
	clr.w	-(sp)
	pea	nom
	move.w	#$3c,-(sp)
	trap	#1
	lea	8(sp),sp
	move.w	d0,d7
	
	pea	buf
	move.l	#20*20*4,-(sp)
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
	
pic	incbin	gene.pi1
buf	ds.b	20*20*4
	even
nom	dc.b	"pres.dat",0	
	end