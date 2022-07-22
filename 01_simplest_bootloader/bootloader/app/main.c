#include "usart.h"
#include "stdio.h"

#define BOOTLOADER_VERSION    "1.1" 

#define APP_ADDR   0x800B001

typedef void (*app_func)(void);

void uart_init(void);

int main(void)
{
    app_func app;
    
    unsigned int *p = (unsigned int *)0x800B000;
    unsigned int addr = *(p+1);
    
    uart_init();
    
    myputstr("Bootloader: ");  
    myputstr(BOOTLOADER_VERSION);
    printf("\r\n");
    myputstr(__DATE__);
    
    printf(" %s\r\n", __TIME__);
#if 0	
    app = (app_func)(APP_ADDR);
#else

    printf("Jump addr %x\r\n", addr);
    app = (app_func)(addr);
#endif
    
    app();    /* Ìø×ªÖ´ÐÐapp */
}