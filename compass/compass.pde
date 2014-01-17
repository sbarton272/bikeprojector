import oscP5.*;
import netP5.*;
PImage compass;
// Global variables
OscP5 oscP5;
float rotation;

int mapval;

int compassheight, compasswidth;
// This is called once
void setup(){
  // Set up an arbitrary screen size
  size(800,800);
  
  // Initialize the oscP5 library object
  oscP5 = new OscP5(this,12000);
  
  // Initialize compass crap, 300x300
  compassheight = 150;
  compasswidth = 150;
  
  mapval = 2;
  compass = loadImage("compass.gif");

}

// This is called about 60 times a second
void draw(){
  // Draw a black background on top of everything every frame. Acts as a clean slate
  background(0);
      text(rotation, 40, 40);
  
  // Set the fill color of the next object
  fill(255);
  
  // Move reference point to the center of the screen to make things easy
  translate(width/2, height/2);

  //rotates canvas
  rotate(radians(rotation));
  
  
  //redraw compass adjusted for image height and width
  image(compass, -compasswidth, -compassheight);
 

  //println(accelX + accelY + accelZ);
}

void oscEvent(OscMessage theOscMessage) {
  
  // Debug information
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
  
  // Check to see if the address of the OscMessage is accellerometer data. Press "?" on the GyrOSC app to see the addresses
  if (theOscMessage.checkAddrPattern("/gyrosc/comp") == true) 
  {
    // Check to see if the OscMessage contains the right amount of values. Eg. fff means 3 float values
    if (theOscMessage.checkTypetag("f")) {
      
      
      //rotation = map(theOscMessage.get(0).floatValue(), 0, 360, -mapval, mapval);
      rotation = theOscMessage.get(0).floatValue();
    }
  }
  
}
