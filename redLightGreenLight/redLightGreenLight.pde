// TODO: change old values to queue, add current value

import oscP5.*;
import netP5.*;
import java.util.LinkedList;

// Global variables
OscP5 oscP5;
float accelX, accelY, accelZ;
int FILTER_WINDOW_SIZE = 10;
LinkedList oldAccelX, oldAccelY, oldAccelZ; // assume itit to zero

// This is called once
void setup(){
  // Set up an arbitrary screen size
  size(800,600);
  
  // Initialize the oscP5 library object
  oscP5 = new OscP5(this,12000);
  
  // Initialize accelerometer floats
  accelX = 0;
  accelY = 0;
  accelZ = 0;

  // Initialize old accelerometer lists
  oldAccelX = new LinkedList();
  oldAccelY = new LinkedList();
  oldAccelZ = new LinkedList();
}

// This is called about 60 times a second
void draw(){
  // Draw a black background on top of everything every frame. Acts as a clean slate
  background(0);
  
  // Set the fill color of the next object
  fill(255);
  
  // Move reference point to the center of the screen to make things easy
  translate(width/2, height/2);
  
  // Draw rectangle at the center of the screen. -50 is to compensate for the fact that rectangles are drawn from upper left
  rect(-50-accelX, -50+accelY, 100, 100);
  println(str(accelX) + ", " + str(accelY) + ", " + str(accelZ));
}

void oscEvent(OscMessage theOscMessage) {
  
  // Debug information
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
  
  // Check to see if the address of the OscMessage is accellerometer data. Press "?" on the GyrOSC app to see the addresses
  if (theOscMessage.checkAddrPattern("/accxyz") == true) 
  {
    // Check to see if the OscMessage contains the right amount of values. Eg. fff means 3 float values
    if (theOscMessage.checkTypetag("fff")) {
      
      // Map the incoming values to something more visible on screen, like -200.0-200.0
      int accRange = 1;
      float currAccelX = map(theOscMessage.get(0).floatValue(), -accRange, accRange, -200.0, 200.0);
      float currAccelY = map(theOscMessage.get(1).floatValue(), -accRange, accRange, -200.0, 200.0);
      float currAccelZ = map(theOscMessage.get(2).floatValue(), -accRange, accRange, -200.0, 200.0);
    
      // filter the acceleration values
      accelX = filter(currAccelX, oldAccelX);

    }

  }
  
}

float filter(float currentVal, LinkedList oldValues) {
  // equally weigted running average
  float sum = 0;

  // update queue
  oldValues.addFirst(currentVal);
  // delete oldest values if too 
  while (oldValues.size() > FILTER_WINDOW_SIZE) {
    oldValues.removeLast();
  }

  for( Object val : oldValues ) {
    sum += (float)val; // known to contain floats
  }
  sum += currentVal;

  // update oldValues to include 

  return sum / (oldValues.length + 1);
}
