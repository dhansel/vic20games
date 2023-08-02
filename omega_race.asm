;;; Commodore OMEGA RACE for VIC-20
        
VIC               := $9000      ; $9000-$900F
VIA1              := $9110      ; $9110-$911F
VIA2              := $9120      ; $9120-$912F
COLORRAM          := $9600      ; $9600-$96C7
CHARSET           := $1000      ; $1000-$1CFF?
SCREEN            := $1E00      ; $1E00-$1EC7
JOY_REG_RIGHT     := VIA2+$0
JOY_REG_OTHER     := VIA1+$1
JOY_MASK_UP       := $04
JOY_MASK_DOWN     := $08
JOY_MASK_LEFT     := $10
JOY_MASK_RIGHT    := $80
JOY_MASK_BUTTON   := $20
IRQVEC            := $0314

SCANKEY           := $FF9F
GETKEY            := $FFE4
        
           .org $A000

           .setcpu"6502"

           .word  COLD, WARM
           .byte  $41,$30,$C3,$C2,$CD ; "A0cbm" signature (PETSCII)
        
COLD:      cld
           jsr    $FD8D         ; init and test RAM
           jsr    $FF8A         ; set I/O vectors
           jsr    $FDF9         ; init I/O registers
           lda    #$1E          
           sta    $0288         
           jsr    $E518         ; init hardware (VIC/VIA)
           jsr    $E45B         ; init BASIC vectors
           jsr    $E3A4         ; init BASIC RAM
           sei
           ldx    #$FF
           txs
           cli
           jsr    LA175
LA029:     jsr    LB1C8
           jsr    LA1AD
LA02F:     jsr    LA1BE
LA032:     lda    #$0F
           sta    VIC+$E
LA037:     jsr    LA36D
           inc    $37
           lda    $37
           and    #$07
           sta    $37
           inc    $3E
           jsr    LA466
           jsr    LA69C
           jsr    LA507
           jsr    LA535
LA050:     lda    $22
           cmp    #$02
           bcc    LA050
           lda    $4E
           cmp    #$01
           beq    LA068
           lda    $1F
           bmi    LA092
           lda    $3D
           bne    LA037
           lda    $4E
           beq    LA07E
LA068:     dec    $4D
           bne    LA037
           lda    $4E
           bmi    LA02F
           lda    $1F
           bmi    LA092
           lda    $3D
           beq    LA07E
           jsr    LA1D2
           jmp    LA032

LA07E:     sei
           lda    #$26
           sta    $46
           sta    $4A
           lda    #$05
           sta    $42
           cli
           lda    #$C8
           sta    $4D
           sta    $4E
           bne    LA037
LA092:     lda    $25
           cmp    $F9
           bcc    LA0AA
           bne    LA0B6
           lda    $24
           cmp    $F8
           bcc    LA0AA
           bne    LA0B6
           lda    $23
           cmp    $F7
           bcc    LA0AA
           bne    LA0B6
LA0AA:     lda    $F7
           sta    $23
           lda    $F8
           sta    $24
           lda    $F9
           sta    $25
LA0B6:     lda    #$00
           sta    VIC+$E
           ldx    #<MSG7
           ldy    #>MSG7
           lda    #$06
           sta    $AE
           sta    $AF
           jsr    LB2CC         ; display ?
           jsr    LB3BB
           jmp    LA029

IRQ:       sei
           inc    $22
           ldy    $45
           beq    LA0F0
           lda    LBED3,y
           sta    VIC+$A
           beq    LA0F0
           dec    $41
           bne    LA0F0
           ldy    $45
           iny
           sty    $45
           ldy    $49
           iny
           sty    $49
           lda    LBED5,y
           sta    $41
LA0F0:     ldy    $46
           beq    LA110
           lda    LBED7,y
           sta    VIC+$B
           beq    LA110
           dec    $42
           bne    LA12D
           iny
           sty    $46
           ldy    $4A
           iny
           sty    $4A
           lda    LBF17,y
           sta    $42
           jmp    LA12D

LA110:     lda    #$01
           sta    $46
           lda    $2F
           beq    LA11C
           ldy    #$4A
           bne    LA126
LA11C:     lda    $31
           beq    LA124
           ldy    #$41
           bne    LA126
LA124:     ldy    #$01
LA126:     sty    $4A
           lda    LBF17,y
           sta    $42
LA12D:     ldy    $47
           beq    LA14C
           lda    LBF68,y
           sta    VIC+$C
           beq    LA14C
           dec    $43
           bne    LA14C
           ldy    $47
           iny
           sty    $47
           ldy    $4B
           iny
           sty    $4B
           lda    LBF8D,y
           sta    $43
LA14C:     ldy    $48
           beq    LA16B
           lda    LBFB1,y
           sta    VIC+$D
           beq    LA16B
           dec    $44
           bne    LA16B
           ldy    $48
           iny
           sty    $48
           ldy    $4C
           iny
           sty    $4C
           lda    LBFCA,y
           sta    $44
LA16B:     bit    VIA2+$4
           pla
           tay
           pla
           tax
           pla
           cli
           rti

LA175:     lda    #$01
           sta    $27
           lda    #$4C
           sta    $1D7D
           lda    #$00
           sta    $23
           sta    $24
           sta    $25
           sta    $62
           lda    #$40
           sta    $028A
           lda    #$80
           sta    $0291
           ldx    #$0F
LA194:     lda    LA442,x
           sta    VIC,x
           dex
           bpl    LA194
           jsr    LA400
           sei
           lda    #<IRQ
           sta    IRQVEC
           lda    #>IRQ
           sta    IRQVEC+1
           cli
           rts

LA1AD:     lda    #$00
           sta    $F7
           sta    $F8
           sta    $F9
           sta    $54
           sta    $20
           lda    #$01
           sta    $21
LA1BD:     rts

LA1BE:     sei
           lda    $20
           beq    LA1D0
           and    #$03
           bne    LA1D0
           jsr    LB367
           sei
           sed
           inc    $21
           cld
           cli
LA1D0:     inc    $20
LA1D2:     lda    $21
           cmp    #$03
           bcc    LA1DA
           lda    #$04
LA1DA:     sta    $55
           lda    $20
           cmp    #$03
           bcc    LA1E4
           lda    #$04
LA1E4:     tax
           lda    LA373,x
           sta    $3D
           sta    $40
           lda    #$00
           sta    $4E
           sta    $B0
           sta    $35
           sta    $B2
           sta    $29
           sta    $3E
           sta    $4D
           sta    VIC+$E
           sta    $45
           sta    $47
           sta    $48
           sta    VIC+$A
           sta    VIC+$B
           sta    VIC+$C
           sta    VIC+$D
           lda    #$01
           sta    $46
           sta    $4A
           tay
           lda    LBF18,y
           sta    $42
           lda    #$00
           sta    $1D80
           lda    LA377,x
           sta    $1D81
           lda    LA37B,x
           sta    $1D82
           lda    LA37F,x
           sta    $1D83
           lda    LA383,x
           sta    $1D84
           lda    #$FF
           sta    $1D85
           sta    $1D86
           ldx    $55
           lda    LA387,x
           sta    $38
           lda    LA38B,x
           sta    $39
           lda    LA38F,x
           sta    $3A
           lda    LA393,x
           sta    $36
           lda    LA397,x
           sta    $4F
           lda    LA39B,x
           sta    $50
           lda    LA39F,x
           sta    $52
           lda    LA3A3,x
           sta    $53
           lda    VIA2+$4
           and    #$01
           bne    LA279
           sta    $56
           ldy    #$03
           bne    LA27D
LA279:     ldy    #$05
           sta    $56
LA27D:     ldx    #$03
LA27F:     lda    LA3F6,y
           sta    $57,x
           lda    LA3FC,x
           sta    $5C,x
           dey
           dex
           bpl    LA27F
           lda    $20
           cmp    #$02
           bcs    LA296
           ldx    #$12
           .byte  $2C
LA296:     ldx    $40
LA298:     cpx    $40
           beq    LA2A8
           bcc    LA2A8
           lda    #$FF
           sta    $033C,x
           sta    $03A2,x
           bne    LA2F5
LA2A8:     lda    LA3A8,x
           sta    $033C,x
           tay
           lda    LA82B,y
           sta    $1D13,x
           sta    $034F,x
           lda    LA3B5,x
           sta    $0362,x
           sta    $0388,x
           lda    LA3C2,x
           sta    $0375,x
           sta    $0395,x
           lda    LA3CF,x
           sta    $03A2,x
           tay
           lda    $57,y
           sta    $03C8,x
           lda    $5C,y
           sta    $1D00,x
           lda    $0375,x
           sec
           sbc    #$64
           sta    $1D26,x
           lda    $56
           bne    LA2EF
           lda    LA3DC,x
           bne    LA2F2
LA2EF:     lda    LA3E9,x
LA2F2:     sta    $03B5,x
LA2F5:     dex
           bpl    LA298
           lda    #$0C
           sta    $B1
           sta    $034F
           lda    #$01
           sta    $30
           lda    #$14
           sta    $1D27
           lda    $56
           bne    LA316
           lda    #$8C
           sta    $0362
           lda    #$14
           sta    $0363
LA316:     lda    $0362
           sta    $A3
           lda    $0375
           sta    $A4
           jsr    LA65D
           txa
           bmi    LA334
           beq    LA334
           cpx    #$0D
           bcc    LA334
           lda    #$FF
           sta    $03A2,x
           sta    $033C,x
LA334:     lda    #$00
           sta    $31
           sta    $2F
           sta    $03C8
           sta    $1D00
           lda    #$FF
           sta    $37
           lda    #$04
           sta    $19
           lda    #$00
           ldx    #$07
LA34C:     sta    $1D5D,x
           dex
           bpl    LA34C
           jsr    LA429
           jsr    LA452
           jsr    LAC04
           jsr    LACAD
           jsr    LACC2
           jsr    LAD18
           jsr    LAD4A
           jsr    LABF6
           jsr    LABCE
LA36D:     sei
           lda    #$00
           sta    $22
           cli
LA373:     rts

           .byte  $06,$08,$0A
LA377:     .byte  $0C,$01,$01,$01
LA37B:     .byte  $00,$03,$01,$01
LA37F:     .byte  $01,$07,$03,$03
LA383:     .byte  $01,$FF,$0F,$0F
LA387:     .byte  $07,$FE,$0F,$07
LA38B:     .byte  $03,$1F,$0F,$07
LA38F:     .byte  $07,$FF,$7F,$7F
LA393:     .byte  $7F,$07,$03,$01
LA397:     .byte  $00,$C8,$40,$20
LA39B:     .byte  $14,$DC,$14,$14
LA39F:     .byte  $0A,$FF,$FF,$C8
LA3A3:     .byte  $96,$FF,$FF,$FF,$FF
LA3A8:     .byte  $00,$02,$04,$04,$04,$04,$04,$04
           .byte  $04,$04,$04,$04,$04
LA3B5:     .byte  $14,$8C,$22,$40,$4C,$4A,$4F,$54
           .byte  $63,$63,$6D,$70,$40
LA3C2:     .byte  $28,$5A,$79,$81,$70,$86,$77,$86
           .byte  $77,$86,$72,$8B,$6E
LA3CF:     .byte  $03,$01,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00
LA3DC:     .byte  $00,$32,$0F,$35,$30,$44,$3A,$4E
           .byte  $4E,$5D,$53,$6F,$22
LA3E9:     .byte  $00,$32,$6B,$55,$38,$50,$3C,$46
           .byte  $28,$37,$19,$2F,$42
LA3F6:     .byte  $FF,$00,$01,$00,$FF,$00
LA3FC:     .byte  $00,$FF,$00,$01

        ;; prepare screen for character bitmap and clear CHARSET
        ;; fill COLORRAM with content of $27
LA400:     lda    #$13
           sta    $A5
           sta    $A7
           lda    #>SCREEN
           sta    $A6
           lda    #>COLORRAM
           sta    $A8
           ldx    #$C7
LA410:     ldy    #$B4
LA412:     txa
           sta    ($A5),y
           lda    $27
           sta    ($A7),y
           dex
           tya
           sec
           sbc    #$14
           tay
           bcs    LA412
           dec    $A5
           dec    $A7
           cpx    #$FF
           bne    LA410

        ;; clear CHARSET
LA429:     lda    #$00
           sta    $A5
           lda    #>CHARSET
           sta    $A6
           lda    #$00
           tay
LA434:     sta    ($A5),y
           iny
           bne    LA434
           inc    $A6
           ldx    $A6
           cpx    #>CHARSET+$0D
           bne    LA434
           rts

        ;; initial VIC settings
        ;; 16x8 (i.e. double-height) character size
        ;; 
        ;; 10 (double-height) rows, 20 columns
        ;; character map at $1000-
        ;; screen memory at $1E00-1EC7
        ;; color at $9600-$96C8
LA442:     .byte  $07,$1B,$94,$15,$00,$FC,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$08

        ;; fill COLORRAM with content of $27
LA452:     lda    #$00
           sta    $A7
           lda    #>COLORRAM
           sta    $A8
           ldy    #$C7
           lda    $27
LA45E:     sta    ($A7),y
           dey
           cpy    #$FF
           bne    LA45E
           rts

LA466:     lda    $03A2
           bmi    LA4E6
           jsr    $1d7d
           bit    $35
           bpl    LA479
           lda    $19
           beq    LA479
           jsr    LADB9
LA479:     lda    $B1
           bit    $B2
           bpl    LA4B3
           bit    VIC+$D
           bmi    LA490
           sei
           ldy    #$18
           sty    $48
           sty    $4C
           ldy    #$64
           sty    $44
           cli
LA490:     tay
           ora    #$10
           sta    $1D13
           lda    $37
           and    #$01
           bne    LA4BA
           clc
           lda    LA4E7,y
           adc    $03C8
           sta    $03C8
           clc
           lda    LA4F7,y
           adc    $1D00
           sta    $1D00
           jmp    LA4BA

LA4B3:     sta    $1D13
           lda    #$01
           sta    $44
LA4BA:     lda    $03C8
           bmi    LA4C7
           cmp    #$04
           bcc    LA4D0
           lda    #$03
           bne    LA4CD
LA4C7:     cmp    #$FD
           bcs    LA4D0
           lda    #$FD
LA4CD:     sta    $03C8
LA4D0:     lda    $1D00
           bmi    LA4DD
           cmp    #$04
           bcc    LA4E6
           lda    #$03
           bne    LA4E3
LA4DD:     cmp    #$FD
           bcs    LA4E6
           lda    #$FD
LA4E3:     sta    $1D00
LA4E6:     rts

LA4E7:     .byte  $02,$01,$01,$01,$00,$FF,$FF,$FF
           .byte  $FE,$FF,$FF,$FF,$00,$01,$01,$01
LA4F7:     .byte  $00,$FF,$FF,$FF,$FE,$FF,$FF,$FF
           .byte  $00,$01,$01,$01,$02,$01,$01,$01
LA507:     ldx    $40
LA509:     lda    $03A2,x
           bmi    LA531
           lda    $033C,x
           tay
           lda    $1D80,y
           cmp    #$FF
           beq    LA531
           and    $37
           bne    LA531
           clc
           lda    $0362,x
           adc    $03C8,x
           sta    $0362,x
           clc
           lda    $0375,x
           adc    $1D00,x
           sta    $0375,x
LA531:     dex
           bpl    LA509
           rts

LA535:     jsr    LAE47
           lda    $26
           beq    LA57A
           lda    #$07
           sta    $B4
LA540:     ldx    $B4
           lda    $26
           and    LAB93,x
           beq    LA576
           lda    $1D65,x
           sta    $A3
           lda    $1D6D,x
           sta    $A4
           jsr    LA65D
           txa
           cmp    #$FF
           beq    LA576
           ldy    $B4
           txa
           bne    LA56B
           lda    $1D75,y
           beq    LA57A
           jsr    LB0B6
           jmp    LA57A

LA56B:     lda    $1D75,y
           bne    LA57A
           jsr    LB0B6
           jmp    LA57A

LA576:     dec    $B4
           bpl    LA540
LA57A:     lda    #$12
           sta    $B4
LA57E:     ldy    $B4
           lda    $033C,y
           sta    $2B
           cmp    #$FF
           bne    LA58C
           jmp    LA623

LA58C:     lda    $03A2,y
           bpl    LA59E
           cmp    #$FF
           bne    LA598
           jmp    LA623

LA598:     jsr    LAFCC
           jmp    LA623

LA59E:     lda    $2B
           cmp    #$05
           bcc    LA5A9
           clc
           adc    #$22
           bne    LA5CE
LA5A9:     lda    $034F,y
           jsr    LAB9B
           lda    $0388,y
           sta    $A3
           lda    $0395,y
           sta    $A4
           jsr    LAB41
           ldy    $B4
           lda    $03C8,y
           sta    $AE
           lda    $1D00,y
           sta    $AF
           lda    $1D13,y
           sta    $034F,y
LA5CE:     jsr    LAB9B
           lda    $0362,y
           sta    $A3
           lda    $0375,y
           sta    $A4
           jsr    LAB05
           lda    $2B
           cmp    #$05
           bcs    LA623
           ldy    $B4
           lda    $A3
           sta    $0362,y
           sta    $0388,y
           lda    $A4
           sta    $0375,y
           sta    $0395,y
           lda    $18
           beq    LA623
           sei
           lda    #$21
           sta    $47
           sta    $4B
           lda    #$03
           sta    $43
           cli
           lda    $AE
           sta    $03C8,y
           lda    $AF
           sta    $1D00,y
           lda    $18
           bmi    LA619
           jsr    LAC69
           lda    $18
LA619:     jsr    LAC77
           lda    $18
           bpl    LA623
           jsr    LAC69
LA623:     dec    $B4
           bmi    LA62A
           jmp    LA57E

LA62A:     lda    $03A2
           bmi    LA659
           lda    $03C8
           bne    LA63B
           lda    $1D00
           bne    LA63B
           beq    LA63F
LA63B:     lda    $1B
           beq    LA659
LA63F:     lda    $0362
           sta    $A3
           lda    $0375
           sta    $A4
           jsr    LA65D
           txa
           bmi    LA659
           beq    LA659
           jsr    LB0B6
           ldx    #$00
           jsr    LB0B6
LA659:     jsr    LABCE
           rts

LA65D:     ldx    #$12
LA65F:     lda    $03A2,x
           bmi    LA698
           lda    $0362,x
           cmp    $A3
           bcs    LA674
           clc
           adc    #$08
           cmp    $A3
           bcs    LA67E
           bcc    LA698
LA674:     lda    $A3
           clc
           adc    #$08
           cmp    $0362,x
           bcc    LA698
LA67E:     lda    $0375,x
           cmp    $A4
           bcs    LA68E
           clc
           adc    #$08
           cmp    $A4
           bcs    LA69B
           bcc    LA698
LA68E:     lda    $A4
           clc
           adc    #$08
           cmp    $0375,x
           bcs    LA69B
LA698:     dex
           bpl    LA65F
LA69B:     rts

LA69C:     lda    $2F
           bne    LA6EF
           lda    $3E
           cmp    $4F
           bne    LA6C6
           ldy    #$03
           jsr    LA887
           txa
           beq    LA6C6
           ldy    #$01
           jsr    LA84F
           ldx    $55
           lda    LA83F,x
           clc
           adc    $3E
           sta    $4F
           sei
           lda    #$00
           sta    $46
           cli
           jmp    LA6EF

LA6C6:     lda    $31
           bne    LA6EF
           lda    $3E
           cmp    $50
           bne    LA6EF
           ldy    #$04
           jsr    LA887
           txa
           bne    LA6E0
           ldy    #$02
           jsr    LA887
           txa
           beq    LA6EF
LA6E0:     ldy    #$03
           jsr    LA84F
           ldx    $55
           lda    LA83B,x
           clc
           adc    $3E
           sta    $50
LA6EF:     lda    $30
           bne    LA700
           ldy    #$04
           jsr    LA887
           txa
           beq    LA700
           ldy    #$02
           jsr    LA84F
LA700:     ldy    $40
LA702:     lda    $03A2,y
           bmi    LA723
           lda    $033C,y
           tax
           lda    $37
           and    LA835,x
           bne    LA723
           lda    $034F,y
           clc
           adc    #$01
           cmp    LA830,x
           bcc    LA720
           lda    LA82B,x
LA720:     sta    $1D13,y
LA723:     dey
           bne    LA702
           ldx    $40
LA728:     lda    $03A2,x
           bmi    LA773
           lda    $033C,x
           tay
           cmp    #$01
           beq    LA773
           lda    $1D80,y
           cmp    #$FF
           beq    LA773
           and    $37
           bne    LA773
           lda    $03A2,x
           tay
           dec    $03B5,x
           bne    LA767
           iny
           tya
           and    #$03
           sta    $03A2,x
           tay
           clc
           lda    $5C,y
           bne    LA75A
           lda    #$28
           .byte  $2C
LA75A:     lda    #$00
           adc    #$28
           adc    $1D26,x
           adc    $1D26,x
           sta    $03B5,x
LA767:     lda    $57,y
           sta    $03C8,x
           lda    $5C,y
           sta    $1D00,x
LA773:     dex
           bne    LA728
           lda    $37
           and    $36
           bne    LA7BD
           ldy    $40
LA77E:     sec
           lda    $0362,y
           sbc    $0362
           bcc    LA790
           jsr    LA89B
           lda    LA847,x
           jmp    LA799

LA790:     jsr    LAA23
           jsr    LA89B
           lda    LA84B,x
LA799:     sta    $1D33,y
           sec
           lda    $0375,y
           sbc    $0375
           bcc    LA7AE
           jsr    LA89B
           lda    LA847,x
           jmp    LA7B7

LA7AE:     jsr    LAA23
           jsr    LA89B
           lda    LA84B,x
LA7B7:     sta    $1D40,y
           dey
           bne    LA77E
LA7BD:     ldx    $2F
           beq    LA7D0
           lda    $38
           cmp    #$FF
           beq    LA7D0
           and    $3E
           bne    LA7D0
           stx    $3B
           jsr    LAF46
LA7D0:     ldx    $30
           beq    LA7E3
           lda    $39
           cmp    #$FF
           beq    LA7E3
           and    $3E
           bne    LA7E3
           stx    $3B
           jsr    LAF46
LA7E3:     ldx    $31
           beq    LA7F6
           lda    $3A
           cmp    #$FF
           beq    LA7F6
           and    $3E
           bne    LA7F6
           stx    $3B
           jsr    LAF46
LA7F6:     ldx    $2F
           beq    LA811
           lda    $52
           cmp    $3E
           bne    LA811
           stx    $3B
           jsr    LAF9D
           clc
           lda    VIA2+$4
           and    #$7F
           ora    #$40
           adc    $3E
           sta    $52
LA811:     ldx    $30
           beq    LA82A
           lda    $53
           cmp    $3E
           bne    LA82A
           stx    $3B
           jsr    LAF9D
           clc
           lda    VIA2+$4
           ora    #$C0
           adc    $3E
           sta    $53
LA82A:     rts

LA82B:     .byte  $00,$20,$23,$24,$25
LA830:     .byte  $1F,$23,$25,$26,$27
LA835:     .byte  $00,$00,$01,$01,$03,$00
LA83B:     .byte  $FA,$F0,$C8,$96
LA83F:     .byte  $FF,$F5,$CD,$9B
LA843:     .byte  $00,$28,$50,$78
LA847:     .byte  $00,$FE,$FD,$FD
LA84B:     .byte  $00,$02,$03,$03
LA84F:     sty    $51
           lda    $033C,x
           tay
           lda    #$00
           sta    $2E,y
           ldy    $51
           lda    LA82B,y
           sta    $1D13,x
           tya
           sta    $033C,x
           txa
           sta    $2E,y
           cpy    #$01
           bne    LA87E
           lda    $03A2,x
           tay
           lda    LA87F,y
           sta    $03C8,x
           lda    LA883,y
           sta    $1D00,x
LA87E:     rts

LA87F:     .byte  $03,$03,$FD,$FD
LA883:     .byte  $03,$FD,$FD,$03
LA887:     sty    $51
           ldx    $40
LA88B:     lda    $03A2,x
           bmi    LA897
           lda    $033C,x
           cmp    $51
           beq    LA89A
LA897:     dex
           bne    LA88B
LA89A:     rts

LA89B:     ldx    #$03
LA89D:     cmp    LA843,x
           bcs    LA8A5
           dex
           bne    LA89D
LA8A5:     rts

LA8A6:     sei
           ldx    #$7F
           stx    VIA2+$2
           lda    JOY_REG_RIGHT
           ldx    #$00
           and    #JOY_MASK_RIGHT
           bne    LA8B7
           ldx    #$FF
LA8B7:     stx    $B1
           ldx    #$FF
           stx    VIA2+$2
           ldx    #$F7
           stx    JOY_REG_RIGHT
           cli
LA8C4:     lda    JOY_REG_OTHER
           cmp    JOY_REG_OTHER
           bne    LA8C4
           and    #$3E
           cmp    #$1F
           bcs    LA8D6
           ldx    #$80
           bne    LA8E0
LA8D6:     bit    $B0
           bpl    LA8DE
           ldx    #$80
           stx    $35
LA8DE:     ldx    #$00
LA8E0:     stx    $B0
           and    #$1F
           cmp    #$0F
           bcs    LA8EC
           ldx    #$01
           stx    $B1
LA8EC:     ldx    #$00
           and    #$04
           bne    LA8F4
           ldx    #$80
LA8F4:     stx    $B2
           clc
           lda    $B1
           adc    $034F
           and    #$0F
           sta    $B1
           rts

LA901:     ldx    #$10
           lda    VIC+$8
LA906:     cmp    LA959,x
           bcs    LA910
           dex
           bpl    LA906
           bmi    LA915
LA910:     txa
           and    #$0F
           sta    $B1
LA915:     lda    JOY_REG_OTHER
           and    #$10
           beq    LA937
           lda    #$00
           sta    $B2
           lda    $B0
           beq    LA92E
           lda    $29
           cmp    $37
           beq    LA92E
           lda    #$80
           sta    $35
LA92E:     lda    $37
           sta    $29
           lda    #$00
           sta    $B0
           rts

LA937:     lda    $B2
           bmi    LA94F
           lda    $B0
           beq    LA950
           lda    $29
           cmp    $37
           bne    LA94F
           lda    #$00
           sta    $B0
           lda    #$80
           sta    $29
           sta    $B2
LA94F:     rts

LA950:     lda    #$80
           sta    $B0
           lda    $37
           sta    $29
           rts

LA959:     brk
           .byte  $0F
           asl    $3C2D,x
           .byte  $4B
           .byte  $5A
           .byte  $69,$78,$87,$96,$A5,$B4,$C3,$D2
           .byte  $E1,$F0
LA96A:     lda    #$80
           .byte  $2C
LA96D:     lda    #$00
           sta    $61
           lda    #$00
           sta    $18
           lda    $A3
           cmp    #$F8
           bcs    LA9A5
           bit    $61
           bpl    LA985
           cmp    #$9D
           bcs    LA9B7
           bcc    LA989
LA985:     cmp    #$97
           bcs    LA9B7
LA989:     cmp    #$79
           bcs    LA9D0
           cmp    #$75
           bcs    LA9C9
           bit    $61
           bpl    LA999
           cmp    #$28
           bcc    LA9D0
LA999:     cmp    #$20
           bcs    LA9CC
           cmp    #$01
           bcs    LA9D0
           cmp    #$01
           bcs    LA9D0
LA9A5:     lda    $A4
           ldy    #$07
           cmp    #$50
           bcs    LA9AE
           iny
LA9AE:     sty    $18
           lda    #$02
           sta    $A3
           jmp    LAA77

LA9B7:     lda    $A4
           ldy    #$03
           cmp    #$50
           bcc    LA9C0
           iny
LA9C0:     sty    $18
           lda    #$95
           sta    $A3
           jmp    LAA77

LA9C9:     lda    #$FE
           .byte  $2C
LA9CC:     lda    #$FC
           sta    $18
LA9D0:     lda    $A4
           cmp    #$F8
           bcs    LA9F8
           bit    $61
           bpl    LA9E0
           cmp    #$9D
           bcs    LAA11
           bcc    LA9E4
LA9E0:     cmp    #$97
           bcs    LAA11
LA9E4:     cmp    #$65
           bcs    LAA0A
           bit    $61
           bpl    LA9F0
           cmp    #$3C
           bcc    LAA0A
LA9F0:     cmp    #$34
           bcs    LAA29
           cmp    #$01
           bcs    LAA0A
LA9F8:     lda    $A3
           ldy    #$01
           cmp    #$50
           bcc    LAA01
           iny
LAA01:     sty    $18
           lda    #$02
           sta    $A4
           jmp    LAA6D

LAA0A:     lda    #$00
           sta    $18
           jmp    LAAAC

LAA11:     lda    $A3
           ldy    #$05
           cmp    #$50
           bcs    LAA1A
           iny
LAA1A:     sty    $18
           lda    #$94
           sta    $A4
           jmp    LAA6D

LAA23:     eor    #$FF
           clc
           adc    #$01
           rts

LAA29:     lda    $18
           bpl    LAA0A
           cmp    #$FC
           bne    LAA43
           lda    $A3
           cmp    #$25
           bcs    LAA4F
           bit    $61
           bpl    LAA3F
           lda    #$25
           bne    LAA4B
LAA3F:     lda    #$20
           bne    LAA4B
LAA43:     lda    $A3
           cmp    #$76
           bcc    LAA4F
           lda    #$79
LAA4B:     sta    $A3
           bne    LAA77
LAA4F:     lda    $A4
           cmp    #$50
           bcs    LAA65
           lda    #$FF
           sta    $18
           bit    $61
           bpl    LAA61
           lda    #$3C
           bne    LAA6B
LAA61:     lda    #$34
           bne    LAA6B
LAA65:     lda    #$FD
           sta    $18
           lda    #$65
LAA6B:     sta    $A4
LAA6D:     lda    $AF
           jsr    LAA23
           sta    $AF
           jmp    LAA7E

LAA77:     lda    $AE
           jsr    LAA23
           sta    $AE
LAA7E:     lda    $2B
           bne    LAAAC
           lda    $AE
           beq    LAA97
           bmi    LAA91
           cmp    #$01
           beq    LAA97
           dec    $AE
           jmp    LAA97

LAA91:     cmp    #$FF
           beq    LAA97
           inc    $AE
LAA97:     lda    $AF
           beq    LAAAC
           bmi    LAAA6
           cmp    #$01
           beq    LAAAC
           dec    $AF
           jmp    LAAAC

LAAA6:     cmp    #$FF
           beq    LAAAC
           inc    $AF
LAAAC:     clc
           lda    $A3
           and    #$07
           sta    $AD
           lda    $A3
           lsr    a
           lsr    a
           and    #$FE
           tax
           clc
           lda    LAAD7,x
           adc    $A4
           sta    $A5
           lda    LAAD7+1,x
           adc    #$00
           sta    $A6
           clc
           lda    $A5
           adc    #$A0
           sta    $A7
           lda    $A6
           adc    #$00
           sta    $A8
           rts

LAAD7:     .byte  $00,>CHARSET+$00,$A0,>CHARSET+$00,$40,>CHARSET+$01,$E0,>CHARSET+$01
           .byte  $80,>CHARSET+$02,$20,>CHARSET+$03,$C0,>CHARSET+$03,$60,>CHARSET+$04
           .byte  $00,>CHARSET+$05,$A0,>CHARSET+$05,$40,>CHARSET+$06,$E0,>CHARSET+$06
           .byte  $80,>CHARSET+$07,$20,>CHARSET+$08,$C0,>CHARSET+$08,$60,>CHARSET+$09
           .byte  $00,>CHARSET+$0A,$A0,>CHARSET+$0A,$40,>CHARSET+$0B,$E0,>CHARSET+$0B
        
LAAFF:     jsr    LAAAC
           jmp    LAB0C

LAB05:     lda    #$00
           sta    $1B
           jsr    LA96D
LAB0C:     ldy    #$07
LAB0E:     lda    ($A9),y
           ldx    #$00
           stx    $AC
           ldx    $AD
           beq    LAB1F
LAB18:     clc
           lsr    a
           ror    $AC
           dex
           bne    LAB18
LAB1F:     sta    $AB
           lda    ($A5),y
           tax
           and    $AB
           ora    $1B
           sta    $1B
           txa
           ora    $AB
           sta    ($A5),y
           lda    ($A7),y
           tax
           and    $AC
           ora    $1B
           sta    $1B
           txa
           ora    $AC
           sta    ($A7),y
           dey
           bpl    LAB0E
           rts

LAB41:     jsr    LAAAC
           jmp    LAB4A

LAB47:     jsr    LA96D
LAB4A:     ldy    #$07
LAB4C:     lda    ($A9),y
           eor    #$FF
           ldx    #$FF
           stx    $AC
           ldx    $AD
           beq    LAB5F
LAB58:     sec
           ror    a
           ror    $AC
           dex
           bne    LAB58
LAB5F:     and    ($A5),y
           sta    ($A5),y
           lda    $AC
           and    ($A7),y
           sta    ($A7),y
           dey
           bpl    LAB4C
           rts

LAB6D:     jsr    LAAAC
           ldx    $AD
           lda    LAB93,x
           ldx    #$00
           ora    ($A5,x)
           sta    ($A5,x)
           rts

LAB7C:     jsr    LA96A
           jmp    LAB85

LAB82:     jsr    LAAAC
LAB85:     ldx    $AD
           lda    LAB93,x
           ldx    #$00
           eor    #$FF
           and    ($A5,x)
           sta    ($A5,x)
           rts

LAB93:     .byte  $80,$40,$20,$10,$08,$04,$02,$01
LAB9B:     sta    $2A
           lda    #$00
           sta    $AA
           lda    $2A
           asl    a
           rol    $AA
           asl    a
           rol    $AA
           asl    a
           rol    $AA
           clc
           adc    #<TILES1
           sta    $A9
           lda    $AA
           adc    #>TILES1
           sta    $AA
           rts

LABB8:     jsr    LAB6D
           clc
           lda    $A3
           adc    $AE
           sta    $A3
           clc
           lda    $A4
           adc    $AF
           sta    $A4
           dec    $BD
           bne    LABB8
           rts

LABCE:     ldy    #$07
           sty    $1A
LABD2:     ldy    $1A
           lda    LABE6,y
           sta    $A3
           lda    LABEE,y
           sta    $A4
           jsr    LAB6D
           dec    $1A
           bpl    LABD2
           rts

LABE6:     .byte  $00,$50,$9F,$00,$9F,$00,$50,$9F
LABEE:     .byte  $00,$00,$00,$50,$50,$9F,$9F,$9F
LABF6:     lda    #$08
           sta    $3C
LABFA:     lda    $3C
           jsr    LAC77
           dec    $3C
           bne    LABFA
           rts

LAC04:     lda    #$08
           sta    $3C
LAC08:     lda    $3C
           cmp    #$FB
           beq    LAC16
           jsr    LAC69
           dec    $3C
           jmp    LAC08

LAC16:     rts

LAC17:     .byte  $00
LAC18:     .byte  $00
LAC19:     .byte  $4F
LAC1A:     .byte  $01
LAC1B:     .byte  $00,$50,$00,$4F,$01,$00,$00,$9F
           .byte  $4F,$01,$00,$50,$9F,$4F,$01,$00
           .byte  $28,$3C,$50,$01,$00,$28,$64,$50
           .byte  $01,$00,$00,$00,$4F,$00,$01,$00
           .byte  $50,$4F,$00,$01,$9F,$00,$4F,$00
           .byte  $01,$9F,$50,$4F,$00,$01,$28,$3C
           .byte  $28,$00,$01,$78,$3C,$28,$00,$01
LAC53:     jsr    LAB82
           clc
           lda    $A3
           adc    $AE
           sta    $A3
           clc
           lda    $A4
           adc    $AF
           sta    $A4
           dec    $BD
           bne    LAC53
           rts

LAC69:     clc
           adc    #$04
           tay
           lda    LACA0,y
           jsr    LAC85
           jsr    LABB8
           rts

LAC77:     clc
           adc    #$04
           tay
           lda    LACA0,y
           jsr    LAC85
           jsr    LAC53
           rts

LAC85:     tay
           lda    LAC17,y
           sta    $A3
           lda    LAC18,y
           sta    $A4
           lda    LAC19,y
           sta    $BD
           lda    LAC1A,y
           sta    $AE
           lda    LAC1B,y
           sta    $AF
           rts

LACA0:     .byte  $32,$19,$37,$14,$00,$00,$05,$28
           .byte  $2D,$0F,$0A,$23,$1E
LACAD:     lda    #$52
           sta    $17
           lda    #$48
           sta    $A4
           ldx    #$02
LACB7:     lda    $F7,x
           sta    $1C,x
           dex
           bpl    LACB7
           jsr    LACD7
           rts

LACC2:     lda    #$52
           sta    $17
           lda    #$5C
           sta    $A4
           ldx    #$02
LACCC:     lda    $23,x
           sta    $1C,x
           dex
           bpl    LACCC
           jsr    LACD7
           rts

LACD7:     jsr    LADA7
           ldx    #$02
           stx    $B4
LACDE:     ldx    $B4
           lda    $1C,x
           bne    LACF0
           jsr    LADA7
           jsr    LADA7
           dec    $B4
           bpl    LACDE
           bmi    LAD12
LACF0:     and    #$F0
           beq    LACFF
LACF4:     ldx    $B4
           lda    $1C,x
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           jsr    LAD9D
LACFF:     jsr    LADA7
           ldx    $B4
           lda    $1C,x
           and    #$0F
           jsr    LAD9D
           jsr    LADA7
           dec    $B4
           bpl    LACF4
LAD12:     lda    #$00
           jsr    LAD9D
           rts

LAD18:     lda    #$04
           sta    $1C
           lda    #$5A
           sta    $17
           lda    #$40
           sta    $A4
           jsr    LAD37
           lda    #$09
           sta    $1C
           lda    #$46
           sta    $17
           lda    #$54
           sta    $A4
           jsr    LAD37
           rts

LAD37:     jsr    LADA7
           ldy    $1C
           lda    LB71E,y
           jsr    LAB9B
           jsr    LAAFF
           dec    $1C
           bpl    LAD37
           rts

LAD4A:     ldx    #$02
           stx    $B4
           lda    #$29
           jsr    LAB9B
LAD53:     ldx    $B4
           lda    LAD93,x
           sta    $A3
           lda    LAD98,x
           sta    $A4
           jsr    LAB41
           dec    $B4
           bpl    LAD53
           ldx    $1F
           beq    LAD92
           stx    $B4
           lda    #$00
           jsr    LAB9B
           lda    $54
           beq    LAD7F
           lda    #$3D
           sta    $A3
           lda    #$4C
           sta    $A4
           bne    LAD8B
LAD7F:     ldx    $B4
           lda    LAD93,x
           sta    $A3
           lda    LAD98,x
           sta    $A4
LAD8B:     jsr    LAAFF
           dec    $B4
           bne    LAD7F
LAD92:     rts

LAD93:     .byte  $3D,$2B,$2B,$34,$34
LAD98:     .byte  $4C,$44,$54,$44,$54
LAD9D:     clc
           adc    #$47
           jsr    LAB9B
           jsr    LAAFF
           rts

LADA7:     lda    $17
           clc
           adc    #$04
           sta    $17
           sta    $A3
           lda    #$5B
           jsr    LAB9B
           jsr    LAB41
           rts

LADB9:     lda    #$00
           sta    $35
           lda    $19
           beq    LAE06
           ldx    #$03
LADC3:     lda    $1D5D,x
           bne    LAE03
           sei
           lda    #$01
           sta    $47
           sta    $4B
           sta    $43
           cli
           ldy    $B1
           clc
           lda    LAE07,y
           sta    $1D4D,x
           clc
           lda    $0362
           adc    LAE27,y
           sta    $1D65,x
           clc
           lda    LAE17,y
           sta    $1D55,x
           clc
           lda    $0375
           adc    LAE37,y
           sta    $1D6D,x
           lda    #$32
           sta    $1D5D,x
           lda    #$00
           sta    $1D75,x
           dec    $19
           rts

LAE03:     dex
           bpl    LADC3
LAE06:     rts

LAE07:     .byte  $03,$02,$02,$01,$00,$FF,$FE,$FE
           .byte  $FD,$FD,$FE,$FF,$00,$01,$02,$02
LAE17:     .byte  $00,$FF,$FE,$FE,$FD,$FE,$FF,$FF
           .byte  $00,$01,$02,$02,$03,$02,$02,$01
LAE27:     .byte  $09,$09,$09,$05,$04,$03,$FF,$FF
           .byte  $FF,$FF,$FF,$03,$04,$05,$09,$09
LAE37:     .byte  $04,$03,$FF,$FF,$FF,$FF,$FF,$03
           .byte  $04,$05,$09,$09,$09,$09,$09,$05
LAE47:     lda    #$00
           sta    $1B
           sta    $26
           lda    #$07
           sta    $B4
LAE51:     ldx    $B4
           lda    $1D5D,x
           beq    LAEC3
           jsr    LAF31
           jsr    LAF01
           ldx    $B4
           dec    $1D5D,x
           beq    LAEA8
           clc
           lda    $1D4D,x
           sta    $AE
           adc    $1D65,x
           sta    $A3
           sta    $1D65,x
           clc
           lda    $1D55,x
           sta    $AF
           adc    $1D6D,x
           sta    $A4
           sta    $1D6D,x
           jsr    LAECB
           lda    $18
           beq    LAE93
           jsr    LAC69
           lda    $18
           jsr    LAC77
           jmp    LAEA0

LAE93:     lda    $1B
           beq    LAEC3
           ldy    $B4
           lda    LAB93,y
           ora    $26
           sta    $26
LAEA0:     ldx    $B4
           jsr    LAF31
           jsr    LAF01
LAEA8:     ldx    $B4
           lda    $1D75,x
           bne    LAEB1
           inc    $19
LAEB1:     lda    #$00
           sta    $1D5D,x
           lda    $18
           bpl    LAEBD
           jsr    LAC69
LAEBD:     lda    #$00
           sta    $1B
           sta    $18
LAEC3:     dec    $B4
           bmi    LAECA
           jmp    LAE51

LAECA:     rts

LAECB:     lda    #$03
           sta    $BD
           lda    #$00
           sta    $1B
LAED3:     jsr    LAF7E
           lda    $18
           ora    $1B
           bne    LAF00
           lda    $AE
           beq    LAEEC
           bmi    LAEE5
           lda    #$01
           .byte  $2C
LAEE5:     lda    #$FF
           clc
           adc    $A3
           sta    $A3
LAEEC:     lda    $AF
           beq    LAEFC
           bmi    LAEF5
           lda    #$01
           .byte  $2C
LAEF5:     lda    #$FF
           clc
           adc    $A4
           sta    $A4
LAEFC:     dec    $BD
           bne    LAED3
LAF00:     rts

LAF01:     lda    #$03
           sta    $BD
LAF05:     jsr    LAB7C
           lda    $18
           bne    LAF30
           lda    $AE
           beq    LAF1C
           bmi    LAF15
           lda    #$01
           .byte  $2C
LAF15:     lda    #$FF
           clc
           adc    $A3
           sta    $A3
LAF1C:     lda    $AF
           beq    LAF2C
           bmi    LAF25
           lda    #$01
           .byte  $2C
LAF25:     lda    #$FF
           clc
           adc    $A4
           sta    $A4
LAF2C:     dec    $BD
           bne    LAF05
LAF30:     rts

LAF31:     lda    $1D65,x
           sta    $A3
           lda    $1D6D,x
           sta    $A4
           lda    $1D4D,x
           sta    $AE
           lda    $1D55,x
           sta    $AF
           rts

LAF46:     ldy    #$07
           ldx    $3B
LAF4A:     lda    $1D5D,y
           bne    LAF78
           lda    $1D33,x
           sta    $1D4D,y
           clc
           adc    $0362,x
           adc    #$04
           sta    $1D65,y
           lda    $1D40,x
           sta    $1D55,y
           clc
           adc    $0375,x
           adc    #$04
           sta    $1D6D,y
           lda    #$23
           sta    $1D5D,y
           lda    #$01
           sta    $1D75,y
           rts

LAF78:     dey
           cpy    #$03
           bne    LAF4A
           rts

LAF7E:     jsr    LA96A
           lda    $18
           bne    LAF9C
           ldx    $AD
           lda    LAB93,x
           sta    $B3
           ldx    #$00
           lda    ($A5,x)
           tay
           and    $B3
           ora    $1B
           sta    $1B
           tya
           ora    $B3
           sta    ($A5,x)
LAF9C:     rts

LAF9D:     ldy    #$12
LAF9F:     lda    $033C,y
           bmi    LAFAB
           dey
           cpy    #$0D
           bcs    LAF9F
           bcc    LAFCB
LAFAB:     lda    $0362,x
           sta    $0362,y
           lda    $0375,x
           sta    $0375,y
           lda    #$00
           sta    $03A2,y
           lda    VIA2+$4
           and    #$03
           bne    LAFC6
           lda    #$05
           .byte  $2C
LAFC6:     lda    #$06
           sta    $033C,y
LAFCB:     rts

LAFCC:     sty    $28
           ldx    $28
           lda    $37
           and    #$07
           beq    LAFD7
           rts

LAFD7:     lda    $03A2,x
           cmp    #$82
           bcs    LB017
           jsr    LB1A1
           ldy    #$08
           sty    $3C
LAFE5:     ldx    $28
           ldy    $3C
           lda    LB08A,y
           clc
           adc    $0362,x
           sta    $A3
           lda    LB093,y
           clc
           adc    $0375,x
           sta    $A4
           lda    $03A2,x
           and    #$01
           beq    LB004
           lda    #$09
LB004:     clc
           adc    $3C
           tay
           lda    LB0A4,y
           jsr    LAB9B
           jsr    LAB05
           dec    $3C
           bpl    LAFE5
           bmi    LB04C
LB017:     jsr    LB17A
           ldy    #$03
           sty    $3C
LB01E:     ldx    $28
           ldy    $3C
           lda    LB082,y
           clc
           adc    $0362,x
           sta    $A3
           lda    LB086,y
           clc
           adc    $0375,x
           sta    $A4
           lda    $03A2,x
           and    #$01
           asl    a
           asl    a
           clc
           adc    $3C
           tay
           lda    LB09C,y
           jsr    LAB9B
           jsr    LAB05
           dec    $3C
           bpl    LB01E
LB04C:     ldx    $28
           dec    $03B5,x
           bmi    LB05C
           lda    $03A2,x
           eor    #$01
           sta    $03A2,x
           rts

LB05C:     lda    #$2A
           sta    $034F,x
           sta    $1D13,x
           lda    $03A2,x
           cmp    #$82
           bcs    LB071
           jsr    LB1A1
           jmp    LB074

LB071:     jsr    LB17A
LB074:     ldy    $28
           lda    $033C,y
           lda    #$FF
           sta    $03A2,y
           sta    $033C,y
           rts

LB082:     .byte  $FC,$04,$FC,$04
LB086:     .byte  $FC,$FC,$04,$04
LB08A:     .byte  $F8,$00,$08,$F8,$00,$08,$F8,$00
           .byte  $08
LB093:     .byte  $F8,$F8,$F8,$00,$00,$00,$08,$08
           .byte  $08
LB09C:     .byte  $2D,$2E,$2F,$30,$31,$32,$33,$34
LB0A4:     .byte  $35,$36,$37,$38,$39,$3A,$3B,$3C
           .byte  $3D,$3E,$3F,$40,$41,$42,$43,$44
           .byte  $45,$46
LB0B6:     lda    #$00
           sta    $03C8,x
           sta    $1D00,x
           lda    $033C,x
           tay
           beq    LB100
           cmp    #$05
           bne    LB0D4
           lda    #$01
           sta    $48
           sta    $4C
           lda    #$07
           sta    $44
           bne    LB0E9
LB0D4:     bcc    LB0DA
           lda    #$17
           bne    LB0DF
LB0DA:     dec    $3D
           sei
           lda    #$0A
LB0DF:     sei
           sta    $46
           sta    $4A
           lda    #$01
           sta    $42
           cli
LB0E9:     lda    #$02
           sta    $03B5,x
           lda    #$82
           sta    $03A2,x
           lda    #$00
           sta    $2E,y
           tya
           jsr    LB12D
           jsr    LACAD
           rts

LB100:     lda    #$80
           sta    $03A2,x
           lda    #$06
           sta    $03B5,x
           dec    $1F
           lda    #$3C
           sta    $4D
           lda    $4E
           ora    #$01
           sta    $4E
           sei
           lda    #$0C
           sta    $48
           sta    $4C
           lda    #$04
           sta    $44
           lda    #$01
           sta    $45
           sta    $49
           lda    #$0C
           sta    $41
           cli
           rts

LB12D:     sei
           asl    a
           tay
           sed
           lda    LB16A,y
           adc    $F7
           sta    $F7
           lda    LB16B,y
           adc    $F8
           sta    $F8
           lda    $F9
           adc    #$00
           sta    $F9
           cld
           cli
           lda    $54
           bne    LB169
           lda    $F8
           cmp    #$40
           bcc    LB169
           sei
           lda    #$11
           sta    $47
           sta    $4B
           lda    #$03
           sta    $43
           cli
           lda    #$01
           sta    $54
           inc    $1F
           jsr    LAD4A
           sta    $A46D         ; ???
LB169:     rts

LB16A:     .byte  $00
LB16B:     .byte  $00,$50,$02,$50,$01,$50,$01,$00
           .byte  $01,$50,$00,$35,$00,$00,$05
LB17A:     ldy    #$03
           sty    $1A
LB17E:     ldx    $28
           ldy    $1A
           lda    $0362,x
           clc
           adc    LB082,y
           sta    $A3
           lda    $0375,x
           clc
           adc    LB086,y
           sta    $A4
           lda    #$29
           jsr    LAB9B
           jsr    LAB47
           dec    $1A
           bpl    LB17E
           rts

LB1A1:     ldy    #$08
           sty    $1A
LB1A5:     ldx    $28
           ldy    $1A
           lda    $0362,x
           clc
           adc    LB08A,y
           sta    $A3
           lda    $0375,x
           clc
           adc    LB093,y
           sta    $A4
           lda    #$29
           jsr    LAB9B
           jsr    LAB47
           dec    $1A
           bpl    LB1A5
           rts

LB1C8:     jsr    LA429
           ldy    #$28
LB1CD:     lda    #$02
           sta    COLORRAM+$3C,y
           lda    #$07
           sta    COLORRAM+$64,y
           dey
           bpl    LB1CD
           ldx    #<MSG2
           ldy    #>MSG2
           lda    #$01
           sta    $AE
           sta    $AF
           jsr    LB2CC         ; display splash screen
           jsr    LB2B4
           bit    $B0
           bpl    LB1EF
           rts

LB1EF:     lda    $62
           beq    LB20B
           jsr    LA452
           jsr    LA429
           ldx    #<MSG1
           ldy    #>MSG1
           lda    #$02
           sta    $AE
           lda    #$FF
           sta    $AF
           jsr    LB2CC         ; display ?
           jsr    LB2B4
LB20B:     jsr    LA452
           jsr    LA429
           ldx    #<MSG3
           ldy    #>MSG3
           lda    #$01
           sta    $AE
           sta    $AF
           jsr    LB2CC         ; display option screen
           bit    $B0
           bmi    LB286
           jsr    LB28A
           bit    $B0
           bmi    LB286
           jsr    LA429
           jsr    LA452
           jsr    LABCE
           ldx    #<MSG4
           ldy    #>MSG4
           lda    #$01
           sta    $AE
           lda    #$FF
           sta    $AF
           jsr    LB2CC         ; display intro text ("in the year...")
           bit    $B0
           bmi    LB286
           jsr    LB2B4
           bit    $B0
           bmi    LB286
           jsr    LA429
           jsr    LABCE
           ldx    #<MSG5
           ldy    #>MSG5
           lda    #$01
           sta    $AE
           sta    $AF
           jsr    LB2CC         ; display point values (second part of intro text)
           jsr    LB323
           bit    $B0
           bmi    LB286
           jsr    LA429
           jsr    LABCE
           ldx    #<MSG6
           ldy    #>MSG6
           lda    #$01
           sta    $AE
           lda    #$FF
           sta    $AF
           jsr    LB2CC         ; display final part of intro text
           bit    $B0
           bmi    LB286
           jsr    LB2B4
           bit    $B0
           bpl    LB287
LB286:     rts

LB287:     jmp    LB1C8

LB28A:     lda    #$19
           sta    $B3
           lda    #$00
           sta    $AE
LB292:     inc    $AE
           lda    $AE
           and    #$07
           sta    COLORRAM+$03
           sta    COLORRAM+$2B
           sta    COLORRAM+$3F
           sta    COLORRAM+$67
           lda    #$06
           sta    $1A
           jsr    LB2B8
           bit    $B0
           bmi    LB2B3
           dec    $B3
           bne    LB292
LB2B3:     rts

LB2B4:     lda    #$28
           sta    $1A
LB2B8:     lda    #$FF
           sta    $3C
LB2BC:     jsr    LB3D2
           bit    $B0
           bmi    LB2CB
           dec    $3C
           bne    LB2BC
           dec    $1A
           bne    LB2B8
LB2CB:     rts

LB2CC:     stx    $2C
           sty    $2D
LB2D0:     ldy    #$00
           lda    ($2C),y
           sta    $A3
           iny
           lda    ($2C),y
           sta    $A4
           iny
           lda    ($2C),y
           sta    $B3
LB2E0:     iny
           lda    ($2C),y
           bne    LB2F3
           iny
           tya
           clc
           adc    $2C
           sta    $2C
           bcc    LB2D0
           inc    $2D
           jmp    LB2D0
LB2F3:     cmp    #$FF
           beq    LB322
           sty    $B4
           jsr    LAB9B
           jsr    LAAFF
           lda    $AE
           sta    $1A
LB303:     lda    $AF
           sta    $3C
LB307:     jsr    LB3D2
           bit    $B0
           bmi    LB322
           dec    $3C
           bne    LB307
           dec    $1A
           bne    LB303
           ldy    $B4
           lda    $A3
           clc
           adc    $B3
           sta    $A3
           jmp    LB2E0
LB322:     rts

LB323:     lda    #$20
           sta    $B3
           jsr    LAB9B
           lda    #$10
           sta    $A3
           lda    #$90
           sta    $A4
           lda    #$64
           sta    $B4
LB336:     lda    #$FF
           sta    $1A
LB33A:     lda    #$20
           sta    $3C
LB33E:     dec    $3C
           bne    LB33E
           dec    $1A
           bne    LB33A
           jsr    LAB41
           inc    $B3
           lda    $B3
           cmp    #$23
           bne    LB355
           lda    #$20
           sta    $B3
LB355:     jsr    LAB9B
           jsr    LAAFF
           jsr    LB3D2
           bit    $B0
           bmi    LB366
           dec    $B4
           bne    LB336
LB366:     rts

LB367:     jsr    LA429
           sei
           lda    #$11
           sta    $47
           sta    $4B
           lda    #$03
           sta    $43
           cli
           lda    $21
           and    #$0F
           clc
           adc    #$D4
           jsr    LAB9B
           lda    #$80
           sta    $A3
           lda    #$1C
           sta    $A4
           jsr    LAAFF
           lda    $21
           and    #$F0
           beq    LB3A5
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           adc    #$D4
           jsr    LAB9B
           lda    #$78
           sta    $A3
           lda    #$1C
           sta    $A4
           jsr    LAAFF
LB3A5:     ldx    #<MSG8
           ldy    #>MSG8
           lda    #$01
           sta    $AE
           sta    $AF
           jsr    LB2CC         ; display ?
           jsr    LB3BB
           lda    #$07
           jsr    LB12D
           rts

LB3BB:     lda    #$FF
           sta    $1A
LB3BF:     lda    #$FF
           sta    $3C
LB3C3:     dec    $3C
           sta    LA1AD
           sta    LA1BD
           bne    LB3C3
           dec    $1A
           bne    LB3BF
           rts

LB3D2:     jsr    SCANKEY
           jsr    LA8A6
           lda    $B0
           bne    LB407
           jsr    LA901
           lda    $B0
           bne    LB3F7
           jsr    GETKEY
           tax
           cmp    #$85
           beq    LB407
           cmp    #$89
           beq    LB407
           cmp    #$86
           beq    LB3F7
           cmp    #$8A
           bne    LB421
LB3F7:     lda    #<LA901
           sta    $1D7E
           lda    #>LA901
           sta    $1D7F
           cpx    #$8A
           beq    LB418
           bne    LB415
LB407:     lda    #<LA8A6
           sta    $1D7E
           lda    #>LA8A6
           sta    $1D7F
           cpx    #$89
           beq    LB418
LB415:     lda    #$02
           .byte  $2C
LB418:     lda    #$04
           sta    $1F
           lda    #$80
           sta    $B0
           rts

LB421:     ldx    $028D
           cpx    #$07
           beq    LB42C
           jsr    LB438
           rts

LB42C:     lda    #$08
           sta    VIC+$F
           lda    #$01
           sta    $27
           sta    $62
           rts

LB438:     tax
           lda    #$01
           cpx    #$1D
           bne    LB44B
           clc
           adc    VIC+$0
           and    #$8F
           ora    #$01
           sta    VIC+$0
           rts

LB44B:     cpx    #$11
           bne    LB45B
           clc
           adc    VIC+$1
           and    #$3F
           ora    #$01
           sta    VIC+$1
           rts

LB45B:     cpx    #$8C
           bne    LB468
           lda    VIC+$0
           eor    #$80
           sta    VIC+$0
           rts

LB468:     cpx    #$87
           bne    LB47D
           lda    VIC+$F
           clc
           adc    #$10
           and    #$77
           clc
           adc    #$01
           ora    #$08
           sta    VIC+$F
           rts

LB47D:     cpx    #$88
           bne    LB48C
           inc    $27
           lda    $27
           and    #$07
           sta    $27
           jsr    LA452
LB48C:     rts

WARM:      bit    JOY_REG_OTHER
           pla
           tay
           pla
           tax
           pla
           rti

TILES1:    .byte  $C0,$30,$2C,$23,$2C,$30,$C0,$00
           .byte  $00,$00,$FF,$22,$24,$18,$10,$20
           .byte  $01,$0E,$32,$C2,$24,$14,$08,$08
           .byte  $04,$0C,$14,$24,$64,$9C,$04,$04
           .byte  $10,$10,$28,$28,$44,$7C,$82,$82
           .byte  $20,$30,$28,$24,$26,$39,$20,$20
           .byte  $80,$60,$5C,$23,$24,$28,$10,$10
           .byte  $00,$00,$FF,$44,$24,$18,$08,$04
           .byte  $03,$0C,$34,$C4,$34,$0C,$03,$00
           .byte  $04,$08,$18,$24,$44,$FF,$00,$00
           .byte  $10,$10,$28,$24,$23,$5C,$60,$80
           .byte  $20,$20,$39,$26,$24,$28,$30,$20
           .byte  $82,$82,$7C,$44,$28,$28,$10,$10
           .byte  $04,$04,$9C,$64,$24,$14,$0C,$04
           .byte  $08,$08,$14,$24,$C4,$3A,$06,$01
           .byte  $20,$10,$18,$24,$22,$FF,$00,$00
           .byte  $C0,$30,$6C,$E3,$6C,$30,$C0,$00
           .byte  $00,$00,$FF,$22,$64,$78,$10,$20
           .byte  $01,$0E,$32,$C2,$24,$74,$68,$08
           .byte  $04,$0C,$14,$24,$64,$BC,$34,$04
           .byte  $10,$10,$28,$28,$44,$7C,$BA,$92
           .byte  $20,$30,$28,$24,$26,$3D,$2C,$20
           .byte  $80,$60,$5C,$23,$24,$2E,$16,$10
           .byte  $00,$00,$FF,$44,$26,$1E,$08,$04
           .byte  $03,$0C,$36,$C7,$36,$0C,$03,$00
           .byte  $04,$08,$1E,$26,$44,$FF,$00,$00
           .byte  $10,$16,$2E,$24,$23,$5C,$60,$80
           .byte  $20,$2C,$3D,$26,$24,$28,$30,$20
           .byte  $92,$BA,$7C,$44,$28,$28,$10,$10
           .byte  $04,$34,$BC,$64,$24,$14,$0C,$04
           .byte  $08,$68,$74,$24,$C4,$3A,$06,$01
           .byte  $20,$10,$78,$64,$22,$FF,$00,$00
           .byte  $00,$82,$54,$38,$6C,$10,$10,$10
           .byte  $00,$04,$98,$78,$7C,$08,$04,$00
           .byte  $10,$10,$10,$28,$7C,$28,$44,$00
           .byte  $18,$66,$42,$99,$BD,$42,$66,$18
           .byte  $24,$3C,$C3,$5A,$7E,$C3,$3C,$24
           .byte  $18,$66,$42,$81,$81,$42,$66,$18
           .byte  $24,$3C,$C3,$42,$42,$C3,$3C,$24
           .byte  $10,$28,$44,$FE,$44,$28,$10,$00
           .byte  $10,$28,$44,$FE,$00,$00,$00,$00
           .byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $04,$04,$08,$10,$20,$40,$40,$00
           .byte  $7C,$82,$BA,$A2,$A2,$BA,$82,$7C
           .byte  $00,$00,$00,$01,$09,$05,$00,$1C
           .byte  $00,$00,$00,$00,$20,$40,$00,$70
           .byte  $00,$05,$09,$00,$00,$00,$00,$00
           .byte  $00,$40,$20,$00,$00,$00,$00,$00
           .byte  $09,$49,$25,$10,$C0,$20,$00,$E0
           .byte  $20,$24,$48,$10,$06,$08,$00,$0E
           .byte  $00,$20,$C0,$10,$25,$49,$09,$01
           .byte  $00,$08,$06,$10,$48,$24,$20,$00
           .byte  $00,$00,$00,$00,$00,$00,$02,$01
           .byte  $00,$00,$00,$00,$10,$92,$54,$55
           .byte  $00,$00,$00,$00,$00,$00,$80,$00
           .byte  $00,$06,$00,$0F,$00,$06,$00,$01
           .byte  $92,$54,$00,$C7,$00,$54,$92,$55
           .byte  $00,$C0,$00,$E0,$00,$C0,$00,$00
           .byte  $02,$00,$00,$00,$00,$00,$00,$00
           .byte  $54,$92,$10,$00,$00,$00,$00,$00
           .byte  $80,$00,$00,$00,$00,$00,$00,$00
           .byte  $02,$02,$21,$11,$08,$04,$00,$60
           .byte  $10,$10,$11,$11,$82,$00,$00,$00
           .byte  $80,$80,$08,$10,$20,$40,$00,$0C
           .byte  $18,$00,$00,$F0,$00,$00,$18,$60
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $30,$00,$00,$1E,$00,$00,$30,$0C
           .byte  $00,$04,$08,$11,$21,$02,$02,$00
           .byte  $00,$00,$82,$11,$11,$10,$10,$10
           .byte  $00,$40,$20,$10,$08,$80,$80,$00
           .byte  $E0,$A0,$A0,$A0,$E0,$00,$00,$00
           .byte  $40,$C0,$40,$40,$E0,$00,$00,$00
           .byte  $E0,$20,$60,$80,$E0,$00,$00,$00
           .byte  $E0,$20,$40,$20,$E0,$00,$00,$00
           .byte  $A0,$A0,$E0,$20,$20,$00,$00,$00
           .byte  $E0,$80,$C0,$20,$C0,$00,$00,$00
           .byte  $60,$80,$E0,$A0,$E0,$00,$00,$00
           .byte  $E0,$20,$40,$80,$80,$00,$00,$00
           .byte  $E0,$A0,$E0,$A0,$E0,$00,$00,$00
           .byte  $E0,$A0,$E0,$20,$20,$00,$00,$00

        ;; "SCORE"
LB71E:     .byte  $65,$72,$6F,$63,$73,$2A,$68,$67
           .byte  $69,$68

        ;; ???
MSG1:      .byte  $18,$10,$08,$93,$86,$80,$7D,$93
           .byte  $82,$8F,$90,$86,$8C,$8B,$7D,$7F
           .byte  $96,$00,$24,$38,$08,$7E,$8B,$81
           .byte  $96,$7D,$83,$86,$8B,$88,$82,$89
           .byte  $00,$4B,$4E,$04,$77,$69,$6B,$00
           .byte  $24,$68,$08,$82,$8F,$86,$80,$7D
           .byte  $80,$8C,$91,$91,$8C,$8B,$00,$40
           .byte  $88,$08,$D7,$2B,$DC,$D6

TILES2:    .byte  $FF,$00,$00,$00,$00,$00,$00,$00
           .byte  $F0,$F0,$F0,$F0,$F0,$00,$00,$00
           .byte  $FF,$9B,$B3,$9B,$BB,$B1,$FF,$00
           .byte  $FF,$89,$BD,$99,$BD,$B9,$FF,$00
           .byte  $FF,$91,$B7,$91,$BD,$B1,$FF,$00
           .byte  $FF,$91,$BD,$9D,$BD,$BD,$FF,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $40,$A0,$E0,$A0,$A0,$00,$00,$00
           .byte  $C0,$A0,$C0,$A0,$C0,$00,$00,$00
           .byte  $60,$80,$80,$80,$60,$00,$00,$00
           .byte  $C0,$A0,$A0,$A0,$C0,$00,$00,$00
           .byte  $E0,$80,$C0,$80,$E0,$00,$00,$00
           .byte  $E0,$80,$C0,$80,$80,$00,$00,$00
           .byte  $60,$80,$80,$A0,$60,$00,$00,$00
           .byte  $A0,$A0,$E0,$A0,$A0,$00,$00,$00
           .byte  $E0,$40,$40,$40,$E0,$00,$00,$00
           .byte  $E0,$40,$40,$40,$80,$00,$00,$00
           .byte  $A0,$A0,$C0,$A0,$A0,$00,$00,$00
           .byte  $80,$80,$80,$80,$E0,$00,$00,$00
           .byte  $A0,$E0,$A0,$A0,$A0,$00,$00,$00
           .byte  $C0,$A0,$A0,$A0,$A0,$00,$00,$00
           .byte  $40,$A0,$A0,$A0,$40,$00,$00,$00
           .byte  $C0,$A0,$C0,$80,$80,$00,$00,$00
           .byte  $40,$A0,$A0,$A0,$60,$00,$00,$00
           .byte  $C0,$A0,$C0,$A0,$A0,$00,$00,$00
           .byte  $E0,$80,$E0,$20,$E0,$00,$00,$00
           .byte  $E0,$40,$40,$40,$40,$00,$00,$00
           .byte  $A0,$A0,$A0,$A0,$E0,$00,$00,$00
           .byte  $A0,$A0,$A0,$A0,$40,$00,$00,$00
           .byte  $A0,$A0,$A0,$E0,$A0,$00,$00,$00
           .byte  $A0,$A0,$40,$A0,$A0,$00,$00,$00
           .byte  $A0,$A0,$40,$40,$40,$00,$00,$00
           .byte  $E0,$20,$40,$80,$E0,$00,$00,$00
           .byte  $00,$00,$00,$40,$40,$80,$00,$00
           .byte  $00,$00,$00,$00,$40,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $30,$48,$84,$FC,$84,$84,$84,$00
           .byte  $F8,$84,$84,$F8,$84,$84,$F8,$00
           .byte  $FC,$80,$80,$80,$80,$80,$FC,$00
           .byte  $F8,$84,$84,$84,$84,$84,$F8,$00
           .byte  $FC,$80,$80,$F8,$80,$80,$FC,$00
           .byte  $FC,$80,$80,$F8,$80,$80,$80,$00
           .byte  $FC,$80,$8C,$84,$84,$84,$FC,$00
           .byte  $84,$84,$84,$FC,$84,$84,$84,$00
           .byte  $70,$20,$20,$20,$20,$20,$70,$00
           .byte  $08,$08,$08,$08,$08,$88,$78,$00
           .byte  $88,$90,$E0,$A0,$90,$88,$88,$00
           .byte  $80,$80,$80,$80,$80,$80,$FC,$00
           .byte  $84,$CC,$B4,$84,$84,$84,$84,$00
           .byte  $84,$C4,$A4,$94,$8C,$84,$84,$00
           .byte  $FC,$84,$84,$84,$84,$84,$FC,$00
           .byte  $FC,$84,$84,$FC,$80,$80,$80,$00
           .byte  $FC,$84,$84,$84,$94,$88,$F4,$00
           .byte  $FC,$84,$84,$FC,$A0,$90,$88,$00
           .byte  $FC,$80,$80,$FC,$04,$04,$FC,$00
           .byte  $7C,$10,$10,$10,$10,$10,$10,$00
           .byte  $84,$84,$84,$84,$84,$84,$FC,$00
           .byte  $44,$44,$44,$44,$28,$28,$10,$00
           .byte  $84,$84,$84,$84,$B4,$CC,$84,$00
           .byte  $44,$44,$28,$10,$28,$44,$44,$00
           .byte  $44,$44,$28,$10,$10,$10,$10,$00
           .byte  $FC,$04,$08,$10,$20,$40,$FC,$00
           .byte  $00,$00,$00,$00,$10,$10,$20,$00
           .byte  $00,$00,$00,$00,$00,$10,$10,$00
           .byte  $00,$00,$00,$01,$03,$07,$0F,$1E
           .byte  $07,$1F,$7F,$F8,$E0,$C1,$07,$1F
           .byte  $FF,$FF,$FF,$00,$00,$FC,$FF,$FF
           .byte  $00,$C0,$F0,$FC,$3E,$1F,$07,$C3
           .byte  $00,$00,$00,$00,$00,$00,$80,$FF
           .byte  $00,$00,$00,$00,$00,$00,$00,$FF
           .byte  $1C,$3C,$38,$71,$71,$E3,$E3,$E7
           .byte  $3E,$78,$F1,$E7,$CF,$9E,$9C,$38
           .byte  $03,$00,$FC,$FF,$FF,$03,$01,$00
           .byte  $E1,$F1,$78,$3C,$9C,$CE,$CE,$E7
           .byte  $FF,$FF,$00,$00,$7F,$7F,$7F,$70
           .byte  $FF,$FF,$00,$00,$E1,$F1,$F9,$3C
           .byte  $FF,$FF,$00,$00,$FF,$FF,$FF,$00
           .byte  $FF,$FF,$00,$00,$03,$0F,$1F,$3E
           .byte  $FF,$FF,$00,$00,$E0,$E0,$E0,$00
           .byte  $FF,$FF,$00,$00,$E0,$E0,$E0,$70
           .byte  $FF,$FF,$00,$00,$1F,$1F,$1F,$00
           .byte  $FF,$FF,$00,$00,$F0,$F8,$FC,$1C
           .byte  $FF,$FF,$00,$00,$1C,$1C,$1C,$0E
           .byte  $FF,$FF,$00,$00,$03,$0F,$1F,$3E
           .byte  $FF,$FF,$00,$00,$DF,$DF,$DF,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$F0
           .byte  $E0,$E0,$00,$00,$80,$00,$00,$00
           .byte  $E7,$E7,$E7,$E7,$E7,$E7,$E3,$E3
           .byte  $38,$38,$38,$38,$38,$38,$9C,$9E
           .byte  $00,$00,$00,$00,$00,$00,$01,$03
           .byte  $E7,$E7,$E7,$E7,$E7,$E7,$CE,$CE
           .byte  $70,$73,$73,$73,$73,$73,$73,$73
           .byte  $1C,$9D,$9D,$9D,$9D,$9D,$9D,$9D
           .byte  $00,$FF,$FF,$FF,$C0,$C0,$FF,$FF
           .byte  $38,$79,$71,$79,$38,$3E,$1F,$0F
           .byte  $00,$E1,$E3,$E3,$03,$27,$E7,$E7
           .byte  $70,$F0,$B8,$B8,$B8,$1C,$FC,$FC
           .byte  $00,$1F,$1F,$1F,$1C,$1C,$1C,$1C
           .byte  $1C,$F8,$F0,$F8,$38,$1C,$1C,$1C
           .byte  $0E,$3E,$77,$77,$77,$E3,$FF,$FF
           .byte  $38,$70,$70,$70,$38,$BE,$9F,$8F
           .byte  $00,$1F,$1F,$1F,$1C,$1C,$DF,$DF
           .byte  $00,$FC,$F8,$F8,$00,$00,$E0,$C0
           .byte  $71,$71,$38,$3C,$1C,$1E,$0F,$07
           .byte  $CF,$E7,$F1,$78,$3E,$1F,$07,$C1
           .byte  $FF,$FF,$FC,$00,$03,$FF,$FF,$FC
           .byte  $9C,$3C,$78,$F1,$E1,$C3,$07,$1F
           .byte  $73,$00,$00,$FF,$FF,$FF,$00,$00
           .byte  $9D,$00,$00,$FF,$FF,$FF,$00,$00
           .byte  $FF,$00,$00,$FF,$FF,$FF,$00,$00
           .byte  $03,$00,$00,$FF,$FF,$FF,$00,$00
           .byte  $CF,$00,$00,$FF,$FF,$FF,$00,$00
           .byte  $FE,$00,$00,$FF,$FF,$FF,$00,$00
           .byte  $1C,$00,$00,$FF,$FF,$FF,$00,$00
           .byte  $1D,$00,$00,$FF,$FF,$FF,$00,$00
           .byte  $C3,$00,$00,$FF,$FF,$FF,$00,$00
           .byte  $DF,$00,$00,$FF,$FE,$FE,$00,$00
           .byte  $C0,$00,$00,$00,$00,$00,$00,$00
           .byte  $03,$01,$00,$00,$00,$00,$00,$00
           .byte  $E0,$F8,$7F,$1F,$07,$00,$00,$00
           .byte  $00,$00,$FF,$FF,$FF,$00,$00,$00
           .byte  $3E,$FC,$F0,$C0,$00,$00,$00,$00
           .byte  $78,$84,$84,$84,$84,$84,$78,$00
           .byte  $10,$30,$10,$10,$10,$10,$38,$00
           .byte  $38,$44,$04,$08,$10,$20,$7C,$00
           .byte  $38,$44,$04,$08,$04,$44,$38,$00
           .byte  $44,$44,$44,$7C,$04,$04,$04,$00
           .byte  $7C,$40,$78,$04,$04,$44,$38,$00
           .byte  $3C,$40,$78,$44,$44,$44,$7C,$00
           .byte  $7C,$04,$08,$10,$20,$40,$40,$00
           .byte  $7C,$44,$44,$7C,$44,$44,$7C,$00
           .byte  $7C,$44,$44,$7C,$04,$04,$04,$00

        ;; splash screen contents
MSG2:      .byte  $09,$3E,$08,$9A,$9B,$9C,$9D,$9E
           .byte  $9F,$9F,$9F,$9F,$9F,$9F,$9F,$9F
           .byte  $9F,$9F,$9F,$AF,$00,$09,$46,$08
           .byte  $A0,$A1,$A2,$A3,$A4,$A5,$A6,$A7
           .byte  $A8,$A9,$AA,$AB,$AC,$AD,$AE,$A6
           .byte  $B0,$00,$09,$4E,$08,$B1,$B2,$B3
           .byte  $B4,$B5,$B6,$B7,$B8,$B9,$BA,$BB
           .byte  $BC,$BD,$BE,$BF,$C0,$00,$09,$56
           .byte  $08,$C1,$C2,$C3,$C4,$C5,$C6,$C7
           .byte  $C8,$C9,$CA,$CB,$CC,$C7,$CD,$CE
           .byte  $CF,$00,$09,$5E,$08,$D0,$D1,$D2
           .byte  $D3,$00,$20,$7E,$04,$2C,$60,$48
           .byte  $50,$4F,$49,$60,$63,$6F,$6D,$6D
           .byte  $6F,$64,$6F,$72,$65,$60,$6C,$74
           .byte  $64,$7C,$00,$20,$8A,$04,$2C,$60
           .byte  $48,$50,$4F,$48,$60,$62,$61,$6C
           .byte  $6C,$79,$60,$6D,$69,$64,$77,$61
           .byte  $79,$FF

        ;; option screen contents
MSG3:      .byte  $18,$08,$08,$5C,$7D,$87,$8C,$96
           .byte  $90,$91,$86,$80,$88,$00,$18,$20
           .byte  $08,$5D,$7D,$8D,$7E,$81,$81,$89
           .byte  $82,$7D,$00,$18,$38,$08,$5E,$7D
           .byte  $90,$80,$8F,$82,$82,$8B,$7D,$80
           .byte  $8C,$89,$8C,$8F,$00,$18,$50,$08
           .byte  $5F,$7D,$90,$85,$86,$8D,$7D,$80
           .byte  $8C,$89,$8C,$8F,$00,$1C,$70,$08
           .byte  $7F,$8C,$8B,$92,$90,$7D,$90,$85
           .byte  $86,$8D,$7D,$7E,$91,$00,$34,$88
           .byte  $08,$D8,$D4,$D4,$D4,$D4,$FF

        ;; intro text ("in the year...")
MSG4:      .byte  $0A,$18,$04,$69,$6E,$60,$74,$68
           .byte  $65,$60,$79,$65,$61,$72,$60,$49
           .byte  $47,$47,$4A,$7B,$60,$74,$68,$65
           .byte  $60,$6F,$6D,$65,$67,$61,$6E,$60
           .byte  $73,$79,$73,$74,$65,$6D,$00,$0C
           .byte  $20,$04,$64,$65,$76,$65,$6C,$6F
           .byte  $70,$65,$64,$60,$61,$60,$6D,$65
           .byte  $74,$68,$6F,$64,$60,$6F,$66,$60
           .byte  $74,$72,$61,$69,$6E,$69,$6E,$67
           .byte  $60,$69,$74,$73,$00,$14,$28,$04
           .byte  $77,$61,$72,$72,$69,$6F,$72,$73
           .byte  $60,$74,$6F,$60,$70,$72,$6F,$74
           .byte  $65,$63,$74,$60,$74,$68,$65,$69
           .byte  $72,$60,$73,$74,$61,$72,$00,$0E
           .byte  $30,$04,$63,$6F,$6C,$6F,$6E,$69
           .byte  $65,$73,$7C,$60,$6F,$76,$65,$72
           .byte  $60,$74,$68,$65,$60,$63,$69,$74
           .byte  $79,$60,$6F,$66,$60,$6B,$6F,$6D
           .byte  $61,$72,$7B,$00,$0E,$38,$04,$61
           .byte  $6E,$64,$72,$6F,$69,$64,$60,$63
           .byte  $6F,$6E,$74,$72,$6F,$6C,$6C,$65
           .byte  $64,$60,$66,$69,$67,$68,$74,$65
           .byte  $72,$73,$60,$72,$61,$63,$65,$64
           .byte  $00,$1A,$40,$04,$74,$6F,$60,$65
           .byte  $6E,$67,$61,$67,$65,$60,$61,$6E
           .byte  $64,$60,$64,$65,$73,$74,$72,$6F
           .byte  $79,$60,$74,$68,$65,$73,$65,$00
           .byte  $30,$48,$04,$6F,$6D,$65,$67,$61
           .byte  $6E,$60,$77,$61,$72,$72,$69,$6F
           .byte  $72,$73,$7C,$00,$04,$70,$04,$70
           .byte  $6F,$69,$6E,$74,$73,$60,$77,$65
           .byte  $72,$65,$60,$61,$77,$61,$72,$64
           .byte  $65,$64,$60,$66,$6F,$72,$60,$74
           .byte  $68,$65,$60,$61,$62,$69,$6C,$69
           .byte  $74,$79,$60,$74,$6F,$00,$02,$78
           .byte  $04,$6E,$65,$75,$74,$72,$61,$6C
           .byte  $69,$7A,$65,$60,$74,$68,$69,$73
           .byte  $60,$64,$72,$6F,$69,$64,$60,$66
           .byte  $6F,$72,$63,$65,$60,$61,$73,$60
           .byte  $66,$6F,$6C,$6C,$6F,$77,$73,$7C
           .byte  $FF

        ;; point values screen (second part of intro text)
MSG5:      .byte  $10,$10,$08,$28,$00,$10,$30,$08
           .byte  $27,$00,$10,$50,$08,$25,$00,$10
           .byte  $70,$08,$23,$00,$10,$90,$08,$20
           .byte  $00,$50,$10,$08,$D7,$D9,$D4,$7D
           .byte  $8D,$8C,$86,$8B,$91,$90,$00,$50
           .byte  $30,$08,$D9,$D4,$D4,$7D,$8D,$8C
           .byte  $86,$8B,$91,$90,$00,$48,$50,$08
           .byte  $D5,$D4,$D4,$D4,$7D,$8D,$8C,$86
           .byte  $8B,$91,$90,$00,$48,$70,$08,$D5
           .byte  $D9,$D4,$D4,$7D,$8D,$8C,$86,$8B
           .byte  $91,$90,$00,$48,$90,$08,$D6,$D9
           .byte  $D4,$D4,$7D,$8D,$8C,$86,$8B,$91
           .byte  $90,$FF

        ;; final part of intro text
MSG6:      .byte  $06,$20,$04,$74,$68,$65,$60,$6F
           .byte  $6D,$65,$67,$61,$6E,$60,$6D,$65
           .byte  $74,$68,$6F,$64,$60,$69,$73,$60
           .byte  $73,$6F,$60,$73,$75,$63,$63,$65
           .byte  $73,$73,$66,$75,$6C,$60,$69,$74
           .byte  $00,$0C,$28,$04,$63,$6F,$6D,$6D
           .byte  $61,$6E,$64,$73,$60,$66,$65,$61
           .byte  $72,$60,$61,$6E,$64,$60,$72,$65
           .byte  $73,$70,$65,$63,$74,$60,$66,$72
           .byte  $6F,$6D,$60,$61,$6C,$6C,$00,$18
           .byte  $30,$04,$74,$68,$72,$6F,$75,$67
           .byte  $68,$6F,$75,$74,$60,$74,$68,$65
           .byte  $60,$67,$61,$6C,$61,$78,$69,$65
           .byte  $73,$7C,$60,$74,$68,$65,$00,$22
           .byte  $38,$04,$6D,$65,$74,$68,$6F,$64
           .byte  $60,$69,$73,$60,$63,$6F,$64,$65
           .byte  $60,$6E,$61,$6D,$65,$64,$7C,$7C
           .byte  $7C,$FF

        ;; ???
MSG7:      .byte  $2D,$30,$08,$84,$7E,$8A,$82,$7D
           .byte  $8C,$93,$82,$8F,$FF

        ;; ???
MSG8:      .byte  $18,$1C,$08,$81,$8F,$8C,$86,$81
           .byte  $7D,$83,$8C,$8F,$80,$82,$00,$28
           .byte  $4C,$08,$82,$89,$86,$8A,$86,$8B
           .byte  $7E,$91,$82,$81,$00,$08,$7C,$08
           .byte  $D9,$99,$D4,$D4,$D4,$7D,$7F,$8C
           .byte  $8B,$92,$90,$7D,$8D,$8C,$86,$8B
           .byte  $91,$90
LBED3:     .byte  $FF,$8C
LBED5:     .byte  $00,$5A
LBED7:     .byte  $00,$AF,$08,$B3,$08,$AF,$08,$A0
           .byte  $08,$00,$FA,$F5,$F0,$EB,$E6,$DC
           .byte  $D7,$C8,$BE,$B4,$AA,$96,$00,$B4
           .byte  $BE,$C8,$CD,$D2,$D7,$DC,$E1,$E6
           .byte  $EB,$F0,$F5,$FA,$FF,$00,$D9,$D4
           .byte  $D9,$DB,$DF,$CF,$01,$D9,$D4,$D9
           .byte  $DB,$DF,$CF,$01,$D9,$D4,$D9,$DB
           .byte  $DF,$CF,$01,$D9,$DB,$D9,$DB,$D4
LBF17:     .byte  $00
LBF18:     .byte  $12,$06,$12,$06,$12,$06,$12,$06
           .byte  $00,$01,$01,$02,$03,$03,$02,$02
           .byte  $02,$02,$02,$01,$01,$00,$01,$01
           .byte  $01,$01,$01,$01,$02,$02,$02,$02
           .byte  $02,$02,$03,$09,$00,$05,$06,$06
           .byte  $08,$21,$14,$05,$06,$06,$06,$08
           .byte  $21,$14,$05,$06,$06,$06,$08,$21
           .byte  $14,$05,$06,$06,$06,$0A,$2D,$00
           .byte  $09,$03,$09,$03,$09,$03,$09,$03
           .byte  $00,$04,$02,$04,$02,$04,$02,$04
LBF68:     .byte  $02,$FF,$FA,$F5,$F0,$EB,$E6,$E1
           .byte  $DC,$D7,$D2,$C8,$BE,$B4,$AF,$AA
           .byte  $00,$EE,$01,$EE,$01,$EE,$01,$EE
           .byte  $01,$EE,$01,$EE,$01,$EE,$01,$EE
           .byte  $00,$BE,$C1,$BE,$01
LBF8D:     .byte  $00,$01,$01,$01,$01,$01,$01,$01
           .byte  $01,$01,$01,$01,$01,$01,$01,$01
           .byte  $00,$03,$03,$03,$03,$03,$03,$03
           .byte  $03,$03,$03,$03,$03,$03,$03,$03
           .byte  $00,$02,$02,$02
LBFB1:     .byte  $04,$B4,$BE,$C3,$C8,$CD,$D2,$D7
           .byte  $DC,$E1,$E6,$00,$CD,$01,$C8,$01
           .byte  $C3,$01,$BE,$01,$B4,$01,$8C,$00
           .byte  $C8
LBFCA:     .byte  $00,$08,$08,$08,$08,$08,$08,$08
           .byte  $07,$07,$07,$00,$0F,$01,$0F,$01
           .byte  $0F,$01,$0F,$01,$0F,$01,$0F,$00
           .byte  $64,$03,$31,$82,$0F,$01,$0F,$01
           .byte  $0F,$00,$64,$AA,$AA,$AA,$AA,$AA
        
           .byte  $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
           .byte  $AA,$AA,$AA,$AA,$AA,$AA
