#include "ecGPIO.h"
#include "ecRCC.h"

// GPIO init
void GPIO_init(GPIO_TypeDef* Port, int pin, int mode){
	RCC_GPIO_enable(Port);
	GPIO_mode(Port, pin, mode);
}

// GPIO Mode          : Input(00), Output(01), AlterFunc(10), Analog(11, reset)
void GPIO_mode(GPIO_TypeDef *Port, int pin, int mode){
   Port->MODER &= ~(3UL<<(2*pin));     
   Port->MODER |= mode<<(2*pin);    
}

// GPIO Write 			 	: Output 0 or 1
void GPIO_write(GPIO_TypeDef *Port, int pin, int output){
	Port->ODR &= ~(1UL<<pin);
	Port->ODR |= output<<pin ;
}

// GPIO Read
int  GPIO_read(GPIO_TypeDef *Port, int pin){
	return (int)(Port->IDR & (1UL<<pin));
}

//GPIO output speed 	: Low(00), Medium(01), Fast(01), High(11)
void GPIO_ospeed(GPIO_TypeDef* Port, int pin, int speed){
	Port->OSPEEDR &= ~(3UL<<(2*pin));
	Port->OSPEEDR |= speed<<(2*pin);
}

//GPIO output type 		: push-pull(0), open-drain(1)
void GPIO_otype(GPIO_TypeDef* Port, int pin, int type){
	Port->OTYPER &= ~(1UL<<pin);
	Port->OTYPER |= type<<pin;
}

// GPIO pull-up/pull-down 	: No pull-up/pull-down(00), Pull-up(01), Pull-down(10), Reserved(11)
void GPIO_pupdr(GPIO_TypeDef* Port, int pin, int pupd){
	Port->PUPDR &= ~(3UL<<(2*pin));
	Port->PUPDR |= pupd<<(2*pin);
}
