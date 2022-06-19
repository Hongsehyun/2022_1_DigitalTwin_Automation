/*
*********************************************************
* @author HeeYun Kang
* @Mod 		2022-06-16 by Hee-Yun KANG
* @brief 	Digital Twin & Automation
					< Project : Garbage Classification & Automation >
					 - This program generates pwm signal for stepper motor of conveyer belt 
					 - Libraries are referenced by 2021-2 Embedded Controller lecture(YKK)
*
*********************************************************
*/

#include "ecRCC.h"
#include "ecGPIO.h"
#include "ecSysTick.h"
#include "ecEXTI.h"
#include "ecTIM.h"
#include "ecPWM.h"

#define PWM_PIN		15

static PWM_t ServoMotor;

uint32_t cnt = 0;

void setup(void);

int main(void) {
	
// Initialiization ----------------------------
	setup();

// While loop ---------------------------------
	while(1){
		
		PWM_PulseWidth_ms(&ServoMotor, (0.5 + cnt * 0.2));

		if (cnt > 10) cnt = 0;

	}
}

void setup(void){
	RCC_PLL_init();   			// System Clock = 84MHz	
		
	// Button Interrupt
	EXTI_init(GPIOC, BUTTON_PIN, FALLING, 0);
	GPIO_init(GPIOC, BUTTON_PIN, INPUT);
	GPIO_pupdr(GPIOC, BUTTON_PIN, PULL_UP);
	
	// PA1 : PWM
	PWM_init(&ServoMotor, GPIOA, PWM_PIN);
	PWM_period_us(&ServoMotor, 1250);
	PWM_duty(&ServoMotor, 0.5);

}

void EXTI15_10_IRQHandler(void){
	if(Is_Pending_EXTI(BUTTON_PIN)){
		cnt++;
		Clear_Pending_EXTI(BUTTON_PIN);
	}
}
