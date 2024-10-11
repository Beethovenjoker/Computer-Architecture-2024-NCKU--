.data
test_n:    .word 1, 3, 10    # Input values n = 1, 3, 12
expected: .word 1, 27, 462911642   # Expected outputs for each case
yes:    .string "yes\n"   # Correct output message
no:    .string "no\n"     # Wrong output message
MOD:    .word 1000000007   # Modulus value for the operation

.text
main:
    la t0, test_n           # Load the base address of the test input n values
    la t1, expected         # Load the base address of the expected output values
    li t2, 3                # Loop counter for 3 test cases
    li a7, 4                # Syscall number for printing
testloop:
    beq t2, x0, end         # If loop counter is 0, end program
    addi t2, t2, -1         # Decrement loop counter
    lw a0, 0(t0)            # Load current test case n into a0
    jal ra, concatenatedBinary  # Call concatenatedBinary function
    lw t3, 0(t1)            # Load expected result into t3
    beq a0, t3, correct     # If result matches expected, print "yes"
    la a0, no               # Otherwise, print "no"
print:
    ecall                   # Make system call to print result
    addi t0, t0, 4          # Move to the next test case
    addi t1, t1, 4          # Move to the next expected output
    j testloop              # Loop back to test the next case
correct:
    la a0, yes              # Load "yes" string
    j print                 # Jump to print the result
concatenatedBinary:
    addi sp, sp, -4        # Save registers on the stack
    sw ra, 0(sp)
    li s0, 0                # result = 0 (initialize result)
    li s1, 1                # i = 1 (initialize loop variable)
    li s2, 32               # max bit length for shifts
    lw s3, MOD              # Load MOD value from memory
    add s4, a0, x0
binary_loop:
    bgt s1, s4, end_binary   # Exit loop when i > n
    addi a0, s1, 0          # a1 = i (current number for concatenation)
    jal ra, my_clz          # Call my_clz to get the number of leading zeros
    sub a0, s2, a0          # length = 32 - my_clz(i)
    sll s0, s0, a0          # Left shift result by the bit length of the number
    or s0, s0, s1           # Concatenate the current number
    remu s0, s0, s3
    addi s1, s1, 1          # Increment i by 1
    j binary_loop           # Repeat the loop
end_binary:
    add a0, s0, x0          # Move the final result to a0 (return value)
    lw ra, 0(sp)            # Restore saved registers
    addi sp, sp, 4         # Restore stack
    jr ra                   # Return to main
my_clz:
    addi sp, sp, -24        # Save registers on the stack
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    add s0, a0, x0          # Copy input value to s0
    li s1, 1                # Set s1 to 1 (for shifting)
    li s2, 31               # Start from the 31st bit
    li s3, 0                # Initialize leading zero counter to 0
    li s4, 0                # Temporary value for shift
clz_loop:
    blt s2, x0, end_clz      # If s2 < 0, exit loop
    sll s4, s1, s2          # Shift 1 left by s2 bits (1 << s2)
    and s4, s0, s4          # Mask the bit at position s2
    beq s4, x0, zero        # If the bit is 0, increment leading zero count
    j end_clz               # If the bit is 1, exit the loop
zero:
    addi s3, s3, 1          # Increment leading zero count
    addi s2, s2, -1         # Decrement bit position counter
    j clz_loop              # Repeat the loop
end_clz:
    add a0, s3, x0          # Store leading zero count in a0 (return value)
    lw ra, 0(sp)            # Restore saved registers
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 24         # Restore stack
    jr ra                   # Return to main
end:
    li a7, 10               # Exit the program
    ecall