#include "stm32f411xe.h"

#ifndef __EC_TIM_H
#define __EC_TIM_H

#ifdef __cplusplus
	extern "C" {
#endif	/* __cplusplus */

/* Input Capture */

// Count Type
#define UP_CNT 		0
#define DOWN_CNT 	1

// Edge Type
#define RISE_TIM 0
#define FALL_TIM 1
#define BOTH_TIM 2

/* Timer Coonfiguration */
void TIM_init(TIM_TypeDef* TIMx, uint32_t msec);
void TIM_CNT_DIR(TIM_TypeDef*TIMx, uint32_t direction);
void TIM_period_us(TIM_TypeDef* TIMx, uint32_t usec);
void TIM_period_ms(TIM_TypeDef* TIMx, uint32_t msec);
void TIM_Interrupt_init(TIM_TypeDef* TIMx, uint32_t msec, uint32_t priority);
void TIM_Interrupt_enable(TIM_TypeDef* TIMx);
void TIM_Interrupt_disable(TIM_TypeDef* TIMx);
uint32_t Is_UIF(TIM_TypeDef* TIMx);
void Clear_UIF(TIM_TypeDef* TIMx);


//Input Capture
typedef struct{
	GPIO_TypeDef *port;
	int pin;   
	TIM_TypeDef *timer;
	int ch;  		//int Timer Channel
	int ICnum;  //int IC number
} IC_t;

void ICAP_init(IC_t *ICx, GPIO_TypeDef *port, int pin, uint32_t priority);
void ICAP_setup(IC_t *ICx, int IC_number, int edge_type);
void ICAP_counter_us(IC_t *ICx, int usec);
uint32_t Is_CCIF(TIM_TypeDef *TIMx, uint32_t ccNum);
void Clear_CCIF(TIM_TypeDef *TIMx, uint32_t ccNum);
void ICAP_pinmap(IC_t *timer_pin);


#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif