// The Nature of Code
import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

class bikeStackClass {
  int mapval, ticker, interval, boxSize, boxNum, sss, score;
  
  
  // A reference to our box2d world
  PBox2D box2d;
  
  // A list we'll use to track fixed objects
  ArrayList<Boundary> boundaries;
  // A list for all of our rectangles
  ArrayList<Box> boxes;

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
  boundaries.add(new Boundary(0,0,5,width));
  boundaries.add(new Boundary(width,0,5,width));
  boundaries.add(new Boundary(400,500,200,5));
  
  
  
  bikeStackClass() {
      mapval = 20;
      ticker = 0;
      interval = 50;
      boxSize=60;
      boxNum=2;
      score=0;
    
  }
  
  void display() {
    
    box2d.setGravity((SensorData.rotVal*10)*5 , -5);
    background(255);
    text("Score:" + score, 50, 50);

    box2d.step();

    if (ticker > interval) {
      Box p = new Box(width/2,height-(boxSize*boxNum)-50, boxSize);
      boxes.add(p);
      ticker=0;
      boxNum++;
      score++;
    }

    for (Box b: boxes) {
      b.display();
    }

  
    for (int i = boxes.size()-1; i >= 0; i--) {
      Box b = boxes.get(i);
      if (b.getY().y > 600) {
        reset();
      }
    }
    ticker++;
    }
  
  
  void reset() {
    for (int i = boxes.size()-1; i >= 0; i--) {
      Box b = boxes.get(i);
        boxes.remove(i);
    }
    boxNum = 2;
    ticker = -100;
    boxes.clear();
    score=0;

  }
  
  
}
  
