// Car Proximity Detection
// Output video if car too close
// Code for serial started from https://github.com/Illutron/AdvancedTouchSensing

import processing.serial.*;
import processing.video.*;

boolean DEBUG = true;
int SerialPortNumber=2;
int PortSelected=0;
int BAUD = 9600;

/*   =================================================================================       
 Global variables
 =================================================================================*/

int SENSER_THRESHOLD = 100;
int sensorData = 0;
int pSensorData = 0;
int SELECTED_CAMERA = 0;
float EASING = 0.15;

/*   =================================================================================       
 Local variables
 =================================================================================*/

Serial arduinoPort;                                        // The serial port object
Capture camera;

/*   =================================================================================       
 Setup
 =================================================================================*/

void setup(){
  size(960,720);

  SerialPortSetup();
  CameraSetup();

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

//  // distance based response
//  if ( objectDetected(sensorData) ) {
//    println("Object detected");
//    
//    detectionResponse();
//
//  } else if ( objectCaution(sensorData) ) {
//    println("Object caution");
//    
//    cautionResponse();
//
//  } else if ( objectDanger(sensorData) ) {
//    println("Object danger");
//    
//    dangerResponse();
//
//  } else {
//    println("Object NOT detected");
//    
//    regularResponse();
//
//  }

// Proximity visualization
pushStyle();
pushMatrix();
  ellipseMode(CENTER);
  noFill();
  stroke(255,0,0);
  strokeWeight(20);
  translate(width/2, height/2);
  arc(0,0,700,700, PI*.75-radians(sensorData), PI*.75+radians(sensorData));
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

void SerialPortSetup() {

  println( Serial.list() );

  if( PortSelected < Serial.list().length ) {
    String portName = Serial.list()[PortSelected];
    arduinoPort = new Serial(this, portName, BAUD);
    delay(50);
    arduinoPort.clear(); 
    arduinoPort.bufferUntil('\n');
  } else {
    println( "No serial :(" );
  }
}

/* ============================================================    
 serialEvent will be called when something is sent to the 
 serial port being used. 
 ============================================================   */

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

/* ============== Sensor Value Methods ========================= */

boolean objectDetected( int data ) { 
  return data < SENSER_THRESHOLD;
}

/*   =================================================================================       
 Camera
 =================================================================================*/

void CameraSetup() {

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

void keyPressed() {
  if (key == '+') {
    sensorData += 25;
  } else if (key == '-') {
    sensorData -= 25;
  }
  
}
