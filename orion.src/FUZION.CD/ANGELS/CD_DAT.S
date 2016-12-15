	lea	cd+34+160*40,a0
	lea	buf_cd,a1
	move.w	#43,d0
cop2	lea	24(a0),a0
	move.w	#13,d1
cop	move.w	(a0),(a1)+
	lea	8(a0),a0
	dbf	d1,cop
	lea	24(a0),a0
	dbf	d0,cop2
	
	clr.w	-(sp)
	pea	nom
	move.w	#$3c,-(sp)
	trap	#1
	lea	8(sp),sp
	move.w	d0,d7
	
	pea	buf_cd
	move.l	#44*14*2,-(sp)
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
	
cd	incbin	cd_num.pi1
buf_cd	ds.b	44*14*2
nom	dc.b	"cd.dat",0