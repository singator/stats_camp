// a simple program to print the heart rate at every pulse.

const byte interruptPin = 2;
// volatile byte state = LOW;
unsigned long time1, time2;
byte count=0;
volatile unsigned long hr = 0.0;

void setup() {
  // pinMode(LED_BUILTIN, OUTPUT);
  pinMode(interruptPin, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(interruptPin), blink, RISING);
  Serial.begin(9600);
  Serial.println("Get ready...");
  delay(5000);
  time1 = millis();
  // Serial.print("Start time: ");
  // Serial.println(time1); 
}

void loop() {
  // digitalWrite(LED_BUILTIN, state);
}

void blink() {
  if (count > 0) {
    Serial.print("HR: ");
    time2 = millis();
    hr = 60000 / (time2 - time1);
    Serial.println(hr, DEC);
    time1 = time2;
  } else {
    count += 1;
  }
}
