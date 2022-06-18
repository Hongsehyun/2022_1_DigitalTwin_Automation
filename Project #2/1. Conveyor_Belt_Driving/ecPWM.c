#include "ecPWM.h"

/* PWM Configuration */

void PWM_init(PWM_t *pwm, GPIO_TypeDef *port, int pin){
// 0. Match Output Port and Pin for TIMx
	pwm->port = port;
	pwm->pin 	= pin;
	PWM_PinMap(pwm);
	TIM_TypeDef *TIMx = pwm->timer;
	int CHn = pwm->ch;
	
// 1. Initialize GPIO port and pin as AF
	GPIO_init(port, pin, AF);
	GPIO_ospeed(port, pin, HIGH_SPEED);
	GPIO_otype(port, pin, PUSH_PULL);
	GPIO_pupdr(port, pin, NO_PUPD);

// 2. Configure GPIO AFR by pin number.
	// AFR[0] for pin: 0~7,			AFR[1] for pin: 8~15
	// AF1: TIM1, TIM2 / AF2: TIM3~5 / AF3: TIM9~11
	
	uint32_t AFRval = 0;
	if 			(TIMx == TIM1) 	AFRval = 0x01UL;
	else if (TIMx == TIM2) 	AFRval = 0x01UL;
	else if (TIMx == TIM3) 	AFRval = 0x02UL;
	else if (TIMx == TIM4) 	AFRval = 0x02UL;
	else if (TIMx == TIM5) 	AFRval = 0x02UL;
	else if (TIMx == TIM9) 	AFRval = 0x03UL;
	else if (TIMx == TIM10) AFRval = 0x03UL;
	else if (TIMx == TIM11) AFRval = 0x03UL;
	
	port->AFR[pin>>3] &= ~(15UL<<(4*(pin&7)));
	port->AFR[pin>>3] |= AFRval<<(4*(pin&7)); 
	
// 3. Initialize Timer
	TIM_init(TIMx, 1);					// with default msec = 1 value.
	TIMx->CR1 &= ~TIM_CR1_CEN;	// Disable Timer counter
	
// 3-2. Direction of Counter
	TIMx->CR1 &= ~(1UL << 4);
	TIMx->CR1 |= 0UL << 4;		// 0: up-counter, 1: down-counter
	
// 4. Configure Timer Output mode as PWM
	uint32_t ccVal=TIMx->ARR/2;  // default value  CC=ARR/2
	if(CHn == 1){
		TIMx->CCMR1 &= ~TIM_CCMR1_OC1M;                     // Clear ouput compare mode bits for channel 1
		TIMx->CCMR1 |= 6UL << TIM_CCMR1_OC1M_Pos; 					// OC1M = 110 for PWM Mode 1 output on ch1. #define TIM_CCMR1_OC1M_1          (0x2UL << TIM_CCMR1_OC1M_Pos)
		TIMx->CCMR1	|= TIM_CCMR1_OC1PE;                     // Output 1 preload enable (make CCR1 value changable)
		TIMx->CCR1  = ccVal; 																// Output Compare Register for channel 1 (default duty ratio = 50%)		
		TIMx->CCER &= ~TIM_CCER_CC1P;                       // select output polarity: active high	
		TIMx->CCER  |= TIM_CCER_CC1E;												// Enable output for ch1
	}
	else if(CHn == 2){
		TIMx->CCMR1 &= ~TIM_CCMR1_OC2M;                     // Clear ouput compare mode bits for channel 2
		TIMx->CCMR1 |= 6UL << TIM_CCMR1_OC2M_Pos; 					// OC1M = 110 for PWM Mode 1 output on ch2
		TIMx->CCMR1	|= TIM_CCMR1_OC2PE;                     // Output 1 preload enable (make CCR2 value changable)	
		TIMx->CCR2  = ccVal; 																// Output Compare Register for channel 2 (default duty ratio = 50%)		
		TIMx->CCER &= ~TIM_CCER_CC2P;                       // select output polarity: active high	
		TIMx->CCER  |= TIM_CCER_CC2E;												// Enable output for ch2
	}
	else if(CHn == 3){
		TIMx->CCMR2 &= ~TIM_CCMR2_OC3M;                     // Clear ouput compare mode bits for channel 3
		TIMx->CCMR2 |= 6UL << TIM_CCMR2_OC3M_Pos; 					// OC1M = 110 for PWM Mode 1 output on ch3
		TIMx->CCMR2	|= TIM_CCMR2_OC3PE;                     // Output 1 preload enable (make CCR3 value changable)	
		TIMx->CCR3  = ccVal; 																// Output Compare Register for channel 3 (default duty ratio = 50%)		
		TIMx->CCER &= ~TIM_CCER_CC3P;                      	// select output polarity: active high	
		TIMx->CCER  |= TIM_CCER_CC3E;												// Enable output for ch3
	}
	else if(CHn == 4){
		TIMx->CCMR2 &= ~TIM_CCMR2_OC4M;                     // Clear ouput compare mode bits for channel 3
		TIMx->CCMR2 |= 6UL << TIM_CCMR2_OC4M_Pos; 					// OC1M = 110 for PWM Mode 1 output on ch3
		TIMx->CCMR2	|= TIM_CCMR2_OC4PE;                     // Output 1 preload enable (make CCR3 value changable)	
		TIMx->CCR4  = ccVal; 																// Output Compare Register for channel 3 (default duty ratio = 50%)		
		TIMx->CCER &= ~TIM_CCER_CC4P;                      	// select output polarity: active high	
		TIMx->CCER  |= TIM_CCER_CC4E;	
	}
	
// 5. Enable Timer Counter
	if (TIMx == TIM1) TIMx->BDTR |= TIM_BDTR_MOE;					// Only TIM1; Main output enable (MOE): 0 = Disable, 1 = Enable
	TIMx->CR1 |= TIM_CR1_CEN;															// Enable counter
}

void PWM_period_ms(PWM_t *pwm, uint32_t msec){
	TIM_TypeDef *TIMx = pwm->timer;
	TIM_period_ms(TIMx, msec);
}

void PWM_period_us(PWM_t *pwm, uint32_t usec){
	TIM_TypeDef *TIMx = pwm->timer;
	TIM_period_us(TIMx, usec);
}

void PWM_PulseWidth_ms(PWM_t *pwm, float pulse_width_ms){
	TIM_TypeDef *TIMx = pwm->timer;
	int CHn = pwm->ch;
	uint32_t Freq_sys = 0;
	uint32_t Prescaler = pwm->timer->PSC;
	
	// Check System CLK: PLL or HSI
	if 			( (RCC->CFGR & RCC_CFGR_SW_PLL) == RCC_CFGR_SW_PLL ) Freq_sys = MCU_CLK_PLL;
	else if ( (RCC->CFGR & RCC_CFGR_SW_HSI) == RCC_CFGR_SW_HSI ) Freq_sys = MCU_CLK_HSI;
	
	float Freq_cnt = Freq_sys/(Prescaler + 1);					// 84Mhz / 8400 = 10kHz
	uint16_t ccval = pulse_width_ms / 1000 * Freq_cnt;	// 1ms * 10kHz - 1 = 10 - 1 ;
																										// ex) Timer period = 20ms, Freq CNT = 10kHz => ARR = 200 - 1;
	switch(CHn){																			//		 CCRn = 100 => 0.1ms * 100 = 10ms (High)
		case 1: TIMx->CCR1 = ccval; break;
		case 2: TIMx->CCR2 = ccval; break;
		case 3: TIMx->CCR3 = ccval; break;
		case 4: TIMx->CCR4 = ccval; break;
		default: break;
	}
}

void PWM_PulseWidth_us(PWM_t *pwm, float pulse_width_us){
	TIM_TypeDef *TIMx = pwm->timer;
	int CHn = pwm->ch;
	uint32_t Freq_sys = 0;
	uint32_t Prescaler = pwm->timer->PSC;
	
	// Check System CLK: PLL or HSI
	if 			( (RCC->CFGR & RCC_CFGR_SW_PLL) == RCC_CFGR_SW_PLL ) Freq_sys = MCU_CLK_PLL;
	else if ( (RCC->CFGR & RCC_CFGR_SW_HSI) == RCC_CFGR_SW_HSI ) Freq_sys = MCU_CLK_HSI;
	
	float Freq_cnt = Freq_sys/(Prescaler + 1);					// 84Mhz / 84 = 1MHz
	uint16_t ccval = pulse_width_us / 1000000 * Freq_cnt;	// 1us * 1MHz - 1 = 10 - 1 ;
																										// ex) Timer period = 20us, Freq CNT = 1MHz => ARR = 20 - 1;
	switch(CHn){																			//		 CCRn = 10 => 1us * 10 = 10us (High)
		case 1: TIMx->CCR1 = ccval; break;
		case 2: TIMx->CCR2 = ccval; break;
		case 3: TIMx->CCR3 = ccval; break;
		case 4: TIMx->CCR4 = ccval; break;
		default: break;
	}
}

void PWM_duty(PWM_t *pwm, float duty){			// duty = 0 to 1
	TIM_TypeDef *TIMx = pwm->timer;
	float ccval = (TIMx->ARR + 1) * duty;			// (ARR+1) * dutyRatio
	int CHn = pwm->ch;
	
	switch(CHn){
		case 1: TIMx->CCR1 = ccval; break;
		case 2: TIMx->CCR2 = ccval; break;
		case 3: TIMx->CCR3 = ccval; break;
		case 4: TIMx->CCR4 = ccval; break;
		default: break;
	}
}


void PWM_PinMap(PWM_t *pwm){
	GPIO_TypeDef *port = pwm->port;
   int pin = pwm->pin;
   
   if(port == GPIOA) {
      switch(pin){
         case 0 : pwm->timer = TIM2; pwm->ch = 1; break;
         case 1 : pwm->timer = TIM2; pwm->ch = 2; break;
         case 5 : pwm->timer = TIM2; pwm->ch = 1; break;
         case 6 : pwm->timer = TIM3; pwm->ch = 1; break;
         //case 7: pwm->timer = TIM1; pwm->ch = 1N; break;
         case 8 : pwm->timer = TIM1; pwm->ch = 1; break;
         case 9 : pwm->timer = TIM1; pwm->ch = 2; break;
         case 10: pwm->timer = TIM1; pwm->ch = 3; break;
         case 15: pwm->timer = TIM2; pwm->ch = 1; break;
         default: break;
      }         
   }
   else if(port == GPIOB) {
      switch(pin){
         //case 0: pwm->timer = TIM1; pwm->ch = 2N; break;
         //case 1: pwm->timer = TIM1; pwm->ch = 3N; break;
         case 3 : pwm->timer = TIM2; pwm->ch = 2; break;
         case 4 : pwm->timer = TIM3; pwm->ch = 1; break;
         case 5 : pwm->timer = TIM3; pwm->ch = 2; break;
         case 6 : pwm->timer = TIM4; pwm->ch = 1; break;
         case 7 : pwm->timer = TIM4; pwm->ch = 2; break;
         case 8 : pwm->timer = TIM4; pwm->ch = 3; break;
         case 9 : pwm->timer = TIM4; pwm->ch = 3; break;
         case 10: pwm->timer = TIM2; pwm->ch = 3; break;
         
         default: break;
      }
   }
   else if(port == GPIOC) {
      switch(pin){
         case 6 : pwm->timer = TIM3; pwm->ch = 1; break;
         case 7 : pwm->timer = TIM3; pwm->ch = 2; break;
         case 8 : pwm->timer = TIM3; pwm->ch = 3; break;
         case 9 : pwm->timer = TIM3; pwm->ch = 4; break;
         
         default: break;
      }
   }
	 // TIM5 needs to be added, if used.
}
