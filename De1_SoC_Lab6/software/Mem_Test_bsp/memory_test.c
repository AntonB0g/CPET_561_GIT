#include "io.h"
#include <stdio.h>
#include "system.h"

// create standard embedded type definitions
typedef   signed char   sint8;              // signed 8 bit values
typedef unsigned char   uint8;              // unsigned 8 bit values
typedef   signed short  sint16;             // signed 16 bit values
typedef unsigned short  uint16;             // unsigned 16 bit values
typedef   signed long   sint32;             // signed 32 bit values
typedef unsigned long   uint32;             // unsigned 32 bit values
typedef         float   real32;


volatile uint32* RAMPtr = (volatile uint32*) RAM_INFR_CUSTOM_IP_0_BASE;
volatile uint8* LedPtr = (volatile uint8*) LEDS_BASE;

uint32 data = 0x00000001;
uint32 start_address =  0x00000000;

void RAM_test(uint32 s_address, uint32 byte_num, uint32 test_data)
{
	uint32 words = byte_num/4; // number 32 bit WORDS is 512 in 16 Bytes of data

	for (uint32 i = words -1; i > 0; i--)
	{
		*(RAMPtr + i) = test_data;
	};

	for (uint32 i = words-1; i > 0; i--)
	{
		uint32 temp = *(RAMPtr + i);
		if (temp != test_data) // data written does not equal to data read => error
		{
			*LedPtr = 0xff;
		}

		else
		{
			*LedPtr = 0x00;
		}
	}
}

/*
 * This function is not used. Demonstration purpose to access 16-bit memory.
void RAM_test_16(uin16 s_address, uint32 byte_num, uint16 test_data)
{
	bit_num = byte_num/2;

	for (uint16 i = words -1; i > 0; i--)
	{
		*(RAMPtr + i) = test_data;
	};

	for (uint16 i = words-1; i > 0; i--)
	{
		uint32 temp = *(RAMPtr + i);
	    if (temp != test_data) // data written does not equal to data read => error
	    {
	        *LedPtr = 0xff;
	    }

	    else
	    {
	    	*LedPtr = 0x00;
	    }
	}
}
*/

int main()
{
	*LedPtr = 0x00;
	while(1){
		RAM_test(start_address, 16384, data);
	};
  return 0;
}
