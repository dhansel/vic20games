;;; Commodore JELLY MONSTERS (clone of PACMAN) for VIC-20
        
VIC               := $9000      ; $9000-$900F
VIA1              := $9110      ; $9110-$911F
VIA2              := $9120      ; $9120-$912F
COLORRAM          := $9400      ; $9400-$966C (23*27=621 bytes)
CHARROM           := $8000      ; $8000-$8FFF
CHARMAP           := $1400      ; $1400-$1BFF
SCREEN            := $1C00      ; $1C00-$1E6C (23*27=621 bytes)
        
JOY_REG_RIGHT     := VIA2+0
JOY_REG_OTHER     := VIA1+15
JOY_MASK_UP       := $04
JOY_MASK_DOWN     := $08
JOY_MASK_LEFT     := $10
JOY_MASK_RIGHT    := $80
JOY_MASK_BUTTON   := $20

NUM_LIVES := $0A

                
           .org $A000
           .setcpu"6502"
        
           .word  ENTRY
           .word  WARMSTART
           .byte  $41,$30,$C3,$C2,$CD ; "A0cbm" signature (PETSCII)

        ;; warmstart (NMI) entry: do nothing
WARMSTART: pla
           tay
           pla
           tax
           pla
           rti

        ;; VIC settings: screen at $1C00, color at $9400, charmap at $1400
        ;; screen size 23 columns by 27 rows (621 characters)
LA00F:     .byte  $03,$14,$17,$36,$00,$FD,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$70,$0E

        ;; main entry point after RESET
ENTRY:     cld
           sei
           ldx    #$FF
           txs
           ldx    #$0F
LA026:     lda    LA00F,x
           sta    VIC,x         ; init VIC
           dex
           bpl    LA026
           jsr    LA4AF
           jsr    LB11F
           lda    #$00
           sta    VIA1+$E
           lda    #$C0
           sta    VIA2+$E
           lda    #$40
           sta    VIA1+$B
           sta    VIA2+$B
           lda    #$FF
           sta    VIA2+$2
           lda    #$80
           sta    VIA1+$3
           lda    #$82          ; Enable "RESTORE" key interrupt
           sta    VIA1+$E
           lda    #$89
           sta    VIA2+$4
           lda    #$42
           sta    VIA2+$5
           lda    #<IRQ0
           sta    $0314
           lda    #>IRQ0
           sta    $0315
           cli
           jmp    LA077

IRQ0:      lda    VIA2+$4
           pla
           tay
           pla
           tax
           pla
           rti

LA077:     cld
           lda    #$00
           sta    VIC+$E        ; VIC master volume
           sta    $07
           sta    $08
           sta    $09
           sta    $04
           sta    $05
           sta    $06
           sta    NUM_LIVES
           sta    $0B
           tay
LA08E:     sta    CHARMAP+$600,y
           iny
           cpy    #$60
           bne    LA08E
LA096:     jsr    LA42E         ; init game screen
           ldy    #$00
LA09B:     lda    LA41C,y
           sta    SCREEN+$160,y
           lda    LA425,y
           sta    SCREEN+$177,y
           lda    #$01
           sta    COLORRAM+$160,y
           sta    COLORRAM+$177,y
           iny
           cpy    #$09
           bne    LA09B
LA0B4:     jsr    LB1BF
           lda    $71
           beq    LA0C3
           cmp    #$01
           beq    LA0DC
           cmp    #$02
           beq    LA0CE
LA0C3:     jsr    LB1AF
           bne    LA0B4
           jsr    LB6B8
           jmp    LA096

LA0CE:     inc    VIC+$0
           lda    VIC+$0
           and    #$0F
           sta    VIC+$0
           jmp    LA0E7

LA0DC:     inc    VIC+$1
           lda    VIC+$1
           and    #$1F
           sta    VIC+$1
LA0E7:     lda    #$40
           jsr    PAUSE
           jmp    LA0B4

LA0EF:     lda    #$00
           sta    $1011
           sta    $0B
           sta    $07
           sta    $08
           sta    $09
           sta    $BF
           sta    $C0
           sta    $17
           ldy    #$0F
           sty    VIC+$E
           dey
           sty    VIC+$F
           lda    #$03          ; init number of lives
           sta    NUM_LIVES     ; to 3
           sei
           lda    #<IRQ2
           sta    $0314
           lda    #>IRQ2
           sta    $0315
           cli
           jsr    LA42E         ; init game screen
LA11E:     lda    $17
           beq    LA11E
LA122:     lda    #$00
           sta    $1006
           sta    $1007
           sta    $1035
           tay
LA12E:     sta    CHARMAP+$2D0,y
           iny
           cpy    #$30
           bne    LA12E
           ldy    $0B
           lda    LA3E8,y
           asl    a
           asl    a
           asl    a
           asl    a
           asl    a
           tax
           ldy    #$00
LA143:     lda    LBCE0,y
           sta    CHARMAP+$2B0,y
           iny
           cpy    #$20
           bne    LA143
           ldy    #$00
LA150:     lda    LBD00,x
           sta    CHARMAP+$2D0,y
           sta    CHARMAP+$604,y
           lda    LBD08,x
           sta    CHARMAP+$2D8,y
           sta    CHARMAP+$61C,y
           lda    LBD10,x
           sta    CHARMAP+$2E8,y
           sta    CHARMAP+$60C,y
           lda    LBD18,x
           sta    CHARMAP+$2F0,y
           sta    CHARMAP+$624,y
           lda    LBB00,y
           sta    CHARMAP+$634,y
           lda    LBB08,y
           sta    CHARMAP+$64C,y
           lda    LBB10,y
           sta    CHARMAP+$63C,y
           lda    LBB18,y
           sta    CHARMAP+$654,y
           inx
           iny
           cpy    #$08
           bne    LA150
           ldy    #$00
LA194:     ldx    #$00
LA196:     lsr    CHARMAP+$2D0,x
           ror    CHARMAP+$2D8,x
           ror    CHARMAP+$2E0,x
           lsr    CHARMAP+$2E8,x
           ror    CHARMAP+$2F0,x
           ror    CHARMAP+$2F8,x
           inx
           cpx    #$08
           bne    LA196
           iny
           cpy    #$04
           bne    LA194
           lda    #$FF
           sta    CHARMAP+$600
           sta    CHARMAP+$617
           sta    CHARMAP+$618
           sta    CHARMAP+$62F
           sta    CHARMAP+$630
           sta    CHARMAP+$647
           sta    CHARMAP+$648
           sta    CHARMAP+$65F
           jsr    LA42E         ; init game screen
LA1CF:     lda    #$50
           sta    $0E
           sta    $10
           lda    #$54
           sta    $0C
           lda    #$58
           sta    $12
           sta    $0F
           lda    #$60
           sta    $14
           lda    #$A8
           sta    $0D
           lda    #$68
           sta    $11
           sta    $13
           sta    $15
           lda    #$00
           sta    $EB
           sta    $EC
           sta    $ED
           sta    $EE
           sta    $EF
           sta    $F0
           sta    $F1
           sta    $F2
           sta    $1009
           sta    $100A
           sta    $100B
           sta    $100C
           sta    $100D
           sta    $1012
           sta    $1014
           sta    $102C
           sta    $1036
           sta    $1033
           sta    $102E
           sta    $1042
           sta    $1043

        ;; Initialization bug: $1046 should initially be set to
        ;; something other than 0, otherwise there will be video glitches.
        ;; Weirdly, $1036 is set to 0 twice here (already done 5 instructions above)
        ;; which may suggest that this WAS setting $1046=0 but was changed to $1036
        ;; to "fix" the glitch. However, that leaves $1046 completely uninitialized.
        ;; It appears that on a VIC-20 the memory around $1046 after powerup is $FF
        ;; by default which is why the glitch usually does not happen.
        ;; 
        ;; The glitch can be reproduced in VICE:
        ;; - start VICE, attach cartridge image
        ;; - enter monitor (Alt-M), set $1046 to $00: >1046 00, exit monitor
        ;; - reset machine (Alt-R), must use SOFT reset as a hard reset re-initializes memory
        ;; - start game, move PACMAN right (until stopped), then down
        ;; => PACMAN will leave "residue" behind in its path
        ;; Note that this issue is present in both the V1 and V2 versions
        ;; of Jelly Monsters floating around on the internet.
           .if 0
           lda    #$3C
           sta    $1046         ; fix: set $1046 to something other than 0
           .else
           sta    $1036         ; original: $1036 set to 0 (again), $1046 not set at all
           lda    #$3C
           .endif

           sta    $1001
           lda    #$FC
           sta    $1041
           lda    #$8C
           sta    $100E
           lda    #$03
           sta    $1C
           sta    $1005
           sta    $1D
           sta    $1E
           sta    $1F
           sta    $20
           sta    $1008
           jsr    LB54D
           jsr    LAB54
           jsr    LABE9
           lda    #$00
           sta    $71
LA259:     lda    #$00
           jsr    PAUSE
           inc    $71
           lda    $71
           cmp    #$07
           bne    LA259
           jsr    LB153
           lda    $16
           cmp    #$01
           beq    LA271
           lda    #$03
LA271:     sta    $1C
           sta    $1005
           sei
           lda    #<IRQ3
           sta    $0314
           lda    #>IRQ3
           sta    $0315
           cli
           lda    #$80
           jsr    PAUSE
LA287:     jsr    LA4DB
           lda    $102C
           bne    LA297
           lda    $1007
           beq    LA287
           jmp    LA358

LA297:     sei
           lda    #<IRQ0
           sta    $0314
           lda    #>IRQ0
           sta    $0315
           cli
           lda    #$00
           sta    $79
           sta    VIC+$A
           sta    VIC+$B
           sta    VIC+$C
LA2B0:     lda    #$30
           jsr    PAUSE
           jsr    LACB1
           lda    $EF
           eor    #$01
           sta    $EF
           sta    $F0
           sta    $F1
           sta    $F2
           jsr    LABE9
           inc    $79
           lda    $79
           cmp    #$14
           bne    LA2B0
           jsr    LACB1
           sei
           jsr    LB62D
           cli
           lda    $0C
           sta    $C2
           lda    $0D
           sta    $C1
           ldx    #$00
           stx    $C3
           stx    $79
LA2E5:     jsr    LAACE
           ldx    $79
           lda    LA408,x       ; get address to next
           sta    $00           ; set of "pacman dissolving" tile
           lda    LA412,x       ; data and store in $00/$01
           sta    $01
           ldy    #$00
LA2F6:     lda    ($00),y       ; move tile data to $21-$40 (4 tiles, 8 bytes each)
           sta    $21,y
           iny
           cpy    #$20
           bcc    LA2F6
           jsr    LA982
           lda    #$75
           jsr    PAUSE
           inc    $79           ; next set of tiles
           lda    $79
           cmp    #$0A
           bne    LA2E5         ; repeat 10 times
           jsr    LAACE
           dec    NUM_LIVES     ; decrement number of lives
           lda    NUM_LIVES
           bne    LA31B         ; continue if 1 or more lives left
           beq    LA329         ; otherwise game over
LA31B:     clc
           adc    #$30          ; put number of lives
           sta    SCREEN+$170   ; on screen
           lda    #$00
           jsr    PAUSE
           jmp    LA1CF

        ;; display "GAME OVER"
LA329:     ldy    #$00
           sty    VIC+$E
           lda    #$30
           sta    SCREEN+$170
LA333:     lda    LA3FF,y
           sta    SCREEN+$160,y
           lda    #$01
           sta    COLORRAM+$160,y
           iny
           cpy    #$09
           bne    LA333
           lda    #$00
           sta    $1038
LA348:     lda    #$80
           jsr    PAUSE
           inc    $1038
           lda    $1038
           cmp    #$28
           bne    LA348
           rts

LA358:     sei
           lda    #<IRQ0
           sta    $0314
           lda    #>IRQ0
           sta    $0315
           cli
           lda    #$00
           sta    VIC+$A
           sta    VIC+$B
           sta    VIC+$C
           jsr    PAUSE
           jsr    LACB1
           jsr    LABA3
           lda    #$14
           sta    $71
           lda    #$06
           sta    $72
LA380:     lda    #$00
           sta    $00
           lda    #$80
           jsr    PAUSE
           lda    $72
           eor    #$07
           sta    $72
           lda    #>SCREEN
           sta    $01
LA393:     ldy    #$00
LA395:     lda    ($00),y
           cmp    #$B2
           bcc    LA3A9
           cmp    #$C0
           bcs    LA3A9
           jsr    LA3E1
           lda    $72
           sta    ($00),y
           jsr    LA3E1
LA3A9:     iny
           bne    LA395
           inc    $01
           lda    $01
           cmp    #>(SCREEN+$300)
           bne    LA393
           dec    $71
           lda    $71
           bpl    LA380
           ldy    $0B
           iny
           cpy    #$10
           bcc    LA3C3
           ldy    #$0F
LA3C3:     sty    $0B
           jsr    LA4AF
           lda    #$00
           jsr    PAUSE
           jmp    LA122

        ;; delay by approximately A milliseconds
        ;; (inner loop is 5 cycles * 256 = 1280 cycles)
PAUSE:     sta    $1037
           ldy    #$00
LA3D5:     ldx    #$00
LA3D7:     inx                  ; 2 cycles
           bne    LA3D7         ; 3 cycles
           iny
           cpy    $1037
           bne    LA3D5
           rts

        ;; toggle $01 between SCREEN and COLORRAM address space
LA3E1:     lda    $01
           eor    #((>SCREEN) .BITXOR (>COLORRAM))
           sta    $01
           rts

LA3E8:     .byte  $00,$01,$02,$02,$03,$03,$04,$04
           .byte  $05,$05,$06,$06,$07,$07,$07,$07
           .byte  $12,$05,$01,$04,$19,$21,$21

        ;; "GAME OVER"
LA3FF:     .byte  $07,$01,$0D,$05,$20,$0F,$16,$05,$12

        ;; pointers to tiles containing "pacman dissolving" sequence
LA408:     .byte  <LBA00,<LBA20,<LBA40,<LBB20,<LBB40
           .byte  <LBB60,<LBB80,<LBBA0,<LBBC0,<LBBE0
LA412:     .byte  >LBA00,>LBA20,>LBA40,>LBB20,>LBB40
           .byte  >LBB60,>LBB80,>LBBA0,>LBBC0,>LBBE0
LA41C:     .byte  $10,$15,$13,$08,$20,$27,$CC,$CD
           .byte  $27
LA425:     .byte  $20,$14,$0F,$20,$13,$14,$01,$12
           .byte  $14

        ;; initialize game screen
LA42E:     ldy    #$00
LA430:     lda    LB20A,y       ; get character
           sta    SCREEN+$000,y ; put on screen
           ldx    #$06          ; blue color
           cmp    #$80
           bcs    LA43E
           ldx    #$01          ; white color
LA43E:     cpy    #$17
           bcs    LA444
           ldx    #$03          ; cyan color
LA444:     txa
           sta    COLORRAM+$000,y
           lda    LB30A,y
           sta    SCREEN+$100,y
           ldx    #$06          ; blue color
           cmp    #$80
           bcs    LA456
           ldx    #$01          ; white color
LA456:     txa
           sta    COLORRAM+$100,y
           cpy    #$9B
           bcs    LA470
           ldx    #$06          ; blue color
           lda    LB40A,y
           sta    SCREEN+$200,y
           cmp    #$80
           bcs    LA46C
           ldx    #$01          ; white color
LA46C:     txa
           sta    COLORRAM+$200,y
LA470:     iny
           bne    LA430
           jsr    LA8AB
           lda    NUM_LIVES
           clc
           adc    #$30
           sta    SCREEN+$170
           lda    #$05
           sta    COLORRAM+$170
           lda    #$07
           sta    COLORRAM+$15A
           sta    COLORRAM+$15B
           sta    COLORRAM+$171
           sta    COLORRAM+$172
           sta    COLORRAM+$188
           sta    COLORRAM+$189
           ldy    $0B
           lda    LA4CB,y
           sta    COLORRAM+$16D
           sta    COLORRAM+$16E
           sta    COLORRAM+$184
           sta    COLORRAM+$185
           sta    COLORRAM+$19B
           sta    COLORRAM+$19C
           rts

LA4AF:     ldy    #$00
LA4B1:     lda    #$20
           sta    SCREEN+$000,y
           sta    SCREEN+$100,y
           sta    SCREEN+$200,y
           lda    #$00
           sta    COLORRAM+$000,y
           sta    COLORRAM+$100,y
           sta    COLORRAM+$200,y
           iny
           bne    LA4B1
           rts

LA4CB:     .byte  $04,$02,$07,$07,$02,$02,$05,$05
           .byte  $07,$07,$01,$01,$03,$03,$03,$03
LA4DB:     jsr    LB153
           lda    $102E
           bne    LA513
           lda    #$00
           sta    $1004
           lda    $0C
           and    #$07
           cmp    #$04
           beq    LA4FA
           lda    $0D
           and    #$07
           cmp    #$04
           beq    LA4FA
           bne    LA513
LA4FA:     lda    $C6
           cmp    #$40
           bcc    LA513
           cmp    #$60
           bcs    LA513
           jsr    LAD97
           lda    $1006
           cmp    #$C0
           bcc    LA513
           lda    #$01
           sta    $1007
LA513:     jsr    LACB1
           jsr    LABA3
           lda    $102E
           beq    LA521
           jmp    LA618

LA521:     ldy    #$00
LA523:     lda    $EB,y
           bne    LA544
           iny
           cpy    #$04
           bcc    LA523
           inc    $1001
           lda    $1001
           bne    LA544
           ldy    #$00
LA537:     lda    $1D,y
           eor    #$02
           sta    $1D,y
           iny
           cpy    #$04
           bcc    LA537
LA544:     lda    $1036
           beq    LA554
           dec    $1036
           lda    $1036
           bne    LA592
           jsr    LB54D
LA554:     lda    $1006
           ldy    $1035
           cpy    #$01
           bcs    LA562
           cmp    #$32
           beq    LA56C
LA562:     cpy    #$02
           bcs    LA592
           cmp    #$6E
           beq    LA56C
           bne    LA592
LA56C:     ldx    #$00
LA56E:     ldy    LA977,x
           lda    LB477,x
           sta    SCREEN+$163,y
           ldy    $0B
           lda    LA4CB,y
           ldy    LA977,x
           sta    COLORRAM+$163,y
           inx
           cpx    #$06
           bne    LA56E
           sta    $1046
           lda    #$A0
           sta    $1036
           inc    $1035
LA592:     lda    $0C
           and    #$07
           bne    LA5D7
           lda    $0D
           and    #$07
           bne    LA5D7
           lda    $0C
           sta    $C2
           lda    $0D
           sta    $C1
           lda    $16
           bmi    LA5C0
           sta    $1002
           jsr    LACCE
           lda    $1003
           bne    LA5C0
           lda    $1002
           sta    $1C
           sta    $1005
           jmp    LA5E4

LA5C0:     lda    $1C
           cmp    #$04
           beq    LA5E4
           sta    $1002
           jsr    LACCE
           lda    $1003
           beq    LA5E4
           lda    #$04
           sta    $1C
           bne    LA5E4
LA5D7:     lda    $1C
           eor    #$02
           cmp    $16
           bne    LA5E4
           sta    $1C
           sta    $1005
LA5E4:     ldy    $1C
           lda    LA8A1,y
           asl    a
           sta    $85
           lda    LA8A6,y
           asl    a
           sta    $86
           lda    $0C
           clc
           adc    $85
           sta    $0C
           lda    $0D
           clc
           adc    $86
           sta    $0D
           cmp    #$68
           bne    LA618
           lda    $0C
           cmp    #$A8
           beq    LA610
           cmp    #$00
           beq    LA614
           bne    LA618
LA610:     lda    #$00
           beq    LA616
LA614:     lda    #$A8
LA616:     sta    $0C
LA618:     ldy    #$00
           sty    $7A
LA61C:     ldx    LAD34,y
           stx    $7B
           lda    $1008,y
           cmp    #$03
           bne    LA696
           lda    #$00
           sta    $1018,y
           ldx    LAD28,y
           lda    $0E,x
           sta    $C2
           lda    $0F,x
           sta    $C1
           lda    $1D,y
           eor    #$02
           sta    $7D
           lda    LAD34,y
           clc
           adc    $7D
           sta    $7C
           ldy    #$00
LA649:     sty    $1002
           jsr    LACCE
           ldx    $7B
           cpx    $7C
           bne    LA65D
           lda    #$01
           sta    $101C,x
           jmp    LA66A

LA65D:     lda    $1003
           sta    $101C,x
           bne    LA66A
           ldx    $7A
           inc    $1018,x
LA66A:     inc    $7B
           ldy    $1002
           iny
           cpy    #$04
           bne    LA649
           lda    $7A
           asl    a
           tay
           lda    $0F,y
           cmp    #$58
           bne    LA696
           lda    $0E,y
           cmp    #$48
           beq    LA68C
           cmp    #$60
           beq    LA68C
           bne    LA696
LA68C:     ldx    $7A
           ldy    LAD34,x
           lda    #$01
           sta    $101C,y
LA696:     inc    $7A
           ldy    $7A
           cpy    #$04
           bcs    LA6A1
           jmp    LA61C

LA6A1:     jsr    LAB54
           ldy    #$00
           sty    $80
           lda    $102E
           bne    LA6B0
           inc    $1014
LA6B0:     ldx    LAD28,y
           stx    $81
           lda    LAD34,y
           sta    $82
           lda    $102E
           bne    LA6FC
           lda    $1008,y
           bne    LA6D6
           lda    $1014
           cmp    LA89D,y
           bcc    LA6D6
           lda    #$01
           sta    $1008,y
           lda    #$03
           sta    $1D,y
LA6D6:     lda    $1008,y
           cmp    #$01
           bne    LA6FC
           lda    $0E,x
           cmp    #$50
           beq    LA6E8
           dec    $0E,x
           jmp    LA6FC

LA6E8:     dec    $0F,x
           lda    $0F,x
           cmp    #$59
           bcs    LA6FC
           lda    #$03
           sta    $1008,y
           lda    #$03
           sta    $1D,y
           bne    LA749
LA6FC:     lda    $1008,y
           cmp    #$02
           bne    LA73F
           lda    $102E
           beq    LA70F
           lda    $EB,y
           cmp    #$03
           bne    LA73F
LA70F:     lda    $1D,y
           tay
           lda    $0E,x
           clc
           adc    LA8A1,y
           cmp    #$00
           beq    LA72C
           cmp    #$A8
           bcc    LA72E
           ldy    $80
           lda    #$01
           sta    $1D,y
           lda    #$00
           beq    LA72E
LA72C:     lda    #$A8
LA72E:     sta    $0E,x
           ldy    $80
           cmp    #$90
           bcs    LA73F
           cmp    #$19
           bcc    LA73F
           lda    #$03
           sta    $1008,y
LA73F:     lda    $1008,y
           cmp    #$03
           bne    LA749
           jsr    LAFEB
LA749:     lda    $1008,y
           cmp    #$04
           bne    LA76A
           lda    $0F,x
           clc
           adc    #$08
           sta    $0F,x
           cmp    #$68
           bne    LA76A
           lda    #$03
           sta    $1D,y
           lda    #$01
           sta    $1008,y
           lda    #$00
           sta    $EB,y
LA76A:     inc    $80
           ldy    $80
           cpy    #$04
           bcs    LA775
           jmp    LA6B0

LA775:     lda    $102E
           bne    LA7CE
           lda    $1013
           beq    LA7CE
           dec    $1013
           bne    LA7A3
           lda    #$00
           sta    $100C
           tay
LA78A:     ldx    LAD28,y
           lda    $EB,y
           beq    LA79B
           cmp    #$03
           beq    LA79B
           lda    #$00
           sta    $EB,y
LA79B:     iny
           cpy    #$04
           bne    LA78A
           jmp    LA7CE

LA7A3:     cmp    #$46
           bcs    LA7CE
           inc    $84
           lda    $84
           cmp    #$07
           bcc    LA7CE
           lda    #$00
           sta    $84
           tay
LA7B4:     lda    $EB,y
           cmp    #$01
           beq    LA7C1
           cmp    #$02
           beq    LA7C1
           bne    LA7C9
LA7C1:     lda    $EB,y
           eor    #$03
           sta    $EB,y
LA7C9:     iny
           cpy    #$04
           bne    LA7B4
LA7CE:     jsr    LABE9
           lda    $102E
           bne    LA813
           inc    $1000
           lda    $1000
           cmp    #$03
           bcc    LA7F1
           lda    #$00
           sta    $1000
           lda    $EF
           eor    #$01
           sta    $EF
           sta    $F0
           sta    $F1
           sta    $F2
LA7F1:     ldy    #$00
LA7F3:     lda    $EB,y
           cmp    #$03
           bne    LA80E
           ldx    LAD28,y
           lda    $0E,x
           cmp    #$50
           bne    LA80E
           lda    $0F,x
           cmp    #$58
           bne    LA80E
           lda    #$04
           sta    $1008,y
LA80E:     iny
           cpy    #$04
           bne    LA7F3
LA813:     lda    $102E
           beq    LA82B
           lda    $1033
           bne    LA842
           ldy    $102E
           dey
           lda    #$03
           sta    $EB,y
           lda    #$00
           sta    $102E
LA82B:     ldy    #$00
LA82D:     ldx    LAD28,y
           lda    $0E,x
           sec
           sbc    $0C
           cmp    #$FC
           bcs    LA847
           cmp    #$05
           bcc    LA847
LA83D:     iny
           cpy    #$04
           bcc    LA82D
LA842:     lda    #$0A
           jmp    PAUSE

LA847:     lda    $0F,x
           sec
           sbc    $0D
           cmp    #$FC
           bcs    LA856
           cmp    #$05
           bcc    LA856
           bcs    LA83D
LA856:     lda    $EB,y
           beq    LA861
           cmp    #$03
           beq    LA83D
           bne    LA868
LA861:     lda    #$01
           sta    $102C
           bne    LA842
LA868:     iny
           sty    $102E
           ldy    $102D
           sed
           lda    $08
           clc
           adc    LA899,y
           sta    $08
           lda    $07
           adc    #$00
           sta    $07
           cld
           jsr    LA8AB
           lda    #$A0
           sta    $1033
           inc    $102D
           lda    $102D
           cmp    #$04
           bcc    LA896
           lda    #$00
           sta    $100C
LA896:     jmp    LA842

LA899:     .byte  $02,$04,$08,$16
LA89D:     .byte  $19,$32,$4B,$64
LA8A1:     .byte  $00,$01,$00,$FF,$00
LA8A6:     .byte  $FF,$00,$01,$00,$00
LA8AB:     lda    $07
           cmp    $04
           beq    LA8B5
           bcs    LA8C7
           bcc    LA8D3
LA8B5:     lda    $08
           cmp    $05
           beq    LA8BF
           bcs    LA8C7
           bcc    LA8D3
LA8BF:     lda    $09
           cmp    $06
           bcs    LA8C7
           bcc    LA8D3
LA8C7:     lda    $07
           sta    $04
           lda    $08
           sta    $05
           lda    $09
           sta    $06
LA8D3:     lda    $04
           sta    $18
           lda    $05
           sta    $19
           lda    $06
           sta    $1A
           lda    #$11
           sta    $00
           lda    #>SCREEN
           sta    $01
           jsr    LA91F
           lda    $07
           sta    $18
           lda    $08
           sta    $19
           lda    $09
           sta    $1A
           lda    #$03
           sta    $00
           lda    #>SCREEN
           sta    $01
           jsr    LA91F
           lda    $07
           cmp    #$01
           bne    LA91E
           lda    $1011
           bne    LA91E
           inc    $1011
           inc    NUM_LIVES
           lda    NUM_LIVES
           clc
           adc    #$30
           sta    SCREEN+$170
           lda    #$03
           sta    COLORRAM+$170
LA91E:     rts

LA91F:     lda    #$00
           sta    $1B
           tay
           tax
LA925:     lda    $18,x
           lsr    a
           lsr    a
           lsr    a
           lsr    a
           bne    LA936
           lda    $1B
           beq    LA93D
           lda    #$A8
           jmp    LA93B

LA936:     clc
           adc    #$A8
           inc    $1B
LA93B:     sta    ($00),y
LA93D:     iny
           lda    $18,x
           and    #$0F
           bne    LA94D
           lda    $1B
           beq    LA954
           lda    #$A8
           jmp    LA952

LA94D:     clc
           adc    #$A8
           inc    $1B
LA952:     sta    ($00),y
LA954:     iny
           inx
           cpx    #$03
           beq    LA95D
           jmp    LA925

LA95D:     dey
           lda    $1A
           bne    LA966
           lda    #$A8
           sta    ($00),y
LA966:     rts

LA967:     .byte  $00,$30,$60,$90,$C0
LA96C:     .byte  $60,$66,$6C,$72,$78
LA971:     .byte  $00,$17,$2E,$01,$18,$2F
LA977:     .byte  $00,$01,$02,$17,$18,$19
LA97D:     .byte  $00,$06,$0C,$12,$18
LA982:     jsr    LB0C8
           lda    $00
           sta    $73
           lda    $01
           sta    $74
           ldy    $C3
           lda    LA96C,y
           sta    $C4
           lda    LA967,y
           sta    $71
           sta    $00
           lda    #>(CHARMAP+$300)
           sta    $72
           sta    $01
           lda    #$00
           tay
LA9A4:     sta    $41,y
           sta    $8F,y
           iny
           cpy    #$30
           bne    LA9A4
           lda    $C2
           and    #$07
           beq    LA9B8
           jmp    LAA8F
LA9B8:     lda    $C1
           and    #$07
           sta    $78
           tay
           ldx    #$00
LA9C1:     lda    $21,x
           sta    $41,y
           lda    $29,x
           sta    $59,y
           lda    $31,x
           sta    $49,y
           lda    $39,x
           sta    $61,y
           iny
           inx
           cpx    #$08
           bne    LA9C1
           ldy    #$00
LA9DD:     lda    LA971,y
           sta    $103B,y
           iny
           cpy    #$06
           bne    LA9DD
LA9E8:     lda    $73
           sta    $00
           lda    $74
           sta    $01
           ldx    #$00
           stx    $75
LA9F4:     lda    #$00
           sta    $77
           ldy    $103B,x
           lda    ($00),y
           asl    a
           rol    $77
           asl    a
           rol    $77
           asl    a
           rol    $77
           sta    $02
           lda    #>CHARMAP
           clc
           adc    $77
           sta    $03
           stx    $76
           ldy    #$00
LAA13:     ldx    $75
           lda    ($02),y
           sta    $8F,x
           inc    $75
           iny
           cpy    #$08
           bne    LAA13
           ldx    $76
           inx
           cpx    #$06
           bne    LA9F4
           lda    $71
           sta    $00
           lda    $72
           sta    $01
           ldy    #$00
LAA31:     lda    $41,y
           ora    $8F,y
           sta    ($00),y
           iny
           cpy    #$30
           bne    LAA31
           lda    $73
           sta    $00
           lda    $74
           sta    $01
           ldx    #$00
LAA48:     lda    $78
           bne    LAA54
           cpx    #$02
           beq    LAA75
           cpx    #$05
           beq    LAA75
LAA54:     ldy    $103B,x
           lda    ($00),y
           sta    $E3,x
           lda    $C4
           sta    ($00),y
           jsr    LA3E1
           ldy    $C3
           bne    LAA6A
           lda    #$07
           bne    LAA6D
LAA6A:     lda    $1045
LAA6D:     ldy    $103B,x
           sta    ($00),y
           jsr    LA3E1
LAA75:     inc    $C4
           inx
           cpx    #$06
           bne    LAA48
           ldx    $C3
           ldy    LA97D,x
           ldx    #$00
LAA83:     lda    $E3,x
           sta    $C5,y
           iny
           inx
           cpx    #$06
           bne    LAA83
           rts

LAA8F:     sta    $78
           ldy    #$00
LAA93:     lda    $21,y
           sta    $41,y
           lda    $31,y
           sta    $59,y
           iny
           cpy    #$10
           bne    LAA93
           ldy    #$00
LAAA6:     ldx    #$00
LAAA8:     lsr    $41,x
           ror    $49,x
           ror    $51,x
           lsr    $59,x
           ror    $61,x
           ror    $69,x
           inx
           cpx    #$08
           bne    LAAA8
           iny
           cpy    $78
           bne    LAAA6
           ldy    #$00
LAAC0:     lda    LA977,y
           sta    $103B,y
           iny
           cpy    #$06
           bne    LAAC0
           jmp    LA9E8

LAACE:     jsr    LB0C8
           ldx    $C3
           ldy    LA97D,x
           ldx    #$00
LAAD8:     lda    $C5,y
           sta    $E3,x
           iny
           inx
           cpx    #$06
           bne    LAAD8
           ldy    #$00
LAAE5:     lda    $C2
           and    #$07
           bne    LAAF1
           lda    LA971,y
           jmp    LAAF4

LAAF1:     lda    LA977,y
LAAF4:     sta    $103B,y
           iny
           cpy    #$06
           bne    LAAE5
           ldx    #$00
LAAFE:     lda    $C1
           and    #$07
           bne    LAB12
           lda    $C2
           and    #$07
           bne    LAB12
           cpx    #$02
           beq    LAB3F
           cpx    #$05
           beq    LAB3F
LAB12:     ldy    $103B,x
           lda    $E3,x
           sta    ($00),y
           jsr    LA3E1
           lda    $C1
           cmp    #$78
           beq    LAB45
           cmp    #$59
           bcc    LAB38
           cmp    #$69
           bcs    LAB38
           lda    $C2
           cmp    #$40
           bcc    LAB38
           cmp    #$60
           bcs    LAB38
           lda    #$06
           bne    LAB3A
LAB38:     lda    #$01
LAB3A:     sta    ($00),y
           jsr    LA3E1
LAB3F:     inx
           cpx    #$06
           bne    LAAFE
           rts

LAB45:     lda    $C2
           cmp    #$40
           bcc    LAB38
           cmp    #$68
           bcs    LAB38
           lda    $1046
           bne    LAB3A
LAB54:     lda    $102E
           beq    LAB67
           ldy    #$00
LAB5B:     lda    #$00
           sta    $21,y
           iny
           cpy    #$20
           bne    LAB5B
           beq    LAB93
LAB67:     lda    $1005
           asl    a
           asl    a
           sta    $71
           lda    $0C
           and    #$07
           bne    LAB78
           lda    $0D
           and    #$07
LAB78:     lsr    a
           clc
           adc    $71
           tay
           lda    LABB3,y
           sta    $00
           lda    LABC3,y
           sta    $01
           ldy    #$00
LAB89:     lda    ($00),y
           sta    $21,y
           iny
           cpy    #$20
           bne    LAB89
LAB93:     lda    #$00
           sta    $C3
           lda    $0C
           sta    $C2
           lda    $0D
           sta    $C1
           jsr    LA982
           rts

LABA3:     lda    #$00
           sta    $C3
           lda    $0C
           sta    $C2
           lda    $0D
           sta    $C1
           jsr    LAACE
           rts

LABB3:     .byte  <LBA40,<LBA20,<LBA00,<LBA20
           .byte  <LBA80,<LBA60,<LBA00,<LBA60
           .byte  <LBAC0,<LBAA0,<LBA00,<LBAA0
           .byte  <LBB00,<LBAE0,<LBA00,<LBAE0
LABC3:     .byte  >LBA40,>LBA20,>LBA00,>LBA20
           .byte  >LBA80,>LBA60,>LBA00,>LBA60
           .byte  >LBAC0,>LBAA0,>LBA00,>LBAA0
           .byte  >LBB00,>LBAE0,>LBA00,>LBAE0
LABD3:     .byte  $80,$90
LABD5:     .byte  $00,$10,$20,$30
LABD9:     .byte  $A0,$B0,$C0,$D0
LABDD:     .byte  $40,$50,$60,$70
LABE1:     .byte  $02,$03,$04,$07
LABE5:     .byte  $00,$10,$20,$30
LABE9:     ldx    #$00
LABEB:     stx    $C3
           lda    LABE1,x
           sta    $1045
           txa
           asl    a
           tay
           lda    $0E,y
           sta    $C2
           lda    $0F,y
           sta    $C1
           inc    $C3
           ldy    $102E
           beq    LAC30
           cpy    $C3
           bne    LAC30
           ldy    $102D
           dey
           lda    #$05
           sta    $1045
           lda    LABE5,y
           sta    $00
           lda    #>LB800
           sta    $01
           ldy    #$00
LAC1F:     lda    ($00),y
           sta    $21,y
           lda    #$00
           sta    $31,y
           iny
           cpy    #$10
           bne    LAC1F
           beq    LAC7E
LAC30:     lda    #>LBC00
           sta    $01
           lda    $EB,x
           bne    LAC4B
           ldy    $EF,x
           lda    LABD3,y
           jsr    LAC8B
           ldy    $1D,x
           lda    LABD5,y
           jsr    LAC9E
           jmp    LAC7E

LAC4B:     ldy    #$01
           cmp    #$01
           beq    LAC57
           ldy    #$06
           cmp    #$02
           bne    LAC6A
LAC57:     lda    #$C0
           sty    $1045
           jsr    LAC9E
           ldy    $EF,x
           lda    LABD9,y
           jsr    LAC8B
           jmp    LAC7E

LAC6A:     ldy    #$00
           lda    #$00
LAC6E:     sta    $31,y
           iny
           cpy    #$10
           bne    LAC6E
           ldy    $1D,x
           lda    LABDD,y
           jsr    LAC9E
LAC7E:     jsr    LA982
           ldx    $C3
           cpx    #$04
           beq    LAC8A
           jmp    LABEB

LAC8A:     rts

LAC8B:     sty    $EA
           sta    $00
           ldy    #$00
LAC91:     lda    ($00),y
           sta    $31,y
           iny
           cpy    #$10
           bne    LAC91
           ldy    $EA
           rts

LAC9E:     sty    $EA
           sta    $00
           ldy    #$00
LACA4:     lda    ($00),y
           sta    $21,y
           iny
           cpy    #$10
           bne    LACA4
           ldy    $EA
           rts

LACB1:     ldx    #$03
LACB3:     txa
           asl    a
           tay
           lda    $0E,y
           sta    $C2
           lda    $0F,y
           sta    $C1
           stx    $C3
           inc    $C3
           jsr    LAACE
           ldx    $C3
           dex
           dex
           bpl    LACB3
           rts

LACCE:     ldy    $1002
           bne    LACDB
           lda    $C1
           cmp    #$08
           beq    LAD22
           bne    LACF7
LACDB:     cpy    #$01
           bne    LACE7
           lda    $C2
           cmp    #$A8
           beq    LAD22
           bne    LACF7
LACE7:     cpy    #$02
           bne    LACF3
           lda    $C1
           cmp    #$C8
           beq    LAD22
           bne    LACF7
LACF3:     lda    $C2
           beq    LAD22
LACF7:     jsr    LB0C8         ; get screen address for $c1/$c2 into $00/$01
           lda    $00
           sec
           sbc    #$17          ; go up one row
           sta    $00
           bcs    LAD05
           dec    $01
LAD05:     ldy    $1002
           ldx    LAD28,y
           ldy    LAD2C,x
           lda    ($00),y       ; get screen character
           cmp    #$B2          ; is it a wall tile?
           bcs    LAD22        
           inx
           ldy    LAD2C,x
           lda    ($00),y
           cmp    #$B2
           bcs    LAD22
           lda    #$00
           beq    LAD24
LAD22:     lda    #$01
LAD24:     sta    $1003
           rts

LAD28:     .byte  $00,$02,$04,$06
LAD2C:     .byte  $00,$01,$19,$30,$45,$46,$16,$2D
LAD34:     .byte  $00,$04,$08,$0C
LAD38:     .byte  $00,$03,$02,$03,$00,$01,$02,$01
LAD40:     .byte  $01,$03,$05,$05,$07,$07,$10,$10
           .byte  $20,$20,$30,$30,$50,$50
LAD4E:     .byte  $88,$8B,$8E,$8E,$91,$91,$94,$94
           .byte  $97,$97,$9A,$9A,$9D,$9D,$9D,$9D
LAD5E:     ldx    $0B
           ldy    LAD4E,x
           ldx    #$00
LAD65:     tya
           sta    $C5,x
           lda    #$20
           sta    $C8,x
           iny
           inx
           cpx    #$03
           bne    LAD65
           lda    #$A0
           sta    $1033
           lda    #$32
           sta    $1036
           lda    #$05
           sta    $1046
           ldx    $0B
           sed
           lda    $08
           clc
           adc    LAD40,x
           sta    $08
           lda    $07
           adc    #$00
           sta    $07
           cld
           jsr    LA8AB
           rts

LAD97:     lda    $C5
           cmp    #$5A
           beq    LAD5E
           lda    $0D
           cmp    #$78
           bne    LADAE
           lda    $0C
           cmp    #$38
           bcc    LADAE
           cmp    #$71
           bcs    LADAE
           rts

LADAE:     ldx    $1005
           stx    $72
           ldy    LAF25,x
           lda    $C5,y
           cmp    #$4E
           beq    LADC8
           cmp    #$52
           beq    LADC8
           cmp    #$58
           beq    LADC8
           jmp    LAE77

LADC8:     sed
           lda    $09
           clc
           adc    #$50
           sta    $09
           lda    $08
           adc    #$00
           sta    $08
           lda    $07
           adc    #$00
           sta    $07
           cld
           inc    $1006
           lda    #$00
           sta    $73
           sta    $102D
           ldy    #$00
LADE9:     lda    $EB,y
           cmp    #$03
           beq    LADFD
           lda    #$02
           sta    $EB,y
           lda    $1D,y
           eor    #$02
           sta    $1D,y
LADFD:     iny
           cpy    #$04
           bcc    LADE9
           ldy    $0B
           lda    LAF35,y
           sta    $1013
           lda    #$01
           sta    $100C
LAE0F:     ldy    LAF25,x
           lda    $C5,y
           and    #$3F
           asl    a
           asl    a
           asl    a
           sta    $00
           lda    #>(CHARMAP+$200)
           sta    $01
           ldx    $73
           ldy    #$00
LAE24:     lda    ($00),y
           eor    CHARMAP+$270,x
           sta    $21,y
           inx
           iny
           cpy    #$08
           bne    LAE24
           stx    $73
           ldx    $73
           lda    #$3F
           sta    $71
           ldy    #$00
LAE3C:     ldx    LAF0D,y
           lda    $21,x
           and    LAF11,y
           beq    LAE51
           lda    $71
           clc
           adc    LAF15,y
           sta    $71
           lda    LAF15,y
LAE51:     iny
           cpy    #$04
           bne    LAE3C
           lda    $71
           cmp    #$3F
           bne    LAE60
           lda    #$20
           sta    $71
LAE60:     ldx    $72
           ldy    LAF25,x
           lda    $71
           sta    $C5,y
           inx
           inx
           inx
           inx
           stx    $72
           cpx    #$10
           bcc    LAE0F
LAE74:     jmp    LAF09

LAE77:     and    #$3F
           asl    a
           asl    a
           asl    a
           sta    $00
           lda    #>(CHARMAP+$200)
           sta    $01
           ldy    #$06
           lda    ($00),y
           and    #$01
           bne    LAE74
           iny
           lda    ($00),y
           and    #$01
           beq    LAE74
           sed
           lda    $09
           clc
           adc    #$10
           sta    $09
           lda    $08
           adc    #$00
           sta    $08
           lda    $07
           adc    #$00
           sta    $07
           cld
           inc    $1006
           lda    #$00
           sta    $73
           ldx    $72
           lda    #$01
           sta    $100D
LAEB4:     ldy    LAF25,x
           lda    $C5,y
           cmp    #$4E
           bcs    LAED2
           ldx    $73
           clc
           adc    #$01
           and    LAF19,x
           cmp    #$40
           bne    LAEF5
           lda    #$20
           sta    $C5,y
           jmp    LAEFB

LAED2:     cmp    #$56
           bcs    LAEDF
           sec
           sbc    #$04
           sta    $C5,y
           jmp    LAEFB

LAEDF:     and    #$3F
           asl    a
           asl    a
           asl    a
           sta    $00
           ldx    $73
           ldy    LAF1D,x
           lda    ($00),y
           and    LAF21,x
           sta    ($00),y
           jmp    LAEFB

LAEF5:     sec
           sbc    #$01
           sta    $C5,y
LAEFB:     inc    $73
           lda    $72
           clc
           adc    #$04
           sta    $72
           tax
           cpx    #$10
           bcc    LAEB4
LAF09:     jsr    LA8AB
           rts

LAF0D:     .byte  $00,$00,$07,$07
LAF11:     .byte  $80,$01,$80,$01
LAF15:     .byte  $01,$02,$04,$08
LAF19:     .byte  $47,$4B,$4D,$4E
LAF1D:     .byte  $07,$07,$00,$00
LAF21:     .byte  $FE,$7F,$FE,$7F
LAF25:     .byte  $00,$01,$01,$00,$03,$02,$04,$01
           .byte  $01,$04,$02,$03,$04,$05,$05,$04
LAF35:     .byte  $E0,$A0,$A0,$C0,$80,$A0,$60,$80
           .byte  $40,$60,$20,$20,$20,$20,$01,$01
LAF45:     lda    $EB,y
           beq    LAF68
           cmp    #$03
           beq    LAF5E
           jsr    LB0AC
           lda    $1039
           sta    $7E
           lda    $103A
           sta    $7F
           jmp    LAF70

LAF5E:     lda    #$50
           sta    $7E
           lda    #$58
           sta    $7F
           bne    LAF70
LAF68:     lda    $0C
           sta    $7E
           lda    $0D
           sta    $7F
LAF70:     lda    $7E
           cmp    $C2
           bcc    LAF7A
           lda    #$01
           bne    LAF7C
LAF7A:     lda    #$00
LAF7C:     sta    $1015
           lda    $7F
           cmp    $C1
           bcc    LAF89
           lda    #$01
           bne    LAF8B
LAF89:     lda    #$00
LAF8B:     sta    $1016
           lda    $1015
           bne    LAF9F
           lda    $0E,x
           sec
           sbc    $7E
           sta    $78
           lda    #$00
           jmp    LAFA8

LAF9F:     lda    $7E
           sec
           sbc    $0E,x
           sta    $78
           lda    #$04
LAFA8:     sta    $77
           lda    $1016
           bne    LAFB9
           lda    $0F,x
           sec
           sbc    $7F
           sta    $79
           jmp    LAFC6

LAFB9:     lda    $7F
           sec
           sbc    $0F,x
           sta    $79
           lda    #$02
           ora    $77
           sta    $77
LAFC6:     lda    $78
           cmp    $79
           bcc    LAFCE
           inc    $77
LAFCE:     ldy    $77
           lda    LAD38,y
           sta    $1017
           lda    $1015
           bne    LAFDD
           lda    #$03
LAFDD:     sta    $1015
           lda    $1016
           beq    LAFE7
           lda    #$02
LAFE7:     sta    $1016
           rts

LAFEB:     ldy    $80
           lda    $102E
           beq    LAFFA
           lda    $EB,y
           cmp    #$03
           beq    LAFFA
           rts

LAFFA:     ldx    $81
           lda    $0E,x
           and    #$07
           bne    LB049
           lda    $0F,x
           and    #$07
           bne    LB049
           lda    $0E,x
           sta    $C2
           lda    $0F,x
           sta    $C1
           jsr    LAF45
           lda    $1017
           clc
           adc    $82
           tay
           lda    $101C,y
           beq    LB041
           lda    $1015
           clc
           adc    $82
           tay
           lda    $101C,y
           beq    LB041
           ldy    $1016
           clc
           adc    $82
           tay
           lda    $101C,y
           beq    LB041
           ldy    $82
LB039:     lda    $101C,y
           beq    LB041
           iny
           bne    LB039
LB041:     tya
           and    #$03
           ldy    $80
           sta    $1D,y
LB049:     ldx    $1D,y
           lda    LA8A1,x
           sta    $85
           lda    LA8A6,x
           sta    $86
           ldx    $81
           lda    $EB,y
           cmp    #$01
           beq    LB087
           cmp    #$02
           beq    LB087
           lda    $0E,x
           and    #$01
           bne    LB087
           lda    $0F,x
           and    #$01
           bne    LB087
           asl    $85
           asl    $86
           lda    $EB,y
           beq    LB087
           lda    $0E,x
           and    #$03
           bne    LB087
           lda    $0F,x
           and    #$03
           bne    LB087
           asl    $85
           asl    $86
LB087:     lda    $0E,x
           clc
           adc    $85
           sta    $0E,x
           lda    $0F,x
           clc
           adc    $86
           sta    $0F,x
           lda    $0F,x
           cmp    #$68
           beq    LB09C
           rts

LB09C:     lda    $0E,x
           cmp    #$90
           bcs    LB0A6
           cmp    #$18
           bcs    LB0AB
LB0A6:     lda    #$02
           sta    $1008,y
LB0AB:     rts

LB0AC:     asl    $1039
           rol    $103A
           rol    a
           rol    a
           eor    $1039
           rol    a
           eor    $1039
           lsr    a
           lsr    a
           eor    #$FF
           and    #$01
           ora    $1039
           sta    $1039
           rts

        ;; convert X/Y pixel coordinates in $c1/$c2 to screen address in $00/$01
LB0C8:     lda    $C2           ; get pixel column
           lsr    a             ; divide by 8
           lsr    a
           lsr    a
           sta    $00           ; store character column
           lda    $C1           ; get pixel row
           lsr    a             ; divide by 8
           lsr    a
           lsr    a
           tay
           lda    LB0E5,y       ; get row screen address (low byte)
           clc
           adc    $00           ; add character column
           sta    $00           ; store
           lda    LB102,y       ; get row screen address (high byte)
           adc    #$00          ; add carry
           sta    $01           ; store
           rts
LB0E5:     .byte  $00,$17,$2E,$45,$5C,$73,$8A,$A1
           .byte  $B8,$CF,$E6,$FD,$14,$2B,$42,$59
           .byte  $70,$87,$9E,$B5,$CC,$E3,$FA,$11
           .byte  $28,$3F,$56,$6D,$84
LB102:     .byte  >SCREEN+$00,>SCREEN+$00,>SCREEN+$00,>SCREEN+$00,>SCREEN+$00,>SCREEN+$00,>SCREEN+$00,>SCREEN+$00
           .byte  >SCREEN+$00,>SCREEN+$00,>SCREEN+$00,>SCREEN+$00,>SCREEN+$01,>SCREEN+$01,>SCREEN+$01,>SCREEN+$01
           .byte  >SCREEN+$01,>SCREEN+$01,>SCREEN+$01,>SCREEN+$01,>SCREEN+$01,>SCREEN+$01,>SCREEN+$01,>SCREEN+$02
           .byte  >SCREEN+$02,>SCREEN+$02,>SCREEN+$02,>SCREEN+$02,>SCREEN+$02
        
LB11F:     ldy    #$00
LB121:     lda    CHARROM+$000,y
           sta    CHARMAP+$000,y
           lda    CHARROM+$100,y
           sta    CHARMAP+$100,y
           lda    LBE00,y
           sta    CHARMAP+$200,y
           lda    LBF00,y
           sta    CHARMAP+$300,y
           lda    LB800,y
           sta    CHARMAP+$400,y
           lda    LB900,y
           sta    CHARMAP+$500,y
           cpy    #$30
           bcs    LB14F
           lda    LBF00,y
           sta    CHARMAP+$660,y
LB14F:     iny
           bne    LB121
           rts

        ;; read keyboard/joystick, put result in $16:
        ;; FF => no input
        ;; 00 => up
        ;; 01 => right
        ;; 02 => down
        ;; 03 => left
LB153:     lda    #$FF
           sta    $16
           ldx    #$03
LB159:     lda    LB1EE,x
           sta    VIA2+$0
LB15F:     lda    VIA2+$1
           cmp    VIA2+$1
           bne    LB15F
           and    LB1F2,x
           bne    LB171
           lda    LB1F6,x
           sta    $16
LB171:     dex
           bpl    LB159
           sei
           ldx    #$7F
           stx    VIA2+$2
LB17A:     lda    JOY_REG_RIGHT
           cmp    JOY_REG_RIGHT
           bne    LB17A
           ldx    #$FF
           stx    VIA2+$2
           ldx    #$7F
           stx    VIA2+$0
           cli
           and    #JOY_MASK_RIGHT
           bne    LB195
           lda    #$01
           sta    $16
LB195:     lda    JOY_REG_OTHER
           cmp    JOY_REG_OTHER
           bne    LB195
           tay
           ldx    #$02
LB1A0:     tya
           and    LB1FE,x
           bne    LB1AB
           lda    LB201,x
           sta    $16
LB1AB:     dex
           bpl    LB1A0
           rts

LB1AF:     lda    #$EF
           sta    VIA2+$0
LB1B4:     lda    VIA2+$1
           cmp    VIA2+$1
           bne    LB1B4
           and    #$80
           rts

LB1BF:     lda    #$00
           sta    $71
           lda    #$F7
           sta    VIA2+$0
LB1C8:     lda    VIA2+$1
           cmp    VIA2+$1
           bne    LB1C8
           and    #$80
           bne    LB1D8
           lda    #$01
           sta    $71
LB1D8:     lda    #$FB
           sta    VIA2+$0
LB1DD:     lda    VIA2+$1
           cmp    VIA2+$1
           bne    LB1DD
           and    #$80
           bne    LB1ED
           lda    #$02
           sta    $71
LB1ED:     rts

LB1EE:     .byte  $EF,$FB,$FB,$FD
LB1F2:     .byte  $20,$20,$40,$20
LB1F6:     .byte  $02,$03,$01,$00,$02,$04,$01,$0D
LB1FE:     .byte  JOY_MASK_UP,JOY_MASK_DOWN,JOY_MASK_LEFT
LB201:     .byte  $00,$02,$03,$DF,$EF,$F7,$01,$40
           .byte  $02

        ;; game screen (23*27=621 bytes)
        ;; if bit 7 set then blue, otherwise white
LB20A:     .byte  $A0,$A1,$7E,$7E,$7E,$7E,$7E,$7E
           .byte  $A8,$7E,$A2,$A3,$A4,$A5,$A6,$A7
           .byte  $7E,$7E,$7E,$7E,$7E,$7E,$A8,$47
           .byte  $4B,$4B,$4B,$4B,$4B,$4B,$4B,$4B
           .byte  $4B,$43,$BE,$47,$4B,$4B,$4B,$4B
           .byte  $4B,$4B,$4B,$4B,$4B,$43,$49,$46
           .byte  $42,$42,$4A,$46,$42,$42,$42,$4A
           .byte  $44,$BE,$49,$46,$42,$42,$42,$4A
           .byte  $46,$42,$42,$4A,$44,$52,$53,$B6
           .byte  $B7,$49,$44,$B6,$B2,$B7,$49,$44
           .byte  $BE,$49,$44,$B6,$B2,$B7,$49,$44
           .byte  $B6,$B7,$52,$53,$54,$55,$B9,$B8
           .byte  $49,$44,$B9,$B4,$B8,$49,$44,$BC
           .byte  $49,$44,$B9,$B4,$B8,$49,$44,$B9
           .byte  $B8,$54,$55,$49,$4C,$4B,$4B,$4D
           .byte  $4C,$4B,$4B,$4B,$4D,$4C,$4B,$4D
           .byte  $4C,$4B,$4B,$4B,$4D,$4C,$4B,$4B
           .byte  $4D,$44,$49,$46,$42,$42,$4A,$46
           .byte  $42,$4A,$46,$42,$42,$42,$42,$42
           .byte  $4A,$46,$42,$4A,$46,$42,$42,$4A
           .byte  $44,$49,$44,$BD,$BB,$49,$44,$BA
           .byte  $49,$44,$BD,$BF,$B2,$BF,$BB,$49
           .byte  $44,$BA,$49,$44,$BD,$BB,$49,$44
           .byte  $49,$4C,$4B,$4B,$4D,$44,$BE,$49
           .byte  $4C,$4B,$43,$BE,$47,$4B,$4D,$44
           .byte  $BE,$49,$4C,$4B,$4B,$4D,$44,$41
           .byte  $42,$42,$42,$4A,$44,$BE,$41,$42
           .byte  $42,$40,$BE,$41,$42,$42,$40,$BE
           .byte  $49,$46,$42,$42,$42,$40,$B2,$B2
           .byte  $B2,$B7,$49,$44,$B5,$BF,$BB,$20
           .byte  $20,$BC,$20,$20,$BD,$BF,$B3,$49
           .byte  $44,$B6,$B2,$B2,$B2,$20,$20,$20
LB30A:     .byte  $B3,$49,$44,$BE,$20,$20,$20,$20
           .byte  $20,$20,$20,$20,$20,$BE,$49,$44
           .byte  $B5,$20,$20,$20,$B4,$B4,$B4,$B8
           .byte  $49,$44,$BC,$20,$20,$20,$20,$20
           .byte  $20,$20,$20,$20,$BC,$49,$44,$B9
           .byte  $B4,$B4,$B4,$20,$20,$20,$20,$49
           .byte  $44,$20,$20,$20,$B6,$B2,$B2,$B2
           .byte  $B7,$20,$20,$20,$49,$44,$20,$20
           .byte  $20,$20,$20,$20,$20,$20,$49,$44
           .byte  $20,$20,$20,$B9,$B4,$B4,$B4,$B8
           .byte  $20,$20,$20,$49,$44,$20,$20,$20
           .byte  $20,$B2,$C6,$C9,$B7,$49,$44,$BA
           .byte  $20,$20,$20,$20,$20,$20,$20,$20
           .byte  $20,$BA,$49,$44,$B6,$C0,$C3,$B2
           .byte  $20,$C7,$CA,$B3,$49,$44,$BE,$20
           .byte  $20,$20,$20,$20,$20,$20,$20,$20
           .byte  $BE,$49,$44,$B5,$C1,$C4,$20,$B4
           .byte  $C8,$CB,$B8,$49,$44,$BC,$20,$20
           .byte  $BD,$BF,$B2,$BF,$BB,$20,$20,$BC
           .byte  $49,$44,$B9,$C2,$C5,$B4,$47,$4B
           .byte  $4B,$4B,$4D,$4C,$4B,$4B,$4B,$4B
           .byte  $43,$BE,$47,$4B,$4B,$4B,$4B,$4D
           .byte  $4C,$4B,$4B,$4B,$43,$49,$46,$42
           .byte  $42,$4A,$46,$42,$42,$42,$4A,$44
           .byte  $BE,$49,$46,$42,$42,$42,$4A,$46
           .byte  $42,$42,$4A,$44,$49,$44,$BD,$B7
           .byte  $49,$44,$BD,$BF,$BB,$49,$44,$BC
           .byte  $49,$44,$BD,$BF,$BB,$49,$44,$B6
           .byte  $BB,$49,$44,$52,$56,$43,$BE,$49
           .byte  $4C,$4B,$4B,$4B,$4D,$44,$20,$49
           .byte  $4C,$4B,$4B,$4B,$4D,$44,$BE,$47
           .byte  $58,$53,$50,$57,$44,$BE,$49,$46
LB40A:     .byte  $42,$4A,$46,$42,$40,$20,$41,$42
           .byte  $4A,$46,$42,$4A,$44,$BE,$49,$59
           .byte  $51,$B7,$49,$44,$BE,$49,$44,$BA
           .byte  $49,$44,$B6,$B2,$B2,$B2,$B7,$49
           .byte  $44,$BA,$49,$44,$BE,$49,$44,$B6
           .byte  $B3,$49,$44,$BC,$49,$44,$BC,$49
           .byte  $44,$B9,$B4,$B4,$B4,$B8,$49,$44
           .byte  $BC,$49,$44,$BC,$49,$44,$B5,$B3
           .byte  $49,$4C,$4B,$4D,$4C,$4B,$4D,$4C
           .byte  $4B,$4B,$4B,$4B,$4B,$4D,$4C,$4B
           .byte  $4D,$4C,$4B,$4D,$44,$B5,$B3,$41
           .byte  $42,$42,$42,$42,$42,$42,$42,$42
           .byte  $42,$42,$42,$42,$42,$42,$42,$42
           .byte  $42,$42,$42,$40,$B5

LB477:     .byte  $5A,$5B,$5C,$5D,$5E,$5F
LB47D:     .byte  $E8,$EC,$F0,$F4,$F6,$00
LB483:     .byte  $F6,$F2,$EE,$EA,$E8,$00
        
IRQ4:      lda    $1041
           sta    VIC+$B
           clc
           adc    $1043
           sta    $1041
           inc    $100E
           lda    $100E
           cmp    $1042
           bcc    LB4D9
           lda    #$00
           sta    $100E
           lda    $1043
           eor    #$FE
           sta    $1043
           lda    $1042
           eor    #$02
           sta    $1042
           inc    $1044
           lda    $1044
           cmp    #$0E
           bcc    LB4D9
           lda    #<IRQ5
           sta    $0314
           lda    #>IRQ5
           sta    $0315
           lda    #$C8
           sta    $1041
           lda    #$E6
           sta    $1042
           lda    #$03
           sta    $100E
LB4D9:     jmp    IRQ0

IRQ5:      lda    $1041
           sta    VIC+$B
           clc
           adc    $100E
           sta    $1041
           cmp    $1042
           bcc    LB4D9
           lda    #$00
           sta    $100E
           sta    VIC+$B
           lda    #<IRQ6
           sta    $0314
           lda    #>IRQ6
           sta    $0315
           jmp    IRQ0

IRQ6:      inc    $100E
           lda    $100E
           cmp    #$0A
           bcc    LB526
           lda    #<IRQ7
           sta    $0314
           lda    #>IRQ7
           sta    $0315
           lda    #$DC
           sta    $1041
           lda    #$F1
           sta    $1042
           lda    #$03
           sta    $100E
LB526:     jmp    IRQ0

IRQ7:      lda    $1041
           sta    VIC+$B
           clc
           adc    $100E
           sta    $1041
           cmp    $1042
           bcc    LB54A
           lda    #<IRQ0
           sta    $0314
           lda    #>IRQ0
           sta    $0315
           lda    #$00
           sta    VIC+$B
LB54A:     jmp    IRQ0

LB54D:     ldx    #$00
LB54F:     ldy    LA977,x
           lda    #$20
           sta    SCREEN+$163,y
           inx
           cpx    #$06
           bne    LB54F
           rts

IRQ3:      lda    $100C
           bne    LB590
           lda    $100E
           cmp    #$EB
           bcs    LB573
           lda    #$01
           sta    $1041
           lda    #$EB
           sta    $100E
LB573:     cmp    #$F6
           bcc    LB581
           lda    #$FF
           sta    $1041
           lda    #$F6
           sta    $100E
LB581:     lda    $100E
           clc
           adc    $1041
           sta    $100E
           sta    VIC+$C
           bne    LB5A7
LB590:     lda    $100C
           beq    LB5A7
           lda    $100F
           cmp    #$DF
           bcc    LB59E
           lda    #$C4
LB59E:     clc
           adc    #$03
           sta    $100F
           sta    VIC+$C
LB5A7:     lda    $1033
           beq    LB5C3
           clc
           adc    #$02
           cmp    #$F2
           bcc    LB5BA
           lda    #$FC
           sta    $1010
           lda    #$00
LB5BA:     sta    $1033
           sta    VIC+$B
           jmp    LB5E8

LB5C3:     ldy    #$00
LB5C5:     lda    $EB,y
           cmp    #$03
           beq    LB5D8
           iny
           cpy    #$04
           bne    LB5C5
           lda    #$00
           sta    VIC+$B
           beq    LB5E8
LB5D8:     ldy    $1010
           cpy    #$F4
           bcs    LB5E1
           ldy    #$FC
LB5E1:     dey
           sty    $1010
           sty    VIC+$B
LB5E8:     lda    $1042
           bne    LB606
           lda    $100D
           cmp    #$01
           bne    LB62A
           lda    #$00
           sta    $100D
           sta    $1042
           lda    $1043
           eor    #$01
           and    #$01
           sta    $1043
LB606:     ldy    $1042
           lda    $1043
           bne    LB614
           lda    LB47D,y
           jmp    LB617

LB614:     lda    LB483,y
LB617:     sta    VIC+$A
           iny
           sty    $1042
           cpy    #$06
           bne    LB62A
           lda    #$00
           sta    VIC+$A
           sta    $1042
LB62A:     jmp    IRQ0

LB62D:     lda    #<IRQ4
           sta    $0314
           lda    #>IRQ4
           sta    $0315
           lda    #$00
           sta    $100E
           sta    $1044
           lda    #$F3
           sta    $1041
           lda    #$04
           sta    $1042
           lda    #$01
           sta    $1043
           rts

IRQ2:      inc    $C0
           lda    $C0
           cmp    #$04
           bcc    LB68D
           lda    #$00
           sta    VIC+$C
           lda    $BF
           cmp    #$19
           bcs    LB668
           lda    $C0
           cmp    #$08
           bcc    LB68D
LB668:     lda    #$00
           sta    $C0
           ldy    $BF
           lda    LB690,y
           sta    VIC+$C
           iny
           sty    $BF
           cpy    #$10
           bne    LB67F
           lda    #$01
           sta    $17
LB67F:     cpy    #$28
           bne    LB68D
           lda    #<IRQ0
           sta    $0314
           lda    #>IRQ0
           sta    $0315
LB68D:     jmp    IRQ0
LB690:     .byte  $E1,$F0,$EB,$E7,$EB,$00,$E7,$00
           .byte  $E3,$F1,$EC,$E8,$EC,$00,$E8,$00
           .byte  $E1,$F0,$EB,$E7,$EB,$00,$E7,$00
           .byte  $E7,$E8,$EA,$00,$EA,$EB,$EC,$00
           .byte  $EC,$ED,$EF,$00,$F0,$F0,$F0,$00
        
LB6B8:     jsr    LA4AF
           lda    #$01
           ldy    #$00
LB6BF:     sta    COLORRAM+$000,y
           sta    COLORRAM+$100,y
           iny
           bne    LB6BF
           lda    #$07
           sta    COLORRAM+$8F
           sta    COLORRAM+$A5
           sta    COLORRAM+$A7
           sta    COLORRAM+$BD
           lda    #$6E
           sta    VIC+$F
           lda    #$CE
           sta    SCREEN+$8F
           lda    #$D0
           sta    SCREEN+$BD
           ldy    #$00
LB6E7:     lda    LB74B,y
           sta    SCREEN+$12B,y
           cpy    #$0E
           bcs    LB6F7
           lda    LB730,y
           sta    SCREEN+$A5,y
LB6F7:     cpy    #$0D
           bcs    LB701
           lda    LB73E,y
           sta    SCREEN+$EA,y
LB701:     iny
           cpy    #$17
           bne    LB6E7
LB706:     inc    $72
           lda    $72
           bne    LB71C
           inc    $71
           lda    $71
           and    #$07
           ldy    #$00
LB714:     sta    COLORRAM+$1BB,y
           iny
           cpy    #$0A
           bne    LB714
LB71C:     lda    #$FD
           sta    VIA2+$0
LB721:     lda    VIA2+$1
           cmp    VIA2+$1
           bne    LB721
           and    #$20
           bne    LB706
           jmp    LA0EF

        ;; game start screen
LB730:     .byte  $CF,$20,$D1,$20,$26,$20,$0A,$0F ; L ; & JOYSTICK
           .byte  $19,$13,$14,$09,$03,$0B
LB73E:     .byte  $20,$20,$20,$20,$20,$20,$20,$20 ; [SPACES]
           .byte  $20,$20,$20,$20,$20
LB74B:     .byte  $10,$15,$13,$08,$20,$27,$CE,$27 ; PUSH 'P' FOR GAME START
           .byte  $20,$06,$0F,$12,$20,$07,$01,$0D
           .byte  $05,$20,$13,$14,$01,$12,$14

        ;; unknown/unused? (data, not code)
LB762:     .byte  $E0
           .byte  $E0,$03,$01,$00,$00,$00,$01,$07
           .byte  $0F,$00,$80,$C0,$60,$70,$FF,$FF
           .byte  $F8,$00,$01,$03,$06,$0E,$FF,$FF
           .byte  $1F,$C0,$80,$38,$07,$38,$80,$E0
           .byte  $F0,$0F,$0E,$1E,$1C,$1C,$1C,$18
           .byte  $18,$18,$0C,$06,$03,$07,$0C,$18
           .byte  $30,$18,$30,$60,$C0,$E0,$30,$18
           .byte  $0C,$F0,$70,$78,$38,$38,$38,$18
           .byte  $18,$18,$18,$18,$18,$18,$18,$7E
           .byte  $E7,$60,$7F,$3C,$03,$00,$00,$00
           .byte  $00,$06,$FE,$3C,$C0,$00,$00,$00
           .byte  $00,$18,$18,$18,$18,$18,$18,$7E
           .byte  $E7,$00,$00,$00,$00,$01,$03,$07
           .byte  $07,$1F,$3F,$60,$C0,$80,$00,$FF
           .byte  $FF,$F8,$FC,$06,$03,$01,$00,$FF
           .byte  $FF,$00,$00,$00,$00,$80,$C0,$E0
           .byte  $E0,$03,$01,$00,$00,$00,$01,$07
           .byte  $0F,$00,$80,$C0,$60,$70,$FF,$FF
           .byte  $F8,$00,$01,$03,$06,$0E,$FF,$FF
           .byte  $1F,$C0,$80,$38,$07
        
;;; ---- graphics characters ----

        ;; point-increase numbers
LB800:     .byte  $31,$4A,$4A,$0A,$12,$22,$42,$79 ; 200
           .byte  $8C,$52,$52,$52,$52,$52,$52,$8C
           .byte  $11,$32,$52,$52,$52,$7A,$12,$11 ; 400
           .byte  $8C,$52,$52,$52,$52,$52,$52,$8C
           .byte  $31,$4A,$4A,$32,$4A,$4A,$4A,$31 ; 800
           .byte  $8C,$52,$52,$52,$52,$52,$52,$8C
           .byte  $98,$A5,$A1,$B9,$A5,$A5,$A5,$98 ; 1600
           .byte  $C6,$29,$29,$29,$29,$29,$29,$C6
           .byte  $04,$0C,$14,$04,$04,$04,$04,$1F ; 100
           .byte  $38,$45,$45,$45,$45,$45,$45,$38
           .byte  $E0,$10,$10,$10,$10,$10,$10,$E0
           .byte  $0E,$11,$01,$06,$01,$01,$11,$0E ; 300
           .byte  $38,$45,$45,$45,$45,$45,$45,$38
           .byte  $E0,$10,$10,$10,$10,$10,$10,$E0
           .byte  $1F,$10,$10,$1E,$01,$01,$11,$0E ; 500
           .byte  $38,$45,$45,$45,$45,$45,$45,$38
           .byte  $E0,$10,$10,$10,$10,$10,$10,$E0
           .byte  $1F,$11,$11,$02,$04,$04,$04,$04 ; 700
           .byte  $38,$45,$45,$45,$45,$45,$45,$38
           .byte  $E0,$10,$10,$10,$10,$10,$10,$E0
           .byte  $10,$31,$51,$11,$11,$11,$11,$7C ; 1000
           .byte  $E3,$14,$14,$14,$14,$14,$14,$E3
           .byte  $8E,$51,$51,$51,$51,$51,$51,$8E
           .byte  $38,$45,$05,$05,$19,$21,$41,$7C ; 2000
           .byte  $E3,$14,$14,$14,$14,$14,$14,$E3
           .byte  $8E,$51,$51,$51,$51,$51,$51,$8E
           .byte  $38,$45,$05,$19,$05,$05,$45,$38 ; 3000
           .byte  $E3,$14,$14,$14,$14,$14,$14,$E3
           .byte  $8E,$51,$51,$51,$51,$51,$51,$8E
           .byte  $7C,$41,$41,$79,$05,$05,$45,$38 ; 5000
           .byte  $E3,$14,$14,$14,$14,$14,$14,$E3
           .byte  $8E,$51,$51,$51,$51,$51,$51,$8E

LB900:     .byte  $DB,$9B,$DB,$DB,$DB,$DB,$8C,$FF ; 1UP
           .byte  $A1,$AE,$AE,$A1,$AF,$AF,$6F,$FF
           .byte  $BB,$BB,$BB,$83,$BB,$BB,$BB,$FF ; HI-SCORE
           .byte  $1F,$BF,$BF,$B8,$BF,$BF,$1F,$FF
           .byte  $F1,$EE,$EF,$31,$FE,$EE,$F1,$FF
           .byte  $C7,$BA,$BE,$BE,$BE,$BA,$C7,$FF
           .byte  $18,$EB,$EB,$E8,$EA,$EB,$1B,$FF
           .byte  $60,$AF,$AF,$61,$EF,$6F,$A0,$FF
           .byte  $83,$39,$31,$29,$19,$39,$83,$FF ; 0
           .byte  $E7,$C7,$A7,$E7,$E7,$E7,$81,$FF ; 1
           .byte  $83,$39,$F9,$E3,$8F,$3F,$01,$FF ; 2
           .byte  $83,$39,$F9,$E3,$F9,$39,$83,$FF ; 3
           .byte  $E3,$C3,$93,$33,$01,$F3,$F3,$FF ; 4
           .byte  $01,$3F,$07,$F3,$F9,$33,$87,$FF ; 5
           .byte  $83,$39,$3F,$03,$39,$39,$83,$FF ; 6
           .byte  $01,$39,$F3,$E7,$CF,$CF,$CF,$FF ; 7
           .byte  $83,$39,$39,$83,$39,$39,$83,$FF ; 8
           .byte  $83,$39,$39,$81,$F9,$F3,$87,$FF ; 9
           .byte  $FF,$00,$00,$00,$00,$00,$00,$00 ; top line
           .byte  $01,$01,$01,$01,$01,$01,$01,$01 ; right line
           .byte  $00,$00,$00,$00,$00,$00,$00,$FF ; bottom line
           .byte  $80,$80,$80,$80,$80,$80,$80,$80 ; left line
           .byte  $3F,$40,$80,$80,$80,$80,$80,$80 ; top-left corner
           .byte  $FC,$02,$01,$01,$01,$01,$01,$01 ; top-right corner
           .byte  $01,$01,$01,$01,$01,$01,$02,$FC ; bottom-right corner
           .byte  $80,$80,$80,$80,$80,$80,$40,$3F ; bottom-left corner
           .byte  $3C,$42,$81,$81,$81,$81,$81,$81 ; downward "U"
           .byte  $FC,$02,$01,$01,$01,$01,$02,$FC ; left "U"
           .byte  $81,$81,$81,$81,$81,$81,$42,$3C ; right-side-up "U"
           .byte  $3F,$40,$80,$80,$80,$80,$40,$3F ; right "U"
           .byte  $81,$81,$81,$81,$81,$81,$81,$81 ; left and right line
           .byte  $FF,$00,$00,$00,$00,$00,$00,$FF ; top and bottom line
        
        ;; PACMAN tiles (top-left, top-right, bottom-left, bottom-right)
LBA00:     .byte  $00,$07,$1F,$3F,$3F,$7F,$7F,$7F ; pacman static
           .byte  $00,$E0,$F8,$FC,$FC,$FE,$FE,$FE
           .byte  $7F,$7F,$7F,$3F,$3F,$1F,$07,$00
           .byte  $FE,$FE,$FE,$FC,$FC,$F8,$E0,$00
LBA20:     .byte  $00,$00,$18,$38,$3C,$7C,$7E,$7E ; pacman up 1
           .byte  $00,$00,$18,$1C,$3C,$3E,$7E,$7E
           .byte  $7F,$7F,$7F,$3F,$3F,$1F,$07,$00
           .byte  $FE,$FE,$FE,$FC,$FC,$F8,$E0,$00
LBA40:     .byte  $00,$00,$00,$20,$30,$78,$7C,$7E ; pacman up 2
           .byte  $00,$00,$00,$04,$0C,$1E,$3E,$7E
           .byte  $7F,$7F,$7F,$3F,$3F,$1F,$07,$00
           .byte  $FE,$FE,$FE,$FC,$FC,$F8,$E0,$00
LBA60:     .byte  $00,$07,$1F,$3F,$3F,$7F,$7F,$7F ; pacman right 1
           .byte  $00,$E0,$F8,$FC,$FC,$F0,$C0,$00
           .byte  $7F,$7F,$7F,$3F,$3F,$1F,$07,$00
           .byte  $00,$C0,$F0,$FC,$FC,$F8,$E0,$00
LBA80:     .byte  $00,$07,$1F,$3F,$3F,$7F,$7F,$7F ; pacman right 2
           .byte  $00,$E0,$F8,$F0,$E0,$C0,$80,$00
           .byte  $7F,$7F,$7F,$3F,$3F,$1F,$07,$00
           .byte  $00,$80,$C0,$E0,$F0,$F8,$E0,$00
LBAA0:     .byte  $00,$07,$1F,$3F,$3F,$7F,$7F,$7F ; pacman down 1
           .byte  $00,$E0,$F8,$FC,$FC,$FE,$FE,$FE
           .byte  $7E,$7E,$7C,$3C,$38,$18,$00,$00
           .byte  $7E,$7E,$3E,$3C,$1C,$18,$00,$00
LBAC0:     .byte  $00,$07,$1F,$3F,$3F,$7F,$7F,$7F ; pacman down 2
           .byte  $00,$E0,$F8,$FC,$FC,$FE,$FE,$FE
           .byte  $7E,$7C,$78,$30,$20,$00,$00,$00
           .byte  $7E,$3E,$1E,$0C,$04,$00,$00,$00
LBAE0:     .byte  $00,$07,$1F,$3F,$3F,$0F,$03,$00 ; pacman left 1
           .byte  $00,$E0,$F8,$FC,$FC,$FE,$FE,$FE
           .byte  $00,$03,$0F,$3F,$3F,$1F,$07,$00
           .byte  $FE,$FE,$FE,$FC,$FC,$F8,$E0,$00
LBB00:     .byte  $00,$07,$1F,$0F,$07,$03,$01,$00 ; pacman left 2
LBB08:     .byte  $00,$E0,$F8,$FC,$FC,$FE,$FE,$FE
LBB10:     .byte  $00,$01,$03,$07,$0F,$1F,$07,$00
LBB18:     .byte  $FE,$FE,$FE,$FC,$FC,$F8,$E0,$00
LBB20:     .byte  $00,$00,$00,$00,$00,$60,$78,$7E ; pacman dissolving 1
           .byte  $00,$00,$00,$00,$00,$06,$1E,$7E
           .byte  $7F,$FF,$FF,$FF,$7F,$3F,$0F,$00
           .byte  $FE,$FF,$FF,$FF,$FE,$FC,$F0,$00
LBB40:     .byte  $00,$00,$00,$00,$00,$00,$00,$00 ; pacman dissolving 2
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $7F,$7F,$FF,$FF,$7F,$7F,$3F,$1C
           .byte  $FE,$FE,$FF,$FF,$FE,$FE,$FC,$38
LBB60:     .byte  $00,$00,$00,$00,$00,$00,$00,$00 ; pacman dissolving 3
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $01,$07,$1F,$7F,$7F,$3F,$3F,$0C
           .byte  $80,$E0,$F8,$FE,$FE,$FC,$FC,$30
LBB80:     .byte  $00,$00,$00,$00,$00,$00,$00,$00 ; pacman dissolving 4
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $01,$03,$07,$0F,$1F,$3F,$1F,$0E
           .byte  $80,$C0,$E0,$F0,$F8,$FC,$F8,$70
LBBA0:     .byte  $00,$00,$00,$00,$00,$00,$00,$00 ; pacman dissolving 5
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $01,$03,$03,$07,$07,$0F,$0F,$06
           .byte  $80,$C0,$C0,$E0,$E0,$F0,$F0,$60
LBBC0:     .byte  $00,$00,$00,$00,$00,$00,$00,$00 ; pacman dissolving 6
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $01,$01,$03,$03,$03,$07,$07,$03
           .byte  $80,$80,$C0,$C0,$C0,$E0,$E0,$C0
LBBE0:     .byte  $00,$00,$00,$04,$22,$10,$08,$E0 ; pacman dissolving 7
           .byte  $00,$00,$00,$20,$44,$08,$10,$07
           .byte  $08,$10,$22,$04,$00,$00,$00,$00
           .byte  $10,$08,$44,$20,$00,$00,$00,$00

        ;; ghost tiles
LBC00:     .byte  $00,$07,$1F,$31,$2A,$6E,$6E,$6E
           .byte  $00,$E0,$F8,$8C,$54,$76,$76,$76
           .byte  $00,$07,$1F,$31,$2E,$6C,$6C,$6E
           .byte  $00,$E0,$F8,$8C,$74,$66,$66,$76
           .byte  $00,$07,$1F,$31,$2E,$6E,$6E,$6A
           .byte  $00,$E0,$F8,$8C,$74,$76,$76,$56
           .byte  $00,$07,$1F,$31,$2E,$66,$66,$6E
           .byte  $00,$E0,$F8,$8C,$74,$36,$36,$76
           .byte  $00,$00,$0E,$1B,$1F,$1F,$1F,$0E
           .byte  $00,$00,$70,$D8,$F8,$F8,$F8,$70
           .byte  $00,$00,$0E,$1F,$1C,$1C,$1F,$0E
           .byte  $00,$00,$70,$F8,$E0,$E0,$F8,$70
           .byte  $00,$00,$0E,$1F,$1F,$1F,$1B,$0E
           .byte  $00,$00,$70,$F8,$F8,$F8,$D8,$70
           .byte  $00,$00,$0E,$1F,$07,$07,$1F,$0E
           .byte  $00,$00,$70,$F8,$38,$38,$F8,$70
           .byte  $71,$7F,$7F,$7F,$7F,$7B,$31,$00
           .byte  $8E,$FE,$FE,$FE,$FE,$DE,$8C,$00
           .byte  $71,$7F,$7F,$7F,$7F,$6E,$46,$00
           .byte  $8E,$FE,$FE,$FE,$FE,$76,$62,$00
           .byte  $7F,$66,$59,$7F,$7F,$7B,$31,$00
           .byte  $FE,$66,$9A,$FE,$FE,$DE,$8C,$00
           .byte  $7F,$66,$59,$7F,$7F,$6E,$46,$00
           .byte  $FE,$66,$9A,$FE,$FE,$76,$62,$00
           .byte  $00,$07,$1F,$3F,$3F,$73,$73,$7F
           .byte  $00,$E0,$F8,$FC,$FC,$CE,$CE,$FE
        
           .byte  $01,$02,$04,$08,$10,$20,$40,$80
           .byte  $01,$02,$04,$08,$10,$20,$40,$80
LBCE0:     .byte  $80,$00,$00,$00,$C0,$E0,$F0,$F1
           .byte  $F1,$F0,$E0,$C0,$00,$00,$00,$01
           .byte  $01,$00,$00,$00,$03,$07,$0F,$8F
           .byte  $8F,$0F,$07,$03,$00,$00,$00,$80
LBD00:     .byte  $00,$00,$00,$00,$01,$01,$02,$04
LBD08:     .byte  $E0,$E0,$60,$A0,$20,$10,$10,$08
LBD10:     .byte  $1E,$2F,$7F,$5F,$5F,$3F,$1E,$00
LBD18:     .byte  $08,$3C,$BE,$BF,$BF,$3F,$7E,$3C
           .byte  $01,$01,$0F,$2A,$75,$5F,$FD,$B7
           .byte  $80,$80,$F0,$A8,$56,$FE,$DB,$7F
           .byte  $DE,$7B,$7F,$2E,$17,$0D,$07,$01
           .byte  $EF,$7E,$DA,$FC,$E8,$B0,$E0,$80
           .byte  $00,$00,$00,$01,$03,$18,$7F,$7F
           .byte  $00,$00,$00,$C0,$20,$08,$2E,$56
           .byte  $FF,$FF,$FF,$FF,$FF,$7F,$3F,$0F
           .byte  $57,$A7,$CF,$FF,$FF,$FE,$FC,$F0
           .byte  $00,$03,$01,$1D,$7E,$CF,$FF,$9F
           .byte  $00,$00,$80,$B8,$7E,$FF,$FF,$FF
           .byte  $9F,$FF,$7F,$7F,$3F,$3F,$1F,$0E
           .byte  $FF,$FF,$FE,$FE,$FC,$FC,$F8,$70
           .byte  $1F,$01,$01,$0C,$3D,$5A,$67,$F9
           .byte  $F8,$84,$80,$50,$EC,$8E,$76,$7B
           .byte  $FA,$37,$CF,$66,$79,$3B,$17,$07
           .byte  $7C,$BD,$5B,$66,$AE,$CC,$B0,$60
           .byte  $00,$01,$03,$47,$4F,$7F,$7F,$7F
           .byte  $00,$80,$C0,$E2,$F2,$FE,$FE,$FE
           .byte  $3F,$1D,$0D,$05,$01,$01,$01,$01
           .byte  $FC,$B8,$B0,$A0,$80,$80,$80,$80
           .byte  $00,$06,$09,$08,$10,$21,$33,$7F
           .byte  $00,$C0,$20,$18,$0C,$DC,$DE,$FE
           .byte  $7F,$00,$7F,$7F,$1F,$03,$01,$07
           .byte  $FE,$00,$FE,$FE,$F8,$C0,$80,$E0
           .byte  $07,$0C,$3F,$40,$7F,$40,$3F,$07
           .byte  $E0,$30,$FC,$02,$FE,$02,$FC,$60
           .byte  $07,$03,$01,$03,$07,$03,$07,$03
           .byte  $60,$60,$60,$60,$60,$60,$40,$80

LBE00:     .byte  $80,$00,$00,$00,$00,$00,$00,$00
           .byte  $01,$00,$00,$00,$00,$00,$00,$00
           .byte  $81,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$80
           .byte  $80,$00,$00,$00,$00,$00,$00,$80
           .byte  $01,$00,$00,$00,$00,$00,$00,$80
           .byte  $81,$00,$00,$00,$00,$00,$00,$80
           .byte  $00,$00,$00,$00,$00,$00,$00,$01
           .byte  $80,$00,$00,$00,$00,$00,$00,$01
           .byte  $01,$00,$00,$00,$00,$00,$00,$01
           .byte  $81,$00,$00,$00,$00,$00,$00,$01
           .byte  $00,$00,$00,$00,$00,$00,$00,$81
           .byte  $80,$00,$00,$00,$00,$00,$00,$81
           .byte  $01,$00,$00,$00,$00,$00,$00,$81
           .byte  $00,$00,$00,$00,$03,$07,$0F,$0F
           .byte  $00,$00,$00,$00,$C0,$E0,$F0,$F0
           .byte  $0F,$0F,$07,$03,$00,$00,$00,$00
           .byte  $F0,$F0,$E0,$C0,$00,$00,$00,$00
           .byte  $01,$00,$00,$00,$03,$07,$0F,$0F
           .byte  $80,$00,$00,$00,$C0,$E0,$F0,$F0
           .byte  $0F,$0F,$07,$03,$00,$00,$00,$01
           .byte  $F0,$F0,$E0,$C0,$00,$00,$00,$80
           .byte  $80,$00,$00,$00,$C0,$E0,$F0,$F1
           .byte  $F1,$F0,$E0,$C0,$00,$00,$00,$01
           .byte  $01,$00,$00,$00,$03,$07,$0F,$8F
           .byte  $8F,$0F,$07,$03,$00,$00,$00,$80
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $01,$01,$02,$04,$1E,$2F,$7F,$5F
           .byte  $5F,$3F,$1E,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$E0,$E0,$60,$A0
           .byte  $20,$10,$10,$08,$08,$3C,$BE,$BF
           .byte  $BF,$3F,$7E,$3C,$00,$00,$00,$00
        
LBF00:     .byte  $FF,$81,$BF,$BF,$87,$BF,$BF,$FF ; inverse "F"
           .byte  $FF,$EF,$CF,$EF,$EF,$EF,$C7,$FF ; inverse "1"
           .byte  $FF,$83,$BD,$BD,$83,$BF,$BF,$FF ; inverse "P"
           .byte  $FF,$BF,$BF,$BF,$BF,$BD,$81,$FF ; inverse "L"
           .byte  $FF,$FF,$FF,$FF,$FF,$E7,$E7,$FF ; inverse "."
           .byte  $FF,$E7,$E7,$FF,$E7,$E7,$CF,$FF ; inverse ";"
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
           .byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
