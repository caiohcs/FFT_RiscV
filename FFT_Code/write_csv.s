.globl __start

.data
	Xa:	.float -0.723
	Xb:	.float -125.622
	Xc:	.float -312.1415
	X3:	.float 100
	X:	.zero 100
	

.rodata
	O_RDWR:	.word 0b0110100		# open flags
	path:	.string "exit.txt"	# pathname
.text

# Inputs: a0: address of float vector, a1: output buffer address, a2: number of elements
# Outputs: a0: number of characters in the output text 
Float2Str:
	addi	sp, sp, -4		# Salva RA
	sw	s1, 0(sp)		# Salva RA

	add	a3, a1, x0		# t7 = beginning of output buffer
	li	t2, 10000		
	fcvt.s.w ft2, t2		# ft2 = 10000
	li	t2, 10			# t2 = 10
	fcvt.s.w ft0, x0		# ft0 = 0
	flw	ft1, 0(a0)
	
Float2Str_outerLoop:
	li	t5, 1			# t5 = 1 if processing integer part, t5 = 0 if decimal part
Float2Str_decimal:
	flt.s	t6, ft1, ft0		# t6 = 1 if the float is negative
	beq	t6, x0, Float2Str_Not	# Jump next instructions if it's positive
	
	li	t1, -1
	fcvt.s.w ft4, t1		# ft4 = -1
	fmul.s	ft1, ft1, ft4		# make the decimal part positive

	li	t3, '-'			# store '-'
	sb	t3, 0(a1)		# store '-'
	addi	a1, a1, 1		# store '-'
	
Float2Str_Not:
	fcvt.w.s t0, ft1		# t0 = round the float (don't know yet if it was up or down)
	fcvt.s.w ft3, t0		# ft3 = round the float (don't know yet if it was up or down)
	flt.s	t6, ft1, ft3		# t6 = 1 if the float was rounded up
	
	beq	t6, x0, Float2Str_wasRoundedDown
	addi	t0, t0, -1		# integer part -= 1 if it was rounded up
	fcvt.s.w ft3, t0		# ft3 = integer part
	
Float2Str_wasRoundedDown:	
	li	t1, -1
	fcvt.s.w ft4, t1
	fmul.s	ft3, ft3, ft4		# integer part * -1
	fadd.s	ft1, ft1, ft3		# ft1 = decimal part
	
	li	t4, 0			# t4 will hold the number of digits

	
Float2Str_pos:
	rem	t3, t0, t2		# t3 = current digit
	div	t0, t0, t2		# t0 = remaining digits
	addi	t4, t4, 1
	addi	t3, t3, '0'
	addi	sp, sp, -1		# push current digit in the stack
	sb	t3, 0(sp)		# push current digit in the stack
	bne	t0, x0, Float2Str_pos	# Loop while there are remaining digits

Float2Str_store:
	lb	t0, 0(sp)		# pop current digit from stack
	addi	sp, sp, 1		# pop current digit from stack
	sb	t0, 0(a1)		# store current digit
	addi	a1, a1, 1		# output buff addr += 1
	addi	t4, t4, -1		# counter -= 1x
	bne	t4, x0, Float2Str_store

	beq	t5, x0, Float2Str_next	# if t5 = 0, jump to next
	
	li	t3, '.'			# store '.'
	sb	t3, 0(a1)		# store '.'
	addi	a1, a1, 1		# store '.'

	fmul.s	ft1, ft1, ft2		# decimal part *= 10000
	fcvt.w.s t0, ft1		# t0 = decimal part
	add	t5, x0, x0		# t5 = 0 indicating that it will process the decimals
	jal	x0, Float2Str_pos	# go process the decimals

Float2Str_next:
	li	t3, ' '			# store ' '
	sb	t3, 0(a1)		# store ' '
	addi	a1, a1, 1		# store ' '
	addi	a2, a2, -1		# store ' '
	beq	a2, x0, Float2Str_end	# if counter=0 jump to end
	addi	a0, a0, 4		# next float addr += 4
	flw	ft1, 0(a0)		# loads next float
	jal	x0, Float2Str_outerLoop


Float2Str_end:
	sub	a0, a1, a3		# a0 = end of buffer - beginning of buf = text size
	
	lw	s1, 0(sp)		# Restaura RA
	addi	sp, sp, 4		# Restaura RA
	ret
	
	
__start:
	li	a0, 13			# Open File
	la	a1, path		# pathname address
	lw	a2, O_RDWR		# load O_RDWR open flag
	ecall
	add	s0, a0, x0
	
	la	a0, Xa
	la	a1, X
	li	a2, 4
	call	Float2Str

	add	a3, a0, x0		# a3 = size of text

	li	a0, 15			# write
	add	a1, s0, x0		# file descriptor
	la	a2, X
	ecall
	
	li	a0, 10			# ends the program with status code 0
	ecall
