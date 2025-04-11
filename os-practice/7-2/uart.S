#include "platform.h"

.global uart_init
.global uart_putc
.global uart_getc
.global uart_puts
.global uart_gets

.equ RHR, 0
.equ THR, 0
.equ DLL, 0
.equ IER, 1
.equ DLM, 1
.equ FCR, 2
.equ ISR, 2
.equ LCR, 3
.equ MCR, 4
.equ LSR, 5
.equ MSR, 6
.equ SPR, 7
.equ LSR_RX_READY, 0x01
.equ LSR_TX_IDLE, 0x20

.text

.macro uart_read_reg dest, reg
    li t1, UART0
    lb \dest, \reg(t1)
.endm

.macro uart_write_reg src, reg
    li t1, UART0
    sb \src, \reg(t1)
.endm

uart_init:
    li t0, 0x00
    uart_write_reg t0, IER
    li t0, 0x80
    uart_write_reg t0, LCR
    li t0, 0x03
    uart_write_reg t0, DLL
    li t0, 0x00
    uart_write_reg t0, DLM
    li t0, 0x03
    uart_write_reg t0, LCR
    ret

uart_putc:
    uart_read_reg t0, LSR
wait_tx:
    andi t0, t0, LSR_TX_IDLE
    beqz t0, uart_putc
    uart_write_reg a0, THR
    ret

uart_puts:
puts_loop:
    lbu a0, 0(a1)
    beqz a0, puts_end
    jal uart_putc
    addi a1, a1, 1
    j puts_loop
puts_end:
    ret

uart_getc:
getc_wait:
    uart_read_reg t0, LSR
    andi t0, t0, LSR_RX_READY
    beqz t0, getc_wait
    uart_read_reg a0, RHR
    ret

uart_gets:
    mv t2, a0         # buffer pointer
    li t3, 0

get_loop:
    call uart_getc
    li t0, 10         # '\n' = 10
    beq a0, t0, end_get

    sb a0, 0(t2)
    addi t2, t2, 1
    call uart_putc
    j get_loop

end_get:
    li a0, '\n'
    call uart_putc
    li t0, 0
    sb t0, 0(t2)
    ret
