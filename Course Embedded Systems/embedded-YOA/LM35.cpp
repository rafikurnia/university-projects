/*
  LM35.cpp - Library for reading LM35 Temperature Sensor
  Created by Rafi Kurnia Putra. May 2, 2015.
  Embedded System Project 2015
*/

#include "LM35.h"

LM35::LM35(int pin) : _pin(pin) {}

void LM35::init() {
  pinMode(_pin, INPUT);
  digitalWrite(_pin, HIGH);
}

int LM35::getADC() {
  return analogRead(_pin);
}

float LM35::getVoltage() {
  return LM35::getADC() * 0.004882814;
}

float LM35::getCelcius() {
  return LM35::getVoltage() * 100;
}

float LM35::getReamur() {
  return LM35::getCelcius() * 4 / 5;
}

float LM35::getFahrenheit() {
  return (LM35::getCelcius() * 9 / 5) + 32;
}
