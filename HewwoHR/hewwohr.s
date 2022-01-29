.include "libSFX.i"

;VRAM destination addresses
VRAM_MAP_LOC     = $0000
VRAM_TILES_LOC   = $8000

Main:
	SMP_playspc SPC_State, SPC_Image_Lo, SPC_Image_Hi
	
    VRAM_memcpy VRAM_MAP_LOC, Map, sizeof_Map
    VRAM_memcpy VRAM_TILES_LOC, Tiles, sizeof_Tiles
    CGRAM_memcpy 0, Palette, sizeof_Palette
	
	lda #bgmode(BG_MODE_5, BG3_PRIO_NORMAL, BG_SIZE_16X16, BG_SIZE_8X8, BG_SIZE_8X8, BG_SIZE_8X8)
	sta BGMODE
	lda #bgsc(VRAM_MAP_LOC, SC_SIZE_32X32)
	sta BG1SC
	ldx #bgnba(VRAM_TILES_LOC, 0, 0, 0)
	stx BG12NBA
	lda #tm(ON, OFF, OFF, OFF, OFF)
	sta TM
	lda #tm(ON, OFF, OFF, OFF, OFF)
	sta TS
	
	lda #inidisp(ON, DISP_BRIGHTNESS_MAX)
	sta SFX_inidisp
	LDA #%00000001
	STA HDMAEN
	VBL_set vbh
	VBL_on
	
:	wai
	bra :-

vbh:
;RW a8

;HDMA_set_absolute 0, 2, BG1VOFS, hdmavofs

;lda     #%00000001
;sta     HDMAEN

rtl

hdmavofs:
.repeat 112, i
        .byte 2
        .word ($0000 - i) & $ffff
.endrep

;--
;RODATA ROMDATA
.segment "RODATA"
incbin  Palette,        "Data/hewwohr.png.palette"
incbin  Tiles,          "Data/hewwohr.png.tiles"
incbin  Map,            "Data/hewwohr.png.map"

.define spc_file "Data/3HCStairsDisplay.spc"
.segment "RODATA"
SPC_State:    SPC_incbin_state spc_file
.segment "ROM2"
SPC_Image_Lo: SPC_incbin_lo spc_file
.segment "ROM3"
SPC_Image_Hi: SPC_incbin_hi spc_file