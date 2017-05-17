/*
  Led.h - Library for controlling Led
  Created by Rafi Kurnia Putra. May 2, 2015.
  Embedded System Project 2015
*/

#ifndef LED_H
#define LED_H

#include "Arduino.h"

class Led {
  public:
    Led(int pin);
    void init();
    void turnOn();
    void turnOff();
    void blink(int delayValue);
    int getState();

  private:
    const int _pin;
};

#endif
