// Car Proximity Detection
// Output video if car too close
// Code for serial started from https://github.com/Illutron/AdvancedTouchSensing

import processing.serial.*;
import processing.video.*;
import ddf.minim.*;

/*   =================================================================================       
 Constants
 =================================================================================*/

boolean DEBUG = false;
int BAUD = 9600;
int SENSOR_MAX = 500;
int SELECTED_CAMERA = 115;
int SERIAL_PORT_NUMBER=2;
int PORT_SELECTED=0;
int AUDIO_BUF_SIZE = 512;
int SENSER_THRESHOLD = 100;

float EASING = 0.15;

/*   =================================================================================       
 Global variables
 =================================================================================*/

Serial arduinoPort;
Capture camera;
Minim minim;
AudioPlayer dangerSiren, warningBeep;
AudioInput input;
int sensorData = 0;
float arcValue = 0;


/*   =================================================================================       
 Setup
 =================================================================================*/

void setup(){
  size(960,720);

  serialPortSetup();
  cameraSetup();
  audioSetup();

}

/*   =================================================================================       
 Draw
 =================================================================================*/

void draw() {
  // Draw a black background on top of everything every frame. Acts as a clean slate
  background(0);

  // Trigger senser read, if present
  if( arduinoPort != null ) {
    arduinoPort.write("A");
  }
  

  // camera
  if (camera.available() == true) {
    camera.read();
  }

  image(camera, 0, 0);

  // distance based response
  
  if ( objectDanger(sensorData) ) {
    println("Object danger");
    
    //dangerResponse();
    dangerSiren.play();

  } else if ( objectCaution(sensorData) ) {
    println("Object caution");
    
    //cautionResponse();
    warningBeep.play();

  } else if ( objectDetected(sensorData) ) {
    println("Object detected");
    
    //detectionResponse();

  } else {
    println("Object NOT detected");
    
    // regularResponse();
  }

// Proximity visualization
pushStyle();
pushMatrix();
  arcValue += ((float)sensorData-arcValue) * EASING;
  ellipseMode(CENTER);
  noFill();
  stroke(255,0,0);
  strokeWeight(20);
  strokeCap(SQUARE);
  translate(width/2, height/2);
  arc(0,0,700,700, PI*.75-radians(arcValue), PI*.75+radians(arcValue));
popMatrix();
popStyle();

  if (DEBUG) {
    print( "#### Sensor Data" );
    print( ", " + Integer.toString(sensorData) );
    println();
  }
}

/*   =================================================================================       
 Serial
 =================================================================================*/

void serialPortSetup() {

  println( Serial.list() );

  if( PORT_SELECTED < Serial.list().length ) {
    
    String portName = Serial.list()[PORT_SELECTED];
    arduinoPort = new Serial(this, portName, BAUD);
    delay(50);
    arduinoPort.clear(); 
    arduinoPort.bufferUntil('\n');
  
  } else {

    println( "No serial :(" );
  
  }
}


void serialEvent(Serial arduinoPort) {

  while (arduinoPort.available() > 0)
  {
    String inBuffer = arduinoPort.readString();   
  
    if (inBuffer != null && inBuffer.matches("[0-9]+") && inBuffer.length() > 1) {

      println(inBuffer);
  
      sensorData = Integer.parseInt(inBuffer);

    }
  }
}

/*   =================================================================================       
 Sensor
 =================================================================================*/

boolean objectDetected( int data ) { 
  return data < SENSOR_MAX;
}

boolean objectCaution( int data ) { 
  return data < (SENSOR_MAX/2);
}

boolean objectDanger( int data ) { 
  return data < (SENSOR_MAX/6);
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

  camera = new Capture(this, cameras[SELECTED_CAMERA]);
  camera.start();   
}

/*   =================================================================================       
 Audio
 =================================================================================*/


void audioSetup() {
  minim = new Minim(this);
  dangerSiren = minim.loadFile("siren.mp3");
  warningBeep = minim.loadFile("beep.mp3");

  if ( dangerSiren == null || warningBeep == null ) println("Didn't get audio");
}

void keyPressed() {
  if (key == '+') {
    sensorData += 25;
  } else if (key == '-') {
    sensorData -= 25;
  }
  
}
