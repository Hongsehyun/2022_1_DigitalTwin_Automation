#include "stm32f411xe.h"

#ifndef __EC_EXTI_H
#define __EC_EXTI_H

#ifdef __cplusplus
 extern "C" {
#endif /* __cplusplus */

#define FALLING 	0
#define RISING 		1
#define FALL_RISE 2

void EXTI_init(GPIO_TypeDef* Port, int Pin, int TrigType, int priority);
void EXTI_PinSetup(GPIO_TypeDef* Port, int Pin);
void EXTI_FallingTrigger(int Pin);
void EXTI_RisingTrigger(int Pin);
void EXTI_Enable(uint32_t Pin);
void EXTI_Disable(uint32_t Pin);
void EXTI_SetPriority(int Pin, int priority);
void NVIC_Enable(int Pin);
uint32_t Is_Pending_EXTI(uint32_t Pin);
void Clear_Pending_EXTI(uint32_t Pin);
	 
#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif
