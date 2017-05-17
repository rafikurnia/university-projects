/*
  DebugAndInit.ino - EMBEDDED YOA !
  Created by Rafi Kurnia Putra. May 2, 2015.
  Embedded System Project 2015
*/

void initAll() {
  Serial.begin(115200);
  
  initEthernet();
  
  for (int i = 0; i < 2; i++) {
    sensor[i] = new LM35(i + 14);
    sensor[i]->init();
  }

  for (int i = 0; i < 3; i++) {
    button[i] = new RemoteButton(i + 8);
    button[i]->init();
  }

  for (int i = 0; i < 6; i++ ) {
    led[i] = new Led(i + 2);
    led[i]->init();
  }

  uint8_t turnedOn = EEPROM.read(1);
  uint8_t tempNow = EEPROM.read(2);

  button[POWER]->setValue(turnedOn);
  button[TEMPDOWN]->setValue(tempNow);
  button[TEMPUP]->setValue(button[TEMPDOWN]->getValue());

  if (!turnedOn) {
    button[POWER]->toggleState();
    turnedOn = 1;
    button[POWER]->setValue(turnedOn);
    EEPROM.write(1, turnedOn);
  }
 
  button[TEMPDOWN]->calibrate();
  tempNow = 16;
  button[TEMPDOWN]->setValue(tempNow);
  button[TEMPUP]->setValue(button[TEMPDOWN]->getValue());
  EEPROM.write(2, tempNow);

}

void printSerial() {
  Serial.print("EMBEDDED YOA!     |     ");
  Serial.print(sensor[LEFT]->getADC());
  Serial.print(" ADC   ");
  Serial.print(sensor[LEFT]->getVoltage());
  Serial.print(" V   ");
  Serial.print(sensor[LEFT]->getCelcius());
  Serial.print(" C   ");
  Serial.print(sensor[LEFT]->getReamur());
  Serial.print(" R   ");
  Serial.print(sensor[LEFT]->getFahrenheit());
  Serial.print(" F     |     ");
  Serial.print(sensor[LEFT]->getADC());
  Serial.print(" ADC   ");
  Serial.print(sensor[RIGHT]->getVoltage());
  Serial.print(" V   ");
  Serial.print(sensor[RIGHT]->getCelcius());
  Serial.print(" C   ");
  Serial.print(sensor[RIGHT]->getReamur());
  Serial.print(" R   ");
  Serial.print(sensor[RIGHT]->getFahrenheit());
  Serial.print(" F     |     Switch : ");
  Serial.print(EEPROM.read(1));
  Serial.print("   Remote Temp : ");
  Serial.println(EEPROM.read(2));
}
