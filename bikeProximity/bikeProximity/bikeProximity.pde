// Car Proximity Detection
// Output video if car too close
// Code for serial started from https://github.com/Illutron/AdvancedTouchSensing

import processing.serial.*;
import processing.video.*;

boolean DEBUG = false;
int SerialPortNumber=2;
int PortSelected=0;
int BAUD = 9600;

/*   =================================================================================       
 Global variables
 =================================================================================*/

int THRES = 100;
int sensorData = 0;

/*   =================================================================================       
 Local variables
 =================================================================================*/

Serial arduinoPort;                                        // The serial port object
Capture camera;

/*   =================================================================================       
 Setup
 =================================================================================*/

void setup(){
  size(640, 480);

  SerialPortSetup();

  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
  } 

}

/*   =================================================================================       
 Draw
 =================================================================================*/

void draw() {

  arduinoPort.write("A");
<<<<<<< HEAD
  println("A");
=======
>>>>>>> 13ae5c89d1d67081204dcb761eb13e26e9431b7e
  
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
  
<<<<<<< HEAD
    if (inBuffer != null && inBuffer.matches("[0-9]+") && inBuffer.length() > 1) {
=======
    if (inBuffer != null) {
>>>>>>> 13ae5c89d1d67081204dcb761eb13e26e9431b7e
      println(inBuffer);
  
      sensorData = Integer.parseInt(inBuffer);

    }
  }
}

/* ============== Sensor Value Methods ========================= */

boolean objectDetected( int data ) { 
  return data < THRES;
}
