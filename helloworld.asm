bits    64
default rel

global  main

extern  printf

section .data
    number     dw 0xBABA,0
    format     db '%u is a number',10,0

section .bss

section .text
    main:
        sub rsp, 8
        mov rax,0
        mov rsi, [number]
        lea rdi, [format]
        mov al, 0
        call printf wrt ..plt
        
        add rsp,8
        mov rax, 0

        add rsp, 8
        mov rax, 60
        mov rdi, 0
        syscall