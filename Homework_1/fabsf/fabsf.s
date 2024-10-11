.data
test:    .word 0xBF800000, 0xC048F5C3, 0x420C0000   # -1.0, -3.14, 35.0
expected:    .word 0x3F800000, 0x4048F5C3, 0x420C0000   # 1.0, 3.14, 35.0
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
    jal ra, fabsf
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
fabsf:
    addi sp, sp, -4
    sw ra, 0(sp)
    li s0, 0x7FFFFFFF 
    and a0, a0, s0
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra
end:
    addi a7, x0, 10
    ecall