;
; 32 Shades of Grey   - Definitions file
; Danjovic 2018 - danjovic@hotmail.com
; Released under GPL 2.0
;

.equ SyncBit  = 0
.equ Grey0Bit = 5
.equ Grey1Bit = 1
.equ Grey2Bit = 2
.equ Grey3Bit = 3
.equ Grey4Bit = 4


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
.equ gray31  = (1<<Sy)|(1<<G4)|(1<<G3)|(1<<G2)|(1<<G1)|(1<<G0) ; White


