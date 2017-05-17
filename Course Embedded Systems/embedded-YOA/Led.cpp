/*
  Led.h - Library for controlling Led
  Created by Rafi Kurnia Putra. May 2, 2015.
  Embedded System Project 2015
*/

#include "Led.h"

Led::Led(int pin) : _pin(pin) {}

void Led::init() {
  pinMode(_pin, OUTPUT);
  digitalWrite(_pin, LOW);
}

void Led::turnOn() {
  digitalWrite(_pin, HIGH);
}

void Led::turnOff() {
  digitalWrite(_pin, LOW);
}

void Led::blink(int delayValue) {
  Led::turnOff();
  delay(delayValue);
  Led::turnOn();
  delay(delayValue);
}

int Led::getState() {
  return digitalRead(_pin);
}
