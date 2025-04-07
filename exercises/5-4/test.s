    .text
    .global _start

_start:
    li t0, 0x87654321 # 将立即数0x87654321加载到寄存器t0中
    li t3, 0xffff # 将立即数0xffff加载到寄存器t3中
    and t1, t0, t3 # 将寄存器t0和t3中的值进行按位与操作，结果存储在寄存器t1中
    srl t0, t0, 16 # 将寄存器t0中的值右移16位，结果存储在寄存器t0中
    and t2, t0, t3 # 将寄存器t0和t3中的值进行按位与操作，结果存储在寄存器t2中

stop:
    j stop # 无限循环，程序停止

    .end