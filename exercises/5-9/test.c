int foo(int a, int b) 
{
    int c;
    __asm__ (
        "mul t0, %[a], %[a]\n"  // t0 = a * a
        "mul t1, %[b], %[b]\n"  // t1 = b * b
        "add %[c], t0, t1\n"    // c  = t0 + t1
        : [c] "=r" (c)          // 输出约束
        : [a] "r" (a), [b] "r" (b) // 输入约束
        : "t0", "t1"            // 被修改的寄存器
    );
    return c;
}
