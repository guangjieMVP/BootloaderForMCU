#include "usart.h"
//#include "stdio.h"

#define BOOTLOADER_VERSION    "1.4" 

#define APP_ADDR   0x800B000   /* APPÆðÊ¼µØÖ· */
#define VECTOR_REG_ADDR    0xE000ED08

void boot_app(unsigned int start_addr, unsigned int vector_reg);

int main(void)
{
    unsigned int s_addr = APP_ADDR;
    unsigned int vector_addr = VECTOR_REG_ADDR;
    uart_init();
    
    myputstr("\r\nBootloader: ");  
    myputstr(BOOTLOADER_VERSION);
	myputstr("  ");
    myputstr(__DATE__);
	myputstr("  ");
    myputstr(__TIME__);

    boot_app(s_addr, vector_addr);
	
	return 0;
}

