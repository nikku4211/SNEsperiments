.include "libSFX.i"

;VRAM destination addresses
VRAM_SQMAP_LOC     = $b000
VRAM_SQTILES_LOC   = $0000
VRAM_SFMAP_LOC     = $c000
VRAM_SFTILES_LOC   = $a000

Main:
        ;libSFX calls Main after CPU/PPU registers, memory and interrupt handlers are initialized.
        
        VRAM_memcpy VRAM_SQMAP_LOC, squiMap, sizeof_squiMap
        VRAM_memcpy VRAM_SQTILES_LOC, squiTiles, sizeof_squiTiles
        CGRAM_memcpy 16, squiPalette, sizeof_squiPalette
        VRAM_memcpy VRAM_SFMAP_LOC, sfbgMap, sizeof_sfbgMap
        VRAM_memcpy VRAM_SFTILES_LOC, sfbgTiles, sizeof_sfbgTiles
        CGRAM_memcpy 0, sfbgPalette, sizeof_sfbgPalette

        lda     #bgmode(BG_MODE_4, BG3_PRIO_NORMAL, BG_SIZE_8X8, BG_SIZE_8X8, BG_SIZE_8X8, BG_SIZE_8X8)
        sta     BGMODE
        lda     #bgsc(VRAM_SQMAP_LOC, SC_SIZE_32X32)
        sta     BG1SC
        lda     #bgsc(VRAM_SFMAP_LOC, SC_SIZE_32X32)
        sta     BG2SC
        lda #bgsc($f000, SC_SIZE_32X32)
        sta BG3SC
        ldx     #bgnba(VRAM_SQTILES_LOC, VRAM_SFTILES_LOC, 0, 0)
        stx     BG12NBA
        lda     #tm(ON, ON, OFF, OFF, OFF)
        sta     TM

        ;Turn on screen
        ;The vblank interrupt handler will copy the value in SFX_inidisp to INIDISP ($2100)
        lda     #inidisp(ON, DISP_BRIGHTNESS_MAX)
        sta     SFX_inidisp

        ;Turn on vblank interrupt
        VBL_on

:       wai
        bra :-

.segment "ROM1"
incbin  squiPalette,        "Data/squirrelphototileset.png.palette"
incbin  squiTiles,          "Data/squirrelphototileset.png.tiles"
incbin  squiMap,            "Data/squirrelphototileset.png.map"

incbin  sfbgPalette,        "Data/sfbgf.png.palette"
incbin  sfbgTiles,          "Data/sfbgf.png.tiles"
incbin  sfbgMap,            "Data/sfbgf.png.map"
