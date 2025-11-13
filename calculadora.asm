###############################################################
# AUTOR: Yan Ribeiro Nunes
# EMAIL: yrn@cesar.school
# Data: 13/11/2025
# Hora: 14:35
###############################################################

.data
msg_inicial: .asciiz "Digite um número decimal: "
msg_saida:   .asciiz "\nNúmero lido: "
num: .word 0

.text
.globl main

main:
    # Exibe mensagem inicial
    li $v0, 4
    la $a0, msg_inicial
    syscall

    # Lê número inteiro
    li $v0, 5
    syscall
    move $t0, $v0        

    li $v0, 4
    la $a0, msg_saida
    syscall

    li $v0, 1
    move $a0, $t0
    syscall

.data
msg_bin: .asciiz "\nRepresentação em binário: "
binario: .space 33   # até 32 bits + null

.text
int_para_bin:
    li $t1, 31
    la $t2, binario
loop_bin:
    sll $t3, $t0, 0     
    srlv $t3, $t3, $t1
    andi $t3, $t3, 1
    addi $t3, $t3, 48
    sb $t3, 0($t2)
    addi $t2, $t2, 1
    addi $t1, $t1, -1
    bgez $t1, loop_bin
    sb $zero, 0($t2)
    jr $ra

main:
    ...
    li $v0, 4
    la $a0, msg_bin
    syscall

    jal int_para_bin
    li $v0, 4
    la $a0, binario
    syscall


.data
msg_oct: .asciiz "\nRepresentação em octal: "

.text
main:
    ...
    li $v0, 4
    la $a0, msg_oct
    syscall

    move $a0, $t0
    jal imprime_octal
    jr $ra

imprime_octal:
    li $t1, 0
    li $t2, 8
    move $t3, $a0
    la $t4, binario+32
conv_octal:
    beqz $t3, fim_oct
    div $t3, $t2
    mfhi $t5
    addi $t5, $t5, 48
    addi $t4, $t4, -1
    sb $t5, 0($t4)
    mflo $t3
    j conv_octal
fim_oct:
    li $v0, 4
    move $a0, $t4
    syscall
    jr $ra

.data
msg_hex: .asciiz "\nRepresentação em hexadecimal: "

.text
imprime_hex:
    li $t1, 0
    li $t2, 16
    move $t3, $a0
    la $t4, binario+32
conv_hex:
    beqz $t3, fim_hex
    div $t3, $t2
    mfhi $t5
    blt $t5, 10, num_hex
    addi $t5, $t5, 55    # A-F
    j salva_hex
num_hex:
    addi $t5, $t5, 48
salva_hex:
    addi $t4, $t4, -1
    sb $t5, 0($t4)
    mflo $t3
    j conv_hex
fim_hex:
    li $v0, 4
    move $a0, $t4
    syscall
    jr $ra
.data
msg_bcd: .asciiz "\nCódigo BCD: "

.text
imprime_bcd:
    move $t1, $a0
    la $t2, binario+32
loop_bcd:
    beqz $t1, fim_bcd
    div $t1, 10
    mfhi $t3
    addi $t3, $t3, 48
    addi $t2, $t2, -1
    sb $t3, 0($t2)
    mflo $t1
    j loop_bcd
fim_bcd:
    li $v0, 4
    move $a0, $t2
    syscall
    jr $ra

.data
msg_comp: .asciiz "\nComplemento a 2 (16 bits): "
comp: .space 17

.text
complemento2:
    move $t1, $a0
    andi $t1, $t1, 0xFFFF
    la $t2, comp+16
    li $t3, 16
loop_comp:
    beqz $t3, fim_comp
    andi $t4, $t1, 1
    addi $t4, $t4, 48
    addi $t2, $t2, -1
    sb $t4, 0($t2)
    srl $t1, $t1, 1
    addi $t3, $t3, -1
    j loop_comp
fim_comp:
    li $v0, 4
    move $a0, $t2
    syscall
    jr $ra

.data
msg_real: .asciiz "\nDigite um número real: "
num_real: .float 0.0

.text
main:
    ...
    li $v0, 4
    la $a0, msg_real
    syscall

    li $v0, 6       # lê float
    syscall
    mov.s $f12, $f0

.data
msg_float: .asciiz "\nBits do float (IEEE-754 simples): "

.text
float_bits:
    mfc1 $t0, $f12
    li $v0, 4
    la $a0, msg_float
    syscall

    jal int_para_bin

.data
msg_sinal: .asciiz "\nSinal: "
msg_exp:   .asciiz "\nExpoente: "
msg_bias:  .asciiz "\nExpoente (com viés): "
msg_frac:  .asciiz "\nFração: "

.text
campos_float:
    mfc1 $t0, $f12
    srl $t1, $t0, 31          # sinal
    srl $t2, $t0, 23
    andi $t2, $t2, 0xFF       # expoente
    andi $t3, $t0, 0x7FFFFF   # fração

    # sinal
    li $v0, 4
    la $a0, msg_sinal
    syscall
    li $v0, 1
    move $a0, $t1
    syscall

    # expoente
    li $v0, 4
    la $a0, msg_exp
    syscall
    li $v0, 1
    move $a0, $t2
    syscall

    # expoente com viés
    li $v0, 4
    la $a0, msg_bias
    syscall
    addi $a0, $t2, -127
    li $v0, 1
    syscall

    # fração
    li $v0, 4
    la $a0, msg_frac
    syscall
    move $a0, $t3
    jal int_para_bin

.data
msg_double: .asciiz "\nBits do double (IEEE-754 duplo): "

.text
main:
    ...
    li $v0, 7       # lê double
    syscall
    mov.d $f14, $f0

    li $v0, 4
    la $a0, msg_double
    syscall

    mfc1.d $t0, $f14
    jal int_para_bin
