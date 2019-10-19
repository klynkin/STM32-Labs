#include "main.h"




int main(void)
{
	//PORTD: 3,4,7,13
	
	RCC->APB2ENR|=RCC_APB2ENR_IOPCEN;
	RCC->APB2ENR|=RCC_APB2ENR_IOPAEN;
	
	GPIOC->CRL &= ~(GPIO_CRL_CNF3_1);
	GPIOA->CRL &= ~(GPIO_CRL_CNF0|GPIO_CRL_MODE0);
	GPIOA->CRL &= ~(GPIO_CRL_CNF1|GPIO_CRL_MODE1);
	GPIOA->CRL &= ~(GPIO_CRL_CNF2|GPIO_CRL_MODE2);
	GPIOA->CRL &= ~(GPIO_CRL_CNF3|GPIO_CRL_MODE3);
	GPIOA->CRL &= ~(GPIO_CRL_CNF4|GPIO_CRL_MODE4);
	GPIOA->CRL &= ~(GPIO_CRL_CNF5|GPIO_CRL_MODE5);
	GPIOA->CRL &= ~(GPIO_CRL_CNF6|GPIO_CRL_MODE6);
	
	GPIOA->CRL |=	(GPIO_CRL_MODE0_1);
	GPIOA->CRL |=	(GPIO_CRL_MODE1_1);
	GPIOA->CRL |=	(GPIO_CRL_MODE2_1);
	GPIOA->CRL |=	(GPIO_CRL_MODE3_1);
	GPIOA->CRL |=	(GPIO_CRL_MODE4_1);
	GPIOA->CRL |=	(GPIO_CRL_MODE5_1);
	GPIOA->CRL |=	(GPIO_CRL_MODE6_1);

	
	int counter=0;
	int flag=0;
	
	//initBtn();
	//init_tim6();
	
	while(1)
	{
		
		
		if((GPIOC->IDR & GPIO_IDR_IDR1) != GPIO_IDR_IDR1) {
    delay(1000000);
			if((GPIOC->IDR & GPIO_IDR_IDR1) != GPIO_IDR_IDR1) {
				
				
	GPIOA->ODR &= 0xFF80;
				if(flag==0)
				{
					counter++;
					if(counter>9)
					{
					flag=1;
					}
				}
				else
				{
					counter --;
					if(counter==0)
					{
					flag=0;
					}
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