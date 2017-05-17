//--------------------------------------------------------------
// File     : stm32_ub_string.c
// Datum    : 02.03.2014
// Version  : 1.1
// Autor    : UB
// EMail    : mc-4u(@)t-online.de
// Web      : www.mikrocontroller-4u.de
// CPU      : STM32F4
// IDE      : CooCox CoIDE 1.7.4
// GCC      : 4.7 2012q4
// Module   : Retarget_Printf
// Funktion : String Funktionen (Integer und Float)
//
// Hinweise : für die Umwandlung von Ganzzahlen, kann die
//            Funktion "sprintf()" benutzt werden
//
//            Beispiel fuer Integer :
//            -----------------------
//              int16_t wert=-123;
//              sprintf(STRING_BUF,"%d",wert);
//
//              Ausgabe als Dezimalzahl :
//                8/16bit unsigned = %d oder %i : uint8_t, uint16_t
//                8/16bit signed   = %d oder %i : int8_t, int16_t
//                32bit unsigned   = %u         : unsigned int
//              Ausgabe als Hex-Zahl :
//                8/16bit unsigned = %x oder %X : uint8_t, uint16_t
//                32bit unsigned   = %x oder %X : unsigned int
//              Ausgabe als String :
//                                 = %s         : char[], unsigned char[]
//              Ausgabe als Zeichen :
//                                 = %c         : char, unsigned char
//
//              Zusätze :
//                %5d  : ausgabe von 5 Stellen
//                %05d : ausgabe von 5 Stellen mit führenden Nullen
//
//
//            Beispiel fuer Float :
//            -----------------------  
//              float wert=-123.4567;
//
//              UB_String_FloatToDezStr(wert);
//
//--------------------------------------------------------------


//--------------------------------------------------------------
// Includes
//--------------------------------------------------------------
#include "stm32_ub_string.h"




//--------------------------------------------------------------
// wandelt eine Float Zahl in einen String als Dezimahl Zahl
// ergebnis steht dann in "STRING_BUF"
// Float muss zwischen -32767 und +32767 liegen
// Bsp : Zahl = 123.4567 wird zu String "123.457"
//--------------------------------------------------------------
void UB_String_FloatToDezStr(float wert)
{
  int16_t vorkomma;
  uint16_t nachkomma;
  float rest;

  if((wert>32767) || (wert<-32767)) {
    // zahl zu groß oder zu klein
    sprintf(STRING_BUF,"%s","OVF");
    return;
  }

  vorkomma=(int16_t)(wert);
  if(wert>=0) {
    rest = wert-(float)(vorkomma);
  }
  else {
    rest = (float)(vorkomma)-wert;
  }
  nachkomma = (uint16_t)(rest*(float)(STRING_FLOAT_FAKTOR)+0.5);

  sprintf(STRING_BUF,STRING_FLOAT_FORMAT,vorkomma,nachkomma);
}


//--------------------------------------------------------------
// wandelt einn String in eine Float Zahl
// Bsp : String "123.457" wird zu Zahl 123.457
//--------------------------------------------------------------
float UB_String_DezStringToFloat(char *ptr)
{
  float ret_wert=0.0;

  ret_wert=atof(ptr);

  return(ret_wert);
}


//--------------------------------------------------------------
// wandelt einn String in eine Integer Zahl
// Bsp : String "-1234" wird zu Zahl -1234
//--------------------------------------------------------------
int16_t UB_String_DezStringToInt(char *ptr)
{
  int16_t ret_wert=0;

  ret_wert=atoi(ptr);

  return(ret_wert);
}

//--------------------------------------------------------------
// kopiert einen Teilstring
// Bsp : String "Hallo Leute",3,6 wird zu "lo Leu"
//--------------------------------------------------------------
#if USE_STR_FKT==1
void UB_String_Mid(char *ptr, uint16_t start, uint16_t length)
{
  uint16_t i,m;
  uint16_t cnt = 0;

  if(length==0) return;
  m=start+length;
  if(m>strlen(ptr)) m=strlen(ptr);

  for(i=start;i<m; i++) {
    STRING_BUF[cnt] = ptr[i];
    cnt++;
  }
  STRING_BUF[cnt]=0x00;
}
#endif


//--------------------------------------------------------------
// kopiert den linken Teil von einem String
// Bsp : String "Hallo Leute",3 wird zu "Hal"
//--------------------------------------------------------------
#if USE_STR_FKT==1
void UB_String_Left(char *ptr, uint16_t length)
{
  if(length==0) return;
  if(length>strlen(ptr)) length=strlen(ptr);

  strncpy(STRING_BUF,ptr,length);
  STRING_BUF[length]=0x00;
}
#endif


//--------------------------------------------------------------
// kopiert den rechten Teil von einem String
// Bsp : String "Hallo Leute",3 wird zu "ute"
//--------------------------------------------------------------
#if USE_STR_FKT==1
void UB_String_Right(char *ptr, uint16_t length)
{
  uint16_t i,m,start;
  uint16_t cnt = 0;

  if(length==0) return;
  m=strlen(ptr);
  if(length>m) length=m;
  start=m-length;

  for(i=start;i<m; i++) {
    STRING_BUF[cnt] = ptr[i];
    cnt++;
  }
  STRING_BUF[cnt]=0x00;
}
#endif



