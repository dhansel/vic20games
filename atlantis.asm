;;; Imagic Software ATLANTIS for VIC-20

VIC               := $9000      ; $9000-$900F
VIA1              := $9110      ; $9110-$911F
VIA2              := $9120      ; $9120-$912F
COLORRAM          := $9600      ; $9400-$9507 (22x12)
CHARSET           := $1000      ; $1000-$1FFF
SCREEN            := $0200      ; $0200-$0307 (22x12)
JOY_REG_RIGHT     := VIA2+0
JOY_REG_OTHER     := VIA1+1
JOY_MASK_UP       := $04
JOY_MASK_DOWN     := $08
JOY_MASK_LEFT     := $10
JOY_MASK_RIGHT    := $80
JOY_MASK_BUTTON   := $20

           .org $A000
        
           .setcpu"6502"

           .word  ENTRY,ENTRY
           .byte  $41,$30,$C3,$C2,$CD ; "A0cbm" signature (PETSCII)

LA009:     ldy    #$07
LA00B:     lda    ($8C),y
           jmp    ($89)         ; skip varying number of "lsr" instructions below
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           lsr    a
LA017:     ora    ($8E),y
           sta    ($8E),y
           lda    ($8C),y
           jmp    ($87)         ; skip varying number of "als" instructions below
LA020:     asl    a
           asl    a
           asl    a
           asl    a
           asl    a
           asl    a
           asl    a
           asl    a
           ora    ($90),y
           sta    ($90),y
           dey
           bpl    LA00B
           rts

LA030:     ldx    #$03
LA032:     lda    $0F,x
           beq    LA09B
           asl    a
           asl    a
           asl    a
           asl    a
           sta    $8C
           lda    #>LAD00
           adc    #$00
           sta    $8D
           lda    $07,x
           and    #$F8
           lsr    a
           lsr    a
           tay
           lda    LA255,y
           adc    $0B,x
           sta    $8E
           sta    $7B,x
           lda    LA255+1,y
           adc    #$00
           sta    $8F
           sta    $77,x
           lda    $8E
           adc    #$B0
           sta    $90
           lda    $8F
           adc    #$00
           sta    $91
           lda    $07,x
           and    #$07
           sta    $8B
           clc
           adc    #<LA020
           sta    $87
           lda    #<LA017+1
           sbc    $8B
           sta    $89
           jsr    LA009
           lda    $90
           sta    $8E
           clc
           adc    #$B0
           sta    $90
           lda    $91
           sta    $8F
           adc    #$00
           sta    $91
           lda    $8C
           adc    #$08
           sta    $8C
           lda    $8D
           adc    #$00
           sta    $8D
           jsr    LA009
LA09B:     dex
           bpl    LA032
           rts

LA09F:     ldx    #$03
LA0A1:     lda    $7B,x
           sta    $8E
           clc
           adc    #$B0
           sta    $90
           lda    $77,x
           sta    $8F
           adc    #$00
           sta    $91
           lda    $90
           adc    #$B0
           sta    $92
           lda    $91
           adc    #$00
           sta    $93
           lda    #$00
           ldy    #$07
LA0C2:     sta    ($8E),y
           sta    ($90),y
           sta    ($92),y
           dey
           bpl    LA0C2
           dex
           bpl    LA0A1
           rts

LA0CF:     ldx    #$02
LA0D1:     lda    $83,x
           sta    $8E
           lda    $7F,x
           sta    $8F
           ldy    #$00
           tya
           sta    ($8E),y
           iny
           sta    ($8E),y
           dex
           bne    LA0D1
           rts

LA0E5:     ldx    #$02
LA0E7:     ldy    $3E,x
           beq    LA0F8
           jsr    LA104
           lda    LA0FC,y
           ldy    #$00
           sta    ($8E),y
           iny
           sta    ($8E),y
LA0F8:     dex
           bne    LA0E7
           rts

LA0FC:     .byte  $80,$40,$20,$10,$08,$04,$02,$01
LA104:     lda    $3A,x
           and    #$F8
           lsr    a
           lsr    a
           tay
           lda    LA255,y
           adc    $3E,x
           sta    $83,x
           sta    $8E
           lda    LA255+1,y
           adc    #$00
           sta    $7F,x
           sta    $8F
           lda    $3A,x
           and    #$07
           tay
           rts

LA123:     lda    $51
           bne    LA151
           lda    $4C
           beq    LA155
           lda    $49
           and    #$F8
           lsr    a
           lsr    a
           tay
           lda    LA255,y
           adc    #$60
           sta    $94
           lda    LA255+1,y
           adc    #$00
           sta    $95
           ldy    $4A
           sty    $50
LA144:     lda    ($94),y
           sta    $0380,y
           eor    #$0C
           sta    ($94),y
           dey
           bpl    LA144
           .byte  $2C
LA151:     lda    #$00
           sta    $51
LA155:     rts

LA156:     lda    $51
           beq    LA164
           ldy    $50
LA15C:     lda    $0380,y
           sta    ($94),y
           dey
           bpl    LA15C
LA164:     rts

LA165:     ldx    #$03
LA167:     lda    $1B,x
           lsr    a
           and    #$07
           tay
           lda    LA1D2,y
           ldy    LA1CE,x
           sta    $C0,y
           dex
           bpl    LA167
           lda    $75
           lsr    a
           lsr    a
           lsr    a
           and    #$03
           tay
           lda    LA1D7,y
           sta    $013D
           lda    LA1DB,y
           sta    $0147
           lda    $75
           and    #$0F
           bne    LA1AA
           lda    $A3
           and    #$03
           tay
           lda    LA1DF,y
           sta    $0137
           lda    LA1E3,y
           sta    $0138
           lda    LA1E7,y
           sta    $0139
LA1AA:     lda    #$70
           sta    $0153
           sta    $0154
           lda    #$2E
           sta    $C5
           lda    $76
           beq    LA1CD
           sta    $0153
           sta    $0154
           lda    #$53
           ldx    #$05
LA1C4:     sta    $C0,x
           dex
           bpl    LA1C4
           lda    #$00
           sta    $76
LA1CD:     rts

LA1CE:     .byte  $04,$03,$02,$01
LA1D2:     .byte  $01,$0A,$13,$1C,$25
LA1D7:     .byte  $72,$82,$C2,$32
LA1DB:     .byte  $F5,$A5,$75,$B5
LA1DF:     .byte  $0A,$5A,$3A,$6A
LA1E3:     .byte  $6A,$6A,$EA,$5A
LA1E7:     .byte  $5A,$EA,$6A,$6A
LA1EB:     ldx    #$28
LA1ED:     lda    LA211,x
           sta    $8E
           lda    LA211+1,x
           sta    $8F
           lda    LA211,x
           and    #$07
           tay
           lda    LA209,y
           ldy    #$00
           sta    ($8E),y
           dex
           dex
           bpl    LA1ED
           rts

LA209:     .byte  $80,$40,$20,$10,$08,$04,$02,$01
        
LA211:     .byte  $D8,>CHARSET+$0,$76,>CHARSET+$1,$6F,>CHARSET+$2,$04,>CHARSET+$3
           .byte  $90,>CHARSET+$3,$6B,>CHARSET+$4,$EF,>CHARSET+$4,$B5,>CHARSET+$5
           .byte  $41,>CHARSET+$6,$0D,>CHARSET+$7,$C6,>CHARSET+$7,$87,>CHARSET+$8
           .byte  $13,>CHARSET+$9,$D9,>CHARSET+$9,$69,>CHARSET+$A,$17,>CHARSET+$B
           .byte  $06,>CHARSET+$C,$9B,>CHARSET+$C,$50,>CHARSET+$D,$1A,>CHARSET+$E

LA239:     jsr    LA165
           jsr    LA156
           jsr    LA09F
           jsr    LA0CF
           jsr    LA0E5
           jsr    LA1EB
           jsr    LA030
           jsr    LAA50
           jsr    LA123
           rts

LA255:     .byte  $A0,>CHARSET-$2,$50,>CHARSET-$1
LA259:     .byte  $00,>CHARSET+$0,$B0,>CHARSET+$0,$60,>CHARSET+$1,$10,>CHARSET+$2
           .byte  $C0,>CHARSET+$2,$70,>CHARSET+$3,$20,>CHARSET+$4,$D0,>CHARSET+$4
           .byte  $80,>CHARSET+$5,$30,>CHARSET+$6,$E0,>CHARSET+$6,$90,>CHARSET+$7
           .byte  $40,>CHARSET+$8,$F0,>CHARSET+$8,$A0,>CHARSET+$9,$50,>CHARSET+$A
           .byte  $00,>CHARSET+$B,$B0,>CHARSET+$B,$60,>CHARSET+$C,$10,>CHARSET+$D
           .byte  $C0,>CHARSET+$D,$70,>CHARSET+$E,$20,>CHARSET+$F,$D0,>CHARSET+$F
           .byte  $80,>CHARSET-$6,$30,>CHARSET-$5,$E0,>CHARSET-$5,$90,>CHARSET-$4
           .byte  $40,>CHARSET-$3,$F0,>CHARSET-$3,$A0,>CHARSET-$2
        
ENTRY:     cld
           ldx    #$FF
           txs
           lda    #$7F
           sta    VIA2+$E
           sta    VIA1+$E
           lda    #$00
           sta    $8E
           sta    $8F
           tay
           ldx    #$A0
LA2AC:     sta    ($8E),y
           dey
           bne    LA2AC
           inc    $8F
           dex
           bne    LA2AC
           lda    #<LAAA3
           sta    $0318
           lda    #>LAAA3
           sta    $0319
           ldy    #$05
LA2C2:     lda    LA306,y
           sta    VIC+$0,y
           dey
           bpl    LA2C2
           lda    #$15
           sta    VIC+$F
           lda    #$50
           sta    VIC+$E
           jsr    LA32E
           jsr    LA905
           jsr    LAA0E
           jsr    LAA35
           jsr    LA45C
           lda    #>LA009
           sta    $88
           sta    $8A
           ldx    #$36
           lda    #$E0
LA2EE:     sta    $50,x
           dex
           bpl    LA2EE
           lda    #$40
           sta    VIA1+$B
           jsr    LA30C
           lda    #$C0
           sta    VIA1+$E
           jsr    LA343
           jmp    LA35A

        ;; init VIC:
        ;; 16x8 (i.e. double-height) character size
        ;; 
        ;; 12 (double-height) rows, 22 columns
        ;; character map at $1000
        ;; screen memory at $0200-$0308
        ;; color at $9600-$9708
LA306:     .byte  $05,$18,$96,$19,$00,$8C
        
LA30C:     ldy    #$15
LA30E:     cpy    VIC+$4
           bne    LA30E         ; wait for raster line 21
           iny
LA314:     cpy    VIC+$4
           bne    LA314         ; wait for raster line 22
           lda    #$D8
           sta    VIA1+$4
           lda    #$00
           sta    VIA1+$5
           lda    #$EF
           sta    VIA1+$6
           lda    #$FF
           sta    VIA1+$7
           rts

LA32E:     lda    #$F1
           tay
LA331:     sta    SCREEN,y
           dey
           cpy    #$15
           beq    LA342
           sec
           sbc    #$0B
           bcs    LA331
           adc    #$F1
           bne    LA331
LA342:     rts

LA343:     ldy    #$6D
           ldx    #$36
LA347:     lda    LAB0E,x
           sta    COLORRAM+$84,y
           dey
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           sta    COLORRAM+$84,y
           dey
           dex
           bpl    LA347
           rts

LA35A:     lda    #$60
LA35C:     cmp    VIC+$4
           bne    LA35C         ; wait for raster line 96
           jsr    LA239
           bit    $A0
           bvc    LA36C
           lda    #$06
           sta    $A2
LA36C:     inc    $75
           bne    LA378
           dec    $A2
           bne    LA378
           lda    #$00
           sta    $A0
LA378:     lda    $06
           beq    LA3BA
           dec    $06
           bne    LA3BA
           lda    $00
           bne    LA396
           lda    $20
           cmp    #$12
           bcs    LA38C
           adc    #$01
LA38C:     sta    $20
           lda    $23
           cmp    #$06
           bcs    LA396
           inc    $23
LA396:     lda    #$80
           sta    $05
           ldx    $9F
           lda    $20
           sta    $21,x
           lda    $23
           sta    $24,x
           txa
           eor    #$01
           tax
           lda    $24,x
           beq    LA3B0
           sta    $23
           stx    $9F
LA3B0:     lda    $23
           bne    LA3BA
           sta    $05
           lda    #$80
           sta    $A0
LA3BA:     bit    $A0
           bvc    LA3C9
           lda    $05
           beq    LA3C9
           dec    $05
           bne    LA3C9
           jsr    LA43E
LA3C9:     lda    $04
           beq    LA3E3
           lda    #$00
           sta    $47
           dec    $04
           bne    LA3FA
           ldx    #$0F
LA3D7:     sta    $0F,x
           dex
           bpl    LA3D7
           sta    $02
           sta    $03
           jmp    LA396

LA3E3:     lda    $9C
           eor    #$FF
           and    $9D
           bpl    LA3FA
           bit    $A0           ; button was pressed
           lda    #$C0
           sta    $A0
           bvs    LA3FA
           jsr    LA45C
           lda    #$40
           sta    $05
LA3FA:     bit    $A0
           bvc    LA414
           lda    $02
           ora    $03
           ora    $05
           ora    $06
           ora    $46
           ora    $04
           ora    $4E
           ora    $4D
           bne    LA414
           lda    #$40
           sta    $06
LA414:     jsr    LA8F1
           jsr    LA57F
           jsr    LA62A
           jsr    LA5BE
           jsr    LA955
           jsr    LA84E
           jsr    LA761
           jsr    LA710
           jsr    LA6AE
           jsr    LA48C
           jsr    LA6CA
           jsr    LA7EA
           jsr    LA9A6
           jmp    LA35A

LA43E:     ldx    $9F
           lda    $21,x
           sta    $20
           cmp    #$03
           bcc    LA44B
           adc    #$02
           .byte  $24           ; skip next (1-byte) instruction
LA44B:     asl    a
           adc    #$06
           sta    $1F
           asl    a
           sbc    #$05
           sta    $03
           lda    #$00
           sta    $00
           sta    $01
           rts

LA45C:     lda    #$00
           ldx    #$50
LA460:     sta    $FF,x
           dex
           bne    LA460
           ldx    #$15
LA467:     sta    SCREEN+$F2,x
           dex
           bpl    LA467
           lda    $A1
           and    #$01
           sta    $9F
           tax
           inx
           lda    $A1
           lsr    a
           tay
LA479:     lda    LA48A,y
           sta    $20,x
           lda    #$06
           sta    $23,x
           sta    $1F
           dex
           bpl    LA479
           rts

           .byte  $05,$0F
LA48A:     .byte  $00,$09
LA48C:     ldx    #$04
           lda    #$50
LA490:     ora    $A5,x
           sta    VIC+$A,x
           lda    #$00
           sta    $A5,x
           dex
           bpl    LA490
           lda    $05
           beq    LA4B1
           cmp    #$40
           bcs    LA4B1
           and    #$08
           beq    LA4B1
           lda    #$F2
           sta    $A7
           lda    #$08
           sta    $A9
           rts

LA4B1:     lda    $06
           beq    LA4E7
           cmp    #$20
           bcc    LA4C6
           and    #$04
           beq    LA4E7
           lda    #$F2
           sta    $A7
           lda    #$08
           sta    $A9
           rts

LA4C6:     lsr    a
           lsr    a
           and    #$0F
           tay
           lda    $00
           bne    LA4E7
           lda    $23
           cmp    #$06
           bcs    LA4E7
           lda    LA573,y
           beq    LA4E7
           sta    $A7
           lda    $06
           and    #$03
           asl    a
           asl    a
           ora    #$02
           sta    $A9
           rts

LA4E7:     lda    $4C
           beq    LA501
           ldy    #$F9
           and    #$01
           beq    LA4F3
           ldy    #$FB
LA4F3:     sty    $A5
           lda    #$0F
           sta    $A9
           lda    $4C
           clc
           adc    #$DC
           sta    $A8
           rts

LA501:     lda    $4E
           beq    LA527
           dec    $4E
           lsr    a
           bcs    LA527
           lsr    a
           tay
           lda    LA563,y
           bit    $01
           bpl    LA51D
           lda    #$7F
           sta    $76
           lda    #$F0
           sta    $A7
           lda    #$0F
LA51D:     sta    $A9
           lda    LA56B,y
           adc    $4F
           sta    $A5
           rts

LA527:     ldy    $4D
           beq    LA537
           dec    $4D
           lda    #$05
           sta    $A9
           lda    LA55B,y
           sta    $A5
           rts

LA537:     lda    $04
           and    #$02
           beq    LA546
           lda    #$F2
           sta    $A7
           lda    #$08
           sta    $A9
           rts

LA546:     lda    $02
           beq    LA55A
           lda    $1F
           asl    a
           sbc    $03
           adc    #$C0
           sta    $A5
           asl    a
           sta    $A6
           lda    #$02
           sta    $A9
LA55A:     rts

LA55B:     .byte  $F0,$F2,$F4,$F6,$F7,$F8,$F9,$FA
LA563:     .byte  $01,$03,$05,$07,$09,$0B,$0D,$0F
LA56B:     .byte  $80,$9C,$BD,$EF,$E3,$EA,$F0,$F4
LA573:     .byte  $ED,$E9,$EB,$E7,$E9,$E4,$E7,$E2
           .byte  $F0,$E0,$D0,$C0
LA57F:     bit    $A0
           bvc    LA5BD
           lda    $01           ; have we used "nuke" yet
           bne    LA59C         ; jump if so
           lda    $A0
           lsr    a
           bcs    LA5BD
           lda    $02
           beq    LA5BD
           lda    $9D
           eor    #$FF
           and    $9C
           bpl    LA5BD
           lda    #$80          ; button pressed => "nuke"
           sta    $01
LA59C:     bpl    LA5BD
           lda    #$00
           sta    $13
           sta    $14
           sta    $15
           sta    $16
           ldy    $4E
           bne    LA5BD
LA5AC:     lda    $1B,y         ; ship active?
           beq    LA5B4         ; jump if not
           jmp    LA6F5         ; yes, ship gets destroyed

LA5B4:     iny
           cpy    #$04
           bne    LA5AC
           lda    #$01
           sta    $01           ; now have used "nuke"
LA5BD:     rts

LA5BE:     lda    $A0
           lsr    a
           bcs    LA5EF
           ldx    #$03          ; loop over 4 ships (3 to 0)
LA5C5:     lda    $75
           and    #$03
           tay
           lda    LA626,y
           clc
           adc    $13,x
           lsr    a
           lsr    a
           sta    $72
           lda    $1B,x         ; get ship's flags
           beq    LA5EC         ; if 0 then ship does not move
           lsr    a             ; get bit 0 into carry
           lda    $07,x         ; get ship X coordinate
           bcs    LA5E0         ; if carry set then move left
           adc    $72           ; move right
           .byte  $2C
LA5E0:     sbc    $72           ; move left
           cmp    #$F0
           bcs    LA5EA
           cmp    #$E0
           bcs    LA5F0         ; if $E0 <= X < $F0 then ship has exited screen
LA5EA:     sta    $07,x         ; save new X coordinate
LA5EC:     dex                  ; next ship
           bpl    LA5C5         ; loop
LA5EF:     rts

LA5F0:     txa                  ; ship has exited screen
           beq    LA5F7         ; jump if this ship was on level 0
           lda    $04
           beq    LA600
LA5F7:     bit    $A0
           bpl    LA61B
           dec    $02
           jmp    LA61B
LA600:     lda    $1A,x         ; next lower ship level occupied?
           bne    LA5EC         ; if so, go to next ship
           lda    $0B,x
           clc
           adc    #$16
           sta    $0A,x
           lda    $13,x
           sta    $12,x
           lda    $1B,x
           sta    $1A,x
           and    #$01
           tay
           lda    LA624,y
           sta    $06,x
LA61B:     lda    #$00
           sta    $1B,x         ; ship is no longer visible
           sta    $13,x
           jmp    LA5EC         ; next ship

LA624:     .byte  $00,$C0
LA626:     .byte  $00,$02,$01,$03
LA62A:     lda    $47
           beq    LA677
           ldy    $1D
           bne    LA636
           and    #$3F
           sta    $47
LA636:     lda    $1F
           lsr    a
           lsr    a
           eor    #$FF
           sec
           adc    $47
           sta    $47
           beq    LA645
           bcs    LA676
LA645:     lda    #$00
           sta    $47
           ldy    $48
           clc
           .byte  $2C
LA64D:     adc    $1F
           dey
           bpl    LA64D
           lsr    a
           lsr    a
           lsr    a
           clc
           adc    $1F
           sta    $16
           lda    $A4
           and    #$07
           ora    #$80
           sta    $1E
           and    #$01
           tay
           lda    LA624,y
           sta    $0A
           lda    #$14
           sta    $0E
           bit    $A0
           bvc    LA676
           dec    $03
           inc    $02
LA676:     rts

LA677:     lda    $4E
           bne    LA676
           bit    $A0
           bpl    LA685
           bvc    LA676
           lda    $03
           beq    LA676
LA685:     lda    $1E
           ora    $05
           ora    $04
           bne    LA676
           lda    $A3
           and    #$01
           ora    #$02
           eor    $48
           tax
           sec
           sbc    $48
           stx    $48
           ldy    #$00
           bcc    LA6A0
           tay
LA6A0:     lda    $A3
           and    #$00
           adc    LA6AA,y
           sta    $47
           rts

LA6AA:     .byte  $14,$3C,$64,$8C
LA6AE:     ldx    #$02
LA6B0:     lda    $3E,x
           beq    LA6C6
           sec
           sbc    #$03
           cmp    #$10
           bcs    LA6BD
           lda    #$00
LA6BD:     sta    $3E,x
           lda    $3A,x
           clc
           adc    $42,x
           sta    $3A,x
LA6C6:     dex
           bne    LA6B0
           rts

LA6CA:     ldx    #$02
LA6CC:     ldy    #$03
LA6CE:     lda    $1B,y
           bpl    LA6E7
           lda    $3E,x
           sec
           sbc    $0B,y
           cmp    #$0A
           bcs    LA6E7
           lda    $3A,x
           sec
           sbc    $07,y
           cmp    #$10
           bcc    LA6EE
LA6E7:     dey
           bpl    LA6CE
           dex
           bne    LA6CC
           rts

LA6EE:     lda    #$00
           sta    $3E,x
           sta    $13,y
LA6F5:     lda    #$48          ; a ship was hit/destroyed
           sta    $1B,y
           lda    #$11
           sta    $17,y
           lda    #$1F
           sta    $4E
           lda    $A3
           and    #$07
           sta    $4F
           jmp    LA988

           .byte  $14,$28,$3C,$50
LA710:     lda    $A0
           eor    #$40
           and    #$41
           bne    LA75C
           lda    $05
           ora    $06
           ora    $04
           bne    LA75C
           lda    $9D
           eor    #$FF
           and    #$60
           and    $9C
           beq    LA75C
           ldy    #$01          ; LEFT or RIGHT pressed
LA72C:     lda    $9C
           and    LA7E7,y
           beq    LA759
           ldx    #$02
LA735:     lda    $3E,x
           beq    LA73D
           dex
           bne    LA735
           rts

LA73D:     lda    $98,y
           bne    LA759
           lda    #$04
           sta    $98,y
           lda    #$07
           sta    $4D
           lda    #$67
           sta    $3E,x
           lda    LA75D,y
           sta    $3A,x
           lda    LA75F,y
           sta    $42,x
LA759:     dey
           bpl    LA72C
LA75C:     rts
LA75D:     .byte  $15,$BA
LA75F:     .byte  $04,$FC
        
LA761:     lda    $9C
           sta    $9D
           lda    #$00
           sta    VIA2+$2
           sta    VIA1+$3
           lda    JOY_REG_RIGHT
           and    #JOY_MASK_RIGHT
           lsr    a             ; right => #$40
           sta    $9A
           lda    JOY_REG_OTHER
           and    #(JOY_MASK_LEFT|JOY_MASK_UP|JOY_MASK_DOWN|JOY_MASK_BUTTON)
           adc    #$20
           and    #$5C          
           asl    a             ; left => #$20, up => #$08, down => #$10, button => #$80
           ora    $9A
           eor    #$F1
           sta    $72
           lda    #$FF
           sta    VIA2+$2
           ldy    #$0B
LA78C:     lda    LA7CF,y
           sta    VIA2+$0
           lda    VIA2+$1
           eor    #$FF
           and    LA7DB,y
           beq    LA7B0
           cpy    #$08
           bcc    LA7BE
           bne    LA7A9
           lda    $A0
           ora    #$01
           sta    $A0
           rts
LA7A9:     lda    LA7DE,y
           ora    $72
           sta    $72
LA7B0:     dey
           bpl    LA78C
           lda    $72
           ora    $9B
           sta    $9C
           lda    $72
           sta    $9B
           rts
LA7BE:     tya
           and    #$03
           sta    $A1
           jsr    LA45C
           lda    #$40
           sta    $05
           lda    #$C0
           sta    $A0
           rts

LA7CF:     .byte  $EF,$DF,$BF,$7F,$FE,$7F,$FE,$7F
           .byte  $F7,$E7,$E7,$EF
LA7DB:     .byte  $80,$80,$80
LA7DE:     .byte  $80,$01,$01,$02,$02,$01,$0C,$70
           .byte  $01
LA7E7:     .byte  $20,$40,$80
LA7EA:     lda    $1B
           bmi    LA7F5
           lda    #$00
           sta    $4C
           sta    $4B
           rts

LA7F5:     lda    $4C
           beq    LA803
           dec    $4C
           bne    LA841
           lda    $1F
           asl    a
           sta    $13
           rts

LA803:     lda    $23
           beq    LA841
           bit    $A0
           bvc    LA841
           lda    $4B
           bne    LA841
           ldy    $23
           lda    $07
           clc
           adc    #$08
           cmp    LA847,y
           rol    a
           eor    $1B
           ror    a
           bcc    LA841
           lda    LA847,y
           sta    $49
           sbc    #$08
           sta    $07
           lda    #$00
           sta    $13
           lda    LA841,y
           sta    $4A
           lda    #$01
           sta    $4B
           lda    #$1E
           sta    $4C
           sta    $46
           sta    $00
           lda    #$19
           sta    $76
LA841:     rts

           .byte  $40,$20,$30,$20,$30
LA847:     .byte  $20,$2C,$64,$84,$AC,$44,$24
LA84E:     ldx    #$0C
LA850:     lda    LAC4D,x
           sta    $52,x
           dex
           bpl    LA850
           ldx    #$01
LA85A:     ldy    LA8DC,x
           lda    $98,x
           beq    LA866
           dec    $98,x
           ldy    LA8DE,x
LA866:     sty    $52,x
           dex
           bpl    LA85A
           ldx    #$02
LA86D:     lda    $75
           lsr    a
           lsr    a
           lsr    a
           adc    LA8EB,y
           and    #$07
           tay
           lda    LA8E0,y
           ldy    LA8E8,x
           sta    COLORRAM,y
           lda    $75
           lsr    a
           and    #$01
           clc
           adc    #$05
           ldy    LA8EE,x
           sta    $52,y
           dex
           bpl    LA86D
           lda    $46
           beq    LA8B9
           dec    $46
           lda    $46
           bne    LA8A7
           dec    $23
           bne    LA8B9
           lda    #$80
           sta    $04
           jmp    LA8B9

LA8A7:     lsr    a
           lsr    a
           lsr    a
           tay
           lda    $23
           tax
           ror    a
           lda    LA8D4,y
           bcc    LA8B7
           lda    LA8D8,y
LA8B7:     sta    $53,x
LA8B9:     ldx    $23
           lda    #$00
           .byte  $2C
LA8BE:     sta    $53,x
           inx
           cpx    #$07
           bcc    LA8BE
           lda    $23
           lsr    a
           tax
           lda    #$0C
           .byte  $2C
LA8CC:     sta    $59,x
           inx
           cpx    #$04
           bcc    LA8CC
           rts

LA8D4:     .byte  $29,$28,$27,$26
LA8D8:     .byte  $23,$20,$1D,$1A
LA8DC:     .byte  $01,$03
LA8DE:     .byte  $02,$04
LA8E0:     .byte  $01,$03,$01,$07,$01,$03,$01,$05
LA8E8:     .byte  $9C,$A4,$AD
LA8EB:     .byte  $00,$03,$06
LA8EE:     .byte  $03,$05,$07
LA8F1:     sec
           rol    $A3
           rol    $A4
           bcs    LA904
           lda    $A3
           eor    #$05
           sta    $A3
           lda    $A4
           eor    #$88
           sta    $A4
LA904:     rts

LA905:     lda    #$18
           sta    $8E
           lda    #>CHARSET+$F
           sta    $8F
           lda    #$0A
           sta    $74
           ldy    #$6E
LA913:     sty    $72
           lda    LAB44,y
           asl    a
           asl    a
           asl    a
           jsr    LA92A
           ldy    $72
           lda    LAB44,y
           lsr    a
           jsr    LA92A
           bne    LA913
           rts

LA92A:     and    #$78
           ora    #$07
           tax
           ldy    #$07
LA931:     lda    LABB3,x
           sta    ($8E),y
           dex
           dey
           bpl    LA931
           lda    #$F8
           dec    $74
           bne    LA946
           lda    #$0A
           sta    $74
           lda    #$98
LA946:     clc
           adc    $8E
           sta    $8E
           lda    #$FF
           adc    $8F
           sta    $8F
           ldy    $72
           dey
           rts

LA955:     ldx    #$03
LA957:     lda    $1B,x
           beq    LA968
           bpl    LA96D
           lda    $75
           and    #$04
           eor    $1B,x
           and    #$07
           clc
           adc    #$05
LA968:     sta    $0F,x
           jmp    LA97F

LA96D:     dec    $17,x
           lda    $17,x
           bne    LA977
           sta    $1B,x
           dec    $02
LA977:     lsr    a
           lsr    a
           tay
           lda    LA983,y
           sta    $0F,x
LA97F:     dex
           bpl    LA957
           rts

LA983:     .byte  $01,$02,$03,$04,$00
LA988:     ldx    $9F
           lda    $20
           cmp    #$0A
           bcc    LA994
           sbc    #$09
           inx
           inx
LA994:     inx
           inx
           sec
           adc    $26,x         ; increase points
           sta    $26,x
           sbc    #$09
           bmi    LA9A5
           sta    $26,x
           lda    #$00
           beq    LA994
LA9A5:     rts

        ;; display score
LA9A6:     ldx    $9F
           lda    $A1
           lsr    a
           bcs    LA9AF
           ldx    #$02
LA9AF:     lda    LAA08,x       ; get screen address for digit
           sta    $96
           lda    LAA0B,x
           sta    $97
           bcc    LA9C1
           lda    $05
           and    #$04
           bne    LA9F3
LA9C1:     lda    $9F
           ora    #$10
           tax
           ldy    #$00
           sec
LA9C9:     sty    $72
           lda    $26,x         ; get points digit
           bcc    LA9D1
           beq    LA9D4
LA9D1:     clc
           adc    #$01
LA9D4:     tay
           lda    LA9FD,y
           ldy    $72
           sta    ($96),y
           dex
           dex
           bmi    LA9EE
           ora    $9F
           bne    LA9EA
           lda    $A1
           and    #$01
           bne    LA9EB
LA9EA:     iny
LA9EB:     jmp    LA9C9

LA9EE:     lda    #$0B
           sta    ($96),y
           rts

LA9F3:     ldy    #$09
           lda    #$00
LA9F7:     sta    ($96),y
           dey
           bpl    LA9F7
           rts

LA9FD:     .byte  $00,$0B,$16,$21,$2C,$37,$42,$4D
           .byte  $58,$63,$6E
LAA08:     .byte  <(SCREEN+$F3),<(SCREEN+$FE),<(SCREEN+$F7)
LAA0B:     .byte  >(SCREEN+$F3),>(SCREEN+$FE),>(SCREEN+$F7)
LAA0E:     ldy    #$1E
           ldx    #$95
LAA12:     sty    $72
           lda    LA259,y
           clc
           adc    #$02
           sta    $8E
           lda    LA259+1,y
           adc    #$00
           sta    $8F
           ldy    #$09
LAA25:     lda    LAF60,x
           sta    ($8E),y
           dex
           dey
           bpl    LAA25
           ldy    $72
           dey
           dey
           bne    LAA12
           rts

LAA35:     ldx    #$7F
LAA37:     lda    LAC69,x
           sta    $0100,x
           dex
           bpl    LAA37
           ldx    #$0F
LAA42:     lda    LACD5,x
           sta    $C0,x
           lda    LACC9,x
           sta    $AA,x
           dex
           bpl    LAA42
           rts

LAA50:     ldy    #$0C
LAA52:     lda    $52,y
           cmp    $62,y
           beq    LAA9F
           sta    $62,y
           asl    a
           asl    a
           asl    a
           sta    $8C
           lda    #>LAE00
           adc    #$00
           sta    $8D
           sty    $72
           ldx    LAC5A,y
           tya
           asl    a
           tay
           lda    LAC33,y
           sta    $8E
           lda    LAC33+1,y
           sta    $8F
           jmp    LAA91
LAA7D:     lda    $8E
           clc
           adc    #$B0
           sta    $8E
           bcc    LAA88
           inc    $8F
LAA88:     lda    $8C
           beq    LAA91
           clc
           adc    #$08
           sta    $8C
LAA91:     ldy    #$07
LAA93:     lda    ($8C),y
           sta    ($8E),y
           dey
           bpl    LAA93
           dex
           bne    LAA7D
           ldy    $72
LAA9F:     dey
           bpl    LAA52
           rts

LAAA3:     cld
           pha
           txa
           pha
           tya
           pha
           ldx    $BF
           beq    LAAB9
           lda    $AA,x
           bne    LAAB9
           sta    $BF
           jsr    LA30C         ; wait until raster line 22
           jmp    LAAFE         ; exit interrupt
LAAB9:     inc    $BF
           ldy    $C0,x
           lda    $0100,y
           iny
           sta    VIC+$F
           lda    $AB,x
           sec
           sbc    $AA,x
           sta    $BE
           lsr    a
           lsr    a
           tax
           lda    $BE
           ror    a
           ror    a
           and    #$80
           ror    a 
           adc    $BE
           bcc    LAADA
           inx
LAADA:     clc
           adc    VIA1+$4
           sta    VIA1+$4
           txa
           adc    #$FF
           sta    VIA1+$5
           lda    $0100,y
           jmp    LAAF2
LAAED:     ldx    #$08
LAAEF:     dex
           bpl    LAAEF
LAAF2:     sta    VIC+$F
           nop
           nop
           nop
           iny
           lda    $0100,y
           bne    LAAED
LAAFE:     lda    #$F1
           sta    VIA1+$6
           lda    #$FF
           sta    VIA1+$7
           pla
           tay
           pla
           tax
           pla
           rti

LAB0E:     .byte  $00,$99,$99,$99,$99,$99,$99,$99
           .byte  $99,$99,$00,$EE,$EE,$11,$11,$11
           .byte  $11,$11,$11,$11,$11,$EE,$EE,$EE
           .byte  $E6,$66,$EE,$EE,$E6,$66,$EE,$EE
           .byte  $EE,$AA,$22,$2A,$AA,$AA,$AA,$AA
           .byte  $AA,$AA,$AA,$AA,$22,$22,$22,$22
           .byte  $22,$22,$22,$22,$22,$22
LAB44:     .byte  $22,$00,$22,$22,$4D,$00,$00,$32
           .byte  $22,$15,$00,$22,$00,$22,$00,$00
           .byte  $22,$00,$42,$00,$00,$22,$00,$15
           .byte  $00,$00,$22,$00,$00,$16,$00,$22
           .byte  $00,$00,$1B,$00,$22,$00,$00,$CF
           .byte  $00,$22,$00,$16,$DD,$00,$22,$00
           .byte  $7D,$DD,$00,$22,$00,$DD,$DD,$00
           .byte  $22,$00,$18,$9D,$00,$22,$00,$15
           .byte  $15,$00,$22,$00,$00,$11,$00,$22
           .byte  $00,$00,$16,$00,$22,$00,$00,$7D
           .byte  $00,$22,$00,$16,$DD,$00,$22,$00
           .byte  $1B,$DD,$00,$22,$00,$C2,$5D,$00
           .byte  $22,$00,$22,$1B,$00,$00,$E2,$22
           .byte  $7F,$00,$00,$22,$22,$DD,$00
LABB3:     .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
           .byte  $55,$55,$55,$55,$55,$55,$55,$55
           .byte  $00,$00,$00,$40,$40,$40,$50,$50
           .byte  $AA,$AA,$6A,$6A,$5A,$5A,$56,$55
           .byte  $6A,$6A,$6A,$5A,$5A,$56,$55,$55
           .byte  $AB,$AB,$AF,$AF,$BF,$BF,$FF,$FF
           .byte  $AA,$AB,$AF,$AF,$AF,$BF,$BF,$FF
           .byte  $EA,$E9,$E5,$D5,$F5,$F5,$F5,$F5
           .byte  $FE,$FE,$FE,$FE,$FE,$FF,$FF,$FF
           .byte  $AA,$A9,$A9,$A9,$A9,$A5,$A5,$A5
           .byte  $AA,$EA,$F9,$F6,$FD,$FD,$FF,$FF
           .byte  $AA,$AA,$A9,$A9,$A5,$95,$95,$95
           .byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
           .byte  $00,$00,$01,$01,$05,$15,$15,$15
           .byte  $FF,$FF,$FF,$FF,$BF,$EF,$FB,$FE
LAC33:     .byte  $68,>CHARSET+$0,$D8,>CHARSET+$E,$F8,>CHARSET+$1,$58,>CHARSET+$7
           .byte  $78,>CHARSET+$9,$88,>CHARSET+$D,$F8,>CHARSET+$3,$D8,>CHARSET+$1
           .byte  $40,>CHARSET+$1,$C0,>CHARSET+$8,$40,>CHARSET+$3,$90,>CHARSET+$9
           .byte  $E4,>CHARSET+$8
LAC4D:     .byte  $01,$03,$11,$05,$14,$05,$17,$05
           .byte  $07,$07,$07,$2A,$2B
LAC5A:     .byte  $01,$01,$03,$01,$03,$01,$03,$01
           .byte  $05,$05,$05,$01,$01,$01,$01
LAC69:     .byte  $00,$40,$80,$70,$10,$10,$70,$80
           .byte  $40,$00,$10,$70,$C0,$C0,$80,$70
           .byte  $80,$40,$00,$60,$30,$50,$10,$10
           .byte  $50,$30,$60,$00,$10,$10,$50,$E0
           .byte  $50,$50,$30,$60,$00,$80,$80,$80
           .byte  $40,$70,$40,$80,$80,$00,$70,$70
           .byte  $70,$20,$20,$30,$30,$00,$00,$6A
           .byte  $6A,$6A,$6A,$00,$6A,$6A,$00,$32
           .byte  $52,$32,$72,$92,$42,$12,$32,$12
           .byte  $00,$35,$55,$55,$35,$35,$35,$C5
           .byte  $75,$5D,$00,$70,$70,$00,$10,$10
           .byte  $10,$10,$30,$30,$E0,$E0,$60,$00
LACC9:     .byte  $00,$14,$2A,$40,$56,$68,$70,$7F
           .byte  $88,$98,$B0,$00
        
LACD5:     .byte  $53,$01,$01,$01,$01,$2E,$37,$3C
           .byte  $3F,$49,$56,$DA,$13,$80,$84,$4F
           .byte  $F5,$C0,$30,$9C,$B9,$02,$30,$04
           .byte  $B1,$0B,$10,$16,$39,$90,$72,$C8
           .byte  $74,$C0,$18,$D2,$3B,$12,$B0,$89
           .byte  $F9,$86,$74

        ;; graphics characters
LAD00:     .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$01,$00,$02,$00,$00,$00
           .byte  $00,$00,$00,$10,$00,$40,$00,$00
           .byte  $02,$00,$03,$10,$03,$00,$04,$00
           .byte  $00,$00,$00,$18,$00,$C0,$00,$40
           .byte  $06,$40,$07,$30,$07,$40,$0C,$00
           .byte  $00,$20,$00,$1C,$00,$E0,$00,$62
           .byte  $0E,$D0,$07,$70,$0F,$C0,$1C,$40
           .byte  $00,$32,$80,$1E,$00,$F4,$00,$73
           .byte  $F0,$38,$1C,$0F,$0F,$1C,$38,$F0
           .byte  $00,$1C,$22,$DD,$DD,$22,$1C,$00
           .byte  $00,$38,$44,$BB,$BB,$44,$38,$00
           .byte  $0F,$1C,$38,$F0,$F0,$38,$1C,$0F
           .byte  $20,$78,$FF,$55,$FF,$78,$7E,$00
           .byte  $00,$00,$00,$FF,$C0,$00,$00,$00
           .byte  $00,$00,$00,$FF,$03,$00,$00,$00
           .byte  $04,$1E,$FF,$AA,$FF,$1E,$7E,$00
           .byte  $F0,$38,$1C,$0F,$0F,$1C,$38,$F0
           .byte  $00,$1C,$22,$C1,$C1,$22,$1C,$00
           .byte  $00,$38,$44,$83,$83,$44,$38,$00
           .byte  $0F,$1C,$38,$F0,$F0,$38,$1C,$0F
           .byte  $20,$78,$FF,$AA,$FF,$78,$7E,$00
           .byte  $00,$00,$00,$FF,$C0,$00,$00,$00
           .byte  $00,$00,$00,$FF,$03,$00,$00,$00
           .byte  $04,$1E,$FF,$55,$FF,$1E,$7E,$00
           .byte  $1E,$08,$0C,$1F,$0C,$08,$1E,$00
           .byte  $00,$00,$00,$F0,$00,$00,$00,$00
           .byte  $00,$00,$00,$0F,$00,$00,$00,$00
           .byte  $78,$10,$30,$F8,$30,$10,$78,$00
           .byte  $86,$F6,$90,$70,$94,$94,$8C,$25
           .byte  $9C,$56,$80,$30,$86,$FE,$84,$44
LAE00:     .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $03,$06,$0C,$1E,$36,$95,$AB,$FF
           .byte  $00,$06,$0C,$1E,$3E,$F5,$FF,$FF
           .byte  $C0,$60,$30,$78,$6C,$A9,$D5,$FF
           .byte  $00,$60,$30,$78,$7C,$AF,$FF,$FF
           .byte  $0C,$4E,$0C,$4E,$0C,$4E,$0C,$0C
           .byte  $30,$72,$30,$72,$30,$72,$30,$30
           .byte  $AA,$AA,$AA,$AA,$AA,$A8,$A2,$8A
           .byte  $00,$00,$03,$1C,$E0,$00,$00,$00
           .byte  $00,$3C,$C3,$00,$00,$00,$00,$00
           .byte  $00,$00,$C0,$38,$07,$00,$00,$00
           .byte  $AA,$AA,$AA,$AA,$AA,$2A,$8A,$A2
           .byte  $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
           .byte  $00,$04,$04,$15,$13,$54,$DF,$6D
           .byte  $02,$72,$FA,$05,$FE,$01,$FF,$B5
           .byte  $00,$20,$20,$60,$F8,$8A,$AF,$FA
           .byte  $10,$10,$13,$16,$1C,$7F,$F0,$2F
           .byte  $0E,$15,$A0,$CE,$5F,$FF,$81,$FF
           .byte  $00,$20,$A8,$74,$74,$FE,$0F,$F4
           .byte  $07,$08,$12,$37,$3F,$32,$30,$30
           .byte  $24,$FF,$66,$7E,$FF,$7E,$24,$00
           .byte  $E0,$10,$48,$EC,$FC,$4C,$0C,$0C
           .byte  $00,$11,$00,$08,$00,$02,$00,$08
           .byte  $84,$20,$06,$40,$89,$20,$82,$10
           .byte  $00,$10,$40,$00,$00,$00,$20,$80
           .byte  $00,$00,$00,$22,$06,$10,$20,$04
           .byte  $00,$00,$84,$20,$05,$40,$88,$21
           .byte  $00,$00,$00,$08,$20,$00,$80,$00
           .byte  $00,$00,$00,$00,$01,$44,$00,$A0
           .byte  $00,$00,$00,$00,$02,$20,$05,$40
           .byte  $00,$00,$00,$00,$00,$04,$10,$80
           .byte  $00,$00,$00,$00,$00,$00,$88,$44
           .byte  $00,$00,$00,$00,$00,$82,$20,$04
           .byte  $00,$00,$00,$00,$00,$00,$00,$49
           .byte  $28,$02,$28,$52,$08,$50,$24,$18
           .byte  $00,$00,$49,$80,$54,$42,$28,$22
           .byte  $00,$00,$00,$00,$91,$44,$81,$24
           .byte  $00,$00,$00,$00,$00,$91,$04,$51
           .byte  $3C,$0C,$30,$60,$80,$00,$00,$00
           .byte  $01,$03,$0C,$30,$00,$00,$00,$00
        
LAF60:     .byte  $1C,$36,$36,$36,$77,$36,$36,$36
           .byte  $36,$1C,$28,$38,$18,$18,$18,$3C
           .byte  $18,$18,$18,$7E,$5E,$73,$63,$63
           .byte  $03,$06,$0C,$19,$3F,$7F,$5E,$73
           .byte  $63,$03,$1E,$03,$03,$63,$67,$7E
           .byte  $05,$0E,$1E,$36,$66,$7F,$06,$06
           .byte  $06,$09,$7F,$7E,$40,$40,$7E,$03
           .byte  $03,$63,$7F,$3E,$1E,$33,$23,$20
           .byte  $20,$7E,$23,$23,$33,$1E,$7F,$3F
           .byte  $06,$0C,$18,$30,$78,$30,$30,$30
           .byte  $3E,$77,$63,$77,$3E,$36,$63,$63
           .byte  $77,$3E,$3C,$6E,$46,$66,$7F,$06
           .byte  $06,$66,$66,$3C,$DD,$F9,$90,$70
           .byte  $9D,$FF,$97,$3C,$8F,$FB,$9D,$15
           .byte  $DE,$FF,$04,$39,$DF,$D7,$80,$31
           .byte  $DD,$D3,$C0,$13,$92,$D6,$90,$10
           .byte  $00,$7C,$04,$30,$D0,$F5,$40,$10
           .byte  $16,$B9,$80,$28,$85,$FD,$C4,$A0
           .byte  $9C,$32,$00,$B0,$5D,$3D,$C0,$10
           .byte  $9A,$DC,$80,$70,$8E,$30,$8C,$90
