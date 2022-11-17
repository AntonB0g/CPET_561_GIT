#include "io.h"
#include <stdio.h>
#include "system.h"
#include <stdbool.h>

// create standard embedded type definitions
typedef   signed char   sint8;              // signed 8 bit values
typedef unsigned char   uint8;              // unsigned 8 bit values
typedef   signed short  sint16;             // signed 16 bit values
typedef unsigned short  uint16;             // unsigned 16 bit values
typedef   signed long   sint32;             // signed 32 bit values
typedef unsigned long   uint32;             // unsigned 32 bit values
typedef         float   real32;


volatile uint32* WORDPtr = (volatile uint32*) INFERRED_RAM_BE_0_BASE;
volatile uint16* HALFPtr = (volatile uint16*) INFERRED_RAM_BE_0_BASE;
volatile uint8* BYTEPtr = (volatile uint8*) INFERRED_RAM_BE_0_BASE;
volatile uint8* LedPtr = (volatile uint8*) LEDS_BASE;
volatile uint32* KeyPtr = (volatile uint32*) PUSHBUTTONS_BASE;
volatile uint32* JTAG_Ptr = (volatile uint32*) JTAG_UART_0_BASE;

uint32 BYTE_test_data = 0x00000000; // actual data is 0x00
uint32 HALF_test_data = 0x00001234;// actual data is 0x1234
uint32 WORD_test_data = 0xABCDEF90;// already actual data
uint8  byte_data = 0x01;
uint32 byte_num = 0x00000000;
uint16 half_data = 0x0000;
uint32 halfs = 0x00000000;
uint32 words = 0x00000000;
const char str[17]= "RAM Test is Done!";
bool Test = true;


uint32 start_address =  0x00000000;

void RAM_test(uint32 s_address, uint32 ram_size, uint32 test_data, uint32 access_size)
{
	switch(access_size){
	case 8:
			byte_data = (uint8) test_data;
			byte_num = ram_size; // number 32 bit WORDS is 512 in 16 Bytes of data

			for (uint32 i = byte_num -1; i > 0; i--)
			{
				*(BYTEPtr + i) = test_data;
			};

			for (uint32 i = byte_num-1; i > 0; i--)
			{
				uint32 temp = *(BYTEPtr + i);
				if (temp != test_data) // data written does not equal to data read => error
				{
					*LedPtr = 0xff;
					printf("Error-> Address: 0x%x, Read: 0x%x, Expected: 0x%x", i, test_data, temp);
				}

				else
				{
					*LedPtr = 0x00;
				}
			}
			break;
	case 16:
			half_data = (uint16) test_data;
			halfs = ram_size/2; // number 32 bit WORDS is 512 in 16 Bytes of data

			for (uint32 i = halfs -1; i > 0; i--)
			{
				*(HALFPtr + i) = test_data;
			};

			for (uint32 i = halfs-1; i > 0; i--)
			{
				uint32 temp = *(HALFPtr + i);
				if (temp != test_data) // data written does not equal to data read => error
				{
					*LedPtr = 0xff;
					printf("Error-> Address: 0x%x, Read: 0x%x, Expected: 0x%x", i*2, test_data, temp);
				}

				else
				{
					*LedPtr = 0x00;
				}
			}
			break;
	case 32:
			words = ram_size/4; // number 32 bit WORDS is 512 in 16 Bytes of data

			for (uint32 i = words -1; i > 0; i--)
			{
				*(WORDPtr + i) = test_data;
			};

			for (uint32 i = words-1; i > 0; i--)
			{
				uint32 temp = *(WORDPtr + i);
				if (temp != test_data) // data written does not equal to data read => error
				{
					*LedPtr = 0xff;
					printf("Error-> Address: 0x%x, Read: 0x%x, Expected: 0x%x", i*4, test_data, temp);
				}

				else
				{
					*LedPtr = 0x00;
				}
			}
			break;
		}
}

void JTAG_msg_sender( const char *str, uint8 length)
{
	for (uint8 i = 0; i < length; i++)
	{
		*(JTAG_Ptr) = str[i];
	}
}

void ISR()
{

	Test = false;
	*LedPtr = 0b010101010;
	JTAG_msg_sender(str, 17);
	*(KeyPtr + 3) = 0; // EdgeCapture reset
}

int main()
{
	*LedPtr = 0x00;
	alt_ic_isr_register(PUSHBUTTONS_IRQ_INTERRUPT_CONTROLLER_ID,PUSHBUTTONS_IRQ,ISR,0,0);
	*(KeyPtr+2) = 0x2; //set the interrupt mask for KEY1
	while(Test){
		RAM_test(start_address, 16384, WORD_test_data, 32);
		*LedPtr = 0x00;
		RAM_test(start_address, 16384, BYTE_test_data, 8);
		*LedPtr = 0x00;
		RAM_test(start_address, 16384, HALF_test_data, 16);
		*LedPtr = 0x00;
	};
  return 0;
}
