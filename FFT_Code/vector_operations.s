.globl Sum_Vector

.text

Sum_Vector:
# Inputs:	a0: Vector, a1: Vector Size
# Outputs:	fs1,fs2: Sum of Vector

addi sp, sp, -4
sw ra, 0(sp)
li s3,0
li a2,0
Sum_Vector_Loop:

beq a1,s3, Return

flw fs3, 0(s9)
call calc_argWN_2km

fmul.s fa1, fs3, fa6 # Real Part
fmul.s fa2, fs3, fa5 # Imag Part

fadd.s fs1,fs1,fa1
fadd.s fs2,fs1,fa2

addi s9,s9,4
addi s3,s3,1
jal x0, Sum_Vector_Loop

Return:
lw ra, 0(sp)
addi sp, sp, 4
ret