VIC               := $9000      ; $9000-$900F
VIA1              := $9110      ; $9110-$911F
VIA2              := $9120      ; $9120-$912F
COLORRAM          := $9400      ; $9400-$9507 (22x12)
CHARSET           := $1000      ; $1000-$1FFF
SCREEN            := $0200      ; $0200-$0307 (22x12)
JOY_REG_RIGHT     := VIA2+0
JOY_REG_OTHER     := VIA1+1
JOY_MASK_UP       := $04
JOY_MASK_DOWN     := $08
JOY_MASK_LEFT     := $10
JOY_MASK_RIGHT    := $80
JOY_MASK_BUTTON   := $20
IRQVEC            := $0314
NMIVEC            := $0318

           .setcpu "6502"
           .org $A000
        
           .word  ENTRY,ENTRY
           .byte  $41,$30,$C3,$C2,$CD

;;; [all code from here to *** marker below must reside in the same memory page]
                
LA009:     lda    $A5,x
           sta    $9D
           lda    $A6,x
           sta    $9E
           ldy    $CE
           bit    LAC0E
           lda    $94
           lsr    a
           lda    $D7
           bcs    LA02A
           ldx    #$00
           lda    $97
           and    #$04
           clc
           adc    $CE
           tay
           clv
LA028:     lda    $02,x
LA02A:     jmp    ($C9)

           lsr    a
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           lsr    a
LA034:     jmp    LA03F

LA037:     asl    a
           asl    a
           asl    a
           asl    a
           asl    a
           asl    a
           asl    a
           asl    a
LA03F:     sta    ($9D),y
           iny
           sta    ($9D),y
           iny
           sta    ($9D),y
           iny
           sta    ($9D),y
           iny
           cpy    $D0
           bcs    LA05A
           bvs    LA03F
           iny
           iny
           iny
           iny
           inx
           cpy    $D0
           bcc    LA028
LA05A:     rts

LA05B:     lda    $A5,x
           sta    $9D
           lda    $A6,x
           sta    $9E
           lda    $A7,x
           sta    $9F
           lda    $A8,x
           sta    $A0
           ldy    $8E
           ldx    LAF07,y
           ldy    #$8E
LA072:     dex
           lda    LAEB7,x
           jmp    ($CB)

           lsr    a
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           lsr    a
LA081:     sta    ($9D),y
           iny
           sta    ($9D),y
           iny
           lda    LAEB7,x
           jmp    ($C9)

LA08C:     asl    a
           asl    a
           asl    a
           asl    a
           asl    a
           asl    a
           asl    a
           asl    a
           sta    ($9F),y
           iny
           sta    ($9F),y
           iny
           iny
           iny
           iny
           cpy    #$B0
           bcc    LA072
           rts

LA0A2:     lda    ($9B),y
           jmp    ($CB)

           lsr    a
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           lsr    a
LA0AE:     ora    ($9D),y
           sta    ($9D),y
           lda    ($9B),y
           jmp    ($C9)

LA0B7:     asl    a
           asl    a
           asl    a
           asl    a
           asl    a
           asl    a
           asl    a
           asl    a
           ora    ($9F),y
           sta    ($9F),y
           dey
           bpl    LA0A2
LA0C6:     dex
           bpl    LA10F
           rts

LA0CA:     lda    $C3,x
           sta    $9D
           lda    $C4,x
           sta    $9E
           ldy    #$0B
LA0D4:     lda    LAEAB,y
           jmp    ($C9)

           lsr    a
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           lsr    a
LA0E1:     jmp    LA0EC

LA0E4:     asl    a
           asl    a
           asl    a
           asl    a
           asl    a
           asl    a
           asl    a
           asl    a
LA0EC:     sta    $8F
           and    ($9D),y
           bne    LA0FF
           lda    $8F
           ora    ($9D),y
           sta    ($9D),y
           dey
           sta    ($9D),y
           dey
           bpl    LA0D4
           rts

;;; [*** end of code that must reside in same memory page]
        
LA0FF:     lda    #$3F
           sta    $90
           sta    $41
           lda    $4C
           sec
           sbc    #$04
           sta    $D8
           rts

LA10D:     ldx    #$09
LA10F:     lda    $34,x
           beq    LA0C6
           ldy    #>LAD00
           asl    a
           asl    a
           asl    a
           bcc    LA11B
           iny
LA11B:     sec
           sbc    $34,x
           bcs    LA121
           dey
LA121:     sta    $9B
           sty    $9C
           lda    $66,x
           and    #$F8
           lsr    a
           lsr    a
           tay
           lda    LA2CB+0,y
           adc    $70,x
           sta    $9D
           sta    $AB,x
           lda    LA2CB+1,y
           adc    #$00
           sta    $9E
           sta    $B7,x
           lda    LA2CB+2,y
           sta    $9F
           adc    $70,x
           sta    $9F
           lda    LA2CB+3,y
           adc    #$00
           sta    $A0
           lda    $66,x
           and    #$07
           sta    $D2
           clc
           adc    #<LA0B7
           sta    $C9
           lda    #<LA0AE+1
           sbc    $D2
           sta    $CB
           ldy    #$06
           jmp    LA0A2

LA164:     lda    $CD
           beq    LA17B
           cmp    #$02
           lda    #$00
           bcc    LA17C
           ldy    $CF
           beq    LA17B
LA172:     sta    ($A5),y
           sta    ($A7),y
           iny
           cpy    $D1
           bcc    LA172
LA17B:     rts

LA17C:     ldy    #$8C
LA17E:     sta    ($A5),y
           sta    ($A7),y
           sta    ($A9),y
           iny
           cpy    #$B0
           bcc    LA17E
           rts

LA18A:     ldx    #$09
LA18C:     lda    $AB,x
           sta    $9D
           clc
           adc    #$B0
           sta    $9F
           lda    $B7,x
           sta    $9E
           adc    #$00
           sta    $A0
           lda    #$00
           ldy    #$06
LA1A1:     sta    ($9D),y
           sta    ($9F),y
           dey
           bpl    LA1A1
           dex
           bpl    LA18C
           rts

LA1AC:     jsr    LA28E
           lda    $90
           beq    LA1EA
           lda    #$01
           sta    $CD
           lda    #$00
           sta    $01
           sta    $CE
           lda    $A7
           clc
           adc    #$B0
           sta    $A9
           lda    $A8
           adc    #$00
           sta    $AA
           lda    #<LA08C
           adc    $D2
           sta    $C9
           lda    #<LA081+1
           sbc    $D2
           sta    $CB
           lda    $90
           lsr    a
           lsr    a
           and    #$FE
           sta    $8E
           ldx    #$00
           jsr    LA05B
           ldx    #$02
           inc    $8E
           jmp    LA05B

LA1EA:     lda    #$02
           sta    $CD
           lda    $CE
           beq    LA210
           sta    $CF
           lda    $D0
           sta    $D1
           lda    #<LA034+1
           clc
           sbc    $D2
           sta    $C9
           ldx    #$00
           jsr    LA009
           lda    #<LA037
           clc
           adc    $D2
           sta    $C9
           ldx    #$02
           jmp    LA009

LA210:     rts

LA211:     lda    #$00
           ldy    #$0B
LA215:     sta    ($C3),y
           sta    ($C5),y
           sta    ($C7),y
           dey
           bpl    LA215
           rts

LA21F:     ldy    $4B
           beq    LA236
           ldx    #$00
           jsr    LA264
           tay
           lda    LA237,y
           ldy    #$07
LA22E:     sta    ($C3),y
           dey
           sta    ($C3),y
           dey
           bpl    LA22E
LA236:     rts

LA237:     .byte  $80,$40,$20,$10,$08,$04,$02,$01
LA23F:     lda    $90
           bne    LA236
           bit    $DA
           bpl    LA249
           bvc    LA236
LA249:     ldx    #$02
           jsr    LA264
           clc
           lda    #<LA0E1+1
           sbc    $D2
           sta    $C9
           jsr    LA0CA
           clc
           lda    #<LA0E4
           adc    $D2
           sta    $C9
           ldx    #$04
           jmp    LA0CA

LA264:     lda    $4A,x
           and    #$F8
           lsr    a
           lsr    a
           tay
           lda    LA2CB+0,y
           adc    $4B,x
           sta    $C3,x
           lda    LA2CB+1,y
           adc    #$00
           sta    $C4,x
           lda    LA2CB+2,y
           adc    $4B,x
           sta    $C5,x
           lda    LA2CB+3,y
           adc    #$00
           sta    $C6,x
           lda    $4A,x
           and    #$07
           sta    $D2
           rts

LA28E:     lda    $D8
           and    #$F8
           lsr    a
           lsr    a
           tay
           lda    LA2CB+0,y
           sta    $A5
           lda    LA2CB+1,y
           sta    $A6
           lda    LA2CB+2,y
           sta    $A7
           lda    LA2CB+3,y
           sta    $A8
           lda    $D8
           and    #$07
           sta    $D2
           rts

LA2B0:     jsr    LAC38
           jsr    LA18A
           jsr    LA211
           jsr    LA164
           jsr    LA21F
           jsr    LA10D
           jsr    LA1AC
           jsr    LA23F
           jmp    LA514

LA2CB:     .byte  $00,>CHARSET-$10+$10,$B0,>CHARSET-$10+$10,$60,>CHARSET-$10+$11,$10,>CHARSET-$10+$12
           .byte  $C0,>CHARSET-$10+$12,$70,>CHARSET-$10+$13,$20,>CHARSET-$10+$14,$D0,>CHARSET-$10+$14
           .byte  $80,>CHARSET-$10+$15,$30,>CHARSET-$10+$16,$E0,>CHARSET-$10+$16,$90,>CHARSET-$10+$17
           .byte  $40,>CHARSET-$10+$18,$F0,>CHARSET-$10+$18,$A0,>CHARSET-$10+$19,$50,>CHARSET-$10+$1A
           .byte  $00,>CHARSET-$10+$1B,$B0,>CHARSET-$10+$1B,$60,>CHARSET-$10+$1C,$10,>CHARSET-$10+$1D
           .byte  $C0,>CHARSET-$10+$1D,$70,>CHARSET-$10+$1E,$20,>CHARSET-$10+$1F,$D0,>CHARSET-$10+$1F
           .byte  $80,>CHARSET-$10+$0A,$30,>CHARSET-$10+$0B,$E0,>CHARSET-$10+$0B,$90,>CHARSET-$10+$0C
           .byte  $40,>CHARSET-$10+$0D,$F0,>CHARSET-$10+$0D,$50,>CHARSET-$10+$0E,$50,>CHARSET-$10+$0F
           .byte  $00,>CHARSET-$10+$10

LA30D:     lda    #$00
           sta    VIA2+$2
           lda    JOY_REG_RIGHT
           and    #JOY_MASK_RIGHT
           sta    $D4
           lda    JOY_REG_OTHER
           asl    a
           and    #(JOY_MASK_LEFT|JOY_MASK_BUTTON)*2
           ora    $D4
           eor    #$FF
           sta    $D4
           lda    #$FF
           sta    VIA2+$2
           ldy    #$0B
LA32C:     lda    LA368,y
           sta    VIA2+$0
           lda    VIA2+$1
           eor    #$FF
           and    LA374,y
           beq    LA350
           cpy    #$08
           bcc    LA354
           bne    LA349
           lda    $DA
           ora    #$10
           sta    $DA
           rts

LA349:     lda    LA377,y
           ora    $D4
           sta    $D4
LA350:     dey
           bpl    LA32C
           rts

LA354:     cpy    $D9
           sty    $D9
           bne    LA360
           bit    $DA
           bpl    LA360
           bvc    LA363
LA360:     jsr    LA468
LA363:     lda    #$80
           sta    $DA
           rts

LA368:     .byte  $FE,$7F,$FE,$7F,$FE,$7F,$FE,$7F
           .byte  $F7,$E7,$E7,$EF
LA374:     .byte  $01,$01,$02
LA377:     .byte  $02,$04,$04,$08,$08,$01,$70,$0C
           .byte  $01,$80,$20,$40

        ;; main entry point
ENTRY:     cld
           ldx    #$FF
           txs
           lda    #$7F
           sta    VIA2+$E
           sta    VIA1+$E
           lda    #$00
           sta    $9E
           sta    $9D
           tay
           ldx    #$A0
LA398:     sta    ($9D),y
           dey
           bne    LA398
           inc    $9E
           dex
           bne    LA398
           lda    #<LA2B0
           sta    IRQVEC
           lda    #>LA2B0
           sta    IRQVEC+1
           lda    #<LAC7B
           sta    NMIVEC
           lda    #>LAC7B
           sta    NMIVEC+1
           ldy    #$05
LA3B8:     lda    LA429,y
           sta    VIC,y
           dey
           bpl    LA3B8
           lda    #$08
           sta    VIC+$F
           lda    #>LA009
           sta    $CA
           sta    $CC
           jsr    LA455
           jsr    LA433
           jsr    LA468
           jsr    LAC38
           ldx    #$23
LA3DA:     lda    #$E0
           sta    $A5,x
           dex
           bpl    LA3DA
           lda    #$40
           sta    VIA1+$B
           sta    VIA2+$B
           ldy    #$15
LA3EB:     cpy    VIC+$4
           bne    LA3EB
           iny
LA3F1:     cpy    VIC+$4
           bne    LA3F1
           lda    #$DC
           sta    VIA1+$4
           lda    #$00
           sta    VIA1+$5
           lda    #$EF
           sta    VIA1+$6
           lda    #$FF
           sta    VIA1+$7
           lda    #$C0
           sta    VIA1+$E
           ldy    #$74
LA411:     cpy    VIC+$4
           bne    LA411
           lda    #$42
           sta    VIA2+$5
           lda    #$43
           sta    VIA2+$4
           lda    #$C0
           sta    VIA2+$E
           cli
LA426:     jmp    LA426

        ;; init VIC:
        ;; 16x8 (i.e. double-height) character size
        ;; 12 (double-height) rows, 22 columns
        ;; character map at $1000
        ;; screen memory at $0200-$0308
        ;; color at $9600-$9708
LA429:     .byte  $05,$18,$96,$19,$00,$8C
        
LA42F:     .byte  $79,$84,$8F,$9A
        
LA433:     ldy    #$26
           ldx    #$BD
LA437:     sty    $8E
           lda    LA2CB+0,y
           sta    $9D
           lda    LA2CB+1,y
           sta    $9E
           ldy    #$09
LA445:     lda    LAF17,x
           sta    ($9D),y
           dex
           dey
           bpl    LA445
           ldy    $8E
           dey
           dey
           bne    LA437
           rts

LA455:     lda    #$F1
           tay
LA458:     sta    SCREEN,y
           dey
           beq    LA467
           sec
           sbc    #$0B
           bcs    LA458
           adc    #$F1
           bne    LA458
LA467:     rts

LA468:     ldx    #$9B
           lda    #$00
LA46C:     sta    $FF,x
           dex
           bne    LA46C
           ldy    #$15
LA473:     lda    #$00
           sta    SCREEN,y
           lda    #$A5
           sta    SCREEN+$F2,y
           lda    #$0F
           sta    COLORRAM+$2F2,y
           dey
           bpl    LA473
           ldx    #$03
LA487:     lda    LA42F,x
           sta    SCREEN+$09,x
           lda    #$07
           sta    COLORRAM+$209,x
           dex
           bpl    LA487
           ldx    #$08
LA497:     lda    #$04
           sta    COLORRAM+$200,x
           lda    #$03
           sta    COLORRAM+$20D,x
           dex
           bpl    LA497
           lda    #$04
           sta    $91
           sta    $92
           lda    #$6E
           sta    $72
           lda    #$46
           sta    $74
           lda    #$28
           sta    $76
           lda    $D9
           and    #$04
           beq    LA4C0
           lda    #$0C
           sta    $93
LA4C0:     ldx    #$4E
           lda    #$00
LA4C4:     sta    $FF,x
           dex
           bne    LA4C4
           sta    $CE
           lda    $93
           lsr    a
           sta    $94
           cmp    #$06
           bcc    LA4DE
LA4D4:     sbc    #$06
           cmp    #$06
           bcs    LA4D4
           sta    $94
           lda    #$05
LA4DE:     tax
           and    #$06
           asl    a
           asl    a
           eor    #$FF
           adc    #$19
           sta    $3E
           lda    LAC28,x
           sta    $99
           lda    LAB3F,x
           sta    $40
           lda    LAB39,x
           sta    $3F
           lda    #$0A
           sta    $42
           lda    #$55
           sta    $4C
           lda    #$A3
           sta    $4D
           ldx    $96
           lda    LA512,x
           ldy    #$15
LA50B:     sta    COLORRAM+$2F2,y
           dey
           bpl    LA50B
           rts

LA512:     .byte  $0B
           .byte  $0C
        
LA514:     bit    $DA
           bvc    LA51C
           lda    #$06
           sta    $98
LA51C:     dec    $97
           bne    LA528
           dec    $98
           bne    LA528
           lda    #$00
           sta    $DA
LA528:     lda    $90
           beq    LA53A
           dec    $90
           bne    LA53A
           bit    $DA
           bvc    LA53A
           ldx    $96
           dec    $91,x
           beq    LA581
LA53A:     lda    $57
           bne    LA555
           bit    $D5
           bvc    LA555
           bit    $D4
           bvs    LA555
           bit    $DA
           bvs    LA54D
           jsr    LA468
LA54D:     lda    $DA
           and    #$EF
           ora    #$C0
           sta    $DA
LA555:     lda    $D4
           sta    $D5
           lda    #$20
           bit    $DA
           bne    LA581
           lda    $42
           ora    $43
           ora    $CE
           bne    LA5BD
           lda    $DA
           ora    #$20
           sta    $DA
           lda    $41
           bne    LA57D
           ldx    $96
           lda    $91,x
           cmp    #$07
           bcs    LA57D
           lda    #$3C
           sta    $56
LA57D:     lda    #$00
           sta    $41
LA581:     lda    $56
           ora    $57
           bne    LA5BD
           lda    #$C0
           sta    $DA
           lda    $D9
           and    #$01
           beq    LA5A1
           eor    $96
           tax
           ldy    $91,x
           beq    LA5A1
           stx    $96
           lda    #$78
           sta    $9A
           txa
           bne    LA5AA
LA5A1:     ldx    $93
           inx
           bpl    LA5A8
           ldx    #$74
LA5A8:     stx    $93
LA5AA:     ldx    $96
           lda    $91,x
           bne    LA5BA
           lda    #$80
           sta    $DA
           lda    #$FF
           sta    $57
           dec    $93
LA5BA:     jsr    LA4C0
LA5BD:     jsr    LAC2E
           jsr    LABAF
           jsr    LA30D
           jsr    LA5F3
           jsr    LAA1F
           jsr    LA837
           lda    $DA
           and    #$10
           bne    LA5E4
           jsr    LAB55
           jsr    LA6FA
           jsr    LA90C
           jsr    LAA70
           jsr    LA7E3
LA5E4:     jsr    LA979
           jsr    LA884
           lda    VIA2+$4
           pla
           tay
           pla
           tax
           pla
           rti

LA5F3:     lda    #$10
           bit    $DA
           bpl    LA5FB
           ora    $52
LA5FB:     sta    $52
           ldx    #$04
           ldy    #$00
LA601:     lda    $4E,x
           sta    VIC+$A,x
           sty    $4E,x
           dex
           bpl    LA601
           lda    $56
           beq    LA62E
           dec    $56
           lda    $56
           bne    LA619
           ldx    $96
           inc    $91,x
LA619:     lsr    a
           lsr    a
           tax
           lda    LA6EA,x
           sta    $50
           beq    LA62D
           lda    $56
           and    #$03
           asl    a
           asl    a
           ora    #$02
           sta    $52
LA62D:     rts

LA62E:     lda    $57
           beq    LA64E
           dec    $57
           tay
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           sta    $52
           lda    LAD00,y
           and    #$0E
           eor    #$F0
           sta    $50
           lda    LAD01,y
           and    #$0E
           eor    #$F0
           sta    $4F
           rts

LA64E:     ldy    #$00
           ldx    $53
           beq    LA65F
           dex
           stx    $53
           lda    LA6D2,x
           sta    $51
           ldy    LA6CE,x
LA65F:     lda    $55
           beq    LA66E
           dec    $55
           lda    #$F0
           sec
           sbc    $55
           sta    $51
           ldy    #$0A
LA66E:     lda    $90
           beq    LA67E
           lsr    a
           lsr    a
           sta    $52
           lsr    a
           tax
           lda    LA6E2,x
           sta    $51
           rts

LA67E:     ldx    $54
           beq    LA68F
           inc    $54
           lda    LAD00,x
           ora    #$F8
           tay
           dey
           sty    $50
           ldy    #$09
LA68F:     tya
           sta    $52
           bne    LA62D
           lda    $43
           beq    LA6C1
           lda    $97
           and    #$0F
           sec
           sbc    #$04
           bcc    LA6C1
           tax
           lsr    a
           tay
           lda    $97
           and    #$10
           bne    LA6B6
           lda    LA6C2,x
           sec
           sbc    $42
           sbc    $42
           sta    $4F
           sty    $52
LA6B6:     lda    $20
           beq    LA6C1
           lda    LA6D6,x
           sta    $50
           sty    $52
LA6C1:     rts

LA6C2:     .byte  $FC,$F0,$FA,$F0,$F8,$F0,$F6,$F0
           .byte  $F4,$F0,$F2,$F0
LA6CE:     .byte  $0F,$0A,$06,$03
LA6D2:     .byte  $F0,$E0,$D0,$C0
LA6D6:     .byte  $F8,$F7,$F6,$F7,$F8,$F7,$F8,$F9
           .byte  $FA,$FB,$FA,$FA
LA6E2:     .byte  $AA,$C8,$DC,$E6,$AA,$C8,$DC,$E6
LA6EA:     .byte  $E9,$00,$00,$E4,$00,$00,$00,$E2
           .byte  $E7,$E4,$E9,$E7,$EB,$E9,$ED,$00
        
LA6FA:     ldx    #$07
LA6FC:     lda    $20,x
           beq    LA740
           cmp    #$0D
           beq    LA72D
           cpx    #$02
           bne    LA70C
           lda    $01
           bne    LA72D
LA70C:     lda    $16,x
           and    #$07
           tay
           lda    LA7C5,y
           cpx    #$00
           bne    LA71B
           lda    LA7CD,y
LA71B:     clc
           adc    $7A,x
           sta    $7A,x
           bcc    LA72D
           lda    $16,x
           and    #$20
           beq    LA72B
           inc    $66,x
           .byte  $2C
LA72B:     dec    $66,x
LA72D:     lda    $20,x
           beq    LA740
           cmp    #$04
           beq    LA740
           cmp    #$01
           beq    LA740
           lda    $66,x
           clc
           adc    #$08
           sta    $67,x
LA740:     dex
           bpl    LA6FC
           ldx    #$04
LA745:     lda    $22,x
           cmp    #$0D
           beq    LA799
           txa
           bne    LA752
           lda    $01
           bne    LA799
LA752:     lda    $18,x
           and    #$07
           tay
           lda    $86,x
           clc
           adc    LA7CD,y
           sta    $86,x
           bcc    LA799
           lda    $72,x
           adc    $3E
           cmp    LA7DD,x
           bcc    LA77B
           cmp    LA7DE,x
           bcs    LA77B
           lda    $CE
           beq    LA785
           lda    $72,x
           adc    #$08
           cmp    $CE
           bcc    LA785
LA77B:     lda    #$F0
           and    $18,x
           bcs    LA783
           ora    #$08
LA783:     sta    $18,x
LA785:     ldy    $72,x
           lda    $18,x
           and    #$08
           bne    LA78F
           dey
           .byte  $24
LA78F:     iny
           tya
           adc    #$0A
           cmp    $70,x
           bcs    LA799
           sty    $72,x
LA799:     ldy    $72,x
           sty    $73,x
           dex
           dex
           bpl    LA745
           lda    $20
           cmp    #$04
           bne    LA7C4
           lda    $16
           and    #$07
           tay
           lda    LA7D5,y
           clc
           adc    $70
           sta    $70
           cmp    #$A9
           bcs    LA7BC
           lda    $90
           beq    LA7C4
LA7BC:     lda    #$00
           sta    $34
           sta    $20
           dec    $43
LA7C4:     rts

LA7C5:     .byte  $FF,$C0,$A0,$80,$80,$A0,$C0,$FF
LA7CD:     .byte  $40,$80,$C0,$F0,$F0,$C0,$80,$40
LA7D5:     .byte  $01,$01,$01,$01,$01,$FF,$FF,$FF
LA7DD:     .byte  $78
LA7DE:     .byte  $8E,$5A,$6E,$37,$50
        
LA7E3:     lda    $43
           beq    LA7C4
           lda    $34
           ora    $CE
           ora    $90
           bne    LA7C4
           ldx    #$01
           lda    $22
           ora    $23
           beq    LA804
           cmp    #$04
           bne    LA7C4
           lda    $22
           beq    LA804
           dex
           lda    $23
           bne    LA7C4
LA804:     ldy    #$00
LA806:     lda    $22,x
           sta    $20,y
           lda    $68,x
           sta    $66,y
           lda    $72,x
           sta    $70,y
           lda    $18,x
           sta    $16,y
           lda    $2C,x
           sta    $2A,y
           lda    $36,x
           sta    $34,y
           inx
           txa
           tay
           cpx    #$06
           bne    LA806
           ldx    #$00
           stx    $26
           stx    $27
           stx    $3A
           stx    $3B
           dex
           rts

LA837:     ldx    #$04
LA839:     lda    $22,x
           cmp    #$0D
           bne    LA87F
           lda    $46
           clc
           adc    $44
           sta    $46
           bcc    LA84A
           inc    $48
LA84A:     lda    $47
           clc
           adc    $45
           sta    $47
           bcs    LA855
           dec    $49
LA855:     lda    $7C,x
           clc
           adc    $46
           sta    $7C,x
           lda    $68,x
           adc    $48
           sta    $68,x
           adc    #$08
           sta    $69,x
           lda    $82
           adc    $47
           sta    $82
           lda    $6E
           adc    $49
           sta    $6E
           clc
           adc    #$08
           sta    $6F
           lda    $36,x
           sta    $3C
           lda    $37,x
           sta    $3D
LA87F:     dex
           dex
           bpl    LA839
           rts

LA884:     lda    $97
           and    #$07
           tax
           lda    $20,x
           beq    LA8C1
           dec    $2A,x
           bpl    LA8A3
           lda    $20,x
           cmp    #$0A
           beq    LA8DA
           cmp    #$01
           beq    LA8F7
           cmp    #$07
           beq    LA8F3
           cmp    #$0D
           beq    LA8C2
LA8A3:     lda    $2A,x
           and    #$03
           tay
           lda    LA902,y
           clc
           adc    $20,x
LA8AE:     sta    $34,x
           ldy    $20,x
           beq    LA8C1
           cpy    #$04
           beq    LA8C1
           cpy    #$01
           beq    LA8C1
           clc
           adc    #$1B
           sta    $35,x
LA8C1:     rts

LA8C2:     bit    $DA
           bpl    LA8C8
           dec    $42
LA8C8:     inc    $43
           lda    #$00
           sta    $3C
           sta    $3D
           ldy    $94
           lda    LA906,y
           sta    $20,x
           jmp    LA8AE

LA8DA:     lda    #$08
           sta    $16,x
           lda    #$28
           sta    $17,x
           lda    #$04
           sta    $20,x
           sta    $21,x
           sta    $34,x
           sta    $35,x
           lda    #$00
           sta    $54
           inc    $43
           rts

LA8F3:     lda    #$00
           sta    $35,x
LA8F7:     lda    #$00
           sta    $20,x
           sta    $34,x
           sta    $54
           dec    $43
           rts

LA902:     .byte  $00,$01,$02,$01
LA906:     .byte  $10,$13,$16,$19,$1C,$1F
        
LA90C:     lda    $9A
           beq    LA913
           dec    $9A
           rts

LA913:     lda    $55
           bne    LA978
           ldy    $42
           beq    LA978
           lda    $90
           bne    LA978
           bit    $DA
           bpl    LA925
           bvc    LA978
LA925:     lda    $97
           and    #$3F
           cmp    #$02
           bcc    LA978
           tax
           and    #$79
           ora    $20,x
           ora    $21,x
           bne    LA978
           lda    $70,x
           adc    #$0A
           cmp    $6E,x
           bcs    LA978
           lda    #$F0
           sta    $66,x
           lda    #$F8
           sta    $67,x
           lda    #$AC
           sta    $6E
           lda    #$B4
           sta    $6F
           jsr    LAC2E
           and    #$3F
           adc    #$0F
           sta    $44
           sec
           sbc    #$5E
           sta    $45
           lda    #$00
           sta    $46
           sta    $47
           sta    $48
           sta    $49
           lda    #$0D
           sta    $20,x
           lda    $70,x
           sta    $78
           sta    $79
           lda    #$04
           sta    $2A,x
           lda    #$21
           sta    $55
LA978:     rts

LA979:     ldx    #$07
           lda    $4B
           beq    LA9AF
LA97F:     lda    $70,x
           sbc    $4B
           clc
           adc    #$07
           sbc    #$11
           bcs    LA9AC
           ldy    $20,x
           cpy    #$04
           beq    LA994
           cpy    #$10
           bcc    LA9AC
LA994:     ldy    $34,x
           lda    LA9E5,y
           lsr    a
           bcs    LA99F
           sbc    #$07
           .byte  $2C
LA99F:     sbc    #$03
           adc    $4A
           sec
           sbc    $66,x
           clc
           sbc    LA9E5,y
           bcc    LA9B0
LA9AC:     dex
           bpl    LA97F
LA9AF:     rts

LA9B0:     lda    $20,x
           asl    a
           asl    a
           asl    a
           sta    $54
           ldy    #$01
           txa
           bne    LA9BE
           ldy    #$03
LA9BE:     lda    $20,x
           cmp    #$04
           beq    LA9D1
           dey
           lda    $93
           cmp    #$04
           bcc    LA9CE
           lda    #$0A
           .byte  $2C
LA9CE:     lda    #$07
           .byte  $2C
LA9D1:     lda    #$01
           sta    $20,x
           lda    #$04
           sta    $2A,x
           lda    #$00
           sta    $4B
           bit    $DA
           bpl    LA9E4
           jsr    LABD2
LA9E4:     rts

LA9E5:     .byte  $00,$00,$00,$00,$07,$09,$09,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $12,$12,$10,$0E,$12,$10,$0E,$0E
           .byte  $12,$12,$12,$12,$10,$0E,$10,$04
           .byte  $08,$0A
LAA07:     lda    $4C
           ldy    $20,x
           cpy    #$04
           beq    LAA11
           sbc    #$04
LAA11:     cmp    $66,x
           lda    $16,x
           bcc    LAA1A
           ora    #$20
           .byte  $2C
LAA1A:     and    #$DF
           sta    $16,x
           rts

LAA1F:     lda    $97
           and    #$03
           asl    a
           tax
           txa
           beq    LAA34
           ldy    $D3
           cpy    #$1F
           bcs    LAA34
           lda    $16,x
           eor    #$20
           sta    $16,x
LAA34:     jsr    LAA38
           inx
LAA38:     inc    $16,x
           lda    $16,x
           and    #$EF
           sta    $16,x
           cpx    #$02
           beq    LAA4A
           bcs    LAA5D
           and    #$07
           bne    LAA5D
LAA4A:     jsr    LAA07
           lda    $16,x
           cpx    #$02
           bne    LAA5D
           ldy    $70,x
           cpy    $4B
           bcs    LAA5D
           eor    #$20
           sta    $16,x
LAA5D:     lda    $16,x
           ldy    $66,x
           cpy    #$05
           bcs    LAA67
           ora    #$20
LAA67:     cpy    #$A0
           bcc    LAA6D
           and    #$DF
LAA6D:     sta    $16,x
           rts

LAA70:     lda    $20
           bne    LAADD
           lda    #$B0
           sta    $70
           lda    $22
           bne    LAA7E
           sta    $01
LAA7E:     lda    $90
           bne    LAADD
           lda    $93
           cmp    #$08
           bcc    LAA8B
           jsr    LAB2C
LAA8B:     lda    $CE
           bne    LAA92
           jsr    LAAEE
LAA92:     dec    $00
           bpl    LAADD
           lda    $3F
           sta    $00
           lda    $D0
           cmp    #$AB
           bcs    LAAA4
           adc    #$08
           sta    $D0
LAAA4:     lda    $D3
           sta    $8E
           ldx    #$09
           ldy    #$09
           lda    $01
           beq    LAAB1
           iny
LAAB1:     lda    $02,x
           bcc    LAAB9
           clc
LAAB6:     rol    a
           bcc    LAABC
LAAB9:     ror    a
           bcs    LAAB6
LAABC:     sta    $02,y
           ror    $8E
           dey
           dex
           bpl    LAAB1
           lda    $01
           beq    LAADE
           dec    $01
           lda    $D3
           and    #$0F
           ldy    $22
           cpy    #$04
           bne    LAAD7
           and    #$07
LAAD7:     tay
           lda    LAB45,y
           sta    $02
LAADD:     rts

LAADE:     lda    $CE
           beq    LAADD
           clc
           adc    #$08
           cmp    #$AB
           bcc    LAAEB
           lda    #$00
LAAEB:     sta    $CE
           rts

LAAEE:     lda    $34
           ora    $55
           ora    $90
           bne    LAB38
           sta    $00
           lda    $72
           adc    $3E
           cmp    LA7DD
           bcc    LAB38
           lda    $22
           ldy    #$24
           cmp    #$04
           beq    LAB0F
           cmp    #$10
           bcc    LAB38
           ldy    #$81
LAB0F:     sty    $D7
           lda    $94
           lsr    a
           lda    #$03
           bcs    LAB1A
           and    $D3
LAB1A:     clc
           adc    #$01
           sta    $01
           inc    $01
           lda    $72
           ora    #$03
           clc
           adc    #$08
           sta    $CE
           sta    $D0
LAB2C:     lda    $68
           ldy    $22
           cpy    #$04
           beq    LAB36
           adc    #$03
LAB36:     sta    $D8
LAB38:     rts

LAB39:     .byte  $08,$05,$05,$03,$05,$05
LAB3F:     .byte  $03,$03,$04,$04,$06,$06
LAB45:     .byte  $00,$20,$10,$08,$04,$24,$28,$14
           .byte  $90,$40,$02,$09,$42,$88,$11,$44
LAB55:     lda    $90
           bne    LAB7C
           ldy    $4C
           bit    $DA
           bvs    LAB67
           bmi    LABAE
           bit    $97
           bmi    LAB71
           bpl    LAB6F
LAB67:     lda    #$20
           bit    $D4
           bne    LAB71
           bpl    LAB7C
LAB6F:     iny
           .byte  $24
LAB71:     dey
           cpy    #$0A
           bcc    LAB7C
           cpy    #$A0
           bcs    LAB7C
           sty    $4C
LAB7C:     lda    $4B
           bne    LAB92
           lda    $90
           bne    LABAE
           bit    $D4
           bvs    LAB8C
           lda    $DA
           .byte  $D0
LAB8B:     .byte  $22
LAB8C:     lda    #$04
           sta    $53
           lda    $4D
LAB92:     sec
           sbc    $40
           cmp    #$10
           bcs    LAB9B
           lda    #$00
LAB9B:     sta    $4B
           cmp    #$8C
           lda    $D9
           and    #$02
           bne    LABA7
           bcc    LABAE
LABA7:     lda    $4C
           clc
           adc    #$03
           sta    $4A
LABAE:     rts

LABAF:     ldx    $96
           lda    $91,x
           sta    $8E
           lda    $56
           lsr    a
           lsr    a
           and    #$03
           tax
           ldy    #$06
LABBE:     lda    #$A5
           cpy    $8E
           bcs    LABC7
           lda    LABCE,x
LABC7:     sta    SCREEN+$F2,y
           dey
           bne    LABBE
           rts

LABCE:     bcs    LAB8B
           dec    $BB
LABD2:     lda    $96
           ora    #$06
           tax
           lda    $99
           clc
           sed
LABDB:     adc    $58,x
           sta    $58,x
           lda    #$00
           dex
           dex
           bcs    LABDB
           dey
           bpl    LABD2
           cld
           ldx    #$00
           ldy    #$0D
           jsr    LABF4
           ldx    #$01
           ldy    #$01
LABF4:     bit    LAC0E
LABF7:     lda    $58,x
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           jsr    LAC0E
           lda    $58,x
           and    #$0F
           jsr    LAC0E
           inx
           inx
           cpx    #$08
           bcc    LABF7
           rts

LAC0E:     bvc    LAC17
           bne    LAC17
           cpy    #$0A
           bcs    LAC23
           rts

LAC17:     clc
           adc    #$01
           sta    $8E
           asl    a
           asl    a
           adc    $8E
           asl    a
           adc    $8E
LAC23:     sta    SCREEN,y
           iny
           rts

LAC28:     .byte  $10,$15,$20,$25,$30,$35
LAC2E:     lda    $D3
           asl    a
           bcs    LAC35
           eor    #$71
LAC35:     sta    $D3
           rts

LAC38:     ldx    #$04
           ldy    #$02
LAC3C:     lda    $22,x
           ora    $23,x
           beq    LAC54
           lda    $72,x
           sta    $DC,y
           lda    $93
           and    #$03
           asl    a
           asl    a
           asl    a
           adc    #$08
           sta    $E8,y
           iny
LAC54:     dex
           dex
           bpl    LAC3C
           lda    #$AC
           sta    $DC,y
           lda    $96
           asl    a
           asl    a
           sta    $E8,y
           lda    #$00
           iny
           sta    $DC,y
           sta    $DC
           sty    $DB
           lda    #$28
           sta    $E8
           lda    #$2B
           sta    $E9
           lda    #$10
           sta    $DD
           rts

LAC7B:     cld
           pha
           txa
           pha
           tya
           pha
           ldx    $DB
           beq    LAC89
           lda    $DC,x
           beq    LACD0
LAC89:     inc    $DB
           ldy    $E8,x
           lda    LAFCB,y
           iny
           sta    VIC+$F
           lda    $DD,x
           sec
           sbc    $DC,x
           sta    $E6
           lsr    a
           lsr    a
           tax
           lda    $E6
           ror    a
           ror    a
           and    #$80
           ror    a
           adc    $E6
           bcc    LACAA
           inx
LACAA:     clc
           adc    VIA1+$4
           sta    VIA1+$4
           txa
           adc    #$FF
           sta    VIA1+$5
           lda    LAFCB,y
           jmp    LACC2

LACBD:     ldx    #$08
LACBF:     dex
           bpl    LACBF
LACC2:     sta    VIC+$F
           nop
           nop
           nop
           iny
           lda    LAFCB,y
           bne    LACBD
           beq    LACEB
LACD0:     lda    #$00
           sta    $DB
           ldy    #$15
LACD6:     cpy    VIC+$4
           bne    LACD6
           iny
LACDC:     cpy    VIC+$4
           bne    LACDC
           lda    #$DA
           sta    VIA1+$4
           lda    #$00
           sta    VIA1+$5
LACEB:     lda    #$F1
           sta    VIA1+$6
           lda    #$FF
           sta    VIA1+$7
           pla
           tay
           pla
           tax
           pla
           rti

           ;; [unused?]
           .byte  $13,$8C,$09,$03,$0C
                
LAD00:     .byte  $00
LAD01:     .byte  $00,$00,$00,$00,$00,$00,$08,$02
           .byte  $40,$00,$10,$04,$11,$40,$12,$00
           .byte  $20,$02,$10,$02,$00,$90,$04,$20
           .byte  $02,$00,$22,$00,$82,$C6,$6C,$28
           .byte  $10,$00,$00,$00,$00,$6C,$D6,$82
           .byte  $82,$00,$10,$7C,$C6,$82,$82,$44
           .byte  $10,$40,$02,$00,$08,$20,$88,$02
           .byte  $48,$00,$04,$40,$08,$40,$00,$09
           .byte  $20,$04,$40,$00,$44,$90,$42,$14
           .byte  $80,$11,$04,$20,$84,$40,$14,$A0
           .byte  $12,$04,$40,$20,$14,$08,$68,$14
           .byte  $20,$00,$00,$3F,$00,$00,$7E,$00
           .byte  $0F,$FC,$00,$3F,$00,$00,$7C,$00
           .byte  $00,$00,$3C,$00,$7C,$00,$1F,$00
           .byte  $02,$F0,$19,$0E,$07,$03,$00,$04
           .byte  $00,$71,$CE,$03,$06,$08,$01,$02
           .byte  $1F,$23,$46,$4C,$0C,$0F,$14,$24
           .byte  $22,$21,$10,$00,$06,$1F,$64,$84
           .byte  $82,$40,$00,$00,$03,$0F,$14,$24
           .byte  $44,$00,$04,$0A,$04,$02,$1D,$36
           .byte  $00,$0A,$08,$24,$32,$1E,$09,$24
           .byte  $10,$48,$E4,$B2,$9F,$02,$00,$64
           .byte  $90,$88,$87,$8F,$9F,$04,$70,$88
           .byte  $87,$8C,$98,$4F,$32,$48,$87,$8C
           .byte  $98,$4C,$27,$08,$14,$23,$23,$24
           .byte  $44,$04,$18,$27,$23,$24,$28,$24
           .byte  $20,$3F,$47,$42,$44,$48,$20,$10
           .byte  $00,$00,$01,$01,$00,$00,$00,$00
           .byte  $00,$03,$05,$03,$00,$00,$00,$06
           .byte  $09,$09,$09,$06,$00,$08,$02,$40
           .byte  $00,$10,$04,$11,$40,$12,$00,$20
           .byte  $02,$10,$02,$00,$90,$04,$20,$02
           .byte  $00,$22,$09,$42,$28,$01,$88,$20
           .byte  $04,$21,$02,$28,$05,$48,$20,$02
           .byte  $04,$28,$10,$16,$28,$04,$00,$3F
           .byte  $00,$00,$F0,$00,$7C,$00,$00,$00
           .byte  $0F,$00,$F8,$00,$7C,$00,$3E,$00
           .byte  $1F,$00,$7C,$00,$00,$40,$0F,$98
           .byte  $70,$E0,$C0,$00,$20,$00,$8E,$73
           .byte  $C0,$60,$10,$80,$40,$F8,$C4,$62
           .byte  $32,$30,$F0,$28,$24,$44,$84,$08
           .byte  $00,$60,$F8,$26,$21,$41,$02,$00
           .byte  $00,$C0,$F0,$28,$24,$22,$00,$20
           .byte  $50,$20,$40,$B8,$6C,$00,$50,$10
           .byte  $24,$4C,$78,$90,$24,$08,$12,$27
           .byte  $4D,$F9,$40,$00,$26,$09,$11,$E1
           .byte  $F1,$F9,$20,$0E,$11,$E1,$31,$19
           .byte  $F2,$4C,$12,$E1,$31,$19,$32,$E4
           .byte  $10,$28,$C4,$C4,$24,$22,$20,$18
           .byte  $E4,$C4,$24,$14,$24,$04,$FC,$E2
           .byte  $42,$22,$12,$04,$08,$00,$00,$80
           .byte  $80,$00,$00,$00,$00,$00,$C0,$A0
           .byte  $C0,$00,$00,$00,$60,$90,$90,$90
           .byte  $60,$00
LAEAB:     .byte  $28,$28,$28,$28,$6C,$6C,$EE,$EE
           .byte  $C6,$C6,$C6,$C6
LAEB7:     .byte  $06,$03,$01,$00,$00,$A0,$C0,$80
           .byte  $00,$00,$06,$01,$04,$02,$00,$A0
           .byte  $80,$20,$40,$00,$0A,$00,$02,$10
           .byte  $04,$60,$00,$40,$08,$20,$10,$02
           .byte  $04,$40,$10,$08,$40,$20,$02,$08
           .byte  $00,$10,$02,$44,$00,$00,$08,$40
           .byte  $22,$00,$00,$40,$90,$02,$08,$00
           .byte  $02,$09,$40,$10,$40,$80,$08,$00
           .byte  $24,$02,$01,$10,$00,$24,$80,$00
           .byte  $00,$00,$84,$01,$00,$00,$00,$21
LAF07:     .byte  $50,$4B,$46,$41,$3C,$37,$32,$2D
           .byte  $28,$23,$1E,$19,$14,$0F,$0A,$05
LAF17:     .byte  $00,$7C,$64,$64,$64,$64,$64,$64
           .byte  $64,$7C,$00,$38,$18,$18,$18,$18
           .byte  $18,$18,$18,$18,$00,$7C,$4C,$4C
           .byte  $0C,$3C,$40,$4C,$4C,$7C,$00,$7C
           .byte  $4C,$4C,$0C,$38,$0C,$4C,$4C,$7C
           .byte  $00,$4C,$4C,$4C,$4C,$4C,$4C,$7E
           .byte  $0C,$0C,$00,$7C,$4C,$40,$7C,$0C
           .byte  $0C,$4C,$4C,$7C,$00,$7C,$4C,$4C
           .byte  $40,$7C,$4C,$4C,$4C,$7C,$00,$7C
           .byte  $4C,$4C,$0C,$18,$18,$30,$30,$30
           .byte  $00,$7C,$64,$64,$64,$7C,$4C,$4C
           .byte  $4C,$7C,$00,$7C,$4C,$4C,$4C,$7C
           .byte  $0C,$4C,$4C,$7C,$3F,$40,$48,$89
           .byte  $89,$89,$89,$49,$40,$3F,$FF,$00
           .byte  $A3,$54,$54,$57,$54,$54,$00,$FF
           .byte  $FF,$00,$19,$A5,$A1,$AD,$A5,$99
           .byte  $00,$FF,$FC,$02,$32,$49,$41,$41
           .byte  $49,$32,$02,$FC,$AA,$00,$AA,$00
           .byte  $00,$AA,$00,$00,$00,$AA,$AA,$00
           .byte  $AE,$0C,$0C,$AE,$33,$33,$33,$BB
           .byte  $AA,$00,$AA,$00,$0C,$AE,$0C,$33
           .byte  $33,$BB,$AA,$00,$AA,$00,$00,$AA
           .byte  $0C,$0C,$33,$BB
LAFCB:     .byte  $50,$30,$60,$00,$80,$40,$20,$00
           .byte  $10,$60,$60,$40,$40,$80,$70,$00
           .byte  $10,$20,$20,$40,$80,$80,$70,$00
           .byte  $10,$40,$80,$80,$50,$30,$70,$00
           .byte  $10,$60,$60,$30,$50,$10,$70,$00
           .byte  $08,$08,$00,$70,$70,$00,$2B,$63
           .byte  $36,$3E,$91,$1C,$5F
