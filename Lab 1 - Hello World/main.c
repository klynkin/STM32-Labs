#include "main.h"
int main(void)


{

	RCC->APB2ENR|=RCC_APB2ENR_IOPCEN;
	RCC->APB2ENR|=RCC_APB2ENR_IOPAEN;
	GPIOA->CRL &= 0xF0000000;
	GPIOA->CRL |= 0x03333333;
	uint8_t counter=0;
	uint8_t flag=0;
	
	while(1)
	{
		if((GPIOC->IDR & GPIO_IDR_IDR1) != GPIO_IDR_IDR1) 
			{
    delay(1000000);
				if((GPIOC->IDR & GPIO_IDR_IDR1) != GPIO_IDR_IDR1) 
					{
				
					GPIOA->ODR &= 0xFF80;
					if(flag==0)
						{
							counter++;
								if(counter>9)
								flag=1;
						}
						else
						{
							counter --;
							if(counter==1)
							flag=0;
						}
						
						switch (counter)
						{
							case 1:
							GPIOA->ODR |=0x003F;
							break;
							
							case 2:
							GPIOA->ODR |=0x0006;
							break;
							
							case 3:
							GPIOA->ODR |=0x005B;
							break;
							
							case 4:
							GPIOA->ODR |=0x004F;
							break;
							
							case 5:
							GPIOA->ODR |=0x0066;
							break;
							
							case 6:
							GPIOA->ODR |=0x006D;
							break;
							
							case 7:
							GPIOA->ODR |=0x007D;
							break;
							
							case 8:
							GPIOA->ODR |=0x0007;
							break;
							
							case 9:
							GPIOA->ODR |=0x007F;
							break;
							
							case 10:
							GPIOA->ODR |=0x006F;
							break;
							
						}
					}
				}	
	}
}

void delay(uint32_t t)
{
	for( uint32_t i=0; i<=t; i++);
}