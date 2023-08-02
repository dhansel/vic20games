;;; UMI Software SPIDERS OF MARS for VIC-20
        
VIC               := $9000      ; $9000-$900F
VIA1              := $9110      ; $9110-$911F
VIA2              := $9120      ; $9120-$912F
COLORRAM          := $9600      ; $9400-$94F1 (22x11)
CHARSET           := $1000      ; $1000-$1FFF
SCREEN            := $0200      ; $0200-$02F1 (22x11)
JOY_REG_RIGHT     := VIA2+0
JOY_REG_OTHER     := VIA1+1
JOY_MASK_UP       := $04
JOY_MASK_DOWN     := $08
JOY_MASK_LEFT     := $10
JOY_MASK_RIGHT    := $80
JOY_MASK_BUTTON   := $20

        ;; start screen:        
        ;;   F1 = reset game
        ;;   F3 = increase level
        ;;   F5 = start game
        ;; game play:
        ;;   A  = up
        ;;   Z  = down
        ;;   ,  = left
        ;;   .  = right
        ;;   SPACE = fire
        
           .org $A000
        
           .setcpu"6502"

           .word  LA009,LA009
           .byte  $41,$30,$C3,$C2,$CD
        
LA009:     sei
           cld
           ldx    #$FF
           txs
           ldx    #$09
           lda    #$00
LA012:     sta    $0100,x
           dex
           bpl    LA012
           jsr    LAFB6
LA01B:     jmp    LB396

LA01E:     jsr    LB076
           jsr    LB08C
           jsr    LB000
           jsr    LA719
           jsr    LB033
           jsr    LA68E
           jsr    LB10C
           jsr    LB2CF
           jsr    LB32A
           jsr    LB37D
LA03C:     dec    $20
           bne    LA043
           jsr    LB170
LA043:     dec    $21
           bne    LA04A
           jsr    LA7FA
LA04A:     dec    $22
           bne    LA051
           jsr    LAC4C
LA051:     dec    $23
           bne    LA058
           jsr    LAD06
LA058:     dec    $24
           bne    LA05F
           jsr    LA19A
LA05F:     dec    $25
           bne    LA066
           jsr    LA24A
LA066:     dec    $2A
           bne    LA06D
           jsr    LA0B9
LA06D:     dec    $26
           bne    LA074
           jsr    LA2B9
LA074:     dec    $27
           bne    LA07B
           jsr    LA358
LA07B:     dec    $28
           bne    LA082
           jsr    LA385
LA082:     dec    $29
           bne    LA089
           jsr    LA4B8
LA089:     dec    $2B
           bne    LA090
           jsr    LB2CF
LA090:     dec    $2C
           bne    LA097
           jsr    LA5B9
LA097:     dec    $2D
           bne    LA09E
           jsr    LB4B6
LA09E:     nop
           ldx    $4D
LA0A1:     dex
           bne    LA0A1
           jmp    LA03C

LA0A7:     .byte  $20,$10,$0C,$0A,$08,$06,$04,$03
           .byte  $02,$01,$01,$01,$01,$01,$01,$01
           .byte  $01,$01
LA0B9:     lda    $3A
           sta    $2A
           lda    $70
           bne    LA11F
           lda    $71
           bne    LA11F
           inc    $0104
           lda    $0108
           bne    LA0D8
           lda    $6C
           bne    LA0F4
           lda    #<LB63D
           ldy    #>LB63D
           jsr    LB571
LA0D8:     jmp    LA0FB

LA0DB:     sed
           sec
           lda    $0106
           bmi    LA10D
           sbc    #$01
           sta    $0106
           bmi    LA10D
           cld
           jsr    LB37D
           jsr    LB2CF
           lda    $6C
           beq    LA0FB
LA0F4:     lda    #<LB652
           ldy    #>LB652
           jsr    LB571
LA0FB:     jsr    LB5E5
           ldy    #$FF
LA100:     ldx    #$FF
LA102:     dex
           bne    LA102
           dey
           bne    LA100
           pla
           pla
           jmp    LA01E

LA10D:     cld
           pla
           pla
           lda    $0108
           bne    LA11C
           lda    #<LB670
           ldy    #>LB670
           jsr    LB571
LA11C:     jmp    LA01B

LA11F:     rts

LA120:     lda    #$07
           sta    $10
           lda    #$00
           sta    $02
LA128:     ldy    $10
           lda    LB68B,y
           sta    $00
           lda    LB6A7,y
           sta    $01
           ldx    $02
           lda    LA154,x
           beq    LA153
           asl    a
           asl    a
           asl    a
           tax
           inc    $10
           inc    $02
           ldy    #$40
LA145:     lda    LBF08,x
           sta    ($00),y
           inx
           iny
           cpy    #$48
           bne    LA145
           jmp    LA128

LA153:     rts

LA154:     .byte  $0D,$09,$0B,$11,$06,$12,$06,$05
           .byte  $0B,$07,$04,$0F,$04,$02,$00
LA163:     lda    $0108
           bne    LA196
           lda    #$00
           sta    VIA2+$2
           lda    #$FF
           sta    VIA2+$3
LA172:     lda    #$DF
           sta    VIA2+$1
           lda    VIA2+$0
           and    #$02
           beq    LA172
LA17E:     lda    #$DF
           sta    VIA2+$1
           lda    VIA2+$0
           and    #$02
           bne    LA17E
LA18A:     lda    #$DF
           sta    VIA2+$1
           lda    VIA2+$0
           and    #$02
           beq    LA18A
LA196:     jmp    LB275

LA199:     rts

LA19A:     lda    $34
           sta    $24
           ldx    #$15
           stx    $04
LA1A2:     dec    $04
           ldx    $04
           cpx    #$0C
           beq    LA199
           lda    $C2,x
           bmi    LA1A2
           lda    $44
           beq    LA1D5
           lda    $C2,x
           bne    LA1D5
           jsr    LB0D2
           cmp    #$01
           beq    LA1D5
           dec    $44
LA1BF:     lda    $43,x
           eor    #$01
           sta    $43,x
           inc    $0105
           ldy    $0105
           lda    LBE08,y
           clc
           lsr    a
           lsr    a
           ora    #$03
           sta    $C2,x
LA1D5:     lda    $C2,x
           beq    LA20D
           jsr    LB0D2
           cmp    #$01
           bne    LA20D
           lda    $0300,x
           jsr    LAFC2
           sec
           cmp    $0A
           bcc    LA1F2
           lda    #$01
           sta    $12
           jmp    LA1F6

LA1F2:     lda    #$01
           sta    $13
LA1F6:     sec
           lda    $033E
           cmp    $033E,x
           bcs    LA206
           lda    #$01
           sta    $14
           jmp    LA243

LA206:     lda    #$01
           sta    $15
           jmp    LA243

LA20D:     lda    $43,x
           and    #$10
           beq    LA21A
           lda    #$01
           sta    $13
           jmp    LA21E

LA21A:     lda    #$01
           sta    $12
LA21E:     lda    $C2,x
           beq    LA243
           dec    $C2,x
           beq    LA1BF
           lda    $43,x
           and    #$01
           beq    LA238
           lda    $033E,x
           beq    LA1BF
           lda    #$01
           sta    $14
           jmp    LA243

LA238:     lda    $033E,x
           cmp    #$43
           beq    LA1BF
           lda    #$01
           sta    $15
LA243:     jsr    LAE23
           jmp    LA1A2

LA249:     rts

LA24A:     lda    $35
           sta    $25
           ldx    #$1D
           stx    $04
LA252:     dec    $04
           ldx    $04
           cpx    #$14
           beq    LA249
           lda    $C2,x
           bmi    LA252
           lda    $45
           beq    LA285
           lda    $C2,x
           bne    LA285
           jsr    LB0D2
           cmp    #$01
           beq    LA285
           dec    $45
LA26F:     lda    $43,x
           eor    #$01
           sta    $43,x
           inc    $0105
           ldy    $0105
           lda    LBE08,y
           clc
           lsr    a
           lsr    a
           ora    #$01
           sta    $C2,x
LA285:     lda    $C2,x
           beq    LA2B2
           lda    #$01
           sta    $13
           dec    $C2,x
           beq    LA26F
           lda    $43,x
           beq    LA2A4
           lda    $033E,x
           beq    LA26F
           lda    #$01
           sta    $14
LA29E:     jsr    LAE23
           jmp    LA252

LA2A4:     lda    $033E,x
           cmp    #$44
           beq    LA26F
           lda    #$01
           sta    $15
           jmp    LA29E

LA2B2:     inc    $0300,x
           jmp    LA252

LA2B8:     rts

LA2B9:     lda    $36
           sta    $26
           ldx    #$21
           stx    $04
LA2C1:     dec    $04
           ldx    $04
           cpx    #$1C
           beq    LA2B8
           lda    $C2,x
           bmi    LA2C1
           lda    $46
           beq    LA2E2
           lda    $C2,x
           bne    LA2E2
           jsr    LB0D2
           cmp    #$01
           beq    LA2E2
           lda    #$01
           sta    $C2,x
           dec    $46
LA2E2:     lda    #$01
           sta    $12
           sec
           lda    $033E
           cmp    $033E,x
           beq    LA2FA
           bcs    LA30E
           lda    $033E,x
           beq    LA2FA
           lda    #$01
           sta    $14
LA2FA:     jsr    LAE23
           ldx    $04
           sec
           lda    $033E,x
           sbc    $033E
           sec
           cmp    #$03
           bcs    LA2C1
           jmp    LA32A

LA30E:     lda    $033E,x
           cmp    #$4A
           beq    LA319
           lda    #$01
           sta    $15
LA319:     jsr    LAE23
           ldx    $04
           sec
           lda    $033E
           sbc    $033E,x
           sec
           cmp    #$02
           bcs    LA2C1
LA32A:     jsr    LB0D2
           cmp    #$01
           bne    LA2C1
           lda    $C2,x
           beq    LA2C1
           lda    $D6,x
           bne    LA2C1
           lda    #$01
           sta    $D6,x
           sec
           lda    $0300,x
           sbc    #$04
           sta    $0314,x
           clc
           lda    $033E,x
           adc    #$02
           sta    $0352,x
           lda    #$0A
           sta    $1F34,x
           jmp    LA2C1

LA357:     rts

LA358:     lda    $37
           sta    $27
           ldx    #$35
           stx    $04
LA360:     dec    $04
           ldx    $04
           cpx    #$30
           beq    LA357
           lda    $C2,x
           beq    LA360
           jsr    LB0D2
           cmp    #$01
           bne    LA37D
           lda    #$01
           sta    $12
           jsr    LAE23
           jmp    LA360

LA37D:     lda    #$00
           sta    $C2,x
           jmp    LA360

LA384:     rts

LA385:     lda    $38
           sta    $28
           dec    $48
           bne    LA3C5
           lda    $49
           sta    $48
           ldx    #$08
LA393:     dex
           bmi    LA3C5
           lda    $D7,x
           beq    LA393
           bmi    LA393
           ldy    #$0F
LA39E:     lda    $E3,y
           beq    LA3A9
           dey
           bmi    LA3C5
           jmp    LA39E

LA3A9:     clc
           lda    $0315,x
           sta    $0321,y
           lda    $0353,x
           adc    #$02
           sta    $035F,y
           lda    #$40
           sta    $E3,y
           lda    #$15
           sta    $1F41,y
           jmp    LA393

LA3C5:     ldx    #$31
           stx    $04
LA3C9:     dec    $04
           ldx    $04
           cpx    #$20
           beq    LA384
           lda    $C2,x
           beq    LA3C9
           bmi    LA41E
           inc    $C2,x
           jsr    LB0D2
           cmp    #$01
           bne    LA3EE
           lda    $0300,x
           jsr    LAFC2
           sec
           cmp    $0A
           bcs    LA3FE
           jmp    LA3F7

LA3EE:     sec
           lda    $0300
           cmp    $0300,x
           bcc    LA3FE
LA3F7:     lda    #$01
           sta    $13
           jmp    LA402

LA3FE:     lda    #$01
           sta    $12
LA402:     sec
           lda    $033E
           cmp    $033E,x
           beq    LA418
           bcs    LA414
           lda    #$01
           sta    $14
           jmp    LA418

LA414:     lda    #$01
           sta    $15
LA418:     jsr    LAE23
           jmp    LA3C9

LA41E:     lda    #$16
           sta    $1F20,x
           jsr    LAE23
           ldx    $04
           lda    #$00
           sta    $C2,x
           lda    #$15
           sta    $1F20,x
           lda    $38
           cmp    #$38
           beq    LA439
           dec    $38
LA439:     jmp    LA3C9

LA43C:     ldy    $4E
           ldx    #$3E
           stx    $04
LA442:     dec    $04
           ldx    $04
           cpx    #$35
           beq    LA4B4
           lda    $C3,y
           beq    LA4B4
           bmi    LA4B4
           lda    $C2,x
           beq    LA442
           bmi    LA442
           jsr    LB0D2
           cmp    #$01
           bne    LA442
           sec
           lda    $033E,x
           cmp    #$F0
           bcs    LA442
           sec
           cmp    $033F,y
           bcc    LA442
           clc
           lda    $18,y
           adc    #$05
           sta    $06
           lda    $0300,x
           jsr    LAFC2
           sec
           cmp    $06
           bcs    LA442
           sec
           cmp    $18,y
           bcc    LA442
           lda    #$80
           sta    $C2,x
           sta    $C3,y
           lda    $91,x
           cmp    #$02
           beq    LA4B4
           lda    #$80
           sta    $91,x
           lda    $0108
           bne    LA4B4
           lda    #$01
           sta    $65
           lda    #$80
           sta    VIC+$D
           lda    VIC+$E
           ora    #$0F
           sta    VIC+$E
           lda    LBE08,y
           ora    #$80
           sta    VIC+$B
LA4B4:     rts

LA4B5:     jmp    LA43C

LA4B8:     lda    $39
           sta    $29
           inc    $4E
           ldy    $4E
           cpy    #$04
           bne    LA4C8
           ldy    #$00
           sty    $4E
LA4C8:     ldx    #$21
           stx    $04
LA4CC:     dec    $04
           ldy    $4E
           ldx    $04
           cpx    #$04
           beq    LA4B5
           lda    $C2,x
           beq    LA4CC
           bmi    LA54F
           lda    $C3,y
           beq    LA4CC
           bmi    LA4CC
           jsr    LB0D2
           cmp    #$01
           bne    LA4CC
           clc
           lda    $18,y
           adc    #$05
           sta    $06
           lda    $0300,x
           jsr    LAFC2
           sec
           cmp    $06
           bcs    LA4CC
           lda    $0300,x
           adc    #$0A
           jsr    LAFC2
           sec
           cmp    $18,y
           bcc    LA4CC
           lda    $033E,x
           cmp    $033F,y
           bcs    LA4CC
           lda    $1F20,x
           tay
           lda    LB6C3,y
           clc
           lsr    a
           adc    $033E,x
           ldy    $4E
           sec
           cmp    $033F,y
           bcc    LA4CC
           lda    #$80
           sta    $C2,x
           sta    $C3,y
           lda    $0108
           bne    LA4CC
           lda    #$01
           sta    $65
           lda    #$80
           sta    VIC+$D
           lda    VIC+$E
           ora    #$0F
           sta    VIC+$E
           lda    LBE08,y
           ora    #$80
           sta    VIC+$B
           jmp    LA4CC

LA54F:     sec
           lda    $033E,x
           cmp    #$50
           bcs    LA561
           lda    #$01
           sta    $15
           jsr    LAE23
           jmp    LA4CC

LA561:     lda    #$00
           sta    $C2,x
           txa
           sec
           sbc    #$05
           clc
           lsr    a
           lsr    a
           tay
           lda    LA5B0,y
           jsr    LA5A0
           jsr    LB2A2
           ldx    $04
           inc    $0105
           ldy    $0105
           lda    LBE08
           and    #$2F
           sta    $033E,x
           sec
           cpx    #$0D
           bcc    LA59B
           sec
           lda    $70
           sbc    #$01
           sta    $70
           lda    $71
           sbc    #$00
           sta    $71
           jmp    LA4CC

LA59B:     inc    $62
           jmp    LA4CC

LA5A0:     sta    $06
           ldy    $47
           sed
LA5A5:     dey
           beq    LA5AE
           clc
           adc    $06
           jmp    LA5A5

LA5AE:     cld
           rts

LA5B0:     .byte  $01,$01,$03,$03,$02,$02,$04,$04
LA5B8:     rts

LA5B9:     lda    $3C
           sta    $2C
           lda    $C2
           beq    LA5B8
           bmi    LA5B8
           ldx    #$35
           stx    $04
LA5C7:     dec    $04
           ldx    $04
           cpx    #$04
           beq    LA62F
           lda    $C2,x
           beq    LA5C7
           jsr    LB0D2
           cmp    #$01
           bne    LA5C7
           clc
           lda    $033E
           adc    #$04
           sta    $06
           sec
           lda    $033E,x
           cmp    $06
           bcs    LA5C7
           clc
           lda    $1F20,x
           tay
           lda    LB6C3,y
           lsr    a
           clc
           adc    $033E,x
           sec
           cmp    $033E
           bcc    LA5C7
           clc
           lda    $0300
           jsr    LAFC2
           adc    #$07
           sta    $06
           lda    $0300,x
           jsr    LAFC2
           sec
           cmp    $06
           bcs    LA5C7
           lda    $0300,x
           jsr    LAFC2
           clc
           adc    LA676,y
           sta    $06
           lda    $0300
           jsr    LAFC2
           sec
           cmp    $06
           bcs    LA5C7
           lda    #$80
           sta    $C2
           rts

LA62F:     ldx    #$3E
           stx    $04
LA633:     dec    $04
           ldx    $04
           cpx    #$35
           beq    LA675
           lda    $C2,x
           beq    LA633
           jsr    LB0D2
           cmp    #$01
           bne    LA633
           sec
           lda    $033E,x
           cmp    #$F0
           bcs    LA633
           sec
           cmp    $033E
           bcc    LA633
           lda    $0300
           jsr    LAFC2
           sta    $02
           clc
           adc    #$07
           sta    $06
           lda    $0300,x
           jsr    LAFC2
           sec
           cmp    $06
           bcs    LA633
           sec
           cmp    $02
           bcc    LA633
           lda    #$80
           sta    $C2
LA675:     rts

LA676:     .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$0B,$0B,$0B,$0B
           .byte  $0B,$0B,$07,$09,$09,$01,$01,$09
LA68E:     jsr    LB0A7
           jsr    LB0BD
           inc    $0105
           ldy    $0105
           lda    LBE08,y
           ldx    #$07
LA69F:     sta    $030D,x
           clc
           adc    #$60
           dex
           bpl    LA69F
           iny
           lda    LBE08,y
           ldx    #$07
LA6AE:     sta    $0315,x
           clc
           adc    #$60
           dex
           bpl    LA6AE
           iny
           lda    LBE08,y
           ldx    #$03
LA6BD:     sta    $031D,x
           clc
           adc    #$C0
           dex
           bpl    LA6BD
           iny
           lda    LBE08,y
           sta    $0335
           ldx    #$07
LA6CF:     iny
           lda    LBE08,y
           and    #$2F
           sta    $0353,x
           iny
           lda    LBE08,y
           ora    #$20
           and    #$2F
           sta    $034B,x
           iny
           lda    LBE08,y
           and    #$2F
           sta    $035B,x
           iny
           lda    LBE08,y
           and    #$11
           sta    $50,x
           iny
           lda    LBE08,y
           and    #$01
           sta    $58,x
           lda    #$13
           sta    $1F35,x
           lda    #$12
           sta    $1F2D,x
           lda    #$14
           sta    $1F3D,x
           dex
           bpl    LA6CF
           lda    #$4A
           sta    $0373
           lda    #$17
           sta    $1F55
           rts

LA719:     ldx    $0104
           txa
           clc
           adc    #$02
           and    #$FE
           sta    $44
           sta    $45
           clc
           lsr    a
           sta    $46
           clc
           adc    $44
           sta    $70
           lda    #$00
           adc    $71
           sta    $71
           clc
           lda    $70
           adc    $45
           sta    $70
           lda    #$00
           adc    $71
           sta    $71
           lda    $46
           sec
           cpx    #$10
           bcc    LA74B
           lda    #$08
LA74B:     sta    $47
           sec
           cpx    #$20
           bcc    LA754
           ldx    #$1F
LA754:     lda    LA789,x
           sta    $41
           sta    $42
           txa
           clc
           lsr    a
           tax
           lda    LA7A9,x
           sta    $48
           sta    $49
           lda    LA7B9,x
           sta    $4A
           sta    $4B
           lda    $0104
           clc
           lsr    a
           and    #$0F
           tax
           lda    LA7C9,x
           sta    VIC+$F
           lda    LA7D9,x
           ora    #$0F
           sta    VIC+$E
           lda    LA7E9,x
           sta    $4C
           rts

LA789:     .byte  $50,$4C,$48,$44,$40,$3C,$38,$34
           .byte  $30,$2C,$28,$24,$20,$1C,$18,$14
           .byte  $10,$0C,$08,$07,$06,$05,$04,$03
           .byte  $02,$01,$01,$01,$01,$01,$01,$01
LA7A9:     .byte  $20,$1C,$18,$14,$10,$0D,$0C,$0B
           .byte  $0A,$09,$08,$07,$06,$05,$04,$03
LA7B9:     .byte  $26,$24,$22,$20,$1E,$1C,$1A,$18
           .byte  $16,$14,$12,$10,$0E,$0C,$0A,$08
LA7C9:     .byte  $0A,$0E,$0C,$0F,$6A,$6F,$8E,$DC
           .byte  $BA,$9E,$E9,$9E,$FA,$28,$FE,$1F
LA7D9:     .byte  $60,$20,$50,$20,$70,$00,$00,$00
           .byte  $60,$20,$20,$50,$40,$50,$50,$00
LA7E9:     .byte  $0F,$0F,$09,$0E,$08,$0C,$0F,$0E
           .byte  $0C,$08,$08,$0A,$08,$09,$0C,$0E
           .byte  $60
LA7FA:     lda    $31
           sta    $21
           lda    $61
           clc
           lsr    a
           tay
           lda    LA0A7,y
           sta    $4D
           lda    $C2
           bne    LA813
           lda    #$00
           sta    $17
           jmp    LA991

LA813:     bpl    LA82C
           jmp    LA8D0

LA818:     inc    $C2
           jmp    LA834

LA81D:     lda    $0108
           bne    LA825
           jsr    LB504
LA825:     lda    #$01
           sta    $C2
           jmp    LA834

LA82C:     cmp    #$10
           beq    LA818
           cmp    #$11
           beq    LA81D
LA834:     lda    $07
           beq    LA89D
           bmi    LA86F
           lda    $0A
           cmp    #$43
           bne    LA853
LA840:     lda    #$01
           sta    $17
           inc    $0301
           inc    $0302
           inc    $0303
           inc    $0304
           jmp    LA8A1

LA853:     lda    $0300
           and    #$01
           bne    LA840
           lda    #$01
           sta    $13
           lda    $1F20
           and    #$01
           sta    $1F20
           inc    $0A
           lda    #$00
           sta    $17
           jmp    LA8A1

LA86F:     lda    $0A
           cmp    #$28
           bne    LA888
LA875:     lda    #$FF
           sta    $17
           dec    $0301
           dec    $0302
           dec    $0303
           dec    $0304
           jmp    LA8A1

LA888:     lda    $0300
           and    #$01
           bne    LA875
           lda    #$01
           sta    $12
           lda    $1F20
           ora    #$02
           sta    $1F20
           dec    $0A
LA89D:     lda    #$00
           sta    $17
LA8A1:     lda    $08
           beq    LA8C0
           bmi    LA8B5
           lda    $033E
           cmp    #$02
           beq    LA8C0
           lda    #$01
           sta    $14
           jmp    LA8C0

LA8B5:     lda    $033E
           cmp    #$44
           beq    LA8C0
           lda    #$01
           sta    $15
LA8C0:     ldx    #$00
           lda    $1F20
           eor    #$01
           sta    $1F20
           jsr    LAE23
           jmp    LA991

LA8D0:     lda    #$00
           sta    VIC+$C
           sta    VIC+$B
           sta    VIC+$A
           sta    VIC+$D
           ldx    #$07
LA8E0:     lda    $033E
           sta    $035F,x
           lda    $0300
           sta    $0321,x
           lda    #$01
           sta    $E3,x
           lda    #$17
           sta    $1F41,x
           dex
           bpl    LA8E0
           lda    $0108
           bne    LA90A
           lda    #$80
           sta    VIC+$D
           lda    #$0F
           ora    VIC+$E
           sta    VIC+$E
LA90A:     ldx    #$21
           inc    $14
           jsr    LAE23
           ldx    #$22
           inc    $14
           inc    $13
           jsr    LAE23
           ldx    #$23
           inc    $13
           jsr    LAE23
           ldx    #$24
           inc    $13
           inc    $15
           jsr    LAE23
           ldx    #$25
           inc    $15
           jsr    LAE23
           ldx    #$26
           inc    $15
           inc    $12
           jsr    LAE23
           ldx    #$27
           inc    $12
           jsr    LAE23
           ldx    #$28
           inc    $12
           inc    $14
           jsr    LAE23
LA94A:     inc    $C2
           lda    $C2
           beq    LA981
           lda    $C2
           and    #$07
           bne    LA972
           lda    VIC+$E
           and    #$0F
           sec
           sbc    #$01
           sta    $06
           lda    VIC+$E
           and    #$F0
           ora    $06
           sta    VIC+$E
           lda    VIC+$F
           eor    #$F0
           sta    VIC+$F
LA972:     ldx    #$FF
LA974:     dex
           bne    LA974
           lda    $C2
           sec
           cmp    #$C0
           bcs    LA94A
           jmp    LA90A

LA981:     lda    #$00
           sta    VIC+$D
           lda    VIC+$F
           eor    #$F0
           sta    VIC+$F
           jmp    LA0DB

LA991:     lda    $17
           beq    LA9E2
           lda    #$01
           sta    $4D
           ldx    $0B
           ldy    #$03
           sty    $10
LA99F:     lda    LB68B,y
           sta    $00
           lda    LB6A7,y
           sta    $01
           ldy    LBD04,x
           lda    #$00
           sta    ($00),y
           inx
           ldy    LBD04,x
           sta    ($00),y
           inx
           ldy    LBD04,x
           sta    ($00),y
           inx
           ldy    LBD04,x
           sta    ($00),y
           inx
           inc    $10
           ldy    $10
           cpy    #$19
           bne    LA99F
           lda    $17
           bmi    LA9DA
           ldx    $0B
           inx
           stx    $40
           inc    $0300
           jmp    LA9E2

LA9DA:     ldx    $0B
           dex
           stx    $40
           dec    $0300
LA9E2:     ldx    $40
           ldy    #$03
           sty    $10
LA9E8:     lda    LB68B,y
           sta    $00
           lda    LB6A7,y
           sta    $01
           ldy    LBD04,x
           lda    #$40
           ora    ($00),y
           sta    ($00),y
           inx
           ldy    LBD04,x
           lda    #$10
           ora    ($00),y
           sta    ($00),y
           inx
           ldy    LBD04,x
           lda    #$04
           ora    ($00),y
           sta    ($00),y
           inx
           ldy    LBD04,x
           lda    #$01
           ora    ($00),y
           sta    ($00),y
           inx
           inc    $10
           ldy    $10
           cpy    #$19
           bne    LA9E8
           lda    #$00
           sta    $61
           ldx    #$36
           stx    $04
LAA2A:     dec    $04
           ldx    $04
           cpx    #$04
           bne    LAA38
           jsr    LB170
           jmp    LAA8D

LAA38:     lda    $C2,x
           beq    LAA2A
           clc
           lda    $0B
           adc    #$64
           bcs    LAA53
           sec
           cmp    $0300,x
           bcc    LAA2A
           lda    $0B
           cmp    $0300,x
           bcs    LAA2A
           jmp    LAA60

LAA53:     cmp    $0300,x
           bcs    LAA60
           sec
           lda    $0B
           cmp    $0300,x
           bcs    LAA2A
LAA60:     stx    $16
           inc    $61
           lda    $17
           beq    LAA87
           bmi    LAA70
           jsr    LAF0A
           jmp    LAA73

LAA70:     jsr    LAF5F
LAA73:     lda    $0B
           sta    $02
           lda    $40
           sta    $0B
           ldx    $16
           jsr    LAE91
           lda    $02
           sta    $0B
           jmp    LAA2A

LAA87:     jsr    LAE91
           jmp    LAA2A

LAA8D:     lda    $17
           bne    LAA94
           jmp    LAB8B

LAA94:     ldx    #$3E
           stx    $04
LAA98:     dec    $04
           ldx    $04
           cpx    #$35
           bne    LAAA5
           lda    $40
           sta    $0B
           rts

LAAA5:     lda    $C2,x
           beq    LAA98
           jsr    LB0D2
           cmp    #$01
           bne    LAA98
           lda    $033E,x
           beq    LAA98
           and    #$F0
           cmp    #$F0
           beq    LAA98
           lda    $0300,x
           jsr    LAFC2
           jsr    LB0F9
           sty    $10
           jsr    LB100
           lda    LBE04,x
           eor    #$FF
           sta    $0F
           ldy    $10
           lda    LB68B,y
           sta    $00
           lda    LB6A7,y
           sta    $01
           lda    $0B
           sta    $05
           lda    $40
           sta    $0B
           ldx    $04
           lda    $0300,x
           jsr    LAFC2
           jsr    LB0F9
           sty    $10
           jsr    LB100
           lda    LBE04,x
           sta    $0D
           ldy    $10
           lda    LB68B,y
           sta    $02
           lda    LB6A7,y
           sta    $03
           ldx    $04
           lda    $033E,x
           clc
           asl    a
           tay
           lda    $C2,x
           bmi    LAB29
LAB11:     lda    $0F
           and    ($00),y
           sta    ($00),y
           lda    $0D
           ora    ($02),y
           sta    ($02),y
           dey
           cpy    #$FF
           bne    LAB11
LAB22:     lda    $05
           sta    $0B
           jmp    LAA98

LAB29:     sec
           cmp    #$85
           bcs    LAB4C
           inc    $C2,x
LAB30:     lda    $0F
           and    ($00),y
           sta    ($00),y
           dey
           lda    $0F
           and    ($00),y
           sta    ($00),y
           sec
           cpy    #$F0
           bcs    LAB22
           lda    $0D
           ora    ($02),y
           sta    ($02),y
           dey
           jmp    LAB30

LAB4C:     sec
           cmp    #$89
           bcs    LAB76
           inc    $C2,x
LAB53:     lda    $0F
           and    ($00),y
           sta    ($00),y
           dey
           lda    $0F
           and    ($00),y
           sta    ($00),y
           dey
           lda    $0F
           and    ($00),y
           sta    ($00),y
           sec
           cpy    #$F0
           bcs    LAB22
           lda    $0D
           ora    ($02),y
           sta    ($02),y
           dey
           jmp    LAB53

LAB76:     lda    $0F
           and    ($00),y
           sta    ($00),y
           dey
           cpy    #$FF
           bne    LAB76
           ldx    $04
           lda    #$00
           sta    $C2,x
           jmp    LAB22

LAB8A:     rts

LAB8B:     ldx    #$3E
           stx    $04
LAB8F:     dec    $04
           ldx    $04
           cpx    #$35
           beq    LAB8A
           lda    $C2,x
           beq    LAB8F
           lda    $0300,x
           jsr    LB0D2
           cmp    #$01
           bne    LAB8F
           lda    $033E,x
           beq    LAB8F
           and    #$F0
           cmp    #$F0
           beq    LAB8F
           lda    $0300,x
           jsr    LAFC2
           jsr    LB0F9
           sty    $10
           jsr    LB100
           lda    LBE04,x
           sta    $06
           ldy    $10
           lda    LB68B,y
           sta    $00
           lda    LB6A7,y
           sta    $01
           ldx    $04
           lda    $033E,x
           clc
           asl    a
           tay
           lda    $C2,x
           bmi    LABED
LABDB:     lda    $06
           ora    ($00),y
           sta    ($00),y
           dey
           bne    LABDB
           lda    $06
           ora    ($00),y
           sta    ($00),y
LABEA:     jmp    LAB8F

LABED:     sec
           cmp    #$85
           bcs    LAC0C
           inc    $C2,x
LABF4:     lda    $06
           eor    #$FF
           and    ($00),y
           sta    ($00),y
           dey
           sec
           cpy    #$F0
           bcs    LAB8F
           lda    $06
           ora    ($00),y
           sta    ($00),y
           dey
           jmp    LABF4

LAC0C:     sec
           cmp    #$89
           bcs    LAC34
           inc    $C2,x
LAC13:     lda    $06
           eor    #$FF
           and    ($00),y
           sta    ($00),y
           dey
           lda    $06
           eor    #$FF
           and    ($00),y
           sta    ($00),y
           dey
           sec
           cpy    #$F0
           bcs    LABEA
           lda    $06
           ora    ($00),y
           sta    ($00),y
           dey
           jmp    LAC13

LAC34:     lda    $06
           eor    #$FF
           and    ($00),y
           sta    ($00),y
           dey
           sec
           cpy    #$F0
           bcc    LAC34
           ldx    $04
           lda    #$00
           sta    $C2,x
           jmp    LAB8F

           rts

LAC4C:     lda    $32
           sta    $22
           lda    $09
           cmp    #$01
           bne    LACBE
           lda    $C2
           beq    LACBE
           bmi    LACBE
           cmp    #$11
           beq    LACBE
           ldx    #$04
LAC62:     lda    $C2,x
           beq    LAC6C
           dex
           bne    LAC62
           jmp    LACBE

LAC6C:     lda    #$01
           sta    $C2,x
           lda    #$02
           sta    $09
           lda    #$FF
           sta    $64
           clc
           lda    $033E
           adc    #$03
           sta    $033E,x
           lda    $1F20
           and    #$02
           bne    LACA4
           clc
           lda    $0300
           adc    #$06
           sta    $0300,x
           clc
           lda    $0A
           adc    #$06
           sta    $17,x
           lda    #$01
           sta    $1B,x
           lda    #$09
           sta    $1F20,x
           jmp    LACBE

LACA4:     sec
           lda    $0300
           sbc    #$04
           sta    $0300,x
           sec
           lda    $0A
           sbc    #$04
           sta    $17,x
           clc
           lda    #$FF
           sta    $1B,x
           lda    #$0A
           sta    $1F20,x
LACBE:     ldx    #$05
           stx    $04
LACC2:     dec    $04
           bne    LACC7
           rts

LACC7:     ldx    $04
           lda    $C2,x
           beq    LACC2
           bmi    LACF4
           lda    $1B,x
           bmi    LACE2
           lda    $17,x
           cmp    #$64
           beq    LACF4
           inc    $17,x
           lda    #$01
           sta    $13
           jmp    LACEE

LACE2:     lda    $17,x
           cmp    #$0C
           beq    LACF4
           dec    $17,x
           lda    #$01
           sta    $12
LACEE:     jsr    LAE23
           jmp    LACC2

LACF4:     lda    #$0B
           sta    $1F20,x
           jsr    LAE23
           ldx    $04
           lda    #$00
           sta    $C2,x
           jmp    LACC2

           rts

LAD06:     lda    $33
           sta    $23
           dec    $41
           bne    LAD4F
           lda    $71
           bne    LAD4F
           sec
           lda    $70
           cmp    #$03
           bcc    LAD4F
           lda    $42
           sta    $41
           inc    $0105
           ldx    $0105
           lda    LBE08,x
           clc
           lsr    a
           lsr    a
           adc    #$18
           adc    $0B
           clc
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           tax
           lda    $F8,x
           ora    $C7,x
           beq    LAD41
           lda    #$01
           sta    $41
           jmp    LAD4F

LAD41:     lda    #$01
           sta    $C7,x
           lda    #$F9
           sta    $0343,x
           lda    #$0C
           sta    $1F25,x
LAD4F:     ldx    #$0D
           stx    $04
LAD53:     dec    $04
           ldx    $04
           cpx    #$04
           beq    LADBA
           lda    $C2,x
           beq    LAD53
           bmi    LAD95
           cmp    #$02
           beq    LADA2
           lda    $033E,x
           cmp    #$01
           bne    LAD73
           lda    #$01
           sta    $F3,x
           sta    $036F,x
LAD73:     cmp    #$4B
           bne    LAD83
           lda    #$02
           sta    $C2,x
           lda    #$10
           sta    $1F20,x
           jmp    LAD53

LAD83:     lda    #$01
           sta    $15
           lda    $1F20,x
           eor    #$01
           sta    $1F20,x
           jsr    LAE23
           jmp    LAD53

LAD95:     lda    $F3,x
           beq    LAD53
           bmi    LAD53
           lda    #$80
           sta    $F3,x
           jmp    LAD53

LADA2:     lda    $F3,x
           bne    LAD53
           dec    $4A
           bne    LAD53
           lda    $4B
           sta    $4A
           lda    #$02
           sta    $F3,x
           lda    #$4A
           sta    $036F,x
           jmp    LAD53

LADBA:     ldx    #$3E
           stx    $04
LADBE:     dec    $04
           ldx    $04
           cpx    #$35
           bne    LADC7
           rts

LADC7:     lda    $C2,x
           beq    LADBE
           bmi    LADBE
           cmp    #$02
           beq    LADBE
           inc    $033E,x
           lda    $033E,x
           cmp    #$4A
           bne    LADDF
           lda    #$02
           sta    $C2,x
LADDF:     jsr    LB0D2
           cmp    #$00
           beq    LADBE
           lda    $033E,x
           beq    LADBE
           and    #$F0
           cmp    #$F0
           beq    LADBE
           lda    $0300,x
           jsr    LAFC2
           jsr    LB0F9
           sty    $10
           jsr    LB100
           lda    LBE04,x
           sta    $06
           ldy    $10
           lda    LB68B,y
           sta    $00
           lda    LB6A7,y
           sta    $01
           ldy    $04
           lda    $033E,y
           clc
           asl    a
           tay
           dey
           lda    $06
           sta    ($00),y
           iny
           sta    ($00),y
           jmp    LADBE

LAE23:     stx    $16
           lda    $12
           beq    LAE3F
           jsr    LB0D2
           cmp    #$00
           beq    LAE37
           lda    $C2,x
           beq    LAE37
           jsr    LAF0A
LAE37:     ldx    $16
           dec    $0300,x
           jmp    LAE56

LAE3F:     lda    $13
           beq    LAE56
           jsr    LB0D2
           cmp    #$00
           beq    LAE51
           lda    $C2,x
           beq    LAE51
           jsr    LAF5F
LAE51:     ldx    $16
           inc    $0300,x
LAE56:     lda    $14
           beq    LAE70
           jsr    LB0D2
           cmp    #$00
           beq    LAE68
           lda    $C2,x
           beq    LAE68
           jsr    LAFA1
LAE68:     ldx    $16
           dec    $033E,x
           jmp    LAE87

LAE70:     lda    $15
           beq    LAE87
           jsr    LB0D2
           cmp    #$00
           beq    LAE82
           lda    $C2,x
           beq    LAE82
           jsr    LAF7D
LAE82:     ldx    $16
           inc    $033E,x
LAE87:     lda    #$00
           sta    $12
           sta    $13
           sta    $14
           sta    $15
LAE91:     jsr    LB0D2
           cmp    #$00
           beq    LAE9C
           lda    $C2,x
           bne    LAE9D
LAE9C:     rts

LAE9D:     lda    $033E,x
           clc
           asl    a
           sta    $0C
           lda    $1F20,x
           sta    $11
           tay
           lda    LB6C3,y
           sta    $0D
           sta    $0E
           lda    LB6DB,y
           sta    $0F
           lda    $0300,x
           jsr    LAFC2
           jsr    LB0F9
           sty    $10
           jsr    LB100
           ldy    $11
           cmp    #$00
           bne    LAED3
           lda    LB6F3,y
           ldx    LB70B,y
           jmp    LAEF3

LAED3:     cmp    #$01
           bne    LAEE0
           lda    LB723,y
           ldx    LB73B,y
           jmp    LAEF3

LAEE0:     cmp    #$02
           bne    LAEED
           lda    LB753,y
           ldx    LB76B,y
           jmp    LAEF3

LAEED:     lda    LB783,y
           ldx    LB79B,y
LAEF3:     sta    $03C6
           stx    $03C7
           ldy    $10
           lda    LB68B,y
           sta    $03C9
           lda    LB6A7,y
           sta    $03CA
           jmp    $03BC

LAF0A:     lda    $0300,x
           jsr    LAFC2
           jsr    LB0F9
           sty    $10
           jsr    LB100
           cmp    #$00
           bne    LAF5E
           ldx    $16
           lda    $033E,x
           clc
           asl    a
           sta    $0C
           lda    $1F20,x
           tay
           clc
           lda    $10
           adc    LB6DB,y
           sec
           sbc    #$01
           sta    $10
LAF34:     lda    $1F20,x
           tay
           lda    LB6C3,y
           sta    $0D
           sta    $0E
           lda    #$01
           sta    $0F
LAF43:     lda    #<LB875
           sta    $03C6
           lda    #>LB875
           sta    $03C7
           ldy    $10
           lda    LB68B,y
           sta    $03C9
           lda    LB6A7,y
           sta    $03CA
           jmp    $03BC

LAF5E:     rts

LAF5F:     lda    $0300,x
           jsr    LAFC2
           jsr    LB0F9
           sty    $10
           jsr    LB100
           cmp    #$03
           bne    LAF5E
           ldx    $16
           lda    $033E,x
           clc
           asl    a
           sta    $0C
           jmp    LAF34

LAF7D:     lda    $033E,x
           clc
           asl    a
           sta    $0C
LAF84:     lda    $1F20,x
           tay
           lda    LB6DB,y
           sta    $0F
           lda    #$02
           sta    $0D
           sta    $0E
           lda    $0300,x
           jsr    LAFC2
           jsr    LB0F9
           sty    $10
           jmp    LAF43

LAFA1:     lda    $1F20,x
           tay
           lda    $033E,x
           clc
           asl    a
           clc
           adc    LB6C3,y
           sec
           sbc    #$02
           sta    $0C
           jmp    LAF84

LAFB6:     ldx    #$33
LAFB8:     lda    LAFC7,x
           sta    $03BC,x
           dex
           bpl    LAFB8
           rts

LAFC2:     sec
           sbc    $0B
           clc
           rts
        
        ;; this code gets copied to $03BC and runs from there
LAFC7:     ldx    #$00
           ldy    $0C
LAFCB:     sec
           cpy    #$9F
           bcs    LAFD6
           lda    $FFFF,x       ; argument is at $03C6/$03C7
           sta    $0000,y       ; argument is at $03C9/$03CA
LAFD6:     inx
           iny
           dec    $0E
           bne    LAFCB
           lda    $0D
           sta    $0E
           dec    $0F
           beq    LAFF7
           inc    $10
           ldy    $10
           lda    LB68B,y
           sta    $03C9
           lda    LB6A7,y
           sta    $03CA
           jmp    $03BE
LAFF7:     rts

           .byte  $00,$00,$FF,$FF,$00,$00,$FF,$FF
        
        ;; set whole charset memory to 0
LB000:     ldy    #$00
           tya
           sta    $00
           lda    #>CHARSET
           sta    $01
LB009:     lda    #$00
LB00B:     sta    ($00),y
           iny
           bne    LB00B
           inc    $01
           lda    $01
           cmp    #>CHARSET+$10
           bne    LB009
           rts

        ;; init VIC:
        ;; 16x8 (i.e. double-height) character size
        ;; 
        ;; 11 (double-height) rows, 22 columns
        ;; character map at $1000
        ;; screen memory at $0200-$02F1
        ;; color at $9600-$96F1
LB019:     ldx    #$0D
LB01B:     lda    LB025,x
           sta    VIC+$0,x
           dex
           bpl    LB01B
           rts
LB025:     .byte  $05,$1B,$96,$17,$00,$8C,$00,$00
           .byte  $00,$00,$00,$00,$00,$00
        
LB033:     lda    $4C
           sta    $06
           lda    #>COLORRAM
           jsr    LB067
           ldx    #$15
           lda    $06
           and    #$07
           sta    $06
LB044:     lda    $06
           sta    COLORRAM+$DC,x
           dex
           bpl    LB044
           rts

LB04D:     lda    #$00
           sta    $06
           tay
LB052:     lda    $06
           ldx    #$15
LB056:     sta    SCREEN,y
           clc
           adc    #$0B
           iny
           dex
           bpl    LB056
           inc    $06
           cpy    #$F2
           bne    LB052
           rts

        ;; fill one page at $[AA]00 with content of $06
LB067:     sta    $01
           lda    #$00
           sta    $00
           tay
           lda    $06
LB070:     sta    ($00),y
           iny
           bne    LB070
           rts

LB076:     lda    #$00
           sta    $06
           jsr    LB067
           lda    #$00
           sta    VIC+$A
           sta    VIC+$B
           sta    VIC+$C
           sta    VIC+$D
           rts

LB08C:     ldx    #$0D
LB08E:     lda    LB099,x
           sta    $20,x
           sta    $30,x
           dex
           bpl    LB08E
           rts

LB099:     .byte  $50,$10,$07,$2C,$34,$43,$45,$0C
           .byte  $58,$06,$FF,$FF,$1A,$10
LB0A7:     lda    #$10
           sta    $C2
           lda    #$01
           sta    $1F20
           lda    #$38
           sta    $0300
           sta    $0A
           lda    #$28
           sta    $033E
           rts

LB0BD:     lda    #$00
           tax
LB0C0:     sta    $0305,x
           clc
           adc    #$04
           sta    $0336,x
           clc
           adc    #$1C
           inx
           cpx    #$08
           bne    LB0C0
           rts

LB0D2:     clc
           lda    $0B
           adc    #$64
           bcs    LB0E9
           sec
           cmp    $0300,x
           bcc    LB0F6
           lda    $0B
           cmp    $0300,x
           bcs    LB0F6
LB0E6:     lda    #$01
           rts

LB0E9:     cmp    $0300,x
           bcs    LB0E6
           sec
           lda    $0B
           cmp    $0300,x
           bcc    LB0E6
LB0F6:     lda    #$00
           rts

LB0F9:     pha
           clc
           lsr    a
           lsr    a
           tay
           pla
           rts

LB100:     pha
           tya
           asl    a
           asl    a
           sta    $06
           sec
           pla
           sbc    $06
           tax
           rts

LB10C:     ldx    #$04
           lda    #$02
           stx    $04
           sta    $05
LB114:     jsr    LB152
           inc    $04
           inc    $05
           lda    $05
           ldx    $04
           cpx    #$09
           bne    LB114
           ldx    #$0B
           lda    #$00
           stx    $04
           sta    $05
LB12B:     jsr    LB152
           inc    $04
           inc    $05
           lda    $05
           ldx    $04
           cpx    #$12
           bne    LB12B
           ldx    #$14
           lda    #$07
           stx    $04
           sta    $05
LB142:     jsr    LB152
           inc    $04
           inc    $05
           lda    $05
           ldx    $04
           cpx    #$18
           bne    LB142
           rts

LB152:     pha
           lda    LB68B,x
           sta    $00
           lda    LB6A7,x
           sta    $01
           pla
           asl    a
           asl    a
           asl    a
           tax
           ldy    #$A0
LB164:     lda    LBF08,x
           sta    ($00),y
           inx
           iny
           cpy    #$A7
           bne    LB164
           rts

LB170:     lda    $30
           sta    $20
           lda    $0108
           beq    LB17C
           jmp    LB233

LB17C:     lda    #$00
           sta    VIA2+$C
           sta    VIA2+$2
           lda    #$FF
           sta    VIA2+$3
           lda    #$FD
           sta    VIA2+$1
           lda    VIA2+$0
           sta    $04
           lda    #$DF
           sta    VIA2+$1
           lda    VIA2+$0
           sta    $05
           lda    #$FE
           sta    VIA2+$1
           lda    VIA2+$0
           sta    $06
           ldy    #$FF
           lda    JOY_REG_OTHER
           and    #JOY_MASK_LEFT
           beq    LB1D3
           lda    $05
           and    #$08          ; , => LEFT
           beq    LB1D3
           ldy    #$01
           lda    #$00
           sta    VIA2+$3
           lda    #$7F
           sta    VIA2+$2
           lda    JOY_REG_RIGHT
           and    #JOY_MASK_RIGHT
           beq    LB1D3
           lda    $05
           and    #$10          ; . => RIGHT
           beq    LB1D3
           dey
           inc    $0105
LB1D3:     sty    $07
           ldy    #$FF
           lda    JOY_REG_OTHER
           and    #JOY_MASK_DOWN
           beq    LB1F7
           lda    $04           ; Z => DOWN
           and    #$10
           beq    LB1F7
           ldy    #$01
           lda    JOY_REG_OTHER
           and    #JOY_MASK_UP
           beq    LB1F7
           lda    $04           ; A => UP
           and    #$04
           beq    LB1F7
           dey
           inc    $0105
LB1F7:     sty    $08
           lda    $09
           bne    LB21E
           ldy    #$01
           lda    JOY_REG_OTHER
           and    #JOY_MASK_BUTTON
           beq    LB210
           lda    $06
           and    #$10          ; SPACE => BUTTON
           beq    LB210
           dey
           inc    $0105
LB210:     sty    $09
LB212:     jsr    LB449
           lda    $05
           and    #$02
           bne    LB275
           jmp    LA163

LB21E:     ldy    #$00
           inc    $0105
           lda    JOY_REG_OTHER
           and    #JOY_MASK_BUTTON
           beq    LB212
           lda    $06
           and    #$10
           beq    LB212
           jmp    LB210

LB233:     jsr    LB449
           inc    $0105
           ldy    $0105
           lda    #$01
           sta    $07
           lda    $08
           bne    LB248
           lda    #$01
           sta    $08
LB248:     iny
           lda    LBE08,y
           and    #$E3
           beq    LB25C
           inc    $0105
           inc    $0105
           inc    $0105
           jmp    LB262

LB25C:     lda    $08
           eor    #$FF
           sta    $08
LB262:     iny
           lda    LBE08,y
           and    #$E0
           bne    LB275
           lda    #$01
           sta    $09
           lda    JOY_REG_OTHER
           and    #JOY_MASK_BUTTON
           beq    LB297
LB275:     lda    $C2
           cmp    #$10
           beq    LB28D
           cmp    #$11
           beq    LB28D
           lda    $63
           cmp    #$01
           beq    LB28E
           cmp    #$03
           beq    LB291
           cmp    #$05
           beq    LB297
LB28D:     rts

LB28E:     jmp    LA009

LB291:     ldx    #$FF
           txs
           jmp    LB396

LB297:     ldx    #$FF
           txs
           lda    #$00
           sta    $0108
           jmp    LB430

LB2A2:     ldy    $0108
           bne    LB2B2
           sed
           clc
           adc    $0100
           sta    $0100
           bcs    LB2B3
           cld
LB2B2:     rts

LB2B3:     lda    #$00
           adc    $0101
           sta    $0101
           and    #$0F
           bne    LB2CA
           clc
           lda    $0106
           adc    #$01
           sta    $0106
           inc    $6C
LB2CA:     cld
           jsr    LB37D
           rts

LB2CF:     lda    $3B
           sta    $2B
           ldx    #$04
           lda    $0101
           jsr    LB304
           jsr    LB30C
           ldx    #$05
           lda    $0101
           and    #$0F
           jsr    LB30C
           ldx    #$06
           lda    $0100
           jsr    LB304
           jsr    LB30C
           ldx    #$07
           lda    $0100
           and    #$0F
           jsr    LB30C
           ldx    #$08
           lda    #$00
           jmp    LB30C

LB304:     and    #$F0
           clc
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           rts

        ;; copy font character for digit "0"-"9" (specified in A)
        ;; into character set at location specified in X
LB30C:     pha
           lda    LB68B,x
           sta    $00
           lda    LB6A7,x
           sta    $01
           pla
           asl    a
           asl    a
           asl    a
           tax
           ldy    #$A8
LB31E:     lda    LBFA0,x
           sta    ($00),y
           inx
           iny
           cpy    #$AF
           bne    LB31E
           rts

LB32A:     sec
           lda    $0101
           cmp    $0103
           beq    LB338
           bcc    LB34C
           jmp    LB340

LB338:     lda    $0100
           cmp    $0102
           bcc    LB34C
LB340:     lda    $0100
           sta    $0102
           lda    $0101
           sta    $0103
LB34C:     ldx    #$0C
           lda    $0103
           jsr    LB304
           jsr    LB30C
           ldx    #$0D
           lda    $0103
           and    #$0F
           jsr    LB30C
           ldx    #$0E
           lda    $0102
           jsr    LB304
           jsr    LB30C
           ldx    #$0F
           lda    $0102
           and    #$0F
           jsr    LB30C
           ldx    #$10
           lda    #$00
           jmp    LB30C

LB37D:     ldx    #$15
           lda    $0106
           jsr    LB304
           cmp    #$00
           beq    LB38C
           jsr    LB30C
LB38C:     ldx    #$16
           lda    $0106
           and    #$0F
           jmp    LB30C

        ;; init game
LB396:     jsr    LB076         ; clear zero page and VIC voices
           jsr    LB04D         ; init screen pattern
           jsr    LB000         ; clear character set memory
           lda    #$00
           sta    $0104
           jsr    LA719
           lda    #$07
           sta    $4C
           jsr    LB033
           jsr    LB019
           jsr    LB10C
           lda    #$00
           sta    $0108
           jsr    LB2CF
           jsr    LB32A
           lda    #$03
           sta    $0106
           jsr    LB37D
           jsr    LB52B
           lda    $0109
           and    #$03
           bne    LB3DB
           jsr    LB49A
           lda    #<LB61F
           ldy    #>LB61F
           jsr    LB571
LB3DB:     lda    #$19
           sta    $00
           inc    $0109
LB3E2:     jsr    LB449
           lda    #$0F
           ora    VIC+$E
           sta    VIC+$E
           jsr    LB481
           inc    $0105
           lda    $63
           cmp    #$01
           beq    LB446
           cmp    #$05
           beq    LB430
           lda    #$FF
           sta    $02
LB401:     ldx    #$0A
LB403:     jsr    LB449
           lda    JOY_REG_OTHER
           and    #JOY_MASK_BUTTON
           beq    LB430
           lda    $63
           cmp    #$05
           beq    LB430
           dex
           bne    LB403
           dec    $02
           bne    LB401
           dec    $00
           lda    $00
           bne    LB3E2
           lda    #$01
           sta    $0108
           lda    #$00
           sta    $0104
           sta    $0106
           jmp    LA01E

LB430:     lda    $0107
           sta    $0104
           lda    #$00
           sta    $0100
           sta    $0101
           lda    #$02
           sta    $0106
           jmp    LA01E

LB446:     jmp    LA009

LB449:     lda    #$FF
           sta    VIA2+$3
           lda    #$00
           sta    VIA2+$C
           sta    VIA2+$2
           lda    #$7F
           sta    VIA2+$1
           lda    VIA2+$0
           tay
           and    #$10          ; F1?
           bne    LB468
           lda    #$01
           sta    $63
           rts

LB468:     tya
           and    #$20          ; F3?
           bne    LB472
           lda    #$03
           sta    $63
           rts

LB472:     tya
           and    #$40          ; F5?
           bne    LB47C
           lda    #$05
           sta    $63
           rts

LB47C:     lda    #$00
           sta    $63
           rts

LB481:     lda    $63
           cmp    #$03
           bne    LB49A
           lda    #$20
           sta    $00
           inc    $0107
           lda    $0107
           cmp    #$0A
           bne    LB49A
           lda    #$00
           sta    $0107
LB49A:     lda    $0107
           asl    a
           asl    a
           asl    a
           tax
           ldy    #$00
LB4A3:     lda    LBFA0,x
           sta    CHARSET+$6E3,y
           inx
           iny
           cpy    #$08
           bne    LB4A3
           lda    #$07
           sta    COLORRAM+$0A
           rts

LB4B5:     rts

LB4B6:     lda    $3D
           sta    $2D
           lda    $0108
           bne    LB4B5
           lda    $64
           beq    LB4D6
           sta    VIC+$C
           sec
           sbc    #$01
           sta    $64
           cmp    #$EF
           bne    LB4D6
           lda    #$00
           sta    $64
           sta    VIC+$C
LB4D6:     lda    $65
           beq    LB4F0
           lda    VIC+$E
           and    #$0F
           sec
           sbc    #$01
           bmi    LB4F1
           sta    $06
           lda    VIC+$E
           and    #$F0
           ora    $06
           sta    VIC+$E
LB4F0:     rts

LB4F1:     lda    #$00
           sta    VIC+$D
           sta    VIC+$B
           sta    $65
           lda    #$0F
           ora    VIC+$E
           sta    VIC+$E
           rts

LB504:     lda    #$07
           sta    $00
LB508:     lda    #$D7
           sta    VIC+$C
LB50D:     ldx    #$FF
LB50F:     ldy    #$06
LB511:     dey
           bne    LB511
           dex
           bne    LB50F
           inc    VIC+$C
           lda    VIC+$C
           cmp    #$F5
           bne    LB50D
           dec    $00
           bne    LB508
           lda    #$00
           sta    VIC+$C
           rts

LB52B:     lda    #$06
           sta    $10
           ldx    #$00
           stx    $02
LB533:     ldy    $10
           lda    LB68B,y
           sta    $00
           lda    LB6A7,y
           sta    $01
           ldx    $02
           lda    LB561,x
           beq    LB55E
           asl    a
           asl    a
           asl    a
           tax
           inc    $02
           inc    $10
           ldy    #$30
LB550:     lda    LBF08,x
           sta    ($00),y
           inx
           iny
           cpy    #$38
           bne    LB550
           jmp    LB533

LB55E:     jmp    LA120

LB561:     .byte  $02,$11,$01,$0E,$06,$05,$02,$0B
           .byte  $04,$07,$0B,$10,$0C,$05,$02,$00
LB571:     sta    $66
           sty    $67
           jsr    LB5E5
           ldy    #$00
           lda    ($66),y
           sta    $68
           iny
           lda    ($66),y
           sta    $69
LB583:     iny
           lda    ($66),y
           beq    LB5E5
           ldx    $68
           sta    VIC+$A,x
           lda    #$F0
           and    VIC+$E
           sta    VIC+$E
LB595:     lda    $69
           jsr    LB5F4
           clc
           lda    VIC+$E
           and    #$0F
           adc    #$01
           sta    $06
           lda    VIC+$E
           and    #$F0
           ora    $06
           sta    VIC+$E
           lda    $06
           cmp    #$0F
           bne    LB595
           iny
           lda    ($66),y
           sta    $6A
LB5B9:     jsr    LB602
           dec    $6A
           bne    LB5B9
           iny
           lda    ($66),y
           sta    $6B
LB5C5:     lda    $6B
           jsr    LB611
           lda    VIC+$E
           and    #$0F
           sec
           sbc    #$01
           sta    $06
           lda    VIC+$E
           and    #$F0
           ora    $06
           sta    VIC+$E
           lda    $06
           bne    LB5C5
           jmp    LB583

LB5E5:     lda    #$00
           sta    VIC+$A
           sta    VIC+$B
           sta    VIC+$C
           sta    VIC+$D
           rts

LB5F4:     sty    $00
           tay
LB5F7:     ldx    #$20
LB5F9:     dex
           bne    LB5F9
           dey
           bne    LB5F7
           ldy    $00
           rts

LB602:     sty    $00
           ldy    #$40
LB606:     ldx    #$40
LB608:     dex
           bne    LB608
           dey
           bne    LB606
           ldy    $00
           rts

LB611:     sty    $00
           tay
LB614:     ldx    #$FF
LB616:     dex
           bne    LB616
           dey
           bne    LB614
           ldy    $00
           rts

LB61F:     .byte  $01,$0F,$ED,$02,$03,$EB,$02,$03
           .byte  $ED,$46,$3C,$64,$26,$02,$EB,$01
           .byte  $02,$E8,$01,$04,$E7,$01,$06,$E3
           .byte  $14,$1E,$E4,$1E,$5A,$00
LB63D:     .byte  $02,$08,$AF,$03,$04,$C3,$03,$04
           .byte  $CF,$03,$05,$D7,$08,$0C,$CF,$04
           .byte  $05,$D7,$08,$0F,$00
LB652:     .byte  $02,$08,$87,$05,$06,$93,$05,$07
           .byte  $9F,$05,$06,$93,$05,$06,$87,$05
           .byte  $07,$93,$05,$07,$9F,$05,$15,$87
           .byte  $05,$15,$87,$05,$15,$00
LB670:     .byte  $01,$0A,$64,$10,$02,$E4,$05,$0A
           .byte  $E7,$06,$0A,$E8,$06,$0A,$E4,$06
           .byte  $0A,$EB,$09,$19,$E4,$09,$2D,$64
           .byte  $08,$10,$00
LB68B:     .byte  $00,$00,$00,$00,$B0,$60,$10,$C0
           .byte  $70,$20,$D0,$80,$30,$E0,$90,$40
           .byte  $F0,$A0,$50,$00,$B0,$60,$10,$C0
           .byte  $70,$00,$00,$00
LB6A7:     .byte  $40,$40,$40,>CHARSET+$0,>CHARSET+$0,>CHARSET+$1,>CHARSET+$2,>CHARSET+$2
           .byte  >CHARSET+$3,>CHARSET+$4,>CHARSET+$4,>CHARSET+$5,>CHARSET+$6,>CHARSET+$6,>CHARSET+$7,>CHARSET+$8
           .byte  >CHARSET+$8,>CHARSET+$9,>CHARSET+$A,>CHARSET+$B,>CHARSET+$B,>CHARSET+$C,>CHARSET+$D,>CHARSET+$D
           .byte  >CHARSET+$E,$40,$40,$40
        
LB6C3:     .byte  $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
           .byte  $0A,$01,$01,$01,$10,$10,$10,$10
           .byte  $0A,$0A,$0B,$09,$09,$02,$02,$05
LB6DB:     .byte  $03,$03,$03,$03,$03,$03,$03,$03
           .byte  $03,$02,$02,$02,$03,$03,$03,$03
           .byte  $03,$03,$03,$03,$03,$01,$01,$02

LB6F3:     .byte  <LB7B3,<LB82B,<LB89D,<LB909,$00   ,$00   ,$00   ,$00   
           .byte  <LB875,<LB978,<LB980,<LB875,<LB988,<LBA48,$00   ,<LB875
           .byte  <LBB08,<LB875,<LBB7B,<LBBFC,<LBC68,<LBCD4,<LB875,<LBCDC
LB70B:     .byte  >LB7B3,>LB82B,>LB89D,>LB909,$00   ,$00   ,$00   ,$00   
           .byte  >LB875,>LB978,>LB980,>LB875,>LB988,>LBA48,$00   ,>LB875
           .byte  >LBB08,>LB875,>LBB7B,>LBBFC,>LBC68,>LBCD4,>LB875,>LBCDC
LB723:     .byte  <LB7D1,<LB846,<LB8B8,<LB924,$00   ,$00   ,$00   ,$00   
           .byte  <LB875,<LB97A,<LB982,<LB875,<LB9B8,<LBA78,$00   ,<LB875
           .byte  <LBB25,<LB875,<LBB9A,<LBC17,<LBC83,<LBCD6,<LB875,<LBCE6
LB73B:     .byte  >LB7D1,>LB846,>LB8B8,>LB924,$00   ,$00   ,$00   ,$00   
           .byte  >LB875,>LB97A,>LB982,>LB875,>LB9B8,>LBA78,$00   ,>LB875
           .byte  >LBB25,>LB875,>LBB9A,>LBC17,>LBC83,>LBCD6,>LB875,>LBCE6
LB753:     .byte  <LB7EF,<LB861,<LB8D3,<LB93F,$00   ,$00   ,$00   ,$00   
           .byte  <LB875,<LB97C,<LB984,<LB875,<LB9E8,<LBAA8,$00   ,<LB875
           .byte  <LBB41,<LB875,<LBBBB,<LBC32,<LBC9E,<LBCD8,<LB875,<LBCF0
LB76B:     .byte  >LB7EF,>LB861,>LB8D3,>LB93F,$00   ,$00   ,$00   ,$00   
           .byte  >LB875,>LB97C,>LB984,>LB875,>LB9E8,>LBAA8,$00   ,>LB875
           .byte  >LBB41,>LB875,>LBBBB,>LBC32,>LBC9E,>LBCD8,>LB875,>LBCF0
LB783:     .byte  <LB80D,<LB87F,<LB8EE,<LB95A,$00   ,$00   ,$00   ,$00   
           .byte  <LB875,<LB97E,<LB986,<LB875,<LBA18,<LBAD8,$00   ,<LB875
           .byte  <LBB5D,<LB875,<LBBDB,<LBC4D,<LBCB9,<LBCDA,<LB875,<LBCFA
LB79B:     .byte  >LB80D,>LB87F,>LB8EE,>LB95A,$00   ,$00   ,$00   ,$00   
           .byte  >LB875,>LB97E,>LB986,>LB875,>LBA18,>LBAD8,$00   ,>LB875
           .byte  >LBB5D,>LB875,>LBBDB,>LBC4D,>LBCB9,>LBCDA,>LB875,>LBCFA        
                
LB7B3:     .byte  $80,$A0,$A8,$2A,$0A,$3D,$37,$3F
           .byte  $08,$20,$00,$00,$00,$10,$D0,$F0
           .byte  $F0,$C0,$80,$20,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00
LB7D1:     .byte  $20,$28,$2A,$0A,$02,$0F,$0D,$0F
           .byte  $02,$08,$00,$00,$00,$84,$B4,$7C
           .byte  $FC,$F0,$20,$08,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00
LB7EF:     .byte  $08,$0A,$0A,$02,$00,$03,$03,$03
           .byte  $00,$02,$00,$00,$80,$A1,$AD,$DF
           .byte  $7F,$FC,$88,$02,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00
LB80D:     .byte  $02,$02,$02,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$80,$A0,$A8,$2B,$F7
           .byte  $DF,$FF,$22,$80,$00,$00,$00,$40
           .byte  $40,$C0,$C0,$00,$00,$80
LB82B:     .byte  $00,$00,$00,$2A,$0A,$3D,$37,$3F
           .byte  $08,$20,$00,$00,$00,$10,$D0,$F0
           .byte  $F0,$C0,$80,$20,$00,$00,$00,$00
           .byte  $00,$00,$00
LB846:     .byte  $00,$00,$00,$0A,$02,$0F,$0D,$0F
           .byte  $02,$08,$00,$00,$00,$84,$B4,$7C
           .byte  $FC,$F0,$20,$08,$00,$00,$00,$00
           .byte  $00,$00,$00
LB861:     .byte  $00,$00,$00,$02,$00,$03,$03,$03
           .byte  $00,$02,$00,$00,$00,$A1,$AD,$DF
           .byte  $7F,$FC,$88,$02
LB875:     .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00
LB87F:     .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$A8,$2B,$F7
           .byte  $DF,$FF,$22,$80,$00,$00,$00,$40
           .byte  $40,$C0,$C0,$00,$00,$80
LB89D:     .byte  $00,$00,$02,$4A,$7A,$F7,$FD,$3F
           .byte  $22,$80,$20,$A0,$A0,$80,$00,$C0
           .byte  $C0,$C0,$00,$80,$00,$00,$00,$00
           .byte  $00,$00,$00
LB8B8:     .byte  $00,$00,$00,$12,$1E,$3D,$3F,$0F
           .byte  $08,$20,$08,$28,$A8,$A0,$80,$F0
           .byte  $70,$F0,$80,$20,$00,$00,$00,$00
           .byte  $00,$00,$00
LB8D3:     .byte  $00,$00,$00,$04,$07,$0F,$0F,$03
           .byte  $02,$08,$02,$0A,$2A,$A8,$A0,$7C
           .byte  $DC,$FC,$20,$08,$00,$00,$00,$00
           .byte  $00,$00,$00
LB8EE:     .byte  $00,$00,$00,$01,$01,$03,$03,$00
           .byte  $00,$02,$00,$02,$0A,$2A,$E8,$DF
           .byte  $F7,$FF,$88,$02,$80,$80,$80,$00
           .byte  $00,$00,$00
LB909:     .byte  $00,$00,$00,$4A,$7A,$F7,$FD,$3F
           .byte  $22,$80,$00,$00,$00,$80,$00,$C0
           .byte  $C0,$C0,$00,$80,$00,$00,$00,$00
           .byte  $00,$00,$00
LB924:     .byte  $00,$00,$00,$12,$1E,$3D,$3F,$0F
           .byte  $08,$20,$00,$00,$00,$A0,$80,$F0
           .byte  $70,$F0,$80,$20,$00,$00,$00,$00
           .byte  $00,$00,$00
LB93F:     .byte  $00,$00,$00,$04,$07,$0F,$0F,$03
           .byte  $02,$08,$00,$00,$00,$A8,$A0,$7C
           .byte  $DC,$FC,$20,$08,$00,$00,$00,$00
           .byte  $00,$00,$00
LB95A:     .byte  $00,$00,$00,$01,$01,$03,$03,$00
           .byte  $00,$02,$00,$00,$00,$2A,$E8,$DF
           .byte  $F7,$FF,$88,$02,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00
LB978:     .byte  $5E,$00
LB97A:     .byte  $27,$80
LB97C:     .byte  $05,$E0
LB97E:     .byte  $01,$78
LB980:     .byte  $B5,$00
LB982:     .byte  $2D,$40
LB984:     .byte  $0B,$50
LB986:     .byte  $02,$D4
LB988:     .byte  $00,$01,$05,$07,$05,$87,$85,$81
           .byte  $20,$09,$81,$29,$01,$09,$22,$82
           .byte  $40,$50,$54,$F4,$D4,$F4,$54,$50
           .byte  $42,$58,$D0,$5A,$D0,$58,$22,$20
           .byte  $00,$00,$00,$00,$00,$80,$80,$80
           .byte  $00,$00,$80,$00,$00,$00,$00,$80
LB9B8:     .byte  $00,$00,$01,$01,$01,$21,$21,$20
           .byte  $08,$02,$20,$0A,$00,$02,$08,$20
           .byte  $10,$54,$55,$FD,$75,$FD,$55,$54
           .byte  $10,$56,$74,$56,$74,$56,$88,$88
           .byte  $00,$00,$00,$00,$00,$20,$20,$20
           .byte  $80,$00,$20,$80,$00,$00,$80,$20
LB9E8:     .byte  $00,$00,$00,$00,$00,$08,$08,$08
           .byte  $02,$00,$08,$02,$00,$00,$02,$08
           .byte  $04,$15,$55,$7F,$5D,$7F,$55,$15
           .byte  $04,$95,$1D,$95,$1D,$95,$22,$22
           .byte  $00,$00,$40,$40,$40,$48,$48,$08
           .byte  $20,$80,$08,$A0,$00,$80,$20,$08
LBA18:     .byte  $00,$00,$00,$00,$00,$02,$02,$02
           .byte  $00,$00,$02,$00,$00,$00,$00,$02
           .byte  $01,$05,$15,$1F,$17,$1F,$15,$05
           .byte  $81,$25,$07,$A5,$07,$25,$88,$08
           .byte  $00,$40,$50,$D0,$50,$D2,$52,$42
           .byte  $08,$60,$42,$68,$40,$60,$88,$82
LBA48:     .byte  $00,$01,$05,$07,$05,$07,$05,$01
           .byte  $80,$89,$21,$89,$21,$89,$22,$02
           .byte  $40,$50,$54,$F4,$D4,$F4,$54,$50
           .byte  $40,$58,$D2,$58,$D2,$58,$22,$20
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $80,$80,$00,$80,$00,$80,$00,$00
LBA78:     .byte  $00,$00,$01,$01,$01,$01,$01,$00
           .byte  $20,$22,$08,$22,$08,$22,$08,$00
           .byte  $10,$54,$55,$FD,$75,$FD,$55,$54
           .byte  $10,$56,$74,$56,$74,$56,$88,$88
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $20,$20,$80,$20,$80,$20,$80,$00
LBAA8:     .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $08,$08,$02,$08,$02,$08,$02,$00
           .byte  $04,$15,$55,$7F,$5D,$7F,$55,$15
           .byte  $04,$95,$1D,$95,$1D,$95,$22,$22
           .byte  $00,$00,$40,$40,$40,$40,$40,$00
           .byte  $08,$88,$20,$88,$20,$88,$20,$00
LBAD8:     .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $02,$02,$00,$02,$00,$02,$00,$00
           .byte  $01,$05,$15,$1F,$17,$1F,$15,$05
           .byte  $01,$25,$87,$25,$87,$25,$88,$08
           .byte  $00,$40,$50,$D0,$50,$D0,$50,$40
           .byte  $02,$62,$48,$62,$48,$62,$88,$80
LBB08:     .byte  $02,$09,$21,$89,$20,$85,$87,$05
           .byte  $01,$00,$20,$58,$D2,$58,$42,$54
           .byte  $F4,$54,$50,$40,$00,$00,$00,$80
           .byte  $00,$80,$80,$00,$00
LBB25:     .byte  $00,$02,$08,$22,$08,$21,$21,$01
           .byte  $00,$00,$88,$56,$74,$56,$10,$55
           .byte  $FD,$55,$54,$10,$00,$00,$80,$20
           .byte  $80,$20,$20,$00
LBB41:     .byte  $00,$00,$02,$08,$02,$08,$08,$00
           .byte  $00,$00,$22,$95,$1D,$95,$04,$55
           .byte  $7F,$55,$15,$04,$00,$80,$20,$88
           .byte  $20,$48,$48,$40
LBB5D:     .byte  $00,$00,$00,$02,$00,$02,$02,$00
           .byte  $00,$00,$08,$25,$87,$25,$81,$15
           .byte  $1F,$15,$05,$01,$80,$60,$48,$62
           .byte  $08,$52,$D2,$50,$40,$00
LBB7B:     .byte  $C1,$F2,$F1,$FD,$FD,$FD,$3D,$3D
           .byte  $3D,$31,$01,$10,$63,$53,$5F,$5F
           .byte  $5F,$5F,$5F,$5F,$13,$10,$C0,$C0
           .byte  $C0,$C0,$C0,$C0,$00,$00,$00
LBB9A:     .byte  $00,$00,$0C,$3F,$3F,$3F,$3F,$3F
           .byte  $3F,$3C,$30,$44,$98,$54,$57,$57
           .byte  $57,$57,$57,$57,$44,$44,$00,$00
           .byte  $C0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
           .byte  $30
LBBBB:     .byte  $0C,$0F,$0F,$0F,$0F,$0F,$03,$03
           .byte  $03,$03,$00,$11,$26,$15,$D5,$D5
           .byte  $D5,$D5,$D5,$D5,$11,$11,$0C,$3C
           .byte  $3C,$FC,$FC,$FC,$F0,$F0,$F0,$30
LBBDB:     .byte  $00,$00,$00,$03,$03,$03,$03,$03
           .byte  $03,$03,$03,$04,$09,$C5,$F5,$F5
           .byte  $F5,$F5,$F5,$F5,$C4,$04,$40,$80
           .byte  $4C,$7F,$7F,$7F,$7F,$7F,$7F,$4F
           .byte  $43
LBBFC:     .byte  $2A,$0A,$02,$00,$3F,$AA,$3F,$00
           .byte  $00,$00,$80,$A0,$A8,$FF,$AA,$FF
           .byte  $0C,$30,$00,$00,$00,$40,$40,$40
           .byte  $00,$00,$00
LBC17:     .byte  $00,$02,$00,$00,$0F,$2A,$0F,$00
           .byte  $00,$00,$A0,$A8,$2A,$FF,$AA,$FF
           .byte  $03,$0C,$00,$00,$00,$10,$D0,$90
           .byte  $C0,$00,$00
LBC32:     .byte  $02,$00,$00,$00,$03,$0A,$03,$00
           .byte  $00,$A0,$A8,$2A,$0A,$FF,$AA,$FF
           .byte  $00,$03,$00,$00,$00,$84,$F4,$A4
           .byte  $F0,$C0,$00
LBC4D:     .byte  $00,$00,$00,$00,$00,$02,$00,$00
           .byte  $00,$00,$2A,$0A,$02,$FF,$AA,$FF
           .byte  $00,$00,$00,$00,$80,$A1,$FD,$A9
           .byte  $FC,$30,$C0
LBC68:     .byte  $00,$02,$0A,$C8,$E4,$E6,$24,$0C
           .byte  $03,$A0,$80,$00,$00,$60,$64,$66
           .byte  $06,$02,$00,$00,$00,$00,$00,$00
           .byte  $00,$40,$00
LBC83:     .byte  $00,$00,$02,$32,$39,$39,$09,$03
           .byte  $00,$00,$00,$80,$00,$18,$99,$00
           .byte  $00,$C0,$00,$00,$00,$00,$00,$00
           .byte  $80,$90,$80
LBC9E:     .byte  $00,$00,$00,$0C,$0E,$0E,$02,$00
           .byte  $00,$0A,$28,$A0,$80,$46,$66,$46
           .byte  $C0,$30,$00,$00,$00,$00,$00,$40
           .byte  $60,$64,$20
LBCB9:     .byte  $00,$00,$00,$03,$03,$03,$00,$00
           .byte  $00,$00,$00,$28,$20,$91,$99,$91
           .byte  $30,$0C,$00,$00,$00,$00,$80,$90
           .byte  $98,$19,$08
LBCD4:     .byte  $80,$80
LBCD6:     .byte  $20,$20
LBCD8:     .byte  $08,$08
LBCDA:     .byte  $02,$02
LBCDC:     .byte  $B8,$74,$DC,$74,$B8,$00,$00,$00
           .byte  $00,$00
LBCE6:     .byte  $1D,$2E,$3B,$2E,$1D,$00,$00,$00
           .byte  $00,$00
LBCF0:     .byte  $0D,$09,$07,$09,$0D,$C0,$80,$40
           .byte  $80,$C0
LBCFA:     .byte  $01,$03,$02,$03,$01,$90,$B0,$60
           .byte  $B0,$90
        
LBD04:     .byte  $93,$93,$93,$93,$93,$92,$92,$92
           .byte  $92,$91,$90,$8F,$8F,$8E,$8D,$8C
           .byte  $8B,$8A,$89,$88,$87,$86,$86,$87
           .byte  $88,$88,$88,$87,$86,$85,$84,$84
           .byte  $84,$84,$84,$85,$85,$85,$85,$86
           .byte  $86,$87,$88,$88,$88,$89,$8A,$8A
           .byte  $8A,$8A,$8A,$8A,$89,$88,$87,$86
           .byte  $85,$84,$83,$82,$81,$80,$7F,$7F
           .byte  $7E,$7E,$7E,$7D,$7D,$7D,$7D,$7C
           .byte  $7C,$7C,$7C,$7C,$7B,$7B,$7B,$7B
           .byte  $7B,$7B,$7C,$7D,$7E,$7F,$80,$81
           .byte  $82,$83,$84,$85,$86,$87,$88,$89
           .byte  $8A,$8B,$8C,$8D,$8D,$8E,$8E,$8E
           .byte  $8F,$8F,$8F,$8F,$90,$90,$90,$90
           .byte  $91,$92,$93,$93,$93,$93,$93,$93
           .byte  $93,$93,$93,$93,$93,$93,$93,$92
           .byte  $92,$92,$91,$90,$8F,$8F,$8F,$8F
           .byte  $8F,$8F,$90,$91,$91,$91,$91,$91
           .byte  $90,$8F,$8F,$8F,$8E,$8D,$8D,$8C
           .byte  $8C,$8B,$8B,$8B,$8C,$8C,$8D,$8D
           .byte  $8E,$8E,$8E,$8E,$8F,$90,$91,$91
           .byte  $91,$91,$91,$91,$92,$93,$93,$93
           .byte  $93,$93,$93,$92,$91,$90,$8F,$8E
           .byte  $8D,$8C,$8C,$8C,$8D,$8D,$8E,$8E
           .byte  $8E,$8E,$8E,$8D,$8D,$8C,$8C,$8B
           .byte  $8B,$8B,$8B,$8A,$8A,$89,$89,$89
           .byte  $88,$89,$8A,$8B,$8B,$8C,$8C,$8B
           .byte  $8A,$89,$88,$87,$86,$85,$84,$84
           .byte  $84,$84,$83,$82,$83,$84,$85,$85
           .byte  $86,$87,$88,$89,$89,$8A,$8B,$8B
           .byte  $8B,$8B,$8C,$8D,$8E,$8F,$90,$91
           .byte  $92,$93,$93,$93,$93,$93,$93,$93
LBE04:     .byte  $C0,$30,$0C,$03
LBE08:     .byte  $E1,$F0,$E9,$EB,$E3,$D3,$76,$3F
           .byte  $D2,$51,$47,$FD,$FD,$9C,$4E,$6A
           .byte  $83,$9E,$8A,$E3,$C2,$E9,$AC,$63
           .byte  $F1,$BF,$12,$B7,$19,$A1,$E5,$21
           .byte  $8E,$C3,$CC,$13,$06,$F6,$06,$E2
           .byte  $DB,$4E,$A3,$45,$E4,$1D,$A0,$05
           .byte  $43,$9D,$6D,$B6,$2C,$4A,$D7,$06
           .byte  $EF,$84,$60,$FA,$5A,$1E,$C5,$40
           .byte  $8A,$5B,$78,$C6,$C1,$6A,$0A,$35
           .byte  $DD,$47,$DC,$77,$6F,$F5,$4C,$D1
           .byte  $0A,$D2,$45,$AE,$20,$36,$9A,$67
           .byte  $98,$33,$04,$C3,$6B,$3E,$01,$50
           .byte  $D5,$55,$26,$4E,$D2,$A9,$38,$7C
           .byte  $D2,$63,$75,$0A,$1B,$8A,$30,$81
           .byte  $7E,$46,$BC,$4C,$AE,$C7,$C1,$60
           .byte  $3F,$47,$66,$FB,$8E,$5C,$B2,$7D
           .byte  $3A,$39,$BC,$FB,$0E,$E7,$92,$9A
           .byte  $7D,$C8,$EE,$FC,$5A,$49,$D6,$04
           .byte  $86,$12,$ED,$7A,$D8,$78,$D7,$E8
           .byte  $B9,$5D,$36,$49,$E1,$5D,$55,$FA
           .byte  $19,$18,$55,$1F,$2F,$F2,$E4,$79
           .byte  $D7,$0B,$F7,$CE,$41,$EF,$A8,$F5
           .byte  $9E,$87,$8C,$17,$5B,$16,$FE,$52
           .byte  $DB,$B9,$C7,$25,$64,$6A,$32,$D7
           .byte  $9D,$6B,$B8,$5C,$79,$84,$F1,$2D
           .byte  $84,$22,$DE,$5A,$B4,$1D,$01,$C4
           .byte  $33,$E4,$DD,$B4,$47,$9D,$06,$91
           .byte  $E2,$0A,$BC,$4A,$08,$A1,$F6,$9E
           .byte  $4A,$41,$E4,$90,$0B,$03,$99,$53
           .byte  $59,$39,$43,$7A,$6F,$47,$02,$D4
           .byte  $3D,$83,$F7,$0D,$D6,$6A,$3C,$16
           .byte  $C1,$06,$48,$E5,$A9,$17,$CF,$38
LBF08:     .byte  $E6,$E6,$E6,$FE,$E6,$E6,$E6,$00
           .byte  $FC,$FC,$30,$30,$30,$FC,$FC,$00
           .byte  $7C,$EE,$E0,$7C,$06,$E6,$7C,$00
           .byte  $7C,$EE,$E0,$E0,$E0,$EE,$7C,$00
           .byte  $7C,$FE,$E6,$E6,$E6,$FE,$7C,$00
           .byte  $FC,$FE,$E6,$FC,$EC,$E6,$E6,$00
           .byte  $FE,$FE,$E0,$F8,$E0,$FE,$FE,$00
           .byte  $FE,$FE,$E0,$F8,$F8,$E0,$E0,$00
           .byte  $E0,$E0,$E0,$E0,$E0,$FE,$FE,$00
           .byte  $C6,$C6,$6C,$38,$38,$38,$38,$00
           .byte  $7C,$EE,$E0,$7C,$06,$E6,$7C,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $10,$38,$6C,$6C,$FE,$C6,$C6,$00
           .byte  $FE,$E6,$E6,$FC,$E6,$E6,$FC,$00
           .byte  $FC,$E6,$E6,$E6,$E6,$E6,$FC,$00
           .byte  $E6,$E6,$FC,$F8,$FC,$E6,$E6,$00
           .byte  $C6,$EE,$FE,$D6,$C6,$C6,$C6,$00
           .byte  $FC,$E6,$E6,$FC,$E0,$E0,$E0,$00
           .byte  $FC,$FC,$30,$30,$30,$30,$30,$00
LBFA0:     .byte  $7C,$FE,$E6,$E6,$E6,$FE,$7C,$00 ; 0
           .byte  $18,$38,$38,$18,$18,$18,$7C,$00 ; 1
           .byte  $7C,$C6,$0C,$18,$30,$7E,$FE,$00 ; 2
           .byte  $7C,$C6,$06,$1E,$06,$C6,$7C,$00 ; 3
           .byte  $E6,$E6,$FE,$FE,$06,$06,$06,$00 ; 4
           .byte  $FE,$FE,$E0,$7C,$06,$E6,$7C,$00 ; 5
           .byte  $7C,$E6,$E0,$FC,$E6,$FE,$7C,$00 ; 6
           .byte  $FE,$FE,$0E,$1C,$38,$70,$E0,$00 ; 7
           .byte  $7C,$E6,$E6,$7C,$E6,$E6,$7C,$00 ; 8
           .byte  $7C,$E6,$E6,$7E,$06,$06,$06,$00 ; 9
           .byte  $B6,$8D,$CA,$03,$4C,$BE,$03,$60
           .byte  $00,$00,$FF,$FF,$00,$00,$FF,$FF
