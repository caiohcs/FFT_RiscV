.globl __start
.globl X
.globl sizeX
.globl sizeX_half
.globl X_odd
.globl temp
.globl k

.data
  sizeX: .zero 4
  sizeX_half: .zero 4
  X: .zero 20
  temp: .zero 100
  k: .zero 1
  X_odd: .float 0 # X_even will be defined as an offset of X_even


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
  la s9,X_odd
  lb a1,sizeX_half
  call Sum_Vector
  
  li a0, 10	# ends the program with status code 0
  ecall