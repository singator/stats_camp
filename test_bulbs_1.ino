int switchState = LOW, i;
int bulbState[3] = {LOW, LOW, LOW};
int previous = LOW;
long time = 0;
long debounce = 200;

void setup() {
  // put your setup code here, to run once:
  pinMode(5, OUTPUT);
  pinMode(3, OUTPUT);
  pinMode(4, OUTPUT);
  pinMode(2, INPUT);
}

void loop() {
  switchState = digitalRead(2);

  // if the input just went from LOW and HIGH and we've waited long enough
  // to ignore any noise on the circuit, toggle the output pin and remember
  // the time
  if (switchState == HIGH && previous == LOW && millis() - time > debounce) {
    
    if (bulbState[0] == HIGH){   //red is on --> check yellow
      if(bulbState[1] == LOW){   //yellow off --> turn it on
        bulbState[1] = HIGH;
      } else {                   //yellow on --> check green
        if(bulbState[2] == LOW){ //green off --> turn it on
          bulbState[2] = HIGH;
        } else {                 //green on --> turn all off   
           for(int i = 0; i < 3; i++){
             bulbState[i] = LOW;
           }
        }
      }      
    } else { //red is low --> turn it on
      bulbState[0] = HIGH;
    }

 //     bulbState[0] = LOW;
 //   else
 //     bulbState[0] = HIGH;

    time = millis();
  }

  for(int i = 0; i < 3; i++) {
    digitalWrite(i+3, bulbState[i]);
  }

  previous = switchState;
}

