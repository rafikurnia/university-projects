/*
  ButtonHandling.ino - EMBEDDED YOA !
  Created by Rafi Kurnia Putra. May 3, 2015.
  Embedded System Project 2015
*/

void tempUP() {
  uint8_t tempNow = EEPROM.read(2);
  if (tempNow < 30) {
    button[TEMPUP]->toggleState();
    delay(250);
    tempNow++;
    button[TEMPUP]->setValue(tempNow);
    button[TEMPDOWN]->setValue(button[TEMPUP]->getValue());
    EEPROM.write(2, tempNow);
  }
}

void tempDOWN() {
  uint8_t tempNow = EEPROM.read(2);
  if (tempNow > 16) {
    button[TEMPDOWN]->toggleState();
    delay(100);
    tempNow--;
    button[TEMPDOWN]->setValue(tempNow);
    button[TEMPUP]->setValue(button[TEMPDOWN]->getValue());
    EEPROM.write(2, tempNow);
  }
}

void toggleSwitch() {
  uint8_t turnedOn = EEPROM.read(1);
  button[POWER]->toggleState();
  if (turnedOn == 1) {
    turnedOn = 0;
  }
  else {
    turnedOn = 1;
  }
  button[POWER]->setValue(turnedOn);
  EEPROM.write(1, turnedOn);
}
