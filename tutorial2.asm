; Tutorial 2,   PVI objects
;========================================================================================


; CONSTANTS
; ---------

carrybit	equ	$01
compare		equ	$02
withcarry	equ	$08
registerselect	equ	$10
intinhibit	equ 	$20
stackpointer	equ	$07

obj1complete	equ	$08
obj2complete	equ	$04
obj3complete	equ	$02
obj4complete	equ	$01

effects		equ	$1e80

player1keys147c	equ	$1e88	;player1 keypad, bits: 1,4,7,clear,x,x,x,x
player1keys2580	equ	$1e89	;player1 keypad, bits: 2,5,8,0,x,x,x,x
player1keys369e	equ	$1e8a	;player1 keypad, bits: 3,6,9,enter,x,x,x,x
console		equ	$1E8B	;start and select buttons on console

consolestart	equ	$40
consoleselect	equ	$80

keymask123	equ	$80	;top row of keys
keymask456	equ	$40
keymask789	equ	$20
keymaskc0e	equ	$10	;bottom row of keys



shape1		equ	$1f00
hc1		equ	$1f0a
hcd1		equ	$1f0b
vc1		equ	$1f0c
voff1		equ	$1f0d

shape2		equ	$1f10
hc2		equ	$1f1a
hcd2		equ	$1f1b
vc2		equ	$1f1c
voff2		equ	$1f1d

shape3		equ	$1f20
hc3		equ	$1f2a
hcd3		equ	$1f2b
vc3		equ	$1f2c
voff3		equ	$1f2d

shape4		equ	$1f40
hc4		equ	$1f4a
hcd4		equ	$1f4b
vc4		equ	$1f4c
voff4		equ	$1f4d

griddefinition	equ	$1F80

objectsize	equ	$1fc0
colours12	equ	$1fc1
colours34	equ	$1fc2
scoreformat	equ	$1fc3
backgnd		equ	$1fc6
;pitch		equ	$1fc7
score12		equ	$1fc8
score34		equ	$1fc9
ocomplete	equ	$1fca
collision	equ	$1fcb

;=============================================================================



reset_vector:
	bcta,un	reset
interrupt_vector:
	retc,un
reset:	
				;initialise program status word, just to be sure!
	ppsu	intinhibit	;inhibit interrupts
	cpsu	stackpointer	;stack pointer=0
	cpsl	registerselect	;register bank 0
 	cpsl	withcarry 	;without carry
	cpsl	compare		;arithmetic compare

	eorz	r0
	stra,r0	effects		;initialise the 74LS378
	
	bsta,un InitPVI		;initialise video chip

endless:
	bctr,un endless

;===================================================================
; subroutine - initialise PVI
InitPVI:
	eorz	r0		;r0 = 0
	lodi,r3	$CA		;set 1F00-1FC9 to 00 (most of PVI)
loop1:				;sets all colours to black, turns off sound, score 1 field at top.
	stra,r0	shape1,r3-
	brnr,r3	loop1

	lodi,r0 $02
	stra,r0 scoreformat	
	lodi,r0 $aa		;blank the score digits
	stra,r0 score12
	lodi,r0 $aa
	stra,r0 score34

	lodi,r0 $78		;screen black
	stra,r0 backgnd

	lodi,r0	%00000011
	stra,r0 colours12	; obj 1 white, 2 red
	lodi,r0	%00101001
	stra,r0 colours34	; obj 3 green, 4 yellow

	lodi,r0	%11100100
	stra,r0 objectsize

	lodi,r3 $0E
loopISe:			;load sprite shapes and coords
	loda,r0 one,r3-
	stra,r0 shape1,r3
	loda,r0 two,r3
	stra,r0 shape2,r3
	loda,r0 three,r3
	stra,r0 shape3,r3
	loda,r0 four,r3
	stra,r0 shape4,r3
	brnr,r3 loopISe	
	retc,un

	
one:			
	db	$08
	db	$18
	db	$08
	db	$08
	db	$08
	db	$08
	db	$08
	db	$08
	db	$1c
	db	$1c
	db	10	;hc
	db	10	;hcb
	db	20	;vc
	db	20	;voff
two:			
	db	$1c
	db	$3e
	db	$22
	db	$02
	db	$0e
	db	$18
	db	$30
	db	$20
	db	$3e
	db	$3e
	db	40	
	db	35	 
	db	60	
	db	10	
three:		
	db	$7c
	db	$7c
	db	$04
	db	$04
	db	$1c
	db	$1c
	db	$04
	db	$04
	db	$7c
	db	$7c
	db	60
	db	120	
	db	90
	db	250
four:			
	db	$40
	db	$40
	db	$40
	db	$40
	db	$48
	db	$7e
	db	$7e
	db	$08
	db	$08
	db	$08
	db	100
	db	110	
	db	0
	db	255	;
