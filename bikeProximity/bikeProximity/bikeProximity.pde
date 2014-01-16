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

/*   =================================================================================       
 Global variables
 =================================================================================*/

Serial arduinoPort;
Capture camera;
Minim minim;
AudioPlayer dangerSiren, warningBeep;
AudioInput input;

int sensorData = 0;


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
  
  if (DEBUG) {
    print( "#### Sensor Data" );
    print( ", " + Integer.toString(sensorData) );
    println();
  }

  // camera
  if (camera.available() == true) {
    camera.read();
  }

  image(camera, 0, 0);

    dangerSiren.play();
    delay(1000);

  // distance based response
  if ( objectDetected(sensorData) ) {
    println("Object detected");
    
    //detectionResponse();

  } else if ( objectCaution(sensorData) ) {
    println("Object caution");
    
    //cautionResponse();
    warningBeep.play();

  } else if ( objectDanger(sensorData) ) {
    println("Object danger");
    
    //dangerResponse();
    dangerSiren.play();

  } else {
    println("Object NOT detected");
    
    regularResponse();

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
