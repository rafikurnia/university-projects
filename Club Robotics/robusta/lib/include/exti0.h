//--------------------------------------------------------------
// File     : stm32_ub_ext_int0.h
//--------------------------------------------------------------

//--------------------------------------------------------------
#ifndef _EXT_INT0_H_
#define _EXT_INT0_H_


//--------------------------------------------------------------
// Globale Funktionen
//--------------------------------------------------------------
void UB_Ext_INT0_Init(void);
uint8_t uvtron_check();

//--------------------------------------------------------------
// Struktur eines EXT_INT
//--------------------------------------------------------------
typedef struct {
  GPIO_TypeDef* INT_PORT; // Port
  const uint16_t INT_PIN; // Pin
  const uint32_t INT_CLK; // Clock
  const uint8_t INT_SOURCE; // Source
  GPIOPuPd_TypeDef INT_R; // Widerstand
  EXTITrigger_TypeDef INT_TRG; // Trigger
}EXT_INT;



//--------------------------------------------------------------
#endif // __STM32F4_UB_EXT_INT0_H
