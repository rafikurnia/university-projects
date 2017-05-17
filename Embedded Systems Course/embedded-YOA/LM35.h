/*
  LM35.h - Library for reading LM35 Temperature Sensor
  Created by Rafi Kurnia Putra. May 2, 2015.
  Embedded System Project 2015
*/

#ifndef LM35_H
#define LM35_H

#include "Arduino.h"

class LM35 {
  public:
    LM35(int pin);
    void init();
    int getADC();
    float getVoltage();
    float getCelcius();
    float getReamur();
    float getFahrenheit();

  private:
    const int _pin;
};

#endif
