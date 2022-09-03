.include "libSFX.i"
.MACPACK longbranch

;VRAM destination addresses
	VRAM_MAP_LOC     = $9000
	VRAM_TILES_LOC   = $2000
	VRAM_FONTILE_LOC = $0200
	VRAM_FONTMAP_LOC = $1000

Main:
	VRAM_memcpy VRAM_MAP_LOC, bg, sizeof_bg
	VRAM_memcpy VRAM_TILES_LOC, tile, sizeof_tile
	VRAM_memcpy VRAM_FONTILE_LOC, fontile, sizeof_fontile
	CGRAM_memcpy 0, pal, sizeof_pal
  	
	lda #bgmode(BG_MODE_4, BG3_PRIO_NORMAL, BG_SIZE_8X8, BG_SIZE_8X8, BG_SIZE_8X8, BG_SIZE_8X8)
	sta BGMODE
	lda #bgsc(VRAM_MAP_LOC, SC_SIZE_32X32)
	sta BG1SC
	lda #bgsc(VRAM_FONTMAP_LOC, SC_SIZE_32X32)
	sta BG2SC
	lda #bgsc($f000, SC_SIZE_32X32)
	sta BG3SC
	ldx #bgnba(VRAM_TILES_LOC, 0, 0, 0)
	stx BG12NBA
	lda #tm(ON, ON, OFF, OFF, OFF)
	sta TM
	
	RW_forced a16i16
	
	stz $210D
	stz $210D
	stz $210E
	stz $210E
	stz $210F
	stz $210F
	stz $2110
	stz $2110
	stz $2112
	stz $2112
	stz toffset
	stz toffsetn
	
	ldx #512 + 32 - 4
	zero_oam:
		stz shadow_oam + 3, x
		dex
	bne zero_oam 
	
	ldx #1559
	ldy #0
	lda #0
	
	zerotext:
		stz textbox, x ;clear text area in WRAM
		dex
		cpx #0
	bne zerotext
	
	ldx toffsetn ;index at a certain part of the text source
	stx toffset
	ldy #0
		
	filltext:
		RW_forced a8i16
		clc
		lda textboxtable,x
		beq imdone ;terminate at a null character
		cmp #$0D
		beq ignord ;ignore carriage return
		cmp #$0A
		beq breakline ;go to next line at a line feed
		inx	
		clc
		sta textbox,y
		iny
	
	filltextp:
    RW_forced a8i16
		lda #%00100000 ;give the text a priority attribute
		sta textbox,y
		iny
	bra endphobe
	
	breakline:
		RW_forced a16i16
		lda #0
		tya
		clc
		adc #$44 ;go to next line
		and #$FFC0
		tay
		sta textline
		inx
	bra filltext
	
	ignord:
		inx ;ignoring carriage return
		iny
	bra filltextp
		
	endphobe:
		RW_forced a16i16
		tya
		and #$3f
		cmp #$40
		;lda #0
		bne filltext
		iny
		iny
		iny
	bra filltextp
	
	imdone:
		RW_forced a8i16
	
	lda #inidisp(ON, DISP_BRIGHTNESS_MAX)
	sta SFX_inidisp
	VBL_set VBlankHand
	VBL_on
	
:	
	RW_forced a16i16
	lda toffsetn
	cmp toffset
	ldx #1559
	ldy #0
	jne zerotext
	wai
	bra :-
	
	VBlankHand:
		RW_forced a8i16
		HDMA_set_absolute 0, 2, BG1VOFS, hdmavofs
		lda #%00000001
		sta HDMAEN
		
		;stz $2115
		;lda #$00
		;stz $2116
		;sta $2117
		;lda #%00000001 ;Dear B Bus, 2 bytes to 2 addresses, increment, From, CPU
		;sta $4310
		;lda #$18 ;PPU Data Write
		;sta $4311
		;lda #.bankbyte(textbox)
		;sta $4314
		;ldx #textbox
		;stx $4312
		;ldx #1134 ;bytes
		;stx $4315
		;lda #%00000010 ;channel 1
		;sta $420B
		
		VRAM_memcpy VRAM_FONTMAP_LOC, textbox, 1560
		
		lda #248
		sta $210f
		lda #0
		sta $210f
		lda #240
		sta $2110
		stz $2110 ;offset textbox
		
		RW_forced a16i16
		
		lda SFX_joy1cont
		and JOY_B
		beq :+
		
		nex:
			lda #$242
			sta toffsetn
		
		:
		
	rtl

	hdmavofs:
		.repeat 112, i
			.byte 2
			.word ($0000 - i) & $ffff
		.endrep


;--
.RODATA
	incbin  bg,            "data/NSEVNTestBG.png.map"
	incbin  textboxtable, "data/text/TheTruth.txt"
	
.segment "ROM2"
	incbin  pal,        "data/NSEVNTestBG.png.palette"
	
.segment "ROM3"
	incbin  tile,          "data/NSEVNTestBG.png.tiles"
	incbin  fontile, "data/font.png.tiles"
	
.segment "LORAM"
	shadow_oam: .res 512+32
	textbox: .res 1560
	textline: .res 2
	toffsetn: .res 2
	toffset: .res 2