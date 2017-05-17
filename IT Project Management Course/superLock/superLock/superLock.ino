#include <Keypad.h>
#include <LiquidCrystal.h>
#include <EEPROM.h>

#define HC05 Serial

const char startFlag = '*';
const char endFlag = '#';
const char endCharFlag = '|';
const byte digitalWriteFlag = 10;
const byte textFlag = 12;
const byte readFlag = 13;
const byte highFlag = 3;
const byte lowFlag = 2;
const byte dataFlag = 25;

const byte rowsNumber = 4;
const byte colsNumber = 4;

const byte rsPin = 16;
const byte enablePin = 17;
const byte data4Pin = 18;
const byte data5Pin = 11;
const byte data6Pin = 19;
const byte data7Pin = 12;

const byte solenoidPin = 10;

const int addrPIN = 135;
const int addrLock = 127;
const int addrX = 76;
const int addrY = 87;
const int addrI = 34;

const char keysValue[rowsNumber][colsNumber] = {
  {'1', '2', '3', 'A'},
  {'4', '5', '6', 'B'},
  {'7', '8', '9', 'C'},
  {'*', '0', '#', 'D'}
};

byte rowPins[rowsNumber] = {3, 8, 2, 9};
byte colPins[colsNumber] = {5, 6, 4, 7};

byte command = 0;
byte pinNumber = 0;
byte pinValue = 0;

char keyPressed;
char incomingChar = ' ';
String incomingText = "";

String x = "";
String y = "";

bool acceptData = false;

long time = 100;

char buf[4];

String valueStringPIN;
String valueStringLock;
int valueX;
int valueY;

Keypad keypad = Keypad(makeKeymap(keysValue), rowPins, colPins, rowsNumber, colsNumber);
LiquidCrystal lcd = LiquidCrystal(rsPin, enablePin, data4Pin, data5Pin, data6Pin, data7Pin);

void setup() {
  HC05.begin(9600);

  lcd.begin(16, 2);
  lcd.setCursor(0, 1);
  lcd.print("superLock!");

  pinMode(solenoidPin, OUTPUT);
  lockDoor();
  pinMode(13, INPUT);

}

void loop() {
  valueStringPIN = String(EEPROM.read(addrPIN)) + String(EEPROM.read(addrPIN + 1));
  valueStringLock = String(EEPROM.read(addrLock)) + String(EEPROM.read(addrLock + 1));
  valueX = EEPROM.read(addrX);
  valueY = EEPROM.read(addrY);
  keyPressed = keypad.getKey();
  if (keyPressed) {
    HC05.println(keyPressed);
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print(keyPressed);
    if (keyPressed == 'B') acceptData = true;
    if (time < 100) {
      time = 0;
    } else {
      keyPressed = ' ';
      time = 0;
    }
  }

  time++;

  if (time > 100) {
    lcd.setCursor(0, 1);
    lcd.print("superLock!");
    delay(100);
    lcd.clear();
  } else {
    lcd.setCursor(0, 0);
    lcd.print("1. Admin");
    lcd.setCursor(0, 1);
    lcd.print("2. User");
    if (keyPressed == '1') {
      bool indexAdmin = true;
      bool rightAdmin = false;
      time = 0;
      lcd.clear();
      String temp = "";
      int o = 0;
      while (1) {
        time++;
        //if (time > 500) return;
        lcd.setCursor(0, 0);
        lcd.print("Insert PIN");
        keyPressed = keypad.getKey();
        if (keyPressed) {
          time = 0;
          switch (keyPressed) {
            case 'B':
              if (!temp.equals(valueStringPIN)) {
                lcd.clear();
                lcd.setCursor(0, 0);
                lcd.print("PIN Incorrect");
                delay(500);
                return;
              } else {
                rightAdmin = true;
              }
              break;
            case 'C':
              temp = "";
              lcd.setCursor(0, 1);
              lcd.print("                 ");
              o = 0;
              break;
            default:
              temp += keyPressed;
              lcd.setCursor(o, 1);
              lcd.print(keyPressed);
              o++;
              break;
          }
        }
        while (rightAdmin) {
          keyPressed = keypad.getKey();
          if (keyPressed) {
            time = 0;
            if (keyPressed == 'A') {
              if (indexAdmin) {
                indexAdmin = false;
              } else {
                indexAdmin = true;
              }
            } else if (keyPressed == 'D') {
              if (indexAdmin) {
                indexAdmin = false;
              } else {
                indexAdmin = true;
              }
            } else if (keyPressed == '1') {
              changePassword();
            } else if (keyPressed == '2') {
              changeLockKey();
            } else if (keyPressed == '3') {
              changePIN();
            } else if (keyPressed == '4') {
              return;
            }
          }
          if (indexAdmin) {
            lcd.setCursor(0, 0);
            lcd.print("1.Change Passwrd");
            lcd.setCursor(0, 1);
            lcd.print("2.Change LockKey");
          } else {
            lcd.setCursor(0, 0);
            lcd.print("3.Change PIN");
            lcd.setCursor(0, 1);
            lcd.print("4.BACK");
          }

          delay(100);
          lcd.clear();
          time++;
          //if (time > 100) return;
        }
      }
    } else if (keyPressed == '2') {
      time = 0;
      while (1) {
        keyPressed = keypad.getKey();
        if (keyPressed) {
          time = 0;
          if (keyPressed == '1') {
            bool indexUser = true;
            bool next = false;
            time = 0;
            lcd.clear();
            String temp = "";
            int o = 0;
            bool loop = true;
            while (loop) {
              time++;
              //if (time > 500) return;
              lcd.setCursor(0, 0);
              lcd.print("Insert Password");
              keyPressed = keypad.getKey();
              if (keyPressed) {
                time = 0;
                switch (keyPressed) {
                  case 'B':
                    loop = false;
                    break;
                  case 'C':
                    temp = "";
                    lcd.setCursor(0, 1);
                    lcd.print("                 ");
                    o = 0;
                    break;
                  default:
                    temp += keyPressed;
                    lcd.setCursor(o, 1);
                    lcd.print(keyPressed);
                    o++;
                    break;
                }
              }              
            }

            lcd.clear();
            lcd.setCursor(0, 0);
            lcd.print("Press B 2Capture");
            while (1) {
              keyPressed = keypad.getKey();
              if (keyPressed) {
                if (keyPressed == 'B') {
                  break;
                } else if (keyPressed == 'C') {
                  return;
                }
              }
            }
        asd:
            HC05.println('B');

            if (HC05.available() < 1)             goto asd;

            acceptData = true;

            incomingChar = HC05.read();

            if (incomingChar != startFlag) goto asd;

            command = HC05.parseInt();
            pinNumber = HC05.parseInt();
            pinValue = HC05.parseInt();

            if ((command == dataFlag) && acceptData) {
              int index = 0;
              acceptData = false;
              incomingText = "";
              incomingChar = ' ';
              while (HC05.available()) {
                incomingChar = HC05.read();
                delay(10);
                if (incomingChar == endFlag) {
                  HC05.println("Data Diterima");
                  lcd.clear();
                  for (int i = 0; i < incomingText.length(); i++) {
                    if (incomingText.charAt(i) == ' ') {
                      index = i;
                      break;
                    }
                  }
                  x = "";
                  y = "";
                  for (int i = 0; i < index; i++) {
                    x +=  incomingText.charAt(i);
                  }

                  for (int i = index + 1; i < incomingText.length(); i++) {
                    y +=  incomingText.charAt(i);
                  }

                  lcd.setCursor(5, 0);
                  lcd.print("x=");
                  lcd.print(x);
                  EEPROM.write(addrX, x.toInt());
                  lcd.setCursor(5, 1);
                  lcd.print("y=");
                  lcd.print(y);
                  EEPROM.write(addrY, y.toInt());
                  delay(1000);
                  break;
                }
                else if (incomingChar !=  endCharFlag) {
                  incomingText += incomingChar;
                }
              }
            }

            int nilaiX = x.toInt();
            int nilaiY = y.toInt();


             if ((valueX == nilaiX) && (valueY == nilaiY) && (temp.equals(valueStringLock))) {

               lcd.clear();
               lcd.setCursor(0,0);
               lcd.print("UNLOCK");
               unlockDoor();
               while(1)
               {
                  if (digitalRead(13)) {
                     lockDoor();
                     return;
                  } 
               }
               
             }
             else
             {

               lcd.clear();
               lcd.setCursor(0,0);
               lcd.print("WRONG");
               delay(1000);
                return;
              }


          } else if (keyPressed == '2') {
            return;
          }
        }
        lcd.setCursor(0, 0);
        lcd.print("1.Unlock");
        lcd.setCursor(0, 1);
        lcd.print("2.BACK");

        delay(100);
        lcd.clear();
        time++;
        //if (time > 100) return;
      }
    }

    delay(100);
    lcd.clear();
  }

  if (HC05.available() < 1) return;

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

  incomingChar = HC05.read();

  if (incomingChar != startFlag) return;

  command = HC05.parseInt();
  pinNumber = HC05.parseInt();
  pinValue = HC05.parseInt();

  if (command == textFlag) {
    incomingText = "";
    incomingChar = ' ';
    while (HC05.available()) {
      incomingChar = HC05.read();
      delay(10);
      if (incomingChar == endFlag) {
        if (incomingText.equalsIgnoreCase("Rafi")) {
          lcd.clear();
          lcd.setCursor(0, 0);
          lcd.print("Rafi Ganteng");
          HC05.println("Rafi Ganteng");
        } else {
          HC05.println(incomingText);
          lcd.clear();
          lcd.setCursor(0, 0);
          lcd.print(incomingText);
        }
        break;
      }
      else if (incomingChar !=  endCharFlag) {
        incomingText += incomingChar;
      }
    }
  }

  if (command == digitalWriteFlag) {
    if (pinNumber == solenoidPin) {
      if (pinValue == lowFlag) unlockDoor();
      else if (pinValue == highFlag) lockDoor();
      else return;
    }
    return;
  }

  if (command == readFlag) {
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("MANPRO!");
    HC05.println("superLock!");
    return;
  }
}

void lockDoor() {
  digitalWrite(solenoidPin, LOW);
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Terkunci !");
  //HC05.println("Terkunci !");
}

void unlockDoor() {
  digitalWrite(solenoidPin, HIGH);
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Terbuka !");
  //HC05.println("Terbuka !");
}

void changePassword() {
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Press B 2Capture");
  while (1) {
    keyPressed = keypad.getKey();
    if (keyPressed) {
      if (keyPressed == 'B') {
        break;
      } else if (keyPressed == 'C') {
        return;
      }
    }
  }

  HC05.println('B');

  if (HC05.available() < 1) changePassword();

  acceptData = true;

  incomingChar = HC05.read();

  if (incomingChar != startFlag) changePassword();

  command = HC05.parseInt();
  pinNumber = HC05.parseInt();
  pinValue = HC05.parseInt();

  if ((command == dataFlag) && acceptData) {
    int index = 0;
    acceptData = false;
    incomingText = "";
    incomingChar = ' ';
    while (HC05.available()) {
      incomingChar = HC05.read();
      delay(10);
      if (incomingChar == endFlag) {
        HC05.println("Data Diterima");
        lcd.clear();
        for (int i = 0; i < incomingText.length(); i++) {
          if (incomingText.charAt(i) == ' ') {
            index = i;
            break;
          }
        }
        x = "";
        y = "";
        for (int i = 0; i < index; i++) {
          x +=  incomingText.charAt(i);
        }

        for (int i = index + 1; i < incomingText.length(); i++) {
          y +=  incomingText.charAt(i);
        }

        lcd.setCursor(5, 0);
        lcd.print("x=");
        lcd.print(x);
        EEPROM.write(addrX, x.toInt());
        lcd.setCursor(5, 1);
        lcd.print("y=");
        lcd.print(y);
        EEPROM.write(addrY, y.toInt());
        delay(1000);
        break;
      }
      else if (incomingChar !=  endCharFlag) {
        incomingText += incomingChar;
      }
    }
  }
}


void changeLockKey() {
  String incoming = "";
  String verify = "";
  int i = 0;
  char buf[4];

  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Insert newLckKey");
  while (1) {
    keyPressed = keypad.getKey();
    if (keyPressed) {
      if (keyPressed != 'B') {
        incoming += keyPressed;
        i++;
        if (i > 3) break;
      } else if (keyPressed == 'C') {
        return;
      } else {
        break;
      }
    }
  }
  i = 0;
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Insert again");
  while (1) {
    keyPressed = keypad.getKey();
    if (keyPressed) {
      if (keyPressed != 'B') {
        verify += keyPressed;
        i++;
        if (i > 3) break;
      } else if (keyPressed == 'C') {
        return;
      } else {
        break;
      }
    }
  }
  if (incoming.equals(verify)) {
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("LockKey Changed!");
    String str = "";
    str = incoming.substring(0, 2);
    lcd.setCursor(3, 1);
    lcd.print(str);
    EEPROM.write(addrLock, str.toInt());
    str = incoming.substring(2, 4);
    lcd.setCursor(7, 1);
    lcd.print(str);
    EEPROM.write(addrLock + 1, str.toInt());
    delay(1000);
  } else {
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Mismatch!");
    delay(1000);
    changePIN();
  }
}

void changePIN() {
  String incoming = "";
  String verify = "";
  int i = 0;
  char buf[4];

  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Insert a new PIN");
  while (1) {
    keyPressed = keypad.getKey();
    if (keyPressed) {
      if (keyPressed != 'B') {
        incoming += keyPressed;
        i++;
        if (i > 3) break;
      } else if (keyPressed == 'C') {
        return;
      } else {
        break;
      }
    }
  }
  i = 0;
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Insert again");
  while (1) {
    keyPressed = keypad.getKey();
    if (keyPressed) {
      if (keyPressed != 'B') {
        verify += keyPressed;
        i++;
        if (i > 3) break;
      } else if (keyPressed == 'C') {
        return;
      } else {
        break;
      }
    }
  }
  if (incoming.equals(verify)) {
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("PIN Changed!");
    String str = "";
    str = incoming.substring(0, 2);
    lcd.setCursor(3, 1);
    lcd.print(str);
    EEPROM.write(addrPIN, str.toInt());
    str = incoming.substring(2, 4);
    lcd.setCursor(7, 1);
    lcd.print(str);
    EEPROM.write(addrPIN + 1, str.toInt());
    delay(1000);
  } else {
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Mismatch!");
    delay(1000);
    changePIN();
  }
}
