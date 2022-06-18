#include "stm32f411xe.h"

#ifndef __EC_SYSTICK_H
#define __EC_SYSTICK_H

#ifdef __cplusplus
 extern "C" {
#endif /* __cplusplus */

// Clock
#define MCU_CLK_PLL 	84000000
#define MCU_CLK_HSI 	16000000
#define MCU_SYS_CLK 	MCU_CLK_PLL		// MCU_CLK_HSI	or MCU_CLK_PLL

// UNIT
#define UNIT_MILLI		1/1000
#define UNIT_MICRO		1/1000000

void SysTick_init(uint32_t Tick_Period_ms);
void SysTick_init_us(uint32_t Tick_Period_us);
void delay_ms(uint32_t msec);
void delay_us(uint32_t usec);
uint32_t SysTick_val(void);
void SysTick_Enable(void);
void SysTick_Disable(void);

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif
