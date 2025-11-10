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
