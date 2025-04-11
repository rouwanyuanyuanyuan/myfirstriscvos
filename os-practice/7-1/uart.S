#include "platform.h"

.global uart_init
.global uart_putc
.global uart_getc
.global uart_puts

.equ RHR, 0	// Receive Holding Register (read mode)
.equ THR, 0	// Transmit Holding Register (write mode)
.equ DLL, 0	// LSB of Divisor Latch (write mode)
.equ IER ,1	// Interrupt Enable Register (write mode)
.equ DLM ,1	// MSB of Divisor Latch (write mode)
.equ FCR ,2	// FIFO Control Register (write mode)
.equ ISR ,2	// Interrupt Status Register (read mode)
.equ LCR ,3	// Line Control Register
.equ MCR ,4	// Modem Control Register
.equ LSR ,5	// Line Status Register
.equ MSR ,6	// Modem Status Register
.equ SPR ,7	// ScratchPad Register
.equ LSR_RX_READY ,0x01
.equ LSR_TX_IDLE ,0x20

.text

.macro uart_read_reg dest, reg
    li t1, UART0
    lb \dest ,\reg(t1)
    .endm

.macro uart_write_reg src, reg
    li t1, UART0
    sb \src ,\reg(t1)
    .endm

uart_init:
    li t0, 0x00
    uart_write_reg t0, IER
    xori t0, t0, 0x80
    uart_write_reg t0, LCR
    li t0, 0x03
    uart_write_reg t0, DLL
    li t0, 0x00
    uart_write_reg t0, DLM
    xori t0, t0, 0x03
    uart_write_reg t0, LCR
    ret

uart_putc:
    uart_read_reg t0, LSR
    andi t0, t0, LSR_TX_IDLE
    beqz t0, uart_putc
    uart_write_reg a0, THR
    ret

uart_puts:
    loop:
    lbu a0, 0(a1)
    beqz a0, loop_end
    jal uart_putc
    addi a1, a1, 1
    j loop
    
loop_end:
    ret

