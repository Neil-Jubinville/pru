// Author:  Neil Jubinville
// Simple WS2812 LED driver 
// TI PRU
// This app drives one pixel - yay. 

#include <pru/io.h>
#include "resource_table_0.h"


static void delay_ns(unsigned int nano)
{
    
        if (nano == 35)
           __delay_cycles( 70 );
        if (nano == 70)
            __delay_cycles( 140 );
        if (nano == 60)
            __delay_cycles( 120 );
        if (nano == 80)
            __delay_cycles( 160 );
        if (nano == 50)
            __delay_cycles( 15000 );
            
}


static void sendLow(double nanoseconds){
        write_r30(0x0000);
        delay_ns(nanoseconds);
}

static void sendHigh(int nanoseconds){
        write_r30(0xffff);
        delay_ns(nanoseconds);
}


static void zero(){
        sendHigh(35);  // .35 microseconds
        sendLow(80);
}

static void one(){
        sendHigh(70);
        sendLow(60);
}



static void endFrame(){

  sendLow(50);

}

int main(void)
{

// simple program illustrating bit banging the WS2812 LED - rudimentary driver to test timings

for(;;){

    endFrame();
    
    //green byte - 
    one();
    one();
    one();
    one();
    one();
    one();
    one();
    one();

    //red byte
    zero();
    zero();
    zero();
    zero();
    zero();
    zero();
    zero();
    zero();

    //blue byte
    one();
    zero();
    one();
    zero();
    one();
    zero();
    one();
    one();

}

        return 0;

}
