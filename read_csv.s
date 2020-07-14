.globl __start

.data
  X: .zero 5
  temp: .zero 64

.rodata
  # open flags
  O_RDWR:  .word 0b0000100
  # pathname
  path: .string "example.txt"

.text

  __start:
  li a0, 13      # Open File
  la a1, path    # pathname address
  lw a2, O_RDWR  # load O_RDWR open flag
  ecall

  Read:
  add a1,x0,a0   # Pass File Descriptor to a1
  la a2,temp     # Pass Buffer Address to a2
  li a3,5        # 1 bytes to read
  li a0,14       # Read File
  ecall
  
  Convert:
  la a1,temp
  Loop_Convert:
  lb a2,0(a1)
  beq x0, a2, End
  li a3,48
  sub a2,a2,a3
  sb a2,0(a1)
  addi a1,a1,1
  jal x0,Loop_Convert
  
  End:
  ebreak