;;; Sirius SPIDER_CIRY for VIC-20
        
VIC               := $9000      ; $9000-$900F
VIA1              := $9110      ; $9110-$911F
VIA2              := $9120      ; $9120-$912F
COLORRAM          := $9400      ; $9600-$96C7
CHARSET           := $1000      ; $1000-$1F1F (22 cols*11 rows*16 bytes/char)
SCREEN            := $1E00      ; $1E00-$1FFF
CHARROM           := $8000      ; $8000-$8FFF
JOY_REG_RIGHT     := VIA2+$0
JOY_REG_OTHER     := VIA1+$1
IRQVEC            := $0314

           .org $A000
           .setcpu "6502"

           .word  ENTRY,ENTRY
           .byte  $41,$30,$C3,$C2,$CD ; "A0cbm" signature (PETSCII)

        ;; VIA1 initialization
LA009:     .byte  $EF,$C7,$AB,$80,$F7,$DF,$F7,$DF
           .byte  $00,$00,$FF,$40,$FE,$00,$7F,$88
        ;; VIA2 initialization
LA019:     .byte  $E3,$88,$7F,$00,$A0,$84,$8E,$84
           .byte  $00,$00,$FF,$40,$DE,$00,$C0,$FF
        ;; VIC initialization
        ;; 22 columns, 13 rows, 8x16 character size
        ;; charset at $1000, screen at $1E00, color at $9600
LA029:     .byte  $05,$AA,$96,$1B
LA02D:     .byte  $FF,$FC
LA02F:     .byte  $00,$C0,$03,$FF,$25,$10,$00,$00,$01,$08
        
LA039:     lda    $D3
           asl    a
           asl    a
           asl    a
           asl    a
           ora    $D0
           sta    VIC+$E
           lda    #$78
           eor    $5F
           sta    VIC+$F
           lda    $D3
           ldx    #$05
LA04F:     ldy    LAED9,x
           sta    COLORRAM+$2F5,y
           dex
           bpl    LA04F
           jmp    LA341

IRQ:       ldx    $B6
           inc    $B6
           lda    LAF9E,x
           sta    VIA2+$6
           lda    LAFA3,x
           sta    VIA2+$7
           dex
           bmi    LA07D
           beq    LA0DC
           dex
           beq    LA08E
           dex
           beq    LA039
           dex
           stx    $B6
           lda    #$08
           bne    LA081
LA07D:     lda    #$78
           eor    $5F
LA081:     sta    VIC+$F
           lda    #$A0
           ora    $D0
           sta    VIC+$E
           jmp    LA341

LA08E:     ldy    #$2E
           txa
LA091:     sta    CHARSET+$40,y
           sta    CHARSET+$A0,y
           dey
           bpl    LA091
           lda    #$D8
           eor    $5F
           sta    VIC+$F
           inc    VIA1+$7
           inc    $1A
           ldy    $4E
           lda    LACCB,y
           and    #$F0
           eor    $5F
           ora    $D0
           sta    VIC+$E
           lda    ($00,x)
           lda    $1A
           asl    a
           asl    a
           asl    a
           sta    $FD
           ldy    #$08
           txa
           ldx    #$2F
           sty    VIC+$F
LA0C5:     sta    CHARSET+$70,x
           sta    CHARSET+$D0,x
           dex
           bpl    LA0C5
           ldx    #$10
LA0D0:     sta    SCREEN+$78,x
           sta    SCREEN+$89,x
           dex
           bpl    LA0D0
           jmp    LA341

LA0DC:     lda    $5A
           and    #$3C
           asl    a
           asl    a
           ora    #$08
           sta    VIC+$F
           stx    $EF
           lda    $D1
           and    #$0F
           ldy    $B5
           beq    LA0F2
           txa
LA0F2:     sta    $D0
           cli
           ldy    #$03
LA0F7:     lda    $54,y
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           ora    #$10
           sta    SCREEN+$08,x
           inx
           lda    $54,y
           and    #$0F
           ora    #$10
           sta    SCREEN+$08,x
           inx
           dey
           bne    LA0F7
           lda    #$36
LA114:     ldy    SCREEN+$02,x
           cpy    #$10
           bne    LA123
           sta    SCREEN+$02,x
           inx
           cpx    #$0B
           bne    LA114
LA123:     ldx    #$05
           lda    #$09
LA127:     ldy    LAED9,x
           sta    COLORRAM+$2F5,y
           dex
           bpl    LA127
           jsr    LA5F8
LA133:     lda    VIA2+$5
           cmp    #$05
           bcs    LA133
           ldy    #$00
           tya
           sta    $21
LA13F:     sta    SCREEN+$16,y
           iny
           cpy    #$62
           bne    LA13F
           ldx    $58
           beq    LA189
           bpl    LA150
           jsr    LAF09
LA150:     lda    $58
           cmp    #$50
           bcs    LA168
           and    #$07
           cmp    #$07
           bne    LA168
           ldx    $4E
           ldy    #$00
LA160:     lda    $53
           jsr    LADAD
           dex
           bne    LA160
LA168:     ldy    #$3F
           ldx    $1A
           lda    #$1B
LA16E:     inx
           inx
           inx
           inx
           cpx    #$84
           bcs    LA179
           sta    SCREEN+$16,x
LA179:     dey
           bpl    LA16E
           ldx    #$84
LA17E:     lda    #$04
           sta    COLORRAM+$215,x
           dex
           bne    LA17E
           jmp    LA331

LA189:     lda    #>SCREEN
           sta    $F5
           eor    #>(SCREEN .BITXOR (COLORRAM+$200))
           sta    $F7
LA191:     lda    $01,x
           sta    $F6
           sta    $F4
           lda    $3C,x
           beq    LA1B9
           lda    $30,x
           lsr    a
           lsr    a
           lsr    a
           tay
           txa
           clc
           adc    #$04
           sta    ($F4),y
           adc    #$06
           iny
           sta    ($F4),y
           lda    $36,x
           eor    $5E
           bne    LA1B4
           eor    $5E
LA1B4:     sta    ($F6),y
           dey
           sta    ($F6),y
LA1B9:     inx
           cpx    #$06
           bne    LA191
           dex
           lda    #>CHARSET
           sta    $F3
           sta    $F9
           lda    #>LAD1C
           sta    $F1
LA1C9:     stx    $FE
           lda    $30,x
           and    #$07
           tay
           lda    LACA8,y
           sta    $ED
           lda    #>LA226
           sta    $EE
           lda    $3C,x
           tay
           lda    LACDE,y
           clc
           adc    #$1C
           sta    $F0
           lda    LAE4D,y
           and    #$0F
           sta    $FF
           cpy    #$07
           bne    LA200
           lda    $25,x
           cmp    #$80
           bne    LA1F9
           inc    $F0
           dec    $FF
LA1F9:     and    #$0F
           clc
           adc    #$03
           bne    LA208
LA200:     lda    LAE4D,y
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           clc
LA208:     adc    LACA2,x
           sta    $F2
           adc    #$60
           sta    $F8
           ldy    $FF
           bit    $FD
LA215:     lda    #$00
           sta    $F6
           lda    ($F0),y
           beq    LA24A
           bvc    LA223
           tax
           lda    $0200,x
LA223:     jmp    ($ED)

        ;; the following code must not cross a page boundary
LA226:     rol    a
           rol    $F6
LA229:     rol    a
           rol    $F6
LA22C:     rol    a
           rol    $F6
           sta    ($F8),y
           lda    $F6
           sta    ($F2),y
           jmp    LA24A
LA238:     ror    a
           ror    $F6
LA23B:     ror    a
           ror    $F6
LA23E:     ror    a
           ror    $F6
LA241:     ror    a
           ror    $F6
LA244:     sta    ($F2),y
        ;; end of code that must not cross a page boundary
           lda    $F6
           sta    ($F8),y
LA24A:     dey
           bpl    LA215
           ldx    $FE
           dex
           bmi    LA255
           jmp    LA1C9

LA255:     bit    $CF
           bpl    LA25C
           jmp    LA341

LA25C:     stx    $1E
           lda    #>CHARSET
           sta    $FF
           lda    $51
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           tay
           lda    $50
           clc
           adc    $00,y
           tay
           lda    $52
           beq    LA294
           ldx    #$01
           lda    $51
           cmp    #$60
           bcc    LA27D
           dex
LA27D:     lda    #$02
           jsr    LACEB
           lda    $51
           and    #$0F
           tax
           ldy    #$03
LA289:     lda    CHARSET+$20,x
           beq    LA290
           sta    $21
LA290:     inx
           dey
           bpl    LA289
LA294:     lda    $A6
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           tay
           lda    $A7
           lsr    a
           lsr    a
           lsr    a
           clc
           adc    $00,y
           tay
           ldx    #>CHARSET+$2
           stx    $FF
           ldx    #$05
           lda    #$20
           jsr    LACEB
           lda    $A6
           and    #$0F
           tax
           lda    #$0C
           sta    $F2
           lda    $A7
           and    #$06
           lsr    a
           adc    #>CHARSET+$4
           sta    $E8
           sta    $EA
           sta    $EC
           ldy    $A9
           bit    $18
           bmi    LA2D4
           cpy    #$00
           beq    LA2E2
           ldy    #$00
           beq    LA2DC
LA2D4:     bvs    LA2E2
           cpy    #$18
           beq    LA2E2
           ldy    #$18
LA2DC:     sty    $A9
           lda    #$0F
           sta    $1D
LA2E2:     lda    $5B
           beq    LA2F2
           lda    $1A
           lsr    a
           bcc    LA2ED
           dec    $5B
LA2ED:     clc
           tya
           adc    #$0C
           tay
LA2F2:     lda    $5A
           beq    LA2F8
           ldy    #$30
LA2F8:     lda    ($E7),y
           and    CHARSET+$200,x
           beq    LA301
           stx    $1E
LA301:     lda    ($E7),y
           ora    CHARSET+$200,x
           sta    CHARSET+$200,x
           lda    ($E9),y
           and    CHARSET+$220,x
           beq    LA312
           stx    $1E
LA312:     lda    ($E9),y
           ora    CHARSET+$220,x
           sta    CHARSET+$220,x
           lda    ($EB),y
           and    CHARSET+$240,x
           beq    LA323
           stx    $1E
LA323:     lda    ($EB),y
           ora    CHARSET+$240,x
           sta    CHARSET+$240,x
           inx
           iny
           dec    $F2
           bne    LA2F8
LA331:     ldx    #$04
           lda    $51
           and    #$0F
           tay
           lda    #$FF
LA33A:     sta    CHARSET+$1F,y
           iny
           dex
           bne    LA33A
LA341:     bit    VIA2+$4
           pla
           tay
           pla
           tax
           pla
           rti

        ;; main entry point
ENTRY:     sei
           ldy    #$00
           sty    $F0
           ldx    #>CHARSET
           stx    $F1
           tya
LA354:     jsr    LAF53
           dex
           bne    LA354
LA35A:     sta    $00,x
           clc
           adc    #$16
           inx
           cpx    #$0C
           bne    LA35A
           ldx    #$00
           ldy    #>CHARSET+$8
           txa
LA369:     sta    $80,x
           sty    $92,x
           clc
           adc    #$50
           bcc    LA373
           iny
LA373:     inx
           cpx    #$12
           bne    LA369
LA378:     lda    VIC+$4
           bne    LA378
           ldx    #$10
           lda    #$17
LA381:     cmp    VIC+$4
           bne    LA381
LA386:     lda    LA019-1,x
           sta    VIA2-1,x
           lda    LA009-1,x
           sta    VIA1-1,x
           lda    LA029-1,x
           sta    VIC-1,x
           dex
           bne    LA386
           lda    #<IRQ
           sta    IRQVEC
           lda    #>IRQ
           sta    IRQVEC+1
LA3A5:     stx    $FF
           ldy    #$08
           lda    #$00
LA3AB:     lsr    $FF
           rol    a
           dey
           bne    LA3AB
           sta    $0200,x
           inx
           bne    LA3A5
           stx    $B6
           ldy    #$44
LA3BB:     lda    LA5B3,y
           cpy    #$18
           bcs    LA3C8
           ldx    LA5CB,y
           lda    $0200,x
LA3C8:     sta    $F0
           cpy    #$3C
           bcs    LA3D5
           ldx    #$05
LA3D0:     cmp    LAFA8,x
           bne    LA3D7
LA3D5:     ldx    #$AB
LA3D7:     dex
           bpl    LA3D0
           stx    $FF
           jsr    LAF64
           sta    $F1
           jsr    LAF64
           sta    $F0
           lda    #$00
           sta    $F2
           ldx    #$05
LA3EC:     lda    LADC4,x
           sta    $E7,x
           dex
           bpl    LA3EC
           ldx    #$04
LA3F6:     lda    $F0
           sta    ($E7),y
           lda    $F1
           sta    ($E9),y
           lda    $F2
           sta    ($EB),y
           inc    $E8
           inc    $EA
           inc    $EC
           lsr    $F0
           ror    $F1
           ror    $F2
           lsr    $F0
           ror    $F1
           ror    $F2
           dex
           bne    LA3F6
           dey
           bpl    LA3BB
           ldy    #$03
LA41C:     lda    #$FF
           sta    CHARSET+$100,y
           lda    #$06
           sta    $F0
LA425:     lda    LADE8,x
           sta    CHARSET+$101,y
           inx
           iny
           dec    $F0
           bpl    LA425
           lda    #$FF
           sta    CHARSET+$101,y
           tya
           clc
           adc    #$09
           tay
           cpy    #$A8
           bcc    LA41C
           lda    #$03
           sta    $FC
           lda    #>CHARSET+$3
           sta    $FD
           ldx    #$0C
LA449:     lda    LAFDE,x       ; get character data offset in rom
           sta    $F0
           lda    #>CHARROM     ; caracter rom address high byte
           sta    $F1
           ldy    #$08
LA454:     lda    ($F0),y
           eor    #$FF
           sta    ($FC),y
           dey
           bne    LA454
           lda    #$FF
           sta    ($FC),y
           lda    $FC
           clc
           adc    #$10
           sta    $FC
           dex
           bpl    LA449
           lda    #>CHARSET+$8
           sta    $F1
           ldx    #$00
           stx    $CF
           stx    $F0
LA475:     lda    LA542,x
           sta    $F2
           lda    #$04
           sta    $F3
LA47E:     lda    $F2
           and    #$03
           tay
           lda    LA02F,y
           ldy    #$09
           jsr    LAF53
           lsr    $F2
           lsr    $F2
           dec    $F3
           bne    LA47E
           inx
           txa
           lsr    a
           bcs    LA475
           inc    $F0
           ldy    #$07
           lda    #$FF
           jsr    LAF53
           cpx    #$24
           bcc    LA475
           lda    #$00
           sta    $F1
           tay
LA4AA:     ldx    #$12
           ora    #$80
LA4AE:     sta    SCREEN+$9C,y
           iny
           clc
           adc    #$05
           dex
           bne    LA4AE
           inc    $F1
           iny
           iny
           iny
           iny
           lda    $F1
           cmp    #$05
           bne    LA4AA
           ldx    #$0A
           lda    #$FF
LA4C8:     sta    CHARSET+$1B0,x
           dex
           bpl    LA4C8
           ldy    #$08
LA4D0:     lda    #$FC
           sta    CHARSET+$A39,y
           lda    #$3F
           sta    CHARSET+$B29,y
           lda    #$0F
           sta    CHARSET+$A92,y
           lda    #$F0
           sta    CHARSET+$AE2,y
           dey
           bpl    LA4D0
           stx    $1A
           lda    #$80
           jsr    LAE5A
           lda    #$14
           sta    VIC+$1
           cli
LA4F4:     lda    $58
           bne    LA4F4
           ldy    #$0A
           lda    $C8
           lsr    a
           eor    #$FF
           tax
           lda    #$00
LA502:     clc
           adc    #$16
           dex
           bne    LA502
           sec
           sbc    $C9
           tax
           lda    $C8
           and    #$01
           sta    SCREEN+$180
           eor    #$01
           sta    SCREEN+$188
LA518:     txa
           adc    $F800,y
           cmp    #$84
           bcc    LA522
           sbc    #$84
LA522:     tax
           lda    SCREEN+$16,x
           bne    LA535
           lda    #$F8
           sta    SCREEN+$16,x
           lda    VIA1+$4
           and    #$07
           sta    COLORRAM+$216,x
LA535:     dey
           bpl    LA518
           lda    VIA1+$D
           and    #$02
           beq    LA4F4
           jmp    ENTRY

LA542:     .byte  $3F,$FF,$22,$A3,$33,$F3,$B3,$F8
           .byte  $F3,$FC,$2B,$CA,$3F,$CF,$8F,$E8
           .byte  $E3,$FC,$D3,$FC,$4F,$D4,$3F,$CF
           .byte  $17,$C5,$F3,$FC,$73,$F4,$33,$F3
           .byte  $11,$53,$3F,$FF
        
LA566:     txa
           pha
           lsr    a
           lsr    a
           lsr    a
           tax
           lda    $80,x
           sta    $FA
           lda    $92,x
           sta    $FB
           pla
           lsr    a
           and    #$03
           tax
           lda    LA582,x
           and    ($FA),y
           cmp    LA582,x
           rts
LA582:     .byte  $C0,$30,$0C,$03
        
LA586:     .byte  $80,$20,$08,$02
LA58A:     lda    $5A
           ora    $58
           bne    LA5AC
           lda    $1D
           beq    LA59B
           lda    $18
           asl    a
           dec    $1D
           bpl    LA5A4
LA59B:     lda    $18
           bmi    LA5A0
           inx
LA5A0:     asl    a
           bmi    LA5A4
           dex
LA5A4:     asl    a
           bmi    LA5A8
           iny
LA5A8:     asl    a
           bmi    LA5AC
           dey
LA5AC:     rts

LA5AD:     .byte  $00,$16,$01,$17,$02,$18
LA5B3:     .byte  $6F,$8A,$AD,$B8,$60,$8D,$D5,$EF
           .byte  $38,$CF,$16,$3A
LA5BF:     .byte  $20,$23,$80,$23,$23,$02,$C8,$C8
           .byte  $20,$80,$C8,$C8
LA5CB:     .byte  $00,$00,$01,$03,$1F,$3F,$67,$E7
           .byte  $18,$0C,$00,$00,$55,$00,$01,$03
           .byte  $1F,$3F,$67,$E7,$18,$0C,$00,$55
           .byte  $00,$00,$00,$10,$44,$89,$24,$49
           .byte  $A2,$24,$00,$00,$40,$40,$40,$E0
           .byte  $E0,$E0,$40,$40,$40
        
LA5F8:     ldy    #$08
LA5FA:     lda    $61,y
           sta    ($73),y
           lda    $6A,y
           sta    ($75),y
           dey
           bpl    LA5FA
           lda    $19
           ldy    $A8
           sta    ($FA),y
           ldx    #$0B
           ldy    $B5
           beq    LA65B
           lda    $60
           lsr    a
LA616:     txa
           ora    #$30
           bit    $1A
           bpl    LA620
           lda    LAFEB,x
LA620:     bcs    LA62D
           cpx    #$03
           bcc    LA62B
           cpx    #$09
           bcc    LA630
           clc
LA62B:     lda    #$36
LA62D:     sta    SCREEN+$05,x
LA630:     dex
           bpl    LA616
           ldx    #$0B
           lda    #$03
           sta    $4E
           ldy    $1A
           bne    LA673
           inc    $60
LA63F:     lda    VIA1+$4
           and    #$F0
LA644:     sta    $5F
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           and    #$07
           sta    $5E
           bpl    LA653
LA650:     jsr    LAE5A
LA653:     jmp    LAFB5

        ;; dead code
           pla
           pla
           jmp    LA331
        
        ;; get joystick input
LA65B:     lda    JOY_REG_OTHER         ; read joystick
           asl    a                     ; get "button" bit into carry
           asl    a
           asl    a
           bcs    LA665                 ; skip following instruction if button not pressed
           and    #$EF                  ; clear bit 4
LA665:     asl    JOY_REG_RIGHT         ; shift "joystick right" bit into carry
           ror    a                     ; shift carry into bit 7 of A
           ora    #$04                  ; set bit 2
           sta    $18                   ; store joystick status bits: 3=button, 4=up, 5=down, 6=left, 7=right
           cmp    #$F8                  ; any joystick input?
           bcc    LA689                 ; jump if so
        ;; get keyboard input
           ldx    #$05
LA673:     ldy    #$05
LA675:     lda    LAE41,x
           sta    JOY_REG_RIGHT
           lda    LAE35,x
           and    VIA2+$1
           cmp    #$01
           ror    $18
           dex
           dey
           bpl    LA675
LA689:     lda    $18
           ldx    $CE
           and    #$04
           sta    $CE
           bne    LA69E
           txa
           beq    LA69E
           lda    $CF
           eor    #$80
           sta    $CF
           beq    LA644
LA69E:     bit    $CF
           bpl    LA6AB
           lda    #$00
           sta    $D1
           dec    $CD
           beq    LA63F
           rts

LA6AB:     bit    $B5
           bpl    LA70E
           lda    JOY_REG_OTHER ; read joystick
           lsr    a
           lsr    a
           and    $18
           and    #$08          ; button pressed?
           beq    LA650         ; jump if so
           ldy    $CB
           lda    VIA1+$4
           cmp    #$10
           bcs    LA6C9
           lda    VIA2+$4
           eor    $1A
           tay
LA6C9:     lda    $18
           sty    $18
           sty    $CB
           cmp    $CC
           sta    $CC
           beq    LA70E
           ldx    #$01
           asl    a
           bpl    LA6DC
           bcs    LA6DE
LA6DC:     ldx    #$FF
LA6DE:     ldy    #$00
           asl    a
           asl    a
           bpl    LA6E9
           iny
           bcc    LA6E9
           ldy    #$06
LA6E9:     txa
           clc
           adc    VIC+$0,y
           beq    LA70E
           sta    VIC+$0,y
           cpy    #$01
           bne    LA70E
           lda    #$82
           cpx    #$80
           bcc    LA702
           lda    #$7E
           dec    VIA2+$7
LA702:     clc
           adc    VIA2+$6
           sta    VIA2+$6
           bcc    LA70E
           inc    VIA2+$7
LA70E:     lda    $21
           beq    LA740
           lda    $51
           clc
           adc    #$02
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           tax
           ldy    $3B,x
           beq    LA740
           lda    #$00
           sta    $52
           cpy    #$0A
           bne    LA73D
           lda    #$0B
           sta    $3B,x
           sed
           lda    $53
           sec
           sbc    #$01
           cld
           bcc    LA737
           sta    $53
LA737:     lda    #$50
           sta    $5D
           bne    LA740
LA73D:     jsr    LAD80
LA740:     lda    $1E
           bmi    LA790
           lda    $A6
           and    #$F0
           clc
           adc    $1E
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           tax
           ldy    $3B,x
           cpy    #$0A
           bne    LA765
           sed
           lda    $53
           clc
           adc    #$01
           sta    $53
           cld
           dec    $3B,x
           lda    #$07
           sta    $59
LA765:     cpy    #$05
           bcs    LA76D
           lda    $5B
           beq    LA790
LA76D:     cpy    #$09
           bcs    LA790
           lda    $5A
           bne    LA790
           lda    $5B
           bne    LA78D
           sta    $53
           ldy    #$3F
           lda    $16
           ora    $B5
           bne    LA785
           ldy    #$FF
LA785:     sty    $5A
           lda    #$0B
           sta    $3B,x
           bne    LA790
LA78D:     jsr    LAD80
LA790:     lda    #$00
           ldx    #$05
LA794:     ora    $3C,x
           dex
           bpl    LA794
           tax
           bne    LA800
           lda    $AA
           cmp    #$0C
           bne    LA7B9
           lda    #$81
           sta    $58
           inc    $4E
           jsr    LAF74
           sed
           lda    $5C
           clc
           adc    #$01
           sta    $5C
           cld
           jsr    LAEB6
           bmi    LA800
LA7B9:     lda    VIA1+$4
           eor    VIA2+$4
           cmp    #$FC
           bcc    LA800
           lda    $5A
           ora    $58
           bne    LA800
           lda    $1A
           and    #$07
           cmp    #$06
           bcs    LA800
           tax
           lda    #$1F
           sta    $24
           ldy    #$00
           lda    VIA1+$4
           adc    $1A
           cmp    #$A0
           bcs    LA7EC
           lda    $4E
           cmp    #$04
           bcc    LA7E8
           iny
LA7E8:     lda    #$06
           bne    LA7F7
LA7EC:     lsr    $24
           lda    $4E
           cmp    #$03
           bcs    LA7F5
           dey
LA7F5:     lda    #$0A
LA7F7:     sta    $3C,x
           lda    $1A
           sty    $48,x
           jsr    LAEDF
LA800:     ldx    $A7
           ldy    $A6
           jsr    LA58A
           cpx    #$90
           beq    LA811
           cpx    #$0F
           beq    LA811
           stx    $A7
LA811:     cpy    #$60
           beq    LA81B
           cpy    #$0F
           beq    LA81B
           sty    $A6
LA81B:     ldx    $A5
           ldy    $A8
           lda    $1A
           and    #$07
           bne    LA840
           jsr    LA58A
           cpx    #$90
           bne    LA82E
           ldx    #$00
LA82E:     cpx    #$FF
           bne    LA834
           ldx    #$8F
LA834:     cpy    #$FF
           bne    LA83A
           ldy    #$47
LA83A:     cpy    #$48
           bne    LA840
           ldy    #$00
LA840:     stx    $FE
           sty    $FF
           ldy    $A8
           jsr    LA566
           beq    LA84F
           ldx    $FE
           stx    $A5
LA84F:     ldx    $A5
           ldy    $FF
           jsr    LA566
           beq    LA85A
           sty    $A8
LA85A:     ldx    $A5
           ldy    $A8
           jsr    LA566
           lda    ($FA),y
           sta    $19
           lda    LA586,x
           and    $19
           sta    $1B
           beq    LA8D1
           lda    $19
LA870:     dey
           cmp    ($FA),y
           beq    LA870
           lda    ($FA),y
           sta    $19
           iny
           sta    ($FA),y
           iny
           sta    ($FA),y
           iny
           sta    ($FA),y
           ldx    #$05
           lda    VIA1+$4
           sta    $F0
LA889:     lda    $3C,x
           cmp    #$0A
           beq    LA8B4
           lda    #$FF
           sta    $48,x
           lda    $F0
           and    #$07
           tay
           lda    LACB0,y
           sta    $30,x
           lda    #$01
           sta    $3C,x
           cpy    #$03
           bcc    LA8B0
           cpy    #$05
           bcs    LA8AE
           bit    VIA2+$4
           bmi    LA8B0
LA8AE:     lda    #$FF
LA8B0:     sta    $42,x
           ror    $F0
LA8B4:     dex
           bpl    LA889
           lda    #$00
           sta    $54
           lda    $4E
           cmp    #$08
           bcc    LA8C3
           lda    #$07
LA8C3:     eor    #$07
           asl    a
           asl    a
           asl    a
           asl    a
           adc    #$1F
           sta    $4F
           inc    $AA
           ldy    $A8
LA8D1:     lda    LA586,x
           ora    ($FA),y
           sta    ($FA),y
           lda    $1A
           and    #$01
           tax
           lda    $58
           bne    LA8EC
           lda    $22
           beq    LA8EF
           lda    $1A
           lsr    a
           bcc    LA8EC
           dec    $22
LA8EC:     jmp    LA9BA

LA8EF:     lda    $4E
           clc
           adc    #$01
           cmp    #$10
           bcc    LA8FA
           lda    #$0F
LA8FA:     lsr    a
           tay
           lda    $1A
           and    LADCA,y
           eor    LADCA,y
           ora    $5A
           bne    LA8EC
           lda    $A8
           eor    $A5
           adc    VIA1+$4
           and    #$02
           ora    #$01
           sta    $F8
           lda    $AD,x
           clc
           adc    #$03
           cmp    $A5
           beq    LA92D
           ldy    #$01
           bcc    LA924
           ldy    #$03
LA924:     lda    VIA1+$4
           sbc    VIA1+$5
           asl    a
           bmi    LA93C
LA92D:     lda    $AB,x
           clc
           adc    #$04
           cmp    $A8
           beq    LA8EC
           ldy    #$00
           bcc    LA93C
           ldy    #$02
LA93C:     sty    $FD
           lda    $AD,x
           cmp    #$48
           bcc    LA948
           lda    #$8B
           sbc    $AD,x
LA948:     ldy    #$12
LA94A:     cmp    LADD2,y
           bne    LA958
           pha
           lda    $AB,x
           cmp    LACB8,y
           beq    LA974
           pla
LA958:     dey
           bpl    LA94A
           lda    VIA1+$4
           eor    $A5
           cmp    #$A0
           bcc    LA9A5
           lda    $FD
           cmp    $AF,x
           beq    LA9A5
           eor    #$02
           cmp    $AF,x
           bne    LA9A5
           eor    #$02
           bpl    LA9A3
LA974:     lda    LACCB,y
           and    #$0F
           ldy    $AD,x
           cpy    #$48
           bcc    LA98D
           pha
           and    #$0A
           beq    LA98C
           cmp    #$0A
           beq    LA98C
           pla
           eor    #$0A
           .byte  $24
LA98C:     pla
LA98D:     sta    $FC
           pla
           ldy    $FD
LA992:     lda    LAFB1,y
           and    $FC
           bne    LA9A2
           tya
           clc
           adc    $F8
           and    #$03
           tay
           bpl    LA992
LA9A2:     tya
LA9A3:     sta    $AF,x
LA9A5:     ldy    $AF,x
           bne    LA9AB
           inc    $AB,x
LA9AB:     dey
           bne    LA9B0
           inc    $AD,x
LA9B0:     dey
           bne    LA9B5
           dec    $AB,x
LA9B5:     dey
           bne    LA9BA
           dec    $AD,x
LA9BA:     lda    $AD,x
           lsr    a
           lsr    a
           lsr    a
           tay
           lda    $AB,x
           clc
           adc    $80,y
           sta    $73
           lda    $92,y
           adc    #$00
           sta    $74
           lda    $AB,x
           adc    $81,y
           sta    $75
           lda    $93,y
           adc    #$00
           sta    $76
           lda    $AD,x
           and    #$06
           lsr    a
           adc    #>CHARSET+$4
           sta    $F1
           sta    $F3
           lda    #$3C
           sta    $F0
           lda    #$81
           sta    $F2
           ldy    #$08
LA9F2:     lda    ($73),y
           sta    $61,y
           ora    ($F0),y
           sta    ($73),y
           lda    ($75),y
           sta    $6A,y
           ora    ($F2),y
           sta    ($75),y
           dey
           bpl    LA9F2
           lda    $A5
           clc
           adc    #$02
           sbc    $AD,x
           cmp    #$07
           bcs    LAA5A
           lda    $A8
           sec
           sbc    $AB,x
           cmp    #$09
           bcs    LAA5A
           lda    $5B
           beq    LAA21
           dec    $5B
LAA21:     lda    $5A
           ora    $22
           bne    LAA58
           lda    VIA1+$4
           and    #$07
           cmp    #$06
           bcs    LAA58
           tax
           lda    $3C,x
           bne    LAA58
           lda    #$2F
           sta    $24
           lda    #$00
           sta    $48,x
           ldy    #$07
           lda    VIA1+$4
           and    #$80
           sta    $25,x
           eor    $A5
           eor    $1A
           cmp    #$F0
           bcc    LAA53
           iny
           inc    $48,x
           lda    #$07
LAA53:     sty    $3C,x
           jsr    LAEDF
LAA58:     ldy    #$00
LAA5A:     iny
           sty    $D2
           lda    $4F
           beq    LAAA3
           and    #$07
           cmp    #$07
           bne    LAA8A
           ldx    #$05
LAA69:     ldy    $3C,x
           beq    LAA87
           cpy    #$05
           bcs    LAA87
           iny
           cpy    #$05
           bne    LAA78
           ldy    #$01
LAA78:     sty    $3C,x
           lda    $4F
           lsr    a
           lsr    a
           lsr    a
           and    #$07
           bne    LAA85
           lda    #$03
LAA85:     sta    $36,x
LAA87:     dex
           bpl    LAA69
LAA8A:     dec    $4F
           bne    LAAA3
           ldx    #$05
LAA90:     lda    $3C,x
           beq    LAAA0
           cmp    #$05
           bcs    LAAA0
           lda    #$05
           sta    $3C,x
           lda    #$05
           sta    $36,x
LAAA0:     dex
           bpl    LAA90
LAAA3:     ldx    #$05
LAAA5:     lda    $3C,x
           cmp    #$05
           bcc    LAACF
           cmp    #$0B
           bcs    LAACF
           ldy    $48,x
           bpl    LAAB9
           iny
           lda    $1A
           lsr    a
           bcc    LAACF
LAAB9:     lda    $42,x
           dey
           bmi    LAAC2
LAABE:     asl    a
           dey
           bpl    LAABE
LAAC2:     clc
           adc    $30,x
           cmp    #$A8
           bcc    LAACD
           lda    #$00
           sta    $3C,x
LAACD:     sta    $30,x
LAACF:     dex
           bpl    LAAA5
           lda    $52
           beq    LAAE3
           clc
           adc    $50
           sta    $50
           cmp    #$16
           bcc    LAB0A
           lda    #$00
           sta    $52
LAAE3:     lda    $18
           and    #$08
           ora    $58
           ora    $5A
           bne    LAB0A
           lda    $A6
           clc
           adc    #$05
           sta    $51
           dec    VIA1+$6
           lda    $A7
           adc    #$08
           lsr    a
           lsr    a
           lsr    a
           sta    $50
           ldy    #$01
           lda    $A9
           beq    LAB08
           ldy    #$FF
LAB08:     sty    $52
LAB0A:     lda    $1A
           and    #$0F
           eor    #$0F
           bne    LAB29
           ldx    #$05
LAB14:     ldy    $3C,x
           cpy    #$0B
           bcc    LAB24
           rol    a
           iny
           cpy    #$0D
           bne    LAB22
           ldy    #$00
LAB22:     sty    $3C,x
LAB24:     dex
           bpl    LAB14
           sta    $15
LAB29:     lda    $1A
           lsr    a
           bcc    LAB68
           ldx    #$05
           lda    $4E
           asl    a
           sta    $F0
LAB35:     lda    $3C,x
           cmp    #$07
           bne    LAB65
           lda    VIA1+$4
           adc    $1A
           cmp    $F0
           bcs    LAB4C
           lda    $42,x
           eor    #$FF
           ora    #$01
           sta    $42,x
LAB4C:     ldy    $25,x
           bpl    LAB52
           dey
           dey
LAB52:     iny
           cpy    #$7F
           beq    LAB65
           cpy    #$80
           bne    LAB5D
           ldy    #$00
LAB5D:     cpy    #$08
           bne    LAB63
           ldy    #$87
LAB63:     sty    $25,x
LAB65:     dex
           bpl    LAB35
LAB68:     lda    $58
           beq    LAB7D
           dec    $58
           bne    LAB74
           lda    #$00
           sta    $53
LAB74:     lsr    a
           lsr    a
           lsr    a
           tax
           lda    LAF43,x
           bmi    LABA3
LAB7D:     lda    $1A
           lsr    a
           bcc    LABA8
           lda    $59
           beq    LABA8
           dec    $59
           bne    LAB95
           ldx    #$06
LAB8C:     dex
           lda    $3C,x
           eor    #$09
           bne    LAB8C
           sta    $3C,x
LAB95:     lda    #$10
           ldy    #$00
           jsr    LADAD
           lda    $59
           eor    #$07
           asl    a
           ora    #$F0
LABA3:     tax
           lda    #$0F
           bpl    LABEE
LABA8:     lda    $5D
           beq    LABDE
           sta    $D1
           and    #$07
           eor    #$07
           asl    a
           ora    #$F0
           sta    VIC+$B
           lda    $5D
           dec    $5D
           and    #$0F
           cmp    #$0F
           bne    LABD9
           sed
           lda    $56
           sec
           sbc    #$02
           sta    $56
           lda    $57
           sbc    #$00
           bcs    LABD6
           lda    #$00
           sta    $55
           sta    $56
LABD6:     sta    $57
           cld
LABD9:     lda    #$00
           jmp    LAC8D

LABDE:     lda    $5B
           beq    LABF6
           ldx    #$CE
           cmp    #$E2
           bcs    LABEE
           ldx    #$E7
           cmp    #$20
           bcs    LABF6
LABEE:     sta    $D1
           stx    VIC+$B
           jmp    LABD9

LABF6:     ldx    #$00
           stx    VIC+$B
           lda    $5A
           bne    LAC6B
           lda    $22
           cmp    #$E0
           bcs    LAC0D
           lda    $4F
           beq    LAC19
           and    #$1F
           ora    #$C0
LAC0D:     eor    #$1F
           sta    VIC+$B
           and    #$0F
           sta    $D1
           jmp    LABD9

LAC19:     lda    $15
           bne    LAC61
           lda    $24
           beq    LAC30
           dec    $24
           eor    #$0F
           sta    $D1
           ora    #$F0
           sta    VIC+$B
           bmi    LAC46
           bpl    LAC38
LAC30:     lda    $52
           beq    LAC46
           lda    $50
           ora    #$08
LAC38:     sta    $D1
           and    #$0F
           asl    a
           asl    a
           asl    a
           ora    #$C0
           sta    VIC+$B
           bmi    LAC8D
LAC46:     lda    $D2
           beq    LAC8D
           lda    $1A
           and    #$03
           beq    LAC8D
           and    #$02
           tax
           lda    VIA2+$4
           ora    #$80
           sta    VIC+$B,x
           lda    #$0F
           sta    $D1
           bpl    LAC90
LAC61:     lda    $1A
           sta    $D1
           eor    #$FF
           ora    #$C0
           bmi    LAC8D
LAC6B:     lsr    a
           lsr    a
           ora    #$0C
           sta    $D1
           dec    $5A
           bne    LAC80
           lda    #$00
           sta    $52
           jsr    LAEFB
           lda    #$7F
           sta    $5B
LAC80:     lda    $5A
           eor    #$30
           and    #$3F
           adc    #$A0
           sta    VIC+$B
           eor    #$0F
LAC8D:     sta    VIC+$D
LAC90:     lda    $1A
           and    #$03
           bne    LACA1
           ldx    $C9
           ldy    $C8
           jsr    LA58A
           stx    $C9
           sty    $C8
LACA1:     rts

LACA2:     .byte  $40,$50,$60,$70,$80,$90
LACA8:     .byte  <LA244,<LA241,<LA23E,<LA23B,<LA238,<LA226,<LA229,<LA22C
LACB0:     .byte  $08,$20,$38,$50,$58,$70,$88,$A0
LACB8:     .byte  $1B,$1B,$2D,$24,$00,$09,$1B,$2D
           .byte  $3F,$09,$24,$36,$1B,$12,$1B,$24
           .byte  $36,$09,$12
LACCB:     .byte  $82,$59,$AC,$E7,$41,$67,$3E,$D3
           .byte  $74,$19,$CC,$26,$97,$D3,$FD,$07
           .byte  $0C,$03,$0C
LACDE:     .byte  <(LAD1C-$1C+$01),<(LAD1C-$1C+$00),<(LAD1C-$1C+$0D),<(LAD1C-$1C+$1A)
           .byte  <(LAD1C-$1C+$23),<(LAD1C-$1C+$28),<(LAD1C-$1C+$30),<(LAD1C-$1C+$37)
           .byte  <(LAD1C-$1C+$3B),<(LAD1C-$1C+$44),<(LAD1C-$1C+$4D),<(LAD1C-$1C+$57)
           .byte  <(LAD1C-$1C+$5F)
                
LACEB:     sty    $F4
           sty    $F6
           sta    $20
           lda    #>CHARSET
           sta    $FD
LACF5:     ldy    LA5AD,x
           lda    ($F4),y
           asl    a
           asl    a
           asl    a
           asl    a
           sta    $FC
           txa
           ora    $20
           sta    ($F4),y
           asl    a
           asl    a
           asl    a
           asl    a
           sta    $FE
           lda    #$0A
           sta    ($F6),y
           ldy    #$0F
LAD11:     lda    ($FC),y
           sta    ($FE),y
           dey
           bpl    LAD11
           dex
           bpl    LACF5
           rts

        ;; this data must not cross a page boundary
LAD1C:     .byte  $24,$00,$00,$42,$00,$00,$81,$00
           .byte  $00,$42,$00,$00,$24,$18,$00,$24
           .byte  $00,$42,$00,$81,$00,$42,$00,$24
           .byte  $00,$18,$18,$00,$24,$00,$42,$00
           .byte  $24,$00,$18,$18,$00,$24,$00,$18
           .byte  $80,$58,$24,$56,$6A,$24,$1A,$01
           .byte  $18,$34,$34,$FF,$34,$34,$18,$18
           .byte  $7C,$3E,$18,$3C,$24,$24,$E7,$89
           .byte  $E7,$24,$24,$3C,$88,$22,$88,$22
           .byte  $88,$22,$88,$22,$88,$19,$A5,$9A
           .byte  $FC,$3C,$3C,$24,$24,$24,$66,$24
           .byte  $01,$80,$10,$08,$01,$80,$24,$42
           .byte  $08,$24,$10,$42
        
LAD80:     cpy    #$09
           bcs    LADC3
           lda    #$0B
           sta    $3B,x
           cpy    #$06
           bcs    LAD9C
           inc    $54
           ldy    $54
           cpy    #$05
           bne    LAD98
           lda    #$FF
           sta    $5B
LAD98:     lda    #$00
           beq    LADAD
LAD9C:     cpy    #$08
           bne    LADA4
           lda    #$FF
           sta    $22
LADA4:     lda    LA02D,y
           pha
           lda    LA02F,y
           tay
           pla
LADAD:     bit    $B5
           bmi    LADC3
           clc
           sed
           adc    $55
           sta    $55
           tya
           adc    $56
           sta    $56
           lda    $57
           adc    #$00
           sta    $57
           cld
LADC3:     rts

LADC4:     .byte  $00,>CHARSET+$4,$45,>CHARSET+$4,$8A,>CHARSET+$4
LADCA:     .byte  $0E,$06,$06,$02,$02,$00,$00,$00
LADD2:     .byte  $00,$18,$18,$18,$08,$08,$08,$08
           .byte  $08,$28,$28,$28,$28,$38,$38,$38
           .byte  $38,$3E,$3E
LADE5:     .byte  >CHARSET+$C,>CHARSET+$C,>CHARSET+$D
LADE8:     .byte  $80,$BE,$BE,$BC,$BC,$BC,$80,$FB
           .byte  $FB,$FB,$F3,$F3,$F3,$F3,$80,$BE
           .byte  $FE,$80,$9F,$9F,$80,$81,$BD,$FD
           .byte  $C0,$FC,$BC,$80,$BD,$BD,$BD,$80
           .byte  $F9,$F9,$F9,$80,$BF,$BF,$80,$FC
           .byte  $BC,$80,$80,$BE,$BF,$80,$BC,$BC
           .byte  $80,$C0,$FE,$FE,$FC,$FC,$FC,$FC
           .byte  $C1,$DD,$DD,$80,$BC,$BC,$80,$80
           .byte  $BE,$BE,$80,$FC,$FC,$FC,$E7,$DB
           .byte  $A5,$AD,$A5,$DB,$E7
LAE35:     .byte  $10,$10,$10,$10,$01,$01,$02,$40
           .byte  $80,$80,$01,$01
LAE41:     .byte  $DF,$FB,$EF,$FD,$EF,$F7,$F7,$EF
           .byte  $F7,$FB,$EF,$F7
LAE4D:     .byte  $00,$1C,$1C,$38,$54,$27,$26,$03
           .byte  $28,$28,$29,$37,$44
        
LAE5A:     sta    $B5
           lda    #$00
           ldx    #$30
LAE60:     sta    $30,x
           dex
           bpl    LAE60
           sta    $16
           ldx    #$11
LAE69:     lda    #$1B
           sta    SCREEN+$10A,x
           lda    #$36
           sta    SCREEN+$02,x
           dex
           bpl    LAE69
           ldx    #$05
LAE78:     txa
           clc
           adc    #$FA
           ldy    LAED9,x
           sta    SCREEN+$10B,y
           dex
           bpl    LAE78
           lda    #$60
           sta    $FB
           sta    $74
           sta    $76
           sta    $F0
           lda    #>(SCREEN+$100)
           sta    $F1
LAE93:     lda    #$FF
           ldy    #$0B
           jsr    LAF53
           lda    $F0
           clc
           adc    #$05
           sta    $F0
           bmi    LAE93
           ldx    #$02
LAEA5:     lda    #$FF
           sta    $F2
           stx    $FF
           jsr    LAF7E
           jsr    LAF09
           ldx    $FF
           dex
           bpl    LAEA5
LAEB6:     ldx    #$0B
LAEB8:     lda    LAF92,x
           sta    $A5,x
           lda    LA5B3,x
           sta    $F0
           txa
           lsr    a
           cpx    #$02
           bne    LAEC9
           lsr    a
LAEC9:     ora    #>CHARSET+$8
           sta    $F1
           lda    LA5BF,x
           ldy    #$03
           jsr    LAF53
           dex
           bpl    LAEB8
           rts

LAED9:     .byte  $0F,$0D,$0B,$04,$02,$00
LAEDF:     and    #$07
           bne    LAEE5
           lda    #$05
LAEE5:     sta    $36,x
           lda    VIA1+$4
           eor    $A8
           ldy    #$00
           and    #$01
           bne    LAEF6
           lda    #$FF
           ldy    #$A7
LAEF6:     sta    $42,x
           sty    $30,x
           rts

LAEFB:     ldy    #$FF
           lda    $B5
           bne    LAF36
           ldx    $16
           dex
           bpl    LAF14
           sty    $B5
           rts

LAF09:     ldy    #$00
           ldx    $16
           inc    $16
           cpx    #$09
           bcs    LAF36
           .byte  $2C
LAF14:     stx    $16
           sty    $F2
           lda    LAF37,x
           ldy    LAF40,x
           ldx    #$02
LAF20:     sta    $F0
           tya
           bpl    LAF27
           ldy    #$1F
LAF27:     sty    $F1
           ldy    #$02
LAF2B:     lda    LA009,x
           ora    $F2
           sta    ($F0),y
           dex
           dey
           bpl    LAF2B
LAF36:     rts

LAF37:     .byte  $9B,$3B,$DB,$F0,$E0,$D0,$F5,$E5
           .byte  $D5
LAF40:     .byte  >CHARSET+$8,>CHARSET+$9,>CHARSET+$9
LAF43:     .byte  $CF,$CF,$D9,$DF,$E3,$DB,$DF,$E3
           .byte  $E4,$DF,$E3,$E4,$E7,$E3,$E4,$E7
        
LAF53:     sty    $FF
           ldy    #$00
LAF57:     sta    ($F0),y
           inc    $F0
           bne    LAF5F
           inc    $F1
LAF5F:     dec    $FF
           bne    LAF57
           rts

LAF64:     ldx    #$04
           lda    #$00
LAF68:     lsr    $F0
           php
           ror    a
           plp
           ror    a
           dex
           bne    LAF68
           and    $FF
LAF73:     rts

LAF74:     ldx    #$00
           stx    $F2
           ldx    $5C
           cpx    #$09
           bcs    LAF73
LAF7E:     lda    LAF89,x
           ldy    LADE5,x
           ldx    #$11
           jmp    LAF20

LAF89:     .byte  $0B,$AB,$4B,$C0,$B0,$A0,$C5,$B5
           .byte  $A5
LAF92:     .byte  $46,$46,$46,$2A,$00,$00,$1B,$1B
           .byte  $14,$5C,$01,$03
LAF9E:     .byte  $1B,$35,$20,$01,$CA
LAFA3:     .byte  $16,$15,$05,$0F,$02
LAFA8:     .byte  $1F,$3F,$67,$F8,$FC,$E6,$FF,$01
           .byte  $FF
LAFB1:     .byte  $01,$02,$04,$08
LAFB5:     ldx    #$6B
           ldy    $5E
           iny
           tya
           ora    #$08
LAFBD:     sta    COLORRAM+$29A,x
           dex
           bpl    LAFBD
           ldx    #$11
           stx    $CD
           lda    $5E
           clc
           adc    #$06
           and    #$07
           sta    $D3
LAFD0:     sta    COLORRAM+$30A,x
           sta    COLORRAM+$202,x
           dex
           bpl    LAFD0
           pla
           pla
           jmp    LA331

        ;; character rom offsets for letters in
        ;; "SPIDER CITY" and "SIRIUS": "UYTIC  REDIPS"
LAFDE:     .byte  $A7,$C7,$9F,$47,$17,$FF,$FF,$8F
           .byte  $27,$1F,$47,$7F,$97
        
LAFEB:     .byte  $1A,$11,$19,$18,$13,$36,$30,$32
           .byte  $35,$32,$3C,$30,$80,$00,$60,$00
           .byte  $B0,$00,$04,$F9,$BF
