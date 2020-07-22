.globl __start
.globl X
.globl sizeX
.globl sizeX_half
.globl X_even
.globl temp
.globl k

.data
  sizeX: .zero 4
  sizeX_half: .zero 4
  X: .zero 20
  temp: .zero 100
  k: .zero 1
  X_even: .float 0 # X_odd will be defined as an offset of X_even


.text

__start:
  call Read_CSV
  
  la a0, X			# X address Convert arg
  la a1, temp			# temp address Convert arg
  call Convert			# convert the string to a vector of floats
  la a1, sizeX
  sw a0, 0(a1)			# store num elements at sizeX
  
  call SplitArrays
  
  li a6,0
  la a7,k
  sb a6,0(a7)
  la s9,X_even
  lb a1,sizeX_half
  slli a2,a1,2 # (32 * X_half_Size)/8 = 2^(2) * Half_Size
  add s9,s9,a2 # Offset X_even to get X_odd
  call Sum_Vector
  
  fmv.s ft9,fs1
  fmv.s ft10,fs2
  call Complex_Mul
  
  li a0, 10	# ends the program with status code 0
  ecall