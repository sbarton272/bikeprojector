// The Nature of Code
import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import ddf.minim.*;


// Main application
Minim minim;

//Apps
BikeProximity bikeProximity;
SensorData sensorData;
compassClass compass;
Shells shells;
bikeStackClass stackGame;

void setup() {

  size(displayWidth, displayHeight);
    minim = new Minim(this);


  sensorData = new SensorData(this);
  bikeProximity = new BikeProximity(this, sensorData);
  compass = new compassClass(sensorData, (height-50)/2, (height-50)/2, (height-50), (height-50));
  shells = new Shells(this, sensorData);
  stackGame = new bikeStackClass(this, sensorData);
}

void draw() {
  sensorData.update();                //update the sensors


  println( "STATE: " + sensorData.stateVal );

  if (sensorData.stateChange) {
    shells.cleanup();
    bikeProximity.cleanup();
  }

  switch( sensorData.stateVal ) {
  case 1:
    //shells.cleanup();
    //bikeProximity.cleanup();
    stackGame.display();
    break;
  case 2:
    //bikeProximity.cleanup();
    shells.display();
    break;
  case 3:
    //shells.cleanup();
    bikeProximity.display();
    break;
  case 4:
    //bikeProximity.cleanup();
    //shells.cleanup();
    compass.display();
    break;
  default:
    //bikeProximity.cleanup();
    //shells.cleanup();
    break;
  }
}

