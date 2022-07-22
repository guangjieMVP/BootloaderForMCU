#include "usart.h"
#include "stdio.h"

#define BOOTLOADER_VERSION    "1.2" 

#define APP_ADDR   0x800B000   /* APPÆðÊ¼µØÖ· */

void boot_app(unsigned int sp, unsigned int pc);

int main(void)
{
    unsigned int *s_addr = (unsigned int *)APP_ADDR;
    unsigned int sp = *s_addr;
    unsigned int pc = *(s_addr+1);
    
    uart_init();
    
    myputstr("Bootloader: ");  
    myputstr(BOOTLOADER_VERSION);
    printf("\r\n");
    myputstr(__DATE__);
    printf(" %s\r\n", __TIME__);

    boot_app(sp, pc);
}