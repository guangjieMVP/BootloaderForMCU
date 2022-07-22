/*
 * @brief :   
 * @date :  2021-11-xx
 * @version : v1.0.0
 * @copyright(c) 2020 : OptoMedic company Co.,Ltd. All rights reserved
 * @Change Logs:   
 * @date         author         notes:  
 */

#include "usart.h"

typedef unsigned int __be32;
typedef unsigned char uint8_t;
typedef unsigned int uint32_t;

//typedef enum {
//	false = 0,
//	true = !false,
//}BOOL, bool;

#define bool int

#define BOOTLOADER_VERSION    "1.4" 

#define APP_BIN_ADDR   0x800B000   /* APP在加载地址 */

#define IH_MAGIC	0x27051956	 /* Image Magic Number		*/
#define IH_NMLEN		32	     /* Image Name Length  */

/* 大端字节序转小端字节序 */
#define __BE32_TO_CPU(x)   ( ( (x & 0x000000FF) << 24 ) | ( ( (x & 0x0000FF00)  >> 8 ) << 16) |  \
                           ( ( (x & 0x00FF0000) >> 16 ) << 8)  | ( ( (x & 0xFF000000 ) >> 24 ) ) )

typedef struct image_header {
	__be32		ih_magic;	/* Image Header Magic Number	*/
	__be32		ih_hcrc;	/* Image Header CRC Checksum	*/
	__be32		ih_time;	/* Image Creation Timestamp	*/
	__be32		ih_size;	/* Image Data Size		*/
	__be32		ih_load;	/* Data	 Load  Address		*/
	__be32		ih_ep;		/* Entry Point Address		*/
	__be32		ih_dcrc;	/* Image Data CRC Checksum	*/
	uint8_t		ih_os;		/* Operating System		*/
	uint8_t		ih_arch;	/* CPU architecture		*/
	uint8_t		ih_type;	/* Image Type			*/
	uint8_t		ih_comp;	/* Compression Type		*/
	uint8_t		ih_name[IH_NMLEN];	/* Image Name		*/
} image_header_t;

static void parse_head(uint32_t bin_addr, uint32_t *load, uint32_t *entry, uint32_t *size)
{
    image_header_t *hdr;
    
    hdr = (image_header_t *)bin_addr;
    
    uint32_t _load = __BE32_TO_CPU(hdr->ih_load);    /* 加载地址 */
    uint32_t _entry = __BE32_TO_CPU(hdr->ih_ep);     /* 链接地址 */
    
    uint32_t _size = __BE32_TO_CPU(hdr->ih_size);    /* 链接地址 */
        
    *load = bin_addr + sizeof(image_header_t);       /* APP真正开始的地址 */
    *entry = _entry;
    *size = _size;
}

/* 重定位app */
static void relocate_app(char *from, char *to, unsigned int len)
{
	while (len--)
	{
		*to++ = *from++;
	}
}

void boot_app(uint32_t start_addr);

int main(void)
                                                                                                         {
    uint32_t s_addr = APP_BIN_ADDR;
    uint32_t entry;
    uint32_t load;
    uint32_t size;
																											 
	bool ad = 0;
    
    uart_init();
    
    myputstr("\r\nBootloader: ");  
    myputstr(BOOTLOADER_VERSION);
	myputstr("  ");
    myputstr(__DATE__);
	myputstr("  ");
    myputstr(__TIME__);
    
    parse_head(s_addr, &load, &entry, &size);
    relocate_app((char *)load, (char *)entry, size);
    boot_app(entry);
	
	return 0;
}

