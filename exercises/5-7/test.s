    .data
str:
    .asciz "Hello World!"
    
    .text
    .global _start

_start:
    la t0, str   # 将字符串地址加载到寄存器t0
    li t1,0 # 将寄存器t1初始化为0

loop:
    lb t2, 0(t0) # 从字符串中加载一个字节到寄存器t2
    beqz t2, stop # 如果寄存器t2为0，跳转到stop标签
    addi t0, t0, 1 # 将寄存器t0的值加1，指向下一个字节
    addi t1, t1, 1 # 将寄存器t1的值加1，计数器加1
    j loop # 无条件跳转到loop标签

stop:
    j stop   # 无条件跳转到stop标签，程序结束

    .end
