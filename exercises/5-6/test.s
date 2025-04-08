    .data
s:
    .word 0
    .word 0
    
    .text
    .global _start

    .macro SET_S base, offset, value
        sw \value, \offset(\base)
    .endm

    .macro GET_S dest, base, offset
        lw \dest, \offset(\base)
    .endm

_start:
    la t0, s
    li t1, 0x12345678
    li t2, 0x87654321

    SET_S t0, 0, t1
    SET_S t0, 4, t2
    
    li t1, 0
    li t2, 0

    GET_S t1, t0, 0
    GET_S t2, t0, 4


stop:
    j stop

    .end