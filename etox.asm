bits    64
default rel

global  main

extern  printf
extern  scanf

section .data
    format_out      db  '%lf', 10,0
    format_bscan    db  'please input k and x (k x): ',10,0
    format_scan     db  '%d %lf',0
    format_debug    db  '%lf %lf',10,0

    zero            dq  0.0
    one             dq  1.0
section .bss
    k           resd 1
    x           resq 1
section .text
    main:
        sub rsp, 8
        mov rax,0
        lea rdi, [format_bscan]
        mov al, 0
        call printf wrt ..plt
        add rsp,8
        mov rax, 0

        ;get variables
        lea rdi,[format_scan]
        lea rsi, [k]
        lea rdx, [x]
        sub rsp,8
        mov al,0
        call scanf wrt ..plt
        add rsp,8

        mov         r15,    [k]
        movlpd      xmm15,  [zero] ;sum
        movlpd      xmm14,  [one];numerator
        movlpd      xmm13,  [one];denumerator
        movlpd      xmm12,  [zero];i        
        loop:
            cmp     r15,    0
            jle     print
            dec     r15

            ;add fraction to sum
            movsd   xmm1,   xmm14
            divsd   xmm1,   xmm13
            addsd   xmm15,  xmm1

            ;multiply numerator by x
            movlpd  xmm1,   [x]
            mulsd   xmm14,  xmm1

            ;multiply denumerator
            addsd   xmm12,   [one]
            mulsd   xmm13,  xmm12
            
            jmp loop

        print:
            sub rsp, 8;print single element
            movsd xmm0,xmm15
            lea rdi, [format_out]
            mov al, 1
            call printf wrt ..plt
            add rsp,8
            mov rax, 0

        exit:;exit 0
            mov rax,60
            mov rdi,0
            syscall