/*
  TemperatureHandling.ino
  Created by Rafi Kurnia Putra. May 4, 2015.
  Embedded System Project 2015
*/

float avgTemp;
long timerLevel[6];
bool timerStarted[6] = {false};

void tempControl() {
  avgTemp = (sensor[LEFT]->getCelcius() + sensor[RIGHT]->getCelcius()) / 2;
  if (avgTemp < 25) {
    setLed(1);
    if (!timerStarted[0]) {
      tempUP();
      timerStarted[0] = true;
      timerLevel[0] = millis();
      for (int i = 0; i < 6 ; i++) {
        if (i == 0) continue;
        timerStarted[i] = false;
      }
    }
    if ((millis() - timerLevel[0]) > 5000) {
      timerStarted[0] = false;
    }
  }
  else if ((avgTemp >= 25) && (avgTemp < 30)) {
    setLed(2);
    if (!timerStarted[1]) {
      tempDOWN();
      timerStarted[1] = true;
      timerLevel[1] = millis();
      for (int i = 0; i < 6 ; i++) {
        if (i == 1) continue;
        timerStarted[i] = false;
      }
    }
    if ((millis() - timerLevel[1]) > 10000) {
      timerStarted[1] = false;
    }
  }
  else if ((avgTemp >= 30) && (avgTemp < 35)) {
    setLed(3);
    if (!timerStarted[2]) {
      tempDOWN();
      timerStarted[2] = true;
      timerLevel[2] = millis();
      for (int i = 0; i < 6 ; i++) {
        if (i == 2) continue;
        timerStarted[i] = false;
      }
    }
    if ((millis() - timerLevel[2]) > 10000) {
      timerStarted[2] = false;
    }
  }
  else if ((avgTemp >= 35) && (avgTemp < 40)) {
    setLed(4);
    if (!timerStarted[3]) {
      tempDOWN();
      timerStarted[3] = true;
      timerLevel[3] = millis();
      for (int i = 0; i < 6 ; i++) {
        if (i == 3) continue;
        timerStarted[i] = false;
      }
    }
    if ((millis() - timerLevel[3]) > 5000) {
      timerStarted[3] = false;
    }
  }
  else if ((avgTemp >= 40) && (avgTemp < 45)) {
    setLed(5);
    if (!timerStarted[4]) {
      tempDOWN();
      timerStarted[4] = true;
      timerLevel[4] = millis();
      for (int i = 0; i < 6 ; i++) {
        if (i == 4) continue;
        timerStarted[i] = false;
      }
    }
    if ((millis() - timerLevel[4]) > 2500) {
      timerStarted[4] = false;
    }
  }
  else if (avgTemp >= 45) {
    setLed(6);
    if (!timerStarted[5]) {
      tempDOWN();
      timerStarted[5] = true;
      timerLevel[5] = millis();
      for (int i = 0; i < 6 ; i++) {
        if (i == 5) continue;
        timerStarted[i] = false;
      }
    }
    if ((millis() - timerLevel[5]) > 1000) {
      timerStarted[5] = false;
    }
  }
}
