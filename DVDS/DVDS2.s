.include "libsfx.i"

VRAM_SPRITES_LOC = $0000

Main:
  VRAM_memcpy VRAM_SPRITES_LOC, spr, sizeof_spr
  CGRAM_memcpy 128, sprpal, sizeof_sprpal
  CGRAM_setcolor_rgb 0, 0, 0, 0
  LDA #tm(OFF, OFF, OFF, OFF, ON)
  STA TM
  RW a8i16
  lda #1
  sta xvel
  sta yvel
  stz xpos
  stz ypos
  stz invx
  
  ldx #512 + 32 - 4
  zero_oam:
   stz shadow_oam + 3, x
   dex
   bne zero_oam

    ; Init 1st sprite and 2nd sprite's "extra bits"
   lda #%00110000 ; Top priority
   sta shadow_oam+3
   stz shadow_oam+2
   stz shadow_oam+1
   stz shadow_oam+0
   lda #%00000010
   sta shadow_oam+512
  
   ldx #5 ; All by myself
   lda #$e0
  sweepspritedown:
   sta shadow_oam, x
   inx
   inx
   inx
   inx
   cpx #513
   bne sweepspritedown
   
  
  DMAOAM:
  lda #$80 ;force blank
  sta $2100
  
  lda #$0f ;turn on
  sta $2100
  
  lda #$00
  sta $2122
  lda #$00
  sta $2122
  
  VBL_set VBlankHand
  lda #inidisp(ON, DISP_BRIGHTNESS_MAX)
  sta SFX_inidisp
  VBL_on
  
: wai

  bra :-
  
VBlankHand:
  lda #%10100000
  sta $2101
  lda #%00000010 ;Dear B Bus, 2 bytes to 1 address, increment, From, CPU
  sta $4300
  lda #$04 ;OAM Data Write
  sta $4301
  lda #.bankbyte(shadow_oam)
  sta $4304
  ldx #shadow_oam
  stx $4302
  ldx #544 ;bytes
  stx $4305
  lda #%00000001 ;channel 0
  sta $420B
  
  RW a8i8
  
  lda xpos
  cmp #$01
  bcs :+
    lda #$01
    sta xvel
  :

  lda xpos
  cmp #$bf
  bcc :+
    lda #$ff
    sta xvel
  :

  lda xpos
  clc
  adc xvel
  sta xpos
  sta shadow_oam


  ; -----------------------------------

  lda ypos
  cmp #$01
  bcs :+
    lda #$01
    sta yvel
  :

  lda ypos
  cmp #$9f
  bcc :+
    lda #$ff
    sta yvel
  :

  lda ypos
  clc
  adc yvel
  sta ypos
  sta shadow_oam+1
  
  rtl

.RODATA
  incbin spr, "data/dvds.png.tiles"
  incbin sprpal, "data/dvds.png.palette"

.segment "LORAM"
xvel: .res 1
yvel: .res 1
xpos: .res 1
ypos: .res 1
invx: .res 1
invy: .res 1
cont: .res 1

shadow_oam: .res 512+32