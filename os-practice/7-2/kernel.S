.section .text
.globl start_kernel
.extern uart_init
.extern uart_puts
.extern uart_gets

start_kernel:
    call uart_init

    la a1, hello_str
    call uart_puts

input_loop:
    la a0, buffer
    li a1, 128
    call uart_gets

    la a1, buffer
    call uart_puts

    j input_loop

.section .rodata
hello_str:
    .string "Hello, RVOS! Type something:\n"

.section .bss
buffer:
    .skip 128
