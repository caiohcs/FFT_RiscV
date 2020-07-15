.globl __start

.data
  X: .zero 5
  temp: .zero 64

.rodata
  # open flags
  O_RDWR:  .word 0b0000100
  # pathname
  path: .string "example.txt"

.text

# Inputs: a0:  , a1: input buffer address
# Outputs:
Convert:
	addi sp, sp, -4		# Salva RA
	sw s1, 0(sp)
	li t0, ';'				# Indicador de fim de arquivo
	li t1, ' '
	li t2, '0'
	li t3, '9'
	li t4, 10
	
Convert_Loop:
	lbu a2, 0(a1)
	beq t0, a2, Convert_End		# Fim de arquivo
	beq	t1, a2, Convert_Loop	# Ignora espaço

	li a3, 0
Convert_number:
	sub a2, a2, t2		# ascii pra binario
	mul a3, a3, t4		# multiplica o resultado acumulado por 10
	add	a3, a3, a2		# acumula o resultado com o novo digito

	addi a1, a1, 1
	lbu a2, 0(a1)
	bltu a2, t2, Convert_Loop
	bgeu a2, t3, Convert_Loop
	jal x0, Convert_number

Convert_End:
	lw	s1, 0(sp)			# Restaura RA
	addi	sp, sp, 4
	ret
	
	
__start:
	li a0, 13			# Open File
	la a1, path		# pathname address
	lw a2, O_RDWR	# load O_RDWR open flag
	ecall
	
	Read:
	add a1,x0,a0	 # Pass File Descriptor to a1
	la a2,temp		 # Pass Buffer Address to a2
	li a3,100				# 1 bytes to read
	li a0,14			 # Read File
	ecall

	la a1,temp
	call Convert

	li 	a0, 10	# ends the program with status code 0
	ecall
