// a simple program to print the heart rate at every pulse.

const byte interruptPin = 2;
volatile byte state = LOW;
unsigned long time1, time2;
byte count=0;
volatile unsigned long hr = 0.0;

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(interruptPin, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(interruptPin), blink, RISING);
  Serial.begin(9600);
  //Serial.println("Get ready...");
  delay(5000);
  time1 = millis();
}

void loop() {
  digitalWrite(LED_BUILTIN, state);
}

void blink() {
    //Serial.print("HR: ");
    time2 = millis();
    hr = 60000 / (time2 - time1);
    Serial.print(hr);
    Serial.print(",");
    Serial.println(time2);
    time1 = time2;
}
