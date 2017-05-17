/* 8/10/2014
 * Adika Bintang Sulaeman, Beroda 2012
 * This library is used for SRF08 or SRF10 and TPA81
 * It uses I2C1, with available SCL on PB6, SDA on PB7.
 * Make sure SDA and SCL have pull-up resistors, which the value can be set
 * from 1k8 to 4k7, but 1k8 to 2k is preferable.
 *
 * If there is something weird when reading shorter or longer distance, try
 * to change the value of I2C1_TIMEOUT. The smaller it is, the shorter minimum value
 * it can read, and vice versa.
 *
 * dependencies: As listed in #include
 */

//credit to:
//--------------------------------------------------------------
// File     : stm32_ub_i2c1.c
// Datum    : 07.03.2013
// Version  : 1.0
// Author    : UB
// EMail    : mc-4u(@)t-online.de
// Web      : www.mikrocontroller-4u.de
// CPU      : STM32F4
// IDE      : CooCox CoIDE 1.7.0
// Module   : GPIO, I2C 
//
// Hinweis  : mögliche Pinbelegungen
//            I2C1 : SCL :[PB6, PB8] 
//                   SDA :[PB7, PB9]
					//scl pb6, sda pb7
//            externe PullUp-Widerstände an SCL+SDA notwendig
//--------------------------------------------------------------

//--------------------------------------------------------------
// Includes
//--------------------------------------------------------------
#include "main.h"
#include "i2c.h"


//--------------------------------------------------------------
// internal functions
//--------------------------------------------------------------
void P_I2C1_InitI2C(void);
int16_t P_I2C1_timeout(int16_t wert);

//--------------------------------------------------------------
// Definition of I2C1, code1
//--------------------------------------------------------------
I2C1_DEV_t I2C1DEV = {
// PORT , PIN      , Clock              , Source 
  {GPIOB,GPIO_Pin_8,RCC_AHB1Periph_GPIOB,GPIO_PinSource8}, // SCL an PB6
  {GPIOB,GPIO_Pin_9,RCC_AHB1Periph_GPIOB,GPIO_PinSource9}, // SDA an PB7
};

//(TRUI) my modification starts here

/* sonarSetRange() is used to set the maximum range
 * e.g: sonarSetRange(0xE0, 500) will set the maximum range to be 500 mm (50 cm)
 */
void sonarSetRange(uint8_t addr, uint16_t jauh)
{
	uint8_t r;

	maxRange = jauh/10;

	r = (uint8_t)((jauh - 43)/43) + 1;
	UB_I2C1_WriteByte(addr, 2, r);
}

/* sonarSetGain(addr, gain) is used to set the analogue gain
 * gain values : 0x00 to 0x10 or 0 to 16 (default is 16)
 * e.g: sonarSetRange(0xE0, 0x03)
 */
void sonarSetGain(uint8_t addr, uint16_t gain)
{
	if (gain<=16 && gain>=0)
		UB_I2C1_WriteByte(addr, 1, gain);
	else
		UB_I2C1_WriteByte(addr, 1, 0x10); //default gain
}

/*
To start the SRF08 ranging you would write 0x51 to the command register at 0x00 like this:
1. Send a start sequence
2. Send 0xE0 ( I2C address of the SRF08 with the R/W bit low (even address)
3. Send 0x00 (Internal address of the command register)
4. Send 0x51 (The command to start the SRF08 ranging, in cm)
5. Send the stop sequence.
*/
void sonarRange(uint8_t addr)
{
	UB_I2C1_WriteByte(addr,0x00,0x51);
}

uint16_t sonarGet(uint8_t addr)
{
	uint16_t r;
	uint8_t hi, lo;

	do {
		r = UB_I2C1_ReadByte(addr, 0); //harusnya register 0
	}
	while (r == 0xFF); //will be set high if there is no input //harusnya 0xFF

	hi = UB_I2C1_ReadByte(addr, 2);
	lo = UB_I2C1_ReadByte(addr, 3);
	r = hi << 8;
	r += lo;

	if (r >= maxRange || r == 0)
		r = 70;

	return r;
}

void srf08Addressing(uint8_t oldAddr, uint8_t newAddr)
{
	UB_I2C1_WriteByte(oldAddr, 0x00, 0xA0);
	UB_I2C1_WriteByte(oldAddr, 0x00, 0xAA);
	UB_I2C1_WriteByte(oldAddr, 0x00, 0xA5);
	UB_I2C1_WriteByte(oldAddr, 0x00, newAddr);
}

void tpaSetServo(unsigned char position) {
	UB_I2C1_WriteByte(0xD0, 0x00, position);
}

uint16_t tpaRead(unsigned char pixelNum) {     /* QC */
    uint16_t data = 0;

    data = UB_I2C1_ReadByte(0xD0, pixelNum);  // Internal register address will increment automatically if we pass(1), not otherwise

    return data;
}

uint16_t getTpa81() {
    short pixel = 0;
    uint16_t max = 0;
    uint16_t temp = max;
    for (pixel = 0; pixel <= 7; pixel++) {
        temp = tpaRead(pixel + 2);
        if (temp > max) {
          	max = temp;
        }
    }

    return max;
}

short tpaScanGetPosition() {
	for (position = 0; position <= 30; position++) {
		tpaSetServo(position);
		Delayms(200);
		if (getTpa81() >= 80)
			return position;
	}

	for (; position >= 0; position--) {
		tpaSetServo(position);
		Delayms(200);
		if (getTpa81() >= 80)
			return position;
	}

	return -1;	//-1 means the fire is not found yet
}

//(TRUI) my modification ends here

//--------------------------------------------------------------
// initialization I2C1, code1
//-------------------------------------------------------------- 
void i2c_init(void)
{
  static uint8_t init_ok=0;
  GPIO_InitTypeDef  GPIO_InitStructure;

  // initialisierung darf nur einmal gemacht werden
  if(init_ok!=0) {
    return;
  } 

  // I2C-Clock enable
  RCC_APB1PeriphClockCmd(RCC_APB1Periph_I2C1, ENABLE);

  // Clock Enable der Pins
  RCC_AHB1PeriphClockCmd(I2C1DEV.SCL.CLK, ENABLE); 
  RCC_AHB1PeriphClockCmd(I2C1DEV.SDA.CLK, ENABLE);

  // I2C reset
  RCC_APB1PeriphResetCmd(RCC_APB1Periph_I2C1, ENABLE);
  RCC_APB1PeriphResetCmd(RCC_APB1Periph_I2C1, DISABLE);

  // Connect I2C alternative-function with the IO pins 
  GPIO_PinAFConfig(I2C1DEV.SCL.PORT, I2C1DEV.SCL.SOURCE, GPIO_AF_I2C1); 
  GPIO_PinAFConfig(I2C1DEV.SDA.PORT, I2C1DEV.SDA.SOURCE, GPIO_AF_I2C1);

  // I2C als Alternative-Funktion als OpenDrain  
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF;
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_100MHz; //coba nanti diganti jadi 100mhz
  GPIO_InitStructure.GPIO_OType = GPIO_OType_OD;
  GPIO_InitStructure.GPIO_PuPd  = GPIO_PuPd_UP;

  // SCL-Pin
  GPIO_InitStructure.GPIO_Pin = I2C1DEV.SCL.PIN;
  GPIO_Init(I2C1DEV.SCL.PORT, &GPIO_InitStructure);
  // SDA-Pin
  GPIO_InitStructure.GPIO_Pin = I2C1DEV.SDA.PIN;
  GPIO_Init(I2C1DEV.SDA.PORT, &GPIO_InitStructure);

  // I2C init
  P_I2C1_InitI2C();

  // init Mode speichern
  init_ok=1;
}

//--------------------------------------------------------------
// Auslesen einer Adresse per I2C von einem Slave
// slave_adr => I2C-Basis-Adresse vom Slave
// adr       => Register Adresse die gelesen wird
//
// Return_wert :
//  0...255 , Bytewert der gelesen wurde
//  < 0     , Error
//--------------------------------------------------------------
int16_t UB_I2C1_ReadByte(uint8_t slave_adr, uint8_t adr)
{
  int16_t ret_wert=0;
  uint32_t timeout=I2C1_TIMEOUT;

  // Start-Sequenz
  I2C_GenerateSTART(I2C1, ENABLE);
  timeout=I2C1_TIMEOUT;
  while (!I2C_GetFlagStatus(I2C1, I2C_FLAG_SB)) {
    if(timeout!=0) timeout--; else return(P_I2C1_timeout(-1));
  }

  // ACK disable
  I2C_AcknowledgeConfig(I2C1, DISABLE);

  // Slave-Adresse senden (write)
  I2C_Send7bitAddress(I2C1, slave_adr, I2C_Direction_Transmitter); 
  timeout=I2C1_TIMEOUT;
  while (!I2C_GetFlagStatus(I2C1, I2C_FLAG_ADDR)) {
    if(timeout!=0) timeout--; else return(P_I2C1_timeout(-2));
  }

  // ADDR-Flag löschen
  I2C1->SR2;
  timeout=I2C1_TIMEOUT;
  while (!I2C_GetFlagStatus(I2C1, I2C_FLAG_TXE)) {
    if(timeout!=0) timeout--; else return(P_I2C1_timeout(-3));
  }

  // Adresse senden
  I2C_SendData(I2C1, adr);
  timeout=I2C1_TIMEOUT;
  while ((!I2C_GetFlagStatus(I2C1, I2C_FLAG_TXE)) || (!I2C_GetFlagStatus(I2C1, I2C_FLAG_BTF))) {
    if(timeout!=0) timeout--; else return(P_I2C1_timeout(-4));
  }

  // Start-Sequenz
  I2C_GenerateSTART(I2C1, ENABLE);
  timeout=I2C1_TIMEOUT;
  while (!I2C_GetFlagStatus(I2C1, I2C_FLAG_SB)) {
    if(timeout!=0) timeout--; else return(P_I2C1_timeout(-5));
  }

  // Slave-Adresse senden (read)
  I2C_Send7bitAddress(I2C1, slave_adr|1, I2C_Direction_Receiver);
  timeout=I2C1_TIMEOUT;
  while (!I2C_GetFlagStatus(I2C1, I2C_FLAG_ADDR)) {
    if(timeout!=0) timeout--; else return(P_I2C1_timeout(-6));
  }

  // ADDR-Flag löschen
  I2C1->SR2;
  timeout=I2C1_TIMEOUT;
  while (!I2C_GetFlagStatus(I2C1, I2C_FLAG_RXNE)) {
    if(timeout!=0) timeout--; else return(P_I2C1_timeout(-7));
  }

  // Stop-Sequenz
  I2C_GenerateSTOP(I2C1, ENABLE);

  // Daten auslesen
  ret_wert=(int16_t)(I2C_ReceiveData(I2C1));

  // ACK enable
  I2C_AcknowledgeConfig(I2C1, ENABLE);

  return(ret_wert);
}

//--------------------------------------------------------------
// Beschreiben einer Adresse per I2C von einem Slave
// slave_adr => I2C-Basis-Adresse vom Slave
// adr       => Register Adresse die beschrieben wird
// wert      => Bytewert der geschrieben wird
//
// Return_wert :
//    0  , Ok
//  < 0  , Error
//--------------------------------------------------------------
void UB_I2C1_WriteByte(uint8_t slave_adr, uint8_t adr, uint8_t wert)
{
  uint32_t timeout=I2C1_TIMEOUT;

  // Start-Sequenz
  I2C_GenerateSTART(I2C1, ENABLE); 
  timeout=I2C1_TIMEOUT;
  while (!I2C_GetFlagStatus(I2C1, I2C_FLAG_SB)) {
    if(timeout!=0) timeout--; else return(P_I2C1_timeout(-1));
  }

  // Slave-Adresse senden (write)
  I2C_Send7bitAddress(I2C1, slave_adr, I2C_Direction_Transmitter);
  timeout=I2C1_TIMEOUT;
  while (!I2C_GetFlagStatus(I2C1, I2C_FLAG_ADDR)) {
    if(timeout!=0) timeout--; else return(P_I2C1_timeout(-2));
  }

  // ADDR-Flag clear/delete
  I2C1->SR2;
  while (!I2C_GetFlagStatus(I2C1, I2C_FLAG_TXE));
  timeout=I2C1_TIMEOUT;
  while (!I2C_GetFlagStatus(I2C1, I2C_FLAG_TXE)) {
    if(timeout!=0) timeout--; else return(P_I2C1_timeout(-3));
  }

  // send address
  I2C_SendData(I2C1, adr);
  timeout=I2C1_TIMEOUT;
  while (!I2C_GetFlagStatus(I2C1, I2C_FLAG_TXE)) {
    if(timeout!=0) timeout--; else return(P_I2C1_timeout(-4));
  }

  // Daten senden
  I2C_SendData(I2C1, wert);
  timeout=I2C1_TIMEOUT;
  while ((!I2C_GetFlagStatus(I2C1, I2C_FLAG_TXE)) || (!I2C_GetFlagStatus(I2C1, I2C_FLAG_BTF))) {
    if(timeout!=0) timeout--; else return(P_I2C1_timeout(-5));
  }

  // Stop-Sequenz
  I2C_GenerateSTOP(I2C1, ENABLE);
}


//--------------------------------------------------------------
// kleine Pause (ohne Timer)
//--------------------------------------------------------------
void UB_I2C1_Delay(volatile uint32_t nCount)
{
  while(nCount--)
  {
  }
}


//--------------------------------------------------------------
// code1
// internal function
// Init der I2C-Schnittstelle
//--------------------------------------------------------------
void P_I2C1_InitI2C(void)
{
  I2C_InitTypeDef  I2C_InitStructure;

  // I2C-Konfiguration
  I2C_InitStructure.I2C_Mode = I2C_Mode_I2C;
  I2C_InitStructure.I2C_DutyCycle = I2C_DutyCycle_2;
  I2C_InitStructure.I2C_OwnAddress1 = 0x00;
  I2C_InitStructure.I2C_Ack = I2C_Ack_Enable;
  I2C_InitStructure.I2C_AcknowledgedAddress = I2C_AcknowledgedAddress_7bit;
  I2C_InitStructure.I2C_ClockSpeed = I2C1_CLOCK_FRQ;

  // I2C enable
  I2C_Cmd(I2C1, ENABLE);

  // Init Struktur
  I2C_Init(I2C1, &I2C_InitStructure);
}

//--------------------------------------------------------------
// internal function
// wird bei einem Timeout aufgerufen
// Stop, Reset und reinit der I2C-Schnittstelle
//--------------------------------------------------------------
int16_t P_I2C1_timeout(int16_t wert)
{
  int16_t ret_wert=wert;

  // Stop und Reset
  I2C_GenerateSTOP(I2C1, ENABLE);
  I2C_SoftwareResetCmd(I2C1, ENABLE);
  I2C_SoftwareResetCmd(I2C1, DISABLE);

  // I2C deinit
  I2C_DeInit(I2C1);
  // I2C init
  P_I2C1_InitI2C();
    
  return(ret_wert);
}
