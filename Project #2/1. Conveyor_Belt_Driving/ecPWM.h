#include "stm32f411xe.h"
#include "ecGPIO.h"
#include "ecTIM.h"
#include "ecSysTick.h"

#ifndef __EC_PWM_H
#define __EC_PWM_H

#ifdef __cplusplus
	extern "C" {
#endif	/* __cplusplus */

typedef struct{
	GPIO_TypeDef *port;
	int pin;
	TIM_TypeDef *timer;
	int ch;
} PWM_t;

/* PWM Coonfiguration */
void PWM_init(PWM_t *pwm, GPIO_TypeDef *port, int pin);
void PWM_period_ms(PWM_t *pwm, uint32_t msec);
void PWM_period_us(PWM_t *pwm, uint32_t usec);
void PWM_PulseWidth_ms(PWM_t *pwm, float pulse_width_ms);
void PWM_PulseWidth_us(PWM_t *pwm, float pulse_width_us);
void PWM_duty(PWM_t *pwm, float duty);
void PWM_PinMap(PWM_t *PWM_pin);


#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif
