.data
test_fp16:   .word 0x3C00, 0xC000, 0x7BFF
expected_fp32:   .word 0x3F800000, 0xC0000000, 0x477FE000
yes:        .string "yes\n"
no:         .string "no\n"

.text
main:
    la t0, test_fp16
    la t1, expected_fp32
    li t2, 3
    li a7, 4
testloop:
    beq t2, x0, end
    addi t2, t2, -1
    lw a0, 0(t0)
    jal ra, fp16_to_fp32
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
    add s0, a0, x0
    li s1, 1
    li s2, 31
    li s3, 0
    li s4, 0
clz_loop:
    blt s2, x0, end_clz
    sll s4, s1, s2
    and s4, s0, s4
    beq s4, x0, zero
    j end_clz
zero:
    addi s3, s3, 1
    addi s2, s2, -1
    j clz_loop
end_clz:
    add a0, s3, x0
    jr ra
fp16_to_fp32:
    addi sp, sp, -4
    sw ra, 0(sp)
    slli t6, a0, 16
    li s1, 0x80000000
    and s0, t6, s1
    add t5, s0, x0
    li s1, 0x7FFFFFFF
    and s0, t6, s1
    add a0, s0, x0
    jal ra, my_clz
    add s1, a0, x0
    li s2, 5
    bltu s1, s2, set_zero
    addi s1, s1, -5
    j skip_shift
set_zero:
    addi s1, x0, 0
skip_shift:
    li s2, 0x04000000
    add s2, s0, s2
    srli s2, s2, 8
    li s3, 0x7F800000
    and s2, s2, s3
    addi s3, s0, -1
    srli s3, s3, 31
    sll s0, s0, s1
    srli s0, s0, 3
    li t4, 0x70
    sub s1, t4, s1
    slli s1, s1, 23
    add s0, s0, s1
    or s0, s0, s2
    not s3, s3
    and s0, s0, s3
    or a0, s0, t5
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra
end:
    li a7, 10
    ecall