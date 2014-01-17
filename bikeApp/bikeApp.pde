// The Nature of Code
import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

// Main application

//Apps
BikeProximity bikeProximity;
SensorData sensorData;
compassClass compass;
Shells shells;
bikeStackClass bikeStack;

void setup() {
  size(960,720);
  
  sensorData = new SensorData(this);
  //bikeProximity = new BikeProximity(this, sensorData);
  //compass = new compassClass(sensorData, 10,10,100, 100);
  bikeStack = new bikeStackClass(this, sensorData);
}

void draw() {
  sensorData.update();                //update the sensors
  //bikeProximity.display();            //show the bikeProximity
  //compass.display();
  bikeStack.display();
}
