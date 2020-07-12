#####################
# Sine and Cosine   #
#####################

.globl __start

.rodata
 	pi: .float 3.1415
 	num05: .float 0.5
.text

	
# *************** Calculates factorial(arg) i.e. arg!. ***************
# Inputs:	a0: arg
# Outputs:	a1: arg!
fact:
	addi	a1, x0, 1
	la	t0, fact_loop
	la	t1, fact_fim
	beqz	a0, fact_fim
	
fact_loop:
	mul	a1, a1, a0
	addi	a0, a0, -1 
	bnez	a0, fact_loop
	
fact_fim:	
	ret

	
# *************** Calculates base^exp. ***************
# Inputs:	fa0: base, a0: exp
# Outputs:	fa1: base^exp
pow:
	addi	t0, x0, 1
	fcvt.s.w fa1, t0
	la	t0, pow_loop
	la	t1, pow_fim
	beqz	a0, pow_fim
	
pow_loop:
	fmul.s	fa1, fa1, fa0
	addi	a0, a0, -1 
	bnez	a0, pow_loop
	
pow_fim:
	ret

# *************** Calculates cos(arg) using taylor series. ***************
# Inputs:	f01: arg, a0: number of terms of series to use
# Outputs:	fa1: cos(arg)
cos:
	# Essa funçao ainda nao foi implementada.

	# O codigo abaixo em comentarios mostra como salvar valores na pilha.
	#	addi	sp, sp, -4
	#	sw	s1, 0(sp)
	# O codigo abaixo em comentarios mostra como restaurar valores na pilha.
	#	lw	s1, 0(sp)
	#	addi	sp, sp, 4
	ret

# *************** Main function ***************	
__start:
	la	t0, pi
	flw 	fa0, 0(t0)
	li 	a0, 3
	call 	pow	# pi^3

	
	li 	a0, 10	# ends the program with status code 0
	ecall
