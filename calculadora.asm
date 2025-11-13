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
    move $t0, $v0        # guarda o número lido

    # Mostra confirmação
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
# Função para converter inteiro para binário (string)
int_para_bin:
    li $t1, 31
    la $t2, binario
loop_bin:
    sll $t3, $t0, 0      # cópia
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

# Subrotina para imprimir número em base 8
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
