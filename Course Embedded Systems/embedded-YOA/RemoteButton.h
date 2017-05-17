/*
  RemoteButton.h - Library for controlling AC Remote Button
  Created by Rafi Kurnia Putra. May 2, 2015.
  Embedded System Project 2015
*/

#ifndef REMOTE_BUTTON_H
#define REMOTE_BUTTON_H

#include "Arduino.h"

class RemoteButton {
  public:
    RemoteButton(int pin);
    void init();
    void press();
    void unPress();
    void toggleState();
    void calibrate();
    void setValue(uint8_t value);
    uint8_t getValue();

  private:
    const int _pin;
    uint8_t _value;
};

#endif
