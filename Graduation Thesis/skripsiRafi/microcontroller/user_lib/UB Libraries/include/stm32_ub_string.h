//--------------------------------------------------------------
// File     : stm32_ub_string.h
//--------------------------------------------------------------

//--------------------------------------------------------------
#ifndef __STM32F4_UB_STRING_H
#define __STM32F4_UB_STRING_H


//--------------------------------------------------------------
// Includes
//--------------------------------------------------------------
#include "stm32f4xx.h"
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>


//--------------------------------------------------------------
// Defines
//--------------------------------------------------------------
#define  STRING_BUF_SIZE     50   // maximum Grösse vom String



//--------------------------------------------------------------
// zur Benutzung der String-Kopie Funktionen
// (MidString, LeftString, RightString)
//--------------------------------------------------------------
#define  USE_STR_FKT    1  // 0=nicht benutzen, 1=benutzen


#if USE_STR_FKT==1
  #include <string.h>
#endif



//--------------------------------------------------------------
// Globaler String-Puffer
//--------------------------------------------------------------
char STRING_BUF[STRING_BUF_SIZE];


//--------------------------------------------------------------
// Anzahl der Nachkommastellen bei Float
//  Faktor ->  100 = 2 Nachkommastellen,  Formatierung -> "%d.%02d"
//  Faktor -> 1000 = 3 Nachkommastellen,  Formatierung -> "%d.%03d"
//  usw
//--------------------------------------------------------------
#define  STRING_FLOAT_FAKTOR     1000   // 1000 = 3 Nachkommastellen
#define  STRING_FLOAT_FORMAT "%d.%03d"  // Formatierung


//--------------------------------------------------------------
// Globale Funktionen
//--------------------------------------------------------------
void UB_String_FloatToDezStr(float wert);
float UB_String_DezStringToFloat(char *ptr);
int16_t UB_String_DezStringToInt(char *ptr);
#if USE_STR_FKT==1
void UB_String_Mid(char *ptr, uint16_t start, uint16_t length);
void UB_String_Left(char *ptr, uint16_t length);
void UB_String_Right(char *ptr, uint16_t length);
#endif

//--------------------------------------------------------------
#endif // __STM32F4_UB_STRING_H
