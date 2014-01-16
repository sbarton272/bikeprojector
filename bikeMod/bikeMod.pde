import oscP5.*;
import netP5.*;

// Global variables
OscP5 oscP5;
float accelX, accelY, accelZ;
float PaccelX, PaccelY, PaccelZ;
float smooth;

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
  
  PaccelX = 0;
  PaccelY = 0;
  PaccelZ = 0;
  
  smooth = 0.5;
}

// This is called about 60 times a second
void draw(){
  // Draw a black background on top of everything every frame. Acts as a clean slate
  background(0);
  
  // Set the fill color of the next object
  fill(255);
  
  // Move reference point to the center of the screen to make things easy
  translate(width/2, height/2);
  
  accelX = accelX + smooth * (PaccelX - accelX);
  accelY = accelY + smooth * (PaccelY - accelY);
  
  // Draw rectangle at the center of the screen. -50 is to compensate for the fact that rectangles are drawn from upper left
  rect(-50-accelX, -50+accelY, 100, 100);
  println(accelX + accelY + accelZ);
  
  PaccelX = accelX;
  PaccelY = accelY;
}

void oscEvent(OscMessage theOscMessage) {
  
  // Debug information
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
  
  // Check to see if the address of the OscMessage is accellerometer data. Press "?" on the GyrOSC app to see the addresses
  if (theOscMessage.checkAddrPattern("/gyrosc/accel") == true) 
  {
    // Check to see if the OscMessage contains the right amount of values. Eg. fff means 3 float values
    if (theOscMessage.checkTypetag("fff")) {
      
      // Map the incoming values with a range of -3.0-3.0 to something more visible on screen, like -200.0-200.0
      accelX = map(theOscMessage.get(0).floatValue(), -3.0, 3.0, -500.0, 500.0);
      accelY = map(theOscMessage.get(1).floatValue(), -3.0, 3.0, -500.0, 500.0);
      accelZ = map(theOscMessage.get(2).floatValue(), -3.0, 3.0, -500.0, 500.0);
    }
  }
  
}
