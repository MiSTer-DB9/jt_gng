	ORG $8000

	FILL $FF,$e000-$8000

	ORG $E000
RESET: 
	ORCC #$10
	LDS	#$1E00-1
	ANDCC #$EF
	LDU #0
	
	; Horizontal Scroll
	CLR	$3B08
	CLR $3B09

	; Vertical Scroll
	CLR	$3B0A
	CLR $3B0B

	; Sprite data
	BSR	CLEAR_SPR

	; Single Sprite
	LDX #$1E00
	LDA #$1E
	STA ,X+
	CLRA
	STA ,X+
	LDA #$80	; Y
	STA ,X+
	LDA #$40	; X
	STA ,X+
	STA	$3C00	; OKOUT	


	; Red, Green Test
	LDA #$A5
	LDX #$3800
@LOOP:
	STA ,X+
	CMPX #$3900
	BNE @LOOP
	;STA	$3C00	; OKOUT	

	; Blue Test
	LDA #$A0
	LDX #$3900
@LOOP:
	STA ,X+
	CMPX #$3A00
	BNE @LOOP
	;STA	$3C00	; OKOUT	

	; Scroll RAM test, 30ms
	LDA #$AA
	LDX #$2800
@LOOP:
	STA ,X
	CMPA ,X+
	BNE ERROR_CHRAM
	CMPX #$3000
	BNE @LOOP
	;STA	$3C00	; OKOUT	

	; Character RAM test, 30ms
	LDA #$AA
	LDX #$2000
@LOOP:
	STA ,X
	CMPA ,X+
	BNE ERROR_CHRAM
	CMPX #$2800
	BNE @LOOP
	;STA	$3C00	; OKOUT	

MAINRAM_TEST:	; 105ms
	LDX #$0000
	LDA #$55
@LOOP:	
	STA ,X
	CMPA ,X+
	BNE ERROR_RAM
	CMPX #$2000
	BNE @LOOP
	;STA	$3C00	; OKOUT	

NO_ERROR:
	LDU #0
	BRA NO_ERROR

;--------------------------------------------------------------

CLEAR_SPR:
	CLRA
	LDX #$1E00
	CLRB
@LOOP:
	STD ,X++
	STD ,X++
	CMPX #$2000
	BNE @LOOP
	RTS

UPD_SPR_LOOP:
@LOOP:
	STA	$3C00	; OKOUT	
	LDX #1000
	LDY #0
@LOOP2:
	LEAX ,-X
	CMPX #0
	BNE @LOOP2
	STA	$3C00	; OKOUT	
	LEAY ,Y+
	BRA @LOOP
	RTS


ERROR_RAM:
	LDU #1
	BRA ERROR_RAM

ERROR_CHRAM:
	LDU #2
	BRA ERROR_CHRAM

IRQSERVICE:
	; Sprite update
	STA	$3C00	; OKOUT	
	RTI

	FILL $FF,$FFF8-*
	.WORD IRQSERVICE
	FILL $FF,$FFFE-*

	.WORD RESET