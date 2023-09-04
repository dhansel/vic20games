;;; Atarisoft Donkey Kong for VIC-20
        
VIC               := $9000      ; $9000-$900F
VIA1              := $9110      ; $9110-$911F
VIA2              := $9120      ; $9120-$912F
COLORRAM          := $9400      ; $9400-$9507 (22x12)
CHARSET           := $1000      ; $1000-$1FFF
SCREEN            := $0200      ; $0200-$0307 (22x12)
CHARROM           := $8000      ; $8000-$8FFF
JOY_REG_RIGHT     := VIA2+$0
JOY_REG_OTHER     := VIA1+$F
JOY_MASK_UP       := $04
JOY_MASK_DOWN     := $08
JOY_MASK_LEFT     := $10
JOY_MASK_RIGHT    := $80
JOY_MASK_BUTTON   := $20
IRQVEC            := $0314
NMIVEC            := $0318

           .setcpu "6502"

           .segment "CRT1"
        
        ;; $EB is current game screen:
        ;;   $00 = intro screen
        ;;   $01 = options screen
        ;;   $02 = pre-game/in-game options (F1/F5)
        ;;   $03 = game running
        ;;   $04 = game paused (SPACE)
        ;;   $05 = post-game screen

L2000:     lda    $EB           ; get game mode
           cmp    #$03          ; is game running?
           beq    L202D         ; skip if so
           cmp    #$04          ; is game paused?
           beq    L202D         ; skip if so
           jsr    LAB20
           lda    $B2
           and    #$20          ; button pressed?
           beq    L202D         ; skip if not
           lda    $EB           ; intro screen?
           bne    L202A         ; skip if not
           lda    #$5D
           eor    $0127         ; "2", "C=" and "<-" (left arrow) keys pressed?
           bne    L202A         ; skip if not
           lda    #<LB600
           sta    $7C
           lda    #>LB600
           sta    $7D
           jsr    LA7EC         ; display "blip" (easter egg)
           rts
L202A:     jmp    LA0F6

L202D:     rts

L202E:     ldx    #$00
           lda    #$09
           sta    $99
           lda    $B4
           cmp    #$09
           bcs    L204F
           lda    $99
           sec
           sbc    $B4
           sta    $99
L2041:     lda    #$00
           sta    COLORRAM+$257,x
           txa
           clc
           adc    #$16
           tax
           dec    $99
           bne    L2041
L204F:     lda    $B4
           beq    L2069
           cmp    #$09
           bcc    L2059
           lda    #$09
L2059:     sta    $99
L205B:     lda    #$0A
           sta    COLORRAM+$257,x
           txa
           clc
           adc    #$16
           tax
           dec    $99
           bne    L205B
L2069:     rts

L206A:     lda    VIA1+$B
           and    #$03
           ora    #$40
           sta    VIA1+$B
           lda    #$00
           sta    VIA1+$4
           lda    #$B0
           sta    VIA1+$5
           lda    #$01
           sta    VIA1+$6
           lda    VIA2+$B
           and    #$03
           ora    #$40
           sta    VIA2+$B
           lda    #$64
           sta    VIA2+$4
           lda    #$00
           sta    VIA2+$5
           lda    #$64
           sta    VIA2+$6
           rts

L209D:     lda    #$40
L209F:     bit    VIA1+$D
           beq    L209F
           sta    VIA1+$D
L20A7:     bit    VIA1+$D
           beq    L20A7
           sta    VIA1+$D
           lda    $EB
           cmp    #$03
           beq    L20C1
           cmp    #$04
           beq    L20C1
           dec    $0118
           bne    L20C1
           jmp    LA04D

L20C1:     lda    $EB
           cmp    #$04
           bne    L20E8
           pha
           lda    $0116
           bne    L20D0
           dec    $0117
L20D0:     dec    $0116
           pla
           lda    $0116
           bne    L20E8
           lda    $0117
           bne    L20E8
           lda    #$8C
           sta    VIC+$1
           lda    #$08
           sta    VIC+$F
L20E8:     lda    $EB
           cmp    #$03
           bne    L2106
           lda    $EA
           beq    L2106
           dec    $EA
           bne    L2106
           lda    $EE
           sta    $9B
           lda    $EF
           sta    $9C
           ldx    $0121
           lda    #$20
           jsr    LB352
L2106:     rts

L2107:     lda    #$0A
L2109:     pha
           jsr    L209D
           jsr    LA3D5
           lda    #$80
           sta    $9B
           lda    #$60
           sta    $9C
           jsr    L2000
           pla
           sec
           sbc    #$01
           bne    L2109
           rts

L2122:     ldx    $C3
           dex
           ldy    L2144,x
           lda    #$0A
           sta    $99
           ldx    #$00
L212E:     lda    #$00
           dec    $99
           bne    L213C
           lda    #$0A
           sta    $99
           lda    L2148,y
           iny
L213C:     sta    $00,x
           inx
           cpx    #$78
           bne    L212E
           rts

L2144:     .byte  $00,$00,$0C,$18
L2148:     .byte  $00,$30,$48,$60,$78,$90,$A8,$C0
           .byte  $FF,$FF,$FF,$FF,$00,$30,$34,$38
           .byte  $3C,$40,$44,$48,$60,$78,$98,$B8
           .byte  $00,$30,$48,$60,$78,$90,$A8,$B2
           .byte  $BC,$C6,$D0,$FF
        
L216C:     lda    $04,x
           asl    a
           tay
           lda    ($AB),y
           sta    $AD
           iny
           lda    ($AB),y
           sta    $AE
           lda    #$00
           sta    $0113
           lda    VIA2+$4
           sta    $0112
           ldy    #$00
L2186:     lda    ($AD),y
           sta    $0126
           and    #$7F
           beq    L21AD
           clc
           adc    $0113
           sta    $0113
           bcs    L21AD
           cmp    $0112
           bcs    L21AD
           tya
           clc
           adc    #$09
           bit    $0126
           bpl    L21A9
           sec
           sbc    #$02
L21A9:     tay
           jmp    L2186

L21AD:     iny
           lda    ($AD),y
           sta    $04,x
           iny
           lda    ($AD),y
           sta    $05,x
           iny
           lda    ($AD),y
           sta    $06,x
           iny
           lda    #$11
           bit    $0126
           bmi    L21C7
           lda    ($AD),y
           iny
L21C7:     sta    COLORRAM+$007,x
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           sta    COLORRAM+$006,x
           lda    #$11
           bit    $0126
           bmi    L21DB
           lda    ($AD),y
           iny
L21DB:     sta    COLORRAM+$003,x
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           sta    COLORRAM+$002,x
           lda    ($AD),y
           sta    COLORRAM+$004,x
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           sta    COLORRAM+$108,x
           iny
           lda    ($AD),y
           sta    COLORRAM+$009,x
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           sta    COLORRAM+$008,x
           iny
           lda    ($AD),y
           beq    L2212
           pha
           and    #$1F
           sta    $01,x
           pla
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           and    #$0E
           sta    COLORRAM+$001,x
L2212:     rts

L2213:     lda    #$08
           and    COLORRAM+$004,x
           beq    L221D
           jmp    L22B9

L221D:     lda    $BB
           beq    L2268
           lda    #$08
           bit    COLORRAM+$000
           beq    L222D
           lda    #$08
           jmp    L222F

L222D:     lda    #$F8
L222F:     clc
           adc    $02
           clc
           adc    #$02
           sec
           sbc    $02,x
           cmp    #$0C
           beq    L223E
           bcs    L2268
L223E:     lda    $03
           clc
           adc    #$05
           sec
           sbc    $03,x
           cmp    #$13
           beq    L224C
           bcs    L2268
L224C:     jsr    LA6CB
           lda    #$27
           sta    $04,x
           lda    #$08
           sta    COLORRAM+$004,x
           lda    #$00
           sta    $05,x
           sta    $06,x
           lda    #>L3EEF
           pha
           lda    #<L3EEF
           pha
           jsr    L3C91
           rts

L2268:     lda    $02
           clc
           adc    #$04
           sec
           sbc    $02,x
           cmp    #$08
           beq    L2276
           bcs    L22B9
L2276:     lda    $03
           clc
           adc    #$06
           sec
           sbc    $03,x
           cmp    #$12
           beq    L2284
           bcs    L22B9
L2284:     lda    #$24
           sta    $04,x
           lda    #$08
           sta    COLORRAM+$004,x
           lda    COLORRAM+$004
           and    #$01
           bne    L22A4
           lda    #$01
           sta    $04
           jsr    L3CE8
           lda    #>L3EBE
           pha
           lda    #<L3EBE
           pha
           jsr    L3C91
L22A4:     lda    COLORRAM+$004
           ora    #$01
           sta    COLORRAM+$004
           lda    #$00
           sta    $05,x
           sta    $06,x
           sta    $05
           sta    $06
           sta    $BB
           rts

L22B9:     lda    COLORRAM+$004
           and    #$01
           bne    L22F2
           lda    COLORRAM+$005,x
           and    #$01
           bne    L22F2
           lda    $02,x
           sec
           sbc    $02
           clc
           adc    #$04
           cmp    #$08
           beq    L22D5
           bcs    L22F2
L22D5:     lda    $03,x
           sec
           sbc    $03
           sec
           sbc    #$04
           cmp    #$0C
           beq    L22E3
           bcs    L22F2
L22E3:     lda    $B1
           beq    L22F2
           inc    $0128
           lda    #$01
           ora    COLORRAM+$005,x
           sta    COLORRAM+$005,x
L22F2:     lda    $B1
           bne    L230E
           lda    COLORRAM+$005,x
           and    #$FE
           sta    COLORRAM+$005,x
           ldy    $0128
           beq    L230E
           lda    L230F-1,y
           jsr    LA6D7
           lda    #$00
           sta    $0128
L230E:     rts

L230F:     .byte  $01,$03,$08,$08,$08
        
L2314:     lda    #$00
           sta    $99
L2318:     ldy    $99
           lda    L23A8,y
           sta    $78
           lda    L23A5,y
           sta    $79
           ldx    $0106,y
           lda    L23AE,x
           sta    $010C
           txa
           eor    #$03
           tax
           lda    L23AE,x
           sta    $010D
           ldx    $0106,y
           lda    $0109,y
           bmi    L2343
           inx
           jmp    L2344

L2343:     dex
L2344:     txa
           and    #$03
           sta    $0106,y
           tax
           lda    $010C
           ora    L23AE,x
           sta    $010C
           txa
           eor    #$03
           tax
           lda    $010D
           ora    L23AE,x
           sta    $010D
           lda    VIA2+$4
           cmp    #$03
           bcs    L2373
           lda    $0109,y
           eor    #$FF
           clc
           adc    #$01
           sta    $0109,y
L2373:     ldx    L23AB,y
           jsr    L2382
           inc    $99
           lda    $99
           cmp    #$03
           bne    L2318
           rts

L2382:     ldy    #$00
           lda    $010C
           eor    ($78),y
           sta    ($78),y
           lda    $010D
           ldy    #$07
           eor    ($78),y
           sta    ($78),y
           lda    $78
           clc
           adc    #$C0
           sta    $78
           lda    $79
           adc    #$00
           sta    $79
           dex
           bne    L2382
           rts

L23A5:     .byte  >CHARSET+$2,>CHARSET+$2,>CHARSET+$A
L23A8:     .byte  $DA,$9A,$1A
L23AB:     .byte  $10,$06,$06
L23AE:     .byte  $40,$10,$04,$01
        
L23B2:     lda    $011B
           beq    L23BB
           dec    $011B
           rts

L23BB:     ldx    $C3
           lda    L2439-1,x
           sta    $011B
           ldx    $011C
           bne    L23DC
           lda    $011A
           eor    #$80
           sta    $011A
           lda    #>L3E55
           pha
           lda    #<L3E55
           pha
           jsr    L3C9D
           jmp    L23EE

L23DC:     lda    L240C-1,x
           sta    $0119
           lda    L2418-1,x
           sta    $011A
           lda    L2412-1,x
           sta    $011C
L23EE:     ldx    $C3
           lda    L241E-1,x
           bit    $011A
           bmi    L23FB
           clc
           adc    #$02
L23FB:     sta    $9B
           lda    L2422-1,x
           sta    $9C
           lda    $011A
           ldx    $0119
           jsr    LB772
           rts

L240C:     .byte  $22,$24,$23,$24,$23,$24
L2412:     .byte  $00,$01,$02,$03,$01,$05
L2418:     .byte  $00,$80,$00,$00,$00,$00
L241E:     .byte  $20,$40,$00,$20
L2422:     .byte  $30,$3A,$30,$3A
        
L2426:     lda    #$00
           sta    $011C
           sta    $011A
           lda    #$03
           sta    $011B
           lda    #$22
           sta    $0119
           rts

L2439:     .byte  $03,$0C,$0C,$0C
        
L243D:     lda    #<(L2CDA-2)
           sta    $AB
           lda    #>(L2CDA-2)
           sta    $AC
           ldx    #$0A
L2447:     lda    $04,x
           beq    L249C
           lda    COLORRAM+$004,x
           and    #$08
           bne    L248E
           lda    COLORRAM+$004,x
           and    #$04
           beq    L248B
           jsr    L257F
           lda    $C3
           cmp    #$02
           bne    L2465
           jsr    L252F
L2465:     lda    #$0A
           sta    $05,x
           sta    $06,x
           lda    $00,x
           eor    #$01
           sta    $01,x
           lda    COLORRAM+$000,x
           sta    COLORRAM+$001,x
           lda    COLORRAM+$108,x
           and    #$04
           bne    L2486
           lda    #$00
           sta    COLORRAM+$001,x
           jmp    L248B

L2486:     lda    #$08
           sta    COLORRAM+$001,x
L248B:     jsr    L2213
L248E:     lda    $05,x
           bne    L2499
           lda    $06,x
           bne    L2499
           jsr    L216C
L2499:     jsr    LB9CF
L249C:     txa
           clc
           adc    #$0A
           tax
           cmp    #$32
           beq    L2447
           bcc    L2447
           rts

L24A8:     dec    $F4
           bne    L24E8
           lda    VIA2+$4
           lsr    a
           lsr    a
           adc    #$14
           sta    $F4
           lda    $010E
           ldy    $02
           cpy    #$50
           rol    a
           tay
           lda    L2525,y
           tay
           jsr    LB87D
           bcs    L24E8
           lda    #$04
           sta    COLORRAM+$004,x
           lda    #$06
           sta    COLORRAM+$108,x
           lda    #$02
           sta    COLORRAM+$008,x
           sta    COLORRAM+$009,x
           inc    $010E
           lda    $010E
           cmp    #$05
           bcc    L24E8
           lda    #$00
           sta    $010E
L24E8:     rts

L24E9:     dec    $F4
           bne    L2524
           lda    VIA2+$4
           lsr    a
           lsr    a
           adc    #$14
           sta    $F4
           lda    #$32
           sta    $F5
           ldy    #$9B
           jsr    LB87D
           bcs    L2524
           lda    #$02
           sta    COLORRAM+$008,x
           sta    COLORRAM+$009,x
           lda    #$04
           sta    COLORRAM+$004,x
           lda    $02
           cmp    #$50
           beq    L2516
           bcs    L251B
L2516:     lda    #$06
           jmp    L2521

L251B:     lda    #$47
           sta    $04,x
           lda    #$02
L2521:     sta    COLORRAM+$108,x
L2524:     rts

L2525:     .byte  $1E,$23,$28,$2D,$32,$37,$3C,$41,$46,$4B
        
L252F:     lda    $04,x
           cmp    #$18
           beq    L257E
           jsr    LAF24
           sta    $95
           lda    $02,x
           cmp    #$2C
           bne    L254B
           lda    $95
           bit    $B8
           bne    L254B
           lda    #$06
           sta    COLORRAM+$108,x
L254B:     lda    $02,x
           cmp    #$34
           bne    L255C
           lda    $95
           bit    $B8
           bne    L255C
           lda    #$02
           sta    COLORRAM+$108,x
L255C:     lda    $02,x
           cmp    #$6C
           bne    L256D
           lda    $95
           bit    $B9
           bne    L256D
           lda    #$06
           sta    COLORRAM+$108,x
L256D:     lda    $02,x
           cmp    #$74
           bne    L257E
           lda    $95
           bit    $B9
           bne    L257E
           lda    #$02
           sta    COLORRAM+$108,x
L257E:     rts

L257F:     jsr    LBF1D
           lda    $02
           cmp    $02,x
           bcc    L2595
           sec
           sbc    $02,x
           sta    $011D
           lda    #$00
           sta    $DF
           jmp    L25A1

L2595:     lda    $02,x
           sec
           sbc    $02
           sta    $011D
           lda    #$02
           sta    $DF
L25A1:     lda    $03
           cmp    $03,x
           bcs    L25B0
           sec
           sbc    $03,x
           sta    $011E
           jmp    L25BE

L25B0:     lda    $03,x
           sec
           sbc    $03
           sta    $011E
           lda    #$01
           ora    $DF
           sta    $DF
L25BE:     ldy    #$00
           lda    ($A6),y
           cmp    #$00
           bne    L25FF
           ldy    #$01
           lda    $03,x
           cmp    ($A6),y
           beq    L25D0
           bcs    L25E3
L25D0:     iny
           lda    ($A6),y
           pha
           lda    #$10
           jsr    L2661
           and    #$02
           beq    L25E1
           pla
           sta    $04,x
           rts

L25E1:     pla
           rts

L25E3:     ldy    #$03
           lda    $03,x
           cmp    ($A6),y
           bcc    L25FE
           iny
           lda    ($A6),y
           pha
           lda    #$00
           jsr    L2661
           and    #$02
           beq    L25FC
           pla
           sta    $04,x
           rts

L25FC:     pla
           rts

L25FE:     rts

L25FF:     ldy    #$02
           lda    $02,x
           clc
           adc    #$04
           cmp    ($A6),y
           bne    L2610
           lda    #$02
           sta    COLORRAM+$108,x
           rts

L2610:     ldy    #$03
           lda    $02,x
           sec
           sbc    #$04
           clc
           adc    #$08
           cmp    ($A6),y
           bne    L2624
           lda    #$06
           sta    COLORRAM+$108,x
           rts

L2624:     ldy    #$04
L2626:     lda    ($A6),y
           cmp    #$01
           beq    L2634
           cmp    #$08
           beq    L2634
           cmp    #$02
           bne    L2660
L2634:     sta    $95
           iny
           lda    $02,x
           cmp    ($A6),y
           bne    L265B
           iny
           lda    ($A6),y
           pha
           lda    $95
           cmp    #$02
           bne    L264C
           lda    #$10
           jmp    L264E

L264C:     lda    #$00
L264E:     jsr    L2661
           and    #$02
           bne    L2659
           pla
           sta    $04,x
           rts

L2659:     pla
           rts

L265B:     iny
           iny
           jmp    L2626

L2660:     rts

L2661:     ora    $DF
           sta    $DF
           lda    COLORRAM+$108,x
           and    #$06
           asl    a
           ora    $DF
           sta    $DF
           ldy    $E7
           lda    $F1,y
           tay
           lda    L2696-1,y
           cmp    VIA2+$4
           beq    L267F
           bcs    L2685
L267F:     lda    $DF
           eor    #$03
           sta    $DF
L2685:     ldy    $DF
           lda    #$01
           sta    COLORRAM+$006,x
           sta    COLORRAM+$007,x
           lda    L269C-1,y
           sta    COLORRAM+$108,x
           rts

L2696:     .byte  $2D,$46,$50,$5A,$5F,$00
L269C:     .byte  $00,$00,$00,$02,$02,$00,$02
           .byte  $02,$02,$06,$06,$00,$06,$06,$06
           .byte  $02,$02,$06,$06,$02,$02,$02,$04
           .byte  $00,$00,$00,$00,$06,$04,$06,$06
        
L26BB:     lda    #<(L2CDA-2)
           sta    $AB
           lda    #>(L2CDA-2)
           sta    $AC
           ldx    #$3C
L26C5:     lda    $04,x
           beq    L2719
           lda    COLORRAM+$004,x
           and    #$08
           bne    L270B
           jsr    LBF1D
           ldy    #$02
           lda    $02,x
           cmp    ($A6),y
           bcs    L26E1
           jsr    LBB7E
           jmp    L2719

L26E1:     iny
           clc
           adc    #$04
           cmp    ($A6),y
           bcc    L26EF
           jsr    LBB7E
           jmp    L2719

L26EF:     lda    $04,x
           sec
           sbc    #$45
           tay
           lda    $0109,y
           sta    $07,x
           jsr    L2213
           lda    COLORRAM+$004,x
           and    #$08
           beq    L2708
           lda    #$24
           sta    $04,x
L2708:     jmp    L2716

L270B:     lda    $05,x
           bne    L2716
           lda    $06,x
           bne    L2716
           jsr    L216C
L2716:     jsr    LB9CF
L2719:     txa
           clc
           adc    #$0A
           tax
           cmp    #$64
           beq    L26C5
           bcc    L26C5
           dec    $0111
           bne    L2765
           lda    VIA2+$4
           lsr    a
           lsr    a
           clc
           adc    #$0A
           sta    $0111
           lda    VIA2+$4
           cmp    #$32
           beq    L273D
           bcs    L2742
L273D:     ldy    #$00
           jmp    L274F

L2742:     cmp    #$4B
           beq    L2748
           bcs    L274D
L2748:     ldy    #$01
           jmp    L274F

L274D:     ldy    #$02
L274F:     tya
           asl    a
           ldx    $0109,y
           bpl    L2758
           ora    #$01
L2758:     tax
           ldy    L2766,x
           ldx    #$3C
           lda    #$64
           sta    $F5
           jsr    LB87F
L2765:     rts

L2766:     .byte  $7D,$82,$87,$8C,$91,$96
        
L276C:     lda    #$00
           ldx    $C3
           dex
L2771:     dex
           beq    L277A
           clc
           adc    #$03
           jmp    L2771

L277A:     tax
           lda    #$03
           sta    $99
L277F:     lda    $04
           cmp    L27EB,x
           bne    L27C1
           lda    $02
           sec
           sbc    L27D0,x
           cmp    #$06
           beq    L2792
           bcs    L27C1
L2792:     lda    L27E2,x
           bit    $BE
           beq    L27C1
           eor    #$FF
           and    $BE
           sta    $BE
           lda    L27D0,x
           sta    $9B
           lda    L27D9,x
           sta    $9C
           txa
           pha
           lda    L27C7,x
           tax
           lda    #$20
           jsr    LB352
           ldx    $E7
           lda    $F1,x
           tax
           lda    L27F3,x
           jsr    LA6D7
           pla
           tax
L27C1:     inx
           dec    $99
           bne    L277F
           rts

L27C7:     .byte  $39,$3A,$37,$3A,$37,$38,$3A,$38,$37
L27D0:     .byte  $60,$90,$28,$38,$04,$90,$54,$50,$94
L27D9:     .byte  $BA,$99,$3A,$9F,$60,$48,$B9,$7A,$7A
L27E2:     .byte  $20,$10,$08,$20,$10,$08,$20,$10,$08
L27EB:     .byte  $18,$19,$1C,$24,$3E,$30,$41,$44
L27F3:     .byte  $42,$03,$05,$08,$08,$08
        
L27F9:     lda    $B1
           beq    L284D
           lda    #$02
           sta    $99
           lda    $C3
           sec
           sbc    #$01
           asl    a
           tax
L2808:     lda    $04
           cmp    L2866,x
           bne    L2848
           lda    $02
           cmp    L284E,x
           bne    L2848
           lda    L285E,x
           bit    $BE
           beq    L2848
           eor    #$FF
           and    $BE
           sta    $BE
           lda    #$78
           sta    $BB
           lda    L284E,x
           sta    $9B
           lda    L2856,x
           sta    $9C
           txa
           pha
           ldx    #$21
           lda    #$20
           jsr    LB352
           jsr    L3CE8
           lda    #>L3F10
           pha
           lda    #<L3F10
           pha
           jsr    L3C85
           pla
           tax
L2848:     inx
           dec    $99
           bne    L2808
L284D:     rts

L284E:     .byte  $70,$20,$18,$50,$FF,$FF,$54,$10
L2856:     .byte  $91,$3F,$69,$49,$FF,$FF,$89,$6B
L285E:     .byte  $80,$40,$80,$40,$00,$00,$80,$40
L2866:     .byte  $02,$05,$1A,$1B,$00,$00,$45,$43
L286E:     .byte  $1D,$10
L2870:     .byte  $C0,$00,$10,$00,$09,$10,$A2,$00
           .byte  $10,$01,$08,$20,$8D,$00,$10,$FF
           .byte  $08,$10,$6A,$00,$10,$01,$08,$20
           .byte  $54,$00,$10,$FF,$08,$10,$36,$00
           .byte  $10,$00,$08,$60,$16,$00,$10,$00
           .byte  $03,$FF,$1C,$34,$BA,$00,$00,$FC
           .byte  $02,$74,$B8,$00,$00,$FC,$04,$44
           .byte  $9F,$00,$00,$FC,$05,$24,$9D,$00
           .byte  $00,$FC,$04,$34,$74,$00,$00,$FC
           .byte  $02,$54,$82,$00,$00,$FC,$05,$84
           .byte  $81,$00,$00,$FC,$04,$74,$6A,$00
           .byte  $00,$FC,$02,$44,$66,$00,$00,$FC
           .byte  $05,$24,$64,$00,$00,$FC,$04,$64
           .byte  $4A,$00,$00,$FC,$05,$84,$2E,$00
           .byte  $00,$FC,$06,$56,$30,$00,$00,$FC
           .byte  $0C,$42,$30,$00,$00,$FC,$0C,$FF
           .byte  $28,$74,$BA,$00,$00,$FF,$02,$54
           .byte  $84,$00,$00,$FF,$02,$84,$30,$00
           .byte  $00,$FF,$02,$FF,$FF
L2905:     .byte  $1C,$34,$A8,$00,$34,$86,$00,$74
           .byte  $53,$00,$34,$4D,$00,$34,$3A,$00
           .byte  $FF,$28,$44,$67,$00,$24,$65,$00
           .byte  $FF,$21,$70,$91,$00,$20,$3F,$00
           .byte  $FF,$27,$10,$BA,$00,$FF,$25,$20
           .byte  $30,$80,$FF,$2B,$66,$10,$00,$FF
           .byte  $30,$92,$07,$00,$FF,$35,$90,$16
           .byte  $00,$FF,$2F,$90,$1F,$00,$FF,$31
           .byte  $00,$10,$00,$FF,$05,$0C,$30,$00
           .byte  $18,$30,$00,$12,$29,$00,$FF,$0E
           .byte  $A8,$40,$00,$FF,$FF
L295A:     .byte  $20,$08,$C0,$00,$08,$00,$13,$10
           .byte  $A0,$00,$08,$00,$11,$18,$80,$00
           .byte  $08,$00,$0F,$20,$60,$00,$08,$00
           .byte  $0D,$28,$40,$00,$08,$00,$0B,$30
           .byte  $16,$00,$08,$00,$09,$FF,$1C,$14
           .byte  $B8,$00,$00,$FC,$06,$50,$B8,$00
           .byte  $00,$FC,$06,$8C,$B8,$00,$00,$FC
           .byte  $06,$1C,$98,$00,$00,$FC,$06,$3C
           .byte  $98,$00,$00,$FC,$06,$64,$98,$00
           .byte  $00,$FC,$06,$84,$98,$00,$00,$FC
           .byte  $06,$24,$78,$00,$00,$FC,$06,$50
           .byte  $78,$00,$00,$FC,$06,$7C,$78,$00
           .byte  $00,$FC,$06,$28,$58,$00,$00,$FC
           .byte  $06,$38,$58,$00,$00,$FC,$06,$68
           .byte  $58,$00,$00,$FC,$06,$78,$58,$00
           .byte  $00,$FC,$06,$FF,$20,$30,$40,$20
           .byte  $00,$20,$04,$70,$40,$20,$00,$20
           .byte  $04,$FF,$32,$30,$40,$00,$00,$20
           .byte  $04,$70,$40,$00,$00,$20,$04,$FF
           .byte  $2A,$3A,$3A,$00,$00,$FE,$12,$6C
           .byte  $3A,$00,$00,$FE,$12,$FF,$FF
L2A01:     .byte  $29,$14,$BA,$00,$50,$BA,$00,$8C
           .byte  $BA,$00,$1C,$9A,$00,$3C,$9A,$00
           .byte  $64,$9A,$00,$84,$9A,$00,$24,$7A
           .byte  $00,$50,$7A,$00,$7C,$7A,$00,$28
           .byte  $5A,$00,$38,$5A,$00,$68,$5A,$00
           .byte  $78,$5A,$00,$FF,$21,$18,$69,$00
           .byte  $50,$49,$00,$FF,$25,$40,$3A,$80
           .byte  $FF,$2B,$56,$10,$00,$FF,$39,$60
           .byte  $BA,$00,$FF,$3A,$90,$99,$00,$FF
           .byte  $37,$28,$3A,$00,$FF,$30,$92,$07
           .byte  $00,$FF,$35,$90,$16,$00,$FF,$2F
           .byte  $90,$1F,$00,$FF,$31,$00,$10,$00
           .byte  $FF,$0E,$A8,$40,$00,$FF,$FF
L2A68:     .byte  $1D,$80,$68,$00,$10,$00,$02,$00
           .byte  $36,$00,$10,$00,$08,$40,$16,$00
           .byte  $10,$00,$03,$00,$C0,$00,$10,$00
           .byte  $0A,$FF,$1C,$10,$AE,$00,$00,$FC
           .byte  $08,$0C,$86,$00,$00,$FC,$08,$30
           .byte  $A0,$00,$00,$FC,$10,$40,$A0,$00
           .byte  $00,$FC,$10,$94,$A6,$00,$00,$FC
           .byte  $04,$80,$88,$00,$00,$FC,$08,$64
           .byte  $82,$00,$00,$FC,$0A,$94,$62,$00
           .byte  $00,$FC,$05,$74,$4E,$00,$00,$FC
           .byte  $06,$64,$2E,$00,$00,$FC,$06,$22
           .byte  $30,$00,$00,$FC,$08,$36,$30,$00
           .byte  $00,$FC,$08,$FF,$2A,$22,$BA,$00
           .byte  $00,$FE,$42,$24,$BA,$00,$00,$FE
           .byte  $42,$52,$BA,$00,$00,$FE,$42,$54
           .byte  $BA,$00,$00,$FE,$42,$FF,$FF
L2AE7:     .byte  $1D,$08,$B6,$00,$08,$8E,$00,$08
           .byte  $66,$00,$30,$A6,$00,$30,$60,$00
           .byte  $60,$B8,$00,$94,$AE,$00,$94,$96
           .byte  $00,$7C,$90,$00,$64,$88,$00,$70
           .byte  $54,$00,$90,$4E,$00,$FF,$1E,$40
           .byte  $A6,$40,$40,$60,$40,$78,$B4,$00
           .byte  $84,$B0,$00,$78,$68,$00,$64,$5A
           .byte  $00,$88,$4E,$00,$FF,$41,$20,$C0
           .byte  $00,$20,$36,$40,$50,$C0,$00
L2B2E:     .byte  $50,$36,$40,$FF,$29,$0C,$88,$00
           .byte  $10,$B0,$00,$64,$30,$00,$80,$8A
           .byte  $00,$94,$A8,$00,$FF,$22,$00,$30
           .byte  $00,$FF,$2B,$46,$10,$00,$FF,$37
           .byte  $04,$60,$00,$FF,$3A,$38,$9F,$00
           .byte  $FF,$38,$90,$48,$00,$FF,$31,$00
           .byte  $10,$00,$FF,$0E,$A8,$40,$00,$FF
           .byte  $30,$92,$07,$00,$FF,$35,$90,$16
           .byte  $00,$FF,$2F,$90,$1F,$00,$FF,$FF
L2B76:     .byte  $1D,$10,$C0,$00,$10,$00,$09,$10
           .byte  $80,$00,$10,$00,$02,$38,$80,$00
           .byte  $10,$00,$04,$80,$80,$00,$10,$00
           .byte  $02,$10,$40,$00,$10,$00,$09,$60
           .byte  $16,$00,$10,$00,$02,$FF,$33,$18
           .byte  $A2,$00,$08,$00,$10,$18,$62,$00
           .byte  $08,$00,$06,$68,$62,$00,$08,$00
           .byte  $06,$FF,$1C,$1C,$BA,$00,$00,$FC
           .byte  $06,$44,$BA,$00,$00,$FC,$06,$64
           .byte  $BA,$00,$00,$FC,$06,$8C,$BA,$00
           .byte  $00,$FC,$06,$3C,$98,$00,$00,$FC
           .byte  $06,$6C,$98,$00,$00,$FC,$06,$1C
           .byte  $7A,$00,$00,$FC,$06,$40,$7A,$00
           .byte  $00,$FC,$06,$68,$7A,$00,$00,$FC
           .byte  $06,$8C,$7A,$00,$00,$FC,$06,$18
           .byte  $58,$00,$00,$FC,$06,$90,$58,$00
           .byte  $00,$FC,$06,$42,$38,$00,$00,$FC
           .byte  $0E,$56,$38,$00,$00,$FC,$0E,$74
           .byte  $3A,$00,$00,$FC,$09,$FF,$FF
L2C0D:     .byte  $29,$3C,$9A,$00,$6C,$9A,$00,$18
           .byte  $5A,$00,$90,$5A,$00,$42,$3A,$00
           .byte  $56,$3A,$00,$FF,$21,$54,$89,$00
           .byte  $10,$6B,$00,$FF,$34,$10,$A2,$00
           .byte  $10,$62,$00,$48,$62,$80,$60,$62
           .byte  $00,$98,$62,$80,$98,$A2,$80,$FF
           .byte  $2A,$50,$5F,$00,$52,$5F,$00,$5E
           .byte  $5F,$00,$FF,$27,$50,$68,$00,$FF
           .byte  $25,$20,$3A,$00,$FF,$2B,$66,$10
           .byte  $00,$FF,$3A,$54,$B9,$00,$FF,$37
           .byte  $94,$7A,$00,$FF,$38,$50,$7A,$00
           .byte  $FF,$30,$92,$07,$00,$FF,$35,$90
           .byte  $16,$00,$FF,$2F,$90,$1F,$00,$FF
           .byte  $31,$00,$10,$00,$FF,$0E,$A8,$40
           .byte  $00,$FF,$FF
        
L2C80:     .word  L2C94,L2C9B,L2CA2,L2CA9,L2CB0,L2CB7,L2CBE,L2CC5
           .word  L2CCC,L2CD3
                
L2C94:     .byte  $80,$02,$01,$00,$81,$11,$8E
L2C9B:     .byte  $80,$03,$04,$04,$71,$44,$D0
L2CA2:     .byte  $80,$04,$04,$04,$31,$44,$4E
L2CA9:     .byte  $80,$05,$04,$04,$71,$44,$10
L2CB0:     .byte  $80,$06,$04,$04,$31,$44,$8E
L2CB7:     .byte  $80,$07,$04,$04,$71,$44,$D0
L2CBE:     .byte  $80,$08,$04,$04,$31,$44,$4E
L2CC5:     .byte  $80,$09,$04,$00,$61,$41,$11
L2CCC:     .byte  $80,$0A,$10,$00,$81,$11,$00
L2CD3:     .byte  $80,$FF,$01,$00,$81,$11,$00

L2CDA:     .word  L2D78,L2D7F,L2D8D,L2D94,L2D9D,L2DAD,L2DB6
           .word  L2DC6,L2DD6,L2DDD,L2DED,L2DF6,L2E06,L2E0F,L2E1F
           .word  L2E28,L2E38,L2E3F,L2E4F,L2E58,L2E61,L2E71,L2E7A
           .word  L2E8A,L2E91,L2EA1,L2EAA,L2EBA,L2EC3,L2ED3,L2EDA
           .word  L2EE8,L2EEF,L2EF6,L2F04,L2F0B,L2F12,L2F19,L2F20
           .word  L2F27,L2F2E,L2F35,L2F3C,L2F43,L2F4A,L2F51,L2F58
           .word  L2F5F,L2F66,L2F74,L2F7B,L2F8D,L2F8D,L2F96,L2F96
           .word  L2FA8,L2FA8,L2FBA,L2FBA,L2FCC,L2FCC,L2FD5,L2FD5
           .word  L2FE7,L2FE7,L2FF9,L3002,L3010,L3017,L301E,L3025
           .word  L303A,L304F,L3056,L305D,L3064,L3072,L3079,L3080
        
L2D78:     .byte  $80,$02,$24,$00,$22,$41,$04
L2D7F:     .byte  $AD,$06,$00,$1A,$42,$16,$08,$80
           .byte  $03,$2C,$00,$22,$41,$00
L2D8D:     .byte  $80,$04,$08,$17,$32,$46,$00
L2D94:     .byte  $00,$05,$24,$02,$14,$14,$51,$41
           .byte  $00
L2D9D:     .byte  $A3,$0F,$00,$21,$41,$16,$08,$00
           .byte  $07,$30,$03,$14,$13,$51,$41,$00
L2DAD:     .byte  $00,$07,$20,$02,$14,$13,$51,$41
           .byte  $04
L2DB6:     .byte  $A3,$0D,$00,$1B,$41,$16,$08,$00
           .byte  $08,$20,$02,$14,$13,$51,$41,$00
L2DC6:     .byte  $A3,$0B,$00,$17,$41,$16,$08,$00
           .byte  $09,$0C,$01,$14,$13,$51,$41,$04
L2DD6:     .byte  $80,$0A,$08,$15,$51,$46,$00
L2DDD:     .byte  $9E,$23,$08,$04,$71,$42,$00,$00
           .byte  $0C,$24,$02,$14,$14,$32,$41,$00
L2DED:     .byte  $00,$0C,$10,$01,$14,$13,$32,$41
           .byte  $04
L2DF6:     .byte  $A3,$16,$00,$20,$42,$16,$08,$00
           .byte  $0E,$20,$02,$14,$13,$32,$41,$00
L2E06:     .byte  $00,$0E,$10,$01,$14,$13,$32,$41
           .byte  $04
L2E0F:     .byte  $A3,$14,$00,$1C,$42,$16,$08,$00
           .byte  $10,$30,$03,$14,$13,$32,$41,$00
L2E1F:     .byte  $00,$10,$10,$01,$14,$13,$32,$41
           .byte  $04
L2E28:     .byte  $A3,$13,$00,$16,$42,$16,$08,$00
           .byte  $11,$0C,$01,$14,$13,$32,$41,$00
L2E38:     .byte  $80,$12,$08,$14,$32,$46,$00
L2E3F:     .byte  $9E,$25,$08,$04,$12,$42,$00,$00
           .byte  $15,$54,$05,$14,$14,$51,$41,$00
L2E4F:     .byte  $00,$15,$40,$04,$14,$13,$51,$41
           .byte  $04
L2E58:     .byte  $00,$15,$10,$01,$14,$13,$51,$41
           .byte  $04
L2E61:     .byte  $A3,$1C,$00,$1A,$41,$16,$08,$00
           .byte  $17,$20,$02,$14,$13,$51,$41,$00
L2E71:     .byte  $00,$17,$10,$01,$14,$13,$51,$41
           .byte  $04
L2E7A:     .byte  $A3,$1A,$00,$16,$41,$16,$08,$00
           .byte  $18,$0C,$01,$14,$13,$51,$41,$00
L2E8A:     .byte  $80,$19,$08,$14,$51,$46,$00
L2E91:     .byte  $9E,$23,$08,$04,$71,$42,$00,$00
           .byte  $1B,$24,$02,$14,$14,$32,$41,$00
L2EA1:     .byte  $00,$1B,$10,$01,$14,$13,$32,$41
           .byte  $04
L2EAA:     .byte  $A3,$21,$00,$1C,$42,$16,$08,$00
           .byte  $1D,$40,$04,$14,$13,$32,$41,$00
L2EBA:     .byte  $00,$1D,$30,$03,$14,$13,$32,$41
           .byte  $04
L2EC3:     .byte  $A3,$20,$00,$18,$42,$16,$08,$00
           .byte  $1E,$1C,$02,$14,$13,$32,$41,$00
L2ED3:     .byte  $80,$1F,$08,$16,$32,$46,$00
L2EDA:     .byte  $B2,$25,$08,$04,$12,$42,$00,$80
           .byte  $22,$7C,$00,$61,$41,$00
L2EE8:     .byte  $80,$22,$58,$00,$61,$41,$04
L2EEF:     .byte  $80,$22,$18,$00,$61,$41,$04
L2EF6:     .byte  $D5,$24,$01,$01,$80,$11,$00,$80
           .byte  $2D,$01,$01,$80,$11,$01
L2F04:     .byte  $80,$24,$08,$18,$51,$46,$00
L2F0B:     .byte  $80,$26,$01,$01,$88,$11,$01
L2F12:     .byte  $80,$24,$08,$18,$32,$26,$00
L2F19:     .byte  $80,$00,$01,$01,$88,$11,$00
L2F20:     .byte  $80,$28,$01,$00,$88,$11,$14
L2F27:     .byte  $80,$29,$01,$00,$88,$11,$15
L2F2E:     .byte  $80,$2A,$01,$00,$88,$11,$14
L2F35:     .byte  $80,$2B,$01,$00,$88,$11,$15
L2F3C:     .byte  $80,$2C,$01,$00,$88,$11,$16
L2F43:     .byte  $80,$24,$02,$00,$68,$21,$17
L2F4A:     .byte  $80,$2E,$06,$0C,$70,$46,$02
L2F51:     .byte  $80,$2F,$0C,$08,$10,$64,$03
L2F58:     .byte  $80,$30,$00,$14,$40,$16,$02
L2F5F:     .byte  $80,$01,$00,$04,$64,$22,$03
L2F66:     .byte  $B2,$32,$08,$16,$52,$24,$08,$80
           .byte  $33,$08,$15,$32,$24,$08
L2F74:     .byte  $80,$35,$00,$17,$32,$24,$00
L2F7B:     .byte  $32,$35,$10,$18,$22,$11,$52,$24
           .byte  $00,$00,$37,$10,$1A,$22,$11,$32
           .byte  $24,$00
L2F8D:     .byte  $00,$39,$10,$21,$22,$11,$32,$24
           .byte  $00
L2F96:     .byte  $32,$39,$10,$1F,$22,$11,$52,$24
           .byte  $00,$00,$3B,$10,$1D,$22,$11,$32
           .byte  $24,$00
L2FA8:     .byte  $32,$3D,$10,$17,$22,$11,$52,$46
           .byte  $00,$00,$3F,$10,$19,$22,$11,$32
           .byte  $46,$00
L2FBA:     .byte  $32,$3F,$10,$1B,$22,$11,$52,$46
           .byte  $00,$00,$41,$10,$1D,$22,$11,$32
           .byte  $46,$00
L2FCC:     .byte  $00,$2E,$10,$11,$22,$11,$52,$88
           .byte  $00
L2FD5:     .byte  $32,$21,$10,$1B,$22,$11,$52,$68
           .byte  $00,$00,$42,$10,$1B,$22,$11,$32
           .byte  $68,$00
L2FE7:     .byte  $32,$42,$10,$19,$22,$11,$52,$68
           .byte  $00,$00,$20,$10,$19,$22,$11,$32
           .byte  $68,$00
L2FF9:     .byte  $00,$22,$38,$00,$22,$11,$61,$41
           .byte  $04
L3002:     .byte  $80,$44,$08,$0E,$11,$48,$1B,$80
           .byte  $44,$0C,$0E,$11,$68,$1B
L3010:     .byte  $80,$45,$08,$02,$11,$42,$00
L3017:     .byte  $80,$46,$08,$02,$32,$42,$18
L301E:     .byte  $80,$47,$08,$0E,$32,$48,$00
L3025:     .byte  $B2,$48,$08,$0E,$11,$48,$1B,$9E
           .byte  $48,$0C,$0E,$11,$68,$1B,$80,$48
           .byte  $10,$0E,$11,$88,$1B
L303A:     .byte  $B2,$49,$08,$02,$11,$42,$00,$9E
           .byte  $49,$0C,$02,$11,$62,$00,$80,$49
           .byte  $10,$02,$11,$82,$00
L304F:     .byte  $80,$4A,$08,$02,$32,$42,$18
L3056:     .byte  $80,$4B,$08,$0E,$32,$48,$00
L305D:     .byte  $80,$4C,$08,$0E,$11,$48,$1B
L3064:     .byte  $B2,$4D,$08,$02,$11,$42,$00,$80
           .byte  $4D,$06,$02,$11,$42,$00
L3072:     .byte  $80,$4E,$08,$02,$32,$42,$18
L3079:     .byte  $80,$4F,$08,$0E,$32,$48,$00
L3080:     .byte  $80,$24,$00,$8A,$40,$2F,$18

L3087:     .word  L312B,L313D,L314F,L3167,L3182,L3197,L31A5,L31A5
           .word  L31AA,L31AF,L31B4,L31B9,L31BE,L31C3,L31C8,L31CD
           .word  L31D2,L31D7,L31DC,L31E1,L31E6,L31EB,L31F0,L3204
           .word  L3216,L3230,L324A,L3264,L3275,L327A,L327F,L3284
           .word  L31F5,L31FA,L31FF,L32AA,L32B9,L32C8,L32D1,L32DA
           .word  L32E3,L32ED,L32F7,L3303,L330F,L331A,L3326,L3332
           .word  L333C,L3369,L336E,L3373,L3378,L3378,L337D,L3382
           .word  L3387,L338C,L3391,L3289,L3293,L32A0,L3349,L335A
           .word  L3396,L33E1,L33C2,L33CC,L33AB,L33EB,L33FF,L3413
           .word  L3418,L341D,L3422,L3427,L342C,L3431,L3436,L343B
           .word  L3440,L3445
        
L312B:     .byte  $01,$BA,$20,$A0,$08,$34,$21,$01
           .byte  $74,$09,$05,$9C,$04,$10,$01,$34
           .byte  $08,$00
L313D:     .byte  $03,$A3,$10,$90,$01,$44,$0A,$01
           .byte  $24,$0C,$02,$74,$09,$07,$02,$34
           .byte  $0B,$00
L314F:     .byte  $02,$87,$20,$A0,$08,$34,$22,$02
           .byte  $24,$0C,$02,$44,$0A,$01,$54,$0E
           .byte  $01,$84,$0F,$07,$01,$34,$0D,$00
L3167:     .byte  $03,$6B,$10,$90,$02,$84,$0F,$08
           .byte  $74,$23,$02,$54,$0E,$01,$44,$11
           .byte  $01,$24,$13,$07,$02,$34,$12,$01
           .byte  $74,$10,$00
L3182:     .byte  $02,$4E,$20,$A0,$02,$24,$13,$02
           .byte  $44,$11,$01,$64,$15,$07,$02,$74
           .byte  $16,$01,$34,$14,$00
L3197:     .byte  $01,$30,$40,$90,$02,$64,$15,$07
           .byte  $01,$84,$17,$04,$5C,$00
L31A5:     .byte  $00,$B3,$08,$BA,$01
L31AA:     .byte  $00,$A2,$02,$BA,$01
L31AF:     .byte  $00,$85,$03,$9F,$02
L31B4:     .byte  $00,$9E,$02,$A5,$0B
L31B9:     .byte  $00,$87,$03,$9D,$02
L31BE:     .byte  $00,$83,$0D,$86,$03
L31C3:     .byte  $00,$68,$04,$84,$03
L31C8:     .byte  $00,$6B,$04,$81,$03
L31CD:     .byte  $00,$63,$10,$6A,$04
L31D2:     .byte  $00,$4C,$05,$67,$04
L31D7:     .byte  $00,$66,$04,$71,$12
L31DC:     .byte  $00,$4E,$05,$65,$04
L31E1:     .byte  $00,$4A,$14,$4D,$05
L31E6:     .byte  $00,$30,$06,$4A,$05
L31EB:     .byte  $00,$49,$05,$50,$16
L31F0:     .byte  $00,$10,$FE,$30,$06
L31F5:     .byte  $00,$9E,$02,$BA,$01
L31FA:     .byte  $00,$66,$04,$86,$03
L31FF:     .byte  $00,$49,$05,$66,$04
L3204:     .byte  $01,$BA,$08,$A0,$01,$14,$1D,$01
           .byte  $50,$1D,$01,$8C,$1D,$04,$08,$05
           .byte  $98,$00
L3216:     .byte  $01,$9A,$10,$98,$02,$14,$1D,$02
           .byte  $50,$1D,$02,$8C,$1D,$01,$1C,$1E
           .byte  $01,$3C,$1E,$01,$64,$1E,$01,$84
           .byte  $1E,$00
L3230:     .byte  $01,$7A,$18,$90,$02,$1C,$1E,$02
           .byte  $3C,$1E,$02,$64,$1E,$02,$84,$1E
           .byte  $01,$24,$1F,$01,$50,$1F,$01,$7C
           .byte  $1F,$00
L324A:     .byte  $01,$5A,$20,$88,$02,$24,$1F,$02
           .byte  $50,$1F,$02,$7C,$1F,$01,$28,$20
           .byte  $01,$38,$20,$01,$68,$20,$01,$78
           .byte  $20,$00
L3264:     .byte  $01,$3A,$28,$80,$02,$28,$20,$02
           .byte  $38,$20,$02,$68,$20,$02,$78,$20
           .byte  $00
L3275:     .byte  $00,$9A,$19,$BA,$18
L327A:     .byte  $00,$7A,$1A,$9A,$19
L327F:     .byte  $00,$5A,$1B,$7A,$1A
L3284:     .byte  $00,$3A,$1C,$5A,$1B
L3289:     .byte  $01,$B0,$08,$18,$01,$10,$32,$03
           .byte  $3F,$00
L3293:     .byte  $01,$88,$08,$18,$02,$10,$32,$01
           .byte  $0C,$33,$03,$3F,$00
L32A0:     .byte  $01,$60,$08,$18,$02,$0C,$33,$03
           .byte  $3F,$00
L32AA:     .byte  $01,$A0,$30,$48,$01,$30,$34,$01
           .byte  $40,$34,$03,$3F,$03,$40,$00
L32B9:     .byte  $01,$5A,$30,$48,$02,$30,$34,$02
           .byte  $40,$34,$03,$3F,$03,$40,$00
L32C8:     .byte  $01,$B2,$60,$70,$03,$40,$03,$27
           .byte  $00
L32D1:     .byte  $01,$AE,$78,$80,$03,$26,$03,$28
           .byte  $00
L32DA:     .byte  $01,$AA,$84,$8C,$03,$27,$03,$29
           .byte  $00
L32E3:     .byte  $01,$A8,$94,$A4,$01,$94,$36,$03
           .byte  $28,$00
L32ED:     .byte  $01,$90,$94,$A4,$02,$94,$36,$03
           .byte  $2B,$00
L32F7:     .byte  $01,$8A,$7C,$8C,$01,$80,$37,$03
           .byte  $2A,$03,$2C,$00
L3303:     .byte  $01,$82,$64,$74,$01,$64,$38,$03
           .byte  $2B,$03,$40,$00
L330F:     .byte  $01,$62,$78,$A0,$02,$80,$37,$01
           .byte  $94,$39,$00
L331A:     .byte  $01,$54,$64,$6C,$02,$64,$38,$03
           .byte  $2F,$03,$40,$00
L3326:     .byte  $01,$4E,$70,$80,$01,$74,$3A,$03
           .byte  $2E,$03,$30,$00
L3332:     .byte  $01,$48,$88,$A0,$02,$94,$39,$03
           .byte  $2F,$00
L333C:     .byte  $01,$30,$30,$80,$02,$74,$3A,$01
           .byte  $64,$3B,$04,$3C,$00
L3349:     .byte  $01,$00,$20,$28,$03,$3C,$03,$3D
           .byte  $03,$3E,$03,$3F,$03,$24,$03,$25
           .byte  $00
L335A:     .byte  $01,$00,$50,$58,$03,$24,$03,$25
           .byte  $03,$26,$03,$2C,$03,$2E,$00
L3369:     .byte  $00,$88,$3D,$B0,$3C
L336E:     .byte  $00,$60,$3E,$88,$3D
L3373:     .byte  $00,$5A,$25,$A0,$24
L3378:     .byte  $00,$90,$2A,$A8,$29
L337D:     .byte  $00,$62,$2D,$8A,$2B
L3382:     .byte  $00,$54,$2E,$82,$2C
L3387:     .byte  $00,$48,$30,$62,$2D
L338C:     .byte  $00,$30,$31,$4E,$2F
L3391:     .byte  $00,$10,$FE,$30,$31
L3396:     .byte  $01,$BA,$10,$A0,$01,$1C,$48,$01
           .byte  $44,$48,$01,$64,$48,$01,$8C,$48
           .byte  $04,$10,$05,$98,$00
L33AB:     .byte  $01,$9A,$10,$A0,$02,$1C,$48,$02
           .byte  $44,$48,$02,$64,$48,$02,$8C,$48
           .byte  $01,$3C,$49,$01,$6C,$49,$00
L33C2:     .byte  $01,$7A,$10,$30,$01,$1C,$4A,$03
           .byte  $44,$00
L33CC:     .byte  $01,$7A,$38,$78,$02,$3C,$49,$02
           .byte  $6C,$49,$01,$40,$4B,$01,$68,$4C
           .byte  $03,$43,$03,$42,$00
L33E1:     .byte  $01,$7A,$80,$A0,$01,$8C,$4D,$03
           .byte  $44,$00
L33EB:     .byte  $01,$5A,$10,$50,$02,$1C,$4A,$02
           .byte  $40,$4B,$08,$18,$50,$07,$01,$18
           .byte  $4E,$03,$47,$00
L33FF:     .byte  $01,$5A,$60,$A0,$02,$68,$4C,$02
           .byte  $8C,$4D,$08,$90,$51,$07,$01,$90
           .byte  $4F,$03,$46,$00
L3413:     .byte  $00,$9A,$45,$BA,$41
L3418:     .byte  $00,$7A,$44,$9A,$45
L341D:     .byte  $00,$5A,$46,$7A,$43
L3422:     .byte  $00,$5A,$46,$7A,$44
L3427:     .byte  $00,$5A,$47,$7A,$44
L342C:     .byte  $00,$5A,$47,$7A,$42
L3431:     .byte  $00,$3A,$FE,$5A,$46
L3436:     .byte  $00,$3A,$FE,$5A,$47
L343B:     .byte  $00,$3A,$52,$5A,$46
L3440:     .byte  $00,$3A,$52,$5A,$47
L3445:     .byte  $01,$3A,$10,$A0,$02,$18,$50,$02
           .byte  $90,$51,$00
L3450:     .byte  $01,$0F,$88,$2A,$AA,$30,$FC,$FF
           .byte  $0F,$3F,$3C,$2B,$AA,$E8,$24,$15
           .byte  $10,$50
L3462:     .byte  $01,$0F,$88,$2A,$AA,$30,$FC,$FF
           .byte  $0F,$3F,$3C,$E8,$AA,$AB,$18,$54
           .byte  $04,$05
L3474:     .byte  $01,$0F,$88,$2A,$AA,$30,$FC,$FF
           .byte  $0F,$3F,$3C,$28,$2C,$2C,$2C,$08
           .byte  $04,$14
L3486:     .byte  $01,$0F,$88,$2A,$AA,$30,$FC,$FF
           .byte  $0F,$3F,$3C,$28,$2F,$EF,$EB,$58
           .byte  $04,$14
L3498:     .byte  $02,$09,$88,$00,$14,$30,$04,$30
           .byte  $04,$B3,$A8,$B3,$A8,$BF,$B8,$BF
           .byte  $B8,$8C,$00,$8C,$00
L34AD:     .byte  $02,$0D,$88,$3C,$00,$C3,$00,$3C
           .byte  $00,$00,$00,$00,$14,$30,$04,$30
           .byte  $04,$B3,$A8,$B3,$A8,$BF,$B8,$BF
           .byte  $B8,$8C,$00,$8C,$00,$F8,$00
L34CC:     .byte  $02,$0F,$C8,$00,$2A,$00,$AA,$00
           .byte  $30,$00,$FC,$00,$FF,$00,$0F,$00
           .byte  $3F,$00,$3C,$50,$E8,$53,$EF,$5A
           .byte  $AF,$5A,$AB,$50,$58,$50,$04,$00
           .byte  $14,$F8,$00
L34EF:     .byte  $02,$0F,$C8,$08,$2A,$15,$AA,$15
           .byte  $30,$15,$FC,$15,$FF,$08,$0F,$08
           .byte  $3F,$0B,$3C,$0B,$E8,$08,$EC,$00
           .byte  $2C,$00,$2C,$00,$08,$00,$04,$00
           .byte  $14
L3510:     .byte  $02,$06,$88,$55,$55,$50,$01,$14
           .byte  $05,$05,$14,$01,$50,$55,$55
L351F:     .byte  $01,$06,$88,$55,$01,$05,$14,$50
           .byte  $55
L3528:     .byte  $01,$04,$88,$55,$14,$14,$55
L352F:     .byte  $01,$06,$88,$55,$51,$40,$40,$51
           .byte  $55
L3538:     .byte  $01,$08,$88,$2C,$EF,$EF,$EF,$EF
           .byte  $EF,$EF,$2C
L3543:     .byte  $01,$08,$88,$3C,$FA,$EB,$AF,$BF
           .byte  $FF,$FF,$3C
L354E:     .byte  $01,$08,$88,$3C,$FF,$AA,$AA,$FF
           .byte  $FF,$FF,$3C
L3559:     .byte  $01,$08,$88,$3C,$AF,$EB,$FA,$FE
           .byte  $FF,$FF,$3C,$FE,$00
L3566:     .byte  $02,$08,$C8,$17,$C0,$7F,$D0,$7F
           .byte  $D0,$7D,$50,$57,$D0,$7F,$D0,$7F
           .byte  $D0,$3D,$40,$FE,$00
L357B:     .byte  $02,$08,$C8,$3D,$40,$57,$D0,$7F
           .byte  $D0,$7F,$D0,$7D,$50,$57,$D0,$7F
           .byte  $D0,$3F,$C0,$FE,$00
L3590:     .byte  $02,$08,$C8,$3F,$C0,$7D,$50,$57
           .byte  $D0,$7F,$D0,$7F,$D0,$7D,$50,$57
           .byte  $D0,$3F,$40,$FE,$00
L35A5:     .byte  $02,$08,$C8,$3F,$C0,$7F,$D0,$7D
           .byte  $50,$57,$D0,$7F,$D0,$7F,$D0,$7D
           .byte  $50,$17,$C0
L35B8:     .byte  $04,$1C,$88,$00,$0A,$80,$00,$3C
           .byte  $2A,$A0,$00,$BC,$26,$60,$00,$AC
           .byte  $E8,$AC,$00,$A8,$EA,$AC,$00,$A0
           .byte  $3F,$F0,$00,$A0,$F0,$3C,$00,$A8
           .byte  $CF,$CC,$00,$AA,$FF,$FE,$00,$AA
           .byte  $AF,$E2,$80,$AA,$AA,$A2,$A0,$2A
           .byte  $AA,$8A,$A0,$2A,$AB,$2A,$A0,$0A
           .byte  $AF,$EA,$A0,$02,$BF,$EA,$80,$00
           .byte  $BF,$E8,$80,$00,$BF,$02,$80,$00
           .byte  $BC,$FA,$00,$02,$BF,$F8,$00,$0A
           .byte  $AF,$EA,$00,$AA,$AB,$AA,$80,$AA
           .byte  $AA,$AA,$A0,$AA,$AA,$AA,$A0,$AA
           .byte  $AA,$AA,$A0,$2A,$80,$AA,$A0,$FF
           .byte  $00,$2A,$80,$FF,$00,$0F,$F0,$00
           .byte  $00,$0F,$F0
L362B:     .byte  $04,$1C,$88,$00,$0A,$80,$00,$00
           .byte  $2A,$A0,$00,$00,$26,$60,$00,$00
           .byte  $E8,$AC,$00,$00,$EA,$AC,$00,$00
           .byte  $3F,$F0,$00,$00,$F0,$3C,$00,$00
           .byte  $CF,$CC,$00,$02,$FF,$FE,$00,$0A
           .byte  $AF,$EA,$80,$2A,$AA,$AA,$A0,$2A
           .byte  $AA,$AA,$A0,$2A,$AB,$AA,$A0,$2A
           .byte  $AF,$EA,$A0,$2A,$2F,$E2,$A0,$2A
           .byte  $8F,$CA,$A0,$0A,$BF,$FA,$80,$02
           .byte  $BF,$FA,$00,$00,$BF,$F8,$00,$02
           .byte  $BF,$FA,$00,$0A,$BD,$6A,$80,$2A
           .byte  $57,$DA,$A0,$2A,$7F,$DA,$A0,$2A
           .byte  $7F,$DA,$A0,$2A,$7D,$5A,$A0,$0A
           .byte  $57,$DA,$80,$3F,$7F,$DF,$F0,$3F
           .byte  $FF,$CF,$F0
L369E:     .byte  $04,$1C,$88,$02,$A0,$00,$00,$02
           .byte  $A8,$00,$00,$0F,$AA,$00,$00,$0F
           .byte  $FA,$00,$00,$07,$FA,$A0,$00,$3F
           .byte  $AA,$A8,$00,$FF,$BA,$AA,$00,$FF
           .byte  $BA,$AA,$80,$0F,$FA,$AA,$80,$F3
           .byte  $EA,$AA,$80,$3F,$EA,$AA,$A0,$0F
           .byte  $AA,$AA,$A0,$00,$AA,$8A,$A0,$00
           .byte  $AA,$AA,$A0,$00,$AA,$AA,$A0,$00
           .byte  $AA,$AA,$A0,$00,$AA,$2A,$A0,$00
           .byte  $A8,$AA,$A0,$00,$A8,$AA,$A0,$00
           .byte  $A2,$AA,$A0,$02,$A2,$AA,$80,$02
           .byte  $AA,$AA,$A0,$02,$8A,$AA,$A8,$02
           .byte  $AA,$AA,$AC,$0A,$AA,$2A,$AC,$3A
           .byte  $0A,$00,$AC,$3A,$3F,$00,$0C,$F8
           .byte  $3F,$00,$3C
L3711:     .byte  $04,$1C,$88,$00,$0A,$80,$00,$00
           .byte  $2A,$A0,$00,$00,$26,$60,$00,$00
           .byte  $E8,$AC,$00,$00,$EA,$AC,$00,$00
           .byte  $3F,$F0,$00,$00,$F0,$3C,$00,$00
           .byte  $CF,$CC,$00,$02,$FF,$FE,$00,$0A
           .byte  $AF,$EA,$80,$2A,$AA,$AA,$A0,$2A
           .byte  $AA,$AA,$A0,$2A,$AB,$AA,$A0,$2A
           .byte  $AF,$EA,$A0,$2A,$2F,$E2,$A0,$2A
           .byte  $8F,$CA,$A0,$0A,$BF,$FA,$80,$02
           .byte  $BF,$FA,$00,$00,$BF,$F8,$00,$02
           .byte  $BF,$FA,$00,$0A,$AF,$EA,$80,$2A
           .byte  $AB,$AA,$A0,$2A,$AA,$AA,$A0,$2A
           .byte  $AA,$AA,$A0,$2A,$AA,$AA,$A0,$0A
           .byte  $A0,$2A,$80,$3F,$C0,$0F,$F0,$3F
           .byte  $C0,$0F,$F0
L3784:     .byte  $04,$1C,$88,$00,$0A,$80,$00,$00
           .byte  $2A,$A0,$00,$00,$26,$60,$00,$00
           .byte  $E8,$AC,$00,$00,$EA,$AC,$00,$00
           .byte  $3F,$F0,$00,$00,$C4,$4C,$00,$00
           .byte  $C0,$0C,$00,$02,$F4,$7E,$00,$0A
           .byte  $BF,$FA,$80,$2A,$AF,$EA,$A0,$2A
           .byte  $AA,$AA,$A0,$2A,$AB,$AA,$A0,$2A
           .byte  $AF,$EA,$A0,$2A,$2F,$E2,$A0,$2A
           .byte  $8F,$CA,$A0,$0A,$BF,$FA,$80,$02
           .byte  $BF,$FA,$00,$00,$BF,$F8,$00,$02
           .byte  $BF,$FA,$00,$0A,$AF,$EA,$80,$2A
           .byte  $AB,$AA,$A0,$2A,$AA,$AA,$A0,$2A
           .byte  $AA,$AA,$A0,$2A,$AA,$AA,$A0,$0A
           .byte  $A0,$2A,$80,$3F,$C0,$0F,$F0,$3F
           .byte  $C0,$0F,$F0
L37F7:     .byte  $01,$09,$88,$08,$15,$15,$15,$15
           .byte  $08,$08,$08,$08,$08
L3804:     .byte  $02,$16,$88,$20,$A0,$08,$20,$0A
           .byte  $08,$02,$A0,$A0,$A0,$2A,$A8,$0A
           .byte  $A8,$05,$54,$04,$04,$04,$44,$04
           .byte  $04,$05,$54,$05,$54,$05,$14,$05
           .byte  $14,$05,$14,$05,$54,$05,$54,$04
           .byte  $54,$04,$54,$04,$04,$05,$54
L3833:     .byte  $01,$04,$88,$82,$AA,$82,$82
L383A:     .byte  $01,$05,$88,$24,$6A,$AA,$FF,$FF
L3842:     .byte  $01,$0C,$88,$20,$08,$02,$8A,$28
           .byte  $A8,$A8,$BE,$BE,$BE,$AA,$28
L3851:     .byte  $01,$0B,$88,$80,$20,$0A,$02,$28
           .byte  $AA,$BE,$BE,$BE,$AA,$28
L385F:     .byte  $01,$0E,$88,$A8,$A8,$50,$14,$24
           .byte  $20,$50,$14,$24,$20,$50,$14,$A8
           .byte  $A8
L3870:     .byte  $01,$0C,$88,$A8,$A8,$50,$14,$20
           .byte  $50,$14,$20,$50,$14,$A8,$A8
L387F:     .byte  $01,$09,$88,$A8,$A8,$54,$20,$54
           .byte  $20,$54,$A8,$A8
L388B:     .byte  $01,$05,$88,$A8,$A8,$54,$A8,$A8
L3893:     .byte  $01,$08,$88,$15,$55,$00,$00,$00
           .byte  $00,$55,$54
L389E:     .byte  $01,$08,$88,$2A,$AA,$AA,$AA,$AA
           .byte  $AA,$AA,$2A
L38A9:     .byte  $01,$06,$88,$AA,$AA,$BE,$BE,$AA
           .byte  $28
L38B2:     .byte  $01,$01,$88,$82
L38B6:     .byte  $01,$02,$88,$82,$82
L38BB:     .byte  $01,$02,$88,$80,$80
L38C0:     .byte  $01,$06,$88,$FF,$EB,$69,$69,$69
           .byte  $7D,$01,$04,$88,$41,$41,$41,$41
L38D0:     .byte  $01,$01,$80,$00
L38D4:     .byte  $01,$10,$80,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00
L38E7:     .byte  $02,$08,$88,$15,$00,$55,$40,$40
           .byte  $40,$40,$40,$40,$40,$40,$40,$55
           .byte  $40,$15,$00
L38FA:     .byte  $01,$07,$88,$04,$11,$11,$11,$11
           .byte  $04,$00
L3904:     .byte  $01,$05,$88,$04,$04,$00,$00,$00
L390C:     .byte  $02,$08,$88,$82,$08,$20,$20,$0A
           .byte  $80,$08,$A8,$A8,$80,$0A,$80,$20
           .byte  $20,$82,$08
L391F:     .byte  $01,$0F,$0F,$08,$2A,$2B,$AF,$AF
           .byte  $AC,$94,$1C,$1C,$5D,$57,$55,$55
           .byte  $30,$28
L3931:     .byte  $02,$07,$07,$00,$07,$00,$45,$57
           .byte  $45,$76,$47,$57,$44,$00,$74,$00
           .byte  $04
L3942:     .byte  $03,$03,$04,$8E,$AE,$80,$8C,$AC
           .byte  $80,$EE,$4E,$E0
L394E:     .byte  $03,$05,$04,$E8,$25,$77,$A8,$55
           .byte  $45,$E8,$72,$67,$88,$52,$46,$8E
           .byte  $52,$75
L3960:     .byte  $02,$08,$03,$00,$00,$DB,$BB,$92
           .byte  $AA,$D2,$B3,$52,$AA,$DB,$AB,$00
           .byte  $00,$00,$00
L3973:     .byte  $03,$05,$05,$E3,$22,$93,$94,$B2
           .byte  $94,$E4,$AA,$97,$94,$A6,$91,$E3
           .byte  $22,$66
L3985:     .byte  $02,$10,$03,$03,$EF,$99,$CD,$99
           .byte  $8F,$83,$CF,$9F,$CD,$9F,$CF,$0F
           .byte  $87,$FF,$FF,$03,$8F,$99,$25,$99
           .byte  $27,$83,$E7,$9F,$CD,$9F,$9F,$0F
           .byte  $07,$FF,$FF
L39A8:     .byte  $02,$0E,$02,$18,$30,$3C,$78,$7E
           .byte  $FC,$FF,$FE,$FF,$FE,$FF,$FE,$FF
           .byte  $FE,$7F,$FC,$3F,$F8,$1F,$F0,$0F
           .byte  $E0,$07,$C0,$03,$80,$01,$00
L39C7:     .byte  $02,$0E,$02,$18,$30,$3C,$78,$7C
           .byte  $7C,$FC,$7E,$FE,$7E,$FE,$7E,$FF
           .byte  $3E,$7F,$9C,$3E,$38,$1F,$30,$0F
           .byte  $80,$07,$C0,$03,$80,$01,$00
L39E6:     .byte  $02,$0E,$88,$01,$00,$05,$40,$19
           .byte  $90,$59,$94,$65,$64,$46,$44,$02
           .byte  $00,$02,$00,$02,$00,$02,$00,$02
           .byte  $00,$02,$20,$02,$A0,$00,$80
L3A05:     .byte  $03,$0E,$88,$02,$00,$00,$20,$88
           .byte  $00,$08,$00,$00,$04,$44,$00,$04
           .byte  $44,$00,$04,$44,$00,$04,$44,$00
           .byte  $3F,$FF,$00,$3F,$FF,$00,$3F,$FF
           .byte  $00,$2A,$AA,$00,$3F,$FF,$00,$3F
           .byte  $FF,$00,$55,$55,$40
L3A32:     .byte  $01,$06,$88,$14,$41,$55,$55,$55
           .byte  $55
L3A3B:     .byte  $01,$05,$88,$14,$14,$14,$14,$55
L3A43:     .byte  $03,$06,$80,$0C,$3F,$3F,$3C,$33
           .byte  $33,$FC,$33,$33,$3C,$33,$33,$3C
           .byte  $33,$33,$FF,$3F,$3F
L3A58:     .byte  $03,$06,$80,$FF,$3F,$3F,$C3,$33
           .byte  $33,$0F,$33,$33,$03,$33,$33,$C3
           .byte  $33,$33,$FF,$3F,$3F
L3A6D:     .byte  $03,$06,$80,$FF,$3F,$3F,$C0,$33
           .byte  $33,$FF,$33,$33,$03,$33,$33,$C3
           .byte  $33,$33,$FF,$3F,$3F
L3A82:     .byte  $03,$06,$80,$FF,$3F,$3F,$C3,$33
           .byte  $33,$3C,$33,$33,$C3,$33,$33,$C3
           .byte  $33,$33,$FF,$3F,$3F
L3A97:     .byte  $0B,$10,$02,$FF,$F8,$7F,$F8,$C0
           .byte  $0C,$F0,$30,$FF,$CC,$03,$FF,$FC
           .byte  $FF,$FC,$E0,$0C,$F0,$30,$FF,$CC
           .byte  $03,$F0,$1C,$E0,$1C,$F0,$0C,$F0
           .byte  $30,$C0,$0C,$03,$F0,$0C,$C0,$0C
           .byte  $F8,$0C,$F0,$70,$C0,$0C,$03,$F0
           .byte  $0C,$C0,$0C,$DC,$0C,$F0,$E0,$C0
           .byte  $0C,$03,$F0,$0C,$C0,$0C,$CE,$0C
           .byte  $F1,$C0,$C0,$0C,$03,$F0,$0C,$C7
           .byte  $8C,$C7,$0C,$F3,$80,$C0,$0C,$03
           .byte  $F0,$0C,$C7,$8C,$C3,$8C,$FF,$F8
           .byte  $FF,$CE,$07,$F0,$0C,$C7,$8C,$C1
           .byte  $CC,$FF,$FC,$FF,$C7,$0E,$F0,$0C
           .byte  $C7,$8C,$C0,$EC,$F0,$7C,$F0,$03
           .byte  $9C,$F0,$0C,$C0,$0C,$C0,$7C,$F0
           .byte  $3C,$F0,$01,$F8,$F0,$0C,$C0,$0C
           .byte  $C0,$3C,$F0,$3C,$F0,$00,$F0,$F0
           .byte  $0C,$C0,$0C,$C7,$9C,$F0,$3C,$F0
           .byte  $00,$F0,$F0,$1C,$E0,$1C,$C7,$8C
           .byte  $F0,$3C,$F0,$00,$F0,$FF,$FC,$FF
           .byte  $FC,$C7,$8C,$F0,$3C,$FF,$C0,$F0
           .byte  $FF,$F8,$7F,$F8,$C7,$8C,$F0,$3C
           .byte  $FF,$C0,$F0
L3B4A:     .byte  $08,$10,$02,$F0,$30,$7F,$F8,$C0
           .byte  $0C,$7F,$E0,$F0,$30,$FF,$FC,$E0
           .byte  $0C,$FF,$F0,$F0,$30,$E0,$1C,$F0
           .byte  $0C,$F8,$70,$F0,$70,$C0,$0C,$F8
           .byte  $0C,$F0,$30,$F0,$E0,$C0,$0C,$DC
           .byte  $0C,$F0,$30,$F1,$C0,$C0,$0C,$CE
           .byte  $0C,$F0,$30,$F3,$80,$C7,$8C,$C7
           .byte  $0C,$F0,$00,$FF,$F8,$C7,$8C,$C3
           .byte  $8C,$F0,$00,$FF,$FC,$C7,$8C,$C1
           .byte  $CC,$F0,$00,$F0,$7C,$C7,$8C,$C0
           .byte  $EC,$F1,$FC,$F0,$3C,$C0,$0C,$C0
           .byte  $7C,$F1,$FC,$F0,$3C,$C0,$0C,$C0
           .byte  $3C,$F0,$3C,$F0,$3C,$C0,$0C,$C0
           .byte  $1C,$F0,$3C,$F0,$3C,$E0,$1C,$C0
           .byte  $0C,$F8,$7C,$F0,$3C,$FF,$FC,$C0
           .byte  $0C,$FF,$FC,$F0,$3C,$7F,$F8,$C0
           .byte  $0C,$7F,$F8
        
L3BCD:     .word  L38D0,L3842,L3851,L3538,L3543,L354E,L3559,L3566
           .word  L357B,L3590,L35A5,L3450,L3462,L3474,L3486,L3498
           .word  L34AD,L34EF,L34CC,L38E7,L38FA,L3904,L390C,L385F
           .word  L3870,L387F,L388B,L3833,L3510,L351F,L3528,L352F
           .word  L37F7,L35B8,L362B,L369E,L3711,L3784,L3804,L38B2
           .word  L38B6,L38BB,L391F,L3931,L39A8,L39C7,L394E,L3973
           .word  L3985,L38C0,L3893,L389E,L3942,L383A,L39E6,L3A05
           .word  L3A32,L3A3B,L3A43,L3A58,L3A58,L3960,L3A6D,L38D4
           .word  L38A9,L3A82,L3A97,L3B4A
                
L3C55:     lda    #$00
           sta    $CF
           sta    $D0
           sta    $D1
           sta    $D2
           lda    #<L3D18
           sta    IRQVEC
           lda    #>L3D18
           sta    IRQVEC+1
           lda    #$A0
           sta    VIA2+$E
           lda    #$80
           sta    VIA2+$9
           cli
           rts

           lda    $CF
           bne    L3CA5
L3C79:     lda    #$00
           sta    $0125
           jmp    L3CB8

           lda    $D0
           bne    L3CA5
L3C85:     lda    #$01
           sta    $0125
           jmp    L3CB8

L3C8D:     lda    $D1
           bne    L3CA5
L3C91:     lda    #$02
           sta    $0125
           jmp    L3CB8

           lda    $CF
           bne    L3CA5
L3C9D:     lda    #$03
           sta    $0125
           jmp    L3CB8

L3CA5:     pla
           sta    $0122
           pla
           sta    $0123
           pla
           pla
           lda    $0123
           pha
           lda    $0122
           pha
           rts

L3CB8:     sei
           pla
           sta    $0122
           pla
           sta    $0123
           pla
           sta    $CD
           pla
           sta    $CE
           lda    $0123
           pha
           lda    $0122
           pha
           txa
           pha
           ldx    $0125
           lda    $CD
           sta    $D3,x
           lda    $CE
           sta    $CF,x
           lda    #$01
           sta    $D7,x
           lda    #$00
           sta    $DB,x
           cli
           pla
           tax
           rts

L3CE8:     sei
           lda    #$00
           sta    VIC+$A
           sta    VIC+$B
           sta    VIC+$C
           sta    VIC+$D
           sta    $CF
           sta    $D0
           sta    $D1
           sta    $D2
           cli
           rts

L3D01:     jsr    L209D
           jsr    LA3D5
           lda    $CF
           bne    L3D01
           lda    $D0
           bne    L3D01
           lda    $D1
           bne    L3D01
           lda    $D2
           bne    L3D01
           rts

        ;; IRQ routine to play audio
L3D18:     nop
           lda    #$80
           sta    VIA2+$9
           ldx    #$03          ; iterate over all 4 voices
L3D20:     lda    $D3,x         ; get music command sequence low for this voice
           sta    $CD
           lda    $CF,x         ; get music command sequence high for this voice
           sta    $CE
           beq    L3D76         ; if address high is 0 then skip voice
           dec    $D7,x         ; decrement duration counter for current note
           bne    L3D76         ; if >0 then wait longer until next command
           ldy    $DB,x         ; get index into sequence
L3D30:     lda    ($CD),y       ; get next music command
           iny
           cmp    #$00          ; is it end-of-sequence?
           bne    L3D41         ; jump if not
           lda    #$00
           sta    $CF,x         ; set sequence address high to 0 (end-of-sequence)
           sta    VIC+$A,x      ; turn off voice
           jmp    L3D76         ; done with this voice

L3D41:     cmp    #$01          ; "set volume" command?
           bne    L3D53         ; branch if not
           lda    VIC+$E
           and    #$F0
           ora    ($CD),y       ; get volume value
           iny
           sta    VIC+$E        ; set volume
           jmp    L3D30         ; next sequence command

L3D53:     cmp    #$02          ; "jump to other sequence" command?
           bne    L3D6C         ; branch if not
           lda    ($CD),y       ; get new sequence low byte
           iny
           sta    $D3,x         ; store low byte
           lda    ($CD),y       ; get new sequence high byte
           iny
           sta    $CF,x         ; store high byte
           lda    #$01
           sta    $D7,x         ; init "duration" counter to immediately process next command
           lda    #$00
           sta    $DB,x         ; init index into sequence
           jmp    L3D20         ; go to sequence

L3D6C:     sta    VIC+$A,x      ; otherwise "set note" command => set pitch
           lda    ($CD),y       ; get duration
           iny
           sta    $D7,x         ; set duration counter
           sty    $DB,x
L3D76:     dex                  ; next voice
           bpl    L3D20         ; loop through voices 3-0
           pla
           tay
           pla
           tax
           pla
           rti

L3D7F:     .byte  $01,$08,$AF,$30,$B7,$10,$BB,$20
           .byte  $AF,$20,$D7,$02,$D4,$02,$D7,$02
           .byte  $D4,$02,$D7,$02,$D4,$02,$D7,$02
           .byte  $D4,$02,$D7,$02,$D4,$02,$D7,$02
           .byte  $D4,$02,$D7,$02,$D4,$02,$D7,$02
           .byte  $D4,$02,$D7,$30,$00
L3DAC:     .byte  $E1,$30,$E4,$10,$E5,$20,$E1,$20
           .byte  $03,$20,$EB,$30,$00
L3DB9:     .byte  $01,$08,$DB,$04,$03,$04,$DD,$04
           .byte  $E1,$08,$03,$08,$E4,$04,$E8,$04
           .byte  $E3,$04,$E4,$08,$03,$04,$D7,$04
           .byte  $03,$04,$EB,$04,$03,$04,$E8,$04
           .byte  $E4,$04,$03,$04,$E1,$04,$03,$04
           .byte  $E1,$04,$E8,$04,$03,$04,$E1,$04
           .byte  $E4,$04,$03,$04,$DD,$08,$03,$08
           .byte  $AF,$04,$B7,$04,$BB,$08,$00
L3DF8:     .byte  $E8,$04,$03,$04,$EB,$04,$ED,$08
           .byte  $03,$08,$D1,$04,$03,$04,$C9,$04
           .byte  $03,$08,$03,$04,$D7,$04,$03,$04
           .byte  $C9,$04,$03,$04,$D7,$04,$03,$04
           .byte  $C9,$04,$C3,$04,$03,$04,$D1,$04
           .byte  $03,$04,$D7,$04,$03,$04,$C9,$04
           .byte  $03,$04,$D1,$04,$03,$08,$C3,$04
           .byte  $C9,$04,$03,$04,$BB,$03,$00
L3E37:     .byte  $01,$08,$E4,$02,$E7,$02,$E9,$02
           .byte  $EB,$02,$EF,$08,$EB,$08,$00
L3E46:     .byte  $01,$0F,$B7,$02,$01,$0A,$AF,$02
           .byte  $01,$08,$87,$02,$01,$08,$00
L3E55:     .byte  $01,$0F,$87,$02,$8F,$02,$03,$02
           .byte  $00
L3E5E:     .byte  $01,$0F,$80,$0F,$03,$02,$80,$0F
           .byte  $03,$02,$80,$0F,$01,$08,$00
L3E6D:     .byte  $01,$08
L3E6F:     .byte  $DD,$08,$03,$08,$E4,$08
           .byte  $03,$08,$E8,$04,$EB,$04,$E8,$04
           .byte  $03,$04,$02,<L3E6F,>L3E6F
L3E82:     .byte  $01,$04,$E5,$01,$E4,$01,$01,$08
           .byte  $03,$04,$00
L3E8D:     .byte  $EE,$02,$ED,$02,$EE,$02,$ED,$02
           .byte  $EE,$02,$ED,$02,$EE,$02,$ED,$02
           .byte  $00
L3E9E:     .byte  $E8,$02,$E7,$02,$E4,$02,$E1,$02
           .byte  $DF,$02,$DB,$02,$D7,$02,$D1,$02
           .byte  $CF,$02,$C9,$02,$C3,$02,$BF,$02
           .byte  $B7,$02,$AF,$02,$A3,$02,$03,$10
L3EBE:     .byte  $E8,$02,$E3,$02,$E7,$02,$E1,$02
           .byte  $E5,$02,$DF,$02,$E4,$02,$DD,$02
           .byte  $E3,$02,$DB,$02,$E1,$02,$D9,$02
           .byte  $E4,$02,$DD,$02,$E3,$02,$DB,$02
           .byte  $E1,$02,$D9,$02,$DF,$02,$D7,$02
           .byte  $03,$06,$D1,$10,$A3,$10,$BB,$14
           .byte  $00
L3EEF:     .byte  $01,$08,$C9,$02,$CF,$02,$D1,$02
           .byte  $D7,$02,$DB,$02,$DF,$02,$E1,$02
           .byte  $E4,$02,$E7,$02,$E8,$02,$EB,$02
           .byte  $ED,$02,$EF,$02,$F0,$02
           .byte  $02,<L3E37,>L3E37
L3F10:     .byte  $DD,$03,$03,$03,$DD,$01,$03,$01
           .byte  $DD,$01,$03,$01,$E4,$06,$DD,$06
           .byte  $E4,$06
L3F22:     .byte  $DD,$06,$E4,$03,$03,$03,$E4,$03
           .byte  $03,$03,$E4,$03,$03,$03,$E4,$01
           .byte  $03,$01,$E4,$01,$03,$01,$E8,$06
           .byte  $E4,$06,$E8,$06,$E4,$06,$DD,$03
           .byte  $03,$03,$DD,$06,$02,<L3F10,>L3F10
L3F49:     .byte  $E1,$04,$E4,$04,$03,$04,$E8,$04
           .byte  $03,$04,$E4,$04,$E1,$04,$E4,$04
           .byte  $DD,$04,$03,$04,$03,$10,$00
L3F60:     .byte  $01,$08,$D1,$04,$03,$04,$C3,$04
           .byte  $03,$04,$D1,$04,$03,$04,$C3,$04
           .byte  $03,$04,$BB,$04,$03,$04,$C3,$02
           .byte  $C9,$02,$CB,$02,$D1,$02,$D7,$02
           .byte  $DB,$02,$DD,$02,$00
L3F85:     .byte  $EE,$01,$ED,$01,$EF,$01,$EE,$01
           .byte  $EF,$01,$EE,$01,$EF,$02,$EE,$02
           .byte  $00
L3F96:     .byte  $E4,$04,$E7,$04,$E9,$04,$E4,$04
           .byte  $03,$04,$E4,$04,$E7,$04,$E9,$04
           .byte  $E4,$04,$00
L3FA9:     .byte  $ED,$04,$EF,$04,$F1,$04,$ED,$04
           .byte  $03,$04,$ED,$04,$EF,$04,$F1,$04
           .byte  $ED,$04,$00
L3FBC:     .byte  $E7,$03,$03,$01,$E3,$03,$03,$01
           .byte  $DB,$03,$03,$01,$02,<L3FBC,>L3FBC
L3FCB:     .byte  $00,$B7,$86,$F7,$86,$35,$06,$75
           .byte  $04,$3D,$0C,$75,$04,$31,$04,$35
           .byte  $04,$75,$0C,$35,$04,$46,$D6,$C6
           .byte  $F5,$46,$77,$E7,$F7,$06,$7F,$CE
           .byte  $D7,$86,$F7,$46,$F7,$6D,$75,$4A
           .byte  $71,$06,$78,$44,$65,$64,$71,$64
           .byte  $75,$0C,$75,$6D,$75

           .segment "CRT2"

           .word  ENTRY,ENTRY
           .byte  $41,$30,$C3,$C2,$CD

           ;; ??? [unused?]
           .byte  $02,$BB,$5A,$30,$5F,$EE,$3D,$A8

ENTRY:     lda    #$10
           sta    $0116
           lda    #$27
           sta    $0117
           lda    #$8C
           sta    $0118
           lda    #$00
           sta    $E6
           sta    $E7
           sta    $EA
           sta    $011F
           sta    $0120
           sta    $0128
           jsr    LA3C6
           lda    #$01
           sta    $F0
           sta    $F1
           sta    $F2
           jsr    LB2AC
           jsr    LB224         ; init VIC/VIA
           jsr    L206A
           jsr    L3C55
           lda    #$00
           sta    $0124
LA04D:     ldx    #$FF
           txs
LA050:     jsr    L3CE8
           lda    #$00
           sta    $EB
           jsr    LB2AC
           jsr    LA762
           lda    #$8C
           jsr    L2109
           lda    #$00
           sta    $EB
           ldx    #$FF
           txs
           jsr    LA853
           lda    #$0A
           jsr    L2109
           jmp    LA050

LA074:     ldx    #$FF
           txs
           jsr    L3CE8
           lda    #$01
           sta    $EB
           lda    #$00
           sta    $E7
           jsr    LA2B1
LA085:     jsr    LA3D5
           jsr    L209D
           jsr    L2000
           jmp    LA085

LA091:     jsr    L3CE8
           lda    #$02
           sta    $EB
           lda    #$00
           sta    $E7
           jsr    LB2AC
           lda    $F0
           sta    $F1
           lda    #$03
           sta    $B4
           jsr    LAAAC
           jsr    LA1C2
           jsr    LA5AF
           jsr    LA56F
           jsr    LA60E
           lda    #$78
           pha
           lda    #$10
           pha
           lda    #>LA0E4
           pha
           lda    #<LA0E4
           pha
           lda    #$07
           sta    $82
           jsr    LA7D0
           lda    #$70
           pha
           lda    #$10
           pha
           lda    #>LA35F
           pha
           lda    #<LA35F
           pha
           jsr    LA7D0
LA0D8:     jsr    LA3D5
           jsr    L209D
           jsr    L2000
           jmp    LA0D8

LA0E4:     .byte  "F5 -- SET OPTIONS", 0
        
LA0F6:     ldx    #$FF
           txs
           jsr    L3CE8
           lda    #$03
           sta    $EB
           lda    $F0
           sta    $F1
           sta    $F2
           jsr    LA3C6
           lda    #$03
           sta    $EC
           sta    $ED
           sta    $B4
           lda    #$00
           sta    $E7
           sta    $E8
           sta    $E9
           sta    $CB
           sta    $CC
LA11D:     ldx    $E7
           lda    #$00
           sta    $E8,x
LA123:     ldx    $E7
           lda    $F1,x
           asl    a
           tax
           lda    LA1EB-2,x
           sta    $C7
           lda    LA1EB-1,x
           sta    $C8
           ldx    $E7
           lda    $E8,x
           tay
           lda    ($C7),y
           beq    LA187
           asl    a
           tax
           lda    LA20E-2,x
           sta    $97
           lda    LA20E-1,x
           sta    $98
           jsr    LA9D4
           jsr    LA1AC
           php
           jsr    LA541
           plp
           bcc    LA175
           lda    #>L3FCB
           pha
           lda    #<L3FCB
           pha
           jsr    L3C79
           jsr    L3D01
           lda    $B4
           bne    LA168
           jsr    LA24B
LA168:     jsr    LA1D4
           lda    $B4
           bne    LA172
           jmp    LA216

LA172:     jmp    LA123

LA175:     jsr    L3D01
           jsr    LA518
           jsr    L2107
           inc    $B4
           ldx    $E7
           inc    $E8,x
           jmp    LA123

LA187:     lda    #>L3DF8
           pha
           lda    #<L3DF8
           pha
           jsr    L3C85
           lda    #>L3DB9
           pha
           lda    #<L3DB9
           pha
           jsr    L3C91
           jsr    L3D01
           ldx    $E7
           lda    $F1,x
           cmp    #$05
           beq    LA1A9
           clc
           adc    #$01
           sta    $F1,x
LA1A9:     jmp    LA11D

LA1AC:     jsr    LA1C2
           lda    #>L3E6D
           pha
           lda    #<L3E6D
           pha
           jsr    L3C79
           lda    #$00
           sta    $EA
           sta    $0128
           jmp    ($97)

LA1C2:     ldx    $E7
           lda    $F1,x
           tax
           lda    LA1CF-1,x
           ldx    $E7
           sta    $E4,x
           rts

LA1CF:     .byte  $50,$60,$70,$80,$80
        
LA1D4:     lda    $E6
           beq    LA1EA
           ldx    $E7
           lda    $B4
           sta    $EC,x
           txa
           eor    #$01
           tax
           lda    $EC,x
           beq    LA1EA
           stx    $E7
           sta    $B4
LA1EA:     rts

LA1EB:     .word  LA1F5,LA1F8,LA1FC,LA201,LA207
LA1F5:     .byte  $01,$02,$00
LA1F8:     .byte  $01,$03,$02,$00
LA1FC:     .byte  $01,$04,$03,$02,$00
LA201:     .byte  $01,$04,$01,$03,$02,$00
LA207:     .byte  $01,$04,$01,$03,$01,$02,$00
        
LA20E:     .word  LAB3F,LAD86,LAFDD,LB153
        
LA216:     jsr    LA585
           lda    #$05
           sta    $EB
           lda    #$78
           pha
           lda    #$10
           pha
           lda    #>LA0E4
           pha
           lda    #<LA0E4
           pha
           lda    #$07
           sta    $82
           jsr    LA7D0
           lda    #$70
           pha
           lda    #$10
           pha
           lda    #>LA35F
           pha
           lda    #<LA35F
           pha
           jsr    LA7D0
LA23F:     jsr    L209D
           jsr    LA3D5
           jsr    L2000
           jmp    LA23F

LA24B:     lda    #$07
           sta    $82
           lda    #$60
           pha
           lda    #$30
           pha
           lda    #>LA28F
           pha
           lda    #<LA28F
           pha
           jsr    LA7D0
           lda    #$30
           sta    $9B
           lda    #$68
           sta    $9C
           lda    #<LA758
           sta    $7C
           lda    #>LA758
           sta    $7D
           lda    $E6
           beq    LA286
           lda    #<LA299
           sta    $7C
           lda    #>LA299
           sta    $7D
           lda    $E7
           beq    LA286
           lda    #<LA2A3
           sta    $7C
           lda    #>LA2A3
           sta    $7D
LA286:     jsr    LA7EC
           lda    #$1E
           jsr    L2109
           rts

LA28F:     .byte  $47,$41,$4D,$45,$20,$4F,$56,$45,$52,$00
LA299:     .byte  $50,$4C,$41,$59,$45,$52,$20,$31,$20,$00
LA2A3:     .byte  $50,$4C,$41,$59,$45,$52,$20,$32,$20,$00
LA2AD:     .byte  $05,$32,$19,$36
        
LA2B1:     jsr    LB2AC
           lda    #<LA3A7
           sta    $A9
           lda    #>LA3A7
           sta    $AA
           jsr    LB326
           jsr    LA585
           lda    #$05
           sta    $82
           lda    #$70
           pha
           lda    #$10
           pha
           lda    #>LA35F
           pha
           lda    #<LA35F
           pha
           jsr    LA7D0
           lda    #$90
           pha
           lda    #$10
           pha
           lda    #>LA395
           pha
           lda    #<LA395
           pha
           jsr    LA7D0
LA2E4:     jsr    LA5AF
           jsr    LA60E
           lda    #$05
           sta    $82
           lda    #$80
           pha
           lda    #$10
           pha
           lda    $E6
           bne    LA301
           lda    #>LA371
           pha
           lda    #<LA371
           pha
           jmp    LA307

LA301:     lda    #>LA383
           pha
           lda    #<LA383
           pha
LA307:     jsr    LA7D0
           lda    #$80
           sta    $82
           lda    #$A0
           pha
           lda    #$10
           pha
           lda    #>LA756
           pha
           lda    #<LA756
           pha
           jsr    LA7D0
           lda    #$10
           sta    $9B
           lda    #$A8
           sta    $9C
           jsr    LA7EC
           lda    $F0
           asl    a
           tax
           lda    LA1EB-2,x
           sta    $C7
           lda    LA1EB-1,x
           sta    $C8
           lda    #$00
           sta    $F8
           lda    #$10
           sta    $9B
           lda    #$B0
           sta    $9C
LA342:     ldy    $F8
           lda    ($C7),y
           beq    LA35E
           tax
           lda    LA2AD-1,x
           tax
           lda    #$00
           jsr    LB772
           lda    $9B
           clc
           adc    #$10
           sta    $9B
           inc    $F8
           jmp    LA342
LA35E:     rts

LA35F:     .byte  "F1 -- START      ", 0
LA371:     .byte  "F3 -- TWO PLAYERS", 0
LA383:     .byte  "F3 -- ONE PLAYER ", 0
LA395:     .byte  "F5 -- SKILL LEVEL", 0
           
        
LA3A7:     .byte  $31,$00,$10,$00,$FF
           .byte  $35,$92,$16,$00,$FF
           .byte  $2F,$90,$1F,$00,$FF
LA3B6:     .byte  $22,$48,$40,$00,$FF
           .byte  $43,$08,$60,$00,$FF
           .byte  $44,$68,$60,$00,$FF
           .byte  $FF
        
LA3C6:     lda    #$00
           sta    $E0
           sta    $E1
           sta    $E2
           sta    $E3
           sta    $E4
           sta    $E5
           rts

LA3D5:     lda    #$C1
           sta    VIA2+$3
           lda    #$7F
           sta    VIA2+$F
           lda    #$10
           bit    VIA2+$0
           bne    LA40B
           jsr    LA4BE         ; F1 pressed
           ldx    $EB
           lda    LA3FD,x
           asl    a
           tax
           lda    LA403,x
           sta    $97
           lda    LA403+1,x
           sta    $98
           jmp    ($97)

LA3FD:     .byte  $01,$02,$03,$02,$02,$02
LA403:     .word  LA04D,LA074,LA091,LA0F6
        
LA40B:     lda    $EB
           cmp    #$01
           bne    LA426         ; igore if game running
           lda    #$20
           bit    VIA2+$0
           bne    LA426
           lda    $E6           ; F3 pressed
           eor    #$01
           and    #$01
           sta    $E6
           jsr    LA2E4
           jsr    LA4BE
LA426:     lda    #$40
           bit    VIA2+$0
           bne    LA44E
           lda    $EB           ; F5 pressed
           cmp    #$01
           bne    LA448         ; go to settings if game running
           inc    $F0           ; increment skill level
           lda    $F0
           cmp    #$06
           bcc    LA43F
           lda    #$01
           sta    $F0
LA43F:     jsr    LA2E4
           jsr    LA4BE
           jmp    LA44E

LA448:     jsr    LA4BE
           jmp    LA074

LA44E:     lda    #$04
           bit    VIA2+$0
           bne    LA46F
           lda    #$BF
           sta    VIA2+$F
           lda    #$10
           ldx    VIC+$0
           bit    VIA2+$0
           bne    LA468
           dex
           jmp    LA469
LA468:     inx
LA469:     txa
           and    #$0F
           sta    VIC+$0
LA46F:     lda    #$FE
           sta    VIA2+$F
           lda    VIA2+$0
           sta    $0127
           and    #$10
           bne    LA4AC
           jsr    LA4DF
           lda    $EB
           cmp    #$03
           bne    LA4A0
           sei
           lda    #$00
           sta    VIC+$A
           sta    VIC+$B
           sta    VIC+$C
           sta    VIC+$D
           lda    #$04
           sta    $EB
           jsr    LA4BE
           jmp    LA4AC

LA4A0:     cmp    #$04
           bne    LA4AC
           lda    #$03
           sta    $EB
           cli
           jsr    LA4BE
LA4AC:     lda    #$00
           sta    VIA2+$3
           lda    $EB
           cmp    #$04
           beq    LA4B8
           rts

LA4B8:     jsr    L209D
           jmp    LA3D5

LA4BE:     lda    #$10
           sta    $0116
           lda    #$27
           sta    $0117
           lda    #$8C
           sta    $0118
           jsr    LA4DF
           ldx    #$64
LA4D2:     lda    VIA2+$0
           and    #$70
           eor    #$70
           bne    LA4BE
           dex
           bne    LA4D2
           rts

LA4DF:     lda    #$18
           sta    VIC+$1
           lda    #$0B
           sta    VIC+$F
           rts

LA4EA:     lda    $C4
           bne    LA50B
           ldx    $E7
           lda    $E4,x
           cmp    #$10
           bne    LA4FF
           lda    #>L3FBC
           pha
           lda    #<L3FBC
           pha
           jsr    L3C79
LA4FF:     lda    #$14
           sta    $C4
           jsr    LA6AC
           bne    LA50B
           jsr    LBF36
LA50B:     dec    $C4
           lda    #$80
           sta    $82
           jsr    LA5DF
           jsr    LA56F
           rts

LA518:     jsr    LA6AC
           bcc    LA540
           lda    $E7
           asl    a
           tay
           sed
           lda    #$01
           clc
           adc    $E0,y
           sta    $E0,y
           lda    $E1,y
           adc    #$00
           sta    $E1,y
           cld
           jsr    LA729
           jsr    LA5AF
           jsr    LA56F
           jmp    LA518

LA540:     rts

LA541:     lda    $E7
           asl    a
           tax
           lda    $0120
           cmp    $E1,x
           beq    LA54E
           bcs    LA56E
LA54E:     bcc    LA564
           lda    $011F
           cmp    $E0,x
           beq    LA559
           bcs    LA56E
LA559:     bcc    LA564
           lda    $011F
           cmp    $E0,x
           beq    LA564
           bcs    LA56E
LA564:     lda    $E0,x
           sta    $011F
           lda    $E1,x
           sta    $0120
LA56E:     rts

LA56F:     lda    #$80
           sta    $82
           ldx    $E7
           lda    #$90
           sta    $9B
           lda    #$08
           sta    $9C
           lda    $E4,x
           jsr    LA661
           jmp    LA65F

LA585:     lda    #$07
           sta    $82
           lda    #$00
           pha
           lda    #$60
           pha
           lda    #>LA74B
           pha
           lda    #<LA74B
           pha
           jsr    LA7D0
           lda    #$80
           sta    $9B
           lda    #$08
           sta    $9C
           lda    $0120
           jsr    LA661
           lda    $011F
           jsr    LA661
           jmp    LA65F

LA5AF:     lda    $E6
           bne    LA5D0
           lda    #$00
           sta    $9B
           lda    #$08
           sta    $9C
           ldx    #$3E
           lda    #$00
           jsr    LB772
           lda    #<LA759
           sta    $7C
           lda    #>LA759
           sta    $7D
           jsr    LA7EC
           jmp    LA5DF

LA5D0:     lda    #$00
           sta    $9B
           lda    #$10
           sta    $9C
           ldx    #$31
           lda    #$00
           jsr    LB772
LA5DF:     lda    #$10
           sta    $9B
           lda    #$00
           sta    $9C
           lda    $E1
           jsr    LA661
           lda    $E0
           jsr    LA661
           jsr    LA65F
           lda    $E6
           bne    LA5F9
           rts

LA5F9:     lda    #$10
           sta    $9B
           lda    #$08
           sta    $9C
           lda    $E3
           jsr    LA661
           lda    $E2
           jsr    LA661
           jmp    LA65F

LA60E:     lda    #$04
           sta    $82
           lda    #$A8
           sta    $9B
           lda    #$10
           sta    $9C
           lda    $F0
           ldx    $EB
           cpx    #$01
           beq    LA626
           ldx    $E7
           lda    $F1,x
LA626:     jsr    LA66D
           lda    $E6
           beq    LA64C
           lda    #$90
           sta    $9B
           lda    #$1F
           sta    $9C
           lda    #$00
           ldx    #$2F
           jsr    LB772
           lda    #$A8
           sta    $9B
           lda    #$18
           sta    $9C
           lda    $E7
           clc
           adc    #$01
           jmp    LA66D

LA64C:     lda    #$90
           sta    $9B
           lda    #$18
           sta    $9C
           lda    #<LA75D
           sta    $7C
           lda    #>LA75D
           sta    $7D
           jmp    LA7EC

LA65F:     lda    #$00
LA661:     pha
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           clc
           adc    #$30
           jsr    LA675
           pla
LA66D:     and    #$0F
           clc
           adc    #$30
           jmp    LA675

LA675:     sta    $C5
           tya
           pha
           jsr    LB857
           lda    #(>CHARROM+$8)/8
           sta    $C6
           asl    $C5
           rol    $C6
           asl    $C5
           rol    $C6
           asl    $C5
           rol    $C6
           ldy    #$07
LA68E:     lda    ($C5),y
           sta    ($7A),y
           sty    $87
           jsr    LB5C7
           ldy    $87
           dey
           bpl    LA68E
           lda    $9B
           clc
           adc    #$08
           sta    $9B
           lda    $9C
           adc    #$00
           sta    $9C
           pla
           tay
           rts

LA6AC:     ldx    $E7
           lda    $E4,x
           bne    LA6B6
           lda    #$01
           clc
           rts

LA6B6:     sed
           lda    $E4,x
           sec
           sbc    #$01
           sta    $E4,x
           cld
           sec
           rts

           lda    #$08
           jmp    LA6D7

           lda    #$05
           jmp    LA6D7

LA6CB:     lda    #$03
           jmp    LA6D7

           lda    #$02
           jmp    LA6D7

LA6D5:     lda    #$01
LA6D7:     sta    $96
           lda    #>L3E37
           pha
           lda    #<L3E37
           pha
           jsr    L3C91
           txa
           pha
           lda    $E7
           asl    a
           tay
           lda    $96
           sed
           clc
           adc    $E0,y
           sta    $E0,y
           lda    $E1,y
           adc    #$00
           sta    $E1,y
           cld
           lda    $EA
           bne    LA723
           lda    $02
           sec
           sbc    #$08
           sta    $EE
           sta    $9B
           lda    $03
           sec
           sbc    #$10
           sta    $EF
           sta    $9C
           lda    $96
           clc
           adc    #$3A
           sta    $0121
           tax
           lda    #$20
           jsr    LB352
           lda    #$04
           sta    $EA
LA723:     jsr    LA729
           pla
           tax
           rts

LA729:     lda    $E7
           asl    a
           tay
           lda    $E1,y
           bne    LA739
           lda    $E0,y
           cmp    #$70
           bcc    LA74A
LA739:     ldy    $E7
           lda    $CB,y
           bne    LA74A
           lda    #$FF
           sta    $CB,y
           inc    $B4
           jsr    L202E
LA74A:     rts

LA74B:     .byte  "HIGH SCORE", 0

        ;; various amounts of spaces
LA756:     .byte  $20,$20
LA758:     .byte  $20
LA759:     .byte  $20,$20,$20,$20
LA75D:     .byte  $20,$20,$20,$20,$00
        
LA762:     jsr    LB2AC
           lda    #<LA3B6
           sta    $A9
           lda    #>LA3B6
           sta    $AA
           jsr    LB326
           lda    #$04
           sta    $82
           lda    #$08
           pha
           lda    #$10
           pha
           lda    #>LA7FE
           pha
           lda    #<LA7FE
           pha
           jsr    LA7D0
           lda    #$05
           sta    $82
           lda    #$70
           pha
           lda    #$28
           pha
           lda    #>LA811
           pha
           lda    #<LA811
           pha
           jsr    LA7D0
           lda    #$07
           sta    $82
           lda    #$80
           pha
           lda    #$20
           pha
           lda    #>LA846
           pha
           lda    #<LA846
           pha
           jsr    LA7D0
           lda    #$04
           sta    $82
           lda    #$90
           pha
           lda    #$08
           pha
           lda    #>LA81D
           pha
           lda    #<LA81D
           pha
           jsr    LA7D0
        
           lda    #$06
           sta    $82
           lda    #$B0
           pha
           lda    #$08
           pha
           lda    #>LA831
           pha
           lda    #<LA831
           pha
           jsr    LA7D0
        
           rts

LA7D0:     pla
           sta    $0122
           pla
           sta    $0123
           pla
           sta    $7C
           pla
           sta    $7D
           pla
           sta    $9B
           pla
           sta    $9C
           lda    $0123
           pha
           lda    $0122
           pha
LA7EC:     tya
           pha
           ldy    #$00
LA7F0:     lda    ($7C),y
           beq    LA7FB
           jsr    LA675
           iny
           jmp    LA7F0
LA7FB:     pla
           tay
           rts

LA7FE:     .byte  "ATARISOFT PRESENTS",0
LA811:     .byte  "BY NINTENDO",0
LA81D:     .byte  "ALL RIGHTS RESERVED",0
LA831:     .byte  "PRESS F1 FOR OPTIONS",0
LA846:     .byte  "(C)1981,1983",0
        
LA853:     jsr    L3CE8
           lda    #>L3DAC
           pha
           lda    #<L3DAC
           pha
           jsr    L3C79
           lda    #>L3D7F
           pha
           lda    #<L3D7F
           pha
           jsr    L3C91
           jsr    LB2AC
           jsr    LA585
           jsr    LA5AF
           lda    #<LA8F6
           sta    $A9
           lda    #>LA8F6
           sta    $AA
           jsr    LB2D9
           sty    $95
           lda    $A9
           clc
           adc    $95
           sta    $A9
           lda    $AA
           adc    #$00
           sta    $AA
           jsr    L3D01
LA88E:     jsr    L2107
           lda    #>L3E46
           pha
           lda    #<L3E46
           pha
           jsr    L3C9D
           lda    #$8C
           sta    $0118
           jsr    LB2D9
           sty    $95
           lda    $A9
           clc
           adc    $95
           sta    $A9
           lda    $AA
           adc    #$00
           sta    $AA
           ldy    #$00
           lda    ($A9),y
           cmp    #$FF
           bne    LA88E
           lda    #>L3E5E
           pha
           lda    #<L3E5E
           pha
           jsr    L3C79
           jsr    L3D01
           lda    #$03
           sta    $B4
           lda    #$00
           sta    $E7
           lda    #$05
           sta    $F1
           sta    $F2
           lda    $0124
           asl    a
           tax
           lda    LA20E,x
           sta    $97
           lda    LA20E+1,x
           sta    $98
           lda    #$3C
           sta    $0118
           inc    $0124
           lda    $0124
           and    #$03
           sta    $0124
           jsr    LA1AC
           rts

LA8F6:     .byte  $1D,$10,$C0,$00,$10,$00,$09
           .byte      $10,$A2,$00,$10,$00,$08
           .byte      $20,$86,$00,$10,$00,$08
           .byte      $10,$6A,$00,$10,$00,$08
           .byte      $20,$4D,$00,$10,$00,$08
           .byte      $10,$36,$00,$10,$00,$08,$FF
           .byte  $25,$10,$30,$00,$00,$00,$01,$FF
           .byte  $2B,$80,$30,$80,$00,$00,$01,$FF
           .byte  $FF
        
           .byte  $25,$10,$30,$20,$00,$00,$01,$FF
           .byte  $22,$20,$30,$00,$00,$00,$01,$FF
           .byte  $1D,$20,$4D,$20,$10,$00,$08
           .byte      $20,$54,$00,$10,$FF,$08,$FF
           .byte  $FF
        
           .byte  $22,$20,$30,$20,$00,$00,$01,$FF
           .byte  $22,$30,$30,$A0,$00,$00,$01,$FF
           .byte  $1D,$10,$6A,$20,$10,$00,$08
           .byte      $10,$6A,$20,$10,$01,$08,$FF
           .byte  $FF
        
           .byte  $22,$30,$30,$A0,$00,$00,$01,$FF
           .byte  $22,$40,$30,$20,$00,$00,$01,$FF
           .byte  $1D,$20,$86,$20,$10,$00,$08
           .byte      $20,$8D,$20,$10,$FF,$08,$FF
           .byte  $FF
        
           .byte  $22,$40,$30,$20,$00,$00,$01,$FF
           .byte  $22,$50,$30,$A0,$00,$00,$01,$FF
           .byte  $1D,$10,$A2,$20,$10,$00,$08
           .byte      $10,$A2,$20,$10,$01,$08,$FF
           .byte  $FF
        
           .byte  $22,$50,$30,$A0,$00,$00,$01,$FF
           .byte  $24,$60,$30,$A0,$00,$00,$01,$FF
           .byte  $FF
        
           .byte  $24,$60,$30,$A0,$00,$00,$01,$FF
           .byte  $26,$60,$30,$20,$00,$00,$01,$FF
           .byte  $2B,$80,$30,$A0,$00,$00,$01,$FF
           .byte  $FF,$FF
        
LA9D4:     jsr    L3CE8
           lda    #>L3F49
           pha
           lda    #<L3F49
           pha
           jsr    L3C91
           lda    #>L3F60
           pha
           lda    #<L3F60
           pha
           jsr    L3C85
           jsr    LB2AC
           lda    #$07
           sta    $82
           lda    #$70
           sta    $9B
           lda    #$08
           sta    $9C
           lda    #<LAA8F
           sta    $7C
           lda    #>LAA8F
           sta    $7D
           jsr    LA7EC
           lda    #$70
           sta    $9B
           lda    #$18
           sta    $9C
           lda    #<LAA98
           sta    $7C
           lda    #>LAA98
           sta    $7D
           jsr    LA7EC
           lda    #$70
           sta    $9B
           lda    #$28
           sta    $9C
           lda    #<LAAA1
           sta    $7C
           lda    #>LAAA1
           sta    $7D
           jsr    LA7EC
           ldx    $E7
           lda    $E8,x
           clc
           adc    #$01
           sta    $F8
           lda    #$25
           sta    $C9
           lda    #$00
           sta    $CA
           lda    #$C0
           sta    $9C
LAA3E:     lda    #$48
           sta    $9B
           lda    #$00
           ldx    #$25
           jsr    LB352
           lda    $9C
           sec
           sbc    #$20
           sta    $9C
           lda    $F8
           sta    $82
           lda    #$1E
           sta    $9B
           lda    $CA
           beq    LAA68
           pha
           lda    $9B
           sec
           sbc    #$08
           sta    $9B
           pla
           jsr    LA66D
LAA68:     lda    $C9
           jsr    LA661
           lda    #<LAAAA
           sta    $7C
           lda    #>LAAAA
           sta    $7D
           jsr    LA7EC
           sed
           lda    $C9
           clc
           adc    #$25
           sta    $C9
           lda    $CA
           adc    #$00
           sta    $CA
           cld
           dec    $F8
           bne    LAA3E
           jsr    L3D01
           rts

LAA8F:     .byte  $48,$4F,$57,$20,$48,$49,$47,$48,$00
LAA98:     .byte  $43,$41,$4E,$20,$20,$59,$4F,$55,$00
LAAA1:     .byte  $20,$20,$47,$45,$54,$3F,$20,$20,$00
LAAAA:     .byte  $4D,$00
        
LAAAC:     jsr    LB2AC
           jsr    L202E
           lda    #<L286E
           sta    $A9
           lda    #>L286E
           sta    $AA
           jsr    LB2D9
           lda    #<L2905
           sta    $A9
           lda    #>L2905
           sta    $AA
           jsr    LB326
           rts

LAAC9:     jsr    LB2AC
           jsr    L202E
           lda    #<L295A
           sta    $A9
           lda    #>L295A
           sta    $AA
           jsr    LB2D9
           lda    #<L2A01
           sta    $A9
           lda    #>L2A01
           sta    $AA
           jsr    LB326
           rts

LAAE6:     jsr    LB2AC
           jsr    L202E
           lda    #<L2A68
           sta    $A9
           lda    #>L2A68
           sta    $AA
           jsr    LB2D9
           lda    #<L2AE7
           sta    $A9
           lda    #>L2AE7
           sta    $AA
           jsr    LB326
           rts

LAB03:     jsr    LB2AC
           jsr    L202E
           lda    #<L2B76
           sta    $A9
           lda    #>L2B76
           sta    $AA
           jsr    LB2D9
           lda    #<L2C0D
           sta    $A9
           lda    #>L2C0D
           sta    $AA
           jsr    LB326
           rts

LAB20:     lda    JOY_REG_OTHER
           and    #(JOY_MASK_LEFT|JOY_MASK_BUTTON|JOY_MASK_UP|JOY_MASK_DOWN)
           eor    #(JOY_MASK_LEFT|JOY_MASK_BUTTON|JOY_MASK_UP|JOY_MASK_DOWN)
           bit    JOY_REG_RIGHT
           bmi    LAB2E
           ora    #JOY_MASK_RIGHT
LAB2E:     sta    $B2
           pha
           lda    $C2
           eor    #JOY_MASK_BUTTON
           ora    #$FF-JOY_MASK_BUTTON
           and    $B2
           sta    $B2
           pla
           sta    $C2
           rts

LAB3F:     jsr    LAAAC
           lda    #$00
           sta    $B1
           sta    COLORRAM+$001
           sta    $BB
           sta    $C4
           sta    $0110
           lda    #$01
           sta    $F4
           sta    $C3
           ldx    $E7
           lda    $F1,x
           tax
           sec
           sbc    #$01
           asl    a
           sta    $95
           lda    #$14
           sec
           sbc    $95
           sta    $F9
           lda    LABFF-1,x
           sta    $010F
           lda    #$C0
           sta    $BE
           jsr    L2426
           lda    #$46
           sta    $F5
           jsr    L2122
           ldy    #$00
           jsr    LACF1
           jsr    LA5AF
           jsr    LA60E
LAB87:     jsr    L209D
           jsr    LAC04
           jsr    LBB97
           jsr    L23B2
           jsr    LAD41
           jsr    LA4EA
           jsr    LA3D5
           lda    $04
           cmp    #$FF
           bne    LABA4
           sec
           rts

LABA4:     cmp    #$FE
           bne    LAB87
           jsr    L3CE8
           lda    #>L3FA9
           pha
           lda    #<L3FA9
           pha
           jsr    L3C85
           lda    #>L3F96
           pha
           lda    #<L3F96
           pha
           jsr    L3C91
           lda    #$70
           sta    $9B
           lda    #$0F
           sta    $9C
           lda    #$00
           ldx    #$2D
           jsr    LB772
           jsr    L3D01
           lda    #$00
           ldx    #$2E
           jsr    LB772
           ldx    #$2B
           lda    #$66
           sta    $9B
           lda    #$10
           sta    $9C
           lda    #$20
           jsr    LB352
           ldx    #$26
           lda    #$20
           sta    $9B
           lda    #$30
           sta    $9C
           lda    #$00
           jsr    LB772
           lda    #>L3E5E
           pha
           lda    #<L3E5E
           pha
           jsr    L3C79
           clc
           rts

LABFF:     .byte  $04,$0A,$0F,$14,$19
        
LAC04:     ldx    #$0A
LAC06:     lda    #<(L2CDA-2)
           sta    $AB
           lda    #>(L2CDA-2)
           sta    $AC
LAC0E:     lda    $04,x
           beq    LAC8C
           lda    COLORRAM+$004,x
           and    #$08
           bne    LAC68
           lda    COLORRAM+$004,x
           and    #$04
           beq    LAC65
           jsr    L257F
           lda    #$0A
           sta    $05,x
           sta    $06,x
           lda    $00,x
           eor    #$01
           sta    $01,x
           lda    COLORRAM+$000,x
           sta    COLORRAM+$001,x
           lda    $BC
           cmp    #$01
           beq    LAC51
           lda    COLORRAM+$108,x
           and    #$0F
           cmp    #$06
           bne    LAC4A
           jsr    LBFB7
           jmp    LAC51

LAC4A:     cmp    #$02
           bne    LAC51
           jsr    LBF9F
LAC51:     lda    COLORRAM+$108,x
           and    #$04
           bne    LAC60
           lda    #$00
           sta    COLORRAM+$001,x
           jmp    LAC65

LAC60:     lda    #$08
           sta    COLORRAM+$001,x
LAC65:     jsr    L2213
LAC68:     lda    $05,x
           bne    LAC86
           lda    $06,x
           bne    LAC86
           jsr    L216C
           lda    $04,x
           cmp    #$47
           beq    LAC7D
           cmp    #$4B
           bne    LAC86
LAC7D:     lda    #>L3F85
           pha
           lda    #<L3F85
           pha
           jsr    L3C85
LAC86:     jsr    LB9CF
           jsr    LAD01
LAC8C:     txa
           clc
           adc    #$0A
           tax
           cmp    #$78
           bcs    LAC98
           jmp    LAC0E

LAC98:     dec    $F4
           bne    LACF0
           lda    VIA2+$4
           lsr    a
           lsr    a
           lsr    a
           adc    $F9
           sta    $F4
           lda    $C3
           cmp    #$03
           bne    LACBD
           ldy    #$78
           ldx    #$5A
           jsr    LB87F
           lda    #>L3F85
           pha
           lda    #<L3F85
           pha
           jsr    L3C85
           rts

LACBD:     ldy    #$14
           lda    VIA2+$4
           sta    $0112
           cmp    $010F
           beq    LACCC
           bcs    LACCE
LACCC:     ldy    #$19
LACCE:     jsr    LB87D
           bcs    LACF0
           lda    #$08
           sta    $05,x
           lda    #$04
           sta    $011C
           lda    #$00
           sta    $011B
           lda    $0112
           cmp    $010F
           beq    LACEB
           bcs    LACF0
LACEB:     lda    #$06
           sta    $011C
LACF0:     rts

LACF1:     ldx    #$00
           jsr    LB890
           dec    $B4
           jsr    L202E
           lda    #$02
           sta    COLORRAM+$004
           rts

LAD01:     lda    COLORRAM+$000,x
           sta    COLORRAM+$001,x
           lda    #$02
           and    COLORRAM+$004,x
           beq    LAD24
           lda    $00,x
           clc
           adc    #$01
           pha
           and    #$03
           bne    LAD1E
           pla
           lda    $00,x
           and    #$FC
           pha
LAD1E:     pla
           sta    $01,x
           jmp    LAD40

LAD24:     lda    #$01
           and    COLORRAM+$004,x
           beq    LAD40
           lda    $00,x
           sec
           sbc    #$01
           pha
           and    #$03
           cmp    #$03
           bne    LAD3D
           pla
           lda    $00,x
           ora    #$03
           pha
LAD3D:     pla
           sta    $01,x
LAD40:     rts

LAD41:     lda    $0110
           beq    LAD60
           cmp    #$01
           bne    LAD5C
           ldx    $C3
           lda    LAD82-1,x
           sta    $9B
           lda    #$08
           sta    $9C
           lda    #$20
           ldx    #$2C
           jsr    LB352
LAD5C:     dec    $0110
           rts

LAD60:     lda    VIA2+$4
           cmp    #$05
           beq    LAD69
           bcs    LAD81
LAD69:     sta    $0110
           inc    $0110
           ldx    $C3
           lda    LAD82-1,x
           sta    $9B
           lda    #$08
           sta    $9C
           lda    #$00
           ldx    #$2C
           jsr    LB772
LAD81:     rts

LAD82:     .byte  $70,$60,$50,$70
        
LAD86:     jsr    LAAC9
           lda    #$02
           sta    $C3
           jsr    L2122
           lda    #$00
           sta    $B1
           sta    COLORRAM+$004
           sta    COLORRAM+$001
           sta    $B5
           sta    $010E
           sta    $BB
           sta    $C4
           lda    #$32
           sta    $F5
           lda    #$01
           sta    $F4
           lda    #$1E
           sta    $B8
           sta    $B9
           lda    #$F8
           sta    $BE
           ldy    #$05
           jsr    LACF1
           lda    #$18
           sta    $04
           jsr    L2426
           jsr    LA5AF
           jsr    LA60E
LADC7:     jsr    L209D
           jsr    LAF0B
           jsr    L23B2
           jsr    L276C
           jsr    LBB97
           jsr    LAE92
           jsr    L243D
           jsr    L24A8
           jsr    LAD41
           jsr    LAFC7
           jsr    LA4EA
           jsr    LA3D5
           lda    $04
           cmp    #$FF
           bne    LADF3
           sec
           rts

LADF3:     lda    $B8
           bne    LADC7
           lda    $B9
           bne    LADC7
           lda    $B5
           bne    LADC7
           jsr    L3CE8
           ldx    #$00
LAE04:     jsr    LBB7E
           txa
           clc
           adc    #$0A
           tax
           cmp    $F5
           beq    LAE04
           bcc    LAE04
           lda    #$3C
LAE14:     pha
           jsr    L209D
           jsr    L23B2
           pla
           sec
           sbc    #$01
           bne    LAE14
           jsr    L2107
           lda    #>L3E9E
           pha
           lda    #<L3E9E
           pha
           jsr    L3C91
           lda    #$40
           sta    $9B
           lda    #$3A
           sta    $9C
           ldx    #$25
           lda    #$40
           jsr    LB772
           jsr    LAF39
           lda    #<LAE5A
           sta    $A9
           lda    #>LAE5A
           sta    $AA
           jsr    LB2D9
           lda    #<LAE77
           sta    $A9
           lda    #>LAE77
           sta    $AA
           jsr    LB326
           jsr    L3D01
           clc
           rts

LAE5A:     .byte  $20,$30,$16,$20,$08,$00,$09,$30,$40,$20,$08,$00,$09,$FF
           .byte  $2A,$3A,$1E,$20,$00,$FE,$04,$6C,$1E,$20,$00,$FE,$04,$FF
           .byte  $FF
        
LAE77:     .byte  $2B,$56,$10,$20,$40,$3A,$00,$FF
           .byte  $0E,$58,$3A,$00,$FF
           .byte  $2D,$48,$30,$00,$FF
           .byte  $2C,$60,$08,$00,$60,$08,$20,$FF
           .byte  $FF
        
LAE92:     lda    COLORRAM+$004
           and    #$01
           bne    LAF0A
           ldx    #$00
           jsr    LBF1D
           lda    $BC
           cmp    #$01
           bne    LAF0A
           lda    $04
           cmp    #$18
           beq    LAF0A
           jsr    LAF24
           sta    $95
           lda    $02
           cmp    #$30
           bne    LAEDF
           lda    $95
           bit    $B8
           bne    LAEC2
           lda    $B5
           bne    LAEDC
           jmp    LBF36

LAEC2:     eor    #$FF
           and    $B8
           sta    $B8
           lda    $02
           sta    $B6
           ldy    #$01
           lda    ($A6),y
           clc
           adc    #$06
           sta    $B7
           lda    #$03
           sta    $B5
           jsr    LA6D5
LAEDC:     jmp    LAF0A

LAEDF:     cmp    #$70
           bne    LAF0A
           lda    $95
           bit    $B9
           bne    LAEF0
           lda    $B5
           bne    LAF0A
           jmp    LBF36

LAEF0:     eor    #$FF
           and    $B9
           sta    $B9
           lda    $02
           sta    $B6
           ldy    #$01
           lda    ($A6),y
           clc
           adc    #$06
           sta    $B7
           lda    #$03
           sta    $B5
           jsr    LA6D5
LAF0A:     rts

LAF0B:     lda    $B5
           bne    LAF10
           rts

LAF10:     dec    $B5
           bne    LAF23
           lda    $B6
           sta    $9B
           lda    $B7
           sta    $9C
           ldx    #$32
           lda    #$20
           jsr    LB352
LAF23:     rts

LAF24:     txa
           pha
           lda    $04,x
           sec
           sbc    #$18
           tax
           lda    #$01
LAF2E:     asl    a
           dex
           bne    LAF2E
           sta    $95
           pla
           tax
           lda    $95
           rts

LAF39:     lda    #$3F
           sta    $0114
           lda    #$22
           sta    $0115
           lda    #$04
           sta    $99
LAF47:     lda    #$1A
           sta    $9A
LAF4B:     ldx    $0115
           ldy    $0114
LAF51:     cpx    #$00
           bne    LAF6F
           lda    #$00
           sta    CHARSET+$541,y
           sta    CHARSET+$601,y
           sta    CHARSET+$6C1,y
           sta    CHARSET+$781,y
           sta    CHARSET+$841,y
           sta    CHARSET+$901,y
           sta    CHARSET+$9C1,y
           jmp    LAF99

LAF6F:     lda    CHARSET+$540,y
           sta    CHARSET+$541,y
           lda    CHARSET+$600,y
           sta    CHARSET+$601,y
           lda    CHARSET+$6C0,y
           sta    CHARSET+$6C1,y
           lda    CHARSET+$780,y
           sta    CHARSET+$781,y
           lda    CHARSET+$840,y
           sta    CHARSET+$841,y
           lda    CHARSET+$900,y
           sta    CHARSET+$901,y
           lda    CHARSET+$9C0,y
           sta    CHARSET+$9C1,y
LAF99:     dey
           dex
           bpl    LAF51
           inc    $0114
           dec    $9A
           bne    LAF4B
           lda    $0114
           clc
           adc    #$06
           sta    $0114
           lda    $0115
           clc
           adc    #$06
           sta    $0115
           lda    #>L3E55
           pha
           lda    #<L3E55
           pha
           jsr    L3C9D
           jsr    L2107
           dec    $99
           bne    LAF47
           rts

LAFC7:     lda    $04
           cmp    #$1C
           bne    LAFDC
           lda    $02
           cmp    #$3C
           beq    LAFDC
           bcc    LAFDC
           cmp    #$60
           bcs    LAFDC
           jsr    LBF36
LAFDC:     rts

LAFDD:     jsr    LAAE6
           lda    #$03
           sta    $C3
           jsr    L2122
           lda    #$00
           sta    $B1
           sta    COLORRAM+$001
           sta    $010E
           sta    $BB
           sta    $C4
           lda    #$6E
           sta    $F5
           lda    #$01
           sta    $F4
           ldx    $E7
           lda    $F1,x
           asl    a
           sta    $95
           lda    #$0F
           sec
           sbc    $95
           sta    $F9
           lda    #$38
           sta    $BE
           ldy    #$0A
           jsr    LACF1
           jsr    L2426
           jsr    LB134
           ldy    #$6E
           ldx    #$46
           jsr    LB87F
           ldy    #$73
           ldx    #$50
           jsr    LB87F
           lda    #$04
           sta    COLORRAM+$04A
           sta    COLORRAM+$054
           lda    #$02
           sta    COLORRAM+$04E
           sta    COLORRAM+$04F
           sta    COLORRAM+$058
           sta    COLORRAM+$059
           lda    #$06
           sta    COLORRAM+$14E
           sta    COLORRAM+$158
           jsr    LA5AF
           jsr    LA60E
LB04C:     jsr    L209D
           jsr    L23B2
           jsr    L276C
           jsr    LB0CF
           jsr    LBB97
           ldx    #$46
           jsr    LAC06
           jsr    LAD41
           jsr    LA4EA
           jsr    LA3D5
           lda    $04
           cmp    #$FF
           bne    LB071
           sec
           rts

LB071:     cmp    #$FE
           bne    LB04C
           jsr    L3CE8
           lda    #>L3FA9
           pha
           lda    #<L3FA9
           pha
           jsr    L3C85
           lda    #>L3F96
           pha
           lda    #<L3F96
           pha
           jsr    L3C91
           lda    #$50
           sta    $9B
           lda    #$0F
           sta    $9C
           lda    #$00
           ldx    #$2D
           jsr    LB772
           jsr    L3D01
           lda    #>L3E5E
           pha
           lda    #<L3E5E
           pha
           jsr    L3C79
           lda    #$00
           ldx    #$2E
           jsr    LB772
           ldx    #$2B
           lda    #$46
           sta    $9B
           lda    #$10
           sta    $9C
           lda    #$20
           jsr    LB352
           lda    #$00
           sta    $9B
           lda    #$30
           sta    $9C
           ldx    #$26
           lda    #$00
           jsr    LB772
           jsr    L3D01
           clc
           rts

LB0CF:     ldx    #$0A
           ldy    #$00
LB0D3:     tya
           pha
           lda    $03,x
           cmp    #$3A
           bne    LB0E3
           jsr    LBB7E
           ldy    #$50
           jsr    LB890
LB0E3:     lda    #$02
           sta    $06,x
           sta    COLORRAM+$009,x
           lda    #$00
           sta    COLORRAM+$108,x
           jsr    LB9CF
           pla
           tay
           lda    $03,x
           sta    $0100,y
           txa
           clc
           adc    #$0A
           tax
           iny
           cpy    #$03
           bne    LB0D3
LB103:     tya
           pha
           lda    $03,x
           cmp    #$BA
           bne    LB113
           jsr    LBB7E
           ldy    #$5F
           jsr    LB890
LB113:     lda    #$02
           sta    $06,x
           sta    COLORRAM+$009,x
           lda    #$04
           sta    COLORRAM+$108,x
           jsr    LB9CF
           pla
           tay
           lda    $03,x
           sta    $0100,y
           txa
           clc
           adc    #$0A
           tax
           iny
           cpy    #$06
           bne    LB103
           rts

LB134:     ldx    #$00
           ldy    #$50
LB138:     txa
           pha
           tya
           pha
           jsr    LB87D
           pla
           tay
           pla
           tax
           lda    $0D
           sta    $0100,x
           inx
           tya
           clc
           adc    #$05
           tay
           cpx    #$06
           bne    LB138
           rts

LB153:     jsr    LAB03
           lda    #$04
           sta    $C3
           jsr    L2122
           lda    #$00
           sta    $B1
           sta    COLORRAM+$001
           sta    $BB
           sta    $C4
           sta    $0106
           sta    $0107
           sta    $0108
           lda    #$64
           sta    $F5
           lda    #$01
           sta    $F4
           sta    $0111
           lda    #$02
           sta    $0109
           sta    $010A
           sta    $010B
           lda    #$0A
           sta    $F9
           lda    #$F8
           sta    $BE
           ldy    #$0F
           jsr    LACF1
           jsr    L2426
           jsr    LA5AF
           jsr    LA60E
LB19D:     jsr    L209D
           jsr    L2314
           jsr    L23B2
           jsr    L26BB
           jsr    L243D
           jsr    L24E9
           jsr    L276C
           jsr    LBB97
           jsr    LAD41
           jsr    LA4EA
           jsr    LA3D5
           lda    $04
           cmp    #$FF
           bne    LB1C6
           sec
           rts

LB1C6:     cmp    #$FE
           bne    LB19D
           jsr    L3CE8
           lda    #>L3FA9
           pha
           lda    #<L3FA9
           pha
           jsr    L3C85
           lda    #>L3F96
           pha
           lda    #<L3F96
           pha
           jsr    L3C91
           lda    #$70
           sta    $9B
           lda    #$0F
           sta    $9C
           lda    #$00
           ldx    #$2D
           jsr    LB772
           jsr    L3D01
           lda    #>L3E5E
           pha
           lda    #<L3E5E
           pha
           jsr    L3C79
           lda    #$00
           ldx    #$2E
           jsr    LB772
           ldx    #$2B
           lda    #$66
           sta    $9B
           lda    #$10
           sta    $9C
           lda    #$20
           jsr    LB352
           lda    #$20
           sta    $9B
           lda    #$3A
           sta    $9C
           ldx    #$26
           lda    #$00
           jsr    LB772
           jsr    L3D01
           clc
           rts

        ;; init VIC/VIA
LB224:     lda    #$7F
           sta    VIA1+$E       ; disable VIA1 (NMI) interrupts
           sta    VIA2+$E
           sta    VIA1+$D
           sta    VIA2+$D
           lda    #$05
           sta    VIC+$0        ; screen origin X
           lda    #$18
           sta    VIC+$1        ; screen origin Y
           lda    #$96
           sta    VIC+$2        ; 22 columns
           lda    #$19
           sta    VIC+$3        ; 12 double-height rows
           lda    #$8C
           sta    VIC+$5        ; character map at $1000, screen RAM at $0200
           lda    #$AF
           sta    VIC+$E        ; master volume
           lda    #$0B
           sta    VIC+$F        ; black common background, green border
           lda    #$00
           ldx    #$00
           ldy    #$16
LB25B:     sta    SCREEN,x       ; initialize screen RAM
           clc
           adc    #$0C
           dey
           bne    LB269
           ldy    #$16
           sec
           sbc    #$07
LB269:     inx
           bne    LB25B
LB26C:     sta    SCREEN+$100,x
           clc
           adc    #$0C
           inx
           cpx    #$08
           bne    LB26C
           lda    #$FF
           sta    SCREEN+$06D
           sta    SCREEN+$083
           sta    SCREEN+$099
           sta    SCREEN+$0AF
           sta    SCREEN+$0C5
           sta    SCREEN+$0DB
           sta    SCREEN+$0F1
           sta    SCREEN+$107
           lda    #$00
           sta    VIA1+$3
           sta    VIA1+$2
           sta    VIA2+$3
           sta    VIA2+$2
           sta    VIC+$A
           sta    VIC+$B
           sta    VIC+$C
           sta    VIC+$D
           rts

LB2AC:     lda    #<CHARSET
           sta    $7A
           lda    #>CHARSET
           sta    $7B
           ldy    #$00
           lda    #$00
LB2B8:     sta    ($7A),y
           inc    $7A
           bne    LB2C0
           inc    $7B
LB2C0:     ldx    $7B
           cpx    #>(CHARSET+$1000)
           bne    LB2B8
           lda    #$0A
           ldx    #$00
LB2CA:     sta    COLORRAM+$200,x
           inx
           bne    LB2CA
LB2D0:     sta    COLORRAM+$300,x
           inx
           cpx    #$08
           bne    LB2D0
           rts

LB2D9:     ldy    #$00
LB2DB:     lda    ($A9),y
           sta    $A8
           iny
           cmp    #$FF
           beq    LB325
LB2E4:     lda    ($A9),y
           sta    $9B
           iny
           cmp    #$FF
           beq    LB322
           lda    ($A9),y
           sta    $9C
           iny
           lda    ($A9),y
           sta    $7F
           iny
           lda    ($A9),y
           sta    $F6
           iny
           lda    ($A9),y
           sta    $F7
           iny
           lda    ($A9),y
           sta    $F8
           iny
LB306:     ldx    $A8
           lda    $7F
           jsr    LB352
           lda    $9B
           clc
           adc    $F6
           sta    $9B
           lda    $9C
           clc
           adc    $F7
           sta    $9C
           dec    $F8
           bne    LB306
           jmp    LB2E4

LB322:     jmp    LB2DB

LB325:     rts

LB326:     ldy    #$00
LB328:     lda    ($A9),y
           sta    $A8
           iny
           cmp    #$FF
           beq    LB351
LB331:     lda    ($A9),y
           sta    $9B
           iny
           cmp    #$FF
           beq    LB34E
           lda    ($A9),y
           sta    $9C
           iny
           lda    ($A9),y
           sta    $7F
           iny
           lda    $7F
           ldx    $A8
           jsr    LB352
           jmp    LB331

LB34E:     jmp    LB328

LB351:     rts

LB352:     sta    $7F
           lda    #$FF
           sta    $7E
           txa
           asl    a
           tax
           lda    L3BCD-2,x
           sta    $7C
           lda    L3BCD-1,x
           sta    $7D
LB365:     tya
           pha
           ldy    #$00
           lda    ($7C),y
           sta    $80
           iny
           lda    ($7C),y
           sta    $81
           iny
           lda    ($7C),y
           sta    $82
           iny
           lda    $9B
           clc
           adc    #$17
           lsr    a
           lsr    a
           lsr    a
           sec
           sbc    #$03
           clc
           adc    $80
           sta    $9E
           lda    $9C
           tax
           sec
           sbc    $81
           sta    $9F
           dex
           stx    $A0
           lda    $9B
           tax
           and    #$07
           sta    $94
           txa
           lsr    a
           lsr    a
           lsr    a
           sta    $9D
           lda    $7E
           cmp    #$FF
           bne    LB3C1
           lda    #$FF
           sta    $A3
           lda    #$00
           sta    $A4
           lda    $9F
           sta    $86
           lda    $A0
           sta    $8B
           lda    $9D
           sta    $89
           lda    $9E
           sta    $8A
           jmp    LB3EB

LB3C1:     lda    $9F
           cmp    $A3
           bcc    LB3C9
           lda    $A3
LB3C9:     sta    $86
           lda    $A0
           cmp    $A4
           beq    LB3D3
           bcs    LB3D5
LB3D3:     lda    $A4
LB3D5:     sta    $8B
           lda    $9D
           cmp    $A1
           bcc    LB3DF
           lda    $A1
LB3DF:     sta    $89
           lda    $9E
           cmp    $A2
           bcs    LB3E9
           lda    $A2
LB3E9:     sta    $8A
LB3EB:     bit    $7F
           bmi    LB3FA
           lda    #$01
           sta    $8C
           lda    #$00
           sta    $8D
           jmp    LB403

LB3FA:     lda    #$FF
           sta    $8C
           ldy    $80
           dey
           sty    $8D
LB403:     lda    $7C
           clc
           adc    #$03
           sta    $91
           lda    $7D
           adc    #$00
           sta    $92
           lda    $80
           sta    $8E
           bit    $7F
           bvc    LB435
           tax
           eor    #$FF
           sta    $8E
           inc    $8E
           lda    #$00
LB421:     clc
           adc    $81
           dex
           bne    LB421
           sec
           sbc    $80
           clc
           adc    $91
           sta    $91
           lda    $92
           adc    #$00
           sta    $92
LB435:     lda    $7E
           sta    $93
           lda    $89
           clc
           adc    #$03
           asl    a
           tax
           lda    LB740,x
           sta    $78
           inx
           lda    LB740,x
           sta    $79
           lda    $78
           clc
           adc    $86
           sta    $78
           lda    $79
           adc    #$00
           sta    $79
           lda    #$00
           sta    $88
           sta    $87
LB45E:     lda    $86
           cmp    $8B
           beq    LB469
           bcc    LB469
           jmp    LB570

LB469:     lda    #$00
           sta    $A5
           lda    $8D
           sta    $90
           lda    $78
           sta    $7A
           lda    $79
           sta    $7B
           lda    #$00
           ldy    $86
           cpy    $9F
           bcc    LB489
           cpy    $A0
           beq    LB487
           bcs    LB489
LB487:     lda    #$80
LB489:     cpy    $A3
           bcc    LB495
           cpy    $A4
           beq    LB493
           bcs    LB495
LB493:     ora    #$40
LB495:     sta    $84
           lda    #$00
           sta    $83
           lda    $89
           sta    $85
LB49F:     lda    $85
           cmp    $8A
           beq    LB4AA
           bcc    LB4AA
           jmp    LB552

LB4AA:     bit    $84
           bvc    LB4C5
           cmp    $A1
           bcc    LB4C5
           cmp    $A2
           beq    LB4B8
           bcs    LB4C5
LB4B8:     ldy    $87
           ldx    $93
           lda    $031A,x
           eor    ($7A),y
           sta    ($7A),y
           inc    $93
LB4C5:     bit    $84
           bpl    LB540
           lda    $85
           cmp    $9D
           bcc    LB540
           cmp    $9E
           beq    LB4D5
           bcs    LB540
LB4D5:     lda    #$00
           sta    $8F
           ldy    $A5
           cpy    $80
           bcs    LB4F6
           ldy    $90
           lda    ($91),y
           tax
           jsr    LB59D
           txa
           ldx    #$00
           stx    $95
           ldx    $94
           beq    LB4F6
LB4F0:     lsr    a
           ror    $95
           dex
           bne    LB4F0
LB4F6:     ora    $83
           sta    $8F
           beq    LB4FF
           jsr    LB5C7
LB4FF:     lda    $95
           sta    $83
           lda    #$20
           bit    $7F
           beq    LB50E
           lda    #$00
           jmp    LB520

LB50E:     lda    $8F
           sta    $95
           pha
           asl    a
           and    #$AA
           ora    $95
           sta    $95
           pla
           lsr    a
           and    #$55
           ora    $95
LB520:     pha
           ldy    $87
           and    ($7A),y
           eor    $8F
           ldx    $88
           sta    $0129,x
           pla
           eor    #$FF
           and    ($7A),y
           eor    $8F
           sta    ($7A),y
           inc    $A5
           lda    $90
           clc
           adc    $8C
           sta    $90
           inc    $88
LB540:     lda    $7A
           clc
           adc    #$C0
           sta    $7A
           lda    $7B
           adc    #$00
           sta    $7B
           inc    $85
           jmp    LB49F

LB552:     inc    $86
           inc    $87
           bit    $84
           bpl    LB56D
           lda    $91
           clc
           adc    $8E
           sta    $91
           lda    #$00
           bit    $8E
           bpl    LB569
           lda    #$FF
LB569:     adc    $92
           sta    $92
LB56D:     jmp    LB45E

LB570:     lda    $7E
           cmp    #$FF
           beq    LB59A
           pla
LB577:     pha
           ldy    #$00
           ldx    $7E
           lda    $80
           sta    $9A
           lda    $94
           beq    LB586
           inc    $9A
LB586:     lda    $81
           sta    $99
LB58A:     lda    $0129,y
           sta    $031A,x
           inx
           iny
           dec    $99
           bne    LB58A
           dec    $9A
           bne    LB586
LB59A:     pla
           tay
           rts

LB59D:     bit    $7F
           bpl    LB5C6
           lda    #$08
           bit    $82
           bne    LB5B5
           lda    #$80
LB5A9:     pha
           txa
           asl    a
           tax
           pla
           ror    a
           bcc    LB5A9
           tax
           jmp    LB5C6

LB5B5:     lda    #$80
LB5B7:     sta    $96
           txa
           asl    a
           php
           asl    a
           tax
           lda    $96
           ror    a
           plp
           ror    a
           bcc    LB5B7
           tax
LB5C6:     rts

LB5C7:     lda    $82
           bmi    LB5FE
           lda    $87
           clc
           adc    $7A
           php
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           sta    $96
           lda    $7B
           plp
           adc    #$00
           asl    a
           asl    a
           asl    a
           asl    a
           ora    $96
           tax
           lda    LB60B,x
           bne    LB5F8
           cpx    #$00
           beq    LB5F8
           lda    LB60B-$B3,x   ; X is always >= $B3
           tax
           lda    $82
           sta    COLORRAM+$300,x
           jmp    LB5FE
LB5F8:     tax
           lda    $82
           sta    COLORRAM+$200,x
LB5FE:     rts

        ;; ??? [unused?]
           .byte  $FF

        ;; "blip"
LB600:     .byte  $02,$0C,$09,$10,$00

        ;; ??? [unused?]
           .byte  $00,$00,$00,$00,$00,$00

LB60B:     .byte  $00,$16,$2C,$42,$58,$6E,$84,$9A
           .byte  $B0,$C6,$DC,$F2,$01,$17,$2D,$43
           .byte  $59,$6F,$85,$9B,$B1,$C7,$DD,$F3
           .byte  $02,$18,$2E,$44,$5A,$70,$86,$9C
           .byte  $B2,$C8,$DE,$F4,$03,$19,$2F,$45
           .byte  $5B,$71,$87,$9D,$B3,$C9,$DF,$F5
           .byte  $04,$1A,$30,$46,$5C,$72,$88,$9E
           .byte  $B4,$CA,$E0,$F6,$05,$1B,$31,$47
           .byte  $5D,$73,$89,$9F,$B5,$CB,$E1,$F7
           .byte  $06,$1C,$32,$48,$5E,$74,$8A,$A0
           .byte  $B6,$CC,$E2,$F8,$07,$1D,$33,$49
           .byte  $5F,$75,$8B,$A1,$B7,$CD,$E3,$F9
           .byte  $08,$1E,$34,$4A,$60,$76,$8C,$A2
           .byte  $B8,$CE,$E4,$FA,$09,$1F,$35,$4B
           .byte  $61,$77,$8D,$A3,$B9,$CF,$E5,$FB
           .byte  $0A,$20,$36,$4C,$62,$78,$8E,$A4
           .byte  $BA,$D0,$E6,$FC,$0B,$21,$37,$4D
           .byte  $63,$79,$8F,$A5,$BB,$D1,$E7,$FD
           .byte  $0C,$22,$38,$4E,$64,$7A,$90,$A6
           .byte  $BC,$D2,$E8,$FE,$0D,$23,$39,$4F
           .byte  $65,$7B,$91,$A7,$BD,$D3,$E9,$FF
           .byte  $0E,$24,$3A,$50,$66,$7C,$92,$A8
           .byte  $BE,$D4,$EA,$00,$0F,$25,$3B,$51 ; $00 at X=$B3 => $00
           .byte  $67,$7D,$93,$A9,$BF,$D5,$EB,$00 ; $00 at X=$BF => $01
           .byte  $10,$26,$3C,$52,$68,$7E,$94,$AA
           .byte  $C0,$D6,$EC,$00,$11,$27,$3D,$53 ; $00 at X=$CB => $02
           .byte  $69,$7F,$95,$AB,$C1,$D7,$ED,$00 ; $00 at X=$D7 => $03
           .byte  $12,$28,$3E,$54,$6A,$80,$96,$AC
           .byte  $C2,$D8,$EE,$00,$13,$29,$3F,$55 ; $00 at X=$E3 => $04
           .byte  $6B,$81,$97,$AD,$C3,$D9,$EF,$00 ; $00 at X=$EF => $05
           .byte  $14,$2A,$40,$56,$6C,$82,$98,$AE
           .byte  $C4,$DA,$F0,$00,$15,$2B,$41,$57 ; $00 at X=$FB => $06

           ;; ??? [unused?]
           .byte  $6D,$83,$99,$AF,$C5,$DB,$F1,$00
           .byte  $8A,$48,$A5,$9B,$18,$69,$18,$4A
           .byte  $4A,$29,$FE,$AA,$BD,$40,$B7,$85
           .byte  $78,$E8,$BD,$40,$B7,$85,$79,$A5
           .byte  $78,$18,$65,$9C,$85,$78,$A5,$79
           .byte  $69,$00,$85,$79,$A5,$9B,$29,$07
           .byte  $85,$7F,$68,$AA,$60
        
LB740:     .byte  $C0,>CHARSET-$10+$0D,$80,>CHARSET-$10+$0E,$40,>CHARSET-$10+$0F,$00,>CHARSET-$10+$10
           .byte  $C0,>CHARSET-$10+$10,$80,>CHARSET-$10+$11,$40,>CHARSET-$10+$12,$00,>CHARSET-$10+$13
           .byte  $C0,>CHARSET-$10+$13,$80,>CHARSET-$10+$14,$40,>CHARSET-$10+$15,$00,>CHARSET-$10+$16
           .byte  $C0,>CHARSET-$10+$16,$80,>CHARSET-$10+$17,$40,>CHARSET-$10+$18,$00,>CHARSET-$10+$19
           .byte  $C0,>CHARSET-$10+$19,$80,>CHARSET-$10+$1A,$40,>CHARSET-$10+$1B,$00,>CHARSET-$10+$1C
           .byte  $C0,>CHARSET-$10+$1C,$80,>CHARSET-$10+$1D,$40,>CHARSET-$10+$1E,$00,>CHARSET-$10+$1F
           .byte  $C0,>CHARSET-$10+$1F
        
LB772:     sta    $7F
           txa
           asl    a
           tax
           lda    L3BCD-2,x
           sta    $7C
           lda    L3BCD-1,x
           sta    $7D
           jsr    LB857
           lda    $7B
           pha
           lda    $7A
           pha
           lda    $7D
           pha
           lda    $7C
           pha
           ldy    #$00
           sty    $87
           lda    ($7C),y
           sta    $80
           iny
           lda    ($7C),y
           iny
           sta    $81
           sta    $86
           lda    $7A
           sec
           sbc    $81
           sta    $7A
           lda    $7B
           sbc    #$00
           sta    $7B
           lda    ($7C),y
           sta    $82
           iny
           sty    $91
           bit    $7F
           bvc    LB7BE
           lda    $81
           sta    $87
           dec    $87
LB7BE:     lda    $80
           sta    $85
           lda    #$00
           sta    $83
           lda    $7B
           pha
           lda    $7A
           pha
           lda    $91
           pha
           bit    $7F
           bpl    LB7DC
           lda    $91
           clc
           adc    $80
           sta    $91
           dec    $91
LB7DC:     ldy    $91
           lda    ($7C),y
           tax
           bit    $7F
           bpl    LB7E9
           dey
           jmp    LB7EA

LB7E9:     iny
LB7EA:     sty    $91
           jsr    LB59D
           jsr    LB83A
           ldy    $87
           txa
           sta    ($7A),y
           jsr    LB5C7
           lda    $7A
           clc
           adc    #$C0
           sta    $7A
           lda    $7B
           adc    #$00
           sta    $7B
           dec    $85
           bne    LB7DC
           pla
           sta    $91
           lda    $91
           clc
           adc    $80
           sta    $91
           pla
           sta    $7A
           pla
           sta    $7B
           bit    $7F
           bvs    LB824
           inc    $87
           jmp    LB826

LB824:     dec    $87
LB826:     dec    $86
           beq    LB82D
           jmp    LB7BE

LB82D:     pla
           sta    $7C
           pla
           sta    $7D
           pla
           sta    $7A
           pla
           sta    $7B
           rts

LB83A:     lda    $83
           sta    $96
           lda    #$00
           sta    $83
           lda    $9B
           and    #$07
           sta    $95
           txa
           ldx    $95
           beq    LB853
LB84D:     lsr    a
           ror    $83
           dex
           bne    LB84D
LB853:     ora    $96
           tax
           rts

LB857:     txa
           pha
           lda    $9B
           clc
           adc    #$18
           lsr    a
           lsr    a
           and    #$FE
           tax
           lda    LB740,x
           sta    $7A
           lda    LB740+1,x
           sta    $7B
           lda    $7A
           clc
           adc    $9C
           sta    $7A
           lda    $7B
           adc    #$00
           sta    $7B
           pla
           tax
           rts

LB87D:     ldx    #$0A
LB87F:     lda    $04,x
           beq    LB890
           txa
           clc
           adc    #$0A
           tax
           cmp    $F5
           beq    LB87F
           bcc    LB87F
           sec
           rts

LB890:     lda    LB92F,y
           sta    $00,x
           lda    LB930,y
           sta    $02,x
           lda    LB931,y
           sta    $03,x
           lda    LB932,y
           sta    COLORRAM+$000,x
           lda    LB933,y
           sta    $04,x
           lda    #$00
           sta    $01,x
           sta    $05,x
           sta    $06,x
           sta    $07,x
           sta    $08,x
           sta    COLORRAM+$004,x
           sta    COLORRAM+$005,x
           lda    #$08
           sta    COLORRAM+$108,x
           lda    #$01
           sta    COLORRAM+$006,x
           sta    COLORRAM+$007,x
           sta    COLORRAM+$002,x
           sta    COLORRAM+$003,x
           sta    COLORRAM+$008,x
           sta    COLORRAM+$009,x
           lda    $02,x
           sta    $9B
           lda    $03,x
           sta    $9C
           lda    COLORRAM+$000,x
           asl    a
           asl    a
           asl    a
           asl    a
           sta    $7F
           txa
           pha
           lda    $00,x
           tax
           lda    $7F
           jsr    LB352
           pla
           tax
           lda    $9D
           sta    COLORRAM+$100,x
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           sta    COLORRAM+$101,x
           lda    $9E
           sta    COLORRAM+$102,x
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           sta    COLORRAM+$103,x
           lda    $9F
           sta    COLORRAM+$104,x
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           sta    COLORRAM+$105,x
           lda    $A0
           sta    COLORRAM+$106,x
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           sta    COLORRAM+$107,x
           lda    $09,x
           sta    $7E
           txa
           pha
           jsr    LB577
           pla
           tax
           clc
           rts

LB92F:     .byte  $0E
LB930:     .byte  $20
LB931:     .byte  $BA
LB932:     .byte  $08
LB933:     .byte  $01,$0E,$20,$BA,$08,$18,$0E,$08
           .byte  $B0,$08,$3C,$0E,$28,$BA,$08,$41
           .byte  $01,$40,$30,$00,$01,$01,$2C,$38
           .byte  $00,$31,$02,$98,$BA,$00,$18,$02
           .byte  $08,$BA,$00,$18,$02,$90,$9A,$00
           .byte  $19,$02,$10,$9A,$00,$19,$02,$88
           .byte  $7A,$00,$1A,$02,$18,$7A,$00,$1A
           .byte  $02,$80,$5A,$00,$1B,$02,$20,$5A
           .byte  $00,$1B,$02,$78,$3A,$00,$1C,$02
           .byte  $28,$3A,$00,$1C,$1F,$20,$BA,$00
           .byte  $01,$1F,$20,$8E,$00,$01,$1F,$20
           .byte  $62,$00,$01,$1F,$50,$3A,$00,$01
           .byte  $1F,$50,$66,$00,$01,$1F,$50,$92
           .byte  $00,$01,$02,$30,$59,$00,$25,$02
           .byte  $90,$47,$00,$30,$1B,$20,$30,$00
           .byte  $43,$36,$10,$9A,$00,$45,$36,$98
           .byte  $9A,$00,$45,$36,$10,$5A,$00,$46
           .byte  $36,$48,$5A,$00,$46,$36,$60,$5A
           .byte  $00,$47,$36,$98,$5A,$00,$47,$02
           .byte  $56,$5A,$00,$46
        
LB9CF:     lda    #$00
           cmp    $05,x
           bne    LB9DC
           cmp    $06,x
           bne    LB9DC
           jmp    LBA64

LB9DC:     lda    COLORRAM+$008,x
           and    #$0F
           cmp    $05,x
           bcc    LB9E7
           lda    $05,x
LB9E7:     sta    $AF
           lda    COLORRAM+$009,x
           and    #$0F
           cmp    $06,x
           bcc    LB9F4
           lda    $06,x
LB9F4:     sta    $B0
           lda    $05,x
           beq    LBA27
           dec    COLORRAM+$006,x
           lda    COLORRAM+$006,x
           and    #$0F
           bne    LBA27
           lda    COLORRAM+$108,x
           and    #$0F
           tay
           lda    $05,x
           sec
           sbc    $AF
           sta    $05,x
           lda    $AF
           sta    $99
LBA15:     lda    $07,x
           clc
           adc    LBB6C,y
           sta    $07,x
           dec    $99
           bne    LBA15
           lda    COLORRAM+$002,x
           sta    COLORRAM+$006,x
LBA27:     lda    $06,x
           beq    LBA58
           dec    COLORRAM+$007,x
           lda    COLORRAM+$007,x
           and    #$0F
           bne    LBA58
           lda    COLORRAM+$108,x
           and    #$0F
           tay
           lda    $06,x
           sec
           sbc    $B0
           sta    $06,x
           lda    $B0
           sta    $99
LBA46:     lda    $08,x
           clc
           adc    LBB75,y
           sta    $08,x
           dec    $99
           bne    LBA46
           lda    COLORRAM+$003,x
           sta    COLORRAM+$007,x
LBA58:     lda    $01,x
           bne    LBA6D
           lda    $05,x
           bne    LBA64
           lda    $06,x
           beq    LBA6D
LBA64:     lda    $07,x
           bne    LBA6D
           lda    $08,x
           bne    LBA6D
           rts

LBA6D:     lda    $01,x
           bne    LBA73
           lda    $00,x
LBA73:     asl    a
           tay
           lda    L3BCD-2,y
           sta    $7C
           lda    L3BCD-1,y
           sta    $7D
           lda    $02,x
           clc
           adc    $07,x
           sta    $02,x
           sta    $9B
           lda    $03,x
           clc
           adc    $08,x
           sta    $03,x
           sta    $9C
           lda    #$00
           sta    $07,x
           sta    $08,x
           lda    #$08
           and    COLORRAM+$001,x
           bne    LBACC
           ldy    #$02
           lda    #$40
           and    ($7C),y
           beq    LBACC
           ldy    #$00
           lda    $7C
           sta    $97
           lda    $7D
           sta    $98
           lda    $97
           sec
           sbc    #$02
           sta    $97
           lda    $98
           sbc    #$00
           sta    $98
           lda    $9B
           clc
           adc    ($97),y
           sta    $9B
           iny
           lda    $9C
           clc
           adc    ($97),y
           sta    $9C
LBACC:     lda    $01,x
           beq    LBADF
           sta    $00,x
           lda    #$00
           sta    $01,x
           lda    COLORRAM+$001,x
           sta    COLORRAM+$000,x
           jmp    LBAE2

LBADF:     lda    COLORRAM+$000,x
LBAE2:     asl    a
           asl    a
           asl    a
           asl    a
           sta    $7F
           lda    $09,x
           sta    $7E
           lda    COLORRAM+$100,x
           and    #$0F
           sta    $95
           lda    COLORRAM+$101,x
           asl    a
           asl    a
           asl    a
           asl    a
           ora    $95
           sta    $A1
           lda    COLORRAM+$102,x
           and    #$0F
           sta    $95
           lda    COLORRAM+$103,x
           asl    a
           asl    a
           asl    a
           asl    a
           ora    $95
           sta    $A2
           lda    COLORRAM+$104,x
           and    #$0F
           sta    $95
           lda    COLORRAM+$105,x
           asl    a
           asl    a
           asl    a
           asl    a
           ora    $95
           sta    $A3
           lda    COLORRAM+$106,x
           and    #$0F
           sta    $95
           lda    COLORRAM+$107,x
           asl    a
           asl    a
           asl    a
           asl    a
           ora    $95
           sta    $A4
           txa
           pha
           jsr    LB365
           pla
           tax
           lda    $9D
           sta    COLORRAM+$100,x
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           sta    COLORRAM+$101,x
           lda    $9E
           sta    COLORRAM+$102,x
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           sta    COLORRAM+$103,x
           lda    $9F
           sta    COLORRAM+$104,x
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           sta    COLORRAM+$105,x
           lda    $A0
           sta    COLORRAM+$106,x
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           sta    COLORRAM+$107,x
           rts

LBB6C:     .byte  $00,$01,$01,$01,$00,$FF,$FF,$FF,$00
LBB75:     .byte  $FF,$FF,$00,$01,$01,$01,$00,$FF,$00
        
LBB7E:     lda    $04,x
           beq    LBB96
           lda    #$01
           sta    $01,x
           lda    #$08
           sta    COLORRAM+$108,x
           lda    #$01
           sta    $05,x
           jsr    LB9CF
           lda    #$00
           sta    $04,x
LBB96:     rts

LBB97:     lda    $EB
           bne    LBB9C
           rts

LBB9C:     ldx    #$00
           lda    #$01
           bit    COLORRAM+$004
           beq    LBBE4
           lda    $05
           bne    LBBB8
           lda    $06
           bne    LBBB8
           lda    #<(L2C80-2)
           sta    $AB
           lda    #>(L2C80-2)
           sta    $AC
           jsr    L216C
LBBB8:     lda    $04
           bpl    LBBBD
           rts

LBBBD:     jsr    LB9CF
           lda    #$0C
           bit    COLORRAM+$004
           beq    LBBE3
           lda    #$04
           bit    COLORRAM+$004
           bne    LBBD4
           dec    COLORRAM+$009
           jmp    LBBE3

LBBD4:     inc    COLORRAM+$009
           lda    COLORRAM+$009
           and    #$0F
           bne    LBBE3
           lda    #$0F
           sta    COLORRAM+$009
LBBE3:     rts

LBBE4:     jsr    LAB20
           lda    #$00
           sta    $B3
           lda    $BB
           beq    LBBF5
           lda    $B2
           and    #(JOY_MASK_LEFT|JOY_MASK_RIGHT)
           sta    $B2
LBBF5:     ldx    #$00
           jsr    LBF1D
           lda    $BC
           cmp    #$00
           bne    LBC44
           lda    #(JOY_MASK_UP|JOY_MASK_DOWN)
           sta    $B3
           lda    $03
           ldy    #$01
           sec
           sbc    ($A6),y
           sta    $C0
           bne    LBC23
           iny
           lda    ($A6),y
           sta    $04
           bpl    LBC19
           jmp    LBCD0

LBC19:     jsr    LBF1D
           lda    $BC
           cmp    #$00
           bne    LBC44
           dey
LBC23:     iny
           iny
           lda    ($A6),y
           sec
           sbc    $03
           sta    $C1
           bne    LBC41
           iny
           lda    ($A6),y
           sta    $04
           bpl    LBC38
           jmp    LBCD0

LBC38:     jsr    LBF1D
           lda    $BC
           cmp    #$00
           bne    LBC44
LBC41:     jmp    LBCD0

LBC44:     lda    #(JOY_MASK_BUTTON|JOY_MASK_LEFT|JOY_MASK_RIGHT)
           sta    $B3
           lda    $04
           cmp    #$3F
           bne    LBC60
           dec    $08
           dec    $08
           lda    $03
           cmp    #$45
           beq    LBC5A
           bcs    LBC60
LBC5A:     jsr    LBF3A
           jmp    LBDB7

LBC60:     lda    $04
           cmp    #$40
           bne    LBC7F
           inc    $08
           inc    $08
           lda    $03
           ldy    $B1
           beq    LBC75
           dey
           clc
           adc    LBE15,y
LBC75:     cmp    #$B6
           bcc    LBC7F
           jsr    LBF3A
           jmp    LBDB7

LBC7F:     ldy    #$04
LBC81:     lda    ($A6),y
           beq    LBCAD
           asl    a
           tax
           lda    LBC9A-2,x
           sta    $97
           lda    LBC9A-1,x
           sta    $98
           jsr    LBCAA
           bcs    LBCAD
           iny
           jmp    LBC81

LBC9A:     .word  LBE1F,LBE43,LBE6B,LBEE9,LBEF8,LBF07,LBF1C,LBF1A
                
LBCAA:     jmp    ($97)

LBCAD:     lda    $B1
           bne    LBCD0
           lda    $02
           clc
           adc    #$04
           ldy    #$02
           cmp    ($A6),y
           bcs    LBCC2
           jsr    LBF36
           jmp    LBB9C

LBCC2:     lda    $02
           ldy    #$03
           cmp    ($A6),y
           bcc    LBCD0
           jsr    LBF36
           jmp    LBB9C

LBCD0:     jsr    L27F9
           lda    $B2
           and    $B3
           sta    $B2
           lda    #JOY_MASK_DOWN
           bit    $B2
           beq    LBCFE
           lda    #$03
           cmp    $C1
           bcc    LBCE7
           lda    $C1
LBCE7:     clc
           adc    $08
           sta    $08
           lda    #$00
           sta    COLORRAM+$001
           lda    #$0C
           sta    $01
           lda    #>L3E82
           pha
           lda    #<L3E82
           pha
           jsr    L3C8D
LBCFE:     lda    #JOY_MASK_UP
           bit    $B2
           beq    LBD28
           lda    #$03
           cmp    $C0
           bcc    LBD0C
           lda    $C0
LBD0C:     eor    #$FF
           clc
           adc    #$01
           clc
           adc    $08
           sta    $08
           lda    #$00
           sta    COLORRAM+$001
           lda    #$0C
           sta    $01
           lda    #>L3E82
           pha
           lda    #<L3E82
           pha
           jsr    L3C8D
LBD28:     bit    $B2
           bpl    LBD5A         ; JOY_MASK_RIGHT=$80
           lda    $02
           cmp    #$A0
           beq    LBD5A
           lda    $07
           clc
           adc    #$04
           sta    $07
           lda    #$08
           sta    COLORRAM+$001
           lda    $BC
           cmp    #$01
           beq    LBD49
           bcc    LBD49
           jsr    LBF9D
LBD49:     lda    #>L3E82
           pha
           lda    #<L3E82
           pha
           jsr    L3C8D
           lda    $BB
           bne    LBD5A
           lda    #$0E
           sta    $01
LBD5A:     lda    #JOY_MASK_LEFT
           bit    $B2
           beq    LBD8C
           lda    $02
           beq    LBD8C
           lda    $07
           sec
           sbc    #$04
           sta    $07
           lda    $BC
           cmp    #$01
           beq    LBD76
           bcc    LBD76
           jsr    LBFB5
LBD76:     lda    #$00
           sta    COLORRAM+$001
           lda    #>L3E82
           pha
           lda    #<L3E82
           pha
           jsr    L3C8D
           lda    $BB
           bne    LBD8C
           lda    #$0E
           sta    $01
LBD8C:     jsr    LBDD5
           lda    $BB
           beq    LBDB4
           lda    #$08
           sta    COLORRAM+$108
           lda    #$12
           sta    $01
           lda    #$01
           sta    $06
           dec    $BB
           bne    LBDB4
           lda    #$0E
           sta    $01
           jsr    L3CE8
           lda    #>L3E6D           
           pha
           lda    #<L3E6D
           pha
           jsr    L3C79
LBDB4:     jsr    LBF79
LBDB7:     ldx    #$00
           lda    $04
           cmp    #$45
           bcc    LBDD1
           cmp    #$47
           beq    LBDC5
           bcs    LBDD1
LBDC5:     sec
           sbc    #$45
           tay
           lda    $0109,y
           clc
           adc    $07
           sta    $07
LBDD1:     jsr    LB9CF
           rts

LBDD5:     ldy    $B1
           bne    LBDFB
           lda    #JOY_MASK_BUTTON
           bit    $B2
           beq    LBE14
           lda    #>L3E8D
           pha
           lda    #<L3E8D
           pha
           jsr    L3C85
           lda    #$05
           sta    $B1
           tay
           lda    #$90
           sta    $BF
           lda    #(JOY_MASK_LEFT|JOY_MASK_RIGHT)
           bit    $B2
           bne    LBDFB
           lda    #$00
           sta    $BF
LBDFB:     lda    $B2
           and    $BF
           sta    $B2
           dey
           sty    $B1
           lda    $08
           clc
           adc    LBE15,y
           sta    $08
           lda    $BF
           bne    LBE14
           lda    #$0C
           sta    $01
LBE14:     rts

LBE15:     .byte  $07,$05,$00,$FB,$F9
LBE1A:     .byte  $00,$07,$0C,$0C,$07
        
LBE1F:     lda    $02
           iny
           cmp    ($A6),y
           bne    LBE40
           lda    $B1
           bne    LBE40
           lda    #JOY_MASK_UP
           bit    $B2
           beq    LBE40
           sta    $B2
           sta    $B3
           iny
           lda    ($A6),y
           sta    $04
           lda    #$0A
           sta    $C0
           jmp    LBE41

LBE40:     iny
LBE41:     clc
           rts

LBE43:     lda    $02
           iny
           cmp    ($A6),y
           bne    LBE68
           lda    $B1
           bne    LBE68
           lda    #JOY_MASK_DOWN
           bit    $B2
           beq    LBE68
           sta    $B2
           sta    $B3
           iny
           lda    ($A6),y
           sta    $04
           lda    #JOY_MASK_DOWN
           sta    $B2
           lda    #$0A
           sta    $C1
           jmp    LBE69

LBE68:     iny
LBE69:     clc
           rts

LBE6B:     iny
           tya
           pha
           lda    ($A6),y
           sta    $95
           asl    a
           tay
           lda    L3087-2,y
           sta    $97
           lda    L3087-1,y
           sta    $98
           lda    $BB
           bne    LBEE5
           lda    $02
           clc
           adc    #$04
           ldy    #$02
           cmp    ($97),y
           bcc    LBEE5
           lda    $02
           ldy    #$03
           cmp    ($97),y
           bcs    LBEE5
           lda    $95
           cmp    #$3F
           bne    LBEA3
           ldx    #$00
           jsr    LBFCB
           jmp    LBEB6

LBEA3:     cmp    #$40
           bne    LBEAF
           ldx    #$03
           jsr    LBFCB
           jmp    LBEB6

LBEAF:     ldy    #$01
           lda    ($97),y
           sec
           sbc    $03
LBEB6:     cmp    #$0A
           beq    LBEBC
           bcs    LBEE5
LBEBC:     ldy    $B1
           sec
           sbc    LBE1A,y
           sta    $08
           lda    #$00
           sta    $05
           sta    $06
           lda    $97
           sta    $A6
           lda    $98
           sta    $A7
           lda    $95
           sta    $04
           cmp    #$46
           beq    LBEDE
           cmp    #$47
           bne    LBEE1
LBEDE:     jsr    LA6D5
LBEE1:     pla
           tay
           sec
           rts

LBEE5:     pla
           tay
           clc
           rts

LBEE9:     iny
           lda    $02
           cmp    ($A6),y
           bne    LBEF6
           lda    $B3
           and    #$FF-JOY_MASK_LEFT
           sta    $B3
LBEF6:     clc
           rts

LBEF8:     iny
           lda    $02
           cmp    ($A6),y
           bne    LBF05
           lda    $B3
           and    #$FF-JOY_MASK_RIGHT
           sta    $B3
LBF05:     clc
           rts

LBF07:     iny
           lda    $02
           cmp    ($A6),y
           bne    LBF17
           iny
           lda    ($A6),y
           sta    $04
           sec
           jmp    LBF19

LBF17:     iny
           clc
LBF19:     rts

LBF1A:     iny
           iny
LBF1C:     rts

LBF1D:     tya
           pha
           lda    $04,x
           asl    a
           tay
           lda    L3087-2,y
           sta    $A6
           lda    L3087-1,y
           sta    $A7
           ldy    #$00
           lda    ($A6),y
           sta    $BC
           pla
           tay
           rts

LBF36:     lda    $B1
           bne    LBF78
LBF3A:     lda    #$00
           sta    $B1
           lda    #$01
           sta    $04
           lda    #$BA
           sec
           sbc    $03
           sta    $06
           lda    #$04
           sta    COLORRAM+$108
           lda    #$01
           sta    COLORRAM+$009
           lda    #$05
           sta    COLORRAM+$004
           lda    #$0E
           sta    $01
           lda    COLORRAM+$000
           ora    #$04
           sta    COLORRAM+$001
           lda    #$00
           sta    $B1
           lda    #$00
           sta    $08
           jsr    L3CE8
           lda    #>L3E9E
           pha
           lda    #<L3E9E
           pha
           jsr    L3C91
LBF78:     rts

LBF79:     lda    COLORRAM+$004
           and    #$02
           beq    LBF9C
           lda    $BB
           bne    LBF88
           lda    $B2
           beq    LBF9C
LBF88:     lda    $F3
           eor    #$01
           and    #$01
           sta    $F3
           lda    $01
           bne    LBF96
           lda    $00
LBF96:     and    #$FE
           ora    $F3
           sta    $01
LBF9C:     rts

LBF9D:     ldx    #$00
LBF9F:     lda    $02,x
           and    #$0F
           cmp    #$0C
           bne    LBFB4
           lda    $BC
           cmp    #$02
           beq    LBFB2
           inc    $08,x
           jmp    LBFB4

LBFB2:     dec    $08,x
LBFB4:     rts

LBFB5:     ldx    #$00
LBFB7:     lda    $02,x
           and    #$0F
           bne    LBFCA
           lda    $BC
           cmp    #$03
           beq    LBFC8
           inc    $08,x
           jmp    LBFCA

LBFC8:     dec    $08,x
LBFCA:     rts

LBFCB:     lda    #$03
           sta    $99
           lda    #$FF
           sta    $96
LBFD3:     lda    $0100,x
           sec
           sbc    #$04
           sec
           sbc    $03
           cmp    $96
           beq    LBFE2
           bcs    LBFE4
LBFE2:     sta    $96
LBFE4:     inx
           dec    $99
           bne    LBFD3
           lda    $96
           rts

        ;; [unused?]
           .byte  $86,$F7,$4E,$F7,$61,$7D,$4E,$71
           .byte  $04,$7C,$44,$65,$66,$75,$64,$75
           .byte  $04,$75,$65,$75
