    .text
    .global _start

_start:
    li t0, 1
    li t1, 2
    li t2, 3
    add t3, t1, t2
    sub t4, t3, t2

stop:
    j stop

    .end
