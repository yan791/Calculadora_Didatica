.386
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib

.data
    msgEntrada db "Digite um número decimal: ", 0
    buffer db 20 dup(0)

.code
start:
    invoke StdOut, addr msgEntrada
    invoke StdIn, addr buffer, 20
    invoke ExitProcess, 0
end start

.data
    numero dd ?
    fmtInt db "Número em decimal: %d", 10, 0

.code
start:
    invoke StdOut, addr msgEntrada
    invoke StdIn, addr buffer, 20
    invoke atodw, addr buffer
    mov numero, eax
    invoke crt_printf, addr fmtInt, numero
    invoke ExitProcess, 0
end start

;
.data
    fmtBin db "Binário: %s", 10, 0
    binario db 33 dup(0)

.code
BinToStr proc valor:DWORD, buffer:PTR BYTE
    mov ecx, 32
    mov ebx, valor
    mov edi, buffer
loopBin:
    shl ebx, 1
    jc bit1
    mov al, '0'
    jmp gravar
bit1:
    mov al, '1'
gravar:
    mov [edi], al
    inc edi
    loop loopBin
    mov byte ptr [edi], 0
    ret
BinToStr endp

start:
    ...
    invoke BinToStr, numero, addr binario
    invoke crt_printf, addr fmtBin, addr binario
