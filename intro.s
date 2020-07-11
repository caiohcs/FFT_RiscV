.globl __start

.data

  X: .byte 1,2,3,4,5,6,7,8,'$'
  X_even: .zero 5
  X_odd:
  
.rodata
  Error_Size: .string "Vector Size is not a power of two!" 
  
.text

CheckSize:
  la a1,X
  li a2,1
  li a3,36 # Dollar Sign to Compare
  CheckSize_Loop:
  lb a4,0(a1)
  beq a4,a3, CheckSize_Result  # Compate to Dollar Sign
  addi a1,a1,1
  addi a2,a2,1
  jal x0,CheckSize_Loop
  
  CheckSize_Result:
  li a3,1
  sub a2,a2,a3 # Subtract Dollar Sign from Size
  sub a3,a2,a3
  and a3,a2,a3
  beq a3,x0,SplitArrays
  li a0, 4 
  la a1,Error_Size # Print Error Msg
  ecall
  ebreak 
  
SplitArrays:
  la a1,X
  la a2, X_odd
  la a3,X_even
  li a6,36 # Dollar Sign to Compare
  SplitArrays_Loop:
  lb a4,0(a1)
  lb a5,1(a1)
  beq a4,a6,Return
  beq a5,a6,Return # Compare to Dollar Sign
  sb a4,0(a2)
  sb a5,0(a3)
  addi a1,a1,2
  addi a2,a2,1
  addi a3,a3,1
  jal x0,SplitArrays_Loop
  
  Return:
  jalr x0, 0(x1)

__start:
  jal x1, CheckSize
  ebreak
  
  