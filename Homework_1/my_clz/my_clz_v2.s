.data
test:       .word 0x00000000, 0x00000400, 0xFFFFFFFF
expected:   .word 32, 21, 0
yes:        .string "yes\n"
no:         .string "no\n"

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
    addi s0, x0, 32
    beq a0, x0, end_clz
    addi s0, x0, 0    
    li t4, 0x0000FFFF
    bgeu a0, t4, less_than_16
    addi s0, s0, 16    #numbers of leading zero
    slli a0, a0, 16
less_than_16:
    li t4, 0x00FFFFFF
    bgeu a0, t4, less_than_8
    addi s0, s0, 8
    slli a0, a0, 8
less_than_8:
    li t4, 0x0FFFFFFF
    bgeu a0, t4, less_than_4
    addi s0, s0, 4
    slli a0, a0, 4
less_than_4:
    li t4, 0x3FFFFFFF
    bgeu a0, t4, less_than_2
    addi s0, s0, 2
    slli a0, a0, 2
less_than_2:
    li t4, 0x7FFFFFFF
    bgeu a0, t4, end_clz
    addi s0, s0, 1
end_clz:
    add a0, s0, x0
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra
end:
    li a7, 10
    ecall