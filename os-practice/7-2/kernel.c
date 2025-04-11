extern void uart_init(void);
extern void uart_puts(char *s);
extern void uart_gets(char *buffer, int buffer_size);

void start_kernel(void)
{
	uart_init();
	uart_puts("Hello, RVOS!\n");
	char buffer[128];  // Buffer to hold input string
	while (1) {
		uart_puts("Input: ");
		uart_gets(buffer, sizeof(buffer));  // Read input string
		uart_puts("You typed: ");
		uart_puts(buffer);  // Echo input string
		uart_puts("\n");
	}; // stop here!
}

