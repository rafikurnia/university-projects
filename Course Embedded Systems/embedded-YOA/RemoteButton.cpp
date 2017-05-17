/*
  RemoteButton.h - Library for controlling AC Remote Button
  Created by Rafi Kurnia Putra. May 2, 2015.
  Embedded System Project 2015
*/

#include "RemoteButton.h"

RemoteButton::RemoteButton(int pin) : _pin(pin) {
  _value = 0;
}

void RemoteButton::init() {
  pinMode(_pin, OUTPUT);
  digitalWrite(_pin, LOW);
}

void RemoteButton::press() {
  digitalWrite(_pin, HIGH);
}

void RemoteButton::unPress() {
  digitalWrite(_pin, LOW);
}

void RemoteButton::toggleState() {
  RemoteButton::press();
  delay(250);
  RemoteButton::unPress();
  delay(100);
}

void RemoteButton::calibrate() {
  if (_pin == 9) {
    for (int i = 0; i < 15; i++) {
      RemoteButton::toggleState();
      delay(100);
    }
  }
}

void RemoteButton::setValue(uint8_t value) {
  _value = value;
}

uint8_t RemoteButton::getValue() {
  return _value;
}
