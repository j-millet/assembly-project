bits    64
default rel

global  main

extern  printf
extern  scanf

section .data
    format_out  db  'your copied string is %s', 10,0
    format_out2  db  'your original string was %s', 10,0
    format_in   db  'please input your string',10,0
    format_scan db  '%s',0
section .bss
    instring    resb 4096
    outstring   resb 4096
section .text
    main:  
        sub rsp,8; call printf, print format_in
        lea rdi, [format_in]
        mov al,0
        call printf wrt ..plt
        add rsp,8
        mov rax,0

        sub rsp,8 ;get string to copy
        lea rdi,[format_scan]
        lea rsi,[instring]
        mov al,0
        call scanf wrt ..plt
        add rsp,8
        mov rax,0
        
        mov ecx,0 ;count the num of chars copied
        lea rdi,[outstring] ;destination string
        lea rsi,[instring]
        
        loop:
            mov rax,[rsi]
            cmp rax,0
            je  printval 
            movsq   ;moves 8 chars from address in rsi to rdi
            add ecx,1
            cmp ecx, 512    ; we have 4096 chars in buffer so we can only move 8 bits 4096/8 times = 512
            jl  loop

        printval: ;print contents of memory we copied to
            mov rax,0
            sub rsp,8
            lea rdi,[format_out]
            lea rsi,[outstring]
            call printf wrt ..plt
            add rsp,8

        printval2: ; print contents of memory we copied from
            mov rax,0
            sub rsp,8
            lea rdi,[format_out2]
            lea rsi,[instring]
            call printf wrt ..plt
            add rsp,8

        exit:;exit 0
            mov rax,60
            mov rdi,0
            syscall