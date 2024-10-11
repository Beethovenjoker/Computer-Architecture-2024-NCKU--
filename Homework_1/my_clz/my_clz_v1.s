.data
test:    .word 0x00000000, 0x00000400, 0xFFFFFFFF   # 0, 1024, 4294967295
expected:    .word 32, 21, 0   # 32, 21, 0
yes:    .string "yes\n"   # Correct output message
no:    .string "no\n"     # Wrong output message

.text
main:
    la t0, test
    la t1, expected
    li t2, 3
    li a7, 4
testloop:
    beq t2, x0, end
    addi t2, t2, -1
    lw a0, 0(t0)
    jal ra, my_clz
    lw t3, 0(t1)
    beq a0, t3, correct
    la a0, no
print:
    ecall
    addi t0, t0, 4
    addi t1, t1, 4
    j testloop
correct:
    la a0, yes
    j print
my_clz:
    addi sp, sp, -4
    sw ra, 0(sp)
    add s0, a0, x0
    li s1, 1   
    li s2, 31   #loop times
    li s3, 0    #counts of leading 0
    li s4, 0    #temp of shift value
clz_loop:
    blt s2, x0, end_function
    sll s4, s1, s2
    and s4, s0, s4
    beq s4, x0, zero
    j  end_function
zero:
    addi s3, s3, 1
    addi s2, s2, -1
    j clz_loop
end_function:
    add a0, s3, x0
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra
end:
    addi a7, x0, 10
    ecall