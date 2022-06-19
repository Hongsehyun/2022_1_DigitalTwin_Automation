#include "ecRCC.h"
#include "ecGPIO.h"
#include "ecEXTI.h"
#include "myFunction.h"
#include "ecSysTick.h"

void EXTI_init(GPIO_TypeDef* Port, int Pin, int TrigType, int priority){
	RCC->APB2ENR |= RCC_APB2ENR_SYSCFGEN;	// Enable GPIO peripheral clock                 
	
	EXTI_PinSetup(Port, Pin);
	
	if (TrigType == FALLING)
		EXTI_FallingTrigger(Pin);
	else if (TrigType == RISING)
		EXTI_RisingTrigger(Pin);
	else if (TrigType == FALL_RISE){
		EXTI_FallingTrigger(Pin);
		EXTI_RisingTrigger(Pin);
	}
	
	EXTI_Enable(Pin);
	
	EXTI_SetPriority(Pin, priority);
	NVIC_Enable(Pin);
}

void EXTI_PinSetup(GPIO_TypeDef* Port, int Pin){
	uint32_t val;
	if (Port == GPIOA)
		val = 0;
	else if (Port == GPIOB)
		val = 1 ;
	else if (Port == GPIOC)
		val = 2 ;
	else if (Port == GPIOD)
		val = 3 ;
	else if (Port == GPIOE)
		val = 4 ;
	else		// GPIOH
		val = 7 ;
	
	SYSCFG->EXTICR[Pin>>2] &= ~( 15UL << (4*(Pin&3)) ); // Clear 4bits
	SYSCFG->EXTICR[Pin>>2] |= val << (4*(Pin&3) );
}

void EXTI_FallingTrigger(int Pin){
	EXTI->FTSR |= 1UL << Pin;
}

void EXTI_RisingTrigger(int Pin){
	EXTI->RTSR |= 1UL << Pin;
}

void EXTI_Enable(uint32_t Pin){
	EXTI->IMR |= 1UL << Pin;
}

void EXTI_Disable(uint32_t Pin){
	EXTI->IMR &= ~(1UL << Pin);
}

void EXTI_SetPriority(int Pin, int priority){
	uint32_t EXTI_Line;
	if (Pin < 5)
		EXTI_Line = Pin + 6UL ;
	else if (Pin < 10)
		EXTI_Line = 23UL;
	else
		EXTI_Line = 40UL;
	
	NVIC_SetPriority(EXTI_Line, priority);
}

void NVIC_Enable(int Pin){
	uint32_t EXTI_Line;
	if (Pin < 5)
		EXTI_Line = (uint32_t)Pin + 6UL ;
	else if (Pin < 10)
		EXTI_Line = 23;
	else
		EXTI_Line = 40;
	
	NVIC_EnableIRQ(EXTI_Line);
}

uint32_t Is_Pending_EXTI(uint32_t Pin){
	uint32_t bBit;
	bBit = ( ( EXTI->PR & (1UL<<Pin) ) == (1UL<<Pin) );
	return bBit;
}

void Clear_Pending_EXTI(uint32_t Pin){
		EXTI->PR |= (1UL<<Pin); 			// cleared by writing '1'
}
