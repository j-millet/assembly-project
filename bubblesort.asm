bits    64
default rel

global  main

extern  printf
extern  scanf

section .data
    format_out  db  '%d', 9,0
    nl          db  ' ',10,0
    format_scan db  '%d',0
section .bss
    intarray    resd 100
    n           resd 1

section .text
    main:  
        mov r15,0
        lea rbx,[intarray]
        loop:
            
            cmp r15,100
            je endinput
            
            add r15,1
            mov rsi,rbx
            lea rdi,[format_scan]
            sub rsp,8 ;get int
            mov rax,0
            mov al,0
            call scanf wrt ..plt
            add rsp,8
            add rbx,4
            cmp rax,0;if scan worked, loop again else continue
            jne loop

        endinput:
        mov [n],r15;save num of elements to n

        ;BEGIN SORT
        mov rcx,0;outer loop counter
        mov rax,[n]
        dec rax
        outerloop:
            cmp rcx,rax
            jge printing
            inc rcx
            lea rbx,[intarray]
            mov r15,1;inner loop counter
            innerloop:
                cmp r15,rax
                jge outerloop
                add r15,1
                add rbx,4
                mov r8d,[rbx-4]
                mov r9d,[rbx]
                cmp r9d,r8d
                jge innerloop
                mov [rbx-4],r9d
                mov [rbx],r8d
                jmp innerloop
        ;END SORT

        printing:
        lea rbx,[intarray]
        mov r15,[n];printloop counter
        dec r15
        printloop:;print elements with a tab between them
            
            sub rsp, 8;print single element
            mov rsi,[rbx]
            lea rdi, [format_out]
            mov al, 0
            call printf wrt ..plt
            add rsp,8
            mov rax, 0

            add rbx,4; go to next element in array
            dec r15
            cmp r15,0
            jle newline
            jmp printloop
        
        newline:;print a new line
            sub rsp, 8
            lea rdi,[nl]
            mov al, 0
            call printf wrt ..plt
            add rsp,8
            mov rax, 0

        exit:;exit 0
            mov rax,60
            mov rdi,0
            syscall