#####################
# Sine and Cosine   #
#####################

.globl __start

.rodata
 	pi_6: .float 0.5236
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
        
        X: .float 1,2,3,4,5,6,7,8
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
# Inputs:	t0: arg
# Outputs:	fa3: cos(arg)
cos:
        addi sp, sp, -4
        sw ra, 0(sp)
        
        la t2, fac1
        flw fa3, 0(t2)
        
        la t1, fac2 # Calculate arg^2/2!
        flw ft8, 0(t1)
        flw fa0, 0(t0) 
        li a0,2
        call pow
        fdiv.s fa2, fa1, ft8 
        fsub.s fa3, fa3, fa2 
        
        la t1, fac4 # Calculate arg^4/4!
        flw ft8, 0(t1)
        li a0,4
        call pow 
        fdiv.s fa2, fa1, ft8 
        fadd.s fa3, fa3, fa2
        
        la t1, fac6 # Calculate arg^6/6!
        flw ft8, 0(t1)
        li a0,6
        call pow 
        fdiv.s fa2, fa1, ft8 
        fsub.s fa3, fa3, fa2
        
        la t1, fac8 # Calculate arg^8/8!
        flw ft8, 0(t1)
        li a0,8
        call pow 
        fdiv.s fa2, fa1, ft8 
        fadd.s fa3, fa3, fa2
        
        la t1, fac10 # Calculate arg^8/8!
        flw ft8, 0(t1)
        li a0,10
        call pow 
        fdiv.s fa2, fa1, ft8 
        fsub.s fa3, fa3, fa2     
               
        lw ra, 0(sp)
        addi sp, sp, 4
	ret

# *************** Calculates sin(arg) by using a truncated taylor series. ***************
# Inputs:	t0: arg
# Outputs:	fa3: sin(arg)
sin:
        addi sp, sp, -4
        sw ra, 0(sp)

        flw fa3, 0(t0)
        
        la t1, fac3 # Calculate arg^2/2!
        flw ft8, 0(t1)
        flw fa0, 0(t0) 
        li a0,3
        call pow
        fdiv.s fa2, fa1, ft8 
        fsub.s fa3, fa3, fa2 
        
        la t1, fac5 # Calculate arg^4/4!
        flw ft8, 0(t1)
        li a0,5
        call pow 
        fdiv.s fa2, fa1, ft8 
        fadd.s fa3, fa3, fa2
        
        la t1, fac7 # Calculate arg^6/6!
        flw ft8, 0(t1)
        li a0,7
        call pow 
        fdiv.s fa2, fa1, ft8 
        fsub.s fa3, fa3, fa2
        
        la t1, fac9 # Calculate arg^8/8!
        flw ft8, 0(t1)
        li a0,9
        call pow 
        fdiv.s fa2, fa1, ft8 
        fadd.s fa3, fa3, fa2
        
        la t1, fac11 # Calculate arg^8/8!
        flw ft8, 0(t1)
        li a0,11
        call pow 
        fdiv.s fa2, fa1, ft8 
        fsub.s fa3, fa3, fa2     
               
        lw ra, 0(sp)
        addi sp, sp, 4
	ret

# *************** Main function ***************	
__start:
        la	t0, pi_6
	call 	cos	
        
	li 	a0, 10	# ends the program with status code 0
	ecall
