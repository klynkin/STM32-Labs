#ifndef __MAIN_H
#define __MAIN_H

#include "stm32f10x.h"                  // Device header
#define DELAY_VAL 1000000

#define LED1_ON() GPIOD->BSRR=GPIO_BSRR_BS3
#define LED2_ON() GPIOD->BSRR=GPIO_BSRR_BS4
#define LED3_ON() GPIOD->BSRR=GPIO_BSRR_BS7
#define LED4_ON() GPIOD->BSRR=GPIO_BSRR_BS13


#define LED1_OFF() GPIOD->BSRR=GPIO_BSRR_BR3
#define LED2_OFF() GPIOD->BSRR=GPIO_BSRR_BR4
#define LED3_OFF() GPIOD->BSRR=GPIO_BSRR_BR7
#define LED4_OFF() GPIOD->BSRR=GPIO_BSRR_BR13

void delay();


#endif
