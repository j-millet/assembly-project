bits    64
default rel

global  main

extern  printf
extern  scanf

section .data
    format_out  db  'sqrt(%.3lf) = %lf', 10,0
    format_scan db  '%lf',0

    step        dq  0.125
    zero        dq  0.0
section .bss
    end         resq 1
section .text
    main:
        mov rax,0;get end value from user
        lea rdi,[format_scan]
        lea rsi, [end]
        sub rsp,8 ;get int
        mov al,0
        call scanf wrt ..plt
        add rsp,8

        movlpd xmm14,[zero]
    
        loop:
            movlpd  xmm15, [end]
            cmpltsd xmm15,xmm14
            movq    rax,xmm15
            cmp     rax,0
            jne      exit

            movsd  xmm0,xmm14
            sqrtsd  xmm1,xmm14


            sub rsp, 8;print single element
            lea rdi, [format_out]
            mov al, 2
            call printf wrt ..plt
            add rsp,8
            mov rax, 0


            movlpd  xmm1,[step]
            addsd   xmm14,xmm1
            jmp loop

        
        exit:;exit 0
            mov rax,60
            mov rdi,0
            syscall