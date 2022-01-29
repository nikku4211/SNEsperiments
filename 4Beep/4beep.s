.include "libSFX.i"

;VRAM destination addresses
VRAM_MAP_LOC     = $0000
VRAM_TILES_LOC   = $8000

Main:
	
	CGRAM_memcpy 0, palette1, sizeof_palette1
    CGRAM_memcpy 64, palette2, sizeof_palette2
	VRAM_memcpy VRAM_MAP_LOC, map1, sizeof_map1
	VRAM_memcpy VRAM_MAP_LOC+2048, map2, sizeof_map2
	VRAM_memcpy VRAM_MAP_LOC+4096, map3, sizeof_map3
	VRAM_memcpy VRAM_MAP_LOC+6144, map4, sizeof_map4
	VRAM_memcpy VRAM_TILES_LOC, tiles1, sizeof_tiles1
	
	lda #bgmode(BG_MODE_1, BG3_PRIO_NORMAL, BG_SIZE_8X8, BG_SIZE_8X8, BG_SIZE_8X8, BG_SIZE_8X8)
	sta BGMODE
	lda #bgsc(VRAM_MAP_LOC, SC_SIZE_64X64)
	sta BG1SC
	ldx #bgnba(VRAM_TILES_LOC, 0, 0, 0)
	stx BG12NBA
	lda #tm(ON, OFF, OFF, OFF, OFF)
	sta TM
	
	VBL_set dima
	lda #inidisp(ON, DISP_BRIGHTNESS_MAX)
	sta SFX_inidisp
	VBL_on
	
:	wai
	bra :-
	
dima:
	;lda #%10000000
	;sta $2101
	;lda #%00000010 ;Dear B Bus, 2 bytes to 1 address, increment, From, CPU
	;sta $4300
	;lda #$18 ;VRAM Data Write
	;sta $4301
	;lda #.bankbyte(shadow_4tiles)
	;sta $4304
	;ldx #shadow_4tiles
	;stx $4302
	;ldx #30720 ;bytes
	;stx $4305
	;lda #%00000001 ;channel 0
	;sta $420B
	
	RW a8i8
		
	readright:
		lda SFX_joy1cont + 1
		and #.hibyte(JOY_RIGHT)
		beq readleft
	
	cammoveright:
			
			RW a16i8
			
			lda camxpos
			clc
			adc #$01
			sta camxpos
			
			RW a8i8
			
			lda camxpos
			sta $210D
			lda camxpos+1
			stz $210D
	readleft:
		lda SFX_joy1cont + 1
		and #.hibyte(JOY_LEFT)
		beq readup

	cammoveleft:
			
			RW a16i8
			
			lda camxpos
			sec
			sbc #$01
			sta camxpos
			
			RW a8i8
			
			lda camxpos
			sta $210D
			lda camxpos+1
			stz $210D
	readup:	
	lda SFX_joy1cont + 1
	and #.hibyte(JOY_UP)
	beq readdown
	
	cammoveup:
		
		RW a16i8
	
		lda camypos
		sec
		sbc #$01
		sta camypos
		
		RW a8i8
		
		lda camypos
		sta $210e
		lda camypos+1
		stz $210e

	readdown:
	lda SFX_joy1cont + 1
	and #.hibyte(JOY_DOWN)
	beq :+
	
	cammovedown:
	
		RW a16i8
	
		lda camypos
		clc
		adc #$01
		sta camypos
		
		RW a8i8
		
		lda camypos
		sta $210e
		lda camypos+1
		stz $210e

	:

	RW a8i16
	rtl
	
;--
;RODATA ROMDATA
.RODATA
incbin  map1, "data/mita_tl.pmap"
incbin  map2, "data/mita_tr.pmap"
incbin  map3, "data/mita_bl.pmap"
incbin  map4, "data/mita_br.pmap"
incbin  tiles1, "data/mita_tl.img"
incbin  tiles2, "data/mita_tr.img"
incbin  tiles3, "data/mita_bl.img"
incbin  tiles4, "data/mita_br.img"
incbin  palette1, "data/mita1.pal"
incbin  palette2, "data/mita2.pal"

.segment "LORAM"

	camxpos: .res 2
	camypos: .res 2

.segment "HIRAM"
