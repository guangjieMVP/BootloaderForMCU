//#include "stdio.h"
#include "usart.h"

void uart_init(void);

void delay(int times)
{
   while (--times);
}

void (*fputstr)(char *);

char buf[100] = {"Hello, My App!!!"};
int xmain(void)
{  
	static unsigned int global;
    uart_init();
	
	fputstr = myputstr;
	char *p = buf;
    fputstr("\r\nApp Start!!!\r\n");
	myputstr(p);	
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