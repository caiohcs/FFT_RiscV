.globl __start

.data
  sizeX: .zero 4
  X: .zero 20
  temp: .zero 100

.rodata
  # open flags
  O_RDWR:  .word 0b0000100
  # pathname
  path: .string "example.txt"

.text

# Inputs: a0: address of float vector  , a1: input buffer address
# Outputs: a0: number of elements converted
Convert:
	addi sp, sp, -4			# Salva RA
	sw s1, 0(sp)			# Salva RA
	add a6, a0, x0			# Salva a posicao inicial do vetor em a5
	li t0, 59			# Indicador de fim de arquivo = ;
	li t1, ' '
	li t2, '0'
	li t3, '9'
	li t4, 10
	li t5, '.'
	li t6, ','
	li a7, -1
	fcvt.s.w ft2, a7		# ft2 = -1
	li a7, '-'
	
	
Convert_loop:
	lbu a2, 0(a1)
	beq t0, a2, Convert_End		# Fim de arquivo
	beq t1, a2, Convert_ignore	# Ignora espaço
	beq t6, a2, Convert_ignore	# Ignora virgula
	beq a7, a2, Convert_negative	# Começa a converter se o numero for negativo
	li a7, 0			# Se positivo, a7 = 0
	jal x0, Convert_start		# Começa a converter se o numero for positivo
	
Convert_ignore:
	addi a1, a1, 1			# Incrementa o indice
	jal x0, Convert_loop

Convert_negative:
	addi a1, a1, 1
	lbu a2, 0(a1)
	li a7, -1			# Se negativo, a7 = -1
	jal x0, Convert_start

Convert_start:
	li a3, 0			# zera a parte inteira
	li a4, 0			# zera a parte decimal do float
Convert_integer_loop:
	sub a2, a2, t2			# ascii pra binario
	mul a3, a3, t4			# multiplica o resultado acumulado por 10
	add a3, a3, a2			# acumula o resultado com o novo digito

	addi a1, a1, 1
	lbu a2, 0(a1)
	beq a2, t5, Convert_decimal	# O numero tem parte decimal
	bltu a2, t2, Convert_float	# O numero nao tem parte decimal
	bgeu a2, t3, Convert_float	# O numero nao tem parte decimal
	jal x0, Convert_integer_loop	# O numero ainda nao foi completamente lido

Convert_decimal:
	li a5, 1			# Potencia de 10 que vai dividir a parte decimal
	addi a1, a1, 1			# Pula o ponto '.'
	lbu a2, 0(a1)			# Pega o primeiro caractere
Convert_decimal_loop:
	sub a2, a2, t2			# ascii pra binario
	mul a4, a4, t4			# multiplica o resultado acumulado por 10
	add a4, a4, a2			# acumula o resultado com o novo digito
	mul a5, a5, t4			# Multiplica a potencia de 10 por 10
	
	addi a1, a1, 1
	lbu a2, 0(a1)
	bltu a2, t2, Convert_float
	bgeu a2, t3, Convert_float
	jal x0, Convert_decimal_loop

Convert_float:
	fcvt.s.w ft0, a4		# converte a parte decimal pra float
	fcvt.s.w ft1, a5		# converte a potencia que vai divir a parte decimal pra float	
	fdiv.s ft0, ft0, ft1
	fcvt.s.w ft1, a3		# converte a parte inteira pra float
	fadd.s ft0, ft0, ft1		# soma parte inteira e decimal
	beq a7, x0, Convert_float_store # a7 = 0 se o numero for positivo
Convert_mul_minues1:			# caso o numero seja negativo
	fmul.s ft0, ft0, ft2		# Multiplica por -1 se for negativo
Convert_float_store:
	fsw ft0, 0(a0)
	addi a0, a0, 4
	li a7, '-'
	jal x0, Convert_loop


Convert_End:
	sub a0, a0, a6			# Calcula o numero de elementos
	li a6, 4			# Calcula o numero de elementos
	div a0, a0, a6			# a0 = numero de elementos
	
	lw s1, 0(sp)			# Restaura RA
	addi sp, sp, 4
	ret
	
	
__start:
	li a0, 13			# Open File
	la a1, path			# pathname address
	lw a2, O_RDWR			# load O_RDWR open flag
	ecall
	
	Read:
	add a1,x0,a0			# Pass File Descriptor to a1
	la a2,temp			# Pass Buffer Address to a2
	li a3,100			# 1 bytes to read
	li a0,14			# Read File
	ecall
	
	la a0, X			# X address Convert arg
	la a1, temp			# temp address Convert arg
	call Convert			# convert the string to a vector of floats
	la a1, sizeX
	sw a0, 0(a1)			# store num elements at sizeX
	la a1, X
	flw fs0, 0(a1)			# fs0 = X[0]
	addi a1, a1, 4
	flw fs1, 0(a1)			# fs1 = X[1]
	addi a1, a1, 4
	flw fs2, 0(a1)			# fs2 = X[2]
	addi a1, a1, 4
	flw fs3, 0(a1)			# fs2 = X[2]
	

	li a0, 10			# ends the program with status code 0
	ecall
