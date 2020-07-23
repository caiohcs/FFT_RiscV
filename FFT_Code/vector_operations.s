.globl Sum_Vector
.globl Complex_Mul
.globl FFT

.text

Sum_Vector:
# Inputs:	s9: Vector, a1: Vector Size, a2: k
# Outputs:	fs1,fs2: Sum of Vector

addi sp, sp, -4
sw ra, 0(sp)
li s3,0 # n
Sum_Vector_Loop:
beq a1,s3, Sum_Vector_Return

flw fs3, 0(s9)
call calc_argWN_2km

fmul.s fa1, fs3, fa6 # Real Part
fmul.s fa2, fs3, fa5 # Imag Part

fadd.s fs1,fs1,fa1 # Real part
fadd.s fs2,fs2,fa2 # Imag part

addi s9,s9,4
addi s3,s3,1
jal x0, Sum_Vector_Loop

Sum_Vector_Return:
lw ra, 0(sp)
addi sp, sp, 4
ret


Complex_Mul:
# Inputs:	fs1,fs2: Real and Imag, a2: k
# Outputs:	fs1,fs2: Sum of Vector

addi sp, sp, -4
sw ra, 0(sp)

call calc_argWNk
fmul.s fs7,fa6,fs1
fmul.s fs8,fa5,fs2
fsub.s fs10,fs7,fs8 # Real Part

fmul.s fs7,fa6,fs2
fmul.s fs8,fa5,fs1
fadd.s fs11,fs7,fs8 # Imag Part

lw ra, 0(sp)
addi sp, sp, 4
ret


FFT:
  addi sp, sp, -4
  sw ra, 0(sp)

  la s9,X_even
  lw a1,sizeX_half
  slli a2,a1,2 # (32 * X_half_Size)/8 = 2^(2) * Half_Size
  mv s10, a2 # FIX 1
  add s9,s9,a2 # Offset X_even to get X_odd
  lw a2,sizeX
  addi a2,a2,-1 #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  
  S2:
  la s5, X_result
  S2_Loop:
  blt a2,x0, S1
  call Sum_Vector
  call Complex_Mul
  fsw fs10,0(s5)
  fsw fs11,4(s5)
  addi s5,s5,8  
  addi a2,a2,-1
  la s9,X_even # FIX 1
  add s9,s9,s10 # FIX 1
  fcvt.s.w fs1,x0 # FIX 2
  fcvt.s.w fs2,x0 # FIX 2
  jal x0, S2_Loop
  
  S1:
  la s9,X_even
  la s5, X_result
  lb a1,sizeX_half
  lw a2,sizeX
  addi a2,a2,-1
  S1_Loop:
  blt a2,x0, Return
  call Sum_Vector
  flw ft10,0(s5)
  flw ft11,4(s5)
  fadd.s fs1,fs1,ft10 # Real Part
  fadd.s fs2,fs2,ft11 # Imag Part
  fsw fs1,0(s5)
  fsw fs2,4(s5)
  addi s5,s5,8  
  addi a2,a2,-1
  la s9,X_even # FIX 1
  fcvt.s.w fs1,x0 # FIX 2
  fcvt.s.w fs2,x0 # FIX 2
  jal x0, S1_Loop
  
  Return:
  lw ra, 0(sp)
  addi sp, sp, 4
  ret