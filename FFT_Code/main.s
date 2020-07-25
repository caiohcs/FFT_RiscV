.globl __start
.globl X
.globl sizeX
.globl sizeX_half
.globl X_even
.globl temp
.globl X_result
.globl textBuffer

.data
  sizeX: .zero 4
  sizeX_half: .zero 4
  X: .zero 20
  temp: .zero 100
  X_even: .float 0 # X_odd will be defined as an offset of X_even
  space: .zero 100 # Space between Variables
  textBuffer:	.zero 100
  X_result: .float 0


.text

__start:
  call Read_CSV
  
  la a0, X			# X address Convert arg
  la a1, temp			# temp address Convert arg
  call Convert			# convert the string to a vector of floats
  la a1, sizeX
  sw a0, 0(a1)			# store num elements at sizeX
  
  call SplitArrays
  
  call FFT
  
  call Write2File
  
  li a0, 10	# ends the program with status code 0
  ecall