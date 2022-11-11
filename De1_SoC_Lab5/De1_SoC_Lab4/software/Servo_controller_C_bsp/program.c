#include "io.h"
#include <stdio.h>
#include <stdbool.h>
#include "system.h"
#include "alt_types.h"
#include "sys/alt_irq.h"


// create standard embedded type definitions
typedef   signed char   sint8;              // signed 8 bit values
typedef unsigned char   uint8;              // unsigned 8 bit values
typedef   signed short  sint16;             // signed 16 bit values
typedef unsigned short  uint16;             // unsigned 16 bit values
typedef   signed long   sint32;             // signed 32 bit values
typedef unsigned long   uint32;             // unsigned 32 bit values
typedef         float   real32;


volatile uint32* ServoPtr = (volatile uint32*)SERVO_CONTROLLER_IP_0_BASE;
volatile uint32* Hex0Ptr  = (volatile uint32*)HEX0_BASE;
volatile uint32* Hex1Ptr  = (volatile uint32*)HEX1_BASE;
volatile uint32* Hex2Ptr  = (volatile uint32*)HEX2_BASE;
volatile uint32* Hex4Ptr  = (volatile uint32*)HEX4_BASE;
volatile uint32* Hex5Ptr  = (volatile uint32*)HEX5_BASE;
volatile uint32* KeyPtr   = (volatile uint32*)PUSHBUTTONS_BASE;
volatile uint32* SWPtr    = (volatile uint32*)SWITCHES_BASE;
volatile uint32 input    = 0x00000000;// strat at 45 degrees angle
volatile uint32 min_ang  = 0x0000C350;// 45 deg or 50k tics in HEX
volatile uint32 max_ang  = 0x000186A0;// 135 deg or 100k tics in HEX
bool displayFlag = false;

uint8 Numbers[10] = {0x40, 0x79, 0x24, 0x30, 0x19, 0x12, 0x2, 0x78, 0x0, 0x10};

int angle_convert_tics(int x)
{
    return(555.56*x+25000);// equation is based on 45 deg - 50K tics; 90 deg - 75k  tics; 135 - 100k tics
}

void update_display()
{
    int min_tenth = min_ang/10;
    int min_dig   = min_ang % 10;

    int max_hund  = max_ang/100;
    int max_tenth = max_ang/10;
    int max_dig   = max_ang % 10;

    if(displayFlag == true)
    {
        *Hex0Ptr = Numbers[max_dig];   /* set HEX0 to display digits of the max value */
        *Hex1Ptr = Numbers[max_tenth]; /* set HEX1 to display tenth of the max value */
        *Hex2Ptr = Numbers[max_hund];  /* set HEX2 to display hundreds of the max value */
        *Hex4Ptr = Numbers[min_dig];   /* set HEX4 to display digits of the min value */
        *Hex5Ptr = Numbers[min_tenth]; /* set HEX5 to display tenth of min value */
    }
}

void ISR()
{
    input = *SWPtr;
    //This function checks what key is pressed (two or three) by masking KeyPtr
    if (*KeyPtr & 0x4) // KEY2 is pressed
    {
        if (input >= min_ang) // check for the input, if input is smaller than minimum allowed value => do nothing
        {
            min_ang = angle_convert_tics(input);
        }
    }
    else // KEY3 is pressed
    {
        if (input <= max_ang) // check for the input, if input is bigger than maximum allowed value => do nothing
        {
            max_ang = angle_convert_tics(input);
        }
    }

    *(KeyPtr + 3) = 0; // EdgeCapture reset
}

void Servo_ISR()
{
    //write to the min and max register of the ServoController_ip
    displayFlag = true;
    *(ServoPtr + 0) = min_ang; // updating minimum angle and writting it to the MIN register
    *(ServoPtr + 1) = max_ang; // updating maximum angle and writting it to the MAX register
    update_display();
}

int main()
{

    *(ServoPtr + 0) = 50000; // updating minimum angle and writting it to the MIN register
    *(ServoPtr + 1) = 100000; // updating maximum angle and writting it to the MAX register
    alt_ic_isr_register(PUSHBUTTONS_IRQ_INTERRUPT_CONTROLLER_ID,PUSHBUTTONS_IRQ,ISR,0,0); //setup Pushbutton Interrupt
    alt_ic_isr_register(SERVO_CONTROLLER_IP_0_IRQ_INTERRUPT_CONTROLLER_ID, SERVO_CONTROLLER_IP_0_IRQ,Servo_ISR,0,0); // setup Servo Interrupt

    *Hex0Ptr = Numbers[0]; /* set HEX0 to display 0 */
    *Hex1Ptr = Numbers[0]; /* set HEX1 to display 0 */
    *Hex2Ptr = Numbers[0]; /* set HEX2 to display 0 */
    *Hex4Ptr = Numbers[0]; /* set HEX4 to display 0 */
    *Hex5Ptr = Numbers[0]; /* set HEX5 to display 0 */

    *(KeyPtr + 2) = 0xC;// set the interrupt mask for KEY2 and KEY3 (1100)

     while(1)
    {
    };

    return 0;
}
