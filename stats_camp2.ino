const byte interruptPin = 2;
int switchState = LOW, i;
int bulbState[3] = {LOW, LOW, LOW};
int bulbState2=0; // 0 - None, 1 - Neut, 2 - RelQ, 3 - ComQ
int previous = LOW;
unsigned long time = 0, time1, time2;
long debounce = 200;
volatile unsigned long hr = 0.0;
volatile byte state = LOW;

void setup() {
  // put your setup code here, to run once:
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(6, OUTPUT);
  pinMode(5, OUTPUT);
  pinMode(4, OUTPUT);
  pinMode(3, INPUT);
  pinMode(interruptPin, INPUT_PULLUP);
  
  attachInterrupt(digitalPinToInterrupt(interruptPin), blink, RISING);
  Serial.begin(9600);
  delay(5000);
  time1 = millis();
}

void loop() {
  switchState = digitalRead(3);

  // if the input just went from LOW and HIGH and we've waited long enough
  // to ignore any noise on the circuit, toggle the output pin and remember
  // the time
  if (switchState == HIGH && previous == LOW && millis() - time > debounce) {
    
    if (bulbState[0] == HIGH){   //red is on --> check yellow
      if(bulbState[1] == LOW){   //yellow off --> turn it on
        bulbState[1] = HIGH;
        bulbState2 = 2;
      } else {                   //yellow on --> check green
        if(bulbState[2] == LOW){ //green off --> turn it on
          bulbState[2] = HIGH;
          bulbState2 = 3;
        } else {                 //green on --> turn all off   
           for(int i = 0; i < 3; i++){
             bulbState[i] = LOW;
           }
           bulbState2=0;
        }
      }      
    } else { //red is low --> turn it on
      bulbState[0] = HIGH;
      bulbState2 = 1;
    }

    time = millis();
  }

  for(int i = 0; i < 3; i++) {
    digitalWrite(i+4, bulbState[i]);
  }
  digitalWrite(LED_BUILTIN, state);

  previous = switchState;
}

void blink() {
    //Serial.print("HR: ");
    time2 = millis();
    hr = 60000 / (time2 - time1);
    Serial.print(hr);
    Serial.print(",");
    Serial.print(time2);
    Serial.print(",");
    switch(bulbState2){
      case 0:
        Serial.println("None");
        break;
      case 1:
        Serial.println("Neut");
        break;
      case 2:
        Serial.println("RelQ");
        break;
      case 3:
        Serial.println("ComQ");
        break;
    }
    time1 = time2;
}

