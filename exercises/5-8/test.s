.text
.global _start

_start:
    la sp, stack_end   # 将栈指针指向栈的起始位置
    li a0, 3           # 将a0寄存器中的值设为3
    call sum           # 调用sum函数

stop:
    j stop             # 无限循环，程序停止

sum:
    addi sp, sp, -16   # 在栈上分配16字节的空间
    sw s0, 0(sp)       # 将s0寄存器中的值保存到栈上
    sw s1, 4(sp)       # 将s1寄存器中的值保存到栈上
    sw s2, 8(sp)       # 将s2寄存器中的值保存到栈上
    sw ra, 12(sp)      # 将ra寄存器中的值保存到栈上

    mv s0, a0          # 将a0寄存器中的值保存到s0寄存器中
    li s1, 1           # 将1保存到s1寄存器中
    li s2, 0           # 将0保存到s2寄存器中

loop:
    blt s0, s1, end    # 如果s0小于s1，跳转到end
    mv a0, s1          # 将s1的值赋给a0
    jal square         # 跳转到square函数
    add s2, s2, a0     # 将a0的值加到s2上
    addi s1, s1, 1     # s1的值加1
    j loop             # 跳转到loop

end:
    mv a0, s2          # 将s2的值赋给a0
    lw s0, 0(sp)       # 从栈中恢复s0的值
    lw s1, 4(sp)       # 从栈中恢复s1的值
    lw s2, 8(sp)       # 从栈中恢复s2的值
    lw ra, 12(sp)      # 从栈中恢复ra的值
    addi sp, sp, 16    # 栈指针加16
    ret                # 返回

square:
    addi sp, sp, -12   # 为局部变量分配12字节空间
    sw ra, 0(sp)       # 保存ra寄存器
    sw s0, 4(sp)       # 保存s0寄存器
    sw s1, 8(sp)       # 保存s1寄存器

    mv s0, a0          # 将a0寄存器的值存储到s0寄存器中
    mul s1, s0, s0     # 将s0寄存器的值乘以自身，结果存储到s1寄存器中
    mv a0, s1          # 将s1寄存器的值存储到a0寄存器中

    lw ra, 0(sp)       # 恢复ra寄存器
    lw s0, 4(sp)       # 恢复s0寄存器
    lw s1, 8(sp)       # 恢复s1寄存器
    addi sp, sp, 12    # 恢复栈空间

    ret

# 这里不需要在.bss段中声明栈空间
stack_start:
	.rept 12
    .word 0
    .endr
stack_end:
    .end
