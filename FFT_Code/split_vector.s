.globl SplitArrays

.rodata
  Error_Size: .string "Vector Size is not a power of two!"
  
.text
SplitArrays:
  CheckSize:
  lb a2,sizeX
  mv s4,a2
  li a3,1
  sub a3,a2,a3
  and a3,a2,a3
  beq a3,x0,Split
  li a0, 4 
  la a1,Error_Size # Print Error Msg
  ecall
  li a0, 10	# ends the program with status code 0
  ecall
  
  Split:
  la a1, X
  la a2, X_odd
  lb a5, sizeX
  srli a6,a5,1 # sizeX_half
  la t0, sizeX_half # Get sizeX_half address
  sb a6, 0(t0) # Store sizeX_half
  slli a6,a6,2 # (32 * X_half_Size)/8 = 2^(2) * Half_Size
  add a3,a2,a6 # Offset to X_even
  addi a5,a5,1 # Array Size + 1 to Compare
  li a7, 2 # Position Flag
  Split_Loop:
  bge a7,a5,Return
  flw f1,0(a1)
  flw f2,4(a1)
  fsw f1,0(a2)
  fsw f2,0(a3)
  addi a1,a1,8 # Jump Two Positions (32*2)/8
  addi a2,a2,4 # Jump One Position (32*1)/8
  addi a3,a3,4 # Jump One Position (32*1)/8
  addi a7,a7,2
  jal x0,Split_Loop
  
  Return:
  ret
  
  