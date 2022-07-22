//#include "stdio.h"
#include "usart.h"

void uart_init(void);

void delay(int times)
{
   while (--times);
}


char buf[100] = {"Hello, My App!!!"};
int xmain(void)
{  
	static unsigned int global;
    uart_init();

    myputstr("\r\nApp Start\r\n");
	myputstr(buf);	
    myputstr("\r\n");
    
    while (1)
    {
        myputstr("app runing\r\n");
        //myputstr("App runing\r\n");
        delay(1000000);
    }
}

void relocate_app(char *from, char *to, unsigned int len)
{
	while (len--)
	{
		*to++ = *from++;
	}
}

/* 重定位数据段 */
void c_relocate_data(char *from, char *to, unsigned int len)
{
    while (len--)
    {
        *to = *from;
		to++;
		from++;
    }
}

/* 清除bss段 */
void c_clear_bss(char *dest, unsigned int len, char val)
{
    while (len--)
    {
        *dest++ = val;
    }
}
