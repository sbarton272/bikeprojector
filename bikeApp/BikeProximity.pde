// Car Proximity Detection

import processing.serial.*;
import cc.arduino.*;
import processing.video.*;
import ddf.minim.*;

class BikeProximity {
  /*   =================================================================================       
   Constants
   =================================================================================*/

  boolean DEBUG = true;
  
  int SENSOR_DETECT = 100;
  int SENSOR_CAUTION = 50;
  int SENSOR_DANGER = 30;
  int SENSOR_MAX = 500;

  int SELECTED_CAMERA = 0;
  int PORT_SELECTED=0;

  float EASING = 0.15;

  /*   =================================================================================       
   Global variables
   =================================================================================*/

  Capture camera;
  Minim minim, danger;
  AudioPlayer dangerSiren, warningBeep;
  
  AudioInput input;
  SensorData sensorData;
  PApplet parent;
  float arcValue = 0;
  int proximitySensor;


  /*   =================================================================================       
   Setup
   =================================================================================*/

  BikeProximity(PApplet parent, SensorData sensorData){
    danger = new Minim(parent);
    this.sensorData = sensorData;
    this.proximitySensor = (int)sensorData.proxData;
    this.parent = parent;

    cameraSetup();
    audioSetup();

    dangerSiren.play();
    warningBeep.play();
    dangerSiren.loop();
    warningBeep.loop();
    dangerSiren.mute();
    warningBeep.mute();

  }

  /*   =================================================================================       
   Draw
   =================================================================================*/

  void display() {
    // Data from arduino
    proximitySensor = (int)sensorData.proxData;
    println(proximitySensor);
    // Draw a black background on top of everything every frame. Acts as a clean slate
    background(0);

    // camera (always show, update if available)
    if (camera.available() == true) {
      camera.read();
    }

    image(camera, 0, 0);

    // distance based response
    if ( objectDanger(proximitySensor) ) {
      println("Object danger");
      
      dangerSiren.unmute();
      warningBeep.mute();

    } else if ( objectCaution(proximitySensor) ) {
      println("Object caution");
      
      dangerSiren.mute();
      warningBeep.unmute();
      
    } else if ( objectDetected(proximitySensor) ) {
      println("Object detected");
      
      dangerSiren.mute();
      warningBeep.mute();

    } else {
      println("Object NOT detected");
      
      dangerSiren.mute();
      warningBeep.mute();
      
    }

  // Proximity visualization
  pushStyle();
  pushMatrix();

    arcValue += ((float)proximitySensor-arcValue) * EASING;
    float arcSize = map(arcValue, 0, SENSOR_MAX, 180, 0);
    ellipseMode(CENTER);
    noFill();
    color from = color(0,255,0);
    color to = color(255,0,0);
    color strokeColor = lerpColor(from,to,map(arcSize,0, 180, 0,1));
    stroke(strokeColor);
    strokeWeight(20);
    strokeCap(SQUARE);
    translate(width/2, height/2);
    arc(0,0,700,700, PI*.75-radians(arcSize), PI*.75+radians(arcSize));

  popMatrix();
  popStyle();

    if (DEBUG) {
      print( "#### Sensor Data" );
      print(", " + "Averaged Data: " + Integer.toString(proximitySensor));
      println();
    }
  }


  /*   =================================================================================       
   Sensor
   =================================================================================*/

  boolean objectDetected( int data ) { 
    return data < SENSOR_DETECT;
  }

  boolean objectCaution( int data ) { 
    return data < SENSOR_CAUTION;
  }

  boolean objectDanger( int data ) { 
    return data < SENSOR_DANGER;
  }

  /*   =================================================================================       
   Camera
   =================================================================================*/

  void cameraSetup() {

    String[] cameras = Capture.list();
    
    if (cameras.length == 0) {
      println("There are no cameras available for capture.");
      exit();
    } else {
      println("Available cameras:");
      for (int i = 0; i < cameras.length; i++) {
        print(Integer.toString(i) + "\t");
        println(cameras[i]);
      }
    } 

    camera = new Capture(parent, cameras[SELECTED_CAMERA]);
    camera.start();   
  }

  /*   =================================================================================       
   Audio
   =================================================================================*/


  void audioSetup() {
    minim = new Minim(parent);
    dangerSiren = minim.loadFile("siren.mp3");
    warningBeep = minim.loadFile("beep.mp3");

    if ( dangerSiren == null || warningBeep == null ) println("Didn't get audio");
  }


  // dev purposes
  void keyPressed() {
    if (key == '+') {
      proximitySensor += 25;
    } else if (key == '-') {
      proximitySensor -= 25;
    }
    
  }

}

