;;; RESTON MINER 2049er for VIC-20

VIC               := $9000      ; $9000-$900F
VIA1              := $9110      ; $9110-$911F
VIA2              := $9120      ; $9120-$912F
COLORRAM          := $9400
CHARSET           := $1000
SCREEN            := $1E00
CHARROM           := $8000

JOY_REG_RIGHT     := VIA2+$0
JOY_REG_OTHER     := VIA1+$1
JOY_MASK_UP       := $04
JOY_MASK_DOWN     := $08
JOY_MASK_LEFT     := $10
JOY_MASK_RIGHT    := $80
JOY_MASK_BUTTON   := $20

;;; NOTE: This code relies on page boundaries in many
;;;       locations, so data sections (.byte) should 
;;;       not be shifted when making changes
        
           .org $A000

           .word  ENTRY,ENTRY
           .byte  $41,$30,$C3,$C2,$CD ; "a0CBM" 

           .byte  $33,$36,$32,$32,$20,$33,$36
LA010:     lda    #$00
           sta    $52
           lda    #>(COLORRAM+$200)
           sta    $53
           lda    #$DC
           sta    $010C
           jsr    LA680
           rts

LA021:     .byte  $77,$66,$55,$44,$33,$22,$11,$01
           .byte  $44,$43,$43,$20,$44,$44,$24,$24
LA031:     asl    a
           asl    a
           asl    a
           sta    $C0
           jsr    LB3EF
           rts

           .byte  $60,$23
LA03C:     .byte  $02
LA03D:     .byte  $00,$04,$00,$04,$02,$04,$FE,$00
           .byte  $00,$00,$FC,$00,$FE,$FF,$FE,$01
           .byte  $FE,$00,$DA,$00,$DA,$00,$DA,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$04
           .byte  $00,$00,$00
LA060:     lda    #$78
           sta    $55
           sta    $57
           lda    #$00
           sta    $56
           sta    $58
           jsr    LA100
           jsr    LA106
           jsr    LA10C
           jsr    LA112
           rts

           .byte  $53,$45,$51,$20,$20,$05,$9F
LA080:     .byte  $06,$06,$07,$07,$06,$05,$02,$02
           .byte  $02,$11,$11,$11,$09,$09,$09,$09
           .byte  $1A,$09,$09,$09,$09,$09,$09,$09
           .byte  $09,$EA
LA09A:     .byte  $14,$00,$55,$41,$55,$00
           .byte  $00,$14,$14,$00,$55,$41,$55,$00
           .byte  $14,$00,$55,$69,$55,$00,$00,$44
           .byte  $40,$14,$14,$55,$41,$55,$11,$01
           .byte  $14,$14,$55,$41,$55,$EA,$00,$DF
LA0C0:     .word LB080,LB086,LB08C,LB093,LB09A,LB0A0,LB0A5,LB0A5
           .word LB0A5,LB0A7,LB0B8,LB0C9,LB0DA,LB0E3,LB0EC,LB0F5
           .word LB0FE,LB118,LB121,LB12A,LB133,LB13C,LB145,LB14E,LB157        
                
           .byte  $EA
LA0F3:     ldy    #$00
LA0F5:     lda    ($C0),y
           sta    ($96),y
           iny
           cpy    #$08
           bne    LA0F5
           rts

           .byte  $1F
LA100:     lda    $55
           sta    VIC+$C
           rts

LA106:     lda    $56
           sta    VIC+$B
           rts

LA10C:     lda    $57
           sta    VIC+$A
           rts

LA112:     lda    $58
           sta    VIC+$D
           rts

LA118:     lda    VIC+$E
LA11B:     and    #$0F
           ora    $59
           sta    VIC+$E
           rts

           .byte  $AD,$0E,$90,$29,$0F,$05,$5A,$8D
           .byte  $0E,$90,$60,$AD,$0F,$90,$29,$0F
           .byte  $05,$5B,$8D,$0F,$90,$60,$AD,$0F
           .byte  $90,$29,$F8,$05,$5C,$8D,$0F,$90
           .byte  $60,$AD,$0F,$90,$29,$FB,$05,$5D
           .byte  $8D,$0F,$90,$60,$A5,$5E,$8D,$86
           .byte  $02,$60

        ;; VIC: charset at $1000, screen at $1E00, color at $9600
LA155:     lda    #$FC
           sta    VIC+$5
           lda    #$96
           sta    VIC+$2
           rts

           .byte  $A9,$F0,$8D,$05,$90,$60,$A9,$F1
           .byte  $8D,$05,$90,$60
        ;; VIC: 16x8 character size
LA16C:     lda    #$01
           ora    VIC+$3
           sta    VIC+$3
           rts
           .byte  $A9,$FE,$2D,$03,$90,$8D,$03,$90
           .byte  $60,$F5,$F5
        
LA180:     lda    #$FF
           sta    VIA2+$2
           ldy    #$00
           lda    $CB
           sty    VIA2+$2
           rts

LA18D:     lda    #$00
           sta    VIA1+$3
           rts

LA193:     lda    #$00
           sta    $0300
           ldy    #$00
           sty    $010B
           lda    #$9F
           sta    $0301
LA1A2:     jsr    LA200
LA1A5:     lda    #$00
           sta    ($96),y
           lda    #$10
           clc
           adc    $96
           bcc    LA1B2
           inc    $97
LA1B2:     sta    $96
           inc    $010B
           lda    $010B
           cmp    #$17
           bne    LA1A5
           sty    $010B
           inc    $55
           inc    $57
           jsr    LA10C
           jsr    LA100
           lda    #$50
           jsr    LA1E0
           dec    $0301
           lda    $0301
           cmp    #$FF
           bne    LA1A2
           rts

           .byte  $75,$F7,$FD,$F9,$D5
LA1E0:     sec
LA1E1:     pha
LA1E2:     sbc    #$01
           bne    LA1E2
           pla
           sbc    #$01
           bne    LA1E1
           rts

LA1EC:     ldy    #$00
           lda    ($BE),y
           sta    $0300
           inc    $BE
           lda    ($BE),y
           sta    $0301
           inc    $BE
           jsr    LA200
           rts

LA200:     stx    $0302
           lda    $0301
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           asl    a
           tax
           lda    LBA00,x
           sta    $96
           lda    LBA00+1,x
           sta    $97
           lda    $0301
           and    #$0F
           clc
           adc    $96
           sta    $96
           lda    $0300
           lsr    a
           lsr    a
           asl    a
           tax
           lda    $96
           clc
           adc    LBA14,x
           sta    $96
           lda    $97
           adc    LBA14+1,x
           sta    $97
           lda    $0300
           and    #$03
           sta    $0308
           ldx    $0302
           rts

LA242:     lda    $71
           cmp    #$9D
           beq    LA278
           lda    $4E
           and    #$18
           beq    LA278
           cmp    #$08
           bne    LA25D
           lda    $0110
           and    #$30
           cmp    #$30
           beq    LA266
           bne    LA26A
LA25D:     lda    $0110
           and    #$0C
           cmp    #$0C
           bne    LA26A
LA266:     dec    $71
           bne    LA275
LA26A:     inc    $71
           jsr    LABA8
           lda    $73
           beq    LA275
           dec    $71
LA275:     jsr    LB7BA
LA278:     rts

           .byte  $97,$60,$F5,$F5,$F5,$F5,$F5
LA280:     lda    #$00
           sta    $0101
LA285:     lda    #$00
           sta    $0105
           sta    $0106
           lda    $0100
           bne    LA2AC
           ldy    #$00
           lda    ($60),y
           ldy    $0101
           sta    ($64),y
           lda    ($62),y
           ldy    #$00
           sta    ($60),y
           lda    $60
           clc
           adc    #$10
           bcc    LA2AA
           inc    $61
LA2AA:     sta    $60
LA2AC:     lda    $0100
           cmp    #$01
           bne    LA2FC
           ldy    $0101
           lda    ($62),y
           clc
           ror    a
           ror    $0106
           clc
           ror    a
           ror    $0106
           sta    $0105
           ldy    #$00
           lda    ($60),y
           sta    $0107
           and    #$C0
           ora    $0105
           sta    ($60),y
           clc
           lda    $60
           adc    #$10
           bcc    LA2DC
           inc    $61
LA2DC:     sta    $60
           lda    ($60),y
           sta    $0108
           and    #$3F
           ora    $0106
           sta    ($60),y
           clc
           lda    $0107
           rol    $0108
           rol    a
           clc
           rol    $0108
           rol    a
           ldy    $0101
           sta    ($64),y
LA2FC:     lda    $0100
           cmp    #$02
           bne    LA360
           ldy    $0101
           lda    ($62),y
           clc
           ror    a
           ror    $0106
           clc
           ror    a
           ror    $0106
           clc
           ror    a
           ror    $0106
           clc
           ror    a
           ror    $0106
           sta    $0105
           ldy    #$00
           lda    ($60),y
           sta    $0107
           and    #$F0
           ora    $0105
           sta    ($60),y
           clc
           lda    $60
           adc    #$10
           bcc    LA336
           inc    $61
LA336:     sta    $60
           lda    ($60),y
           sta    $0108
           and    #$0F
           ora    $0106
           sta    ($60),y
           lda    $0107
           clc
           rol    $0108
           rol    a
           clc
           rol    $0108
           rol    a
           clc
           rol    $0108
           rol    a
           clc
           rol    $0108
           rol    a
           ldy    $0101
           sta    ($64),y
LA360:     lda    $0100
           cmp    #$03
           bne    LA3B0
           ldy    $0101
           lda    ($62),y
           clc
           rol    a
           rol    $0105
           clc
           rol    a
           rol    $0105
           sta    $0106
           ldy    #$00
           lda    ($60),y
           sta    $0107
           and    #$FC
           ora    $0105
           sta    ($60),y
           clc
           lda    $60
           adc    #$10
           bcc    LA390
           inc    $61
LA390:     sta    $60
           lda    ($60),y
           sta    $0108
           and    #$03
           ora    $0106
           sta    ($60),y
           lda    $0108
           clc
           ror    $0107
           ror    a
           clc
           ror    $0107
           ror    a
           ldy    $0101
           sta    ($64),y
LA3B0:     inc    $0101
           lda    $0101
           cmp    $66
           beq    LA3DE
           lda    $60
           and    #$0F
           beq    LA3CF
           sec
           lda    $60
           sbc    #$11
           bcs    LA3C9
           dec    $61
LA3C9:     sta    $60
           jmp    ($0102)

           sec
LA3CF:     lda    $60
           sbc    #$60
           bcs    LA3D7
           dec    $61
LA3D7:     sta    $60
           dec    $61
           jmp    ($0102)

LA3DE:     rts

           .byte  $35
LA3E0:     lda    #$00
           sta    $40
           sta    $41
           sta    $42
           sta    $43
           sta    $44
           lda    JOY_REG_OTHER
           and    #JOY_MASK_UP
           bne    LA3F5
           inc    $40
LA3F5:     lda    JOY_REG_OTHER
           and    #JOY_MASK_LEFT
           bne    LA3FE
           inc    $43
LA3FE:     lda    JOY_REG_OTHER
           and    #JOY_MASK_DOWN
           bne    LA407
           inc    $42
LA407:     lda    JOY_REG_OTHER
           and    #JOY_MASK_BUTTON
           bne    LA410
           inc    $44
LA410:     lda    JOY_REG_RIGHT
           and    #JOY_MASK_RIGHT
           bne    LA419
           inc    $41
LA419:     rts

LA41A:     lda    $70
           sta    $0309
           lda    $71
           sta    $030A
           lda    $A7
           sta    $70
           lda    $A8
           sta    $71
           jsr    LAC88
           lda    $A9
           beq    LA434
           rts

LA434:     lda    $0309
           sta    $70
           lda    $030A
           sta    $71
           jsr    LAC88
           rts

LA442:     lda    #$07
           sta    $66
           lda    #$30
           sta    $0255
           lda    #$02
           sta    $0256
           rts

           .byte  $AB,$18,$69,$0D,$85,$9F,$A5,$71
           .byte  $C5,$9F,$90,$01,$60,$A9,$01,$85
           .byte  $A9,$60

LA463:     .byte  $81,$09,$3C,$4F,$62,$82
           .byte  $09,$17,$4F,$26,$FF,$FF,$30
LA470:     jsr    LA442
           lda    $3E
           sta    $75
           ldx    #$00
LA479:     lda    #$60
           sta    $64
           lda    #$02
           sta    $65
           lda    $031F,x
           cmp    #$FF
           beq    LA4B0
           sta    $0300
           lda    $0324,x
           sta    $0301
           jsr    LA200
           jsr    LBF78
           lda    $0255
           sta    $62
           lda    $0256
           sta    $63
           jsr    LA280
           lda    $0334,x
           beq    LA4B4
           lda    #$FF
           sta    $031F,x
           lda    #$00
LA4B0:     beq    LA51F
LA4B2:     bne    LA479
LA4B4:     lda    $0329,x
           and    #$01
           bne    LA4C0
           inc    $031F,x
           bne    LA4C3
LA4C0:     dec    $031F,x
LA4C3:     inc    $032E,x
           lda    $031F,x
           sta    $AA
           lda    $0324,x
           sta    $AB
           jsr    LA41A
           lda    $A9
           beq    LA4F1
           lda    $C2
           clc
           adc    #$04
           sta    $C2
           jsr    LBBED
           lda    $A4
           bne    LA4E7
           inc    $A6
LA4E7:     lda    #$FF
           sta    $031F,x
           sta    $0334,x
           bne    LA56B
LA4F1:     lda    $032E,x
           cmp    $031A,x
           bne    LA501
           inc    $0329,x
           lda    #$00
           sta    $032E,x
LA501:     lda    $0255
           sta    $64
           lda    $0256
           sta    $65
           lda    $031F,x
           sta    $0300
           lda    $0324,x
           sta    $0301
           jsr    LA200
           jsr    LBF78
           bpl    LA523
LA51F:     beq    LA56B
LA521:     bne    LA4B2
LA523:     lda    $0258
           sta    $63
           lda    $0257
           sta    $62
           lda    $A4
           bne    LA54A
           lda    $031F,x
           and    #$01
           bne    LA541
           lda    $62
           clc
           adc    #$15
           sta    $62
           bne    LA568
LA541:     lda    $62
           clc
           adc    #$1C
           sta    $62
           bne    LA568
LA54A:     lda    $A3
           bne    LA557
           lda    $62
           clc
           adc    #$0E
           sta    $62
           bne    LA568
LA557:     lda    $031F,x
           and    #$01
           beq    LA567
           lda    $62
           clc
           adc    #$07
           sta    $62
           bne    LA568
LA567:     nop
LA568:     jsr    LA280
LA56B:     clc
           lda    $0255
           adc    #$07
           sta    $0255
           inx
           cpx    #$05
           beq    LA57B
           bne    LA521
LA57B:     nop
           lda    $75
           sta    $3E
           rts

           .byte  $55,$02,$E8,$E0,$05,$F0,$02,$D0
           .byte  $82,$A5,$9F,$8D,$55,$02,$60
LA590:     lda    $40
           ora    $41
           ora    $42
           ora    $43
           ora    $44
           bne    LA59F
           sta    $4E
           rts

LA59F:     lda    $4C
           and    $4D
           bne    LA5EB
           lda    $44
           beq    LA5EB
           lda    $41
           bne    LA5CC
           lda    $43
           bne    LA5DA
           lda    $45
           bne    LA5BF
           lda    $46
           sta    $4A
           lda    #$01
           sta    $4E
           bne    LA60A
LA5BF:     lda    $46
           clc
           adc    #$0D
           sta    $4A
           lda    #$01
           sta    $4E
           bne    LA60A
LA5CC:     lda    $46
           sta    $4A
           lda    #$00
           sta    $45
           lda    #$04
           sta    $4E
           bne    LA60A
LA5DA:     lda    $46
           clc
           adc    #$0D
           sta    $4A
           lda    #$01
           sta    $45
           lda    #$02
           sta    $4E
           bne    LA60A
LA5EB:     lda    $40
           ora    $42
           beq    LA625
           lda    $40
           beq    LA615
           lda    $4C
           beq    LA625
           lda    #$20
           sta    $4E
LA5FD:     lda    $71
           and    #$01
           bne    LA60C
LA603:     lda    $46
           clc
           adc    #$1A
           sta    $4A
LA60A:     bne    LA67D
LA60C:     lda    $46
           clc
           adc    #$27
           sta    $4A
           bne    LA67D
LA615:     lda    $4D
           beq    LA625
           lda    #$40
           sta    $4E
           lda    $71
           and    #$01
           bne    LA60C
           beq    LA603
LA625:     lda    $4C
           and    $4D
           beq    LA631
           lda    #$00
           sta    $4E
           beq    LA67D
LA631:     lda    $41
           beq    LA655
           lda    #$10
           sta    $4E
           lda    #$00
           sta    $45
           lda    $70
           and    #$01
           bne    LA64C
           lda    $46
           clc
           adc    #$41
           sta    $4A
           bne    LA67D
LA64C:     lda    $46
           clc
           adc    #$34
           sta    $4A
           bne    LA67D
LA655:     lda    $43
           bne    LA65F
           lda    #$00
           sta    $4E
           beq    LA67D
LA65F:     lda    #$08
           sta    $4E
           lda    #$01
           sta    $45
           lda    $70
           and    #$01
           bne    LA676
           lda    $46
           clc
LA670:     adc    #$5B
           sta    $4A
           bne    LA67D
LA676:     lda    $46
           clc
           adc    #$4E
           sta    $4A
LA67D:     rts

           .byte  $33
           .byte  $FD
        
        ;; write content of $54 to ($52) through ($52)+$010C
        ;; reset $52 and $53 to original state afterwards
LA680:     lda    $52
           sta    $0109
           lda    $53
           sta    $010A
           ldy    #$00
           sty    $010B
LA68F:     lda    $54
           sta    ($52),y
           inc    $010B
           lda    $010B
           cmp    $010C
           beq    LA6A6
           inc    $52
           bne    LA68F
           inc    $53
           bne    LA68F
LA6A6:     lda    $0109
           sta    $52
           lda    $010A
           sta    $53
           rts

           .byte  $FD
LA6B2:     ldx    #$00
LA6B4:     ldy    #$9F
           sty    $0301
           stx    $0300
           jsr    LA200
           ldy    #$00
           lda    #$FF
           sta    ($96),y
           ldy    #$9E
           sty    $0301
           jsr    LA200
           ldy    #$00
           lda    #$FF
           sta    ($96),y
           inx
           inx
           inx
           inx
           cpx    #$58
           beq    LA6DD
           bne    LA6B4
LA6DD:     rts

           .byte  $FD
           .byte  $FD

        ;; write 0,1,2,..,$010C to ($50)+
LA6E0:     lda    $50
           sta    $0109
           lda    $51
           sta    $010A
           ldy    #$00
           sty    $010B
           lda    $010B
LA6F2:     sta    ($50),y
           inc    $010B
           lda    $010B
           cmp    $010C
           beq    LA711
           inc    $50
           bne    LA6F2
           inc    $51
           bne    LA6F2
           lda    $0109
           sta    $50
           lda    $010A
           sta    $51
LA711:     rts

           sbc    $FDFD,x
           sbc    $FDFD,x
LA718:     and    #$7F
           sta    $0300
           inc    $00
           bne    LA723
           inc    $01
LA723:     lda    ($00),y
           sta    $0301
           inc    $00
           bne    LA72E
           inc    $01
LA72E:     lda    ($00),y
           and    #$1F
           tax
           lda    ($00),y
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           clc
           adc    #$01
           rol    a
           sta    $039D
           inc    $00
           bne    LA747
           inc    $01
LA747:     lda    LA080,x
           sta    $66
           txa
           clc
           rol    a
           tax
           lda    $02,x
           sta    $62
           lda    $03,x
           sta    $63
LA758:     jsr    LA200
           lda    $96
           sta    $60
           lda    $97
           sta    $61
           lda    $0308
           sta    $0100
           jsr    LA280
           dec    $039D
           beq    LA787
           lda    $0301
           clc
           adc    LA03D,x
           sta    $0301
           lda    $0300
           clc
           adc    LA03C,x
           sta    $0300
           bne    LA758
LA787:     rts

           .byte  $04,$FE,$11,$F7,$9E,$59,$89,$F8
LA790:     lda    #$60
           sta    $64
           lda    #$02
           sta    $65
LA798:     ldy    #$00
           lda    ($00),y
           bpl    LA7A7
           cmp    #$FF
           beq    LA7ED
           jsr    LA718
           beq    LA798
LA7A7:     inc    $00
           bne    LA7AD
           inc    $01
LA7AD:     sta    $0300
           lda    ($00),y
           sta    $0301
           jsr    LA200
           inc    $00
           bne    LA7BE
           inc    $01
LA7BE:     lda    ($00),y
           tax
           lda    LA080,x
           sta    $66
           inc    $00
           bne    LA7CC
           inc    $01
LA7CC:     lda    $96
           sta    $60
           lda    $97
           sta    $61
           txa
           clc
           rol    a
           tax
           lda    $02,x
           sta    $62
           lda    $03,x
           sta    $63
           lda    $0308
           sta    $0100
           jsr    LA280
           lda    #$01
           bne    LA798
LA7ED:     rts

           .byte  $D0,$A8
LA7F0:     ldx    #$00
           lda    #$04
           sta    $0300
           lda    #$07
           sta    $0301
           jsr    LA200
LA7FF:     cpx    #$03
           beq    LA861
           lda    $02A1,x
           bne    LA80B
           inx
           bne    LA7FF
LA80B:     and    #$F0
           beq    LA835
LA80F:     lda    #$05
           sta    $010B
           lda    $02A1,x
           and    #$F0
           clc
           ror    a
           tay
LA81C:     lda    ($9D),y
           sty    $9F
           ldy    #$00
           sta    ($96),y
           dec    $96
           ldy    $9F
           iny
           dec    $010B
           bne    LA81C
           lda    #$15
           clc
           adc    $96
           sta    $96
LA835:     lda    #$05
           sta    $010B
           lda    $02A1,x
           and    #$0F
           asl    a
           asl    a
           asl    a
           tay
LA843:     lda    ($9D),y
           sty    $9F
           ldy    #$00
           sta    ($96),y
           dec    $96
           ldy    $9F
           iny
           dec    $010B
           bne    LA843
           lda    #$15
           clc
           adc    $96
           sta    $96
           inx
           cpx    #$03
           bne    LA80F
LA861:     ldx    #$00
           lda    #$40
           sta    $0300
           jsr    LA200
LA86B:     cpx    #$03
           beq    LA8CD
           lda    $02A5,x
           bne    LA877
           inx
           bne    LA86B
LA877:     and    #$F0
           beq    LA8A1
LA87B:     lda    #$05
           sta    $010B
           lda    $02A5,x
           and    #$F0
           clc
           ror    a
           tay
LA888:     lda    ($9D),y
           sty    $9F
           ldy    #$00
           sta    ($96),y
           dec    $96
           ldy    $9F
           iny
           dec    $010B
           bne    LA888
           lda    #$15
           clc
           adc    $96
           sta    $96
LA8A1:     lda    #$05
           sta    $010B
           lda    $02A5,x
           and    #$0F
           asl    a
           asl    a
           asl    a
           tay
LA8AF:     lda    ($9D),y
           sty    $9F
           ldy    #$00
           sta    ($96),y
           dec    $96
           ldy    $9F
           iny
           dec    $010B
           bne    LA8AF
           lda    #$15
           clc
           adc    $96
           sta    $96
           inx
           cpx    #$03
           bne    LA87B
LA8CD:     rts

           .byte  $F5,$F5
LA8D0:     lda    $70
           cmp    #$FF
           bne    LA8DA
           lda    #$00
           sta    $70
LA8DA:     cmp    #$55
           bne    LA8E2
           lda    #$54
           sta    $70
LA8E2:     lda    $71
           cmp    #$9E
           bcc    LA8EC
           lda    #$01
           sta    $A6
LA8EC:     cmp    #$09
           bne    LA8F4
           lda    #$0A
           sta    $71
LA8F4:     rts

           .byte  $A0,$00,$B1
LA8F8:     ldy    #$00
LA8FA:     lda    ($68),y
           cmp    #$FF
           beq    LA91A
           cmp    #$80
           bcc    LA909
           and    #$7F
           sta    $72
           iny
LA909:     lda    ($68),y
           iny
           cmp    $70
           bne    LA917
           lda    ($68),y
           cmp    $71
           bne    LA917
           rts

LA917:     iny
           bne    LA8FA
LA91A:     lda    #$00
           sta    $72
           rts

           .byte  $F5
LA920:     sed
           ldx    #$03
           lda    $9C
           bne    LA935
           clc
LA928:     lda    $02A0,x
           adc    $98,x
           sta    $02A0,x
           dex
           bne    LA928
           beq    LA941
LA935:     clc
LA936:     lda    $02A4,x
           adc    $98,x
           sta    $02A4,x
           dex
           bne    LA936
LA941:     cld
           lda    #$00
           sta    $99
           sta    $9A
           sta    $9B
           rts

LA94B:     lda    #<LBD00
           sta    $9D
           lda    #>LBD00
           sta    $9E
           ldy    #$00
           sty    $A6
           lda    #$23
           sta    $0300
           lda    #$07
           sta    $0301
LA961:     jsr    LA200
           lda    #$03
           sta    ($96),y
           dec    $0301
           bne    LA961
           lda    #$01
           sta    $02A4
           ldx    $3E
           lda    LBEF5,x
           sta    $02A0
           rts

LA97B:     dec    $02A4
           beq    LA981
           rts

LA981:     lda    #$07
           sta    $010B
           lda    #$24
           sta    $0300
           lda    #$07
           sta    $0301
           jsr    LA200
           lda    $02A0
           sed
           sec
           sbc    #$01
           sta    $02A0
           cld
           bne    LA9A2
           inc    $A6
LA9A2:     lda    $02A0
           and    #$F0
           beq    LA9CD
           clc
           ror    a
           tay
           dey
LA9AD:     lda    ($9D),y
           iny
           sty    $9F
           ldy    #$00
           eor    #$FF
           sta    ($96),y
           dec    $96
           ldy    $9F
           dec    $010B
           bne    LA9AD
           lda    #$07
           sta    $010B
           lda    #$17
           clc
           adc    $96
           sta    $96
LA9CD:     lda    $02A0
           and    #$0F
           asl    a
           asl    a
           asl    a
           tay
           dey
LA9D7:     lda    ($9D),y
           iny
           sty    $9F
           ldy    #$00
           eor    #$FF
           sta    ($96),y
           ldy    $9F
           dec    $96
           dec    $010B
           bne    LA9D7
           lda    #$07
           sta    $010B
           lda    $96
           clc
           adc    #$17
           sta    $96
           ldy    #$FF
LA9F9:     lda    ($9D),y
           iny
           sty    $9F
           eor    #$FF
           ldy    #$00
           sta    ($96),y
           ldy    #$10
           sta    ($96),y
           lda    #$00
           ldy    #$20
           sta    ($96),y
           ldy    $9F
           dec    $96
           dec    $010B
           bne    LA9F9
           rts

LAA18:     inc    $02A0
LAA1B:     lda    $A6
           ora    $B1
           bne    LAA4D
           lda    #$01
           sta    $9A
           jsr    LA920
           lda    #$01
           sta    $02A4
           lda    #$F0
           sta    $56
           jsr    LA106
           jsr    LA97B
           jsr    LA7F0
           lda    #$00
           sta    $56
           lda    #$80
           jsr    LA1E0
           jsr    LA106
           lda    #$80
           jsr    LA1E0
           beq    LAA1B
LAA4D:     rts

ENTRY:     sei
           jsr    LAE61
           jsr    LBA50
           jmp    LBFF8

LAA58:     lda    #$62
           sta    $0259
           lda    #$06
           sta    $66
           lda    #$B1
           sta    $63
           lda    #$60
           sta    $64
           lda    #$02
           sta    $65
           ldx    #$00
LAA6F:     lda    $039E,x
           beq    LAA89
           lda    $03AA,x
           and    #$01
           bne    LAA81
           inc    $039E,x
           clc
           bcc    LAA84
LAA81:     dec    $039E,x
LAA84:     inc    $03A7,x
           bne    LAA8D
LAA89:     beq    LAAE5
LAA8B:     bne    LAA6F
LAA8D:     lda    $03A7,x
           cmp    $03A4,x
           bne    LAABA
           inc    $03AA,x
           lda    #$00
           sta    $03A7,x
           lda    $039E,x
           sta    $0300
           lda    $03A1,x
           sta    $0301
           jsr    LA200
           jsr    LBF78
           lda    $0259
           clc
           adc    #$0C
           sta    $62
           jsr    LA280
LAABA:     lda    $039E,x
           sta    $0300
           lda    $03A1,x
           sta    $0301
           jsr    LA200
           jsr    LBF78
           lda    $03AA,x
           and    #$01
           bne    LAADD
           lda    $0259
           clc
           adc    #$06
           sta    $62
           bne    LAAE2
LAADD:     lda    $0259
           sta    $62
LAAE2:     jsr    LA280
LAAE5:     inx
           cpx    #$03
           bne    LAA8B
           rts

LAAEB:     lda    #$03
           sta    $BB
           lda    $B8
           bne    LAB09
           lda    $4E
           and    #$07
           bne    LAAFA
           rts

LAAFA:     sta    $B8
           lda    #$00
           sta    $72
           sta    $B2
           lda    #$F8
           sta    $56
           jsr    LA106
LAB09:     lda    #$00
           sta    $40
           sta    $41
           sta    $42
           sta    $43
           sta    $44
           lda    $B9
           bne    LAB3D
LAB19:     dec    $71
           inc    $B2
           lda    $BA
           cmp    $B2
           bcc    LAB29
           dec    $BB
           bne    LAB19
           beq    LAB53
LAB29:     lda    #$00
           sta    $B2
           sta    $56
           jsr    LA106
           lda    #$F0
           sta    $57
           jsr    LA10C
           sta    $B9
           bne    LAB53
LAB3D:     inc    $71
           inc    $B2
           jsr    LBE2C
           lda    $AC
           bne    LAB74
           jsr    LABA8
           lda    $73
           beq    LAB74
           dec    $BB
           bne    LAB3D
LAB53:     lda    $B8
           cmp    #$02
           bne    LAB5B
           dec    $70
LAB5B:     cmp    #$04
           bne    LAB61
           inc    $70
LAB61:     lda    $B9
           beq    LAB73
           jsr    LBE2C
           lda    $AC
           bne    LAB74
           jsr    LABA8
           lda    $73
           beq    LAB74
LAB73:     rts

LAB74:     lda    #$7E
           sta    $57
           jsr    LA10C
           lda    #$00
           sta    $B9
           sta    $B8
           lda    $B0
           cmp    $B2
           bcs    LAB8B
           lda    #$01
           sta    $B1
LAB8B:     lda    #$00
           sta    $B2
           rts

LAB90:     lda    #$00
           sta    $9C
           lda    $98
           cmp    #$01
           bne    LAB9E
           lda    #$00
           sta    $BD
LAB9E:     rts

           .byte  $22,$60,$F5,$F5,$F5,$F5,$F5,$F5
           .byte  $F5
LABA8:     txa
           pha
           ldy    #$00
           lda    $71
           sta    $0301
           inc    $0301
           lda    #$02
           sta    $73
           sta    $74
           lda    $70
           sta    $0300
LABBF:     inc    $0300
           jsr    LA200
           lda    $0308
           tax
           lda    ($96),y
           and    $B3,x
           cmp    $B3,x
           beq    LABD7
           dec    $74
           bne    LABBF
           beq    LAC0E
LABD7:     lda    #$02
           sta    $74
           lda    $71
           cmp    #$9D
           beq    LAC0A
           clc
           adc    #$06
           sta    $0301
           lda    $70
           sta    $0300
LABEC:     inc    $0300
           jsr    LA200
           lda    $0308
           tax
           lda    ($96),y
           and    $B3,x
           sta    $9F
           lda    $B3,x
           and    #$55
           cmp    $9F
           beq    LAC0A
           dec    $74
           bne    LABEC
           beq    LAC0E
LAC0A:     lda    #$00
           sta    $73
LAC0E:     pla
           tax
           rts

LAC11:     lda    $71
           cmp    #$66
           bcs    LAC24
LAC17:     lda    VIC+$4
           cmp    #$46
           bcc    LAC17
           cmp    #$50
           bcs    LAC17
           bcc    LAC2B
LAC24:     lda    VIC+$4
           cmp    #$75
           bcc    LAC24
LAC2B:     jsr    LA280
           rts

           .byte  $FD
LAC30:     ldy    #$00
           sty    $0101
           lda    $70
           sta    $0300
           inc    $0300
           lda    $71
           clc
           adc    #$05
           sta    $0301
           jsr    LA200
LAC48:     lda    $0308
           bne    LAC55
           lda    ($96),y
           ora    #$F0
           sta    ($96),y
           bne    LAC5B
LAC55:     lda    ($96),y
           ora    #$0F
           sta    ($96),y
LAC5B:     inc    $0101
           lda    $0101
           cmp    #$04
           beq    LAC7F
           lda    $96
           and    #$0F
           bne    LAC7A
           lda    $96
           sec
           sbc    #$51
           bcs    LAC74
           dec    $97
LAC74:     dec    $97
           sta    $96
           bne    LAC48
LAC7A:     dec    $96
           clc
           bcc    LAC48
LAC7F:     lda    #$05
           sta    $9B
           dec    $B7
           rts

           .byte  $FD,$FD
LAC88:     lda    #$00
           sta    $A9
           lda    $AA
           sec
           sbc    #$03
           bpl    LAC95
           lda    #$00
LAC95:     sta    $9F
           lda    $70
           cmp    $9F
           bcs    LAC9E
           rts

LAC9E:     lda    $AA
           clc
           adc    #$04
           sta    $9F
           lda    $70
           cmp    $9F
           bcc    LACAC
           rts

LACAC:     lda    $AB
           sec
           sbc    #$06
           bcs    LACB5
           lda    #$00
LACB5:     sta    $9F
           lda    $71
           cmp    $9F
           bcs    LACBE
           rts

LACBE:     lda    $AB
           clc
           adc    #$0D
           sta    $9F
           lda    $71
           cmp    $9F
           bcc    LACCC
           rts

LACCC:     lda    #$01
           sta    $A9
           rts

LACD1:     lda    $A6
           ora    $B1
           bne    LACDC
           lda    $9C
           tax
           inc    $F0,x
LACDC:     jsr    LBAE8
           lda    $9C
           tax
           lda    $F0,x
           and    #$07
           bne    LACEC
           lda    #$01
           inc    $F0,x
LACEC:     sta    $3E
           rts

           .byte  $43
LACF0:     lda    $9C
           tax
           lda    $F0,x
           and    #$3F
           lsr    a
           lsr    a
           lsr    a
           tax
           lda    LA021,x
           sta    $C2
           rts

           .byte  $0A,$D0,$02,$A9,$FE,$49,$FF,$85
           .byte  $C2,$60,$90,$60,$00,$00,$00
LAD10:     lda    #$30
           sta    $0255
           lda    #$02
           lda    #$56
           lda    $3E
           clc
           adc    #$FF
           asl    a
           tax
           lda    LBF6A,x
           sta    $3C
           lda    LBF6A+1,x
           sta    $3D
           ldy    #$00
LAD2C:     lda    ($3C),y
           sta    $031A,y
           iny
           cpy    #$0F
           bne    LAD2C
           lda    #$00
           tay
LAD39:     sta    $0329,y
           iny
           cpy    #$10
           bne    LAD39
           tay
LAD42:     sta    $0230,y
           iny
           cpy    #$25
           bne    LAD42
           rts

LAD4B:     lda    #$0D
           sta    $66
LAD4F:     lda    $4A
           sta    $62
           lda    $4B
           sta    $63
           lda    #$10
           sta    $64
           lda    #$01
           sta    $65
           lda    $70
           sta    $0300
           sta    $A7
           lda    $71
           sta    $0301
           sta    $A8
           jsr    LA200
           jsr    LBF78
           jsr    LA280
           rts

LAD77:     jsr    LA6B2
           jsr    LAE99
           lda    $9C
           tax
           lda    $BC,x
           sta    $BB
           lda    #$22
           sta    $70
           lda    #$56
           sta    $71
LAD8C:     jsr    LAD4B
           dec    $BB
           beq    LAD9C
           lda    $70
           clc
           adc    #$08
           sta    $70
           bne    LAD8C
LAD9C:     lda    #$FE
           sta    $57
LADA0:     inc    $71
           jsr    LBA42
           jsr    LB4C9
           jsr    LAD4B
           lda    #$60
           jsr    LA1E0
           lda    #$9D
           cmp    $71
           bne    LADA0
           jsr    LA060
           jsr    LBE0E
LADBC:     jsr    LA1E0
           lda    #$FE
           sta    $58
           jsr    LBBCD
           jsr    LB4C9
           jsr    LAD4B
           lda    #$00
           sta    $40
           sta    $41
           sta    $42
           sta    $43
           sta    $44
           lda    $3E
           tax
           lda    $70
           cmp    LAFAA,x
           beq    LADFB
           bcs    LADEA
           lda    #$01
           sta    $41
           bne    LADEE
LADEA:     lda    #$01
           sta    $43
LADEE:     jsr    LA590
           jsr    LBD90
           jsr    LA060
           lda    #$80
           bne    LADBC
LADFB:     jsr    LA060
           rts

           .byte  $FD
LAE00:     lda    #$09
           sta    COLORRAM+$24C
           ldx    #$00
LAE07:     lda    $02A1,x
           cmp    $02C6,x
           bcc    LAE1D
           beq    LAE13
           bcs    LAE18
LAE13:     inx
           cpx    #$03
           bne    LAE07
LAE18:     ldy    #$00
           jsr    LAE6E
LAE1D:     ldx    #$00
LAE1F:     lda    $02A5,x
           cmp    $02C6,x
           bcc    LAE35
           beq    LAE2B
           bcs    LAE30
LAE2B:     inx
           cpx    #$03
           bne    LAE1F
LAE30:     ldy    #$04
           jsr    LAE6E
LAE35:     lda    #$02
           sta    $BF
           lda    #$C9
           sta    $BE
           lda    #$FE
           sta    $02C9
           lda    #$3C
           sta    $02CA
           lda    #$07
           sta    $02CB
           lda    #$FF
           sta    $02D2
           jsr    LAECD
           rts

           .byte  $01,$01,$F1,$A5,$B3,$C9,$C0,$F0
           .byte  $0E,$20,$50,$BA
LAE61:     lda    #$00
           sta    $02C6
           sta    $02C7
           sta    $02C8
           rts

           .byte  $C0
LAE6E:     ldx    #$00
LAE70:     lda    $02A1,y
           jsr    LB1F3
           and    #$F0
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           ora    #$30
           sta    $02CC,x
           lda    $02A1,y
           and    #$0F
           ora    #$30
           sta    $02CD,x
           inx
           inx
           iny
           cpx    #$06
           bne    LAE70
           rts

           .byte  $71,$7E,$76,$BE,$1E,$00
LAE99:     ldy    #$00
           ldx    #$00
           lda    $9C
           and    #$01
           beq    LAEA5
           ldx    #$09
LAEA5:     lda    #$3F
           sta    $0301
           lda    #$28
           sta    $0300
           jsr    LA200
LAEB2:     lda    LB0DA,x
           sta    ($96),y
           inx
           dec    $96
           cpx    #$09
           beq    LAEC4
           cpx    #$12
           beq    LAEC4
           bne    LAEB2
LAEC4:     rts

LAEC5:     lda    #>LAF00
           sta    $BF
           lda    #<LAF00
           sta    $BE
LAECD:     ldy    #$00
           lda    ($BE),y
           cmp    #$FE
           bne    LAEDC
           inc    $BE
           jsr    LA1EC
           lda    ($BE),y
LAEDC:     jsr    LA031
           jsr    LA0F3
           lda    #$04
           clc
           adc    $0300
           sta    $0300
           jsr    LA200
           inc    $BE
           ldy    #$00
           lda    ($BE),y
           cmp    #$FF
           bne    LAECD
           inc    $A2
           rts

           .byte  $41,$D0,$C7,$60,$1E
        
LAF00:     .byte  $FE,$04,$07
           .byte  $08,$09,$07,$08,$20,$13,$03,$0F
           .byte  $12,$05,$FE,$14,$67,$0D,$09,$0E
           .byte  $05,$12,$20,$32,$30,$34,$39,$05
           .byte  $12,$FE,$00,$20,$03,$0F,$0E,$03
           .byte  $05,$10,$14,$FE,$00,$30,$02,$19
           .byte  $FE,$00,$40,$02,$09,$0C,$0C,$FE
           .byte  $00,$50,$08,$0F,$07,$15,$05,$FE
           .byte  $30,$20,$03,$0F,$0E,$16,$05,$12
           .byte  $13,$09,$0F,$0E,$FE,$50,$30,$02
           .byte  $19,$FE,$44,$40,$0A,$05,$12,$12
           .byte  $19,$FE,$3C,$50,$02,$12,$05,$03
           .byte  $08,$05,$12,$FE,$1C,$42,$10,$0C
           .byte  $01,$19,$05,$12,$FE,$20,$50,$07
           .byte  $01,$0D,$05,$FE,$20,$74,$30,$20
           .byte  $31,$39,$38,$34,$FE,$04,$80,$12
           .byte  $05,$13,$14,$0F,$0E,$20,$10,$15
           .byte  $02,$0C,$09,$13,$08,$09,$0E,$07
           .byte  $20,$03,$0F,$FE,$04,$90,$0C,$09
           .byte  $03,$05,$0E,$13,$05
LAF98:     .byte  $04,$20,$14
           .byte  $08,$12,$0F,$15,$07,$08,$20,$09
           .byte  $03,$07,$FF,$20,$09,$03,$07
LAFAA:     .byte  $FF,$02,$54,$48,$09,$50,$06,$01
LAFB2:     .byte  $81,$13,$95,$3D,$9D,$43,$81,$1E
           .byte  $79,$2C,$5E,$19,$41,$47,$3E,$82
           .byte  $13,$79,$3D,$8A,$43,$68,$1E,$64
           .byte  $2C,$4A,$19,$24,$47,$24,$FF,$00
           .byte  $00,$FC
LAFD4:     .byte  $81,$03,$9D,$3B,$9D,$1B
           .byte  $84,$49,$84,$0B,$6A,$42,$65,$14
           .byte  $40,$82,$03,$82,$3B,$86
LAFE8:     .byte  $49,$65
           .byte  $42,$40,$14,$2B,$0B,$40,$1B,$6A
           .byte  $87,$29,$9D,$29,$77,$29,$51,$29
           .byte  $2B,$FF,$FD,$FD,$FD,$FD
LB000:     .byte  $00,$C3
           .byte  $EB,$28,$28,$28,$69,$24,$00,$14
           .byte  $10,$FF,$3C,$00,$C3,$EB,$28,$28
           .byte  $28,$69,$18,$00,$14,$04,$FF,$3C
           .byte  $C0,$C0,$03,$2B,$28,$28,$28,$29
           .byte  $40,$14,$14,$FF,$3C,$03,$03,$C0
           .byte  $E8,$28,$28,$28,$68,$01,$14,$14
           .byte  $FF,$3C,$22,$22,$00,$28,$28,$28
           .byte  $69,$24,$00,$14,$10,$FF,$3C
LB041:     .byte  $88,$88,$00,$28,$28,$28,$69,$18,$00
           .byte  $14,$10,$FF,$3C,$88,$88,$00,$28
           .byte  $28,$28,$69,$18,$00,$14,$04,$FF
           .byte  $3C,$22,$22,$00,$28,$28,$28,$69
           .byte  $24,$00,$14,$04,$FF,$3C
LB068:     .byte  $00,$00,$00,$00,$00,$00,$00,$00,$00
LB071:     lda    $B1
           ora    $A6
           beq    LB07C
           lda    $9C
           tax
           dec    $BC,x
LB07C:     rts

           .byte  $A0,$02,$60
LB080:     .byte  $50,$F0,$00,$A0,$00,$F0
LB086:     .byte  $55,$F0,$0F,$AA,$00,$FF
LB08C:     .byte  $05,$50,$FF,$0A,$A0,$0F,$F0
LB093:     .byte  $50,$55,$00,$AF,$0A,$F0,$0F
LB09A:     .byte  $05,$00,$0A,$0F,$00,$0F
LB0A0:     .byte  $82,$AA,$82,$AA,$82
LB0A5:     .byte  $AA,$AA
LB0A7:     .byte  $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
           .byte  $A0,$A0,$A0,$A0,$AA,$2A,$0A,$02
           .byte  $00
LB0B8:     .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$AA,$AA,$AA,$A8
           .byte  $A0
LB0C9:     .byte  $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
           .byte  $A0,$A0,$A0,$A0,$A0,$80,$00,$00
           .byte  $00
LB0DA:     .byte  $A8,$20,$20,$20,$20,$20,$20,$20
           .byte  $A0
LB0E3:     .byte  $AA,$80,$80,$80,$28,$02,$02,$82
           .byte  $28
LB0EC:     .byte  $28,$82,$02,$02,$28,$02,$02,$82
           .byte  $28
LB0F5:     .byte  $08,$08,$08,$08,$AA,$88,$88,$88
           .byte  $88
LB0FE:     .byte  $55,$55,$55,$55,$55,$55,$55,$55
           .byte  $55,$55,$55,$55,$55,$55,$55,$55
           .byte  $55,$55,$55,$55,$55,$55,$55,$55
           .byte  $55,$55
LB118:     .byte  $28,$28,$28,$AA,$AA,$AA,$28,$28
           .byte  $28
LB121:     .byte  $0A,$0A,$0A,$0A,$A0,$A0,$A0,$A0
           .byte  $00
LB12A:     .byte  $22,$22,$88,$88,$22,$22,$88,$88
           .byte  $00
LB133:     .byte  $AA,$AA,$82,$82,$82,$82,$82,$AA
           .byte  $AA
LB13C:     .byte  $28,$28,$28,$82,$82,$82,$28,$28
           .byte  $28
LB145:     .byte  $AA,$8A,$0A,$0A,$AA,$A0,$A0,$A2
           .byte  $AA
LB14E:     .byte  $82,$82,$82,$28,$28,$28,$82,$82
           .byte  $82
LB157:     .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$EA,$03
LB162:     .byte  $54,$FC,$FC,$FC,$FC
           .byte  $FC,$15,$3F,$3F,$3F,$3F,$3F,$14
           .byte  $3C,$3C,$3C,$3C,$3C,$EA,$41,$62
           .byte  $2C,$50,$01,$B0,$50,$63,$FF,$F5
           .byte  $F5
LB180:     .byte  $A7,$9D,$45,$8A,$85,$A5,$C5,$81
           .byte  $85,$82,$56,$85,$87,$2D,$25,$9D
           .byte  $2D,$25,$B2,$2D,$25,$CD,$2D,$25
           .byte  $C3,$9D,$C8,$D0,$81,$E6,$D0,$61
           .byte  $26,$D0,$56,$87,$C7,$44,$A8,$D2
           .byte  $2C,$66,$B7,$4B,$E8,$B1,$57,$48
           .byte  $AF,$79,$E7,$B3,$81,$27,$A0,$87
           .byte  $C1,$8A,$8A,$21,$82,$59,$21,$98
           .byte  $5B,$61,$C0,$5B,$41,$82,$31,$21
           .byte  $98,$31,$01,$20,$31,$01,$AC,$31
           .byte  $81,$54,$31,$01,$82,$1F,$E1,$C0
           .byte  $1F,$41,$4A,$47,$00,$28,$14,$12
           .byte  $50,$14,$12,$10,$4E,$12,$17,$28
           .byte  $12,$44,$28,$12,$1E,$95,$12,$43
           .byte  $49,$12,$FF
        
LB1F3:     cpy    #$04
           bcs    LB1FB
           sta    $02C6,y
           rts

LB1FB:     sta    $02C2,y
           rts

           .byte  $F5
        
LB200:     .byte  $83,$9D,$45,$BB,$9D,$25,$C9
           .byte  $87,$65,$9B,$87,$45,$8B,$6C,$85
           .byte  $94,$42,$25,$14,$32,$05,$C2,$68
           .byte  $65,$42,$5B,$05,$A6,$9D,$29,$AA
           .byte  $9D,$2A,$AE,$9D,$2B,$2A,$9C,$0C
           .byte  $29,$76,$0D,$29,$50,$0E,$29,$2A
           .byte  $0F,$84,$31,$E1,$C4,$31,$21,$A0
           .byte  $57,$41,$38,$57,$00,$A2,$7D,$21
           .byte  $82,$46,$41,$C0,$46,$41,$88,$70
           .byte  $41,$82,$88,$21,$96,$8A,$01,$1E
           .byte  $8A,$00,$B8,$6B,$41,$50,$6B,$01
           .byte  $B4,$8C,$01,$3C,$8C,$01,$C6,$8A
           .byte  $01,$4E,$8A,$01,$31,$96,$13,$02
           .byte  $3D,$13,$12,$22,$13,$38,$45,$13
           .byte  $3E,$22,$13,$48,$5E,$13,$FF,$8D
           .byte  $34
LB278:     .byte  $82,$9D,$E5,$82,$5D,$45,$8D
           .byte  $34,$45,$CB,$34,$45,$88,$1D,$E1
           .byte  $C8,$1D,$01,$82,$37,$21,$12,$37
           .byte  $01,$82,$48,$21,$C4,$37,$01,$4C
           .byte  $37,$01,$8A,$5E,$01,$08,$72,$01
           .byte  $8C,$89,$01,$14,$89,$01,$9A,$39
           .byte  $01,$26,$39,$00,$2C,$30,$01,$B8
           .byte  $3B,$01,$B0,$45,$01,$38,$45,$00
           .byte  $BE,$49,$01,$CA,$51,$01,$A4,$50
           .byte  $01,$2C,$50,$00,$B0,$99,$01,$9C
           .byte  $94,$01,$26,$94,$01,$9C,$7F,$03
           .byte  $24,$7B,$00,$9E,$70,$01,$26,$70
           .byte  $01,$98,$65,$01,$9E,$5B,$01,$BA
           .byte  $91,$01,$C8,$86,$01,$50,$86,$01
           .byte  $AE,$73,$01,$BC,$77,$01,$C6,$7B
           .byte  $01,$B8,$65,$01,$C4,$5B,$01,$44
           .byte  $6B,$01,$48,$6B,$00,$42,$87,$03
           .byte  $14,$96,$14,$50,$7E,$14,$50,$45
           .byte  $14,$30,$5E,$14,$0A,$54,$14,$1F
           .byte  $10,$14,$2C,$28,$14,$2F,$3C,$14
           .byte  $FF
LB318:     .byte  $AA,$4A,$E6,$AA,$2A,$66,$AB
           .byte  $48,$E8,$BB,$28,$68,$AB,$38,$E8
           .byte  $AB,$28,$68,$A9,$48,$E7,$99,$28
           .byte  $67,$A9,$38,$E7,$A9,$28,$67,$A6
           .byte  $50,$01,$2E,$50,$01,$82,$1A,$E1
           .byte  $C2,$1A,$21,$02,$26,$01,$02,$32
           .byte  $01,$02,$3C,$01,$02,$46,$01,$82
           .byte  $50,$01,$0A,$50,$00,$12,$4C,$01
           .byte  $94,$57,$01,$1E,$5B,$01,$82,$6A
           .byte  $01,$02,$74,$01,$0C,$60,$01,$10
           .byte  $60,$00,$88,$7D,$01,$08,$91,$01
           .byte  $52,$26,$01,$4C,$38,$01,$4A,$42
           .byte  $01,$CC,$4E,$01,$4E,$59,$01,$44
           .byte  $62,$01,$48,$62,$00,$4C,$6B,$01
           .byte  $50,$75,$01,$4A,$80,$01,$4E,$80
           .byte  $00,$4E,$8C,$01,$48,$98,$01,$42
           .byte  $89,$01,$36,$83,$01,$9E,$9A,$01
           .byte  $A8,$91,$01,$14,$92,$01,$94,$88
           .byte  $01,$22,$89,$01,$12,$75,$01,$16
           .byte  $75,$00,$1A,$6A,$01,$1E,$6A,$00
           .byte  $2A,$7F,$01,$2A,$74,$01,$A8,$69
           .byte  $01,$1D,$0E,$15,$2A,$10,$15,$37
           .byte  $0E,$15,$0D,$43,$15,$19,$77,$15
           .byte  $FF,$F5,$F5,$F5,$F5,$F5,$F5,$F5
           .byte  $F5,$F5,$F5,$F5,$F5,$F5,$F5,$F5
           .byte  $F5

LB3E0:     .word  LBF88,LB180,LB200,LB278,LB318,LB400,LB500
           .byte  $EA
        
LB3EF:     lda    #>CHARROM
           sta    $C1
           lda    ($BE),y
           cmp    #$1E
           bcc    LB3FB
           inc    $C1
LB3FB:     rts

           .byte  $F5,$F5,$F5,$F5
LB400:     .byte  $89,$3C,$65,$CF
           .byte  $63,$C5,$02,$97,$01,$02,$8B,$01
           .byte  $0A,$80,$01,$12,$75,$01,$16,$75
           .byte  $00,$9C,$6B,$01,$88,$42,$01,$82
           .byte  $1D,$21,$CC,$1D,$01,$54,$1D,$01
           .byte  $BA,$1D,$01,$42,$1D,$00,$A4,$1D
           .byte  $01,$2C,$1D,$01,$32,$26,$01,$A2
           .byte  $35,$01,$32,$3B,$01,$30,$47,$01
           .byte  $2E,$55,$01,$BE,$47,$01,$44,$58
           .byte  $01,$BC,$63,$01,$A8,$5F,$01,$30
           .byte  $76,$01,$3C,$79,$01,$3A,$32,$01
           .byte  $CE,$2C,$01,$CA,$68,$01,$52,$68
           .byte  $01,$CA,$82,$01,$8D,$9F,$F0,$54
           .byte  $8E,$01,$54,$99,$01,$0F,$31,$16
           .byte  $0A,$6B,$16,$22,$27,$16,$43,$13
           .byte  $16,$40,$6D,$16,$4C,$75,$16,$FF
           .byte  $75,$16,$FF,$FD
LB480:     lda    #$6E
           sta    $0328
           nop
           nop
           nop
           lda    #<LA285
           sta    $0102
           lda    #>LA285
           sta    $0103
           lda    #<LAF98
           sta    $9D
           lda    #>LAF98
           sta    $9E
           lda    #<LA03C
           sta    $68
           lda    #>LA03C
           sta    $69
           lda    #<LAFE8
           sta    $0259
           lda    #>LAFE8
           sta    $025A
           lda    #<LB000
           sta    $46
           lda    #>LB000
           sta    $47
           lda    #<CHARSET
           sta    $0304
           lda    #>CHARSET
           sta    $0305
           lda    #<LA09A
           sta    $0257
           lda    #>LA09A
           sta    $0258
           rts

LB4C9:     lda    #$0D
           sta    $66
           lda    #$60
           sta    $64
           lda    #$02
           sta    $65
           lda    #$10
           sta    $62
           lda    #$01
           sta    $63
           lda    $A7
           sta    $0300
           lda    $A8
           sta    $0301
           jsr    LA200
           jsr    LBF78
           jsr    LAC11
           rts

           .byte  $A9,$F0,$09,$20,$C9,$34,$20,$70
           .byte  $A4,$20,$4B,$AD,$60,$FD,$FD
LB500:     .byte  $9B,$4B,$E7,$AA,$69,$E7,$B0,$75,$47
           .byte  $B6,$43,$E8,$C6,$23,$28,$BC,$6A
           .byte  $E8,$CC,$4A,$08,$CC,$37,$C7,$CD
           .byte  $47,$66,$C5,$68,$E7,$C9,$70,$27
           .byte  $86,$9D,$29,$8A,$9D,$2A,$8E,$9D
           .byte  $2B,$0A,$9B,$0C,$09,$75,$0D,$09
           .byte  $4F,$0E,$09,$29,$0F,$CB,$8F,$E7
           .byte  $D0,$9D,$66,$84,$31,$21,$14,$31
           .byte  $01,$82,$57,$21,$84,$7D,$21,$AC
           .byte  $31,$01,$34,$31,$01,$28,$3B,$01
           .byte  $BC,$1D,$41,$B0,$49,$01,$B8,$49
           .byte  $00,$22,$92,$01,$26,$92,$00,$C8
           .byte  $90,$21,$AE,$7B,$01,$38,$7B,$01
           .byte  $BA,$70,$01,$C8,$73,$01,$4E,$67
           .byte  $01,$4C,$5B,$01,$44,$52,$01,$48
           .byte  $46,$01,$3E,$3F,$01,$3A,$90,$01
           .byte  $3E,$90,$00,$20,$7A,$01,$2A,$90
           .byte  $03,$2A,$84,$02,$A0,$5A,$01,$CC
           .byte  $3D,$01,$01,$4A,$17,$32,$18,$17
           .byte  $23,$3A,$17,$39,$63,$17,$42,$90
           .byte  $17,$FF
LB5A3:     .byte  $81,$27,$9D,$45,$81,$0A
           .byte  $84,$02,$53,$07,$2B,$1D,$2B,$32
           .byte  $2B,$4D,$2B,$82,$27,$81,$45,$55
           .byte  $0A,$53,$02,$2B,$07,$19,$1D,$19
           .byte  $32,$19,$4D,$19,$83,$50,$55,$52
           .byte  $19,$84,$1E,$55,$49,$41,$85,$46
           .byte  $2B,$52,$2B,$50,$81,$FF,$48,$40
           .byte  $33,$80,$32,$55,$43,$9D,$50,$80
           .byte  $50,$55,$52,$2B,$FF,$FD,$FD,$FD
           .byte  $FD,$FD,$FD,$FD,$FD,$FD,$FD
LB5F0:     .byte  $81,$02,$9D,$0D,$31,$4B,$31,$82,$02
           .byte  $42,$0D,$17,$4B,$17,$FF,$FD
        
LB600:     jsr    LA3E0
           lda    $44
           beq    LB600
           rts

LB608:     jsr    LA180
           jsr    LA18D
           lda    #$01
           sta    $F0
           sta    $F1
           sta    $3E
           sta    $3F
           lda    #$0F
           sta    VIC+$F
           sta    $59
           inc    $59
           jsr    LA11B
           jsr    LB480
           jsr    LA155
           jsr    LA16C
           lda    #<SCREEN
           sta    $50
           lda    #>SCREEN
           sta    $51
           lda    #$DC
           sta    $010C
           jsr    LA6E0
           lda    #<(SCREEN+$DC)
           sta    $52
           lda    #>(SCREEN+$DC)
           sta    $53
           lda    #$DD
           sta    $54
           lda    #$58
           sta    $010C
           jsr    LA680
           lda    #<(SCREEN-$30)
           sta    $52
           lda    #>(SCREEN-$30)
           sta    $53
           lda    #$00
           sta    $54
           lda    #$11
           sta    $010C
           jsr    LA680
           lda    #<(COLORRAM+$2DD)
           sta    $52
           lda    #>(COLORRAM+$2DD)
           sta    $53
           lda    #$08
           sta    $54
           lda    #$66
           sta    $010C
           jsr    LA680
           ldx    #$00
LB67B:     lda    LA0C0,x
           sta    $02,x
           inx
           cpx    #$33
           bne    LB67B
           nop
           lda    #$00
           sta    $40
           sta    $52
           lda    #>(COLORRAM+$200)
           sta    $53
           lda    #$02
           sta    $54
           lda    #$2C
           sta    $010C
LB699:     jsr    LA680
           clc
           lda    $40
           adc    #$2C
           sta    $52
           sta    $40
           inc    $54
           lda    $54
           cmp    #$07
           bne    LB699
           lda    #$60
           sta    $55
           sta    $57
           jsr    LA193
           jsr    LA060
           jsr    LA6B2
           jsr    LBCF0
LB6BF:     jsr    LAEC5
           jsr    LB89A
           jsr    LAE00
           jsr    LA3E0
           lda    $40
           beq    LB6D5
           inc    $9C
           lda    #$FA
           sta    $58
LB6D5:     jsr    LAE99
           jsr    LBA50
           jsr    LBBCD
           lda    $44
           beq    LB6BF
           lda    $9C
           and    #$01
           clc
           adc    #$01
           sta    $98
           jsr    LAB90
           lda    #$0A
           sta    $54
           jsr    LA010
        
LB6F5:     jsr    LB600
           jsr    LB964
           lda    #$0C
           sta    $BA
           jsr    LAD10
           jsr    LBE8E
           jsr    LBD50
           jsr    LBC8C
           jsr    LBBBE
           jsr    LB9F3
           jsr    LA193
           jsr    LA060
           jsr    LAD77
           jsr    LA6B2
           lda    #$00
           sta    $AE
           sta    $B9
           sta    $B8
           sta    $B1
           lda    #$7E
           sta    $57
           jsr    LA94B
           lda    $3E
           clc
           adc    #$FF
           asl    a
           tax
           lda    LB3E0,x
           sta    $00
           lda    LB3E0+1,x
           sta    $01
           jsr    LA790
           lda    #$0F
           sta    VIC+$F
LB747:     inc    $A2
           lda    $A2
           and    #$0F
           beq    LB747
           cmp    #$08
           beq    LB747
           asl    a
           asl    a
           asl    a
           asl    a
           ora    #$0F
           sta    VIC+$E
           nop
           nop
           jsr    LACF0
LB761:     nop
           lda    $C2
           jsr    LA1E0
LB767:     bne    LB6F5
           jsr    LA470
           jsr    LB800
           lda    $B1
           bne    LB775
           lda    $A6
LB775:     bne    LB77B
           lda    $B7
           bne    LB761
LB77B:     lda    $A6
           beq    LB782
           jsr    LBE60
LB782:     jsr    LB071
           jsr    LA060
           lda    $BC
           ora    $BD
           bne    LB791
           jmp    LB608

LB791:     lda    $A6
           ora    $B1
           bne    LB79E
           jsr    LAA18
           lda    #$00
           sta    $A6
LB79E:     jsr    LACD1
LB7A1:     inc    $A1
           lda    $A1
           and    #$0F
           ora    #$08
           cmp    #$08
           beq    LB7A1
           cmp    #$0F
           beq    LB7A1
           sta    $54
           jsr    LA010
           lda    #$01
           bne    LB767
LB7BA:     ldy    #$00
           lda    $70
           and    #$01
           beq    LB7F3
           lda    $70
           sta    $0300
           inc    $0300
           lda    $71
           cmp    #$9D
           beq    LB7F3
           clc
           adc    #$03
           sta    $0301
           jsr    LA200
           lda    $0308
           bne    LB7E8
           lda    ($96),y
           and    #$F0
           cmp    #$A0
           bne    LB7F3
           beq    LB7F0
LB7E8:     lda    ($96),y
           and    #$0F
           cmp    #$0A
           bne    LB7F3
LB7F0:     jsr    LAC30
LB7F3:     rts

           .byte  $20,$30,$AC
LB7F7:     .byte  $60,$B9,$98,$88,$A5,$8E,$5C,$68
           .byte  $FD
LB800:     jsr    LBAD4
           jsr    LA97B
           jsr    LBB7C
           jsr    LA920
           jsr    LA7F0
           jsr    LB4C9
           jsr    LBDB4
           lda    $A9
           beq    LB81F
           jsr    LA470
           jsr    LBBED
LB81F:     jsr    LAA58
           jsr    LAD4B
           jsr    LBE2C
           jsr    LBCC0
           jsr    LB8D1
           jsr    LBBED
           jsr    LBC70
           lda    $B8
           bne    LB83B
           jsr    LA8F8
LB83B:     jsr    LB9C0
           jsr    LBB00
           jsr    LBBCD
           jsr    LBA42
           jsr    LA3E0
           jsr    LB982
           jsr    LB99C
           jsr    LBA62
           jsr    LBA88
           lda    $73
           beq    LB85D
           jsr    LBA88
LB85D:     nop
           lda    $B8
           bne    LB865
           jsr    LB900
LB865:     jsr    LA590
           lda    $B8
           bne    LB86F
           jsr    LB9D0
LB86F:     jsr    LAAEB
           lda    $B8
           bne    LB87C
           jsr    LBD90
           jsr    LA242
LB87C:     jsr    LA8D0
           jsr    LB8AA
           tay
           iny
           iny
           sta    $D0
           lda    #$20
           asl    a
           sta    $D1
           sta    ($D0),y
           inc    $A1
           rts

           .byte  $C0,$39,$20,$00,$3B,$20,$CD,$3B
           .byte  $20
LB89A:     lda    #$5A
           sta    CHARSET+$A26
           sta    CHARSET+$A28
           lda    #$62
           sta    CHARSET+$A27
           rts

           .byte  $20,$88
LB8AA:     lda    $B1
           beq    LB8D0
           lda    #$0D
           sta    $40
LB8B2:     dec    $40
           lda    $40
           cmp    #$01
           beq    LB8CD
           jsr    LB4C9
           lda    $40
           sta    $66
           inc    $4A
           jsr    LAD4F
           lda    #$85
           jsr    LA1E0
           beq    LB8B2
LB8CD:     jsr    LA1E0
LB8D0:     rts

LB8D1:     lda    $A9
           beq    LB8FE
           jsr    LB4C9
           lda    $AA
           sta    $0300
           lda    $AB
           sta    $0301
           jsr    LA200
           jsr    LBF78
           lda    #$09
           sta    $66
           lda    #$60
           sta    $64
           lda    #<LB068
           sta    $62
           lda    #>LB068
           sta    $63
           jsr    LA280
           jsr    LAD4B
LB8FE:     rts

           .byte  $F5
LB900:     jsr    LABA8
           lda    $73
           beq    LB963
           lda    $AE
           bne    LB963
           lda    $4C
           ora    $4D
           bne    LB963
           lda    $AC
           bne    LB963
           lda    #$00
           sta    $40
           sta    $41
           sta    $42
           sta    $43
           sta    $44
           lda    $AF
           bne    LB937
           lda    $71
           clc
           adc    #$04
           sta    $71
           lda    #$F0
           sta    $57
           jsr    LA10C
           lda    #$01
           sta    $AF
LB937:     ldx    #$00
LB939:     inc    $71
           jsr    LABA8
           lda    $73
           beq    LB94A
           inx
           inc    $B2
           cpx    #$03
           bne    LB939
           rts

LB94A:     lda    $B2
           cmp    $B0
           bcc    LB954
           lda    #$01
           sta    $B1
LB954:     lda    #$7E
           sta    $57
           jsr    LA10C
           lda    #$00
           sta    $AF
           sta    $B2
           nop
           nop
LB963:     rts

LB964:     lda    #$00
           sta    $AF
           sta    $B2
           sta    $B1
           lda    #$19
           sta    $B0
           lda    #$C0
           sta    $B3
           lda    #$30
           sta    $B4
           lda    #$0C
           sta    $B5
           lda    #$03
           sta    $B6
           rts

           .byte  $F5
LB982:     ldx    #$00
           lda    $72
           cmp    #$01
           bne    LB990
           sta    $4C
           stx    $4D
           beq    LB998
LB990:     cmp    #$02
           bne    LB998
           sta    $4D
           stx    $4C
LB998:     rts

           .byte  $F5,$F5,$F5
LB99C:     lda    $40
           beq    LB9AC
           lda    $72
           cmp    #$01
           bne    LB9AC
           sta    $4C
           sta    $4D
           beq    LB9BA
LB9AC:     lda    $42
           beq    LB9BA
           lda    $72
           cmp    #$02
           bne    LB9BA
           sta    $4C
           sta    $4D
LB9BA:     rts

           .byte  $4C,$85,$4D,$60,$F5
LB9C0:     lda    $4E
           beq    LB9CF
           cmp    #$20
           bcc    LB9C9
           rts

LB9C9:     lda    #$00
           sta    $4C
           sta    $4D
LB9CF:     rts

LB9D0:     lda    $4C
           beq    LB9D9
           lda    $4D
           beq    LB9D9
           rts

LB9D9:     ora    $73
           ora    $4E
           bne    LB9E2
           jsr    LB7BA
LB9E2:     rts

           .byte  $F5,$F5,$F5,$F5,$F5,$F5,$F5,$F5
           .byte  $F5,$F5,$F5,$F5,$F5,$F5,$F5,$F5
LB9F3:     lda    $3E
           tax
           lda    LB7F7,x
           sta    $B7
           lda    #$00
           sta    $AC
           rts

LBA00:     .word  CHARSET+$000,CHARSET+$160,CHARSET+$2C0,CHARSET+$420,CHARSET+$580
           .word  CHARSET+$6E0,CHARSET+$840,CHARSET+$9A0,CHARSET+$B00,CHARSET+$C60
LBA14:     .word  $0000,$0010,$0020,$0030,$0040,$0050,$0060,$0070
           .word  $0080,$0090,$00A0,$00B0,$00C0,$00D0,$00E0,$00F0
           .word  $0100,$0110,$0120,$0130,$0140,$0150,$F5FF
        
LBA42:     lda    $57
           cmp    #$7E
           beq    LBA4F
           dec    $57
           dec    $57
           jsr    LA10C
LBA4F:     rts

LBA50:     lda    #$00
           ldx    #$00
LBA54:     sta    $99,x
           sta    $02A1,x
           sta    $02A5,x
           inx
           cpx    #$03
           bne    LBA54
           rts

LBA62:     lda    $72
           cmp    #$03
           bne    LBA6C
           sta    $AE
           beq    LBA7A
LBA6C:     cmp    #$04
           bne    LBA74
           sta    $AE
           beq    LBA7A
LBA74:     cmp    #$05
           bne    LBA85
           sta    $AE
LBA7A:     lda    #$E0
           sta    $57
           lda    $71
           clc
           adc    #$05
           sta    $71
LBA85:     rts

           sbc    $F5,x
LBA88:     lda    $AE
           beq    LBAD3
           lda    #$00
           sta    $40
           sta    $41
           sta    $42
           sta    $43
           sta    $44
           inc    $71
           jsr    LBDB4
           jsr    LBBED
           jsr    LABA8
           lda    $73
           beq    LBAB2
           inc    $71
           jsr    LBDB4
           jsr    LBBED
           jsr    LABA8
LBAB2:     lda    $AE
           cmp    #$04
           bne    LBABA
           inc    $70
LBABA:     cmp    #$05
           bne    LBAC0
           dec    $70
LBAC0:     jsr    LBDB4
           jsr    LBBED
           lda    $73
           bne    LBAD3
           sta    $AE
           lda    #$7E
           sta    $57
           jsr    LA10C
LBAD3:     rts

LBAD4:     lda    $4E
           and    #$18
           beq    LBAE7
           lda    $70
           and    #$01
           beq    LBAE7
           lda    #$FF
           sta    $58
           jsr    LA112
LBAE7:     rts

LBAE8:     inc    $9C
           lda    $9C
           and    #$01
           sta    $9C
           tax
           lda    $BC,x
           bne    LBAFD
           inc    $9C
           lda    $9C
           and    #$01
           sta    $9C
LBAFD:     rts

           .byte  $33,$20
LBB00:     lda    $58
           beq    LBB08
           cmp    #$FB
           bcc    LBB56
LBB08:     lda    VIC+$0        ; disable interlace mode
           and    #$7F
           sta    VIC+$0
           lda    $72
           cmp    #$07
           bne    LBB56
           lda    VIC+$0        ; enable interlace mode
           ora    #$80
           sta    VIC+$0
           lda    $40
           beq    LBB2B
           lda    $71
           sec
           sbc    #$26
           sta    $71
           bne    LBB36
LBB2B:     lda    $42
           beq    LBB56
           lda    $71
           clc
           adc    #$26
           sta    $71
LBB36:     lda    #$F8
           sta    $58
           lda    #$FC
           sta    $56
           jsr    LA106
           jsr    LA112
           lda    $71
           cmp    #$C3
           bne    LBB4E
           lda    #$2B
           sta    $71
LBB4E:     cmp    #$05
           bne    LBB56
           lda    #$9D
           sta    $71
LBB56:     rts

           .byte  $05,$38,$E9,$26,$D0,$F7,$85,$71
           .byte  $60,$F5,$F5,$F5,$F5,$F5,$F5
LBB66:     .byte  $84,$12,$14,$1A,$14,$22,$14,$85,$32
           .byte  $14,$3A,$14,$42,$14,$83,$2A,$14
           .byte  $2A,$29,$2A,$39,$FF
        
LBB7C:     lda    $02A0
           cmp    #$01
           bne    LBB87
           lda    #$F0
           sta    $56
LBB87:     rts

           .byte  $F5,$F5
LBB8A:     .byte  $84,$0E,$2B,$20,$54,$40
           .byte  $17,$36,$43,$3C,$6A,$83,$4E,$37
           .byte  $4E,$33,$50,$8A,$85,$4E,$44,$48
           .byte  $17,$87,$09,$9D,$09,$77,$09,$51
           .byte  $09,$2B,$FF,$F5,$F5,$F5
           .byte  $F5,$F5
        
LBBB0:     .word  LAFB2,LB5A3,LAFD4,LB5F0,LBB66,LA463,LBB8A
        
LBBBE:     lda    $3E
           asl    a
           tax
           lda    LBBB0-2,x
           sta    $68
           lda    LBBB0-1,x
           sta    $69
           rts

LBBCD:     lda    $56
           beq    LBBD6
           inc    $56
           jsr    LA106
LBBD6:     lda    $58
           beq    LBBDF
           inc    $58
           jsr    LA112
LBBDF:     lda    $59
           and    #$0F
           cmp    #$0F
           beq    LBBEC
           inc    $59
           jsr    LA118
LBBEC:     rts

LBBED:     lda    $A9
           beq    LBBFD
           lda    #$E0
           sta    $56
           lda    $3E
           sta    $9A
           lda    #$00
           sta    $A9
LBBFD:     rts

           .byte  $F5,$F5,$E5

LBC01:     .word  LBC10,LBC1D,LBC2C,LBC39,LBC4A,LBC55,LBC64
        
           .byte  $FD
LBC10:     .byte  $49,$7D,$08,$64,$4F,$5C,$25,$41
           .byte  $0F,$1D,$4E,$37,$FF
LBC1D:     .byte  $28,$14,$50,$14,$10,$4E,$17,$28
           .byte  $44,$28,$1E,$95,$43,$49,$FF
LBC2C:     .byte  $31,$96,$02,$3D,$12,$22,$38,$45,$3E,$22,$48,$5E,$FF
LBC39:     .byte  $14,$96,$50,$7E,$50,$45,$30,$5E
           .byte  $0A,$54,$1F,$10,$2C,$28,$2F,$3C,$FF
LBC4A:     .byte  $1D,$0E,$2A,$10,$37,$0E,$0D,$43,$19,$77,$FF
LBC55:     .byte  $0F,$31,$0A,$6B,$22,$27,$43,$13,$40,$6D,$4C
           .byte  $75,$FF,$FF,$FF
LBC64:     .byte  $01,$4A,$32,$18,$23,$3A,$39,$63,$42,$90,$FF,$AD
        
LBC70:     lda    $AD
           beq    LBC8A
           dec    $AD
           lda    $AD
           cmp    #$10
           bne    LBC80
           lda    #$01
           sta    $A3
LBC80:     lda    $AD
           bne    LBC8A
           lda    #$00
           sta    $A3
           sta    $A4
LBC8A:     rts

           .byte  $FD
LBC8C:     lda    $3E
           asl    a
           tax
           lda    LBC01-2,x
           sta    $AA
           lda    LBC01-1,x
           sta    $AB
           ldy    #$00
           sty    $AD
           sty    $A4
           sty    $A3
           ldx    #$00
LBCA4:     lda    ($AA),y
           cmp    #$FF
           beq    LBCBC
           sta    $02A8,x
           inc    $AA
           lda    ($AA),y
           sta    $02B2,x
           sta    $02BC,x
           inc    $AA
           inx
           bne    LBCA4
LBCBC:     sta    $02A8,x
           rts

LBCC0:     ldx    #$00
LBCC2:     lda    $02A8,x
           cmp    #$FF
           beq    LBCEF
           sta    $AA
           lda    $02B2,x
           sta    $AB
           lda    $02BC,x
           beq    LBCEC
           jsr    LA41A
           lda    $A9
           beq    LBCEC
           lda    #$00
           sta    $02BC,x
           sta    $A3
           lda    #$01
           sta    $A4
           lda    #$50
           sta    $AD
           rts

LBCEC:     inx
           bne    LBCC2
LBCEF:     rts

LBCF0:     lda    #$00
           sta    $9C
           lda    #$03
           sta    $BC
           sta    $BD
           rts

           .byte  $FD,$FD,$FD,$FD,$FD
LBD00:     .byte  $FC,$CC,$CC
           .byte  $CC,$FC,$00,$00,$00,$0C,$0C,$0C
           .byte  $0C,$0C,$00,$00,$00,$FC,$C0,$FC
           .byte  $0C,$FC,$00,$00,$00,$FC,$0C,$3C
           .byte  $0C,$FC,$00,$00,$00,$0C,$0C,$FC
           .byte  $CC,$CC,$00,$00,$00,$FC,$0C,$FC
           .byte  $C0,$FC,$00,$00,$00,$FC,$CC,$FC
           .byte  $C0,$C0,$00,$00,$00,$0C,$0C,$0C
           .byte  $0C,$FC,$00,$00,$00,$FC,$CC,$FC
           .byte  $CC,$FC,$00,$00,$00,$0C,$0C,$FC
           .byte  $CC,$FC,$00,$00,$00
LBD50:     lda    #$00
           tax
LBD53:     sta    $0110,x
           inx
           cpx    #$0D
           bne    LBD53
           sta    $4E
           sta    $45
           sta    $4C
           sta    $4D
           sta    $73
           lda    #$9D
           sta    $71
           sta    $A8
           ldx    $3E
           lda    LAFAA,x
           sta    $70
           sta    $A7
           lda    #$10
           sta    $48
           lda    #$01
           sta    $49
           lda    #<LB000
           sta    $46
           lda    #>LB000
           sta    $47
           lda    #<LB041
           sta    $4A
           lda    #>LB041
           sta    $4B
           rts

           .byte  $A2,$00,$BD
LBD90:     .byte  $A5
           lsr    $1EF0
           cmp    #$08
           bne    LBD9D
           dec    $70
           jsr    LB7BA
LBD9D:     cmp    #$10
           bne    LBDA6
           inc    $70
           jsr    LB7BA
LBDA6:     cmp    #$20
           bne    LBDAC
           dec    $71
LBDAC:     cmp    #$40
           bne    LBDB2
           inc    $71
LBDB2:     rts

           .byte  $60
LBDB4:     ldx    #$00
LBDB6:     lda    $031F,x
           cmp    #$FF
           beq    LBDD1
           sta    $AA
           lda    $0324,x
           sta    $AB
           jsr    LA41A
           lda    $A9
           beq    LBDD1
           lda    #$01
           sta    $0334,x
           rts

LBDD1:     inx
           cpx    #$05
           bne    LBDB6
           rts

           .byte  $FD
LBDD8:     lda    #$00
           sta    $AC
           lda    $AB
           sec
           sbc    #$06
           sta    $9F
           lda    $71
           cmp    $9F
           beq    LBDEA
           rts

LBDEA:     lda    $AA
           sec
           sbc    #$02
           sta    $9F
           lda    $70
           cmp    $9F
           bcs    LBDF8
           rts

LBDF8:     lda    $AA
           clc
           adc    #$02
           bne    LBE00
           brk
LBE00:     sta    $9F
           lda    $70
           cmp    $9F
           bcc    LBE09
           rts

LBE09:     lda    #$01
           sta    $AC
           rts

LBE0E:     lda    #$90
           sta    $0301
LBE13:     ldx    #$50
LBE15:     stx    $0300
           jsr    LA200
           lda    #$00
           tay
           sta    ($96),y
           dex
           dex
           dex
           dex
           bne    LBE15
           dec    $0301
           bne    LBE13
           rts

LBE2C:     ldx    #$00
LBE2E:     lda    $039E,x
           beq    LBE4F
           sta    $AA
           lda    $03AA,x
           and    #$01
           bne    LBE3E
           inc    $AA
LBE3E:     lda    $03A1,x
           sta    $AB
           jsr    LBDD8
           lda    $AC
           bne    LBE50
           inx
           cpx    #$03
           bne    LBE2E
LBE4F:     rts

LBE50:     lda    $03AA,x
           and    #$01
           beq    LBE5A
           dec    $70
           rts

LBE5A:     inc    $70
           rts

           .byte  $70,$60,$E6
LBE60:     ldy    #$00
           sty    $42
LBE64:     sty    $40
           lda    #>CHARSET
           sta    $41
LBE6A:     lda    ($40),y
           beq    LBE71
           asl    a
           sta    ($40),y
LBE71:     inc    $40
           bne    LBE77
           inc    $41
LBE77:     lda    $41
           cmp    #>CHARSET+$D
           bne    LBE6A
           lda    $40
           cmp    #$C0
           bne    LBE6A
           inc    $42
           lda    $42
           cmp    #$08
           bne    LBE64
           rts

           lda    #<LB162
LBE8E:     sta    $0259
           lda    #>LB162
           sta    $025A
           lda    $3E
           clc
           adc    #$FF
           asl    a
           tax
           lda    LBEC0,x
           sta    $3C
           lda    LBEC0+1,x
           sta    $3D
           ldy    #$00
LBEA9:     lda    ($3C),y
           sta    $039E,y
           iny
           cpy    #$09
           bne    LBEA9
           lda    #$00
           tax
LBEB6:     sta    $03A7,x
           inx
           cpx    #$06
           bne    LBEB6
           rts

           .byte  $F8

LBEC0:     .word  LBED6,LBED6,LBED6,LBED6,LBED9,LBEE2,LBEEB
           .byte  $FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD
LBED6:     .byte  $00,$00,$00
LBED9:     .byte  $32,$31,$3E,$95,$58,$31,$11,$16,$14
LBEE2:     .byte  $0D,$00,$00,$4E,$00,$00,$3A,$00,$00
LBEEB:     .byte  $14,$14,$0F,$9B,$24,$62,$21,$26,$10,$FD
        
LBEF5:     .byte  $FD,$11,$13,$15,$17,$19,$21,$23
           .byte  $FD,$FD,$FD
LBF00:     .byte  $0D,$2B,$23,$14,$00,$17,$0A,$04
           .byte  $2B,$FF,$95,$79,$24,$24,$00
LBF0F:     .byte  $0F,$32,$04,$1A,$16,$0E,$22,$46
           .byte  $0A,$30,$9D,$9D,$40,$19,$19
LBF1E:     .byte  $0B,$31,$12,$19,$13,$13,$0D,$40
           .byte  $38,$06,$6A,$2B,$40,$65,$40
LBF2D:     .byte  $44,$07,$06,$04,$09,$08,$24,$3E
           .byte  $46,$1E,$17,$4A,$43,$75,$8E
LBF3C:     .byte  $15,$16,$22,$25,$05,$05,$2E,$2E
           .byte  $02,$06,$9D,$9D,$14,$14,$4A
LBF4B:     .byte  $0D,$07,$05,$02,$00,$02,$4C,$1E
           .byte  $52,$FF,$17,$17,$65,$88,$00
LBF5A:     .byte  $09,$0C,$18,$00,$00,$2C,$02,$3A
           .byte  $FF,$FF,$2B,$77,$9D,$00,$00,$EA
LBF6A:     .word  LBF00,LBF0F,LBF1E,LBF2D,LBF3C,LBF4B,LBF5A
        
LBF78:     lda    $96
           sta    $60
           lda    $97
           sta    $61
           lda    $0308
           sta    $0100
           rts

           .byte  $84
LBF88:     .byte  $93,$96,$45,$BD,$9D,$25,$C3
           .byte  $84,$45,$9E,$7F,$45,$AC,$63,$45
           .byte  $99,$46,$65,$C7,$43,$45,$8C,$9B
           .byte  $41,$08,$9D,$03,$A8,$9A,$23,$3A
           .byte  $92,$03,$24,$9B,$01,$BC,$90,$41
           .byte  $54,$90,$01,$02,$7F,$00,$84,$7F
           .byte  $A1,$B4,$80,$22,$2C,$64,$01,$48
           .byte  $89,$01,$90,$71,$43,$28,$65,$03
           .byte  $08,$71,$01,$B0,$65,$62,$84,$2A
           .byte  $E1,$44,$88,$02,$38,$92,$03,$C4
           .byte  $2A,$21,$8C,$41,$62,$2C,$50,$01
           .byte  $B0,$50,$63,$49,$7D,$11,$08,$64
           .byte  $11,$4F,$5C,$11,$25,$41,$11,$0F
           .byte  $1D,$11,$4E,$37,$11,$FF,$37,$11
           .byte  $FF
        
LBFF8:     sei
           jsr    $E5C3         ; kernal: init VIC (22 columns, 23 rows)
           jmp    LB608

           .byte  $FD
