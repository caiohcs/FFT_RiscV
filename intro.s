.globl __start

.rodata
  Error_Size: .string "Vector Size is not a power of two!"

.data

  X: .float 1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0
  X_size: .byte 8
  
  X_even: .zero 16 # 5 Positions (32*4)/8
  X_odd: .zero 16 # 5 Positions (32*4)/8
  
.text
  
CheckSize:
  lb a2,X_size
  li a3,1
  sub a3,a2,a3
  and a3,a2,a3
  beq a3,x0,SplitArrays
  li a0, 4 
  la a1,Error_Size # Print Error Msg
  ecall
  ebreak 
  
SplitArrays:
  la a1, X
  la a2, X_odd
  la a3, X_even
  lb a6, X_size
  addi a6,a6,1 # Array Size + 1 to Compare
  li a7, 2 # Position Flag
  SplitArrays_Loop:
  bge a7,a6,Return
  flw f1,0(a1)
  flw f2,4(a1)
  fsw f1,0(a2)
  fsw f2,0(a3)
  addi a1,a1,8 # Jump Two Positions (32*2)/8
  addi a2,a2,4 # Jump One Position (32*1)/8
  addi a3,a3,4 # Jump One Position (32*1)/8
  addi a7,a7,2
  jal x0,SplitArrays_Loop
  
  Return:
  jalr x0, 0(x1)

__start:
  jal x1, CheckSize
  ebreak
  
  