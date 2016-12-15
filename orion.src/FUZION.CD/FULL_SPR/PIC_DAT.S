	lea	pic1,a0
	lea	pic2+34,a1
	lea	buf,a2
	movem.l	2(a0),d0-d7
	movem.l	d0-d7,(a2)
	lea	34(a0),a0
	lea	32(a2),a2
	move.w	#199,d1
cop_all	moveq	#39,d0
cop_1	move.l	(a0)+,(a2)+
	dbf	d0,cop_1
	moveq	#15,d0
cop_2	move.l	(a1)+,(a2)+
	dbf	d0,cop_2
	clr.l	(a2)+
	clr.w	(a2)+
	lea	96(a1),a1
	dbf	d1,cop_all
	
	clr.w	-(sp)
	pea	nom
	move.w	#$3c,-(sp)
	trap	#1
	lea	8(sp),sp
	move.w	d0,d7
	
	pea	buf
	move.l	#230*200+32,-(sp)
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
	
nom	dc.b	"pic.dat",0	
	even
pic1	incbin	pic1.pi1
pic2	incbin	pic2.pi1
	even
buf
	end