.psp
.open "exe\UCJS10014.BIN",0x8803F80

min_ascii:	equ 0x8240
max_ascii:	equ 0x82A0 ; +1 from what our actual table is
letter_table: equ 0x08B51914



.org 0x08868428
	j 0x08868490	; Forces it to always load scn files regardless if changed

.org 0x08891744
	nop		; Forces it to always load font files (maybe others?)

.org 0x0885E084
	j do_vwf	; This gets and stores the letter width for next time
	nop		; no touchy our letter id
	
.org 0x08820798
	j do_gallery_menu
	
.org 0x08820874
	j get_width_gallery_menu
	
.org 0x088207A8
	nop

.org 0x088207B0
	nop
	;nop
	;addiu s2,t0,0x64a0
	;nop
	;addiu a1,s2,0x2c
	;nop

.org 0x0881c1d4
	j turn_off_scene_menu_vwf
	
.org 0x0881c1ec
	j turn_on_scene_menu_vwf
	
.org 0x0881C244
	j turn_off_scene_menu_vwf2
	
.org 0x0881C25C
	j turn_on_scene_menu_vwf2


.org 0x08820F74
	j do_scene_menu
	nop
	
.org 0x08821034
	j get_width_scene_menu
	
.org 0x08820D04
	j do_ending
	nop
	
.org 0x08820DBC
	j get_width_ending
	
.org 0x08820D14
	nop
	
; .org 0x0885F184
	; ;addiu t1, r0, 0x05 
	; addiu t1, r0, 0x00 ; Set it so the sentence is NOT indented
	
.org 0x0885E394
	; lh t2, 0x136(a0)
 	li t2, 0x01 ; Force it to alwasy think its the "first" line so it doesnt indent it
	li t0, 0x00
	
.org 0x0885E0F4
	li a1, 0x7FF ; Overwrite sentence width comparison value so we can have them as long as we want :)

; .org 0x0885D788
	; j reset_cur_width
	; lbu s0, 0x0(t0)
	
.org 0x8989540
turn_off_scene_menu_vwf:
	la t0, vwfOff
	li t1, 1
	sb t1, 0(t0)
	jal 0x0881c1dc
	li t0, 0x4
	
	j 0x0881C1E8
	nop
	
turn_on_scene_menu_vwf:
	la t0, vwfOff
	sb zero, 0(t0)
	j 0x0881c1f4
	li t0, 0x4
	
turn_off_scene_menu_vwf2:
	la t0, vwfOff
	li t1, 1
	sb t1, 0(t0)
	j 0x0881C24C
	lw a0, 0(t9)
	
turn_on_scene_menu_vwf2:
	la t0, vwfOff
	sb zero, 0(t0)
	li t0, 0x4	
	j 0x0881C264
	slti t7, s2, 0x07
		


.org 0x8989200
; ---------------------- VWF CODE ----------------
do_vwf:

;	sw r0, 0x10(v1)		; previous instruction
;
;	la a3, vwf_width_addr   ; setup width address
;	nop
;
;	lb v0, 4(a3)		; see if vwf is enabled...
;	beq v0, r0, done_fwf	; if not... don't bother to do anything
;
;	lw v0, 0(a3)		; load prev width
;	bne r0, v0, no_reset	; compare prev width to zero
;	nop
;	addu v0, r0, a0		; reset width to current width...
;	sw v0, 0(a3)
;no_reset:
;	addu a0, r0, v0


;	Start calculating what the width is....
;	s1 - current letter, hopefully stays that way

	;lh t4, 0x11A(s2)	; Go ahead and get the previous width ; TEST TEST TEST
	la t0, letter_widths	; Load up address for width table

	addiu a0, r0, max_ascii
	andi a0, a0, 0x0000FFFF
	sltu a0, s1, a0	; see if were in range of eng table...
	beq zero, a0, not_eng_vwf

	addiu a0, r0, min_ascii
	andi a0, a0, 0x0000FFFF
	sltu a0, s1, a0
	bne zero, a0, not_eng_vwf

	addi a0, s1, -0x8240	; Magic #, should be first letter we use...
	andi a0, a0, 0x00FF
	addu t0, a0, t0
	lbu a0, 0(t0)
	b done_vwf
	nop
not_eng_vwf:
	addiu a0, r0, 0x10	; Poor not ascii...
done_vwf:
	srl s1, v0, 0x10	; Go ahead and execute what we clobbered
	addu t4, r0, a0	; TEST TEST TEST
	j 0x0885E08C
	sb a0, 0x11A(s2)
;done_fwf:
;	j 0x088A2F08
;	nop

do_ending:
	addu v1, r0, a0
	slti t0, v1, 0xA0
	bne t0, r0, not_one_byte_ending
	lbu	t0,0x0(a3) ; just in case...
	addiu a2, r0, 0xA0
	la t0, letter_table
	subu v1, v1, a2
	sll v1, 1
	addu v1, v1, t0
	lbu t0, 1(v1)
	lbu v1, 0(v1)
	sll	a2,v1,0x8
	addu s1,a3,r0
	b get_letter_width_ending
	;j 0x08820F80
	or a3,a2,t0
not_one_byte_ending:
	sll	a2,v1,0x8
	addiu s1,a3,0x1
	;j 0x08820F80
	or a3,a2,t0
get_letter_width_ending:
	;----- Get letter width... we'se gonna be lazy and just copy the code....
	la t6, letter_widths	; Load up address for width table

	addiu a1, r0, max_ascii
	andi a1, a1, 0x0000FFFF
	sltu a1, a3, a1	; see if were in range of eng table...
	beq zero, a1, not_eng_ending

	addiu a1, r0, min_ascii
	andi a1, a1, 0x0000FFFF
	sltu a1, a3, a1
	bne zero, a1, not_eng_ending

	addi a1, a3, -0x8240	; Magic #, should be first letter we use...
	andi a1, a1, 0x00FF
	addu t6, a1, t6
	lbu a1, 0(t6)
	b done_ending
	nop
not_eng_ending:
	addiu a1, r0, 0x10	; Poor not ascii...
done_ending:
	la t6, cur_letter_width
	j 0x08820D10
	sb a1, 0(t6)
	
get_width_ending:
	la v1, cur_letter_width
	lb v1, 0(v1)
	j 0x08820DC4
	addu s2, s2, v1



do_gallery_menu:
	addu v1, r0, a0
	slti t0, v1, 0xA0
	bne t0, r0, not_one_byte_gallery_menu
	lbu	t0,0x0(s0) ; just in case...
	addiu a2, r0, 0xA0
	la t0, letter_table
	subu v1, v1, a2
	sll v1, 1
	addu v1, v1, t0
	lbu t0, 1(v1)
	lbu v1, 0(v1)
	sll	a2,v1,0x8
	addu s1,s0,r0
	b get_letter_width_gallery_menu
	or a3,a2,t0
not_one_byte_gallery_menu:
	sll	a2,v1,0x8
	addiu s1,s0,0x1
	;j 0x08820F80
	or a3,a2,t0
get_letter_width_gallery_menu:
	;----- Get letter width... we'se gonna be lazy and just copy the code....
	la t6, letter_widths	; Load up address for width table

	addiu a1, r0, max_ascii
	andi a1, a1, 0x0000FFFF
	sltu a1, a3, a1	; see if were in range of eng table...
	beq zero, a1, not_eng_gallery_menu

	addiu a1, r0, min_ascii
	andi a1, a1, 0x0000FFFF
	sltu a1, a3, a1
	bne zero, a1, not_eng_gallery_menu

	addi a1, a3, -0x8240	; Magic #, should be first letter we use...
	andi a1, a1, 0x00FF
	addu t6, a1, t6
	lbu a1, 0(t6)
	b done_gallery_menu
	nop
not_eng_gallery_menu:
	addiu a1, r0, 0x10	; Poor not ascii...
done_gallery_menu:
	la t6, cur_letter_width
	sb a1, 0(t6)
	j 0x088207A4
	lui	t0,0x8B5
	
get_width_gallery_menu:
	la v1, cur_letter_width
	lb v1, 0(v1)
	j 0x0882087C
	addu s4, s4, v1

;   ---- Original Replay Scenes Menu Code ----
;	lbu	v1,0x0(s2)
;	beq	v1,zero,pos_08821108
;	addiu	t5,s2,0x1
;	lbu	t0,0x0(t5)
;	sll	a2,v1,0x8
;	addiu	s2,t5,0x1
;	or	a3,a2,t0
do_scene_menu:
	slti t0, v1, 0xA0
	bne t0, r0, not_one_byte_menu
	lbu	t0,0x0(t5) ; just in case...
	addiu a2, r0, 0xA0
	la t0, letter_table
	subu v1, v1, a2
	sll v1, 1
	addu v1, v1, t0
	lbu t0, 1(v1)
	lbu v1, 0(v1)
	sll	a2,v1,0x8
	addu s2,t5,r0
	b get_letter_width_menu
	;j 0x08820F80
	or a3,a2,t0
not_one_byte_menu:
	sll	a2,v1,0x8
	addiu s2,t5,0x1
	;j 0x08820F80
	or a3,a2,t0
get_letter_width_menu:
	la t6, vwfOff
	lbu t6, 0(t6)
	nop
	bne zero, t6, not_eng_menu
	nop
	
	;----- Get letter width... we'se gonna be lazy and just copy the code....
	la t6, letter_widths	; Load up address for width table

	addiu a1, r0, max_ascii
	andi a1, a1, 0x0000FFFF
	sltu a1, a3, a1	; see if were in range of eng table...
	beq zero, a1, not_eng_menu

	addiu a1, r0, min_ascii
	andi a1, a1, 0x0000FFFF
	sltu a1, a3, a1
	bne zero, a1, not_eng_menu

	addi a1, a3, -0x8240	; Magic #, should be first letter we use...
	andi a1, a1, 0x00FF
	addu t6, a1, t6
	lbu a1, 0(t6)
	b done_menu
	nop
not_eng_menu:
	addiu a1, r0, 0x14	; Poor not ascii...
done_menu:
	la t6, cur_letter_width
	;sb r0, 1(t6)
	j 0x08820F84
	sb a1, 0(t6)
;done_fwf:
;	j 0x088A2F08
;	nop

get_width_scene_menu:
	la v1, cur_letter_width
	lb v1, 0(v1)
	j 0x0882103C
	addu s3, s3, v1
	
reset_cur_width:
	la t3, cur_letter_width
	addiu t0, t0, 0x01
	bne zero, s0, not_zero
	li t2, 0x24
	sb r0, 0(t3)
not_zero:
	bne t2, s0, not_newline
	nop
	sb r0, 0(t3)
not_newline:
	j 0x0885D794
	nop

cur_letter_width:
	.db 00
vwfOff:
	.db 00
letter_widths:	 ; Starts at 8240. Hopefully works ingame?
	.db 10 ;<
	.db 10 ;"
	.db 12 ;#
	.db 12 ;$
	.db 17 ;%
	.db 13 ;&
	.db 10 ;>
	.db 7  ;(
	.db 7  ;)
	.db 12 ;*
	.db 14 ;+
	.db 17 ;@
	.db 14 ;-
	.db 14 ;=
	.db 18 ;/
	.db 11 ;0
	.db 7  ;1
	.db 12 ;2
	.db 12 ;3
	.db 13 ;4
	.db 12 ;5
	.db 12 ;6
	.db 12 ;7
	.db 12 ;8
	.db 12 ;9
	.db 6  ;:
	.db 7  ;;
	.db 6  ;!
	.db 5  ;'
	.db 12 ;?
	.db 7  ;,
	.db 7  ;.
	.db 15 ;A
	.db 12 ;B
	.db 13 ;C
	.db 13 ;D
	.db 11 ;E
	.db 11 ;F
	.db 14 ;G
	.db 13 ;H
	.db 5  ;I
	.db 12 ;J
	.db 13 ;K
	.db 12 ;L
	.db 16 ;M
	.db 13 ;N
	.db 14 ;O
	.db 12 ;P
	.db 14 ;Q
	.db 13 ;R
	.db 12 ;S
	.db 13 ;T
	.db 13 ;U
	.db 15 ;V
	.db 17 ;W
	.db 13 ;X
	.db 13 ;Y
	.db 12 ;Z
	.db 4  ;[
	.db 10 ;\
	.db 4  ;]
	.db 6  ;(space)
	.db 10 ;_
	.db 6  ;`
	.db 16 ;UNK
	.db 11 ;a
	.db 11 ;b
	.db 10 ;c
	.db 11 ;d
	.db 11 ;e
	.db 9  ;f
	.db 11 ;g
	.db 9  ;h
	.db 5  ;i
	.db 8  ;j
	.db 11 ;k
	.db 5  ;l
	.db 15 ;m
	.db 11 ;n
	.db 12 ;o
	.db 11 ;p
	.db 11 ;q
	.db 8  ;r
	.db 10 ;s
	.db 9  ;t
	.db 11 ;u
	.db 11 ;v
	.db 15 ;w
	.db 11 ;x
	.db 11 ;y
	.db 10 ;z
	.db 8  ;{
	.db 6  ;|
	.db 8  ;}
	.db 18 ;~
	.db 6  ; 
	.db 0  ; nothing
	.db 0  ; clear_vwf
	.db 0  ; set_vwf


	

.close