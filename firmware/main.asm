;
; 32 Shades of Grey
; Danjovic 2018 - danjovic@hotmail.com
; Released under GPL 2.0
;
.nolist
.include "tn85def.inc"
.list

.equ SyncBit  = 0
.equ Grey0Bit = 5
.equ Grey1Bit = 1
.equ Grey2Bit = 2
.equ Grey3Bit = 3
.equ Grey4Bit = 4


.equ SyncLevel  = 0
.equ BlackLevel = (1<<SyncBit)
.equ WhiteLevel = (1<<SyncBit)|(1<<Grey0Bit)|(1<<Grey1Bit)|(1<<Grey2Bit)|(1<<Grey3Bit)|(1<<Grey4Bit)

/*
 Register usage
 r18 = temp
 r19 = BlackLevel 
 r20 = White Level
 r21 = SyncLevel
 r22 = DelayCounter
 r23 = Counter
 r24 = Stripe Counter

 r30 = Zh
 r31 = Zl

*/

.def Black = r19
.def White = r20
.def Sync  = r21

.cseg
.org 0
	rjmp START         ; External Pin, Power-on Reset,Brown-out Reset, Watchdog Reset
	rjmp EXT_INT       ; External Interrupt Request 0
	rjmp PC_INT        ; Pin Change Interrupt Request 0
	rjmp TIMER1_COMPA  ; Timer/Counter1 Compare Match A
	rjmp TIMER1_OVF    ; Timer/Counter1 Overflow
	rjmp TIMER0_OVF    ; Timer/Counter0 Overflow
	rjmp EE_RDY        ; EEPROM Ready
	rjmp ANA_COMP      ; Analog Comparator
	rjmp ADCC          ; ADC Conversion Complete
	rjmp TIMER1_COMPB  ; Timer/Counter1 Compare Match B
	rjmp TIMER0_COMPA  ; Timer/Counter0 Compare Match A
	rjmp TIMER0_COMPB  ; Timer/Counter0 Compare Match B
	rjmp WDT           ; Watchdog Time-out
	rjmp USI_START     ; USI START
	rjmp USI_OVF       ; USI Overflow

; unused interrupts
EXT_INT:
PC_INT:
TIMER1_COMPA:
TIMER1_OVF:
TIMER0_OVF:
EE_RDY:
ANA_COMP:
ADCC:
TIMER1_COMPB:
TIMER0_COMPA:
TIMER0_COMPB:
WDT:
USI_START:
USI_OVF:
reti


; ****************
START:
	; initialize stach
	ldi r18, low(RAMEND)
	out SPL,r18
	ldi r16, high(RAMEND)
	out SPH, r18

	; initialize variables
	ldi r19,BlackLevel
	ldi r20,WhiteLevel
	ldi r21,SyncLevel


	; initialize I/O ports
	ser r18
	out DDRB,r18
	out PORTB,Black
	
    ; Generate video pattern    


; == FIRST FRAME, 262 lines ==
; lines 
;   3      Heq   - Horizontal Equalization Lines
;   3      Vser  - Vertical Serration Lines
;   3      Heq   - Horizontal Equalization Lines
;  10      Blank - Top Blanking lines
;  26      TBord - Top Border lines
; 192      Vis   - Visible lines, field 1
;  25      BBord - Bottom Border lines
;
; == SECOND FRAME, 263 lines ==
; 1/2      half1 - first half line (half blank line)
;   3      Heq   - Horizontal Equalization Lines
;   3      Vser  - Vertical Serration Lines
;   3      Heq   - Horizontal Equalization Lines 
; 1/2      half2 - second half line (shelf) 
;  10      Blank - Top Blanking lines
;  26      TBord - Top Border lines
; 192      Vis   - Visible lines, field 2
;  25      BBord - Bottom Border lines
;------
; 525 lines 




loop:
; == FIRST FRAME, 262 lines ==
	ldi r23,3   ; 1      (1016 from the last line)

	rcall Heq   ; 1013   1013
	dec r23     ; 1      1014
	brne pc-2   ; 2/1    1016/1015
	ldi r23, 3  ; 1           1016 value for next cycle

	rcall Vser  ; 1013   1013
	dec r23     ; 1      1014
	brne pc-2   ; 2/1    1016/1015
	ldi r23, 3  ; 1           1016 value for next cycle

	rcall Heq   ; 1013   1013
	dec r23     ; 1      1014
	brne pc-2   ; 2/1    1016/1015
	ldi r23,10  ; 1           1016 value for next cycle

	rcall Blank ; 1013   1013
	dec r23     ; 1      1014
	brne pc-2   ; 2/1    1016/1015
	ldi r23,26  ; 1           1016 value for next cycle

	rcall Tbord ; 1013   1013
	dec r23     ; 1      1014
	brne pc-2   ; 2/1    1016/1015
	ldi r23,192 ; 1           1016 value for next cycle

	rcall Vis1  ; 1013   1013
	dec r23     ; 1      1014
	brne pc-2   ; 2/1    1016/1015
	ldi r23, 25 ; 1           1016 value for next cycle

	rcall BBord ; 1013   1013
	dec r23     ; 1      1014
	brne pc-2   ; 2/1    1016/1015
	ldi r23, 1  ; 1           1016 value for next cycle


 ; == SECOND FRAME, 263 lines ==
	rcall Half1 ; 505    505
	dec r23     ; 1      506
	brne pc-3   ; 2/1    508/507
	ldi r23, 3  ; 1          508 value for next cycle

	rcall Heq   ; 1013   1013
	dec r23     ; 1      1014
	brne pc-2   ; 2/1    1016/1015
	ldi r23, 3  ; 1           1016 value for next cycle

	rcall Vser  ; 1013   1013
	dec r23     ; 1      1014
	brne pc-2   ; 2/1    1016/1015
	ldi r23, 3  ; 1           1016 value for next cycle

	rcall Heq   ; 1013   1013
	dec r23     ; 1      1014
	brne pc-2   ; 2/1    1016/1015
	ldi r23,1   ; 1           1016 value for next cycle

	rcall Half2 ; 504    505
	dec r23     ; 1      506
	brne pc-2   ; 2/1    508/507
	ldi r23,10  ; 1           1016 value for next cycle

	rcall Blank ; 1013   1013
	dec r23     ; 1      1014
	brne pc-2   ; 2/1    1016/1015
	ldi r23,26  ; 1           1016 value for next cycle

	rcall Tbord ; 1013   1013
	dec r23     ; 1      1014
	brne pc-2   ; 2/1    1016/1015
	ldi r23,192 ; 1           1016 value for next cycle

	rcall Vis1  ; 1013   1013
	dec r23     ; 1      1014
	brne pc-2   ; 2/1    1016/1015
	ldi r23,24  ; 1           1016 value for next cycle

	rcall BBord ; 1013   1013
	dec r23     ; 1      1014
	brne pc-2   ; 2/1    1016/1015
	ldi r23,1   ; 1           1016 value for next cycle


	rcall Blank ; 1013  1013 ; last line, should use one less cycl
	rjmp loop   ; 2     1015




; Line generation routines  1013 cycles each


; ***** Horizontal Equalization Lines *****
Heq: ; 3 + 1006 + 4 cycles
	 ; 3  cycles so far from rcall

	; 37 cycles sync    ; cycls                sum
	out PORTB,Sync      ; 1                      1
	ldi r22,12          ; 1                   
	dec r22             ; 1     r22*3 = 36      37     
	brne pc-1           ; 2/1           


	; 471 cycles black  ; cycls                sum
	out PORTB,Black     ; 1                      1
	ldi r22,156         ; 1                   
	dec r22             ; 1     r22*3 = 468    469
	brne pc-1           ; 2/1 
	nop                 ; 1                    470
	nop                 ; 1                    471 


	; 37 cycles sync    ; cycls                sum
	out PORTB,Sync      ; 1                      1
	ldi r22,12          ; 1                   
	dec r22             ; 1     r22*3 = 36      37     
	brne pc-1           ; 2/1            


	; 460 black cycles remaining from 1006-37-471-37-1
	; should be 471 cycles black but it is necessary to compensate
	; for some overhead time, by returning before the end of cycles
	; so the next OUT instruction will be performed at the right time
	; to complete the 1016 cycles from the horizontal line
	;
	; 461 cycles black  ; cycls                sum
	out PORTB,Black     ; 1                      1
	ldi r22,153         ; 1                   
	dec r22             ; 1     r22*3 = 459    460
	brne pc-1           ; 2/1
	nop                 ; 1                    461 
	
	; 4 more cycles to return 
	ret 

	; after returning we have 6 more cycles until the next I/O write



Vser: ; 3 + 1006 + 4 cycles = 1013

	; 3 cycles so far from rcall
                         
	; 433 cycles broad  ; cycls                sum
	out PORTB,Sync      ; 1                      1
	ldi r22,144         ; 1                   
	dec r22             ; 1    r22*3 = 432     433
	brne pc-1           ; 2/1    

	; 75 cycles black   ; cycls                sum
	out PORTB,Black     ; 1                      1
	ldi r22,24          ; 1                   
	dec r22             ; 1    r22*3 = 72       73
	brne pc-1           ; 2/1  
	nop                 ; 1                     74
	nop                 ; 1                     75

	; 433 cycles broad  ; cycls                sum
	out PORTB,Sync      ; 1                      1
	ldi r22,144         ; 1                   
	dec r22             ; 1    r22*3 = 432     433
	brne pc-1           ; 2/1              


	; 65 black cycles remaining from 1006-433-75-433
	; should be 75 cycles black but it is necessary to compensate
	; for some overhead time, by returning before the end of cycles
	; so the next OUT instruction will be performed at the right time
	; to complete the 1016 cycles from the horizontal line
	;
	; 65 cycles black  ; cycls                sum
	out PORTB,Black     ; 1                      1
	ldi r22,21          ; 1                   
	dec r22             ; 1     r22*3 = 63      64
	brne pc-1           ; 2/1
	nop                 ; 1                     65 
	
	; 4 more cycles to return 
	ret 
	; after returning we have 6 more cycles until the next I/O write


Tbord:
BBord:
Blank: ; 3 + 1006 + 4 cycles
	; 75 cycles Hsync   ; cycls                sum
	out PORTB,Sync      ; 1                      1
	ldi r22,24          ; 1                   
	dec r22             ; 1    r22*3 = 72       73
	brne pc-1           ; 2/1  
	nop                 ; 1                     74
	nop                 ; 1                     75

	; 931 black cycles remaining from 1006-75

	; 931 cycles shelf  ; cycls                sum
	out PORTB,Black     ; 1                      1
	ldi r22,186         ; 1 
	nop                 ; 1
	nop                 ; 1
	dec r22             ; 1    r22*5 = 930     930
	brne pc-3           ; 2/1  

	; 4 more cycles to return 
	ret 
	; after returning we have 6 more cycles until the next I/O write


; Half Lines 505 bytes each

Half1: ; 3 + 498 + 4 cycles = 505
	; 75 cycles Hsync   ; cycls                sum
	out PORTB,Sync      ; 1                      1
	ldi r22,24          ; 1                   
	dec r22             ; 1    r22*3 = 72       73
	brne pc-1           ; 2/1  
	nop                 ; 1                     74
	nop                 ; 1                     75

	; 423 black cycles remaining from 498-75

	; 423 cycles black  ; cycls                sum
	out PORTB,Black     ; 1                      1
	ldi r22,84          ; 1 
	nop                 ; 1
	nop                 ; 1
	dec r22             ; 1    r22*5 = 420     421
	brne pc-3           ; 2/1  
	nop                 ; 1                    422
	nop                 ; 1                    423

	; 4 more cycles to return 
	ret 
	; after returning we have 6 more cycles until the next I/O write


Half2: ; 3 + 498 + 4 cycles = 505  (just a delay)
	ldi r22,166         ; 1                      1
	dec r22             ; 1    r22*3 = 495     496
	brne pc-1           ; 2/1  
;	nop                 ; 1                    497


	; 4 more cycles to return 
	ret 
	; after returning we have 6 more cycles until the next I/O write




; Visible lines, 1013 cycles each



Vis1: ; 3 + 1006 + 4 cycles

	; 75 cycles Hsync   ; cycls                sum
	out PORTB,Sync      ; 1                      1
	ldi r22,24          ; 1                   
	dec r22             ; 1    r22*3 = 72       73
	brne pc-1           ; 2/1  
	nop                 ; 1                     74
	nop                 ; 1                     75

	; 75 cycles Backporch  ; cycls                sum
	out PORTB,Black     ; 1                      1
	ldi r22,24          ; 1                   
	dec r22             ; 1    r22*3 = 72       73
	brne pc-1           ; 2/1  
	nop                 ; 1                     74
	nop                 ; 1                     75

	; remaining 856 visible cycles from here(1006-75-75)

	; 31 stripes * 27 cycles = 837 cycles
	; remaining: 856 - 37 = 19 cycles

    ; 9 cycles pre                                  
    ldi r24,31 ; 31 stripes              ; 1   1
	ldi ZH, high(Table_Ascending<<1)     ; 1   2
	ldi ZL,  low(Table_Ascending<<1)     ; 1   3
	lpm r18, Z+ ; get first stripe shade ; 3   6
	nop                                  ; 1   7
	nop                                  ; 1   8
	nop                                  ; 1   9

DoStripeAscending:  ; 27*31 = 837 
    out PORTB,r18            ; 1            1
	         
	ldi r22,6                ; 3*r22 = 18  19
	dec r22                  ; 
	brne pc-1                ; 

	lpm r18, Z+              ; 3           22
	nop                      ; 1           23
	nop                      ; 1           24
	dec r24                  ; 1           25
	brne DoStripeAscending   ; 2/1         27 / 26
	nop                      ; 1                27

	; remaining 10 cycles
    out PORTB,Black ;                1
	ldi r22,3       ; 3*r22 = 9     10
	dec r22
	brne pc-1




	; 4 more cycles to return 
	ret 
	; after returning we have 6 more cycles until the next I/O write

Vis2: ; 3 + 1006 + 4 cycles

	; 75 cycles Hsync   ; cycls                sum
	out PORTB,Sync      ; 1                      1
	ldi r22,24          ; 1                   
	dec r22             ; 1    r22*3 = 72       73
	brne pc-1           ; 2/1  
	nop                 ; 1                     74
	nop                 ; 1                     75

	; 75 cycles Backporch  ; cycls                sum
	out PORTB,Black     ; 1                      1
	ldi r22,24          ; 1                   
	dec r22             ; 1    r22*3 = 72       73
	brne pc-1           ; 2/1  
	nop                 ; 1                     74
	nop                 ; 1                     75

	; remaining 856 visible cycles from here(1006-75-75)

	; 31 stripes * 27 cycles = 837 cycles
	; remaining: 856 - 37 = 19 cycles

    ; 9 cycles pre                                  
    ldi r24,31 ; 31 stripes              ; 1   1
	ldi ZH, high(Table_Descending<<1)    ; 1   2
	ldi ZL,  low(Table_Descending<<1)    ; 1   3
	lpm r18, Z+ ; get first stripe shade ; 3   6
	nop                                  ; 1   7
	nop                                  ; 1   8
	nop                                  ; 1   9

DoStripeDescending:  ; 27*31 = 837 
    out PORTB,r18            ; 1            1
	         
	ldi r22,6                ; 3*r22 = 18  19
	dec r22                  ; 
	brne pc-1                ; 

	lpm r18, Z+              ; 3           22
	nop                      ; 1           23
	nop                      ; 1           24
	dec r24                  ; 1           25
	brne DoStripeDescending   ; 2/1         27 / 26
	nop                      ; 1                 27

 ; remaining 10 cycles
    out PORTB,Black ;                1
	ldi r22,3       ; 3*r22 = 9     10
	dec r22
	brne pc-1



	; 4 more cycles to return 
	ret 
	; after returning we have 6 more cycles until the next I/O write




; ************** Data Area ******************************

.equ Sy = SyncBit 
.equ G0 = Grey0Bit
.equ G1 = Grey1Bit
.equ G2 = Grey2Bit
.equ G3 = Grey3Bit
.equ G4 = Grey4Bit



;.db (1<<Sy)|(0<<G4)|(0<<G3)|(0<<G2)|(0<<G1)|(0<<G0) ; Black
Table_Ascending:
.db (1<<Sy)|(0<<G4)|(0<<G3)|(0<<G2)|(0<<G1)|(1<<G0) ; 
.db (1<<Sy)|(0<<G4)|(0<<G3)|(0<<G2)|(1<<G1)|(0<<G0) ; 
.db (1<<Sy)|(0<<G4)|(0<<G3)|(0<<G2)|(1<<G1)|(1<<G0) ; 
.db (1<<Sy)|(0<<G4)|(0<<G3)|(1<<G2)|(0<<G1)|(0<<G0) ; 
.db (1<<Sy)|(0<<G4)|(0<<G3)|(1<<G2)|(0<<G1)|(1<<G0) ; 
.db (1<<Sy)|(0<<G4)|(0<<G3)|(1<<G2)|(1<<G1)|(0<<G0) ; 
.db (1<<Sy)|(0<<G4)|(0<<G3)|(1<<G2)|(1<<G1)|(1<<G0) ; 

.db (1<<Sy)|(0<<G4)|(1<<G3)|(0<<G2)|(0<<G1)|(0<<G0) ; 
.db (1<<Sy)|(0<<G4)|(1<<G3)|(0<<G2)|(0<<G1)|(1<<G0) ; 
.db (1<<Sy)|(0<<G4)|(1<<G3)|(0<<G2)|(1<<G1)|(0<<G0) ; 
.db (1<<Sy)|(0<<G4)|(1<<G3)|(0<<G2)|(1<<G1)|(1<<G0) ; 
.db (1<<Sy)|(0<<G4)|(1<<G3)|(1<<G2)|(0<<G1)|(0<<G0) ; 
.db (1<<Sy)|(0<<G4)|(1<<G3)|(1<<G2)|(0<<G1)|(1<<G0) ; 
.db (1<<Sy)|(0<<G4)|(1<<G3)|(1<<G2)|(1<<G1)|(0<<G0) ; 
.db (1<<Sy)|(0<<G4)|(1<<G3)|(1<<G2)|(1<<G1)|(1<<G0) ; 

.db (1<<Sy)|(1<<G4)|(0<<G3)|(0<<G2)|(0<<G1)|(0<<G0) ; 
.db (1<<Sy)|(1<<G4)|(0<<G3)|(0<<G2)|(0<<G1)|(1<<G0) ; 
.db (1<<Sy)|(1<<G4)|(0<<G3)|(0<<G2)|(1<<G1)|(0<<G0) ; 
.db (1<<Sy)|(1<<G4)|(0<<G3)|(0<<G2)|(1<<G1)|(1<<G0) ; 
.db (1<<Sy)|(1<<G4)|(0<<G3)|(1<<G2)|(0<<G1)|(0<<G0) ; 
.db (1<<Sy)|(1<<G4)|(0<<G3)|(1<<G2)|(0<<G1)|(1<<G0) ; 
.db (1<<Sy)|(1<<G4)|(0<<G3)|(1<<G2)|(1<<G1)|(0<<G0) ; 
.db (1<<Sy)|(1<<G4)|(0<<G3)|(1<<G2)|(1<<G1)|(1<<G0) ; 

.db (1<<Sy)|(1<<G4)|(1<<G3)|(0<<G2)|(0<<G1)|(0<<G0) ; 
.db (1<<Sy)|(1<<G4)|(1<<G3)|(0<<G2)|(0<<G1)|(1<<G0) ; 
.db (1<<Sy)|(1<<G4)|(1<<G3)|(0<<G2)|(1<<G1)|(0<<G0) ; 
.db (1<<Sy)|(1<<G4)|(1<<G3)|(0<<G2)|(1<<G1)|(1<<G0) ; 
.db (1<<Sy)|(1<<G4)|(1<<G3)|(1<<G2)|(0<<G1)|(0<<G0) ; 
.db (1<<Sy)|(1<<G4)|(1<<G3)|(1<<G2)|(0<<G1)|(1<<G0) ; 
.db (1<<Sy)|(1<<G4)|(1<<G3)|(1<<G2)|(1<<G1)|(0<<G0) ; 
.db (1<<Sy)|(1<<G4)|(1<<G3)|(1<<G2)|(1<<G1)|(1<<G0) ; White

Table_Descending:
.db (1<<Sy)|(1<<G4)|(1<<G3)|(1<<G2)|(1<<G1)|(1<<G0) ; White				
.db (1<<Sy)|(1<<G4)|(1<<G3)|(1<<G2)|(1<<G1)|(0<<G0) ; 				
.db (1<<Sy)|(1<<G4)|(1<<G3)|(1<<G2)|(0<<G1)|(1<<G0) ; 				
.db (1<<Sy)|(1<<G4)|(1<<G3)|(1<<G2)|(0<<G1)|(0<<G0) ; 				
.db (1<<Sy)|(1<<G4)|(1<<G3)|(0<<G2)|(1<<G1)|(1<<G0) ; 				
.db (1<<Sy)|(1<<G4)|(1<<G3)|(0<<G2)|(1<<G1)|(0<<G0) ; 				
.db (1<<Sy)|(1<<G4)|(1<<G3)|(0<<G2)|(0<<G1)|(1<<G0) ; 				
.db (1<<Sy)|(1<<G4)|(1<<G3)|(0<<G2)|(0<<G1)|(0<<G0) ; 				
				
.db (1<<Sy)|(1<<G4)|(0<<G3)|(1<<G2)|(1<<G1)|(1<<G0) ; 				
.db (1<<Sy)|(1<<G4)|(0<<G3)|(1<<G2)|(1<<G1)|(0<<G0) ; 				
.db (1<<Sy)|(1<<G4)|(0<<G3)|(1<<G2)|(0<<G1)|(1<<G0) ; 				
.db (1<<Sy)|(1<<G4)|(0<<G3)|(1<<G2)|(0<<G1)|(0<<G0) ; 				
.db (1<<Sy)|(1<<G4)|(0<<G3)|(0<<G2)|(1<<G1)|(1<<G0) ; 				
.db (1<<Sy)|(1<<G4)|(0<<G3)|(0<<G2)|(1<<G1)|(0<<G0) ; 				
.db (1<<Sy)|(1<<G4)|(0<<G3)|(0<<G2)|(0<<G1)|(1<<G0) ; 				
.db (1<<Sy)|(1<<G4)|(0<<G3)|(0<<G2)|(0<<G1)|(0<<G0) ; 				
				
.db (1<<Sy)|(0<<G4)|(1<<G3)|(1<<G2)|(1<<G1)|(1<<G0) ; 				
.db (1<<Sy)|(0<<G4)|(1<<G3)|(1<<G2)|(1<<G1)|(0<<G0) ; 				
.db (1<<Sy)|(0<<G4)|(1<<G3)|(1<<G2)|(0<<G1)|(1<<G0) ; 				
.db (1<<Sy)|(0<<G4)|(1<<G3)|(1<<G2)|(0<<G1)|(0<<G0) ; 				
.db (1<<Sy)|(0<<G4)|(1<<G3)|(0<<G2)|(1<<G1)|(1<<G0) ; 				
.db (1<<Sy)|(0<<G4)|(1<<G3)|(0<<G2)|(1<<G1)|(0<<G0) ; 				
.db (1<<Sy)|(0<<G4)|(1<<G3)|(0<<G2)|(0<<G1)|(1<<G0) ; 				
.db (1<<Sy)|(0<<G4)|(1<<G3)|(0<<G2)|(0<<G1)|(0<<G0) ; 				
				
.db (1<<Sy)|(0<<G4)|(0<<G3)|(1<<G2)|(1<<G1)|(1<<G0) ; 				
.db (1<<Sy)|(0<<G4)|(0<<G3)|(1<<G2)|(1<<G1)|(0<<G0) ; 				
.db (1<<Sy)|(0<<G4)|(0<<G3)|(1<<G2)|(0<<G1)|(1<<G0) ; 				
.db (1<<Sy)|(0<<G4)|(0<<G3)|(1<<G2)|(0<<G1)|(0<<G0) ; 				
.db (1<<Sy)|(0<<G4)|(0<<G3)|(0<<G2)|(1<<G1)|(1<<G0) ; 				
.db (1<<Sy)|(0<<G4)|(0<<G3)|(0<<G2)|(1<<G1)|(0<<G0) ; 				
.db (1<<Sy)|(0<<G4)|(0<<G3)|(0<<G2)|(0<<G1)|(1<<G0) ; 	
			
;.db (1<<Sy)|(0<<G4)|(0<<G3)|(0<<G2)|(0<<G1)|(0<<G0) ; Black
