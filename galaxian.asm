;;; ATARI GALAXIAN for VIC-20

VIC               := $9000      ; $9000-$900F
VIA1              := $9110      ; $9110-$911F
VIA2              := $9120      ; $9120-$912F
COLORRAM          := $9400      ; $9600-$96C7
CHARSET           := $1000      ; $1000-$1F1F (22 cols*11 rows*16 bytes/char)
SCREEN            := $0200      ; $1200-$02C7
        
JOY_REG_RIGHT     := VIA2+$0
JOY_REG_OTHER     := VIA1+$1
JOY_MASK_UP       := $04
JOY_MASK_DOWN     := $08
JOY_MASK_LEFT     := $10
JOY_MASK_RIGHT    := $80
JOY_MASK_BUTTON   := $20

           .org $A000

           .word  ENTRY, ENTRY
           .byte  $41,$30,$C3,$C2,$CD ; "A0CBM"
           .byte  $02,$BB,$5A,$30,$5F,$EE,$3D,$A8

ENTRY:     jsr    $FD52         ; set I/O vectors
           jsr    $FDF9         ; initialize I/O registers
           jsr    $E518         ; init hardware
           sei
           cld
           jsr    LAE68
           dex
           txs
           lda    #$8C          ; CHARSET at $1000, SCREEN at $0200, COLORRAM at $9600
           sta    VIC+$5
           lda    #$96          ; 22 columns
           sta    VIC+$2
           lda    #$7F          ; disable VIA1 (NMI) interrupts
           sta    VIA1+$E
           lda    #$17          ; 11 rows of 16x8 characters
           sta    VIC+$3
           inx
           txa
LA037:     sta    $00,x
           dex
           bne    LA037
           lda    #$00
           sta    $0105
           sta    $0104
LA044:     ldy    #$ED
           lda    #$00
LA048:     sta    $00,y
           dey
           bne    LA048
           lda    #$00
           sta    $00
           tay
LA053:     ldx    #$16
LA055:     sta    SCREEN,y
           iny
           clc
           adc    #$0B
           dex
           bne    LA055
           inc    $00
           lda    $00
           cmp    #$0B
           bne    LA053
           lda    #$FF
           ldx    #$16
LA06B:     sta    SCREEN,y
           sta    SCREEN+8,y
           iny
           beq    LA077
           dex
           bpl    LA06B
LA077:     lda    #>(COLORRAM+$0200)
           ldy    #<(COLORRAM+$0200)
           sty    $FB
LA07D:     sta    $FC
           sta    $03DA,y
           lda    $FB
           sta    $03BC,y
           clc
           adc    #$16
           sta    $FB
           lda    $FC
           adc    #$00
           iny
           cpy    #$1A
           bne    LA07D
           lda    #<CHARSET
           sta    $F7
           lda    #>CHARSET
           ldy    #$00
LA09D:     sta    $F8
           sta    $039E,y
           lda    $F7
           sta    $0380,y
           clc
           adc    #$B0
           sta    $F7
           lda    $F8
           adc    #$00
           iny
           cpy    #$18
           bne    LA09D
           lda    #$80
           sta    $F7
           lda    #$9E
           sta    $F9
           lda    #$03
           sta    $F8
           sta    $FA
           lda    #$BC
           sta    $FB
           lda    #$DA
           sta    $FD
           lda    #$03
           sta    $FC
           sta    $FE
           lda    #$0E
           sta    VIC+$F
           lda    #$2F
           sta    VIC+$E
           lda    #$01
           sta    $0102
           jsr    LA79D
LA0E3:     ldy    #$07
           lda    #$00
LA0E7:     sta    $EC,y
           dey
           bpl    LA0E7
           ldx    #$1D
LA0EF:     lda    LB02C,x
           sta    $1FE1,x
           dex
           bpl    LA0EF
LA0F8:     ldx    #$1D
LA0FA:     lda    LB00E,x
           sta    $AB,x
           lda    LB02C,x
           sta    $C9,x
           dex
           bpl    LA0FA
           lda    #$0F
           ldx    #$00
           ldy    #$16
           jsr    LAE4F
           ldx    #$00
           ldy    #$00
           lda    #$07
           jsr    LAE4F
           ldx    #$0A
           ldy    #$0A
           jsr    LAE4F
LA120:     ldy    #$C8
           lda    #$00
LA124:     sta    $00,y
           dey
           bne    LA124
           ldx    #$1D
LA12C:     lda    $C9,x
           beq    LA13A
           lda    LB00E,x
           sta    $AB,x
           lda    LB02C,x
           sta    $C9,x
LA13A:     dex
           bpl    LA12C
           lda    #$01
           sta    $1E
           lda    #$23
           sta    $1F
           ldx    #$28
           stx    $25
           ldx    #$1D
           stx    $20
           jsr    LAE68
           jsr    LAD4F
           jsr    LABD1
           jsr    LAC48
           jsr    LA9B5
LA15C:     jsr    LA5F5
           jsr    LA67C
           jsr    LA48E
           jsr    LA4C9
           jsr    LA177
           jsr    LA5D3
           jsr    LA4FA
           jsr    LACA1
           jmp    LA15C

LA177:     dec    $27
           bpl    LA1BB
           lda    #$05
           sta    $27
           jsr    LA23A
           jsr    LA720
LA185:     ldx    #$02
           stx    $21
           ldx    $20
LA18B:     lda    $C9,x
           beq    LA1BC
           sta    $C9,x
           sta    $0E
           lda    $6E,x
           bne    LA19D
           jsr    LA1C2
           jsr    LA1E1
LA19D:     ldx    $20
           dex
           bpl    LA1B5
           ldx    #$1D
           dec    $1F
           bne    LA1B5
           lda    $1E
           eor    #$FF
           clc
           adc    #$01
           sta    $1E
           lda    #$23
           sta    $1F
LA1B5:     stx    $20
           dec    $21
           bpl    LA18B
LA1BB:     rts

LA1BC:     jsr    LA798
           jmp    LA19D

LA1C2:     lda    LB00E,x
           sta    $00
           ldy    $1E
           bpl    LA1D4
           clc
           adc    $1F
           sec
           sbc    #$01
           jmp    LA1DC

LA1D4:     lda    #$23
           sec
           sbc    $1F
           clc
           adc    $00
LA1DC:     sta    $AB,x
           sta    $0D
           rts

LA1E1:     and    #$01
           clc
           adc    LAFD2,x
           jmp    LAEC6

LA1EA:     ldx    $96
           jsr    LA1C2
           lda    $C9,x
           clc
           adc    #$01
           sta    $C9,x
           sta    $0E
           cmp    LB02C,x
           beq    LA209
LA1FD:     jsr    LA1E1
           jmp    LA2E9

LA203:     jsr    LA798
           jmp    LA2E9

LA209:     ldx    $96
           lda    #$00
           sta    $6E,x
           ldy    $95
           sta    $8C,y
           bpl    LA1FD
LA216:     jsr    LAEB0
           ldx    $96
           ldy    $C9,x
           lda    $AB,x
           tax
           lda    #$0A
           jsr    LAEC2
           ldx    $95
           lda    $8C,x
           ora    #$E0
           sta    $8C,x
           ldy    $96
           sta    $6E,y
           lda    #$0F
           sta    $C9,y
LA237:     jmp    LA1EA

LA23A:     lda    #$00
           sta    $A3
           ldx    #$08
LA240:     stx    $95
           lda    $8C,x
           beq    LA203
           and    #$1F
           sta    $96
           lda    $8C,x
           and    #$E0
           cmp    #$E0
           beq    LA237
           jsr    LA6C8
           ldx    $95
LA257:     ldy    $96
           lda    $6E,y
           and    #$7F
           sec
           sbc    #$01
           bne    LA266
           jmp    LA309

LA266:     sta    $99
           lda    $6E,y
           and    #$80
           sta    $98
           ora    $99
           sta    $6E,y
           lda    $8C,x
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           sec
           sbc    #$01
           asl    a
           tax
           lda    LB08E,x
           sta    $02
           lda    LB098,x
           sta    $04
           inx
           lda    LB08E,x
           sta    $03
           lda    LB098,x
           sta    $05
           ldx    $96
           ldy    $99
           lda    $C9,x
           clc
           adc    ($04),y
           cmp    #$96
           bcc    LA2A5
           jmp    LA216

LA2A5:     sta    $C9,x
           sta    $0E
           lsr    a
           cmp    $A3
           bcc    LA2B0
           sta    $A3
LA2B0:     lda    $98
           bmi    LA2BB
           lda    ($02),y
           beq    LA2BD
           lda    #$FF
           .byte  $2C
LA2BB:     lda    ($02),y
LA2BD:     sta    $00
           lda    $AB,x
           clc
           adc    $00
           cmp    #$54
           bcc    LA2CB
           jmp    LA216

LA2CB:     sta    $AB,x
           sta    $0D
           stx    $21
           jsr    LA1E1
           ldx    $21
           lda    $C9,x
           cmp    #$91
           bcc    LA2E9
           lda    $AB,x
           sec
           sbc    $25
           cmp    #$FD
           bcs    LA2FA
           cmp    #$05
           bcc    LA2FA
LA2E9:     ldx    $95
           dex
           bmi    LA2F1
           jmp    LA240

LA2F1:     lda    #$00
           sec
           sbc    $A3
           sta    VIC+$A
           rts

LA2FA:     lda    $9C
           bne    LA305
           lda    #$0B
           sta    $9C
           jsr    LA3DD
LA305:     jmp    LA2E9

           rts

LA309:     cpy    #$10
           bcs    LA329
LA30D:     lda    $A4
           cmp    #$04
           bcc    LA336
           ldx    #$01
           jsr    LADFF
           beq    LA30D
           pha
           ldx    #$07
           jsr    LADFF
           and    #$80
           sta    $01
           pla
           tax
           jmp    LA350

LA329:     cpy    #$10
           bcc    LA336
           cpy    #$16
           bcs    LA336
           ldx    #$04
           jmp    LA350

LA336:     lda    $AB,y
           sec
           sbc    $25
           ldx    #$01
           cmp    #$14
           bcc    LA350
           cmp    #$EB
           bcs    LA350
           inx
           cmp    #$1E
           bcc    LA350
           cmp    #$E1
           bcs    LA350
           inx
LA350:     stx    $00
           inx
           txa
           asl    a
           asl    a
           asl    a
           asl    a
           asl    a
           sta    $21
           ora    $96
           ldx    $95
           sta    $8C,x
           ldx    $00
           lda    LB089,x
           ldx    $A4
           cpx    #$04
           bcc    LA377
           ldx    $96
           cpx    #$10
           bcs    LA377
           ora    $01
           jmp    LA381

LA377:     ldx    $96
           ldy    $AB,x
           cpy    $25
           bcs    LA381
           ora    #$80
LA381:     sta    $6E,x
           sta    $01
           lda    $95
           cmp    #$08
           beq    LA390
LA38B:     ldx    $95
           jmp    LA257

LA390:     ldx    #$07
           lda    $8C,x
           beq    LA399
           jsr    LA3A4
LA399:     dex
           lda    $8C,x
           beq    LA38B
           jsr    LA3A4
           jmp    LA38B

LA3A4:     and    #$E0
           cmp    #$E0
           beq    LA3BC
           lda    $8C,x
           and    #$1F
           tay
           lda    $01
           sta    $6E,y
           lda    $8C,x
           and    #$1F
           ora    $21
           sta    $8C,x
LA3BC:     rts

LA3BD:     lda    $2B
           beq    LA3BC
           ldx    #$1D
LA3C3:     stx    $21
           lda    $C9,x
           beq    LA43F
           sec
           sbc    $2A
           cmp    #$03
           bcc    LA3D4
           cmp    #$FA
           bcc    LA43F
LA3D4:     lda    $AB,x
           sec
           sbc    $29
           cmp    #$FC
           bcc    LA43F
LA3DD:     jsr    LAEB0
           ldy    #$08
LA3E2:     lda    $8C,y
           beq    LA3ED
           and    #$1F
           cmp    $21
           beq    LA3F2
LA3ED:     dey
           bpl    LA3E2
           bmi    LA405
LA3F2:     lda    #$00
           sta    $8C,y
           sta    $6E,x
           cpy    #$06
           bcs    LA448
LA3FD:     lda    LAFF0,x
           ldx    #$00
           jsr    LACF7
LA405:     ldx    $21
           ldy    $C9,x
           lda    #$00
           sta    $C9,x
           sta    $6E,x
           lda    $AB,x
           tax
           lda    #$0A
           jsr    LAEC2
           ldx    #$07
LA419:     lda    $53,x
           beq    LA423
           dex
           bpl    LA419
           jmp    LA0F8

LA423:     lda    $0D
           sta    $5B,x
           lda    $0E
           sta    $63,x
           lda    #$03
           sta    $53,x
           ldx    $21
           lda    LAFF0,x
           ldx    #$00
           jsr    LACF7
           jsr    LA4C9
           jmp    LA6B8

LA43F:     ldx    $21
           dex
           bmi    LA447
           jmp    LA3C3

LA447:     rts

LA448:     inc    $9A
           cpy    #$08
           bne    LA3FD
           lda    #$FF
           sta    $A5
           lda    #$03
           sta    $A6
           ldy    $9A
           ldx    LAFBA,y
           stx    $05
           lda    LAFC2,y
           sta    $04
           jsr    LACF7
           ldx    #$1C
           ldy    #$A8
           lda    #$04
           sta    $22
           lda    #$00
           sta    $23
           lda    #$FF
           sta    $9B
           sed
           lda    $04
           clc
           adc    #$60
           sta    $04
           lda    $05
           adc    #$00
           sta    $05
           cld
           lda    #$01
           jsr    LAD80
           ldx    $21
           jmp    LA405

LA48E:     dec    $6B
           bpl    LA447
           lda    #$0A
           sta    $6B
           ldx    #$07
LA498:     stx    $21
           lda    $53,x
           beq    LA4C3
           lda    $63,x
           sta    $0E
           lda    $5B,x
           sta    $0D
           lda    #$0B
           sec
           sbc    $53,x
           jsr    LAEC6
           ldx    $21
           lda    $53,x
           asl    a
           asl    a
           asl    a
           asl    a
           clc
           adc    #$7F
           sta    VIC+$D
           dec    $53,x
           bne    LA4C3
           jsr    LAEAA
LA4C3:     ldx    $21
           dex
           bpl    LA498
LA4C8:     rts

LA4C9:     lda    #$00
           sta    $A4
           ldx    #$1D
LA4CF:     lda    $C9,x
           beq    LA4D5
           inc    $A4
LA4D5:     dex
           bpl    LA4CF
           lda    $A4
           cmp    #$06
           bcs    LA4E2
           lda    #$01
           sta    $A7
LA4E2:     lda    $A4
           bne    LA4C8
           lda    $9C
           beq    LA4EB
           rts

LA4EB:     ldx    $25
           ldy    #$98
           lda    #$0A
           jsr    LAEC2
           jsr    LA6B8
           jmp    LAC29

LA4FA:     dec    $A5
           bne    LA4C8
           dec    $A6
           bpl    LA4C8
           lda    #$01
           sta    $A5
           lda    #$00
           sta    $A6
           lda    $A7
           bne    LA51A
           ldx    $E7
           ldy    $6C,x
           ldx    LB077,y
           jsr    LADFF
           bne    LA4C8
LA51A:     ldx    $E7
           lda    $EA,x
           cmp    #$06
           bcc    LA525
           ldx    #$00
           .byte  $2C
LA525:     ldx    #$01
           jsr    LADFF
           bne    LA53C
           lda    #$1C
           sta    $00
           lda    $E6
           ora    $E5
           beq    LA540
           ldy    #$01
           lda    $8C,x
           beq    LA575
LA53C:     lda    #$16
           sta    $00
LA540:     ldx    #$05
LA542:     lda    $8C,x
           beq    LA54A
           dex
           bpl    LA542
           rts

LA54A:     stx    $95
           ldx    #$1B
LA54E:     ldy    LB04A,x
           cpy    $00
           bcs    LA55F
           lda    $C9,y
           beq    LA55F
           lda    $6E,y
           beq    LA563
LA55F:     dex
           bpl    LA54E
           rts

LA563:     sty    $96
           tya
           ora    #$20
           ldx    $95
           sta    $8C,x
           lda    #$12
           ora    LB0A2,y
           sta    $6E,y
LA574:     rts

LA575:     ldx    #$00
           jsr    LADFF
           clc
           adc    #$1C
           tay
           ldx    #$08
           lda    $C9,y
           beq    LA53C
           lda    $8C,x
           bne    LA53C
           lda    #$01
           sta    $9A
           stx    $95
           sty    $96
           jsr    LA563
           lda    $96
           sec
           sbc    #$1C
           tax
           ldy    #$07
           sty    $95
           asl    a
           asl    a
           ora    #$03
           sta    $00
           lda    #$02
           sta    $01
LA5A8:     ldx    $00
           ldy    LAFCA,x
           beq    LA574
           lda    $C9,y
           beq    LA5CB
           lda    $6E,y
           bne    LA5CB
           ldx    $95
           lda    $8C,x
           bne    LA5CB
           jsr    LA563
           lda    $9A
           asl    a
           sta    $9A
           dec    $95
           dec    $01
LA5CB:     lda    $01
           beq    LA574
           dec    $00
           bpl    LA5A8
LA5D3:     lda    $9B
           beq    LA574
           dec    $9B
           bne    LA574
           ldx    #$28
           stx    $0D
           ldy    #$A8
           sty    $0E
LA5E3:     lda    #$16
           jsr    LAEC6
           lda    $0D
           sec
           sbc    #$04
           cmp    #$18
           beq    LA574
           sta    $0D
           bpl    LA5E3
LA5F5:     lda    $9C
           bne    LA650
           dec    $26
           bpl    LA64F
           lda    #$05
           sta    $26
           jsr    LAE22
           lda    $25
           ldx    $0A
           beq    LA615
           ldx    $08
           bne    LA61E
           sec
           sbc    #$01
           bpl    LA61C
           bmi    LA61E
LA615:     clc
           adc    #$01
           cmp    #$52
           beq    LA61E
LA61C:     sta    $25
LA61E:     lda    $2B
           bne    LA63F
           lda    $0C
           beq    LA62C
           lda    #$00
           sta    $6D
           beq    LA63F
LA62C:     lda    $6D
           bne    LA63F
           inc    $6D
           lda    $25
           clc
           adc    #$03
           sta    $29
           sta    $2B
           lda    #$98
           sta    $2A
LA63F:     ldy    #$98
           ldx    $25
           lda    $2B
           beq    LA64A
           lda    #$11
           .byte  $2C
LA64A:     lda    #$10
           jmp    LAEC2

LA64F:     rts

LA650:     dec    $9D
           bpl    LA64F
           lda    #$0F
           sta    $9D
           ldx    #$07
           jsr    LADFF
           sta    VIC+$D
           jsr    LADFF
           sta    VIC+$A
           dec    VIC+$E
           ldx    $9C
           lda    LAFAE,x
           ldx    $25
           ldy    #$98
           jsr    LAEC2
           dec    $9C
           bne    LA64F
           jmp    LAA11

LA67C:     jsr    LA68B
           jsr    LA68B
           jsr    LA68B
           jsr    LA68B
           jmp    LA3BD

LA68B:     lda    $2B
           beq    LA64F
           dec    $28
           bpl    LA64F
           lda    #$01
           sta    $28
           lda    $2A
           lsr    a
           clc
           adc    #$AF
           sta    VIC+$B
           lda    $29
           sta    $0D
           lda    $2A
           sta    $0E
           sec
           sbc    #$01
           cmp    #$0F
           beq    LA6B8
           sta    $2A
           sta    $0E
           lda    #$12
           jmp    LAEC6

LA6B8:     jsr    LAEB6
           sta    $2B
           ldx    $29
           ldy    $2A
           beq    LA64F
           lda    #$13
           jmp    LAEC2

LA6C8:     ldx    $E7
           ldy    $6C,x
           ldx    LB077,y
           dex
           jsr    LADFF
           bne    LA6E3
           ldx    $E7
           ldy    $6C,x
           ldx    LB080,y
LA6DC:     lda    $47,x
           beq    LA6E4
           dex
           bpl    LA6DC
LA6E3:     rts

LA6E4:     stx    $2E
           ldy    $96
           lda    $C9,y
           beq    LA6E3
           cmp    #$7C
           bcs    LA6E3
           clc
           adc    #$0C
           sta    $3B,x
           sta    $0E
           lda    $AB,y
           clc
           adc    #$03
           cmp    #$54
           bcs    LA6E3
           sta    $2F,x
           sta    $0D
           ldx    $96
           ldy    #$01
           lda    $AB,x
           cmp    $25
           bcc    LA717
           tya
           eor    #$FF
           clc
           adc    #$01
           tay
LA717:     ldx    $2E
           sty    $47,x
           lda    #$14
           jmp    LAEC6

LA720:     dec    $A8
           bpl    LA6E3
           lda    #$01
           sta    $A8
           ldx    $E7
           ldy    $6C,x
           ldx    LB080,y
LA72F:     stx    $2E
           lda    $47,x
           beq    LA77C
           lda    $3B,x
           sta    $0E
           lda    $2F,x
           sta    $0D
           lda    #$13
           jsr    LAEC6
           ldx    $2E
           lda    $2F,x
           bmi    LA78F
           cmp    #$54
           bcs    LA78F
           sta    $0D
           lda    $3B,x
           clc
           adc    #$05
           cmp    #$9C
           bcs    LA78F
           sta    $3B,x
           sta    $0E
           lsr    a
           sta    $00
           lda    #$C8
           sec
           sbc    $00
           sta    VIC+$C
           lda    #$14
           jsr    LAEC6
           ldx    $2E
           lda    $3B,x
           cmp    #$93
           bcc    LA77C
           lda    $2F,x
           sec
           sbc    $25
           cmp    #$05
           bcc    LA782
LA77C:     ldx    $2E
           dex
           bpl    LA72F
           rts

LA782:     lda    #$13
           jsr    LAEC6
           lda    $9C
           bne    LA78F
           lda    #$06
           sta    $9C
LA78F:     ldx    $2E
           jsr    LAEBC
           sta    $47,x
           beq    LA77C
LA798:     lda    #$10
           jmp    LAE95

LA79D:     jsr    LAB59
           jsr    LAE68
           jsr    LAEA1
           sta    $0102
           jsr    LA9CC
           ldx    #$08
           ldy    #$08
           jsr    LADCD
           .byte  $31,$22,$31,$2A,$20,$24,$2D,$1B ; "ATARISOFT PRESENTS
           .byte  $22,$16,$28,$2A,$2E,$24,$2E,$29
           .byte  $22,$24,$00
           ldx    #$1C
           ldy    #$18
           jsr    LADCD
           .byte  $32,$31,$27,$31,$1C,$20,$31,$29 ; "GALAXIAN"
           .byte  $00
           ldx    #$18
           ldy    #$30
           jsr    LADCD
           .byte  $28,$2A,$2E,$24,$24,$16,$1B,$34,$00 ; "PRESS F1"
           ldx    #$14
           ldy    #$38
           jsr    LADCD
           .byte  $1B,$2D,$2A,$16,$2D,$28,$22,$20 ; "FOR OPTIONS"
           .byte  $2D,$29,$24,$00
           ldx    #$04
           ldy    #$08
           lda    #$0F
           jsr    LAE4F
           ldx    #$1D
           stx    $20
LA806:     lda    LB02C,x
           clc
           adc    #$3C
           sta    $C9,x
           lda    LB00E,x
           sta    $AB,x
           dex
           bpl    LA806
           lda    #$15
           sta    $1F
           lda    #$01
           sta    $1E
LA81E:     jsr    LA185
           lda    $20
           cmp    #$1D
           bne    LA81E
           ldx    #$14
           ldy    #$A0
           jsr    LADCD
           .byte  $23,$34,$3C,$3B,$36,$16,$31,$22 ; "(C)1983 ATARI"
           .byte  $31,$2A,$20,$00
           ldx    #$04
           ldy    #$A8
           jsr    LADCD
           .byte  $31,$27,$27,$16,$2A,$20,$32,$1E ; "ALL RIGHTS RESERVED  "
           .byte  $22,$24,$16,$2A,$2E,$24,$2E,$2A
           .byte  $2C,$2E,$21,$16,$16,$00
           lda    #$01
           sta    $0102
LA85C:     jsr    LAB70
           jsr    LA9E5         ; is F1 pressed?
           bne    LA871         ; jump if so
           jsr    LAE22         ; read joystick
           lda    $0C           ; button pressed?
           bne    LA85C         ; jump if not
           jsr    LAB59
           jmp    LA990

        ;; options screen
LA871:     jsr    LAEA1
           jsr    LAB59
           jsr    LAA08
           jsr    LAE68
           jsr    LA9CC
           lda    #$00
           sta    $0102
           jsr    LAD4F
           ldx    #$10
           ldy    #$28
           jsr    LADCD
           .byte  $1B,$34,$26,$24,$22,$31,$2A,$22 ; "F1-START GAME"
           .byte  $16,$32,$31,$30,$2E,$00
           ldx    #$10
           ldy    #$38
           jsr    LADCD
           .byte  $1B,$36,$26,$16,$16,$28,$27,$31 ; "F3-  PLAYER"
           .byte  $19,$2E,$2A,$00
           lda    $0105
           sta    $E7
           clc
           adc    #$34
           ldx    #$1C
           ldy    #$38
           jsr    LAEC2
           ldx    #$10
           ldy    #$48
           jsr    LADCD
           .byte  $1B,$38,$26,$27,$2E,$2C,$2E,$27 ; "F5-LEVEL"
           .byte  $00
           lda    $0104
           sta    $EA
           sta    $EB
           clc
           adc    #$34
           ldx    #$34
           ldy    #$48
           jsr    LAEC2
           ldx    #$10
           ldy    #$70
           jsr    LADCD
           .byte  $06,$16,$16,$16,$16,$16,$04,$16 ; [4 different ships]
           .byte  $16,$16,$02,$16,$16,$16,$01,$00
           ldx    #$10
           ldy    #$80
           jsr    LADCD
           .byte  $39,$33,$16,$16,$16,$16,$38,$33 ; "60    50  40  30"
           .byte  $16,$16,$37,$33,$16,$16,$36,$33,$00
           ldx    #$04
           ldy    #$90
           jsr    LADCD
           .byte  $34,$38,$33,$26,$3B,$33,$33,$16 ; "150-800 100  80  60"
           .byte  $34,$33,$33,$16,$16,$3B,$33,$16
           .byte  $16,$39,$33,$00
           lda    #$01
           sta    $0102
LA92F:     jsr    LAB70
           jsr    LAE22         ; read joystick
           lda    $0C           ; button pressed?
           beq    LA990         ; jump if so
           jsr    LA9F0         ; is F5 pressed?
           ldx    $A1
           sta    $A1
           cpx    #$01
           beq    LA963         ; jump if F5 previously pressed
           cmp    #$00
           beq    LA963         ; jump if F5 not pressed now
           lda    $EA
           clc
           adc    #$01
           and    #$07
           sta    $EA
           sta    $EB
           sta    $0104
           clc
           adc    #$34
           ldx    #$34
           ldy    #$48
           jsr    LAEC2
           jsr    LAB59
LA963:     jsr    LA9FC         ; is F3 pressed?
           ldx    $A2
           sta    $A2
           cpx    #$01
           beq    LA988         ; jump if F3 previously pressed
           cmp    #$00
           beq    LA988         ; jump if F3 not pressed now
           lda    $E7
           eor    #$01
           sta    $E7
           sta    $0105
           clc
           adc    #$34
           ldx    #$1C
           ldy    #$38
           jsr    LAEC2
           jsr    LAB59
LA988:     jsr    LA9E5         ; is F1 pressed?
           beq    LA92F         ; loop if F1 not pressed
        
           jsr    LAA08
LA990:     lda    $0104
           sta    $EA
           sta    $EB
           lda    #$02
           sta    $E8
           sta    $E9
           ldx    $0105
           lda    LAB8D,x
           sta    $E9
           lda    #$00
           sta    $E7
           jsr    LAB59
           jsr    LAEA1
           ldx    #$FF
           txs
           jmp    LA0E3

LA9B5:     ldy    #$05
LA9B7:     lda    #$F0
           jsr    LAE95
           dey
           lda    LA9C6,y
           sta    VIC+$C
           bne    LA9B7
           rts

LA9C6:     .byte  $00,$E3,$DB,$D6,$D2,$C9
LA9CC:     ldx    #$06
LA9CE:     stx    $21
           lda    LAB9B,x
           pha
           ldy    LAB95,x
           lda    LAB8F,x
           tax
           pla
           jsr    LAE4F
           ldx    $21
           dex
           bpl    LA9CE
           rts

        ;; returns 1 if F1 pressed, otherwise returns 0
LA9E5:     lda    #$EF          ; activate row 4
           jsr    LACEB         ; and get columns
           and    #$80          ; column 7 active (F1)?
           bne    LAA05         ; return 0 if not active
           beq    LA9F9         ; return 1
        
        ;; returns 1 if F5 pressed, otherwise returns 0
LA9F0:     lda    #$BF          ; activate row 5
           jsr    LACEB         ; and get column
           and    #$80          ; column 7 active (F3)?
           bne    LAA05         ; return 0 if not active
LA9F9:     lda    #$01          ; return 1
           rts

        ;; returns 1 if F3 pressed, otherwise returns 0
LA9FC:     lda    #$DF          ; activate row 6
           jsr    LACEB
           and    #$80
           beq    LA9F9
LAA05:     lda    #$00
           rts

LAA08:     jsr    LAE93
           jsr    LA9E5
           bne    LAA08
           rts

LAA11:     jsr    LAEA1
           lda    #$2F
           sta    VIC+$E
           ldx    $E7
           dec    $E8,x
           bmi    LAA44
           jsr    LAB33
LAA22:     jsr    LABD1
           ldx    #$0A
LAA27:     jsr    LAE93
           jsr    LAE93
           txa
           pha
           and    #$01
           beq    LAA39
           jsr    LABB2
           jmp    LAA3C

LAA39:     jsr    LABA1
LAA3C:     pla
           tax
           dex
           bpl    LAA27
           jmp    LA120

LAA44:     jsr    LABD1
           ldx    $E7
           lda    #$FF
           sta    $E8,x
           ldy    #$08
           sty    $0E
           ldx    #$18
           stx    $0D
           jsr    LADCD
           .byte  $32,$31,$30,$2E,$16,$16,$2D,$2C
           .byte  $2E,$2A,$00
           jsr    LAEA1
           lda    #$32
           sta    $00          
           jsr    LAB33
           ldx    #$0A
LAA6F:     jsr    LAE93
           dex
           bne    LAA6F
           ldx    #$18
           stx    $0D
           ldy    #$08
           sty    $0E
           jsr    LADCD
           .byte  $16,$16,$16,$16,$16,$16,$16,$16
           .byte  $16,$16,$00
           jmp    LAA22

LAA8E:     ldy    #$02
           lda    #$00
LAA92:     ora    $EE,y
           ora    $F0,y
           ora    $F4,y
           dey
           bpl    LAA92
           bit    $E8
           bne    LAAA5
           jsr    LB066
LAAA5:     ldy    #$01
           sty    $0C
LAAA9:     inc    $0C
           lda    $0C
           cmp    #$14
           beq    LAAD4
           asl    a
           asl    a
           asl    a
           tay
           ldx    #$00
           jsr    LADCD
           .byte  $16,$16,$16,$16,$16,$16,$16,$16
           .byte  $16,$16,$16,$16,$16,$16,$16,$16
           .byte  $16,$16,$16,$16,$16,$16,$00
           jmp    LAAA9

LAAD4:     ldx    #$02
           ldy    #$04
           lda    #$07
           jsr    LAE4F
           jsr    LAB59
           ldx    #$10
           ldy    #$28
           jsr    LADCD
           .byte  $1B,$34,$26,$24,$22,$31,$2A,$22 ; "F1-START GAME"
           .byte  $16,$32,$31,$30,$2E,$00
           ldx    #$10
           ldy    #$40
           jsr    LADCD
           .byte  $1B,$38,$26,$2D,$28,$22,$20,$2D ; "F5-OPTIONS"
           .byte  $29,$24,$00
LAB07:     jsr    LAB70
           jsr    LAE22         ; read joystick
           lda    $0C           ; button pressed?
           beq    LAB21         ; jump if so
           jsr    LA9E5         ; F1 pressed?
           bne    LAB21         ; jump if so
           jsr    LA9F0         ; F5 pressed?
           beq    LAB07         ; jump if not
           jsr    LAB59
           jmp    LA871

LAB21:     jsr    LAB59
           jsr    LA990
           ldx    #$FF
           txs
           jmp    LA0E3

           ldx    #$FF
           txs
           jmp    LA044

LAB33:     lda    $E7
           eor    #$01
           tax
           lda    $E8,x
           bmi    LAB50
           stx    $E7
           ldx    #$1D
LAB40:     lda    $C9,x
           tay
           lda    $1FE1,x
           sta    $C9,x
           tya
           sta    $1FE1,x
           dex
           bpl    LAB40
           rts

LAB50:     ldx    $E7
           lda    $E8,x
           bpl    LAB8C
           jmp    LAA8E

LAB59:     lda    #$0E
           sta    VIC+$F
           lda    #$2F
           sta    VIC+$E
           lda    #$00
           sta    $A9
           sta    $9E
           sta    $9F
           lda    #$24
           sta    $A0
           rts

LAB70:     inc    $9E
           bne    LAB8C
           inc    $9F
           bne    LAB8C
           lda    $A9
           bne    LAB80
           dec    $A0
           bne    LAB8C
LAB80:     ldx    #$07
           stx    $A9
           jsr    LADFF
           ora    #$08
           sta    VIC+$F
LAB8C:     rts

LAB8D:     .byte  $FF,$02
LAB8F:     .byte  $00,$01,$02,$07,$08,$0A
LAB95:     .byte  $00,$01,$06,$07,$09,$0A
LAB9B:     .byte  $07,$06,$07,$0F,$03,$07
LABA1:     ldx    #$38
           ldy    #$A8
           jsr    LADCD
           .byte  $16,$16,$16,$16,$16,$16,$16,$16,$00
           rts

LABB2:     ldx    #$38
           ldy    #$A8
           jsr    LADCD
           .byte  $28,$27,$31,$19,$2E,$2A,$00
           ldx    #$54
           ldy    #$A8
           lda    $E7
           clc
           adc    #$34
           jsr    LAEC2
           rts

LABCD:     ldx    $E7
           inc    $E8,x
LABD1:     jsr    LABB2
           ldx    #$00
           ldy    #$A8
           jsr    LADCD
           .byte  $16,$16,$16,$16,$16,$16,$16,$16
           .byte  $16,$16,$16,$16,$16,$16,$00
           ldy    #$A8
           sty    $0E
           ldx    #$00
           stx    $0D
           ldy    $E7
           ldx    $E8,y
           stx    $A3
           bmi    LAC28
           beq    LAC12
           dec    $A3
           cpx    #$0D
           bcc    LAC06
           ldx    #$0C
           stx    $A3
LAC06:     lda    #$15
           jsr    LAEC6
           lda    $0D
           clc
           adc    #$04
           sta    $0D
LAC12:     lda    #$16
           jsr    LAEC6
           dec    $A3
           bpl    LAC06
           ldx    $E7
           lda    $E8,x
           cmp    #$0D
           bcc    LAC28
           lda    #$25
           jmp    LAEC6

LAC28:     rts

LAC29:     jsr    LAEA1
           ldx    $E7
           lda    $6C
           cmp    #$08
           beq    LAC36
           inc    $6C,x
LAC36:     sed
           lda    $EA,x
           clc
           adc    #$01
           sta    $EA,x
           cld
           jsr    LAC48
           ldx    #$FF
           txs
           jmp    LA0F8

LAC48:     lda    #$A0
           sta    $0E
           lda    #$58
LAC4E:     sta    $0D
           lda    #$16
           jsr    LAEC6
           lda    $0D
           sec
           sbc    #$04
           bpl    LAC4E
           ldx    #$54
           stx    $0D
           ldx    $E7
           lda    $EA,x
           sed
           clc
           adc    #$01
           cld
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           beq    LAC81
           sta    $21
LAC71:     lda    #$17
           jsr    LAEC6
           lda    $0D
           sec
           sbc    #$04
           sta    $0D
           dec    $21
           bne    LAC71
LAC81:     ldx    $E7
           lda    $EA,x
           sed
           clc
           adc    #$01
           cld
           and    #$0F
           beq    LACA0
           sta    $21
LAC90:     lda    #$18
           jsr    LAEC6
           lda    $0D
           sec
           sbc    #$04
           sta    $0D
           dec    $21
           bne    LAC90
LACA0:     rts

LACA1:     jsr    LA9F0         ; F5 pressed?
           beq    LACA9         ; jump if not
           jmp    LA871
LACA9:     jsr    LA9E5         ; F1 pressed?
           beq    LACB7         ; jump if not
           jsr    LA990
           ldx    #$FF
           txs
           jmp    LA0E3

        ;; pause game if SPACE key pressed
LACB7:     jsr    LACDE         ; SPACE pressed?
           bcc    LACF6         ; return if not
           lda    #$20
           sta    VIC+$E
           jsr    LAE93         ; wait a short time (debounce)
           jsr    LACD8         ; wait until SPACE released
LACC7:     jsr    LAB70
           jsr    LACDE         ; SPACE pressed?
           bcc    LACC7         ; loop if not
           jsr    LACD8         ; wait until SPACE released
           jsr    LAE93         ; wait a short time (debounce)
           jmp    LAB59

        ;; wait while SPACE key is held
LACD8:     jsr    LACDE
           bcs    LACD8
           rts

        ;; returns with carry set iff SPACE key is pressed
LACDE:     lda    #$EF
           jsr    LACEB
           and    #$01
           bne    LACE9
           sec
           rts
LACE9:     clc
           rts

        ;; read keyboard (rows in A on entry, columns in A on return)
LACEB:     sta    JOY_REG_RIGHT
LACEE:     lda    VIA2+$1
           cmp    VIA2+$1
           bne    LACEE
LACF6:     rts

LACF7:     pha
           stx    $00
           lda    $E7
           asl    a
           clc
           adc    $E7
           tax
           pla
           sed
           clc
           adc    $EE,x
           sta    $EE,x
           lda    $00
           adc    $EF,x
           sta    $EF,x
           lda    #$00
           adc    $F0,x
           sta    $F0,x
           cld
           stx    $0C
           ldy    $E7
           lda    $EF,x
           cmp    #$70
           bcc    LAD2D
           lda    $EC,y
           bne    LAD2B
           ldx    $E7
           inc    $EC,x
           jsr    LABCD
LAD2B:     ldx    $0C
LAD2D:     inx
           inx
           stx    $00
           ldy    #$02
LAD33:     lda    $EE,x
           cmp    $F4,y
           bcc    LAD4F
           beq    LAD3E
           bcs    LAD42
LAD3E:     dex
           dey
           bpl    LAD33
LAD42:     ldx    $00
           ldy    #$02
LAD46:     lda    $EE,x
           sta    $F4,y
           dex
           dey
           bpl    LAD46
LAD4F:     ldx    #$20
           ldy    #$00
           lda    #$F4
           sta    $22
           lda    #$00
           sta    $23
           lda    #$02
           jsr    LAD80
           lda    #$EE
           sta    $22
           lda    #$00
           sta    $23
           ldx    #$00
           ldy    #$00
           lda    #$02
           jsr    LAD80
           lda    $0105
           beq    LADCC
           lda    #$F1
           sta    $22
           ldx    #$40
           ldy    #$00
           lda    #$02
LAD80:     stx    $0D
           sty    $0E
           sta    $24
           ldx    #$00
           stx    $AA
LAD8A:     ldy    $24
           lda    ($22),y
           pha
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           clc
           adc    #$33
           cmp    #$33
           bne    LAD9E
           ldx    $AA
           beq    LADA5
LAD9E:     ldx    #$01
           stx    $AA
           jsr    LAEC6
LADA5:     lda    $0D
           clc
           adc    #$04
           sta    $0D
           pla
           and    #$0F
           clc
           adc    #$33
           cmp    #$33
           bne    LADBA
           ldx    $AA
           beq    LADC1
LADBA:     ldx    #$01
           stx    $AA
           jsr    LAEC6
LADC1:     lda    $0D
           clc
           adc    #$04
           sta    $0D
           dec    $24
           bpl    LAD8A
LADCC:     rts

LADCD:     stx    $0D
           sty    $0E
           pla
           sta    $2C
           pla
           sta    $2D
           bne    LADE9
LADD9:     ldy    #$00
           lda    ($2C),y
           beq    LADF1
           jsr    LAEC6
           lda    $0D
           clc
           adc    #$04
           sta    $0D
LADE9:     inc    $2C
           bne    LADD9
           inc    $2D
           bne    LADD9
LADF1:     lda    $2D
           pha
           lda    $2C
           pha
           rts

           .byte  $A5,$0C,$29,$10,$D0,$FA,$60
LADFF:     lda    VIC+$4
           adc    $0101
           inc    $0103
           inc    $0100
           ldy    $0103
        ;; The following instruction may be a bug. The ($FF) addressing
        ;; takes the address low byte from $FF and high byte from $00
        ;; $00 seems to be generally used as temporary storage and $FF is
        ;; never really initialized. Also Y does not appear to get initialized
        ;; before this subroutine is called. Maybe this was supposed to be "adc #$FF"?
        ;; Removing it completely appears to make no difference for the game.
           adc    ($FF),y
           adc    VIC+$4
           sta    $0101
           and    LAE1A,x
           rts

LAE1A:     .byte  $01,$03,$07,$0F,$1F,$3F,$7F,$FF
LAE22:     ldy    #$03
LAE24:     lda    #$FF
           cpy    #$02
           beq    LAE33
           sta    VIA2+$2
           lda    JOY_REG_OTHER
           jmp    LAE3A

LAE33:     lsr    a
           sta    VIA2+$2
           lda    JOY_REG_RIGHT
LAE3A:     and    LAE4B,y
           sta    $08,y
           dey
           bpl    LAE24
           lda    JOY_REG_OTHER
           and    #JOY_MASK_BUTTON
           sta    $0C
           rts

LAE4B:     .byte  JOY_MASK_LEFT,JOY_MASK_UP,JOY_MASK_RIGHT,JOY_MASK_DOWN
LAE4F:     stx    $06
LAE51:     sty    $07
           pha
           jsr    LAE8A
           ldy    #$15
           pla
LAE5A:     sta    ($04),y
           dey
           bpl    LAE5A
           ldy    $07
           cpy    $06
           beq    LAE89
           dey
           bpl    LAE51
LAE68:     lda    #>CHARSET     ; clear screen
           sta    $03
           lda    #<CHARSET
           sta    $02
           tay
           ldx    #$0F
LAE73:     sta    ($02),y
           sta    CHARSET+$E20,y
           iny
           bne    LAE73
           inc    $03
           dex
           bne    LAE73
           rts

LAE81:     lda    ($F7),y
           sta    $02
           lda    ($F9),y
           sta    $03
LAE89:     rts

LAE8A:     lda    ($FB),y
           sta    $04
           lda    ($FD),y
           sta    $05
           rts

LAE93:     lda    #$FF
LAE95:     sec
LAE96:     pha
LAE97:     sbc    #$01
           bne    LAE97
           pla
           sbc    #$01
           bne    LAE96
           rts

LAEA1:     jsr    LAEB0
           jsr    LAEB6
           jsr    LAEBC
LAEAA:     lda    #$00
           sta    VIC+$D
           rts

LAEB0:     lda    #$00
           sta    VIC+$A
           rts

LAEB6:     lda    #$00
           sta    VIC+$B
           rts

LAEBC:     lda    #$00
           sta    VIC+$C
           rts

LAEC2:     stx    $0D
           sty    $0E
LAEC6:     ldx    $0D
           sta    $18
           txa
           and    #$03
           sta    $19
           txa
           lsr    a
           lsr    a
           sta    $14
           lda    $18
           asl    a
           tay
           lda    LB1E4,y
           sta    $1A
           iny
           lda    LB1E4,y
           sta    $1B
           ldy    #$00
           lda    ($1A),y
           sta    $11
           iny
           lda    ($1A),y
           sta    $12
           lda    $1A
           clc
           adc    #$02
           sta    $15
           lda    $1B
           adc    #$00
           sta    $16
           lda    #$00
           sta    $1C
           lda    $12
           sta    $17
LAF03:     lda    $0E
           sta    $1D
           ldy    $14
           cpy    #$16
           bcs    LAF57
           jsr    LAE81
           lda    $17
           cmp    $12
           beq    LAF58
           cmp    #$01
           beq    LAF5C
           ldx    #$04
LAF1C:     ldy    $11
           sty    $13
LAF20:     lda    #$00
           ldy    $1C
           jsr    LAF6D
           ldy    $1D
           pha
           lda    $0102
           beq    LAF37
           bpl    LAF3D
           pla
           and    ($02),y
           jmp    LAF47

LAF37:     pla
           ora    ($02),y
           jmp    LAF47

LAF3D:     lda    ($02),y
           and    LAF64,x
           sta    $00
           pla
           ora    $00
LAF47:     sta    ($02),y
           inc    $1C
           inc    $1D
           dec    $13
           bne    LAF20
           inc    $14
           dec    $17
           bne    LAF03
LAF57:     rts

LAF58:     ldx    $19
           bpl    LAF1C
LAF5C:     lda    #$05
           clc
           adc    $19
           tax
           bne    LAF1C
        
LAF64:     .byte  $00,$C0,$F0,$FC,$00,$FF,$3F,$0F,$03
        
LAF6D:     sta    $0F
           stx    $10
           cpx    #$04
           bcc    LAF90
           beq    LAF98
LAF77:     tya
           sec
           sbc    $11
           tay
           lda    ($15),y
           tay
           lda    $19
           clc
           adc    #$FC
           tax
           tya
LAF86:     asl    a
           asl    a
           inx
           bne    LAF86
LAF8B:     ora    $0F
           ldx    $10
           rts

LAF90:     lda    ($15),y
           jsr    LAFA4
           jmp    LAF8B

LAF98:     lda    ($15),y
           jsr    LAFA4
           ora    $0F
           sta    $0F
           jmp    LAF77

LAFA4:     ldx    $19
           beq    LAFAD
LAFA8:     lsr    a
           lsr    a
           dex
           bne    LAFA8
LAFAD:     rts

LAFAE:     .byte  $00,$0A,$0C,$0F,$0E,$0D,$0E,$0D
           .byte  $0C,$0D,$0C,$0B
LAFBA:     .byte  $00,$00,$00,$01,$01,$02,$02,$07
LAFC2:     .byte  $00,$00,$90,$40,$40,$40,$40,$40
LAFCA:     .byte  $00,$1A,$19,$1B,$00,$17,$18,$16
LAFD2:     .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $02,$02,$02,$02,$02,$02,$04,$04
           .byte  $04,$04,$04,$04,$06,$06
LAFF0:     .byte  $30,$30,$30,$30,$30,$30,$30,$30
           .byte  $30,$30,$30,$30,$30,$30,$30,$30
           .byte  $40,$40,$40,$40,$40,$40,$50,$50
           .byte  $50,$50,$50,$50,$60,$60
LB00E:     .byte  $2D,$27,$21,$1B,$15,$0F,$09,$03
           .byte  $2D,$27,$21,$1B,$15,$0F,$09,$03
           .byte  $27,$21,$1B,$15,$0F,$09,$27,$21
           .byte  $1B,$15,$0F,$09,$0F,$21
LB02C:     .byte  $3C,$3C,$3C,$3C,$3C,$3C,$3C,$3C
           .byte  $32,$32,$32,$32,$32,$32,$32,$32
           .byte  $28,$28,$28,$28,$28,$28,$1E,$1E
           .byte  $1E,$1E,$1E,$1E,$14,$14
LB04A:     .byte  $19,$18,$13,$12,$0C,$0B,$04,$03
           .byte  $1A,$17,$14,$11,$0D,$0A,$05,$02
           .byte  $1B,$16,$15,$10,$0E,$09,$06,$01
           .byte  $0F,$08,$07,$00
        
LB066:     ldx    #$1C
           ldy    #$00
           jsr    LADCD
           .byte  $22,$1E,$2E,$16,$2F,$2E,$2A,$2B
           .byte  $00
           rts

LB077:     .byte  $07,$06,$05,$04,$03,$02,$02,$01
           .byte  $01
LB080:     .byte  $05,$05,$06,$06,$07,$08,$09,$0A
           .byte  $0B
LB089:     .byte  $11,$20,$20,$2C,$10
LB08E:     .word  LB0C0,LB0D2,LB0F3,LB114,LB141
LB098:     .word  LB152,LB164,LB185,LB1A6,LB1D3
LB0A2:     .byte  $80,$80,$80,$80,$00,$00,$00,$00
           .byte  $80,$80,$80,$80,$00,$00,$00,$00
           .byte  $80,$80,$80,$00,$00,$00,$80,$80
           .byte  $80,$00,$00,$00,$00,$80
LB0C0:     .byte  $00,$00,$00,$00,$00,$01,$00,$00
           .byte  $00,$01,$00,$01,$01,$01,$01,$01
           .byte  $00,$01
LB0D2:     .byte  $00,$00,$00,$01,$00,$00,$00,$00
           .byte  $01,$00,$00,$01,$00,$00,$00,$01
           .byte  $00,$00,$01,$01,$00,$01,$00,$01
           .byte  $01,$00,$01,$01,$01,$01,$00,$01
           .byte  $00
LB0F3:     .byte  $00,$00,$00,$01,$00,$01,$00,$01
           .byte  $01,$01,$01,$01,$01,$00,$01,$01
           .byte  $01,$01,$01,$01,$01,$00,$01,$01
           .byte  $01,$00,$01,$01,$01,$00,$01,$01
           .byte  $00
LB114:     .byte  $00,$01,$00,$01,$01,$00,$01,$01
           .byte  $00,$01,$01,$01,$01,$01,$01,$01
           .byte  $01,$01,$01,$01,$01,$01,$01,$01
           .byte  $01,$01,$01,$01,$01,$01,$01,$01
           .byte  $01,$01,$01,$01,$01,$01,$01,$01
           .byte  $01,$01,$01,$01,$00
LB141:     .byte  $00,$00,$00,$01,$00,$01,$01,$01
           .byte  $01,$01,$01,$01,$01,$01,$00,$01
           .byte  $00
LB152:     .byte  $00,$01,$01,$01,$01,$01,$01,$01
           .byte  $01,$01,$01,$01,$01,$FF,$FF,$FF
           .byte  $FF,$FF
LB164:     .byte  $00,$02,$02,$02,$02,$02,$02,$02
           .byte  $02,$02,$02,$02,$02,$02,$02,$02
           .byte  $02,$02,$02,$02,$02,$02,$02,$02
           .byte  $02,$02,$02,$02,$02,$02,$02,$02
           .byte  $02
LB185:     .byte  $00,$02,$02,$02,$02,$02,$02,$02
           .byte  $02,$02,$02,$02,$02,$02,$02,$02
           .byte  $02,$02,$02,$02,$02,$02,$02,$02
           .byte  $02,$02,$02,$02,$02,$02,$02,$02
           .byte  $02
LB1A6:     .byte  $00,$02,$02,$02,$02,$02,$02,$02
           .byte  $02,$02,$02,$02,$02,$02,$01,$01
           .byte  $01,$01,$01,$01,$01,$01,$01,$01
           .byte  $01,$01,$01,$01,$01,$01,$01,$01
           .byte  $01,$01,$01,$01,$02,$01,$01,$02
           .byte  $02,$02,$02,$02,$02
LB1D3:     .byte  $00,$02,$02,$02,$02,$02,$02,$02
           .byte  $02,$02,$02,$02,$02,$02,$02,$02
           .byte  $02
LB1E4:     .word LB25E,LB272,LB286,LB29C,LB2B2,LB2C6,LB2DA,LB2EE
           .word LB302,LB316,LB32A,LB340,LB352,LB364,LB376,LB388
           .word LB39A,LB3AC,LB3BE,LB3C4,LB3C9,LB3CD,LB3D7,LB3E1
           .word LB3EB,LB3F5,LB3FF,LB409,LB413,LB41D,LB427,LB431
           .word LB43B,LB445,LB44F,LB459,LB463,LB46D,LB477,LB481
           .word LB48B,LB495,LB49F,LB4A9,LB4B3,LB4BD,LB4C7,LB4D1
           .word LB4DB,LB4E5,LB4EF,LB4F9,LB503,LB50D,LB517,LB521
           .word LB52B,LB535,LB53F,LB549,LB553
LB25E:     .byte  $09,$03,$00,$00,$04,$01,$0D,$01
           .byte  $05,$0C,$00,$00,$00,$10,$40,$70
           .byte  $40,$50,$30,$00
LB272:     .byte  $09,$03,$00,$00,$00,$04,$01,$0D
           .byte  $01,$0C,$00,$00,$00,$00,$10,$40
           .byte  $70,$40,$30,$00
LB286:     .byte  $0A,$03,$00,$00,$00,$08,$01,$0D
           .byte  $01,$0B,$0C,$00,$00,$00,$00,$20
           .byte  $40,$70,$40,$E0,$30,$00
LB29C:     .byte  $0A,$03,$00,$00,$00,$00,$08,$01
           .byte  $0D,$03,$08,$00,$00,$00,$00,$00
           .byte  $20,$40,$70,$C0,$20,$00
LB2B2:     .byte  $09,$03,$00,$00,$09,$0E,$0F,$03
           .byte  $03,$00,$00,$00,$00,$10,$60,$B0
           .byte  $C0,$C0,$C0,$00
LB2C6:     .byte  $09,$03,$00,$00,$00,$04,$08,$0E
           .byte  $03,$03,$00,$00,$00,$00,$10,$B0
           .byte  $F0,$C0,$C0,$00
LB2DA:     .byte  $09,$03,$00,$00,$0D,$0B,$0A,$02
           .byte  $02,$00,$00,$00,$00,$10,$70,$E0
           .byte  $80,$80,$80,$00
LB2EE:     .byte  $09,$03,$00,$00,$00,$04,$0C,$0B
           .byte  $02,$02,$00,$00,$00,$00,$10,$E0
           .byte  $A0,$80,$80,$00
LB302:     .byte  $09,$03,$00,$00,$02,$09,$11,$20
           .byte  $01,$18,$00,$00,$00,$B0,$14,$40
           .byte  $C8,$20,$C0,$00
LB316:     .byte  $09,$03,$00,$00,$02,$21,$18,$22
           .byte  $28,$13,$08,$00,$60,$A0,$18,$48
           .byte  $88,$10,$20,$40
LB32A:     .byte  $0A,$03,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00
LB340:     .byte  $08,$03,$00,$28,$2F,$0D,$0D,$2F
           .byte  $28,$00,$00,$A0,$E0,$C0,$C0,$E0
           .byte  $A0,$00
LB352:     .byte  $08,$03,$00,$23,$0B,$3D,$3D,$0B
           .byte  $23,$00,$00,$20,$80,$F0,$F0,$80
           .byte  $20,$00
LB364:     .byte  $08,$03,$00,$02,$38,$0D,$29,$0C
           .byte  $2E,$00,$00,$E0,$C0,$A0,$C0,$B0
           .byte  $00,$00
LB376:     .byte  $08,$03,$3C,$8E,$AC,$A9,$2D,$EF
           .byte  $C3,$0F,$A0,$B0,$B8,$F8,$B8,$B0
           .byte  $80,$A0
LB388:     .byte  $08,$03,$0F,$2B,$E3,$E1,$E1,$E3
           .byte  $2B,$0F,$C0,$A0,$2C,$2C,$2C,$2C
           .byte  $A0,$C0
LB39A:     .byte  $08,$03,$02,$02,$0F,$0F,$12,$1E
           .byte  $1E,$12,$00,$00,$C0,$C0,$10,$D0
           .byte  $D0,$10
LB3AC:     .byte  $08,$03,$00,$00,$0F,$0F,$12,$1E
           .byte  $1E,$12,$00,$00,$C0,$C0,$10,$D0
           .byte  $D0,$10
LB3BE:     .byte  $04,$01,$80,$80,$80,$00
LB3C4:     .byte  $03,$01,$00,$00,$00
LB3C9:     .byte  $02,$01,$C0,$C0
LB3CD:     .byte  $08,$01,$00,$00,$18,$5A,$66,$5A
           .byte  $66,$00
LB3D7:     .byte  $08,$01,$00,$00,$00,$00,$00,$00
           .byte  $00,$00
LB3E1:     .byte  $08,$01,$00,$7E,$7E,$7E,$7E,$60
           .byte  $60,$60
LB3EB:     .byte  $08,$01,$00,$00,$7C,$7C,$7C,$40
           .byte  $40,$40
LB3F5:     .byte  $08,$01,$66,$66,$66,$3C,$18,$18
           .byte  $18,$00
LB3FF:     .byte  $08,$01,$7C,$66,$66,$7C,$66,$66
           .byte  $7C,$00
LB409:     .byte  $08,$01,$3C,$66,$60,$7C,$60,$60
           .byte  $60,$00
LB413:     .byte  $08,$01,$66,$66,$3C,$18,$3C,$66
           .byte  $66,$00
LB41D:     .byte  $08,$01,$66,$66,$66,$66,$66,$66
           .byte  $3C,$00
LB427:     .byte  $08,$01,$66,$66,$66,$7E,$66,$66
           .byte  $66,$00
LB431:     .byte  $08,$01,$3C,$66,$60,$60,$60,$66
           .byte  $3C,$00
LB43B:     .byte  $08,$01,$7E,$18,$18,$18,$18,$18
           .byte  $7E,$00
LB445:     .byte  $08,$01,$7C,$66,$66,$66,$66,$66
           .byte  $7C,$00
LB44F:     .byte  $08,$01,$7E,$18,$18,$18,$18,$18
           .byte  $18,$00
LB459:     .byte  $08,$01,$3C,$42,$9D,$A1,$A1,$9D
           .byte  $42,$3C
LB463:     .byte  $08,$01,$3C,$66,$60,$3C,$06,$66
           .byte  $3C,$00
LB46D:     .byte  $08,$01,$00,$00,$10,$10,$7C,$10
           .byte  $10,$00
LB477:     .byte  $08,$01,$00,$00,$00,$7E,$7E,$00
           .byte  $00,$00
LB481:     .byte  $08,$01,$60,$60,$60,$60,$60,$60
           .byte  $7E,$00
LB48B:     .byte  $08,$01,$7C,$66,$66,$7C,$60,$60
           .byte  $60,$00
LB495:     .byte  $08,$01,$66,$66,$76,$6E,$66,$66
           .byte  $66,$00
LB49F:     .byte  $08,$01,$7C,$66,$66,$7C,$78,$6C
           .byte  $66,$00
LB4A9:     .byte  $08,$01,$66,$6C,$78,$70,$78,$6C
           .byte  $66,$00
LB4B3:     .byte  $08,$01,$66,$66,$66,$66,$66,$3C
           .byte  $18,$00
LB4BD:     .byte  $08,$01,$3C,$66,$66,$66,$66,$66
           .byte  $3C,$00
LB4C7:     .byte  $08,$01,$3C,$66,$60,$7C,$60,$66
           .byte  $3C,$00
LB4D1:     .byte  $08,$01,$3E,$0C,$0C,$0C,$0C,$6C
           .byte  $38,$00
LB4DB:     .byte  $08,$01,$66,$7E,$66,$66,$66,$66
           .byte  $66,$00
LB4E5:     .byte  $08,$01,$3C,$66,$66,$7E,$66,$66
           .byte  $66,$00
LB4EF:     .byte  $08,$01,$3C,$66,$60,$6E,$66,$66
           .byte  $3C,$00
LB4F9:     .byte  $08,$01,$3C,$66,$6E,$7E,$76,$66
           .byte  $3C,$00
LB503:     .byte  $08,$01,$18,$38,$78,$18,$18,$18
           .byte  $7E,$00
LB50D:     .byte  $08,$01,$3C,$66,$06,$0C,$18,$30
           .byte  $7E,$00
LB517:     .byte  $08,$01,$3C,$66,$06,$1C,$06,$66
           .byte  $3C,$00
LB521:     .byte  $08,$01,$0E,$1E,$36,$66,$7E,$06
           .byte  $06,$00
LB52B:     .byte  $08,$01,$7E,$60,$60,$7C,$06,$66
           .byte  $3C,$00
LB535:     .byte  $08,$01,$1C,$30,$60,$7C,$66
LB53C:     .byte  $66,$3C,$00
LB53F:     .byte  $08,$01,$7E,$66,$0C,$18,$18,$18
           .byte  $18,$00
LB549:     .byte  $08,$01,$3C,$66,$66,$3C,$66,$66
           .byte  $3C,$00
LB553:     .byte  $08,$01,$3C,$66,$66,$3E,$06,$0C
           .byte  $18,$00,$EA,$00,$EA,$EA,$EA,$EA
           .byte  $EA,$EA,$EA,$EA,$EA,$FF,$FF,$FF
           .byte  $FF,$FF,$FF,$FF,$FF,$B0,$99,$6E
           .byte  $00
LB574:     rts

           ldx    #$00
           jsr    LADFF
           clc
           adc    #$1C
           tay
           ldx    #$08
           lda    $C9,y
           beq    LB53C
           lda    $8C,x
           bne    LB53C
           lda    #$01
           sta    $9A
           stx    $95
           sty    $96
           jsr    LA563
           lda    $96
           sec
           sbc    #$1C
           tax
           ldy    #$07
           sty    $95
           asl    a
           asl    a
           ora    #$03
           sta    $00
           lda    #$02
           sta    $01
LB5A8:     ldx    $00
           ldy    LAFCA,x
           beq    LB574
           lda    $C9,y
           beq    LB5CB
           lda    $6E,y
           bne    LB5CB
           ldx    $95
           lda    $8C,x
           bne    LB5CB
           jsr    LA563
           lda    $9A
           asl    a
           sta    $9A
           dec    $95
           dec    $01
LB5CB:     lda    $01
           beq    LB574
           dec    $00
           bpl    LB5A8
           lda    $9B
           beq    LB574
           dec    $9B
           bne    LB574
           ldx    #$28
           stx    $0D
           ldy    #$A8
           sty    $0E
LB5E3:     lda    #$16
           jsr    LAEC6
           lda    $0D
           sec
           sbc    #$04
           cmp    #$18
           beq    LB574
           sta    $0D
           bpl    LB5E3
           lda    $9C
           bne    LB650
           dec    $26
           bpl    LB64F
           lda    #$05
           sta    $26
           jsr    LAE22
           lda    $25
           ldx    $0A
           beq    LB615
           ldx    $08
           bne    LB61E
           sec
           sbc    #$01
           bpl    LB61C
           bmi    LB61E
LB615:     clc
           adc    #$01
           cmp    #$52
           beq    LB61E
LB61C:     sta    $25
LB61E:     lda    $2B
           bne    LB63F
           lda    $0C
           beq    LB62C
           lda    #$00
           sta    $6D
           beq    LB63F
LB62C:     lda    $6D
           bne    LB63F
           inc    $6D
           lda    $25
           clc
           adc    #$03
           sta    $29
           sta    $2B
           lda    #$98
           sta    $2A
LB63F:     ldy    #$98
           ldx    $25
           lda    $2B
           beq    LB64A
           lda    #$11
           .byte  $2C
LB64A:     lda    #$10
           jmp    LAEC2

LB64F:     rts

LB650:     dec    $9D
           bpl    LB64F
           lda    #$0F
           sta    $9D
           ldx    #$07
           jsr    LADFF
           sta    VIC+$D
           jsr    LADFF
           sta    VIC+$A
           dec    VIC+$E
           ldx    $9C
           lda    LAFAE,x
           ldx    $25
           ldy    #$98
           jsr    LAEC2
           dec    $9C
           bne    LB64F
           jmp    LAA11

           jsr    LA68B
           jsr    LA68B
           jsr    LA68B
           jsr    LA68B
           jmp    LA3BD

           lda    $2B
           beq    LB64F
           dec    $28
           bpl    LB64F
           lda    #$01
           sta    $28
           lda    $2A
           lsr    a
           clc
           adc    #$AF
           sta    VIC+$B
           lda    $29
           sta    $0D
           lda    $2A
           sta    $0E
           sec
           sbc    #$01
           cmp    #$0F
           beq    LB6B8
           sta    $2A
           sta    $0E
           lda    #$12
           jmp    LAEC6

LB6B8:     jsr    LAEB6
           sta    $2B
           ldx    $29
           ldy    $2A
           beq    LB64F
           lda    #$13
           jmp    LAEC2

           ldx    $E7
           ldy    $6C,x
           ldx    LB077,y
           dex
           jsr    LADFF
           bne    LB6E3
           ldx    $E7
           ldy    $6C,x
           ldx    LB080,y
LB6DC:     lda    $47,x
           beq    LB6E4
           dex
           bpl    LB6DC
LB6E3:     rts

LB6E4:     stx    $2E
           ldy    $96
           lda    $C9,y
           beq    LB6E3
           cmp    #$7C
           bcs    LB6E3
           clc
           adc    #$0C
           sta    $3B,x
           sta    $0E
           lda    $AB,y
           clc
           adc    #$03
           cmp    #$54
           bcs    LB6E3
           sta    $2F,x
           sta    $0D
           ldx    $96
           ldy    #$01
           lda    $AB,x
           cmp    $25
           bcc    LB717
           tya
           eor    #$FF
           clc
           adc    #$01
           tay
LB717:     ldx    $2E
           sty    $47,x
           lda    #$14
           jmp    LAEC6

           dec    $A8
           bpl    LB6E3
           lda    #$01
           sta    $A8
           ldx    $E7
           ldy    $6C,x
           ldx    LB080,y
LB72F:     stx    $2E
           lda    $47,x
           beq    LB77C
           lda    $3B,x
           sta    $0E
           lda    $2F,x
           sta    $0D
           lda    #$13
           jsr    LAEC6
           ldx    $2E
           lda    $2F,x
           bmi    LB78F
           cmp    #$54
           bcs    LB78F
           sta    $0D
           lda    $3B,x
           clc
           adc    #$05
           cmp    #$9C
           bcs    LB78F
           sta    $3B,x
           sta    $0E
           lsr    a
           sta    $00
           lda    #$C8
           sec
           sbc    $00
           sta    VIC+$C
           lda    #$14
           jsr    LAEC6
           ldx    $2E
           lda    $3B,x
           cmp    #$93
           bcc    LB77C
           lda    $2F,x
           sec
           sbc    $25
           cmp    #$05
           bcc    LB782
LB77C:     ldx    $2E
           dex
           bpl    LB72F
           rts

LB782:     lda    #$13
           jsr    LAEC6
           lda    $9C
           bne    LB78F
           lda    #$06
           sta    $9C
LB78F:     ldx    $2E
           jsr    LAEBC
           sta    $47,x
           beq    LB77C
           lda    #$10
           jmp    LAE95

           jsr    LAB59
           jsr    LAE68
           jsr    LAEA1
           sta    $0102
           jsr    LA9CC
           ldx    #$08
           ldy    #$08
           jsr    LADCD
           .byte  $31,$22,$31,$2A,$20,$24,$2D,$1B
           .byte  $22,$16,$28,$2A,$2E,$24,$2E,$29
           .byte  $22,$24,$00
           ldx    #$1C
           ldy    #$18
           jsr    LADCD
           .byte  $32,$31,$27,$31,$1C,$20,$31,$29
           .byte  $00
           ldx    #$18
           ldy    #$30
           jsr    LADCD
           .byte  $28,$2A,$2E,$24,$24,$16,$1B,$34
           .byte  $00
           ldx    #$14
           ldy    #$38
           jsr    LADCD
           .byte  $1B,$2D,$2A,$16,$2D,$28,$22,$20
           .byte  $2D,$29,$24,$00
           ldx    #$04
           ldy    #$08
           lda    #$0F
           jsr    LAE4F
           ldx    #$1D
           stx    $20
LB806:     lda    LB02C,x
           clc
           adc    #$3C
           sta    $C9,x
           lda    LB00E,x
           sta    $AB,x
           dex
           bpl    LB806
           lda    #$15
           sta    $1F
           lda    #$01
           sta    $1E
LB81E:     jsr    LA185
           lda    $20
           cmp    #$1D
           bne    LB81E
           ldx    #$14
           ldy    #$A0
           jsr    LADCD
           .byte  $23,$34,$3C,$3B,$36,$16,$31,$22
           .byte  $31,$2A,$20,$00
           ldx    #$04
           ldy    #$A8
           jsr    LADCD
           .byte  $31,$27,$27,$16,$2A,$20,$32,$1E
           .byte  $22,$24,$16,$2A,$2E,$24,$2E,$2A
           .byte  $2C,$2E,$21,$16,$16,$00
           lda    #$01
           sta    $0102
LB85C:     jsr    LAB70
           jsr    LA9E5
           bne    LB871
           jsr    LAE22
           lda    $0C
           bne    LB85C
           jsr    LAB59
           jmp    LA990

LB871:     jsr    LAEA1
           jsr    LAB59
           jsr    LAA08
           jsr    LAE68
           jsr    LA9CC
           lda    #$00
           sta    $0102
           jsr    LAD4F
           ldx    #$10
           ldy    #$28
           jsr    LADCD
           .byte  $1B,$34,$26,$24,$22,$31,$2A,$22
           .byte  $16,$32,$31,$30,$2E,$00
           ldx    #$10
           ldy    #$38
           jsr    LADCD
           .byte  $1B,$36,$26,$16,$16,$28,$27,$31
           .byte  $19,$2E,$2A,$00
           lda    $0105
           sta    $E7
           clc
           adc    #$34
           ldx    #$1C
           ldy    #$38
           jsr    LAEC2
           ldx    #$10
           ldy    #$48
           jsr    LADCD
           .byte  $1B,$38,$26,$27,$2E,$2C,$2E,$27
           .byte  $00
           lda    $0104
           sta    $EA
           sta    $EB
           clc
           adc    #$34
           ldx    #$34
           ldy    #$48
           jsr    LAEC2
           ldx    #$10
           ldy    #$70
           jsr    LADCD
           .byte  $06,$16,$16,$16,$16,$16,$04,$16
           .byte  $16,$16,$02,$16,$16,$16,$01,$00
           ldx    #$10
           ldy    #$80
           jsr    LADCD
           .byte  $39,$33,$16,$16,$16,$16,$38,$33
           .byte  $16,$16,$37,$33,$16,$16,$36,$33
           .byte  $00
           ldx    #$04
           ldy    #$90
           jsr    LADCD
           .byte  $34,$38,$33,$26,$3B,$33,$33,$16
           .byte  $34,$33,$33,$16,$16,$3B,$33,$16
           .byte  $16,$39,$33,$00
           lda    #$01
           sta    $0102
LB92F:     jsr    LAB70
           jsr    LAE22
           lda    $0C
           beq    LB990
           jsr    LA9F0
           ldx    $A1
           sta    $A1
           cpx    #$01
           beq    LB963
           cmp    #$00
           beq    LB963
           lda    $EA
           clc
           adc    #$01
           and    #$07
           sta    $EA
           sta    $EB
           sta    $0104
           clc
           adc    #$34
           ldx    #$34
           ldy    #$48
           jsr    LAEC2
           jsr    LAB59
LB963:     jsr    LA9FC
           ldx    $A2
           sta    $A2
           cpx    #$01
           beq    LB988
           cmp    #$00
           beq    LB988
           lda    $E7
           eor    #$01
           sta    $E7
           sta    $0105
           clc
           adc    #$34
           ldx    #$1C
           ldy    #$38
           jsr    LAEC2
           jsr    LAB59
LB988:     jsr    LA9E5
           beq    LB92F
           jsr    LAA08
LB990:     lda    $0104
           sta    $EA
           sta    $EB
           lda    #$02
           sta    $E8
           sta    $E9
           ldx    $0105
           lda    LAB8D,x
           sta    $E9
           lda    #$00
           sta    $E7
           jsr    LAB59
           jsr    LAEA1
           ldx    #$FF
           txs
           jmp    LA0E3

           ldy    #$05
LB9B7:     lda    #$F0
           jsr    LAE95
           dey
           lda    LA9C6,y
           sta    VIC+$C
           bne    LB9B7
           rts

           .byte  $00,$E3,$DB,$D6,$D2,$C9
           ldx    #$06
LB9CE:     stx    $21
           lda    LAB9B,x
           pha
           ldy    LAB95,x
           lda    LAB8F,x
           tax
           pla
           jsr    LAE4F
           ldx    $21
           dex
           bpl    LB9CE
           rts

           lda    #$EF
           jsr    LACEB
           and    #$80
           bne    LBA05
           beq    LB9F9
           lda    #$BF
           jsr    LACEB
           and    #$80
           bne    LBA05
LB9F9:     lda    #$01
           rts

           lda    #$DF
           jsr    LACEB
           and    #$80
           beq    LB9F9
LBA05:     lda    #$00
           rts

LBA08:     jsr    LAE93
           jsr    LA9E5
           bne    LBA08
           rts

           jsr    LAEA1
           lda    #$2F
           sta    VIC+$E
           ldx    $E7
           dec    $E8,x
           bmi    LBA44
           jsr    LAB33
           jsr    LABD1
           ldx    #$0A
LBA27:     jsr    LAE93
           jsr    LAE93
           txa
           pha
           and    #$01
           beq    LBA39
           jsr    LABB2
           jmp    LAA3C

LBA39:     jsr    LABA1
           pla
           tax
           dex
           bpl    LBA27
           jmp    LA120

LBA44:     jsr    LABD1
           ldx    $E7
           lda    #$FF
           sta    $E8,x
           ldy    #$08
           sty    $0E
           ldx    #$18
           stx    $0D
           jsr    LADCD
           .byte  $32,$31,$30,$2E,$16,$16,$2D,$2C
           .byte  $2E,$2A,$00,$20,$A1,$AE,$A9,$32
           .byte  $85,$00
           jsr    LAB33
           ldx    #$0A
LBA6F:     jsr    LAE93
           dex
           bne    LBA6F
           ldx    #$18
           stx    $0D
           ldy    #$08
           sty    $0E
           jsr    LADCD
           .byte  $16,$16,$16,$16,$16,$16,$16,$16
           .byte  $16,$16,$00
           jmp    LAA22

           ldy    #$02
           lda    #$00
LBA92:     ora    $EE,y
           ora    $F0,y
           ora    $F4,y
           dey
           bpl    LBA92
           bit    $E8
           bne    LBAA5
           jsr    LB066
LBAA5:     ldy    #$01
           sty    $0C
           inc    $0C
           lda    $0C
           cmp    #$14
           beq    LBAD4
           asl    a
           asl    a
           asl    a
           tay
           ldx    #$00
           jsr    LADCD
           .byte  $16,$16,$16,$16,$16,$16,$16,$16
           .byte  $16,$16,$16,$16,$16,$16,$16,$16
           .byte  $16,$16,$16,$16,$16,$16,$00
           jmp    LAAA9

LBAD4:     ldx    #$02
           ldy    #$04
           lda    #$07
           jsr    LAE4F
           jsr    LAB59
           ldx    #$10
           ldy    #$28
           jsr    LADCD
           .byte  $1B,$34,$26,$24,$22,$31,$2A,$22
           .byte  $16,$32,$31,$30,$2E,$00
           ldx    #$10
           ldy    #$40
           jsr    LADCD
           .byte  $1B,$38,$26,$2D,$28,$22,$20,$2D
           .byte  $29,$24,$00
LBB07:     jsr    LAB70
           jsr    LAE22
           lda    $0C
           beq    LBB21
           jsr    LA9E5
           bne    LBB21
           jsr    LA9F0
           beq    LBB07
           jsr    LAB59
           jmp    LA871

LBB21:     jsr    LAB59
           jsr    LA990
           ldx    #$FF
           txs
           jmp    LA0E3

           ldx    #$FF
           txs
           jmp    LA044

           lda    $E7
           eor    #$01
           tax
           lda    $E8,x
           bmi    LBB50
           stx    $E7
           ldx    #$1D
LBB40:     lda    $C9,x
           tay
           lda    $1FE1,x
           sta    $C9,x
           tya
           sta    $1FE1,x
           dex
           bpl    LBB40
           rts

LBB50:     ldx    $E7
           lda    $E8,x
           bpl    LBB8C
           jmp    LAA8E

           lda    #$0E
           sta    VIC+$F
           lda    #$2F
           sta    VIC+$E
           lda    #$00
           sta    $A9
           sta    $9E
           sta    $9F
           lda    #$24
           sta    $A0
           rts

           inc    $9E
           bne    LBB8C
           inc    $9F
           bne    LBB8C
           lda    $A9
           bne    LBB80
           dec    $A0
           bne    LBB8C
LBB80:     ldx    #$07
           stx    $A9
           jsr    LADFF
           ora    #$08
           sta    VIC+$F
LBB8C:     rts

           .byte  $FF,$02,$00,$01,$02,$07,$08,$0A
           .byte  $00,$01,$06,$07,$09,$0A,$07,$06
           .byte  $07,$0F,$03,$07,$A2,$38,$A0,$A8
           .byte  $20,$CD,$AD,$16,$16,$16,$16,$16
           .byte  $16,$16,$16,$00,$60,$A2,$38,$A0
           .byte  $A8,$20,$CD,$AD,$28,$27,$31,$19
           .byte  $2E,$2A,$00,$A2,$54,$A0,$A8,$A5
           .byte  $E7,$18,$69,$34,$20,$C2,$AE,$60
           .byte  $A6,$E7,$F6,$E8,$20,$B2,$AB,$A2
           .byte  $00,$A0,$A8,$20,$CD,$AD,$16,$16
           .byte  $16,$16,$16,$16,$16,$16,$16,$16
           .byte  $16,$16,$16,$16,$00
        
           ldy    #$A8
           sty    $0E
           ldx    #$00
           stx    $0D
           ldy    $E7
           ldx    $E8,y
           stx    $A3
           bmi    LBC28
           beq    LBC12
           dec    $A3
           cpx    #$0D
           bcc    LBC06
           ldx    #$0C
           stx    $A3
LBC06:     lda    #$15
           jsr    LAEC6
           lda    $0D
           clc
           adc    #$04
           sta    $0D
LBC12:     lda    #$16
           jsr    LAEC6
           dec    $A3
           bpl    LBC06
           ldx    $E7
           lda    $E8,x
           cmp    #$0D
           bcc    LBC28
           lda    #$25
           jmp    LAEC6
LBC28:     rts

           jsr    LAEA1
           ldx    $E7
           lda    $6C
           cmp    #$08
           beq    LBC36
           inc    $6C,x
LBC36:     sed
           lda    $EA,x
           clc
           adc    #$01
           sta    $EA,x
           cld
           jsr    LAC48
           ldx    #$FF
           txs
           jmp    LA0F8

           lda    #$A0
           sta    $0E
           lda    #$58
LBC4E:     sta    $0D
           lda    #$16
           jsr    LAEC6
           lda    $0D
           sec
           sbc    #$04
           bpl    LBC4E
           ldx    #$54
           stx    $0D
           ldx    $E7
           lda    $EA,x
           sed
           clc
           adc    #$01
           cld
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           beq    LBC81
           sta    $21
LBC71:     lda    #$17
           jsr    LAEC6
           lda    $0D
           sec
           sbc    #$04
           sta    $0D
           dec    $21
           bne    LBC71
LBC81:     ldx    $E7
           lda    $EA,x
           sed
           clc
           adc    #$01
           cld
           and    #$0F
           beq    LBCA0
           sta    $21
LBC90:     lda    #$18
           jsr    LAEC6
           lda    $0D
           sec
           sbc    #$04
           sta    $0D
           dec    $21
           bne    LBC90
LBCA0:     rts

           jsr    LA9F0
           beq    LBCA9
           jmp    LA871

LBCA9:     jsr    LA9E5
           beq    LBCB7
           jsr    LA990
           ldx    #$FF
           txs
           jmp    LA0E3

LBCB7:     jsr    LACDE         ; SPACE pressed?
           bcc    LBCF6
           lda    #$20
           sta    VIC+$E
           jsr    LAE93
           jsr    LACD8
LBCC7:     jsr    LAB70
           jsr    LACDE         ; SPACE pressed?
           bcc    LBCC7
           jsr    LACD8
           jsr    LAE93
           jmp    LAB59

LBCD8:     jsr    LACDE         ; SPACE pressed?
           bcs    LBCD8
           rts

        ;; returns with carry set iff SPACE key is pressed
           lda    #$EF
           jsr    LACEB
           and    #$01
           bne    LBCE9
           sec
           rts
LBCE9:     clc
           rts

           sta    JOY_REG_RIGHT
LBCEE:     lda    VIA2+$1
           cmp    VIA2+$1
           bne    LBCEE
LBCF6:     rts

           pha
           stx    $00
           lda    $E7
           asl    a
           clc
           adc    $E7
           tax
           pla
           sed
           clc
           adc    $EE,x
           sta    $EE,x
           lda    $00
           adc    $EF,x
           sta    $EF,x
           lda    #$00
           adc    $F0,x
           sta    $F0,x
           cld
           stx    $0C
           ldy    $E7
           lda    $EF,x
           cmp    #$70
           bcc    LBD2D
           lda    $EC,y
           bne    LBD2B
           ldx    $E7
           inc    $EC,x
           jsr    LABCD
LBD2B:     ldx    $0C
LBD2D:     inx
           inx
           stx    $00
           ldy    #$02
LBD33:     lda    $EE,x
           cmp    $F4,y
           bcc    LBD4F
           beq    LBD3E
           bcs    LBD42
LBD3E:     dex
           dey
           bpl    LBD33
LBD42:     ldx    $00
           ldy    #$02
LBD46:     lda    $EE,x
           sta    $F4,y
           dex
           dey
           bpl    LBD46
LBD4F:     ldx    #$20
           ldy    #$00
           lda    #$F4
           sta    $22
           lda    #$00
           sta    $23
           lda    #$02
           jsr    LAD80
           lda    #$EE
           sta    $22
           lda    #$00
           sta    $23
           ldx    #$00
           ldy    #$00
           lda    #$02
           jsr    LAD80
           lda    $0105
           beq    LBDCC
           lda    #$F1
           sta    $22
           ldx    #$40
           ldy    #$00
           lda    #$02
           stx    $0D
           sty    $0E
           sta    $24
           ldx    #$00
           stx    $AA
LBD8A:     ldy    $24
           lda    ($22),y
           pha
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           clc
           adc    #$33
           cmp    #$33
           bne    LBD9E
           ldx    $AA
           beq    LBDA5
LBD9E:     ldx    #$01
           stx    $AA
           jsr    LAEC6
LBDA5:     lda    $0D
           clc
           adc    #$04
           sta    $0D
           pla
           and    #$0F
           clc
           adc    #$33
           cmp    #$33
           bne    LBDBA
           ldx    $AA
           beq    LBDC1
LBDBA:     ldx    #$01
           stx    $AA
           jsr    LAEC6
LBDC1:     lda    $0D
           clc
           adc    #$04
           sta    $0D
           dec    $24
           bpl    LBD8A
LBDCC:     rts

           stx    $0D
           sty    $0E
           pla
           sta    $2C
           pla
           sta    $2D
           bne    LBDE9
LBDD9:     ldy    #$00
           lda    ($2C),y
           beq    LBDF1
           jsr    LAEC6
           lda    $0D
           clc
           adc    #$04
           sta    $0D
LBDE9:     inc    $2C
           bne    LBDD9
           inc    $2D
           bne    LBDD9
LBDF1:     lda    $2D
           pha
           lda    $2C
           pha
           rts

LBDF8:     lda    $0C
           and    #$10
           bne    LBDF8
           rts

           lda    VIC+$4
           adc    $0101
           inc    $0103
           inc    $0100
           ldy    $0103
        ;; The following instruction may be a bug. The ($FF) addressing
        ;; takes the address low byte from $FF and high byte from $00
        ;; $00 seems to be generally used as temporary storage and $FF is
        ;; never really initialized. Also Y does not appear to get initialized
        ;; before this subroutine is called. Maybe this was supposed to be "adc #$FF"?
        ;; Removing it completely appears to make no difference for the game.
           adc    ($FF),y
           adc    VIC+$4
           sta    $0101
           and    LAE1A,x
           rts

           .byte  $01,$03,$07,$0F,$1F,$3F,$7F,$FF
           ldy    #$03
LBE24:     lda    #$FF
           cpy    #$02
           beq    LBE33
           sta    VIA2+$2
           lda    JOY_REG_OTHER
           jmp    LAE3A

LBE33:     lsr    a
           sta    VIA2+$2
           lda    JOY_REG_RIGHT
           and    LAE4B,y
           sta    $08,y
           dey
           bpl    LBE24
           lda    VIA1+1
           and    #$20
           sta    $0C
           rts

           .byte  $10,$04,$80,$08,$86,$06
LBE51:     sty    $07
           pha
           jsr    LAE8A
           ldy    #$15
           pla
LBE5A:     sta    ($04),y
           dey
           bpl    LBE5A
           ldy    $07
           cpy    $06
           beq    LBE89
           dey
           bpl    LBE51
           lda    #>CHARSET
           sta    $03
           lda    #<CHARSET
           sta    $02
           tay
           ldx    #$0F
LBE73:     sta    ($02),y
           sta    CHARSET+$E20,y
           iny
           bne    LBE73
           inc    $03
           dex
           bne    LBE73
           rts

           lda    ($F7),y
           sta    $02
           lda    ($F9),y
           sta    $03
LBE89:     rts

           lda    ($FB),y
           sta    $04
           lda    ($FD),y
           sta    $05
           rts

           lda    #$FF
           sec
LBE96:     pha
LBE97:     sbc    #$01
           bne    LBE97
           pla
           sbc    #$01
           bne    LBE96
           rts

           jsr    LAEB0
           jsr    LAEB6
           jsr    LAEBC
           lda    #$00
           sta    VIC+$D
           rts

           lda    #$00
           sta    VIC+$A
           rts

           lda    #$00
           sta    VIC+$B
           rts

           lda    #$00
           sta    VIC+$C
           rts

           stx    $0D
           sty    $0E
           ldx    $0D
           sta    $18
           txa
           and    #$03
           sta    $19
           txa
           lsr    a
           lsr    a
           sta    $14
           lda    $18
           asl    a
           tay
           lda    LB1E4,y
           sta    $1A
           iny
           lda    LB1E4,y
           sta    $1B
           ldy    #$00
           lda    ($1A),y
           sta    $11
           iny
           lda    ($1A),y
           sta    $12
           lda    $1A
           clc
           adc    #$02
           sta    $15
           lda    $1B
           adc    #$00
           sta    $16
           lda    #$00
           sta    $1C
           lda    $12
           sta    $17
LBF03:     lda    $0E
           sta    $1D
           ldy    $14
           cpy    #$16
           bcs    LBF57
           jsr    LAE81
           lda    $17
           cmp    $12
           beq    LBF58
           cmp    #$01
           beq    LBF5C
           ldx    #$04
LBF1C:     ldy    $11
           sty    $13
LBF20:     lda    #$00
           ldy    $1C
           jsr    LAF6D
           ldy    $1D
           pha
           lda    $0102
           beq    LBF37
           bpl    LBF3D
           pla
           and    ($02),y
           jmp    LAF47

LBF37:     pla
           ora    ($02),y
           jmp    LAF47

LBF3D:     lda    ($02),y
           and    LAF64,x
           sta    $00
           pla
           ora    $00
           sta    ($02),y
           inc    $1C
           inc    $1D
           dec    $13
           bne    LBF20
           inc    $14
           dec    $17
           bne    LBF03
LBF57:     rts

LBF58:     ldx    $19
           bpl    LBF1C
LBF5C:     lda    #$05
           clc
           adc    $19
           tax
           bne    LBF1C
           brk

           .byte  $C0,$F0,$FC,$00,$FF,$3F,$0F,$03
           .byte  $85,$0F,$86,$10,$E0,$04,$90,$1B
           .byte  $F0,$21,$98,$38,$E5,$11,$A8,$B1
           .byte  $15,$A8,$A5,$19,$18,$69,$FC,$AA
           .byte  $98,$0A,$0A,$E8,$D0,$FB,$05,$0F
           .byte  $A6,$10,$60,$B1,$15,$20,$A4,$AF
           .byte  $4C,$8B,$AF,$B1,$15,$20,$A4,$AF
           .byte  $05,$0F,$85,$0F,$4C,$77,$AF,$A6
           .byte  $19,$F0,$05,$4A,$4A,$CA,$D0,$FB
           .byte  $60,$00,$0A,$0C,$0F,$0E,$0D,$0E
           .byte  $0D,$0C,$0D,$0C,$0B,$00,$00,$00
           .byte  $01,$01,$02,$02,$07,$00,$00,$90
           .byte  $40,$40,$40,$40,$40,$00,$1A,$19
           .byte  $1B,$00,$17,$18,$16,$00,$00,$00
           .byte  $00,$00,$00,$20,$20,$31,$39,$38
           .byte  $34,$20,$20,$44,$45,$53,$49,$47
           .byte  $4E,$45,$52,$53,$4F,$46,$54,$57
           .byte  $41,$52,$45,$42,$49,$4C,$4C,$20
           .byte  $42,$4F,$47,$45,$4E,$52,$45,$49
           .byte  $46,$20,$36
