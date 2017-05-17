//--------------------------------------------------------------
// file : srf08.h
// Original File     : stm32_ub_i2c1.h
//--------------------------------------------------------------

/*
for example, to read from 0xE0:
To start the SRF08 ranging you would write 0x51 to the command register at 0x00 like this:
1. Send a start sequence
2. Send 0xE0 ( I2C address of the SRF08 with the R/W bit low (even address)
3. Send 0x00 (Internal address of the command register)
4. Send 0x51 (The command to start the SRF08 ranging)
5. Send the stop sequence.
*/

/*
1. Send a start sequence
2. Send 0xE0 ( I2C address of the CMPS03 with the R/W bit low (even address)
3. Send 0x01 (Internal address of the bearing register)
4. Send a start sequence again (repeated start)
5. Send 0xE) ( I2C address of the CMPS03 with the R/W bit high (odd address)
6. Read 8 bit data from register 2, as the leftmost from 16 bit
7. Read 8 bit data from register 3, as the rightmost from 16 bit
8. Send the stop sequence.
*/
//--------------------------------------------------------------
#ifndef _I2C1_H_
#define _I2C1_H_


//--------------------------------------------------------------
// Includes
//--------------------------------------------------------------
#include "main.h"

//--------------------------------------------------------------
// I2C-Clock
// Grundfrequenz (I2C1)= APB1 (APB1=42MHz)
// Mögliche Einstellungen = 100000 = 100 kHz
//--------------------------------------------------------------
#define   I2C1_CLOCK_FRQ   40000  // I2C-Frq in Hz (100 kHz)


//--------------------------------------------------------------
// beroda and berkaki might have different timeout value. Because
// the shorter I2C_TIMEOUT is set, the shorter the maximum range will be.
// for maximum range of 50 cm, 1150 is suitable.
//-------------------------------------------------------------- 
#define   I2C1_TIMEOUT     20000//550//1150//0x3000 = 0b12288, 0x3000  // counter loop timeout

//--------------------------------------------------------------
// structure of the pin
//--------------------------------------------------------------
typedef struct {
  GPIO_TypeDef* PORT;     // Port
  const uint16_t PIN;     // Pin
  const uint32_t CLK;     // Clock
  const uint8_t SOURCE;   // Source
}I2C1_PIN_t; 


//--------------------------------------------------------------
// Struktur vom I2C-Device
//--------------------------------------------------------------
typedef struct {
  I2C1_PIN_t  SCL;       // Clock-Pin
  I2C1_PIN_t  SDA;       // Data-Pin
}I2C1_DEV_t;

uint16_t maxRange;
void i2c_init(void);
int16_t UB_I2C1_ReadByte(uint8_t slave_adr, uint8_t adr);
void UB_I2C1_WriteByte(uint8_t slave_adr, uint8_t adr, uint8_t wert);
void UB_I2C1_Delay(volatile uint32_t nCount);
void sonarSetRange(uint8_t addr, uint16_t jauh);
void sonarSetGain(uint8_t addr, uint16_t gain);
void sonarRange(uint8_t addr);
uint16_t sonarGet(uint8_t addr);
void srf08Addressing(uint8_t oldAddr, uint8_t newAddr);
void tpaSetServo(unsigned char position);
uint16_t tpaRead(unsigned char pixelNum);
uint16_t getTpa81();
short position;
short tpaScanGetPosition();

//--------------------------------------------------------------
#endif // __STM32F4_UB_I2C1_H
