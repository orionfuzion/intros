	lea	fnt+34,a0
	lea	buf,a1
	moveq	#3,d0
cop_40let	moveq	#9,d1
cop_10let	move.w	#31,d2
cop_1let	movem.l	(a0),d4-d7
	movem.l	d4-d7,(a1)
	lea	160(a0),a0
	lea	16(a1),a1
	dbf	d2,cop_1let
	lea	-$13f0(a0),a0
	dbf	d1,cop_10let
	lea	$1360(a0),a0
	dbf	d0,cop_40let
	moveq	#5,d1
cop_10letb	move.w	#31,d2
cop_1letb	movem.l	(a0),d4-d7
	movem.l	d4-d7,(a1)
	lea	160(a0),a0
	lea	16(a1),a1
	dbf	d2,cop_1letb
	lea	-$13f0(a0),a0
	dbf	d1,cop_10letb
	
	clr.w	-(sp)
	pea	nom
	move.w	#$3c,-(sp)
	trap	#1
	lea	8(sp),sp
	move.w	d0,d7
	
	pea	buf
	move.l	#512*46,-(sp)
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
	
nom	dc.b	"fonts.dat",0
	even
fnt	incbin	fonts.pi1
	even
buf	 
	end	