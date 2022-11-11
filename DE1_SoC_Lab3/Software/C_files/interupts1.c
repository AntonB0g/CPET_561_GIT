#include "io.h"
#include <stdio.h>
#include "system.h"
#include "alt_types.h"
#include "sys/alt_irq.h"
#include "altera_avalon_timer_regs.h"
#include "altera_avalon_timer.h"

// create standard embedded type definitions
typedef   signed char   sint8;              // signed 8 bit values
typedef unsigned char   uint8;              // unsigned 8 bit values
typedef   signed short  sint16;             // signed 16 bit values
typedef unsigned short  uint16;             // unsigned 16 bit values
typedef   signed long   sint32;             // signed 32 bit values
typedef unsigned long   uint32;             // unsigned 32 bit values
typedef         float   real32;

uint8 Numbers[10] = {0x40, 0x79, 0x24, 0x30, 0x19, 0x12, 0x2, 0x78, 0x0, 0x10};


volatile uint32* Hex0Ptr = (volatile uint32*)HEX0_BASE;
volatile uint32* KeyPtr  = (volatile uint32*)PUSHBUTTONS_BASE;
volatile uint32* LedPtr  = (volatile uint32*)LEDS_BASE;
volatile uint32* SWPtr   = (volatile uint32*)SWITCHES_BASE;
volatile uint8 idx = 0x0;

void display()
{
	*Hex0Ptr = Numbers[idx];
}

void SW_check()
{
	if(*SWPtr == 1)
	{
		if(idx < 9)
		{
			idx++;
		}
	}
	else
	{
		if(inx > 0)
		{
			idx--;
		}
}

void ISR(void *context)
{
SW_check();
display();
*(KeyPtr + 3) = 0; // EdgeCapture reset
}

int main(void)
{
    alt_ic_isr_register(PUSHBUTTONS_IRQ_INTERRUPT_CONTROLLER_ID,PUSHBUTTONS_IRQ_TYPE,ISR,0,0);
    
    while(1)
    {
        while((*KeyPtr & 2) == 2)
	    {
	    };

        while((*KeyPtr & 2) == 0)
	    {
	    };
    };
}
