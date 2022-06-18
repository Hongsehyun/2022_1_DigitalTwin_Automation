#include "ecRCC.h"
#include "ecGPIO.h"
#include "ecEXTI.h"
#include "ecSysTick.h"
#include "myFunction.h"

static volatile uint32_t Ticks = 0;
static volatile uint32_t curTicks;

// SysTick Setting --------------------------------------
void SysTick_init(uint32_t Tick_Period_ms){
	//  SysTick Control and Status Register
	SysTick->CTRL = 0;				// Disable SysTick IRQ and SysTick Counter

	// Select processor clock
	// 1 = processor clock;  0 = external clock
	SysTick->CTRL |= 1UL << 2;

	// uint32_t MCU_CLK=EC_SYSTEM_CLK
	// SysTick Reload Value Register
	SysTick->LOAD |= MCU_SYS_CLK * Tick_Period_ms * UNIT_MILLI - 1; 	// 1ms
	//SysTick->LOAD |= MCU_SYS_CLK * UNIT_MILLI - 1; 	// 1ms

	// Clear SysTick Current Value 
	SysTick->VAL = 0;

	// Enables SysTick exception request
	// 1 = counting down to zero asserts the SysTick exception request
	SysTick->CTRL |= 1UL << 1;
		
	// Enable SysTick IRQ and SysTick Timer
	SysTick_Enable();
	
	NVIC_SetPriority(SysTick_IRQn, 16);		// Set Priority to 1
	NVIC_EnableIRQ(SysTick_IRQn);			// Enable interrupt in NVIC
}

void SysTick_init_us(uint32_t Tick_Period_us){
	//  SysTick Control and Status Register
	SysTick->CTRL &= ~1UL;				// Disable SysTick IRQ and SysTick Counter

	// Select processor clock
	// 1 = processor clock;  0 = external clock
	SysTick->CTRL |= 1UL << 2;

	// uint32_t MCU_CLK=EC_SYSTEM_CLK
	// SysTick Reload Value Register
	SysTick->LOAD |= MCU_SYS_CLK * Tick_Period_us * UNIT_MICRO - 1; 	// 1ms
	//SysTick->LOAD |= MCU_SYS_CLK * UNIT_MILLI - 1; 	// 1ms

	// Clear SysTick Current Value 
	SysTick->VAL = 0;

	// Enables SysTick exception request
	// 1 = counting down to zero asserts the SysTick exception request
	SysTick->CTRL |= 1UL << 1;
		
	// Enable SysTick IRQ and SysTick Timer
	SysTick_Enable();
	
	NVIC_SetPriority(SysTick_IRQn, 16);		// Set Priority to 1
	NVIC_EnableIRQ(SysTick_IRQn);			// Enable interrupt in NVIC
}

void delay_ms(uint32_t msec){
	curTicks = Ticks;
	while ( (Ticks - curTicks) < msec );
}

void delay_us(uint32_t usec){
	curTicks = Ticks;
	while ( (Ticks - curTicks) < usec );
}

uint32_t SysTick_val(void){
	return SysTick->VAL;
}


void SysTick_Enable(void){
	SysTick->CTRL |= SysTick_CTRL_ENABLE_Msk;
}

void SysTick_Disable(void){
	SysTick->CTRL &= ~SysTick_CTRL_ENABLE_Msk;
}

void SysTick_Handler(void){
	Ticks++;
}