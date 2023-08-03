;;; Atari version of PACMAN for VIC-20

CHARSET           := $1400      ; [$7400-$7BFF] character set location (used by VIC)
SCREEN            := $1E00      ; [$7E00-$7FFF] screen memory location (used by VIC)
VIC               := $9000
VIA1              := $9110
VIA2              := $9120
COLORRAM          := $9400
JOY_REG_RIGHT     := VIA2+$0
JOY_REG_OTHER     := VIA1+$1
JOY_MASK_UP       := $04
JOY_MASK_DOWN     := $08
JOY_MASK_LEFT     := $10
JOY_MASK_RIGHT    := $80
JOY_MASK_BUTTON   := $20
        
P1SCORE    := $2D        ; [$2d-$2f] player 1 score (6 digits, BCD encoded, MSB first)
P2SCORE    := $30        ; [$30-$32] player 2 score (6 digits, BCD encoded, MSB first)
HIGHSCORE  := $33        ; [$33-$35] high score (6 digits, BCD encoded, MSB first)
LEVEL1     := $5B        ; skill level for player 1
LEVEL2     := $5C        ; skill level for player 2
LIVES1     := $60        ; number of lives for player 1
LIVES2     := $61        ; number of lives for player 2
NPLAYERS   := $62        ; number of players (0=1 player, $FF=2 players)
CURPLAYER  := $63        ; current player (0=player 1, 1=player 2)
CURSCREEN1 := $1000      ; [$1000-$118B] player 1 current screen (only rows 2-18)
CURSCREEN2 := $118C      ; [$118C-$1318] player 2 current screen (only rows 2-18)
COLOR      := $1900      ; [$1900-$1AF9] unpacked screen color data
INISCREEN  := $1AFA      ; [$1AFA-$1CF9] unpacked screen background (containing all dots)
STARTLIVES := 3
        
        
           .org $A000
           .setcpu"6502"

           .word  LABC6,LABF2
           .byte  $41,$30,$C3,$C2,$CD ; "A0cbm" signature (PETSCII)

           ;; [unused?]
           .byte  $02,$BB,$5A,$30,$5F,$EE,$3D,$A8

        ;; game screen color (22*23=506 nybbles packed into 253 bytes)
GAMECOLOR: .byte  $11,$11,$11,$11,$11,$11,$11
           .byte  $11,$11,$11,$11,$66,$66,$66,$66
           .byte  $66,$66,$66,$66,$66,$66,$66,$61
           .byte  $11,$11,$11,$11,$66,$11,$11,$11
           .byte  $11,$16,$61,$11,$11,$11,$11,$66
           .byte  $11,$11,$11,$11,$16,$61,$16,$61
           .byte  $16,$11,$66,$11,$61,$16,$61,$16
           .byte  $61,$11,$11,$11,$11,$11,$11,$11
           .byte  $11,$11,$16,$61,$11,$11,$11,$11
           .byte  $11,$11,$11,$11,$11,$16,$66,$66
           .byte  $61,$16,$11,$66,$11,$61,$16,$66
           .byte  $66,$11,$11,$11,$16,$11,$11,$11
           .byte  $61,$11,$11,$11,$11,$11,$11,$16
           .byte  $11,$11,$11,$61,$11,$11,$11,$66
           .byte  $66,$61,$16,$66,$11,$66,$61,$16
           .byte  $66,$66,$61,$11,$11,$11,$11,$11
           .byte  $11,$11,$11,$11,$16,$61,$11,$11
           .byte  $11,$11,$11,$11,$11,$11,$11,$16
           .byte  $61,$16,$11,$61,$16,$66,$61,$16
           .byte  $11,$61,$16,$61,$16,$11,$61,$16
           .byte  $66,$61,$16,$11,$61,$16,$61,$11
           .byte  $11,$61,$17,$77,$11,$16,$11,$11
           .byte  $16,$61,$11,$11,$61,$17,$77,$11
           .byte  $16,$11,$11,$16,$61,$16,$66,$66
           .byte  $66,$11,$66,$66,$66,$61,$16,$61
           .byte  $11,$11,$11,$11,$11,$11,$11,$11
           .byte  $11,$16,$61,$11,$11,$11,$11,$11
           .byte  $11,$11,$11,$11,$16,$66,$66,$66
           .byte  $66,$66,$66,$66,$66,$66,$66,$66
           .byte  $07,$77,$77,$74,$45,$57,$72,$27
           .byte  $72,$21,$20,$07,$77,$77,$74,$45
           .byte  $57,$72,$27,$72,$22,$20
        
GFXCHARS1: .byte  $00,$00,$00,$00,$00,$00,$00,$03 ;  0
           .byte  $00,$00,$00,$00,$00,$FF,$00,$FF ;  1
           .byte  $00,$00,$00,$00,$00,$00,$00,$C0 ;  2
           .byte  $05,$05,$05,$05,$05,$05,$05,$05 ;  3
           .byte  $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0 ;  4
           .byte  $03,$03,$03,$03,$03,$03,$03,$FF ;  5
           .byte  $C0,$C0,$C0,$C0,$C0,$C0,$C0,$FF ;  6
           .byte  $00,$00,$00,$00,$00,$00,$00,$00 ;  7
           .byte  $FF,$80,$80,$80,$80,$80,$80,$FF ;  8
           .byte  $FF,$01,$01,$01,$01,$01,$01,$FF ;  9
           .byte  $00,$00,$00,$00,$00,$00,$00,$FF ; 10
           .byte  $FF,$00,$00,$00,$00,$00,$00,$00 ; 11
           .byte  $C3,$00,$00,$00,$00,$00,$00,$FF ; 12
           .byte  $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0 ; 13
           .byte  $03,$03,$03,$03,$03,$03,$03,$03 ; 14
           .byte  $00,$00,$00,$00,$00,$01,$02,$04 ; 15
           .byte  $00,$00,$00,$00,$00,$80,$40,$20 ; 16
           .byte  $04,$02,$01,$00,$00,$00,$00,$00 ; 17
           .byte  $20,$40,$80,$00,$00,$00,$00,$00 ; 18
           .byte  $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 19
           .byte  $00,$70,$88,$98,$A8,$C8,$70,$00 ; 20
           .byte  $00,$20,$60,$20,$20,$20,$70,$00 ; 21
           .byte  $00,$70,$88,$10,$20,$40,$F8,$00 ; 22
           .byte  $00,$70,$88,$30,$08,$88,$70,$00 ; 23
           .byte  $00,$08,$18,$28,$48,$FC,$08,$00 ; 24
           .byte  $00,$F8,$80,$F0,$08,$88,$70,$00 ; 25
           .byte  $00,$70,$80,$F0,$88,$88,$70,$00 ; 26
           .byte  $00,$F8,$08,$10,$20,$40,$80,$00 ; 27
           .byte  $00,$70,$88,$70,$88,$88,$70,$00 ; 28
           .byte  $00,$70,$88,$70,$08,$08,$70,$00 ; 39
           .byte  $04,$08,$10,$10,$38,$24,$22,$11 ; 30
           .byte  $00,$00,$00,$00,$00,$00,$00,$30 ; 31
           .byte  $18,$7E,$7E,$FF,$FF,$7E,$7E,$18 ; 32
           .byte  $FC,$FC,$7E,$7E,$7C,$7C,$30,$00 ; 33
GFXCHAR34: .byte  $00,$00,$00,$0E,$1F,$1F,$1F,$0E ; 34
        
GFXCHARS2: .byte  $FF,$81,$81,$81,$81,$81,$81,$FF ; 65
           .byte  $FF,$00,$00,$00,$00,$00,$00,$FF
           .byte  $FF,$C3,$C3,$C3,$C3,$C3,$C3,$C3
           .byte  $C3,$C3,$C3,$C3,$C3,$C3,$C3,$FF
           .byte  $C3,$C3,$C3,$C3,$C3,$C3,$C3,$C3
           .byte  $FF,$00,$FF,$00,$00,$00,$00,$00
           .byte  $FF,$C0,$C0,$C0,$C0,$C0,$C0,$C0
           .byte  $FF,$03,$03,$03,$03,$03,$03,$03
           .byte  $00,$00,$00,$38,$7E,$FF,$EE,$EE
           .byte  $00,$00,$00,$1C,$7E,$FF,$EF,$EF
           .byte  $7F,$3B,$3B,$1F,$0E,$0E,$07,$01
           .byte  $FE,$DE,$DC,$F8,$F0,$E0,$C0,$80
           .byte  $00,$00,$03,$07,$0F,$0F,$1F,$1F
           .byte  $00,$00,$C0,$E0,$F0,$F0,$F8,$F8
           .byte  $1F,$1F,$0F,$0F,$07,$03,$00,$00
           .byte  $F8,$F8,$F0,$F0,$E0,$C0,$00,$00
           .byte  $00,$00,$03,$07,$0F,$0F,$1F,$1F
           .byte  $00,$00,$C0,$E0,$F0,$F0,$F8,$F8
           .byte  $1F,$1F,$0F,$0F,$07,$03,$00,$00
           .byte  $F8,$F8,$F0,$F0,$E0,$C0,$00,$00
           .byte  $00,$00,$00,$07,$1F,$3F,$7F,$FF
           .byte  $00,$00,$00,$E0,$F0,$FC,$FE,$FF
           .byte  $FF,$7F,$3F,$1F,$07,$00,$00,$00
           .byte  $FF,$FE,$FC,$F0,$E0,$00,$00,$00
           .byte  $00,$01,$07,$0F,$1F,$1F,$1F,$1F
           .byte  $00,$80,$E0,$F0,$F8,$F8,$F8,$F8
           .byte  $1F,$1F,$1F,$3F,$7F,$0F,$01,$00
           .byte  $F8,$F8,$F8,$FC,$FE,$F0,$80,$00
           .byte  $00,$01,$03,$02,$03,$01,$03,$07
           .byte  $00,$F0,$18,$0C,$0C,$F8,$B0,$00
           .byte  $0E,$1C,$38,$78,$FC,$4E,$04,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$03,$0F,$1F,$0F,$03,$00
           .byte  $00,$00,$C0,$F0,$F8,$F8,$FC,$FC
           .byte  $00,$03,$0F,$1F,$0F,$03,$00,$00
           .byte  $FC,$FC,$F8,$F8,$F0,$C0,$00,$00
           .byte  $00,$03,$1F,$31,$6E,$66,$66,$6E
           .byte  $00,$C0,$F8,$8C,$76,$36,$36,$76
           .byte  $71,$7F,$7F,$7F,$77,$22,$00,$FF
           .byte  $8E,$FE,$FE,$FE,$76,$22,$00,$FF
           .byte  $00,$00,$03,$0F,$1F,$1F,$3F,$3F
           .byte  $00,$00,$C0,$F0,$F8,$F8,$FC,$FC
           .byte  $3F,$3F,$1F,$1F,$0F,$03,$00,$00
           .byte  $FC,$FC,$F8,$F8,$F0,$C0,$00,$00
           .byte  $00,$00,$00,$08,$18,$1C,$3C,$3E
           .byte  $00,$00,$00,$10,$18,$38,$3C,$7C
           .byte  $3F,$3F,$1F,$1F,$0F,$03,$00,$00
           .byte  $FC,$FC,$F8,$F8,$F0,$C0,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $3F,$3F,$1F,$1F,$0F,$03,$00,$00
           .byte  $FC,$FC,$F8,$F8,$F0,$C0,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $01,$03,$07,$1F,$0F,$03,$00,$00
           .byte  $80,$C0,$E0,$F8,$F0,$C0,$00,$00
           .byte  $00,$01,$21,$11,$08,$04,$02,$70
           .byte  $00,$80,$84,$88,$10,$20,$40,$0E
           .byte  $70,$02,$04,$08,$11,$21,$01,$00
           .byte  $0E,$40,$20,$10,$88,$84,$80,$00
           .byte  $00,$38,$40,$40,$4C,$44,$38,$00
           .byte  $00,$10,$28,$44,$7C,$44,$44,$00
           .byte  $00,$44,$6C,$54,$44,$44,$44,$00
           .byte  $00,$7C,$40,$70,$40,$40,$7C,$00
           .byte  $00,$38,$44,$44,$44,$44,$38,$00
           .byte  $00,$44,$44,$44,$44,$28,$10,$00
           .byte  $00,$78,$44,$44,$78,$48,$44,$00
           .byte  $00,$00,$31,$4A,$12,$22,$79,$00
           .byte  $00,$00,$8C,$52,$52,$52,$8C,$00
           .byte  $00,$00,$09,$1A,$2A,$7A,$09,$00
           .byte  $00,$00,$8C,$52,$52,$52,$8C,$00
           .byte  $00,$00,$31,$4A,$32,$4A,$31,$00
           .byte  $00,$00,$8C,$52,$52,$52,$8C,$00
           .byte  $00,$00,$24,$28,$2C,$2A,$24,$00
           .byte  $00,$00,$44,$AA,$AA,$AA,$44,$00
           .byte  $00,$03,$1F,$31,$6E,$6C,$6C,$6E
           .byte  $00,$C0,$F8,$8C,$76,$66,$66,$76
           .byte  $71,$7F,$7F,$7F,$3B,$11,$00,$FF
           .byte  $8E,$FE,$FE,$FE,$BA,$10,$00,$FF ; 128

        ;; pacman going left
PACMANL:   .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$03,$0F,$1F,$07,$01,$00
           .byte  $00,$00,$C0,$F0,$F8,$F8,$FC,$7C
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$01,$07,$1F,$0F,$03,$00,$00
           .byte  $7C,$FC,$F8,$F8,$F0,$C0,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$0F,$3F,$7F,$7F,$FF,$01
           .byte  $00,$00,$00,$C0,$E0,$E0,$F0,$F0
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $01,$FF,$7F,$7F,$3F,$0F,$00,$00
           .byte  $F0,$F0,$E0,$E0,$C0,$00,$00,$00
           .byte  $00,$00,$00,$00,$01,$01,$03,$03
           .byte  $00,$00,$3C,$FF,$FF,$FF,$FF,$FF
           .byte  $00,$00,$00,$00,$80,$80,$C0,$C0
           .byte  $03,$03,$01,$01,$00,$00,$00,$00
           .byte  $FF,$FF,$FF,$FF,$FF,$3C,$00,$00
           .byte  $C0,$C0,$80,$80,$00,$00,$00,$00
           .byte  $00,$00,$00,$03,$07,$07,$00,$00
           .byte  $00,$00,$F0,$FC,$FE,$FE,$FF,$1F
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$07,$07,$03,$00,$00,$00
           .byte  $1F,$FF,$FE,$FE,$FC,$F0,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00

        ;; pacman going right
PACMANR:   .byte  $00,$00,$03,$0F,$1F,$1F,$3F,$3E
           .byte  $00,$00,$C0,$F0,$F8,$E0,$80,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $3E,$3F,$1F,$1F,$0F,$03,$00,$00
           .byte  $00,$80,$E0,$F8,$F0,$C0,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$03,$07,$07,$0F,$0F
           .byte  $00,$00,$F0,$FC,$FE,$FE,$FF,$80
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $0F,$0F,$07,$07,$03,$00,$00,$00
           .byte  $80,$FF,$FE,$FE,$FC,$F0,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$01,$01,$03,$03
           .byte  $00,$00,$3C,$FF,$FF,$FF,$FF,$FF
           .byte  $00,$00,$00,$00,$80,$80,$C0,$C0
           .byte  $03,$03,$01,$01,$00,$00,$00,$00
           .byte  $FF,$FF,$FF,$FF,$FF,$3C,$00,$00
           .byte  $C0,$C0,$80,$80,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$0F,$3F,$7F,$7F,$FF,$F0
           .byte  $00,$00,$00,$C0,$E0,$E0,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $F0,$FF,$7F,$7F,$3F,$0F,$00,$00
           .byte  $00,$00,$E0,$E0,$C0,$00,$00,$00

        ;; pacman going up
PACMANU:   .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$08,$18,$1C,$3C,$3E
           .byte  $00,$00,$00,$10,$18,$38,$3C,$7C
           .byte  $3E,$3F,$1F,$1F,$0F,$03,$00,$00
           .byte  $7C,$FC,$F8,$F8,$F0,$C0,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $02,$0E,$1E,$1E,$3E,$3E,$3E,$3F
           .byte  $40,$70,$78,$78,$7C,$7C,$7C,$FC
           .byte  $1F,$1F,$0F,$03,$00,$00,$00,$00
           .byte  $F8,$F8,$F0,$C0,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$03,$0F
           .byte  $00,$00,$00,$00,$00,$00,$C0,$F0
           .byte  $1F,$1F,$3F,$3F,$3F,$3F,$1F,$1F
           .byte  $F8,$F8,$FC,$FC,$FC,$FC,$F8,$F8
           .byte  $0F,$03,$00,$00,$00,$00,$00,$00
           .byte  $F0,$C0,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$0C,$1C,$1C
           .byte  $00,$00,$00,$00,$00,$30,$38,$38
           .byte  $3E,$3E,$3E,$3F,$1F,$1F,$0F,$03
           .byte  $7C,$7C,$7C,$FC,$F8,$F8,$F0,$C0
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00

        ;; pacman going down
PACMAND:   .byte  $00,$00,$03,$0F,$1F,$1F,$3F,$3E
           .byte  $00,$00,$C0,$F0,$F8,$F8,$FC,$7C
           .byte  $3E,$3C,$1C,$18,$08,$00,$00,$00
           .byte  $7C,$3C,$38,$18,$10,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$03,$0F,$1F,$1F
           .byte  $00,$00,$00,$00,$C0,$F0,$F8,$F8
           .byte  $3F,$3E,$3E,$3E,$1E,$1E,$0E,$02
           .byte  $FC,$7C,$7C,$7C,$78,$78,$70,$40
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$03,$0F
           .byte  $00,$00,$00,$00,$00,$00,$C0,$F0
           .byte  $1F,$1F,$3F,$3F,$3F,$3F,$1F,$1F
           .byte  $F8,$F8,$FC,$FC,$FC,$FC,$F8,$F8
           .byte  $0F,$03,$00,$00,$00,$00,$00,$00
           .byte  $F0,$C0,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $03,$0F,$1F,$1F,$3F,$3E,$3E,$3E
           .byte  $C0,$F0,$F8,$F8,$FC,$7C,$7C,$7C
           .byte  $1C,$1C,$0C,$00,$00,$00,$00,$00
           .byte  $38,$38,$30,$00,$00,$00,$00,$00

        ;; ghosts phase 1
GHOSTS1:   .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$03,$1F,$31,$6E,$66,$66,$6E
           .byte  $00,$C0,$F8,$8C,$76,$36,$36,$76
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $71,$7F,$7F,$7F,$77,$22,$00,$00
           .byte  $8E,$FE,$FE,$FE,$76,$22,$00,$00
           .byte  $00,$00,$00,$00,$01,$01,$01,$01
           .byte  $00,$0F,$7F,$C6,$B9,$98,$98,$B9
           .byte  $00,$00,$E0,$30,$D8,$D8,$D8,$D8
           .byte  $01,$01,$01,$01,$00,$00,$00,$00
           .byte  $C6,$FF,$FF,$FF,$EE,$44,$00,$00
           .byte  $38,$F8,$F8,$F8,$E8,$40,$00,$00
           .byte  $00,$00,$01,$03,$06,$06,$06,$06
           .byte  $00,$3C,$FF,$18,$E7,$63,$63,$E7
           .byte  $00,$00,$80,$C0,$60,$60,$60,$60
           .byte  $07,$07,$07,$07,$06,$04,$00,$00
           .byte  $18,$FF,$FF,$FF,$EE,$44,$00,$00
           .byte  $E0,$E0,$E0,$E0,$E0,$40,$00,$00
           .byte  $00,$00,$07,$0C,$1B,$19,$19,$1B
           .byte  $00,$F0,$FE,$63,$9D,$8D,$8D,$9D
           .byte  $00,$00,$00,$00,$80,$80,$80,$80
           .byte  $1C,$1F,$1F,$1F,$1D,$08,$00,$00
           .byte  $63,$FF,$FF,$FF,$DD,$88,$00,$00
           .byte  $80,$80,$80,$80,$80,$80,$00,$00

        ;; ghost phase 2
GHOSTS2:   .byte  $00,$03,$1F,$31,$6E,$6C,$6C,$6E
           .byte  $00,$C0,$F8,$8C,$76,$66,$66,$76
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $71,$7F,$7F,$7F,$77,$22,$00,$00
           .byte  $8E,$FE,$FE,$FE,$76,$22,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$07,$0C,$1B,$1B,$1B,$1B
           .byte  $00,$F0,$FE,$63,$9D,$19,$19,$9D
           .byte  $00,$00,$00,$00,$80,$80,$80,$80
           .byte  $1C,$1F,$1F,$1F,$0E,$04,$00,$00
           .byte  $63,$FF,$FF,$FF,$EE,$44,$00,$00
           .byte  $80,$80,$80,$80,$80,$00,$00,$00
           .byte  $00,$00,$01,$03,$06,$06,$06,$06
           .byte  $00,$3C,$FF,$18,$E7,$C6,$C6,$E7
           .byte  $00,$00,$80,$C0,$60,$60,$60,$60
           .byte  $07,$07,$07,$07,$06,$04,$00,$00
           .byte  $18,$FF,$FF,$FF,$EE,$44,$00,$00
           .byte  $E0,$E0,$E0,$E0,$E0,$40,$00,$00
           .byte  $00,$00,$00,$00,$01,$01,$01,$01
           .byte  $00,$0F,$7F,$C6,$B8,$B0,$B0,$B8
           .byte  $00,$00,$E0,$30,$D8,$98,$98,$D8
           .byte  $01,$01,$01,$01,$00,$00,$00,$00
           .byte  $C6,$FF,$FF,$FF,$EE,$44,$00,$00
           .byte  $38,$F8,$F8,$F8,$E8,$40,$00,$00

        ;; ghost phase 3
GHOSTS3:   .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$03,$1F,$31,$6A,$6A,$6E,$6E
           .byte  $00,$C0,$F8,$8C,$56,$56,$76,$76
           .byte  $71,$7F,$7F,$7F,$77,$22,$00,$00
           .byte  $8E,$FE,$FE,$FE,$76,$22,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$03
           .byte  $00,$00,$00,$00,$00,$00,$00,$C0
           .byte  $1F,$31,$6A,$6A,$6E,$6E,$71,$7F
           .byte  $F8,$8C,$56,$56,$76,$76,$8E,$FE
           .byte  $7F,$7F,$77,$22,$00,$00,$00,$00
           .byte  $FE,$FE,$76,$22,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$03,$1F,$31
           .byte  $00,$00,$00,$00,$00,$C0,$F8,$8C
           .byte  $6A,$6A,$6E,$6E,$71,$7F,$7F,$7F
           .byte  $56,$56,$76,$76,$8E,$FE,$FE,$FE
           .byte  $77,$22,$00,$00,$00,$00,$00,$00
           .byte  $76,$22,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$03,$1F,$31,$6A,$6A
           .byte  $00,$00,$00,$C0,$F8,$8C,$56,$56
           .byte  $6E,$6E,$71,$7F,$7F,$7F,$77,$22
           .byte  $76,$76,$8E,$FE,$FE,$FE,$76,$22
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00

        ;; ghost phase 4
GHOSTS4:   .byte  $00,$03,$1F,$31,$6E,$6E,$6A,$6A
           .byte  $00,$C0,$F8,$8C,$76,$76,$56,$56
           .byte  $71,$7F,$7F,$7F,$77,$22,$00,$00
           .byte  $8E,$FE,$FE,$FE,$76,$22,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$03,$1F,$31,$6E,$6E
           .byte  $00,$00,$00,$C0,$F8,$8C,$76,$76
           .byte  $6A,$6A,$71,$7F,$7F,$7F,$77,$22
           .byte  $56,$56,$8E,$FE,$FE,$FE,$76,$22
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$03,$1F,$31
           .byte  $00,$00,$00,$00,$00,$C0,$F8,$8C
           .byte  $6E,$6E,$6A,$6A,$71,$7F,$7F,$7F
           .byte  $76,$76,$56,$56,$8E,$FE,$FE,$FE
           .byte  $77,$22,$00,$00,$00,$00,$00,$00
           .byte  $76,$22,$00,$00,$00,$00,$00,$00
           .byte  $00,$00,$00,$00,$00,$00,$00,$03
           .byte  $00,$00,$00,$00,$00,$00,$00,$C0
           .byte  $1F,$31,$6E,$6E,$6A,$6A,$71,$7F
           .byte  $F8,$8C,$76,$76,$56,$56,$8E,$FE
           .byte  $7F,$7F,$77,$22,$00,$00,$00,$00
           .byte  $FE,$FE,$76,$22,$00,$00,$00,$00

        ;; game screen data (packed)
GAMESCRN:  .byte  $87,$06,$14,$87,$06,$14,$08,$07
           .byte  $8F,$14,$01,$90,$83,$08,$00,$87
           .byte  $8D,$8E,$08,$00,$87,$84,$83,$80
           .byte  $03,$07,$80,$02,$07,$80,$87,$8D
           .byte  $8E,$80,$02,$07,$80,$03,$07,$80
           .byte  $87,$84,$83,$A2,$87,$88,$89,$80
           .byte  $87,$C1,$80,$87,$86,$85,$80,$87
           .byte  $C1,$80,$87,$88,$89,$A2,$87,$84
           .byte  $83,$13,$00,$87,$84,$83,$04,$07
           .byte  $80,$02,$07,$80,$03,$07,$80,$02
           .byte  $07,$80,$05,$07,$84,$8A,$03,$42
           .byte  $89,$80,$87,$C3,$80,$87,$88,$89
           .byte  $80,$87,$C3,$80,$87,$88,$03,$42
           .byte  $8A,$05,$07,$80,$87,$C5,$05,$00
           .byte  $87,$C5,$80,$0B,$07,$80,$87,$C5
           .byte  $02,$07,$80,$03,$07,$C5,$80,$06
           .byte  $07,$8B,$03,$42,$89,$80,$87,$86
           .byte  $C2,$89,$80,$87,$88,$C2,$85,$80
           .byte  $87,$88,$03,$42,$8B,$83,$08,$00
           .byte  $03,$07,$08,$00,$87,$84,$83,$80
           .byte  $02,$07,$80,$02,$07,$80,$05,$07
           .byte  $80,$02,$07,$80,$02,$07,$80,$87
           .byte  $84,$83,$02,$07,$C3,$80,$87,$C3
           .byte  $80,$87,$C7,$02,$07,$C8,$80,$87
           .byte  $C3,$80,$87,$C3,$02,$07,$84,$83
           .byte  $A2,$87,$C4,$80,$87,$C5,$80,$87
           .byte  $86,$02,$0A,$85,$80,$87,$C5,$80
           .byte  $87,$C4,$A2,$87,$84,$83,$04,$00
           .byte  $87,$C5,$02,$00,$03,$07,$02,$00
           .byte  $87,$C5,$04,$00,$87,$84,$83,$80
           .byte  $04,$07,$C5,$08,$07,$C5,$03,$07
           .byte  $80,$87,$84,$83,$80,$87,$88,$02
           .byte  $42,$8C,$02,$42,$89,$80,$87,$88
           .byte  $02,$42,$8C,$02,$42,$89,$80,$87
           .byte  $84,$83,$13,$00,$87,$84,$83,$14
           .byte  $07,$84,$91,$14,$46,$92,$13,$07
           .byte  $9E,$9F,$15,$07,$A0,$A1,$87,$00
        
; PACMAN Entry
LABC6:     ldx    #$FF
           sei
           txs
           cld
           jsr    $FD8D
           jsr    $FD52
           jsr    $FDF9
           jsr    $E518
           jsr    $FF8A
           sei
           lda    #$7F
           sta    VIA1+14
           lda    #$00
           sta    $33
           sta    $34
           sta    $35
           ldx    #$03
LABEA:     lda    LBE59,x
           sta    $A7,x
           dex
           bpl    LABEA
LABF2:     cld
           lda    #$00
           sta    CURPLAYER
           sta    NPLAYERS
           sta    $5D
           sta    $5E
           jsr    AUDOFF
           jsr    SETCOLORS
           lda    #$01
           sta    LEVEL1
           sta    LEVEL2
           sta    $91
           sta    $A2
           sta    $A3
           lda    #$05
           sta    $88
           sta    $A1
           lda    #$FF
           sta    $C2
           sta    $C3
        
;;; clear screen
           ldx    #$00
LAC1D:     lda    #$20
           sta    SCREEN,x
           sta    SCREEN+256,x
           inx
           bne    LAC1D
           lda    #$96
           sta    VIC+2
        
;;; unpack game screen data to INISCREEN
           lda    #<(GAMESCRN-1)
           sta    $00
           lda    #>(GAMESCRN-1)
           sta    $01
           lda    #<INISCREEN
           sta    $02
           lda    #>INISCREEN
           sta    $03
           ldy    #$00
LAC3F:     jsr    INC00         ; next source addr
           lda    ($00),y       ; get count
           beq    LAC65         ; done if 0
           tax
           and    #$80          ; bit 7 set?
           bne    LAC5A         ; jump if so
           jsr    INC00         ; next source addr
           lda    ($00),y       ; get data byte
LAC50:     sta    ($02),y       ; store byte
           jsr    INC02         ; next destination addr
           dex
           bne    LAC50         ; repeat "count" times
           beq    LAC3F         ; get next count byte
LAC5A:     txa
           and    #$7F          ; clear bit 7
           sta    ($02),y       ; store byte
           jsr    INC02         ; next destination addr
           jmp    LAC3F         ; get next count byte

;;; display title screen
LAC65:     lda    #$F0
           sta    VIC+5
           lda    #$07
           jsr    PRTTXT1
           .word  SCREEN+$1E
           .byte  "PACMAN"
           .byte  $00
           lda    #$04
           jsr    PRTTXT1
           .word  SCREEN+$44
           .byte  "(C) 1983 ATARI INC"
           .byte  $00
           lda    #$05
           jsr    PRTTXT1
           .word  SCREEN+$89
           .byte  "1 PLAYER GAME"
           .byte  $00
           jsr    PRTTXT2
           .word  SCREEN+$9D
           .byte  "PRESS F3 TO CHANGE"
           .byte  $00
           jsr    PRTTXT2
           .word  SCREEN+$E1
           .byte  "SKILL LEVEL 1"
           .byte  $00
           jsr    PRTTXT2
           .word  SCREEN+$F5
           .byte  "PRESS F5 TO CHANGE"
           .byte  $00
           jsr    PRTTXT2
           .word  SCREEN+$138
           .byte  "F7 RESETS GAME"
           .byte  $00
           jsr    PRTTXT2
           .word  SCREEN+$179
           .byte  "PRESS F1 OR FIRE"
           .byte  $00
           jsr    PRTTXT2
           .word  SCREEN+$193
           .byte  "TO START"
           .byte  $00

LAD22:     lda    #$01
           sta    COLORRAM+$200+137
           sta    COLORRAM+$200+237
           jsr    DELAY3
           jsr    LB66E
           jsr    LB4C6
           cmp    #$85          ; F1 (or button)? 
           beq    LAD48         ; start game if so
           cmp    #$86          ; F3?
           beq    LAD77         ; toggle number of players if so
           cmp    #$87          ; F5?
           beq    LAD4B         ; toggle skill level if so
           cmp    #$88          ; F7?
           bne    LAD22         ; repeat if not
           jsr    LB616         ; reset player 1+2 scores
           beq    LAD22         ; keep waiting
LAD48:     jmp    STARTGAME

           ;; toggle skill level (1-7)
LAD4B:     ldy    CURPLAYER
           lda    LEVEL1,y
           clc
           adc    #$01
           cmp    #$08
           bne    LAD59
           lda    #$01
LAD59:     sta    LEVEL1,y
           sta    $5C
           ora    #$30
           sta    SCREEN+237
           jsr    LBFD4
           lda    LAD70-1,y
           sta    $5D
           sta    $5E
           jmp    LAD22
LAD70:     .byte  $01,$02,$03,$05,$07,$09,$0A
        
           ;; toggle number of players (1/2)
LAD77:     lda    NPLAYERS
           eor    #$FF
           sta    NPLAYERS
           beq    LAD82
           lda    #$32
           .byte  $2C
LAD82:     lda    #$31
           sta    SCREEN+137
           jmp    LAD22

;;; write text after JSR call to screen
PRTTXT1:   sta    $A4           ; store color
PRTTXT2:   pla                  ; get source address (from stack)
           sta    $00
           pla                  
           sta    $01
           ldy    #$01     
           lda    ($00),y       ; get destination address (LOW)
           sta    $02           ; store
           sta    $A5
           iny                  ; 
           lda    ($00),y       ; get destination address (HIGH)
           sta    $03           ; store
           clc
           adc    #>(COLORRAM+$200-SCREEN) ; add offset between SCREEN and COLORRAM
           sta    $A6           ; store color pointer
           lda    $00           ; 
           clc
           adc    #$03          ; skip to start of text
           sta    $00
           bcc    LADAF
           inc    $01
LADAF:     ldy    #$00        
LADB1:     lda    ($00),y       ; get next character
           beq    LADC4         ; if 0 then done
           cmp    #$40          ; convert to screen code
           bcc    LADBB
           sbc    #$40          ; 
LADBB:     sta    ($02),y       ; store character
           lda    $A4           ; get color
           sta    ($A5),y       ; store color
           iny                  ; next character
           bne    LADB1         ; repeat
LADC4:     tya                  ; calculat memory location after end-of-text
           sec
           adc    $00
           sta    $00
           bcc    LADCE
           inc    $01
LADCE:     jmp    ($00)         ; jump to next instruction

;;; start game
STARTGAME: lda    #$00
           sta    $6C
           sta    $71
           sta    $7E
           sta    $7F
           sta    $80
           sta    $87
           jsr    LBFC2
           jsr    LBFCB
           lda    #$DC
           sta    $72
           jsr    LBCAE
           lda    #<GFXCHARS1 ; copy $0118 bytes (characters $00-$22) from $A10E to $1400
           sta    $00
           lda    #>GFXCHARS1
           sta    $01
           lda    #<CHARSET
           sta    $02
           lda    #>CHARSET
           sta    $03
           lda    #$18
           sta    $57
           lda    #$01
           sta    $58
           jsr    COPYMEM
           lda    #<GFXCHARS2  ; copy $0278 bytes (characters $41-$80) from $A226 to $1608
           sta    $00
           lda    #>GFXCHARS2
           sta    $01
           lda    #<(CHARSET+$208)
           sta    $02
           lda    #>(CHARSET+$208)
           sta    $03
           lda    #$78
           sta    $57
           lda    #$02
           sta    $58
           jsr    COPYMEM
           jsr    LB4B8
           jsr    LB4BF
           jsr    LB63D         ; set source ($00) to INISCREEN, destination to SCREEN
           jsr    LB623         ; set count to $1FF
           jsr    COPYMEM       ; copy memory
           lda    #$FD
           sta    VIC+5
LAE36:     ldx    CURPLAYER
           lda    LIVES1,x
           sta    $5F
           dec    LIVES1,x
LAE3E:     jsr    LB728
           lda    #$00
           sta    $AF
           sta    $8D
           lda    #$08
           sta    $79
           ldy    CURPLAYER
           lda    LIVES1,y
           sta    $5F
           tya
           bne    LAE74
           jsr    LBC89
LAE58:     jsr    DELAY3
           dec    $79
           beq    LAE6F
           lda    $79
           and    #$01
           beq    LAE6A
           jsr    LBF76
           beq    LAE58
LAE6A:     jsr    LBFAC
           beq    LAE58
LAE6F:     lda    $6A
           jmp    LAE90

LAE74:     jsr    LBC93
LAE77:     jsr    DELAY3
           dec    $79
           beq    LAE8E
           lda    $79
           and    #$01
           beq    LAE89
           jsr    LBF7F
           beq    LAE77
LAE89:     jsr    LBFB7
           beq    LAE77
LAE8E:     lda    $6B
LAE90:     sta    $69
           jsr    LB728
           lda    #$0E
           sta    $79
           lda    #$00
           sta    $64
           sta    $90
           sta    $71
           sta    $C4
           lda    #$0A
           sta    $75
           lda    #$DC
           sta    $72
           jsr    LBE5D
           lda    #$FF
           sta    $77
           lda    #<PACMANL
           sta    $00
           sta    $2B
           lda    #>PACMANL
           sta    $01
           sta    $2C
           jsr    LB683         ; set destination to CHARSET+$118
           ldx    #$30          ; copy 6 characters
           jsr    COPYPAGE
           lda    #$00
           sta    $27
           sta    $1F
           sta    $20
           lda    #<(SCREEN+$153)          ; initial position?
           sta    $0E
           sta    $00
           lda    #>(SCREEN+$153)          ; initial position?
           sta    $0F
           sta    $01
           lda    #$28
           sta    $B8
           lda    #$3C
           sta    $B9
           lda    #$07
           sta    $1E
           lda    #$23
           sta    $56
           jsr    LB6DA
           jsr    LBF13
           lda    #$00
           sta    $76
           sta    $7A
           sta    $83
LAEF8:     jsr    LBEDB
           lda    $7A
           cmp    #$04
           bne    LAEF8
        
LAF01:     jsr    LAF07         ; print scores
           jmp    LAF25

        ;; print scores
LAF07:     jsr    LBF76         ; print player 1 score
           lda    #HIGHSCORE-1
           sta    $00
           lda    #$00
           sta    $01
           lda    #<(SCREEN+$0D)
           sta    $02
           lda    #>(SCREEN+$0D)
           sta    $03
           jsr    LBF8C         ; print high score
           lda    NPLAYERS      ; 2-player game?
           bne    LAF22         ; jump if so
           rts
LAF22:     jmp    LBF7F         ; print player 2 score

LAF25:     dec    $3C
           beq    LAF2C
           jmp    LB195

LAF2C:     lda    $45
           sta    $3C
           lda    $0E
           sta    $12
           sta    $00
           lda    $0F
           sta    $13
           sta    $01
           lda    $1F
           sta    $27
           lda    $20
           sta    $26
           lda    $28
           cmp    #$03
           beq    LAF4D
           jmp    LAFBE

LAF4D:     lda    #$00
           sta    VIA1+3
           sta    VIA2+2
           lda    JOY_REG_OTHER      ; read joystick
           and    #JOY_MASK_LEFT     ; left?
           beq    LAF74
           lda    JOY_REG_OTHER
           and    #JOY_MASK_DOWN     ; down?
           beq    LAFAA
           lda    JOY_REG_OTHER
           and    #JOY_MASK_UP       ; up?
           beq    LAF99
           lda    JOY_REG_RIGHT
           and    #JOY_MASK_RIGHT    ; right?
           beq    LAF88
           jmp    LAFBE
LAF74:     jsr    LB85C
           bcc    LAF7C
           jmp    LAFBE
LAF7C:     lda    #<PACMANL
           sta    $2B
           lda    #>PACMANL
           sta    $2C
           ldy    #$00
           beq    LAFB9
LAF88:     jsr    LB8E8
           bcs    LAFBE
           lda    #<PACMANR
           sta    $2B
           lda    #>PACMANR
           sta    $2C
           ldy    #$10
           bne    LAFB9
LAF99:     jsr    LB979
           bcs    LAFBE
           lda    #<PACMANU
           sta    $2B
           lda    #>PACMANU
           sta    $2C
           ldy    #$20
           bne    LAFB9
LAFAA:     jsr    LBA06
           bcs    LAFBE
           lda    #<PACMAND
           sta    $2B
           lda    #>PACMAND
           sta    $2C
           ldy    #$30
LAFB9:     sty    $27
           jsr    LB66E
LAFBE:     lda    #$23
           sta    $56           ; current character code is $23(35), i.e. pacman
           lda    $28
           clc
           adc    #$01
           and    #$03
           sta    $28
           tax
           bne    LAFDC
           jsr    LB7C3
           sta    $87
           bcc    LAFDC
           lda    #$03
           sta    $28
           tax
           bne    LAFDC
LAFDC:     lda    #$07
           sta    $1E
           jsr    LB6DA
           inx
           lda    $2B
           sta    $00
           lda    $2C
           sta    $01
           jsr    LB683
LAFEF:     dex
           beq    LB000
           clc
           lda    $00
           adc    #$30
           sta    $00
           bcc    LAFEF
           inc    $01
           jmp    LAFEF

LB000:     ldx    #$30
           jsr    COPYPAGE
           jsr    LB10D
           lda    $8D
           beq    LB079
           lda    $9E
           sec
           sbc    #$2B
           bcs    LB017
           eor    #$FF
           adc    #$01
LB017:     cmp    #$01
           bcs    LB079
           lda    $9F
           sec
           sbc    #$3F
           bcs    LB026
           eor    #$FF
           adc    #$01
LB026:     cmp    #$01
           bcs    LB079
           lda    SCREEN+342
           sta    $A5
           jsr    LB1F7
           lda    #$00
           sta    $8D
           jsr    LBFD4
           lda    $6D
           clc
           adc    LB0BA-1,y
           sta    $6D
           bcc    LB045
           inc    $6C
LB045:     lda    #<(SCREEN+$153)
           sta    $02
           lda    #>(SCREEN+$153)
           sta    $03
           jsr    LBFD4
           lda    LB0BA-1,y
           ldy    #$00
           jsr    LB0E8
           lda    #$00
           jsr    LB0E8
           lda    SCREEN+339
           cmp    #$14
           bne    LB069
           lda    #$07
           sta    SCREEN+339
LB069:     jsr    LB0C1
           lda    #$07
           sta    SCREEN+339
           jsr    LB1F7
           lda    $A5
           sta    SCREEN+342
LB079:     lda    $12
           sta    $0E
           lda    $13
           sta    $0F
           lda    $27
           sta    $1F
           lda    $26
           sta    $20
           cld
           lda    $1F
           ldy    $28
           jsr    LBE0D
           ldy    $28
           bne    LB0A2
           lda    $0F
           ldy    $0E
           jsr    LBE33
           sta    $B8
           lda    $A0
           sta    $B9
LB0A2:     lda    $B8
           clc
           adc    $94
           sta    $9E
           lda    $B9
           clc
           adc    $95
           sta    $9F
           jmp    LB195
LB0B3:     .byte  $E1,$AF,$7D,$4B,$19,$32,$0A
LB0BA:     .byte  $01,$03,$05,$07,$10,$30,$50
        
LB0C1:     lda    #$D6
           sta    $8E
           sta    $8F
           jsr    AUDOFF
LB0CA:     lda    $8E
           sta    VIC+11
           jsr    LBFDA
           ldx    $8F
           beq    LB0DC
           dec    $8E
           cmp    #$C8
           bne    LB0CA
LB0DC:     sty    $8F
           inc    $8E
           cmp    #$D6
           bne    LB0CA
           sty    VIC+11
           rts

LB0E8:     cld
           pha
           and    #$F0
           jsr    LBFF5
           clc
           adc    #$14
           sta    ($02),y
           iny
           pla
           and    #$07
           clc
           adc    #$14
           sta    ($02),y
           iny
           lda    #$01
           sta    COLORRAM+$200+340
           sta    COLORRAM+$200+341
           sta    COLORRAM+$200+342
           sta    COLORRAM+$200+343
           rts

LB10D:     jsr    LBBF5
           jsr    LBC38
           ldy    #$00
           sty    $67
           sty    $68
           lda    $27
           and    #$20
           bne    LB12C
           ldy    #$00
LB121:     jsr    LBC23
           iny
           tya
           cmp    #$03
           bne    LB121
           beq    LB13B
LB12C:     ldy    #$00
           jsr    LBC23
           ldy    #$16
           jsr    LBC23
           ldy    #$2C
           jsr    LBC23
LB13B:     sed
           clc
           ldx    $67
           beq    LB159
           lda    $80
           eor    #$01
           sta    $80
           beq    LB14C
           lda    #$B4
           .byte  $2C
LB14C:     lda    #$C0
           sta    $C4
LB150:     lda    #$10
           adc    $6E
           sta    $6E
           dex
           bne    LB150
LB159:     lda    $68
           beq    LB194
           lda    #$02
           sta    $AF
           lda    #$00
           sta    $83
           jsr    LBFD4
           lda    LB0B3-1,y
           sta    $77
           lda    #$0A
           sta    $76
           sta    $C5
           sta    $C6
           sta    $C7
           sta    $C8
           sta    $7C
           jsr    LBE6C
           lda    #$14
           sta    $7D
           lda    #$0E
           sta    $79
           lda    #$19
           sta    $78
           lda    #$50
           adc    $6E
           sta    $6E
           bcc    LB194
           inc    $6D
LB194:     rts

LB195:     lda    #$00
           sta    $73
           jsr    LBD23
           ldx    #$00
LB19E:     dec    $3D,x
           bne    LB1C6
           lda    $41,x
           beq    LB1AC
           dec    $41,x
           bne    LB1C6
           dec    $7A
LB1AC:     lda    LB206,x
           sta    $56
           stx    $92
           jsr    LB20E
           ldx    $92
           lda    LB20A,x
           sta    $54
           lda    #>(CHARSET+$100)
           sta    $55
           jsr    LB242
           ldx    $92
LB1C6:     inx
           cpx    #$04
           bne    LB19E
           dec    $A2
           bne    LB1F4
           lda    #$30
           sta    $A2
           inc    $C9
           lda    $C9
           and    #$01
           bne    LB1E9
           ldx    #$07
LB1DD:     lda    GFXCHAR34,x
           eor    CHARSET+34*8,x
           sta    CHARSET+34*8,x
           dex
           bpl    LB1DD
LB1E9:     lda    $8D
           beq    LB1F4
           dec    $8D
           bne    LB1F4
           jsr    LB1F7
LB1F4:     jmp    LB264

LB1F7:     lda    #$07
           sta    SCREEN+340
           sta    SCREEN+341
           sta    SCREEN+362
           sta    SCREEN+363
           rts

LB206:     .byte  $29,$2f,$35,$3b
LB20A:     .byte  $48,$78,$a8,$d8                

LB20E:     lda    $C5,x
           bne    LB215
           lda    #$00
           .byte  $2C
LB215:     lda    #$08
           sta    $A5           ; 8=ghost in "defense" mode, 0=normal mode
           lda    $46,x
           clc
           adc    $A5
           sta    $3D,x
LB220:     lda    $50,x
           sta    $4F
           lda    $38,x
           sta    $27
           lda    $4A,x
           sta    $1E           ; current ghost color
           lda    $21,x
           sta    $25
           sta    $26
           txa
           asl    a
           tax
           lda    $16,x
           sta    $12           ; current ghost location (low)
           sta    $00
           lda    $17,x
           sta    $13           ; current ghost location (high)
           sta    $01
           rts

LB242:     stx    $8A
           jsr    LBAA5
           jsr    LBBBB
           ldx    $8A
           lda    $27
           sta    $38,x
           lda    $26
           sta    $21,x
           lda    $4F
           sta    $50,x
           txa
           asl    a
           tax
           lda    $12
           sta    $16,x
           lda    $13
           sta    $17,x
           rts

        ;; add score in $6C-$6E to either player 1 or player 2
        ;; update high score if necessary
LB264:     sed
           lda    #$6B
           sta    $00
           lda    #$00
           sta    $01
           sta    $03
           lda    CURPLAYER     ; get player
           bne    LB279         ; jump if player 2
           lda    #P1SCORE-1
           sta    $02
           bne    LB27D
LB279:     lda    #P2SCORE-1
           sta    $02
LB27D:     clc
           ldy    #$03
LB280:     lda    ($00),y
           adc    ($02),y
           sta    ($02),y
           dey
           bne    LB280
           lda    #HIGHSCORE
           sta    $00
           inc    $02
           ldx    #$03
LB291:     lda    ($00),y
           cmp    ($02),y
           beq    LB29B
           bcc    LB2A1
           bcs    LB2AE
LB29B:     iny
           dex
           bne    LB291
           beq    LB2AE
LB2A1:     ldy    #$03
           dec    $00
           dec    $02
LB2A7:     lda    ($02),y
           sta    ($00),y
           dey
           bne    LB2A7
LB2AE:     lda    CURPLAYER     ; get player
           bne    LB2C4         ; jump if player 2
           lda    $7E
           bne    LB2D9
           lda    P1SCORE
           cmp    #$01
           bne    LB2D9
           inc    LIVES1
           inc    $7E
           lda    LIVES1
           bne    LB2D4
LB2C4:     lda    $7F
           bne    LB2D9
           lda    P2SCORE
           cmp    #$01
           bne    LB2D9
           inc    LIVES2
           inc    $7F
           lda    LIVES2
LB2D4:     sta    $5F
           jsr    LB78E
LB2D9:     cld
           lda    #$00          ; clear out score in $6C-$6E
           sta    $6C
           sta    $6D
           sta    $6E
           lda    $69
           bne    LB2E9
           jmp    LB5BE

LB2E9:     inc    $A1
           lda    $A1
           and    #$03
           bne    LB357
           lda    $76
           beq    LB357
           lda    $77
           beq    LB305
           lda    $90
           eor    #$01
           sta    $90
           bne    LB357
           dec    $77
           bne    LB357
LB305:     dec    $78
           bne    LB357
           lda    #$19
           sta    $78
           dec    $79
           beq    LB327
           lda    $79
           and    #$01
           beq    LB31C
           jsr    LBE6C
           bne    LB357
LB31C:     lda    #$01
           jsr    LBE6E
           lda    #$00
           sta    $AF
           beq    LB357
LB327:     lda    #$0E
           sta    $79
           ldy    #$00
           sty    $76
           sty    $83
           sty    $C5
           sty    $C6
           sty    $C7
           sty    $C8
           jsr    AUDOFF
           jsr    LBE5D
           ldx    #$03
LB341:     lda    $41,x
           bne    LB354
           lda    LB206,x
           sta    $56
           txa
           pha
           jsr    LB220
           jsr    LB6DA
           pla
           tax
LB354:     dex
           bpl    LB341

LB357:     ldx    #$06
           ldy    #$04
LB35B:     jsr    LBDAB
           bne    LB368
           dex
           dex
           dey
           bne    LB35B
           jmp    LB51F

        ;; pacman and ghost Y are in same place
LB368:     dey
           lda    $C5,y         ; is ghost Y in "defense" mode?
           bne    LB371         ; jump if so (pacman catches ghost)
           jmp    LB3B3         ; ghost catches pacman

        ;; pacman caught ghost Y
LB371:     lda    #$00
           sta    $C5,y         ; disable "defense" mode
           lda    LBE68,y       ; get ghost's original color
           sta    $4A,y         ; set ghost color back to normal
           ldx    #$84
           lda    #$02
           ldy    $83
           beq    LB391
           cpy    #$04
           bne    LB38B
           dey
           dec    $83
LB38B:     asl    a
           inx
           inx
           dey
           bne    LB38B
LB391:     inc    $83
           stx    $89
           cmp    #$10
           bne    LB39B
           lda    #$16
LB39B:     sta    $6D
           ldx    $73
           dex
           txa
           pha
           jsr    LB20E
           jsr    LBEAD
           jsr    LB10D
           cld
           pla
           jsr    LBEDB
           jmp    LB51F

        ;; pacman was caught by ghost
LB3B3:     lda    $0E
           sta    $12
           lda    $0F
           sta    $13
           lda    $1F
           sta    $27
           jsr    LB68C
           jsr    AUDOFF
           jsr    DELAY2
           lda    #$E4
           sta    $7B
           lda    $0E
           sta    $0A
           clc
           adc    #<(COLORRAM+$200-SCREEN)
           sta    $10
           lda    $0F
           sta    $0B
           adc    #>(COLORRAM+$200-SCREEN)
           sta    $11
           lda    #$07
           jsr    LBE7E
           lda    #$69
           sta    $84
           lda    #$05
           sta    $85
LB3EA:     lda    $84
           jsr    LB7A7
           jsr    LBE98         ; play next two tones of "caught" melody
           clc
           lda    #$04
           adc    $84
           sta    $84
           dec    $85
           bne    LB3EA
           jsr    DELAY3
           lda    NPLAYERS
           bne    LB40F
           lda    LIVES1
           beq    LB436
           lda    $69
           sta    $6A
LB40C:     jmp    LAE36

LB40F:     lda    CURPLAYER
           bne    LB423
           lda    LIVES1
           beq    LB468
           lda    $69
           sta    $6A
           lda    LIVES2
           beq    LB40C
           lda    #$01
           bne    LB431
LB423:     lda    LIVES2
           beq    LB476
           lda    $69
           sta    $6B
           lda    LIVES1
           beq    LB433
           lda    #$00
LB431:     sta    CURPLAYER
LB433:     jmp    LAE36

LB436:     jsr    LB49E         ; print "GAME OVER"
           jsr    LBFC2         ; reset player 1 score
LB43C:     jsr    LB4B8
LB43F:     jsr    LB4C6         ; read joystick
           cmp    #$85          ; button pressed?
           beq    LB455         ; if so, restart game 
           cmp    #$86          ; if up/right/down => go to settings screen
           beq    LB452
           cmp    #$87
           beq    LB452
           cmp    #$88
           bne    LB43F
LB452:     jmp    LABF2         ; back to settings screen

LB455:     ldy    #$01
           sty    LEVEL1
           sty    LEVEL2
           dey
           sty    $5D
           sty    $5E
           dey
           sty    $C2
           sty    $C3
           jmp    LAE36

           ;; player 1 has no lives left
LB468:     jsr    LB49E         ; print "GAME OVER"
           lda    LIVES2        ; player 2 also done?
           beq    LB484         ; jump if so
           lda    #$01          ; set player 2
           sta    CURPLAYER
           jmp    LAE36         ; continue game

           ;; player 2 has no lives left
LB476:     jsr    LB49E         ; print "GAME OVER"
           lda    LIVES1        ; player 1 also done?
           beq    LB484         ; jump if so
           lda    #$00
           sta    CURPLAYER     ; set player 1
           jmp    LAE36         ; continue game

LB484:     jsr    LBFC2         ; reset player 1 score
           jsr    LBFCB         ; reset player 2 score
           jsr    LB4BF
           lda    #$00
           sta    CURPLAYER
           beq    LB43C
     
LB493:     .byte  $07,$7D,$7E,$7F,$80,$07,$07,$81,$82,$80,$83
           ;; print " GAME OVER"
LB49E:     ldy    #$0A
           sty    $88
LB4A2:     lda    LB493,y
           sta    SCREEN+269,y
           lda    #$01
           sta    COLORRAM+$200+269,y
           dey
           bne    LB4A2
LB4B0:     jsr    DELAY4
           dec    $88
           bne    LB4B0
           rts

           ;; initialize number of lives for player 1
LB4B8:     lda    #STARTLIVES
           sta    LIVES1
           jmp    LBCF6

           ;; initialize number of lives for player 2
LB4BF:     lda    #STARTLIVES
           sta    LIVES2
           jmp    LBD04

LB4C6:     lda    #$00
           sta    VIA1+3
           sta    VIA2+2
           lda    VIA1+1
           and    #$20
           bne    LB4DB
           jsr    LB66E
           lda    #$85
           rts
LB4DB:     jsr    LB66E
           lda    #$EF
           sta    VIA2
           lda    VIA2+1
           and    #$01
           bne    LB502
           lda    $91
           beq    LB506
           jsr    AUDOFF
LB4F1:     lda    VIA2+1
           and    #$01
           beq    LB4F1
LB4F8:     lda    VIA2+1
           and    #$01
           bne    LB4F8
           lda    #$00
           .byte  $2C
LB502:     lda    #$01
           sta    $91
LB506:     ldx    #$03
LB508:     lda    LB51B,x
           jsr    LB66E
           beq    LB516
           dex
           bpl    LB508
           lda    #$40
           rts
LB516:     txa
           clc
           adc    #$85
           rts
LB51B:     .byte  $EF,$DF,$BF,$7F
LB51F:     lda    #$00
           sta    $73
           jsr    LB4C6
           cmp    #$88
           bne    LB52D
           jmp    LABF2

LB52D:     lda    $7A
           bne    LB543
           lda    #$07
           sta    SCREEN+296
           sta    SCREEN+297
           lda    #$0A
           sta    SCREEN+318
           sta    SCREEN+319
           bne    LB560
LB543:     lda    #<(SCREEN+$128)
           sta    $0A
           lda    #>(SCREEN+$128)
           sta    $0B
           inc    $86
           lda    $86
           beq    LB557
           cmp    #$80
           beq    LB55B
           bne    LB560
LB557:     lda    #$65
           bne    LB55D
LB55B:     lda    #$8C
LB55D:     jsr    LB7A7
LB560:     lda    #$06
           sta    COLORRAM+$200+296
           sta    COLORRAM+$200+297
           sta    COLORRAM+$200+318
           sta    COLORRAM+$200+319
           lda    $8D
           bne    LB584
           ldx    CURPLAYER
           lda    $C2,x
           bpl    LB5B3
           lda    $69
           cmp    #$44
           bcs    LB5B3
           sta    $C2,x
           lda    #$32
           sta    $8D
LB584:     jsr    LBFD4
           dey
           beq    LB594
           lda    #$45
LB58C:     clc
           adc    #$04
           dey
           bne    LB58C
           beq    LB596
LB594:     lda    #$1E
LB596:     ldy    #<(SCREEN+$154)
           sty    $0A
           ldy    #>(SCREEN+$154)
           sty    $0B
           jsr    LB7A7
           jsr    LBFD4
           lda    LB5B6,y
           sta    COLORRAM+$200+340
           sta    COLORRAM+$200+341
           sta    COLORRAM+$200+362
           sta    COLORRAM+$200+363
LB5B3:     jmp    LAF01

LB5B6:     .byte  $00,$02,$02,$07,$02,$07,$05,$04
LB5BE:     lda    $28
           cmp    #$03
           beq    LB5C7
           jmp    LB52D

LB5C7:     jsr    AUDOFF
           lda    #$04
           sta    $6F
           jsr    DELAY1
LB5D1:     lda    #$18
           sta    VIC+15
           jsr    DELAY1
           jsr    SETCOLORS
           dec    $6F
           bne    LB5D1
           jsr    DELAY1
           lda    CURPLAYER
           bne    LB5EC
           jsr    LBCF6
           beq    LB5EF
LB5EC:     jsr    LBD04
LB5EF:     ldx    CURPLAYER
           lda    #$FF
           sta    $C2,x
           lda    $5D,x
           cmp    #$0A
           beq    LB5FD
           inc    $5D,x
LB5FD:     lda    $5D,x
           tay
           lda    LB60B,y
           ldy    CURPLAYER
           sta    LEVEL1,y
           jmp    LAE3E
LB60B:     .byte  $01,$02,$03,$03,$04,$04,$05,$05,$06,$06,$07
     
           ;; reset player 1+2 score
LB616:     lda    #$00
           tay
           ldx    #$06
LB61B:     sta    P1SCORE,y
           iny
           dex
           bne    LB61B
           rts

LB623:     lda    #$FF
           sta    $57
           lda    #$01
           sta    $58
           rts

LB62C:     ldy    #$00
LB62E:     sta    ($00),y
           iny
           dex
           bne    LB62E
           rts
        
;;; set foreground/background colors to black
SETCOLORS: lda    #$08
           sta    VIC+15
           jmp    DELAY1

LB63D:     lda    #$FA
           sta    $00
           lda    #$1A
           sta    $01
           lda    #<SCREEN
           sta    $02
           lda    #>SCREEN
           sta    $03
           rts

LB64E:     lda    #P1SCORE
           sta    $00
           lda    #$00
           sta    $01
           rts

LB657:     lda    #P2SCORE
           sta    $00
           lda    #$00
           sta    $01
           rts

INC00:     inc    $00
           bne    LB666
           inc    $01
LB666:     rts

INC02:     inc    $02
           bne    LB66D
           inc    $03
LB66D:     rts

LB66E:     pha
           lda    #$80
           sta    VIA1+3
           lda    #$FF
           sta    VIA2+2
           pla
           sta    VIA2
           lda    VIA2+1
           and    #$80
           rts

        ;; set destination ($02) for "moving pacman" characters
LB683:     lda    #<(CHARSET+$118)
           sta    $02
           lda    #>(CHARSET+$118)
           sta    $03
           rts

        ;; draw pac-man (or ghost?)
LB68C:     lda    $27
           and    #$20
           bne    LB6A7
           ldy    #$00
           lda    #$07
           jsr    LB69E
           ldy    #$16
           jmp    LB69E

LB69E:     sta    ($12),y
           iny
LB6A1:     sta    ($12),y
           iny
           sta    ($12),y
           rts

LB6A7:     ldy    #$00
           lda    #$07
           jsr    LB6A1
           ldy    #$16
           jsr    LB6A1
           ldy    #$2C
           jmp    LB6A1

;;; copy ($58) bytes of memory from ($00) to ($02)
COPYMEM:   inc    $58
           ldy    #$00
LB6BC:     lda    ($00),y
           sta    ($02),y
           jsr    INC00
           jsr    INC02
           dec    $57
           bne    LB6BC
           dec    $58
           bne    LB6BC
           rts

COPYPAGE:  ldy    #$00
LB6D1:     lda    ($00),y
           sta    ($02),y
           iny
           dex
           bne    LB6D1
           rts

LB6DA:     txa
           pha
           ldx    #$00
           clc
           lda    $00
           adc    #<(COLORRAM+$200-SCREEN)
           sta    $10
           lda    $01
           adc    #>(COLORRAM+$200-SCREEN) ; add offset between SCREEN and COLORRAM
           sta    $11
           lda    $27
           and    #$20
           bne    LB700
           ldy    #$00
           jsr    LB70D
           iny
           jsr    LB718
           jsr    LB724
           pla
           tax
           rts

LB700:     ldy    #$00
           jsr    LB718
           ldy    #$2C
           jsr    LB721
           pla
           tax
           rts

           ;; set one character of a 2x2 gost/pacman character tile
LB70D:     lda    $56
           sta    ($00),y
           lda    $1E
           sta    ($10),y
           inc    $56
           rts

           ;; set 2x2 ghost/pacman character tile with character code 
           ;; in $56(+0+1+2+3) and color in $1E
LB718:     jsr    LB70D
           iny
           jsr    LB70D
           ldy    #$16
LB721:     jsr    LB70D
LB724:     iny
           jmp    LB70D

LB728:     lda    #<(SCREEN+$1CE)
           sta    $00
           lda    #>(SCREEN+$1CE)
           sta    $01
           ldx    #$2C
           lda    #$07
           jsr    LB62C
           lda    #$00
           sta    $0C
           jsr    LBFD4
           lda    #<(SCREEN+$1E1)
           sta    $0A
           lda    #>(SCREEN+$1E1)
           sta    $0B
LB746:     dey
           beq    LB75B
           dec    $0A
           dec    $0A
           lda    $0C
           asl    a
           asl    a
           adc    #$49
           jsr    LB7A7
           inc    $0C
           jmp    LB746

LB75B:     jsr    LB78E
           lda    #$E1
           sta    $0A
           lda    #$1E
           jsr    LB7A7
           jsr    LBFD4
           ldx    LB786-1,y
           lda    NPLAYERS
           beq    LB776
           txa
           sbc    #$02
           bne    LB777
LB776:     txa
LB777:     sta    $45
           adc    #$03
           sta    $46
           adc    #$03
           sta    $47
           sta    $48
           sta    $49
           rts
LB786:     .byte  $19,$18,$17,$16,$15,$14,$13,$12
        
LB78E:     lda    #<(SCREEN+$1CF)
           sta    $0A
           lda    #>(SCREEN+$1CF)
           sta    $0B
           ldx    $5F
           beq    LB7A6
LB79A:     lda    #$61
           jsr    LB7A7
           inc    $0A
           inc    $0A
           dex
           bne    LB79A
LB7A6:     rts

LB7A7:     sty    $0D
           ldy    #$00
           jsr    LB7BC
           jsr    LB7BC
           ldy    #$16
           jsr    LB7BC
           jsr    LB7BC
           ldy    $0D
           rts

LB7BC:     sta    ($0A),y
           clc
           adc    #$01
           iny
           rts

LB7C3:     txa
           pha
           lda    $12
           sta    $14
           lda    $13
           sta    $15
           jsr    LBAC3
           lda    $27
           and    #$F0
           cmp    #$00
           bne    LB7FE
           lda    $12
           cmp    #<(SCREEN+$B1)
           bne    LB7F6
           lda    $13
           cmp    #>(SCREEN+$B1)
           bne    LB7F6
           jsr    LB68C
           lda    #<(SCREEN+$C4)
           sta    $12
           sta    $14
           lda    #>(SCREEN+$C4)
           sta    $13
           sta    $15
           jmp    LB7FB

LB7F6:     jsr    LB85C
           bcs    LB828
LB7FB:     jmp    LB83C

LB7FE:     cmp    #$10
           bne    LB82B
           lda    $12
           cmp    #<(SCREEN+$C3)
           bne    LB820
           lda    $13
           cmp    #>(SCREEN+$C3)
           bne    LB820
           jsr    LB68C
           lda    #<(SCREEN+$AF)
           sta    $12
           sta    $14
           lda    #>(SCREEN+$AF)
           sta    $13
           sta    $15
           jmp    LB825

LB820:     jsr    LB8E8
           bcs    LB828
LB825:     jmp    LB83C

LB828:     pla
           tax
           rts

LB82B:     cmp    #$20
           bne    LB837
           jsr    LB979
           bcs    LB828
           jmp    LB83C

LB837:     jsr    LBA06
           bcs    LB828
LB83C:     ldy    $AB
           lda    $12
           clc
           adc    LB854,y
           sta    $12
           sta    $00
           lda    $13
           adc    LB858,y
           sta    $13
           sta    $01
           clc
           bcc    LB828
LB854:     .byte  $FF,$EA,$01,$16
LB858:     .byte  $FF,$FF,$00,$00

LB85C:     sec
           lda    $12
           sbc    #<(SCREEN-COLOR+1)
           sta    $10
           lda    $13
           sbc    #>(SCREEN-COLOR+1)
           sta    $11
           lda    $26
           and    #$20
           bne    LB887
           jsr    LBA9E         ; is color BLUE ?
           bne    LB877         ; jump if not
           jmp    LB977         ; set carry and return (blocked)

LB877:     jsr    LBBF5         ; get current player's CURSCREEN+($12) address into $65/$66
           ldy    #$02          ; 
           jsr    LBA97         ; copy ($65)+2 to ($12)+2
           ldy    #$18          ; 
           jsr    LBA97         ; copy ($65)+24 to ($12)+24
           jmp    LB8E2

LB887:     lda    $26
           and    #$10
           bne    LB8B8
           jsr    LBA9E
           bne    LB895
           jmp    LB977

LB895:     ldy    #$16
           cmp    ($10),y
           bne    LB89E
           jmp    LB977

LB89E:     jsr    LBBF5
           ldy    #$2C
           jsr    LBA97
           iny
           jsr    LBA97
           sec
           lda    $12
           sbc    #$01
           sta    $12
           bcs    LB8B5
           dec    $13
LB8B5:     jmp    LB8E2

LB8B8:     ldy    #22
           jsr    LBAA0         ; is ($10)+22=6 ?
           bne    LB8C2
           jmp    LB977

LB8C2:     ldy    #$2C
           cmp    ($10),y
           bne    LB8CB
           jmp    LB977

LB8CB:     jsr    LBBF5
           ldy    #$00
           jsr    LBA97
           iny
           jsr    LBA97
           lda    $12
           clc
           adc    #$15
           sta    $12
           bcc    LB8E2
           inc    $13
LB8E2:     lda    #$00
           sta    $26
           clc
           rts

LB8E8:     sec
           lda    $12
           sbc    #<(SCREEN-COLOR)
           sta    $10
           lda    $13
           sbc    #>(SCREEN-COLOR)
           sta    $11
           lda    $26
           and    #$20
           bne    LB915
           ldy    #$03
           jsr    LBAA0
           bne    LB905
           jmp    LB977

LB905:     jsr    LBBF5
           ldy    #$00
           jsr    LBA97
           ldy    #$16
           jsr    LBA97
           jmp    LB971

LB915:     lda    $26
           cmp    #$30
           beq    LB947
           ldy    #$02
           jsr    LBAA0
           bne    LB925
           jmp    LB977

LB925:     ldy    #$18
           cmp    ($10),y
           bne    LB92E
           jmp    LB977

LB92E:     jsr    LBBF5
           ldy    #$00
           jsr    LBA97
           ldy    #$16
           jsr    LBA97
           ldy    #$2C
           jsr    LBA97
           iny
           jsr    LBA97
           jmp    LB971

LB947:     ldy    #$18
           jsr    LBAA0
           bne    LB951
           jmp    LB977

LB951:     ldy    #$2E
           cmp    ($10),y
           bne    LB95A
           jmp    LB977

LB95A:     jsr    LBBF5
           ldy    #$00
           jsr    LBA97
           iny
           jsr    LBA97
           clc
           lda    $12
           adc    #$16
           sta    $12
           bcc    LB971
           inc    $13
LB971:     lda    #$10
           sta    $26
           clc
           rts

LB977:     sec
           rts

LB979:     sec
           lda    $12
           sbc    #<(SCREEN-COLOR+22)
           sta    $10
           lda    $13
           sbc    #>(SCREEN-COLOR+22)
           sta    $11
           lda    $26
           and    #$20
           bne    LB9E4
           lda    $26
           cmp    #$10
           beq    LB9B7
           jsr    LBA9E
           beq    LB977
           iny
           cmp    ($10),y
           beq    LB977
           jsr    LBBF5
           ldy    #$02
           jsr    LBA97
           ldy    #$18
           jsr    LBA97
           sec
           lda    $12
           sbc    #$16
           sta    $12
           bcs    LB9B4
           dec    $13
LB9B4:     jmp    LBA00

LB9B7:     ldy    #$01
           jsr    LBAA0
           bne    LB9C1
           jmp    LB977

LB9C1:     iny
           cmp    ($10),y
           bne    LB9C9
           jmp    LB977

LB9C9:     jsr    LBBF5
           ldy    #$00
           jsr    LBA97
           ldy    #$16
           jsr    LBA97
           sec
           lda    $12
           sbc    #$15
           sta    $12
           bcs    LB9E1
           dec    $13
LB9E1:     jmp    LBA00

LB9E4:     jsr    LBA9E
           bne    LB9EC
           jmp    LB977

LB9EC:     iny
           cmp    ($10),y
           bne    LB9F4
           jmp    LB977

LB9F4:     jsr    LBBF5
           ldy    #$2C
           jsr    LBA97
           iny
           jsr    LBA97
LBA00:     lda    #$20
           sta    $26
           clc
           rts

LBA06:     sec
           lda    $12
           sbc    #<(SCREEN-COLOR)
           sta    $10
           lda    $13
           sbc    #>(SCREEN-COLOR)
           sta    $11
           lda    $26
           and    #$20
           bne    LBA6E
           lda    $26
           and    #$10
           bne    LBA41
           ldy    #$2C
           jsr    LBAA0
           bne    LBA29
           jmp    LB977

LBA29:     iny
           cmp    ($10),y
           bne    LBA31
           jmp    LB977

LBA31:     jsr    LBBF5
           ldy    #$02
           jsr    LBA97
           ldy    #$18
           jsr    LBA97
           jmp    LBA8C

LBA41:     ldy    #$2D
           jsr    LBAA0
           bne    LBA4B
           jmp    LB977

LBA4B:     iny
           cmp    ($10),y
           bne    LBA53
           jmp    LB977

LBA53:     jsr    LBBF5
           ldy    #$00
           jsr    LBA97
           ldy    #$16
           jsr    LBA97
           clc
           lda    $12
           adc    #$01
           sta    $12
           bcc    LBA6B
           inc    $13
LBA6B:     jmp    LBA8C

LBA6E:     ldy    #$42
           jsr    LBAA0
           bne    LBA78
           jmp    LB977

LBA78:     iny
           cmp    ($10),y
           bne    LBA80
           jmp    LB977
LBA80:     jsr    LBBF5
           ldy    #$00
           jsr    LBA97
           iny
           jsr    LBA97
LBA8C:     lda    #$30
           sta    $26
           clc
           rts

LBA92:     lda    #$01
           sta    ($36),y
           rts

LBA97:     lda    ($65),y
           sta    ($12),y
           jmp    LBA92

LBA9E:     ldy    #$00
LBAA0:     lda    #$06
           cmp    ($10),y
           rts

LBAA5:     lda    $4F
           cmp    #$03
           beq    LBADC
           lda    $27
           bne    LBAB2
           jmp    LBB36

LBAB2:     cmp    #$10
           bne    LBAB9
           jmp    LBB44

LBAB9:     cmp    #$20
           bne    LBAC0
           jmp    LBB52

LBAC0:     jmp    LBB60

LBAC3:     lda    $27
           and    #$F0
           beq    LBAD9
           cmp    #$10
           beq    LBAD4
           cmp    #$20
           beq    LBAD7
           lda    #$03
           .byte  $2C
LBAD4:     lda    #$02
           .byte  $2C
LBAD7:     lda    #$01
LBAD9:     sta    $AB
           rts

LBADC:     jsr    LBAC3
           lda    $9E
           sec
           sbc    $96,x
           sta    $AD
           lda    $9F
           sec
           sbc    $9A,x
           sta    $AE
           beq    LBB0C
           lda    $AD
           beq    LBB1A
           cmp    $AE
           bcs    LBB0C
           bcc    LBB1A
LBAF9:     jsr    LBB99
LBAFC:     sta    $AC
           eor    #$02
           cmp    $AB
           beq    LBAF9
           jsr    LBB73
           bcs    LBAF9
           jmp    LBB28

LBB0C:     lda    $AD
           bpl    LBB13
           lda    #$00
           .byte  $2C
LBB13:     lda    #$02
           eor    $AF
           jmp    LBAFC

LBB1A:     lda    $AE
           bpl    LBB21
           lda    #$01
           .byte  $2C
LBB21:     lda    #$03
           eor    $AF
           jmp    LBAFC

LBB28:     lda    $AC
           cmp    #$01
           beq    LBB52
           cmp    #$02
           beq    LBB44
           cmp    #$03
           beq    LBB60
LBB36:     jsr    LBB81
           jsr    LBD95
           ldx    #<GHOSTS1
           ldy    #>GHOSTS1
           lda    #$00
           beq    LBB6C
LBB44:     jsr    LBB87
           jsr    LBD95
           ldx    #<GHOSTS2
           ldy    #>GHOSTS2
           lda    #$10
           bne    LBB6C
LBB52:     jsr    LBB8D
           jsr    LBD95
           ldx    #<GHOSTS3
           ldy    #>GHOSTS3
           lda    #$20
           bne    LBB6C
LBB60:     jsr    LBB93
           jsr    LBD95
           ldx    #<GHOSTS4
           ldy    #>GHOSTS4
           lda    #$30
LBB6C:     stx    $29
           sty    $2A
           sta    $27
           rts

LBB73:     lda    $AC
           cmp    #$01
           beq    LBB8D
           cmp    #$02
           beq    LBB87
           cmp    #$03
           beq    LBB93
LBB81:     jsr    LBD9E
           jmp    LB85C

LBB87:     jsr    LBD9E
           jmp    LB8E8

LBB8D:     jsr    LBD9E
           jmp    LB979

LBB93:     jsr    LBD9E
           jmp    LBA06

LBB99:     clc
           lda    $AA
           adc    $A9
           sta    $A9
           adc    $A8
           sta    $A8
           adc    $A7
           sta    $A7
           inc    $AA
           bne    LBBB6
           inc    $A9
           bne    LBBB6
           inc    $A8
           bne    LBBB6
           inc    $A7
LBBB6:     lda    $A7
           and    #$03
           rts

LBBBB:     lda    $4F
           clc
           adc    #$01
           and    #$03
           sta    $4F
           bne    LBBC9
           jsr    LB7C3
LBBC9:     ldx    $4F
           jsr    LB6DA
           inx
           lda    $29
           sta    $00
           lda    $2A
           sta    $01
           lda    $54
           sta    $02
           lda    $55
           sta    $03
LBBDF:     dex
           beq    LBBEF
           clc
           lda    $00
           adc    #$30
           sta    $00
           bcc    LBBDF
           inc    $01
           bne    LBBDF
LBBEF:     ldx    #$30
           jsr    COPYPAGE
           rts

LBBF5:     lda    CURPLAYER     ; get current player
           sec
           bne    LBC09         ; jump if player 2
           lda    $12
           sbc    #<(SCREEN+2*22-CURSCREEN1)
           sta    $65
           lda    $13
           sbc    #>(SCREEN+2*22-CURSCREEN1)
           sta    $66
           jmp    LBC15

LBC09:     lda    $12
           sbc    #<(SCREEN+2*22-CURSCREEN2)
           sta    $65
           lda    $13
           sbc    #>(SCREEN+2*22-CURSCREEN2)
           sta    $66
        
LBC15:     clc
           lda    $12
           adc    #<(COLORRAM+$200-SCREEN)
           sta    $36
           lda    $13
           adc    #>(COLORRAM+$200-SCREEN)
           sta    $37
           rts

LBC23:     lda    ($65),y
           bne    LBC2B
           inc    $67
           bne    LBC31
LBC2B:     cmp    #$22
           bne    LBC37
           inc    $68
LBC31:     lda    #$07
           sta    ($65),y
           dec    $69
LBC37:     rts

LBC38:     lda    $69
           cmp    #$03
           bcc    LBC88
           lda    $27
           cmp    #$30
           bne    LBC4C
           ldy    #$2C
           lda    ($65),y
           beq    LBC5E
           bne    LBC60
LBC4C:     cmp    #$10
           bne    LBC58
           ldy    #$02
           lda    ($65),y
           beq    LBC5E
           bne    LBC60
LBC58:     ldy    #$00
           lda    ($65),y
           bne    LBC60
LBC5E:     inc    $87
LBC60:     lda    $87
           beq    LBC88
           lda    $27
           cmp    #$30
           beq    LBC77
           cmp    #$10
           beq    LBC80
           lda    $151F
           ora    #$03
           sta    $151F
           rts

LBC77:     lda    $153F
           ora    #$03
           sta    $153F
           rts

LBC80:     lda    $152F
           ora    #$03
           sta    $152F
LBC88:     rts

           ;; copy screen data from CURSCREEN1 (player 1) to SCREEN
LBC89:     lda    #<CURSCREEN1
           sta    $00
           lda    #>CURSCREEN1
           sta    $01
           bne    LBC9B
        
           ;; copy screen data from CURSCREEN2 (player 2) to SCREEN
LBC93:     lda    #<CURSCREEN2
           sta    $00
           lda    #>CURSCREEN2
           sta    $01
LBC9B:     lda    #<(SCREEN+2*22)
           sta    $02
           lda    #>(SCREEN+2*22)
           sta    $03
           lda    #<(18*22)
           sta    $57
           lda    #>(18*22)
           sta    $58
           jsr    COPYMEM
        
           ;; unpack color nybbles to COLOR
LBCAE:     lda    #<GAMECOLOR
           sta    $00
           lda    #>GAMECOLOR
           sta    $01
           lda    #<COLOR
           sta    $02
           lda    #>COLOR
           sta    $03
           ldx    #$FD
           ldy    #$00
LBCC2:     lda    ($00),y
           pha
           and    #$F0
           jsr    LBFF5
           sta    ($02),y
           jsr    INC02
           pla
           and    #$0F
           sta    ($02),y
           jsr    INC02
           jsr    INC00
           dex
           bne    LBCC2
        
           ;; copy screen char colors from COLOR to COLORRAM
           lda    #<COLOR
           sta    $00
           lda    #>COLOR
           sta    $01
           lda    #<(COLORRAM+$200)
           sta    $02
           lda    #>(COLORRAM+$200)
           sta    $03
           jsr    LB623
           jsr    COPYMEM
           jmp    LAF07

           ;; copy rows 2-20 of screen data from INISCREEN to CURSCREEN1
LBCF6:     lda    #$88
           sta    $6A
           lda    #<CURSCREEN1
           sta    $02
           lda    #>CURSCREEN1
           sta    $03
           bne    LBD10

           ;; copy rows 2-20 of screen data from INISCREEN to CURSCREEN2
LBD04:     lda    #$88
           sta    $6B
           lda    #<CURSCREEN2
           sta    $02
           lda    #>CURSCREEN2
           sta    $03
LBD10:     lda    #<(INISCREEN+2*22)
           sta    $00
           lda    #>(INISCREEN+2*22)
           sta    $01
           lda    #<(18*22)
           sta    $57
           lda    #>(18*22)
           sta    $58
           jmp    COPYMEM

LBD23:     lda    $76
           bne    LBD4C
           dec    $75
           bne    LBD4C
           lda    #$0A
           sta    $75
           ldx    $72
           lda    $71
           beq    LBD38
           inx
           bne    LBD39
LBD38:     dex
LBD39:     stx    $72
           stx    VIC+11
           cpx    #$E4
           beq    LBD46
           cpx    #$D8
           bne    LBD4C
LBD46:     lda    $71
           eor    #$FF
           sta    $71
LBD4C:     lda    $76
           beq    LBD68
           dec    $7D
           bne    LBD68
           lda    #$14
           sta    $7D
           ldy    $7C
           lda    LBD8D,y
           sta    VIC+11
           dec    $7C
           bne    LBD68
           lda    #$07
           sta    $7C
LBD68:     lda    $A1
           and    #$01
           bne    LBD88
           lda    $C4
           beq    LBD85
           ldy    $80
           lda    $C4
           clc
           adc    LBD89,y
           sta    $C4
           cmp    LBD8B,y
           bne    LBD85
           lda    #$00
           sta    $C4
LBD85:     sta    VIC+12
LBD88:     rts

LBD89:     .byte  $01,$FF
LBD8B:     .byte  $D8,$9C
LBD8D:     .byte  $D1,$CF,$CD,$CB,$C9,$CB,$CD,$CF
LBD95:     lda    $12
           sta    $00
           lda    $13
           sta    $01
           rts

LBD9E:     lda    $00
           sta    $12
           lda    $01
           sta    $13
           lda    $25
           sta    $26
           rts

LBDAB:     stx    $92
           sty    $93
           txa
           lsr    a
           tax
           sta    $A5
           lda    $38,x
           ldy    $50,x
           jsr    LBE0D
           ldx    $A5
           ldy    $50,x
           bne    LBDD6
           lda    $41,x
           bne    LBDD6
           ldx    $92
           lda    $17,x
           ldy    $16,x
           jsr    LBE33
           ldx    $A5
           sta    $B0,x
           lda    $A0
           sta    $B4,x
LBDD6:     ldy    $93
           ldx    $A5
           lda    $B0,x
           clc
           adc    $94
           sta    $96,x
           lda    $B4,x
           clc
           adc    $95
           sta    $9A,x
           lda    $9E
           sec
           sbc    $96,x
           bcs    LBDF3
           eor    #$FF
           adc    #$01
LBDF3:     cmp    #$04
           bcs    LBE08
           lda    $9F
           sec
           sbc    $9A,x
           bcs    LBE02
           eor    #$FF
           adc    #$01
LBE02:     cmp    #$04
           bcs    LBE08
           sty    $73
LBE08:     ldx    $92
           lda    $73
           rts

LBE0D:     sty    $A0
           and    #$F0
           tay
           beq    LBE1F
           cmp    #$10
           beq    LBE1C
           cmp    #$20
           beq    LBE1F
LBE1C:     lda    #$00
           .byte  $2C
LBE1F:     lda    #$03
           eor    $A0
           ldx    #$00
           stx    $94
           stx    $95
           cpy    #$20
           bcs    LBE30
           sta    $94
           rts

LBE30:     sta    $95
           rts

LBE33:     ldx    #$08
           sec
           sbc    #>SCREEN      ; #$1e?
           sty    $A0
LBE3A:     asl    $A0
           rol    a
           cmp    #$16
           bcc    LBE45
           sbc    #$16
           inc    $A0
LBE45:     dex
           bne    LBE3A
           asl    a
           asl    a
           clc
           adc    #$03
           pha
           lda    $A0
           asl    a
           asl    a
           clc
           adc    #$03
           sta    $A0
           pla
           rts

LBE59:     .byte  $A1,$45,$F7,$81
        
        ;; set ghost colors: red,green,yellow,white
LBE5D:     ldx    #$03
LBE5F:     lda    LBE68,x
           sta    $4A,x
           dex
           bpl    LBE5F
           rts
LBE68:     .byte  $02,$05,$07,$01

        ;; set colors of ghosts in "defense" mode to blue
LBE6C:     lda    #$06
        
        ;; set colors of ghosts in "defense" mode to color in A
LBE6E:     sta    $A5
           ldx    #$03
LBE72:     lda    $C5,x
           beq    LBE7A
           lda    $A5
           sta    $4A,x
LBE7A:     dex
           bpl    LBE72
           rts

        ;; store A to a 4-character square at ($10)
LBE7E:     ldy    #$00
           sta    ($10),y
           iny
           sta    ($10),y
           ldy    #$16
           sta    ($10),y
           iny
           sta    ($10),y
           rts

        ;; set frequency for all oscillators to 0 (off)
AUDOFF:    lda    #$00
           ldx    #$03
LBE91:     sta    VIC+10,x
           dex
           bpl    LBE91
           rts

        ;; play high-low sequence (part of "pacman caught" melody)
LBE98:     lda    $7B
           sta    VIC+12
           jsr    DELAY2
           sbc    #$1E
           sta    VIC+12
           jsr    DELAY2
           dec    $7B
           jmp    AUDOFF

LBEAD:     jsr    LB68C
           clc
           lda    $12
           adc    #<(COLORRAM+$200-SCREEN)
           sta    $10
           lda    $13
           adc    #>(COLORRAM+$200-SCREEN) ; add offset between SCREEN ($1e00) and COLORRAM
           sta    $11
           ldy    #$00
           jsr    LBED2
           inc    $89
           iny
           jsr    LBED2
           jsr    LB0C1
           ldy    #$00
           lda    #$07
           jmp    LB6A1

LBED2:     lda    $89
           sta    ($12),y
           lda    #$01
           sta    ($10),y
           rts

LBEDB:     tax
           asl    a
           tay
           asl    a
           adc    #$01
           sta    $41,x
           lda    #<(SCREEN+12*22+10)
           sta    $16,y
           lda    #>(SCREEN+12*22+10)
           sta    $17,y
           lda    #$20
           sta    $38,x
           sta    $21,x
           lda    #$00
           sta    $C5,x
           stx    $92
           sty    $93
           lda    #>(SCREEN+12*22+10)
           ldy    #<(SCREEN+12*22+10)
           jsr    LBE33
           ldx    $92
           ldy    $93
           sta    $B0,x
           lda    $A0
           sta    $B4,x
           lda    #$00
           sta    $50,x
           inc    $7A
           rts

           ;; play intro melody
LBF13:     lda    #$08
           sta    VIC+14
           ldy    #$00
LBF1A:     lda    LBF36,y
           sta    VIC+12
           lda    #$00
           sta    $59
           lda    #$21
           sta    $5A
LBF28:     dec    $59
           bne    LBF28
           dec    $5A
           bne    LBF28
           iny
           cpy    #$40
           bne    LBF1A
           rts
LBF36:     .byte  $AF,$87,$87,$E1,$00,$D7,$00,$CF
           .byte  $AF,$E1,$D7,$87,$00,$CF,$CF,$00
           .byte  $B3,$8F,$8F,$E3,$00,$D9,$00,$D1
           .byte  $B3,$E3,$D9,$8F,$00,$D1,$D1,$00
           .byte  $AF,$87,$87,$E1,$00,$D7,$00,$CF
           .byte  $AF,$E1,$D7,$87,$00,$CF,$CF,$00
           .byte  $AF,$CF,$D1,$D4,$00,$D4,$D7,$D9
           .byte  $00,$D9,$DB,$DD,$00,$E1,$E1,$00

        ;; print player 1 score
LBF76:     jsr    LB64E         ; get $002d into $00/$01
           lda    #<(SCREEN+6)
           ldx    #>(SCREEN+6)
           bne    LBF86         ; jump always
        
        ;; print player 2 score
LBF7F:     jsr    LB657         ; get $0030 into $00/$01
           lda    #<(SCREEN+20)
           ldx    #>(SCREEN+20)
LBF86:     sta    $02
           stx    $03
           dec    $00
LBF8C:     clc
           ldx    #$00
           ldy    #$03
LBF91:     lda    ($00),y
           pha
           and    #$0F
           adc    #$14
           sta    ($02,x)
           dec    $02
           pla
           and    #$F0
           jsr    LBFF5
           adc    #$14
           sta    ($02,x)
           dec    $02
           dey
           bne    LBF91
           rts

LBFAC:     lda    #$07
           ldy    #$06
LBFB0:     sta    SCREEN,y
           dey
           bne    LBFB0
           rts

LBFB7:     lda    #$07
           ldy    #$06
LBFBB:     sta    SCREEN+14,y
           dey
           bne    LBFBB
           rts

        ;; reset player 1 score
LBFC2:     lda    #$00
           sta    P1SCORE
           sta    P1SCORE+1
           sta    P1SCORE+2
           rts

        ;; reset player 2 score
LBFCB:     lda    #$00
           sta    P2SCORE
           sta    P2SCORE+1
           sta    P2SCORE+2
           rts

        ;; get current player's skill level into Y
LBFD4:     ldx    CURPLAYER
           lda    LEVEL1,x
           tay
           rts

LBFDA:     ldy    #$10

;;; delay by about Y * 1.3 milliseconds
DELAY:     ldx    #$FF
LBFDE:     dex
           bne    LBFDE
           dey
           bne    LBFDE
           rts

DELAY1:    ldy    #$99
           bne    DELAY
        
DELAY2:    ldy    #$80
           bne    DELAY
        
DELAY3:    ldy    #$D0
           bne    DELAY
        
DELAY4:    ldy    #$FF
           bne    DELAY
        
LBFF5:     lsr    a
           lsr    a
           lsr    a
           lsr    a
           rts

           ;; [unused?]
           .byte $45,$43,$20,$4C,$4F,$00
