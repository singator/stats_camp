import processing.serial.*;

Serial myPort;        // The serial port
int xPos = 1;         // horizontal position of the graph
float inByte = 0;

void setup () {
  // set the window size:
  size(610, 480);

  // List all the available serial ports
  // if using Processing 2.1 or later, use Serial.printArray()
  //println(Serial.list());

  // I know that the first port in the serial list on my mac
  // is always my  Arduino, so I open Serial.list()[0].
  // Open whatever port is the one you're using.
  // myPort = new Serial(this, Serial.list()[0], 9600);
  myPort = new Serial(this, "COM6", 9600);


  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');

  // set inital background:
  stroke(0);
  strokeWeight(2);
  background(#FFFFFF, 0);
  line(10, 0, 10, 480);
  line(0, 240, 610, 240);
}
void draw () {
  // draw the line:
  stroke(127, 34, 255);
  point(xPos, height/2 - inByte);

  // at the edge of the screen, go back to the beginning:
  if (xPos >= width) {
    xPos = 0;
    background(#FFFFFF, 0);
    stroke(0);
    strokeWeight(2);
    line(10, 0, 10, 480);
    line(0, 240, 610, 240);

  } else {
    // increment the horizontal position:
    xPos++;
  }
}


void serialEvent (Serial myPort) {
  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');

  if (inString != null) {
    // trim off any whitespace:
    inString = trim(inString);
    // convert to an int and map to the screen height:
    inByte = float(inString);
    //println(inByte);
    inByte = map(inByte, 0, 3, 0, height/2);
  }
}