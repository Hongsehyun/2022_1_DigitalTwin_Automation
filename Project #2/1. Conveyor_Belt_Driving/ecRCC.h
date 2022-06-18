#include "stm32f411xe.h"

#ifndef __EC_RCC_H
#define __EC_RCC_H

#ifdef __cplusplus
 extern "C" {
#endif /* __cplusplus */

void RCC_HSI_init(void);
void RCC_PLL_init(void);
void RCC_GPIO_enable(GPIO_TypeDef* Port);

extern int EC_SYSCL;

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif
