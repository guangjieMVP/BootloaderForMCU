#include "led.h"

typedef struct
{
  __IO uint32_t CRL;
  __IO uint32_t CRH;
  __IO uint32_t IDR;
  __IO uint32_t ODR;
  __IO uint32_t BSRR;
  __IO uint32_t BRR;
  __IO uint32_t LCKR;
} GPIO_TypeDef;  


void LED_Init(void)   
{
	RCC->APB2ENR |= 1 << 3;    //使能PORTB时钟	   	 
	RCC->APB2ENR |= 1 << 6;    //使能PORTE时钟	
	   	 
	GPIOB->CRL &= 0XFF0FFFFF; 
	GPIOB->CRL |= 0X00300000;//PB.5 推挽输出   	 
    GPIOB->ODR |= 1 << 5;      //PB.5 输出高
											  
	GPIOE->CRL &= 0XFF0FFFFF;
	GPIOE->CRL |= 0X00300000;  //PE.5推挽输出
	GPIOE->ODR |= 1 << 5;      //PE.5输出高 
}






