;
; 32 Shades of Grey   - Definitions file
; Danjovic 2018 - danjovic@hotmail.com
; Released under GPL 2.0
;

;.equ SyncBit  = 0


;.equ Grey0Bit = 5
;.equ Grey1Bit = 1
;.equ Grey2Bit = 2
;.equ Grey3Bit = 3
;.equ Grey4Bit = 4

.equ PORTV = PORTC
.equ DDRV  = DDRC

.equ Grey0Bit = 5
.equ Grey1Bit = 4
.equ Grey2Bit = 3
.equ Grey3Bit = 2
.equ Grey4Bit = 1
.equ SyncBit  = 0



.equ SyncLevel  = 0
.equ BlackLevel = (1<<SyncBit)
.equ WhiteLevel = (1<<SyncBit)|(1<<Grey0Bit)|(1<<Grey1Bit)|(1<<Grey2Bit)|(1<<Grey3Bit)|(1<<Grey4Bit)

.equ Sy = SyncBit
.equ G0 = Grey0Bit
.equ G1 = Grey1Bit
.equ G2 = Grey2Bit
.equ G3 = Grey3Bit
.equ G4 = Grey4Bit

.equ  gray0 = (1<<Sy)|(0<<G4)|(0<<G3)|(0<<G2)|(0<<G1)|(0<<G0) ; Black
.equ  gray1 = (1<<Sy)|(0<<G4)|(0<<G3)|(0<<G2)|(0<<G1)|(1<<G0) ;
.equ  gray2 = (1<<Sy)|(0<<G4)|(0<<G3)|(0<<G2)|(1<<G1)|(0<<G0) ;
.equ  gray3 = (1<<Sy)|(0<<G4)|(0<<G3)|(0<<G2)|(1<<G1)|(1<<G0) ;
.equ  gray4 = (1<<Sy)|(0<<G4)|(0<<G3)|(1<<G2)|(0<<G1)|(0<<G0) ;
.equ  gray5 = (1<<Sy)|(0<<G4)|(0<<G3)|(1<<G2)|(0<<G1)|(1<<G0) ;
.equ  gray6 = (1<<Sy)|(0<<G4)|(0<<G3)|(1<<G2)|(1<<G1)|(0<<G0) ;
.equ  gray7 = (1<<Sy)|(0<<G4)|(0<<G3)|(1<<G2)|(1<<G1)|(1<<G0) ; 				
.equ  gray8 = (1<<Sy)|(0<<G4)|(1<<G3)|(0<<G2)|(0<<G1)|(0<<G0) ;
.equ  gray9 = (1<<Sy)|(0<<G4)|(1<<G3)|(0<<G2)|(0<<G1)|(1<<G0) ; 				
.equ gray10 = (1<<Sy)|(0<<G4)|(1<<G3)|(0<<G2)|(1<<G1)|(0<<G0) ; 				
.equ gray11 = (1<<Sy)|(0<<G4)|(1<<G3)|(0<<G2)|(1<<G1)|(1<<G0) ; 				
.equ gray12 = (1<<Sy)|(0<<G4)|(1<<G3)|(1<<G2)|(0<<G1)|(0<<G0) ; 				
.equ gray13 = (1<<Sy)|(0<<G4)|(1<<G3)|(1<<G2)|(0<<G1)|(1<<G0) ; 				
.equ gray14 = (1<<Sy)|(0<<G4)|(1<<G3)|(1<<G2)|(1<<G1)|(0<<G0) ; 				
.equ gray15 = (1<<Sy)|(0<<G4)|(1<<G3)|(1<<G2)|(1<<G1)|(1<<G0) ; 				
.equ gray16 = (1<<Sy)|(1<<G4)|(0<<G3)|(0<<G2)|(0<<G1)|(0<<G0) ; 				
.equ gray17 = (1<<Sy)|(1<<G4)|(0<<G3)|(0<<G2)|(0<<G1)|(1<<G0) ; 				
.equ gray18 = (1<<Sy)|(1<<G4)|(0<<G3)|(0<<G2)|(1<<G1)|(0<<G0) ;
.equ gray19 = (1<<Sy)|(1<<G4)|(0<<G3)|(0<<G2)|(1<<G1)|(1<<G0) ; 				
.equ gray20 = (1<<Sy)|(1<<G4)|(0<<G3)|(1<<G2)|(0<<G1)|(0<<G0) ; 				
.equ gray21 = (1<<Sy)|(1<<G4)|(0<<G3)|(1<<G2)|(0<<G1)|(1<<G0) ; 				
.equ gray22 = (1<<Sy)|(1<<G4)|(0<<G3)|(1<<G2)|(1<<G1)|(0<<G0) ; 				
.equ gray23 = (1<<Sy)|(1<<G4)|(0<<G3)|(1<<G2)|(1<<G1)|(1<<G0) ; 					
.equ gray24 = (1<<Sy)|(1<<G4)|(1<<G3)|(0<<G2)|(0<<G1)|(0<<G0) ; 				
.equ gray25 = (1<<Sy)|(1<<G4)|(1<<G3)|(0<<G2)|(0<<G1)|(1<<G0) ; 				
.equ gray26 = (1<<Sy)|(1<<G4)|(1<<G3)|(0<<G2)|(1<<G1)|(0<<G0) ; 				
.equ gray27 = (1<<Sy)|(1<<G4)|(1<<G3)|(0<<G2)|(1<<G1)|(1<<G0) ; 				
.equ gray28 = (1<<Sy)|(1<<G4)|(1<<G3)|(1<<G2)|(0<<G1)|(0<<G0) ; 				
.equ gray29 = (1<<Sy)|(1<<G4)|(1<<G3)|(1<<G2)|(0<<G1)|(1<<G0) ;
.equ gray30 = (1<<Sy)|(1<<G4)|(1<<G3)|(1<<G2)|(1<<G1)|(0<<G0) ;
.equ gray31 = (1<<Sy)|(1<<G4)|(1<<G3)|(1<<G2)|(1<<G1)|(1<<G0) ; White


;****** Macros ****************

 ; generate Hsync + backporch, 150 cycles
.macro HsyncBackporch
	; 75 cycles Hsync   ; cycls                sum
	out PORTV,Sync      ; 1                      1
	ldi r22,24          ; 1                   
	dec r22             ; 1    r22*3 = 72       73
	brne pc-1           ; 2/1  
	nop                 ; 1                     74
	nop                 ; 1                     75

	; 75 cycles Backporch  ; cycls                sum
	out PORTV,Black     ; 1                      1
	ldi r22,24          ; 1                   
	dec r22             ; 1    r22*3 = 72       73
	brne pc-1           ; 2/1
	nop                 ; 1                     74
	nop                 ; 1                     75
.endm




;draw a stripe, 27 cycles
.macro	DoStripe		
	ldi r18,@0      ; 1            1
	out PORTV,r18   ; 1            2
	ldi r22,8       ; 3*r22 = 24  26
	dec r22         ;
	brne pc-1       ;
    nop             ; 1           27
.endm




; draw the resolution pattern 81 cycles
.macro DoResolutionPattern 
	nop             ; 1  timing equalization           1

  	; highest resolution 7 line pairs - 14 cycles     15
	out PORTV,Black ; 1
	out PORTV,White ; 1
	out PORTV,Black ; 1
	out PORTV,White ; 1
	out PORTV,Black ; 1
	out PORTV,White ; 1
	out PORTV,Black ; 1
	out PORTV,White ; 1
	out PORTV,Black ; 1
	out PORTV,White ; 1
	out PORTV,Black ; 1
	out PORTV,White ; 1
	out PORTV,Black ; 1
	out PORTV,White ; 1

  	; mid resolution 7 line pairs -  28 cycles        43 
	out PORTV,Black ; 1
	nop             ; 1
 	out PORTV,White ; 1
	nop             ; 1
	out PORTV,Black ; 1
	nop             ; 1
	out PORTV,White ; 1
	nop             ; 1
	out PORTV,Black ; 1
	nop             ; 1
	out PORTV,White ; 1
	nop             ; 1
	out PORTV,Black ; 1
	nop             ; 1
	out PORTV,White ; 1
	nop             ; 1
	out PORTV,Black ; 1
	nop             ; 1
	out PORTV,White ; 1
	nop             ; 1
	out PORTV,Black ; 1
	nop             ; 1
	out PORTV,White ; 1
	nop             ; 1
	out PORTV,Black ; 1
	nop             ; 1
	out PORTV,White ; 1
;	 nop             ; 1   save 1 cycle for loading r22


  	; mid resolution 6  line pairs - 36 cycles       79
	ldi r22,6       ; 1
	out PORTV,Black ; 1  1
	nop             ; 1  2
	dec r22         ; 1  3
	out PORTV,White ; 1  4
	brne pc-4       ; 2  5\5
	nop             ; 1    6

	out PORTV,Black ; 1   half line pair  2 cycles   81
 	nop             ; 1

.endm
