.include "libSFX.i"

;VRAM destination addresses
VRAM_MAP_LOC     = $0000
VRAM_TILES_LOC   = $2000
TEXT_MAP_LOC = $6000
TEXT_TILES_LOC = $8000

Main:
	SMP_exec SMP_RAM, SMP_play, sizeof_SMP_play, SMP_RAM
	
    VRAM_memcpy VRAM_MAP_LOC, Map, sizeof_Map
    VRAM_memcpy VRAM_TILES_LOC, Tiles, sizeof_Tiles
    CGRAM_memcpy 0, Palette, sizeof_Palette
	VRAM_memcpy TEXT_MAP_LOC, tMap, sizeof_Map
    VRAM_memcpy TEXT_TILES_LOC, tTiles, sizeof_Tiles
	CGRAM_setcolor 0, 0
	
	lda #bgmode(BG_MODE_1, BG3_PRIO_HIGH, BG_SIZE_8X8, BG_SIZE_8X8, BG_SIZE_8X8, BG_SIZE_8X8)
	sta BGMODE
	lda #bgsc(VRAM_MAP_LOC, SC_SIZE_32X32)
	sta BG1SC
	lda #bgsc(TEXT_MAP_LOC, SC_SIZE_32X32)
	sta BG3SC
	ldx #bg12nba(VRAM_TILES_LOC, 0)
	stx BG12NBA
	ldx #bg34nba(TEXT_TILES_LOC, 0)
	stx BG34NBA
	lda #tm(ON, OFF, ON, OFF, OFF)
	sta TM
	
	lda #inidisp(ON, DISP_BRIGHTNESS_MAX)
	sta SFX_inidisp
	VBL_on
	
:	wai
	bra :-
	
;--
.RODATA
incbin  Palette,        "Data/gokudrip.png.palette"
incbin  Tiles,          "Data/gokudrip.png.tiles"
incbin  Map,            "Data/gokudrip.png.map"
incbin  tPalette,        "Data/memetext.png.palette"
incbin  tTiles,          "Data/memetext.png.tiles"
incbin  tMap,            "Data/memetext.png.map"

.segment "ROM2"
incbin  SMP_play,  "SMP-Play.bin"
