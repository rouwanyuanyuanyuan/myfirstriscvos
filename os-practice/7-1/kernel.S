.section .text
.globl start_kernel

# 声明外部函数
.extern uart_init
.extern uart_puts

start_kernel:
    # 初始化 UART
    call uart_init

    # 加载字符串地址到 a1
    la a1, hello_str      # 将字符串的地址加载到 a1
    call uart_puts        # 打印字符串

    # 无限循环
    1:  j 1b               # 无限循环防止程序退出

.section .rodata
hello_str:
    .string "Hello, RVOS!\n"   # 定义要打印的字符串

