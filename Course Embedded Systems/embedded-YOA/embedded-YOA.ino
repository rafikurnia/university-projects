/*
  embedded-YOA.ino - EMBEDDED YOA !
  Created by Rafi Kurnia Putra. May 2, 2015.
  Embedded System Project 2015
*/

#include <EEPROM.h>
#include <SPI.h>
#include <EthernetShield.h>
#include <EthernetUdpShield.h>
#include "RemoteButton.h"
#include "Led.h"
#include "LM35.h"
#include "defines.h"

RemoteButton** button = new RemoteButton*[3];
LM35** sensor = new LM35*[2];
Led** led = new Led*[6];

IPAddressShield ipAddr(152, 118, 24, 10);
EthernetUDPShield packetUDP;

void setup() {
  initAll();
}

void loop() {
  tempControl();
  printSerial();
}
