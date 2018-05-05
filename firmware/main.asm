;
; 32 Shades of Grey
; Danjovic 2018 - danjovic@hotmail.com
; Released under GPL 2.0
;
.nolist
.include "m328def.inc"
.include "definitions.inc" 
.list


; Register usage
; r18 = temp
; r19 = BlackLevel 
; r20 = White Level
; r21 = SyncLevel
; r22 = DelayCounter
; r23 = Counter
; r24 = Stripe Counter


.def Black = r19
.def White = r20
.def Sync  = r21

.cseg
	rjmp START             ; External Pin, Power-on Reset, Brown-out Reset and Watchdog System Reset
	rjmp INT_0              ; External Interrupt Request 0
	rjmp INT_1              ; External Interrupt Request 0
	rjmp PC_INT0           ; Pin Change Interrupt Request 0
	rjmp PC_INT1           ; Pin Change Interrupt Request 1
	rjmp PC_INT2           ; Pin Change Interrupt Request 2
	rjmp WDT               ; WatchdogTime-out Interrupt
	rjmp TIMER2_COMPA      ; Timer/Counter2 Compare Match A
	rjmp TIMER2_COMPB      ; Timer/Coutner2 Compare Match B
	rjmp TIMER2_OVF        ; Timer/Counter2 Overflow
	rjmp TIMER1_CAPT       ; Timer/Counter1 Capture Event
	rjmp TIMER1_COMPA      ; Timer/Counter1 Compare Match A
	rjmp TIMER1_COMPB      ; Timer/Coutner1 Compare Match B
	rjmp TIMER1_OVF        ; Timer/Counter1 Overflow
	rjmp TIMER0_COMPA      ; Timer/Counter0 Compare Match A
	rjmp TIMER0_COMPB      ; Timer/Coutner0 Compare Match B
	rjmp TIMER0_OVF        ; Timer/Counter0 Overflow
	rjmp SPI_STC           ; SPI Serial Transfer Complete
	rjmp USART_RX          ; USART Rx Complete
	rjmp USART_UDRE        ; USART Data Register Empty
	rjmp USART_TX          ; USART Tx Complete
	rjmp ADCC              ; ADC Conversion Complete
	rjmp EE_READY          ; EEPROM Ready
	rjmp ANALOG_COMP       ; Analog Comparator
	rjmp TWI               ; 2-wire Serial Interface (I2C)
	rjmp SPM_READY         ; Store Program Memory Ready

 
; unused interrupts           
INT_0:              
INT_1:              
PC_INT0:            
PC_INT1:            
PC_INT2:            
WDT:      
TIMER2_COMPA:      
TIMER2_COMPB:      
TIMER2_OVF:      
TIMER1_CAPT:      
TIMER1_COMPA:      
TIMER1_COMPB:      
TIMER1_OVF:      
TIMER0_COMPA:      
TIMER0_COMPB:      
TIMER0_OVF:      
SPI_STC:           
USART_RX:          
USART_UDRE:  
USART_TX:         
ADCC:              
EE_READY:          
ANALOG_COMP:       
TWI:               
SPM_READY:  
reti


; ****************
START:

	; initialize stack
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
	out DDRV,r18
	out PORTV,Black



    ; Generate video pattern


; == FIRST FRAME, 262 lines ==
; lines 
;   3      Heq   - Horizontal Equalization Lines
;   3      Vser  - Vertical Serration Lines
;   3      Heq   - Horizontal Equalization Lines
;  10      Blank - Top Blanking lines
;  24      TBord - Top Border lines
; 200      Vis   - Visible lines, field 1
;                  30 - progressive  greyscale
;                  40 - resolution + progress greyscale
;                  30 - progressive  greyscale
;
;                  30 - decrescent  greyscale
;                  40 - resolution + decrescent greyscale
;                  30 - decrescent  greyscale
;
;  21      BBord - Bottom Border lines
;
; == SECOND FRAME, 263 lines ==
; 1/2      half1 - first half line (half blank line)
;   3      Heq   - Horizontal Equalization Lines
;   3      Vser  - Vertical Serration Lines
;   3      Heq   - Horizontal Equalization Lines
; 1/2      half2 - second half line (shelf)
;  10      Blank - Top Blanking lines
;  24      TBord - Top Border lines
; 200      Vis   - Visible lines, field 2
;                  30 - progressive  greyscale
;                  40 - resolution + progress greyscale
;                  30 - progressive  greyscale
;
;                  30 - decrescent  greyscale
;                  40 - resolution + decrescent greyscale
;                  30 - decrescent  greyscale
;
;  21      BBord - Bottom Border lines
;------
; 525 lines 




loop:


; == FIRST FRAME, 262 lines ==
	ldi r23,3   ; 1      (1016 from the last line at the end of the loop)

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
	ldi r23,22  ; 1           1016 value for next cycle

	rcall Tbord ; 1013   1013
	dec r23     ; 1      1014
	brne pc-2   ; 2/1    1016/1015
	


	
; *************** Visible: 200 lines ******************
	ldi r23,30 ; 1           1016 value for next cycle
	rcall Progressive  ; 1013   1013
	dec r23     ; 1      1014
	brne pc-2   ; 2/1    1016/1015

	ldi r23,40  ;            1016
	rcall ProgrResolution ; 1013   1013
	dec r23     ; 1      1014
	brne pc-2   ; 2/1    1016/1015

	ldi r23,30 ; 1           1016 value for next cycle
	rcall Progressive  ; 1013   1013
	dec r23     ; 1      1014
	brne pc-2   ; 2/1    1016/1015

	ldi r23,30 ; 1           1016 value for next cycle
	rcall Regressive  ; 1013   1013
	dec r23     ; 1      1014
	brne pc-2   ; 2/1    1016/1015

	ldi r23,40  ;            1016
	rcall RegrResolution  ; 1013   1013
	dec r23     ; 1      1014
	brne pc-2   ; 2/1    1016/1015

	ldi r23,30 ; 1           1016 value for next cycle
	rcall Regressive  ; 1013   1013
	dec r23     ; 1      1014
	brne pc-2   ; 2/1    1016/101

; *************** End of Visible Lines ****************



	ldi r23, 21 ; 1           1016 value for next cycle

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
	ldi r23,22  ; 1           1016 value for next cycle

	rcall Tbord ; 1013   1013
	dec r23     ; 1      1014
	brne pc-2   ; 2/1    1016/1015

; *************** Visible: 200 lines ******************
	ldi r23,30 ; 1           1016 value for next cycle
	rcall Progressive  ; 1013   1013
	dec r23     ; 1      1014
	brne pc-2   ; 2/1    1016/1015

	ldi r23,40  ;            1016
	rcall ProgrResolution ; 1013   1013
	dec r23     ; 1      1014
	brne pc-2   ; 2/1    1016/1015

	ldi r23,30 ; 1           1016 value for next cycle
	rcall Progressive  ; 1013   1013
	dec r23     ; 1      1014
	brne pc-2   ; 2/1    1016/1015

	ldi r23,30 ; 1           1016 value for next cycle
	rcall Regressive  ; 1013   1013
	dec r23     ; 1      1014
	brne pc-2   ; 2/1    1016/1015

	ldi r23,40  ;            1016
	rcall RegrResolution  ; 1013   1013
	dec r23     ; 1      1014
	brne pc-2   ; 2/1    1016/1015

	ldi r23,30 ; 1           1016 value for next cycle
	rcall Regressive  ; 1013   1013
	dec r23     ; 1      1014
	brne pc-2   ; 2/1    1016/10115


; *************** End of Visible Lines ****************


	ldi r23,20  ; 1           1016 value for next cycle


	rcall BBord ; 1013   1013
	dec r23     ; 1      1014
	brne pc-2   ; 2/1    1016/1015
	ldi r23,1   ; 1           1016 value for next cycle


	rcall Blank ; 1013  1013 ; last line, should use one less cycl
	rjmp loop   ; 2     1015



; **************************************************
;
; Line generation routines  1013 cycles each
;
; **************************************************

;****** Horizontal Equalization line *****
;*
Heq: ; 3 + 1006 + 4 cycles
	 ; 3  cycles so far from rcall

	; 37 cycles sync    ; cycls                sum
	out PORTV,Sync      ; 1                      1
	ldi r22,12          ; 1                   
	dec r22             ; 1     r22*3 = 36      37     
	brne pc-1           ; 2/1           


	; 471 cycles black  ; cycls                sum
	out PORTV,Black     ; 1                      1
	ldi r22,156         ; 1                   
	dec r22             ; 1     r22*3 = 468    469
	brne pc-1           ; 2/1 
	nop                 ; 1                    470
	nop                 ; 1                    471 


	; 37 cycles sync    ; cycls                sum
	out PORTV,Sync      ; 1                      1
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
	out PORTV,Black     ; 1                      1
	ldi r22,153         ; 1                   
	dec r22             ; 1     r22*3 = 459    460
	brne pc-1           ; 2/1
	nop                 ; 1                    461 
	
	; 4 more cycles to return 
	ret 

	; after returning we have 6 more cycles until the next I/O write


;****** Vertical Serration Pulse line  *****
;*
Vser: ; 3 + 1006 + 4 cycles = 1013

	; 3 cycles so far from rcall
                         
	; 433 cycles broad  ; cycls                sum
	out PORTV,Sync      ; 1                      1
	ldi r22,144         ; 1                   
	dec r22             ; 1    r22*3 = 432     433
	brne pc-1           ; 2/1    

	; 75 cycles black   ; cycls                sum
	out PORTV,Black     ; 1                      1
	ldi r22,24          ; 1                   
	dec r22             ; 1    r22*3 = 72       73
	brne pc-1           ; 2/1  
	nop                 ; 1                     74
	nop                 ; 1                     75

	; 433 cycles broad  ; cycls                sum
	out PORTV,Sync      ; 1                      1
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
	out PORTV,Black     ; 1                      1
	ldi r22,21          ; 1                   
	dec r22             ; 1     r22*3 = 63      64
	brne pc-1           ; 2/1
	nop                 ; 1                     65 
	
	; 4 more cycles to return 
	ret 
	; after returning we have 6 more cycles until the next I/O write



;***** Blank lines, same for top and bottom border  *****
;*
Tbord:
BBord:
Blank: ; 3 + 1006 + 4 cycles
	; 75 cycles Hsync   ; cycls                sum
	out PORTV,Sync      ; 1                      1
	ldi r22,24          ; 1                   
	dec r22             ; 1    r22*3 = 72       73
	brne pc-1           ; 2/1  
	nop                 ; 1                     74
	nop                 ; 1                     75

	; 931 black cycles remaining from 1006-75

	; 931 cycles shelf  ; cycls                sum
	out PORTV,Black     ; 1                      1
	ldi r22,186         ; 1 
	nop                 ; 1
	nop                 ; 1
	dec r22             ; 1    r22*5 = 930     930
	brne pc-3           ; 2/1  

	; 4 more cycles to return 
	ret 
	; after returning we have 6 more cycles until the next I/O write



; *******    Half video line with Hsync pulse *****************
Half1: ; 3 + 498 + 4 cycles = 505 bytes each
	; 75 cycles Hsync   ; cycls                sum
	out PORTV,Sync      ; 1                      1
	ldi r22,24          ; 1                   
	dec r22             ; 1    r22*3 = 72       73
	brne pc-1           ; 2/1  
	nop                 ; 1                     74
	nop                 ; 1                     75

	; 423 black cycles remaining from 498-75

	; 423 cycles black  ; cycls                sum
	out PORTV,Black     ; 1                      1
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



; **********  Half shelf line  **************************
Half2: ; 3 + 498 + 4 cycles = 505  (just a delay)
	ldi r22,166         ;                       
	dec r22             ;    r22*3 = 498     496
	brne pc-1           ;   

	; 4 more cycles to return 
	ret 
	; after returning we have 6 more cycles until the next I/O write



;*********************************************************************
;
; Visible content lines, 1013 cycles each
;
;*********************************************************************


;*********************************************************************
;* Generate a progressive grayscale line
Progressive:
    ; 3 + 1006 + 4 cycles

	HsyncBackporch  ; 150 cycles, 856 remaining (1006 - 150)

	; 31 stripes * 27 cycles = 837 cycles
	; remaining: 856 - 37 = 19 cycles

	; 9 cycles first
	; 31 * 27 cycles then = 837
	; 10 cycles at the end
	; 

	ldi r22,3         ; r22*3 = 9 
	dec r22
	brne pc-1 

	DoStripe gray1  ; 27  31*27 = 837
	DoStripe gray2  ; 27  
	DoStripe gray3  ; 27  
	DoStripe gray4  ; 27  
	DoStripe gray5  ; 27  
	DoStripe gray6  ; 27  
	DoStripe gray7  ; 27  
	DoStripe gray8  ; 27  
	DoStripe gray9  ; 27  
	DoStripe gray10 ; 27  
	DoStripe gray11 ; 27  
	DoStripe gray12 ; 27  
	DoStripe gray13 ; 27  
	DoStripe gray14 ; 27  
	DoStripe gray15 ; 27  
	DoStripe gray16 ; 27  
	DoStripe gray17 ; 27  
	DoStripe gray18 ; 27  
	DoStripe gray19 ; 27  
	DoStripe gray20 ; 27  
	DoStripe gray21 ; 27  
	DoStripe gray22 ; 27  
	DoStripe gray23 ; 27  
	DoStripe gray24 ; 27  
	DoStripe gray25 ; 27  
	DoStripe gray26 ; 27  
	DoStripe gray27 ; 27  
	DoStripe gray28 ; 27  
	DoStripe gray29 ; 27  
	DoStripe gray30 ; 27  
	DoStripe gray31 ; 27 


	; remaining 10 cycles
	out PORTV,Black ;                1
	ldi r22,3       ; 3*r22 = 9     10
	dec r22
	brne pc-1

	; 4 more cycles to return 
	ret 
	; after returning we have 6 more cycles until the next I/O write


;*********************************************************************
;* Generate a regressive grayscale line
Regressive: 
	; 3+ 1006 + 4 cycles

	HsyncBackporch  ; 150 cycles, 856 remaining (1006 - 150)

	; 31 stripes * 27 cycles = 837 cycles
	; remaining: 856 - 37 = 19 cycles

	; 9 cycles first
	; 31 * 27 cycles then = 837
	; 10 cycles at the end
	; 

	ldi r22,3         ; r22*3 = 9 
	dec r22
	brne pc-1 

	DoStripe gray31 ; 27  31*27 = 837
	DoStripe gray30 ; 27  
	DoStripe gray29 ; 27  
	DoStripe gray28 ; 27  
	DoStripe gray27 ; 27  
	DoStripe gray26 ; 27  
	DoStripe gray25 ; 27  
	DoStripe gray24 ; 27  
	DoStripe gray23 ; 27  
	DoStripe gray22 ; 27  
	DoStripe gray21 ; 27  
	DoStripe gray20 ; 27  
	DoStripe gray19 ; 27  
	DoStripe gray18 ; 27  
	DoStripe gray17 ; 27  
	DoStripe gray16 ; 27  
	DoStripe gray15 ; 27  
	DoStripe gray14 ; 27  
	DoStripe gray13 ; 27  
	DoStripe gray12 ; 27  
	DoStripe gray11 ; 27  
	DoStripe gray10 ; 27  
	DoStripe gray9  ; 27  
	DoStripe gray8  ; 27  
	DoStripe gray7  ; 27  
	DoStripe gray6  ; 27  
	DoStripe gray5  ; 27  
	DoStripe gray4  ; 27  
	DoStripe gray3  ; 27  
	DoStripe gray2  ; 27  
	DoStripe gray1  ; 27


	; remaining 10 cycles
	out PORTV,Black ;                1
	ldi r22,3       ; 3*r22 = 9     10
	dec r22
	brne pc-1

	; 4 more cycles to return 
	ret 
	; after returning we have 6 more cycles until the next I/O write

;*********************************************************************
;* Generate a progressive grayscale line with resolution pattern
ProgrResolution:  
    ; 3 + 1006 + 4 cycles

	HsyncBackporch  ; 150 cycles, 856 remaining (1006 - 150)

	; 31 stripes * 27 cycles = 837 cycles
	; 6 stripes                           * 27  = 162  cycles
	; 3 stripe times= resolution pattern        =  81  cycles
	; 13 stripes                          * 27  = 351  cycles
	; 3 stripe times= resolution pattern        =  81  cycles
	; 6 stripes	                          * 27  = 162  cycles
	;                                            ------
	;                                             837 cycles
	
	; remaining: 856 - 837 = 19 cycles

	; 9 cycles first
	; 31 * 27 cycles then = 837
	; 10 cycles at the end
	; 
	
	
	ldi r22,3         ; r22*3 = 9 
	dec r22
	brne pc-1 

	DoStripe gray1      ; 27  31*27 = 837
	DoStripe gray2      ; 27  
	DoStripe gray3      ; 27  
	DoStripe gray4      ; 27  
	DoStripe gray5      ; 27  
	DoStripe gray6      ; 27  
	DoResolutionPattern	; 81
;	DoStripe gray7      ; 27  
;	DoStripe gray8      ; 27  
;	DoStripe gray9      ; 27  
	DoStripe gray10     ; 27  
	DoStripe gray11     ; 27  
	DoStripe gray12     ; 27  
	DoStripe gray13     ; 27  
	DoStripe gray14     ; 27  
	DoStripe gray15     ; 27  
	DoStripe gray16     ; 27  
	DoStripe gray17     ; 27  
	DoStripe gray18     ; 27  
	DoStripe gray19     ; 27  
	DoStripe gray20     ; 27  
	DoStripe gray21     ; 27  
	DoStripe gray22     ; 27
	DoResolutionPattern	; 81	
;	DoStripe gray23     ; 27  
;	DoStripe gray24     ; 27  
;	DoStripe gray25     ; 27  
	DoStripe gray26     ; 27  
	DoStripe gray27     ; 27  
	DoStripe gray28     ; 27  
	DoStripe gray29     ; 27  
	DoStripe gray30     ; 27  
	DoStripe gray31     ; 27 


	; remaining 10 cycles
	out PORTV,Black ;                1
	ldi r22,3       ; 3*r22 = 9     10
	dec r22
	brne pc-1

	; 4 more cycles to return 
	ret 
	; after returning we have 6 more cycles until the next I/O write



;*********************************************************************
;* Generate a regressive grayscale line with resolution pattern
RegrResolution: ; 3+ 1006 + 4 cycles

	HsyncBackporch  ; 150 cycles, 856 remaining (1006 - 150)

	; 31 stripes * 27 cycles = 837 cycles
	; remaining: 856 - 37 = 19 cycles

	; 9 cycles first
	; 31 * 27 cycles then = 837
	; 10 cycles at the end
	; 

	ldi r22,3         ; r22*3 = 9 
	dec r22
	brne pc-1 

	DoStripe gray31     ; 27  31*27 = 837
	DoStripe gray30     ; 27  
	DoStripe gray29     ; 27  
	DoStripe gray28     ; 27  
	DoStripe gray27     ; 27  
	DoStripe gray26     ; 27  
	DoResolutionPattern	; 81
;	DoStripe gray25     ; 27  
;	DoStripe gray24     ; 27  
;	DoStripe gray23     ; 27  
	DoStripe gray22     ; 27  
	DoStripe gray21     ; 27  
	DoStripe gray20     ; 27  
	DoStripe gray19     ; 27  
	DoStripe gray18     ; 27  
	DoStripe gray17     ; 27  
	DoStripe gray16     ; 27  
	DoStripe gray15     ; 27  
	DoStripe gray14     ; 27  
	DoStripe gray13     ; 27  
	DoStripe gray12     ; 27  
	DoStripe gray11     ; 27  
	DoStripe gray10     ; 27  
	DoResolutionPattern	; 81
;	DoStripe gray9      ; 27  
;	DoStripe gray8      ; 27  
;	DoStripe gray7      ; 27  
	DoStripe gray6      ; 27  
	DoStripe gray5      ; 27  
	DoStripe gray4      ; 27  
	DoStripe gray3      ; 27  
	DoStripe gray2      ; 27  
	DoStripe gray1      ; 27

	; remaining 10 cycles
	out PORTV,Black ;                1
	ldi r22,3       ; 3*r22 = 9     10
	dec r22
	brne pc-1

	; 4 more cycles to return 
	ret 
	; after returning we have 6 more cycles until the next I/O write



