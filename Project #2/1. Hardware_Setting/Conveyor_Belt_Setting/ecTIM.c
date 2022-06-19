#include "ecTIM.h"
#include "ecGPIO.h"
#include "ecSysTick.h"

void TIM_init(TIM_TypeDef* TIMx, uint32_t msec){
	
// 1. Enable Timer CLOCK
	if 			(TIMx == TIM1) RCC->APB2ENR |= RCC_APB2ENR_TIM1EN;
	else if (TIMx == TIM2) RCC->APB1ENR |= RCC_APB1ENR_TIM2EN;
	else if (TIMx == TIM3) RCC->APB1ENR |= RCC_APB1ENR_TIM3EN;
	else if (TIMx == TIM4) RCC->APB1ENR |= RCC_APB1ENR_TIM4EN;
	else if (TIMx == TIM5) RCC->APB1ENR |= RCC_APB1ENR_TIM5EN;
	else if (TIMx == TIM9) RCC->APB2ENR |= RCC_APB2ENR_TIM9EN;
	else if (TIMx == TIM10) RCC->APB2ENR |= RCC_APB2ENR_TIM10EN;
	else if (TIMx == TIM11) RCC->APB2ENR |= RCC_APB2ENR_TIM11EN;
	
// 2. Set CNT period
	TIM_period_ms(TIMx, msec);
	
// 3. CNT Direction
	TIMx->CR1 &= ~(1UL << 4);	// 0 : up-counter , 1 : down-counter; DIR is on 4
	
// 4. Enable Timer Counter
	TIMx->CR1 |= 1UL << 0;
	
}

void TIM_CNT_DIR(TIM_TypeDef*TIMx, uint32_t direction){
	// 0 : up-counter , 1 : down-counter; DIR is on 4
	if (direction == UP_CNT)
		TIMx->CR1 &= ~(1UL << 4);	
	else if (direction == DOWN_CNT){
		TIMx->CR1 &= ~(1UL << 4);
		TIMx->CR1 |= 1UL << 4;
	}
}
void TIM_period_us(TIM_TypeDef* TIMx, uint32_t usec){
	// period usec = 1 to 1000;
	
	// ARR = 1 -> 1us(1MHz)
	// ARR = 0xFFFF = 65535 -> 65msec
	
	uint32_t Freq_sys = 0;
	uint16_t PSCval = 0;
	
	if 			( (RCC->CFGR & RCC_CFGR_SW_PLL) == RCC_CFGR_SW_PLL ) {
		Freq_sys = MCU_CLK_PLL;
		PSCval = 84;
	}
	else if ( (RCC->CFGR & RCC_CFGR_SW_HSI) == RCC_CFGR_SW_HSI ) {
		Freq_sys = MCU_CLK_HSI;
		PSCval = 16;
	}
	
	if (TIMx == TIM2){
		uint32_t ARRval_32 = 84/PSCval * usec;
		TIMx->ARR = ARRval_32 - 1;
	}
	else{
		uint16_t ARRval = 84/PSCval * usec;
		TIMx->ARR = ARRval - 1;
	}
//	uint16_t Freq_cnt = Freq_sys / PSCval;				//	1MHz
//	uint16_t ARRval = (uint16_t) usec * 1;  			// 1us * 1MHz = 1 = ARR+1
	
	TIMx->PSC = PSCval - 1;
//	TIMx->ARR = ARRval - 1;
}

void TIM_period_ms(TIM_TypeDef* TIMx, uint32_t msec){
	
	uint32_t Freq_sys = 0;
	uint16_t PSCval = 0;
	
	if 			( (RCC->CFGR & RCC_CFGR_SW_PLL) == RCC_CFGR_SW_PLL ) {
		Freq_sys = MCU_CLK_PLL;
		PSCval = 8400;
	}
	else if ( (RCC->CFGR & RCC_CFGR_SW_HSI) == RCC_CFGR_SW_HSI ) {
		Freq_sys = MCU_CLK_HSI;
		PSCval = 1600;
	}
	
	//uint16_t Freq_cnt = Freq_sys / PSCval;					//	10kHz
	uint16_t ARRval = (uint16_t) msec * 10;			

	TIMx->PSC = PSCval - 1;
	TIMx->ARR = ARRval - 1;
}

void TIM_Interrupt_init(TIM_TypeDef* TIMx, uint32_t msec, uint32_t priority){
// 1. Initialize Timer
	TIM_init(TIMx, msec);
	
// 2. Enable Update Interrupt
//	TIM_Interrupt_enable(TIMx);

// 3. NVIC Setting
	uint32_t IRQn_reg = 0;
	if 			(TIMx == TIM1) 	IRQn_reg = TIM1_UP_TIM10_IRQn;
	else if (TIMx == TIM2)	IRQn_reg = TIM2_IRQn;	
	else if (TIMx == TIM3)	IRQn_reg = TIM3_IRQn;
	else if (TIMx == TIM4)	IRQn_reg = TIM4_IRQn;
	else if (TIMx == TIM5)	IRQn_reg = TIM5_IRQn;
	else if (TIMx == TIM9)	IRQn_reg = TIM1_BRK_TIM9_IRQn;
	else if (TIMx == TIM10)	IRQn_reg = TIM1_UP_TIM10_IRQn;
	else if (TIMx == TIM11)	IRQn_reg = TIM1_TRG_COM_TIM11_IRQn;
	
	NVIC_EnableIRQ(IRQn_reg);
//	NVIC_SetPriority(IRQn_reg, 2);
	NVIC_SetPriority(IRQn_reg, priority);
	

}

void TIM_Interrupt_enable(TIM_TypeDef* TIMx){
	TIMx->DIER |= 1UL << 0 ;		// Enable Timer Update Interrupt (UIE)
}

void TIM_Interrupt_disable(TIM_TypeDef* TIMx){
	TIMx->DIER &= ~(1UL << 0);	// Disable Timer Update Interrupt (UIE)
}

uint32_t Is_UIF(TIM_TypeDef* TIMx){
	return TIMx->SR & TIM_SR_UIF;
}

void Clear_UIF(TIM_TypeDef* TIMx){
	TIMx->SR &= ~(1UL << 0);	//	~TIM_SR_UIF
}

/* Input Capture  */
void ICAP_init(IC_t *ICx, GPIO_TypeDef *port, int pin, uint32_t priority){
// 0. Match Input Capture Port and Pin for TIMx
	ICx->port = port;
	ICx->pin  = pin;
	ICAP_pinmap(ICx);	  										// Port, Pin --(mapping)--> TIMx, Channel
	
	TIM_TypeDef *TIMx = ICx->timer;
	int TIn = ICx->ch; 		
	int ICn=TIn;
	ICx->ICnum=ICn;													// (default) TIx=ICx

// GPIO configuration ---------------------------------------------------------------------	
// 1. Initialize GPIO port and pin as AF
	GPIO_init(port,pin, AF);  							// GPIO init as AF=2
	GPIO_ospeed(port, pin, HIGH_SPEED);  						// speed VHIGH=3	

// 2. Configure GPIO AFR by Pin num.
	
	if(TIMx == TIM1 || TIMx == TIM2){
		port->AFR[pin >> 3] &= ~(0x0F << (4*(pin % 8)));
		port->AFR[pin >> 3] |= 0x01 << (4*(pin % 8)); 				// TIM1~2
	}
	else if  (TIMx == TIM3 || TIMx == TIM4 || TIMx == TIM5){
		port->AFR[pin >> 3] &= ~(0x0F << (4*(pin % 8)));
		port->AFR[pin >> 3] |= 0x02 << (4*(pin % 8)); 				// TIM3~5
	}
	else if  (TIMx == TIM9 || TIMx == TIM10 || TIMx == TIM11){
		port->AFR[pin >> 3] &= ~(0x0F << (4*(pin % 8)));
		port->AFR[pin >> 3] |= 0x03 << (4*(pin % 8)); 				// TIM9~11
	}

	
// TIMER configuration ---------------------------------------------------------------------			
// 1. Initialize Timer 
	TIM_init(TIMx, 1);
// 2. Initialize Timer Interrpt 
	TIM_Interrupt_init(TIMx, 1, priority);        					// TIMx Interrupt initialize 
// 3. Modify ARR Maxium for 1MHz
	TIMx->PSC = 84 - 1;						  					// Timer counter clock: 1MHz(1us)  for PLL
	TIMx->ARR = 0xFFFF;											// Set auto reload register to maximum (count up to 65535)
// 4. Disable Counter during configuration
	TIMx->CR1 &= ~TIM_CR1_CEN;  						// Disable Counter during configuration

	
// Input Capture configuration ---------------------------------------------------------------------			
// 1. Select Timer channel(TIx) for Input Capture channel(ICx)
	// Default Setting
	TIMx->CCMR1 &= 	~TIM_CCMR1_CC1S;
	TIMx->CCMR1 &= 	~TIM_CCMR1_CC2S;
	TIMx->CCMR2 &= 	~TIM_CCMR2_CC3S;
	TIMx->CCMR2 &= 	~TIM_CCMR2_CC4S;
	TIMx->CCMR1 |= 	TIM_CCMR1_CC1S_0;      	//01<<0   CC1S    TI1=IC1
	TIMx->CCMR1 |= 	TIM_CCMR1_CC2S_0;  			//01<<8   CC2s    TI2=IC2
	TIMx->CCMR2 |= 	TIM_CCMR2_CC3S_0;       //01<<0   CC3s    TI3=IC3
	TIMx->CCMR2 |= 	TIM_CCMR2_CC4S_0;  			//01<<8   CC4s    TI4=IC4

// 2. Filter Duration (use default)

// 3. IC Prescaler (use default)

// 4. Activation Edge: CCyNP/CCyP	
	TIMx->CCER &= ~(5UL << (4*(ICn-1)+1));			// CCy(Rising) for ICn

// 5.	Enable CCy Capture, Capture/Compare interrupt
	TIMx->CCER |= 1UL << (4*(ICn-1));					// CCn(ICn) Capture Enable	

// 6.	Enable Interrupt of CC(CCyIE), Update (UIE)
	TIMx->DIER |= 1UL << ICn;					// Capture/Compare Interrupt Enable	for ICn
	TIMx->DIER |= TIM_DIER_UIE;			// Update Interrupt enable	

// 7.	Enable Counter 
	TIMx->CR1	 |= TIM_CR1_CEN;							// Counter enable	
}


// Configure Selecting TIx-ICy and Edge Type
void ICAP_setup(IC_t *ICx, int ICn, int edge_type){
	TIM_TypeDef *TIMx = ICx->timer;	// TIMx
	int 				CHn 	= ICx->ch;		// Timer Channel CHn
	ICx->ICnum=ICn;

// Disable  CC. Disable CCInterrupt for ICn. 
	TIMx->CCER &= ~(1UL << (4*(ICn-1)));						// Capture Disable
	TIMx->DIER &= ~(1UL << ICn);										// CCn Interrupt Disable	
	
	
// Configure  IC number(user selected) with given IC pin(TIMx_CHn)
	switch(ICn){
			case 1:
					TIMx->CCMR1 &= ~TIM_CCMR1_CC1S;											//reset   CC1S
					if (ICn==CHn) TIMx->CCMR1 |= 	TIM_CCMR1_CC1S_0;     //01<<0   CC1S    Tx_Ch1=IC1
					else TIMx->CCMR1 |= 	TIM_CCMR1_CC1S_1;      				//10<<0   CC1S    Tx_Ch2=IC1
					break;
			case 2:
					TIMx->CCMR1 &= ~TIM_CCMR1_CC2S;											//reset   CC2S
					if (ICn==CHn) TIMx->CCMR1 |= TIM_CCMR1_CC2S_0;     	//01<<0   CC2S    Tx_Ch2=IC2
					else TIMx->CCMR1 |= TIM_CCMR1_CC2S_1;     					//10<<0   CC2S    Tx_Ch1=IC2
					break;
			case 3:
					TIMx->CCMR2 &= ~TIM_CCMR2_CC3S;											//reset   CC3S
					if (ICn==CHn) TIMx->CCMR2 |= TIM_CCMR2_CC3S_0;	    //01<<0   CC3S    Tx_Ch3=IC3
					else TIMx->CCMR2 |= TIM_CCMR2_CC3S_1;		     				//10<<0   CC3S    Tx_Ch4=IC3
					break;
			case 4:
					TIMx->CCMR2 &= ~TIM_CCMR2_CC4S;											//reset   CC4S
					if (ICn==CHn) TIMx->CCMR2 |= TIM_CCMR2_CC4S_0;	   	//01<<0   CC4S    Tx_Ch4=IC4
					else TIMx->CCMR2 |= TIM_CCMR2_CC4S_1;	     					//10<<0   CC4S    Tx_Ch3=IC4
					break;
			default: break;
		}


// Configure Activation Edge direction
	TIMx->CCER  &= ~(5UL << (4*(ICn-1)+1));								// Clear CCnNP/CCnP bits for ICn
	switch(edge_type){
		case RISE_TIM: TIMx->CCER |= 0UL << (4*(ICn-1)+1);	 break; //rising:  00
		case FALL_TIM: TIMx->CCER |= 1UL << (4*(ICn-1)+1);	 break; //falling: 01
		case BOTH_TIM: TIMx->CCER |= 5UL << (4*(ICn-1)+1);	 break; //both:    11
	}
	
// Enable CC. Enable CC Interrupt. 
	TIMx->CCER |= 1 << (4*(ICn - 1)); 										// Capture Enable
	TIMx->DIER |= 1 << ICn; 															// CCn Interrupt enabled	
}



// Time span for one counter step
void ICAP_counter_us(IC_t *ICx, int usec){	
	TIM_TypeDef *TIMx = ICx->timer;	
	TIMx->PSC = 84*usec - 1;						  // Timer counter clock: 1us * usec
	TIMx->ARR = 0xFFFF;									// Set auto reload register to maximum (count up to 65535)
}


uint32_t Is_CCIF(TIM_TypeDef *TIMx, uint32_t ccNum){
	return (TIMx->SR & 	(1UL << ccNum)) != 0;
}

void Clear_CCIF(TIM_TypeDef *TIMx, uint32_t ccNum){
	TIMx->SR &= ~(1UL << ccNum);	
}



//DO NOT MODIFY THIS
void ICAP_pinmap(IC_t *timer_pin){
   GPIO_TypeDef *port = timer_pin->port;
   int pin = timer_pin->pin;
   
   if(port == GPIOA) {
      switch(pin){
         case 0 : timer_pin->timer = TIM2; timer_pin->ch = 1; break;
         case 1 : timer_pin->timer = TIM2; timer_pin->ch = 2; break;
         case 5 : timer_pin->timer = TIM2; timer_pin->ch = 1; break;
         case 6 : timer_pin->timer = TIM3; timer_pin->ch = 1; break;
         //case 7: timer_pin->timer = TIM1; timer_pin->ch = 1N; break;
         case 8 : timer_pin->timer = TIM1; timer_pin->ch = 1; break;
         case 9 : timer_pin->timer = TIM1; timer_pin->ch = 2; break;
         case 10: timer_pin->timer = TIM1; timer_pin->ch = 3; break;
         case 15: timer_pin->timer = TIM2; timer_pin->ch = 1; break;
         default: break;
      }         
   }
   else if(port == GPIOB) {
      switch(pin){
         //case 0: timer_pin->timer = TIM1; timer_pin->ch = 2N; break;
         //case 1: timer_pin->timer = TIM1; timer_pin->ch = 3N; break;
         case 3 : timer_pin->timer = TIM2; timer_pin->ch = 2; break;
         case 4 : timer_pin->timer = TIM3; timer_pin->ch = 1; break;
         case 5 : timer_pin->timer = TIM3; timer_pin->ch = 2; break;
         case 6 : timer_pin->timer = TIM4; timer_pin->ch = 1; break;
         case 7 : timer_pin->timer = TIM4; timer_pin->ch = 2; break;
         case 8 : timer_pin->timer = TIM4; timer_pin->ch = 3; break;
         case 9 : timer_pin->timer = TIM4; timer_pin->ch = 3; break;
         case 10: timer_pin->timer = TIM2; timer_pin->ch = 3; break;
         
         default: break;
      }
   }
   else if(port == GPIOC) {
      switch(pin){
         case 6 : timer_pin->timer = TIM3; timer_pin->ch = 1; break;
         case 7 : timer_pin->timer = TIM3; timer_pin->ch = 2; break;
         case 8 : timer_pin->timer = TIM3; timer_pin->ch = 3; break;
         case 9 : timer_pin->timer = TIM3; timer_pin->ch = 4; break;
         
         default: break;
      }
   }
}