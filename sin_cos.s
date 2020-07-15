#####################
# Sine and Cosine   #
#####################

.globl __start

.data
        S_evenR: .float 0,0,0,0
        S_evenI: .float 0,0,0,0
        S_oddR: .float 0,0,0,0
        S_oddI: .float 0,0,0,0
        k: .byte 0
        X_even: .float 1,2,3,4
.rodata
 	pi: .float 3.1415
        num05: .float 0.5
        fac1: .float 1
        fac2: .float 2
        fac3: .float 6
        fac4: .float 24
        fac5: .float 120
        fac6: .float 720
        fac7: .float 5040
        fac8: .float 40320
        fac9: .float 362880
        fac10: .float 3628800
        fac11: .float 39916800

.text

	
# *************** Calculates base^exp. ***************
# Inputs:	fa0: base, a0: exp
# Outputs:	fa1: base^exp
pow:
	addi	t0, x0, 1
	fcvt.s.w fa1, t0
	la	t0, pow_loop
	la	t1, pow_fim
	beqz	a0, pow_fim
	
pow_loop:
	fmul.s	fa1, fa1, fa0
	addi	a0, a0, -1 
	bnez	a0, pow_loop
	
pow_fim:
	ret

# *************** Calculates cos(arg) by using a truncated taylor series. ***************
# Inputs:	fa4: arg
# Outputs:	fa6: cos(arg)
cos:
        addi sp, sp, -4
        sw ra, 0(sp)
        
        fmv.s fa3, fa4
        la t2, fac1
        flw ft5, 0(t2)
        
        la t1, fac2 # Calculate arg^2/2!
        flw ft8, 0(t1)
        fmv.s fa0, fa3 
        li a0,2
        call pow
        fdiv.s fa2, fa1, ft8 
        fsub.s fa6, ft5, fa2 
        
        la t1, fac4 # Calculate arg^4/4!
        flw ft8, 0(t1)
        li a0,4
        call pow
        fdiv.s fa2, fa1, ft8 
        fadd.s fa6, fa6, fa2 
        
        la t1, fac6 # Calculate arg^6/6!
        flw ft8, 0(t1)
        li a0,6
        call pow
        fdiv.s fa2, fa1, ft8 
        fsub.s fa6, fa6, fa2
        
        la t1, fac8 # Calculate arg^8/8!
        flw ft8, 0(t1)
        li a0,8
        call pow
        fdiv.s fa2, fa1, ft8 
        fadd.s fa6, fa6, fa2 
        
        la t1, fac10 # Calculate arg^10/10!
        flw ft8, 0(t1)
        li a0,10
        call pow
        fdiv.s fa2, fa1, ft8 
        fsub.s fa6, fa6, fa2  
               
        lw ra, 0(sp)
        addi sp, sp, 4
	ret

# *************** Calculates sin(arg) by using a truncated taylor series. ***************
# Inputs:	fa4: arg
# Outputs:	fa5: sin(arg)
sin:
        addi sp, sp, -4
        sw ra, 0(sp)

        fmv.s fa3, fa4
        
        la t1, fac3 # Calculate arg^3/3!
        flw ft8, 0(t1)
        fmv.s fa0, fa3 
        li a0,3
        call pow
        fdiv.s fa2, fa1, ft8 
        fsub.s fa3, fa3, fa2 
        
        la t1, fac5 # Calculate arg^5/5!
        flw ft8, 0(t1)
        li a0,5
        call pow 
        fdiv.s fa2, fa1, ft8 
        fadd.s fa3, fa3, fa2
        
        la t1, fac7 # Calculate arg^7/7!
        flw ft8, 0(t1)
        li a0,7
        call pow 
        fdiv.s fa2, fa1, ft8 
        fsub.s fa3, fa3, fa2
        
        la t1, fac9 # Calculate arg^9/9!
        flw ft8, 0(t1)
        li a0,9
        call pow 
        fdiv.s fa2, fa1, ft8 
        fadd.s fa3, fa3, fa2
        
        la t1, fac11 # Calculate arg^11/11!
        flw ft8, 0(t1)
        li a0,11
        call pow 
        fdiv.s fa2, fa1, ft8 
        fsub.s fa3, fa3, fa2
        fmv.s fa5, fa3     
               
        lw ra, 0(sp)
        addi sp, sp, 4
	ret
# *************** Calculates argument for exponential. ***************
# Inputs:	a2: k
# Outputs:	fa4: arg
calc_arg:
        addi sp, sp, -4
        sw ra, 0(sp)

        fcvt.s.w ft0, a2 # ft0 = k
        li a3, 4
        fcvt.s.w ft1, a3 # ft1 = 4
        la t2, pi 
        flw ft2, 0(t2) # ft2 = pi
        
        li s0, 2 
        fcvt.s.w ft3, s0 # ft3 = n // Modificar para entrar no loop
        li s1, 8
        fcvt.s.w ft4, s1 # ft4 = N
        
        fmul.s fa4, ft0, ft1
        fmul.s fa4, fa4, ft2
        fmul.s fa4, fa4, ft3
        fdiv.s fa4, fa4, ft4
        
        call sin
        call cos
        
        lw ra, 0(sp)
        addi sp, sp, 4
        ret

# *************** Main function ***************	
__start:
        li      a2, 1 # a2 = k
        la      t0, pi
        call    calc_arg	
        
	li 	a0, 10	# ends the program with status code 0
	ecall
