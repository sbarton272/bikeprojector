// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2011
// PBox2D example

// Basic example of falling rectangles

import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

import oscP5.*;
import netP5.*;
PImage arrow;
// Global variables
OscP5 oscP5;
//rotat[7] is the bike turn goodness (AKA left right)
float[] rotat = new float[16];
float centerThreshold;
int mapval;
int arrowheight, arrowwidth, indicatorWidth;


// A reference to our box2d world
PBox2D box2d;

// A list we'll use to track fixed objects
ArrayList<Boundary> boundaries;
// A list for all of our rectangles
ArrayList<Box> boxes;

void setup() {
  size(800,600);
  smooth();

  // Initialize box2d physics and create the world
  box2d = new PBox2D(this);
  box2d.createWorld();
  // We are setting a custom gravity
  box2d.setGravity(0, -100);

  // Create ArrayLists	
  boxes = new ArrayList<Box>();
  boundaries = new ArrayList<Boundary>();

  // Add a bunch of fixed boundaries
  boundaries.add(new Boundary(0,300,5,600));
  boundaries.add(new Boundary(800,300,5,600));
  boundaries.add(new Boundary(300,600,1000,5));
  
  
  
   // Initialize the oscP5 library object
  oscP5 = new OscP5(this,12000);
  
  // Initialize arrow crap
  arrowheight = 225;
  arrowwidth = 150;
  indicatorWidth = 100;
  
  centerThreshold=.2;
  mapval = 20;
  arrow = loadImage("newArrow.gif");
  
  
}

void draw() {
  
  box2d.setGravity(rotat[3]*100 , -100);
  background(255);

  // We must always step through time!
  box2d.step();

  // Boxes fall from the top every so often
  if (random(1) < 0.2) {
    Box p = new Box(width/2,30);
    boxes.add(p);
  }

  // Display all the boundaries
  for (Boundary wall: boundaries) {
    wall.display();
  }

  // Display all the boxes
  for (Box b: boxes) {
    b.display();
  }

  // Boxes that leave the screen, we delete them
  // (note they have to be deleted from both the box2d world and our list
  for (int i = boxes.size()-1; i >= 0; i--) {
    Box b = boxes.get(i);
    if (b.done()) {
      boxes.remove(i);
    }
  }
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
      println(rotat[3]);
      
      
    }
    
    
      
  }
}

