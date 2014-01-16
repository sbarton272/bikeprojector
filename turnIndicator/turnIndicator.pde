import oscP5.*;
import netP5.*;
PImage arrow;
// Global variables
OscP5 oscP5;
float rotatX, rotatY, rotatZ;


//rotat[7] is the bike turn goodness (AKA left right)
float[] rotat = new float[16];
float centerThreshold;
int mapval;

int arrowheight, arrowwidth, indicatorWidth;
// This is called once
void setup(){
  // Set up an arbitrary screen size
  size(800,600);
  
  // Initialize the oscP5 library object
  oscP5 = new OscP5(this,12000);
  
  // Initialize arrow crap
  arrowheight = 225;
  arrowwidth = 150;
  indicatorWidth = 100;
  
  centerThreshold=.2;
  mapval = 2;
  arrow = loadImage("newArrow.gif");
  
}

// This is called about 60 times a second
void draw(){
  // Draw a black background on top of everything every frame. Acts as a clean slate
  background(0);
  /*
  //Prints Rotation Matrix On Screen
  int val = 0;
  for(int i=1;i<=3;i++) {
    for(int j=1;j<=3;j++){
      text(rotat[val], j*40, i*40);
      val++;
    }
  }*/
  if (-rotat[3] < -centerThreshold) { //Turned right
       print("right");
       rect(800-indicatorWidth,0,indicatorWidth,600);
  } else if (-rotat[3] > centerThreshold) {  //Turned left
       print("left");
       rect(0,0,indicatorWidth,600);
  }
  
  // Set the fill color of the next object
  fill(255);
 
  // Move reference point to the center of the screen to make things easy
  translate(width/2, (height/2) + 50);
  
  
  //rotates canvas
  rotate(rotat[3]);
  
  
  //redraw arrow adjusted for image height and width
  image(arrow, -arrowwidth, -arrowheight - 75);
  


  

}

void oscEvent(OscMessage theOscMessage) {
  
  // Debug information
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
  
  // Check to see if the address of the OscMessage is accellerometer data. Press "?" on the GyrOSC app to see the addresses
  if (theOscMessage.checkAddrPattern("/gyrosc/rmatrix") == true) 
  {
    // Check to see if the OscMessage contains the right amount of values. Eg. fff means 3 float values
    if (theOscMessage.checkTypetag("fffffffff")) {
      
      
      //maps each item in the rotation matrix between two values
      for(int i =0; i<9;i++){
         rotat[i] = map(theOscMessage.get(i).floatValue(), -1, 1, -mapval, mapval);
      }
      
      
      
    }
    
    
      
  }
}
