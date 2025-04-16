#include "os.h"

/*
 * Following functions SHOULD be called ONLY ONE time here,
 * so just declared here ONCE and NOT included in file os.h.
 */
extern void uart_init(void);
extern void page_init(void);
extern void page_test(void);
extern void malloc_init(void);
extern void test_malloc(void);

void start_kernel(void)
{
	uart_init();
	uart_puts("Hello, RVOS!\n");

	page_init();
	malloc_init();


		int flag = 1;
		while (flag)
		{
			page_test();
			test_malloc();
			flag = 0;
		}
		

}

