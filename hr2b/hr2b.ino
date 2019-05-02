// a simple program to print the heart rate at every pulse.

const byte interruptPin = 2;
volatile byte state = LOW;
unsigned long time2;

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(interruptPin, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(interruptPin), pulse, RISING);
  Serial.begin(9600);
  delay(2000);
}

// If the state is high, then 
void loop() {
  if(state == HIGH){
    Serial.println(time2);
    digitalWrite(LED_BUILTIN, state);
    delay(100);
    state = LOW;
    digitalWrite(LED_BUILTIN, state);
  }
}

// Function that is run whenever an interrupt is detected.
void pulse() {
    time2 = millis();
    state = HIGH;
}
