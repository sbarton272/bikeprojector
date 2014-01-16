// Car Proximity Detection
// Output video if car too close
// Code for serial started from https://github.com/Illutron/AdvancedTouchSensing

import processing.serial.*;

boolean DEBUG = true;
int SerialPortNumber=2;
int PortSelected=2;
int BAUD = 9600;

/*   =================================================================================       
 Global variables
 =================================================================================*/

public static final int NUM_SENSORS = 2;
int[NUM_SENSORS] sensorData;

/*   =================================================================================       
 Local variables
 =================================================================================*/

Serial arduinoPort;                                        // The serial port object

/*   =================================================================================       
 Setup
 =================================================================================*/

void setup(){

  SerialPortSetup();

}

/*   =================================================================================       
 Draw
 =================================================================================*/

void draw() {

  if (DEBUG) {
    println( "#### Sensor Data" );
    for( int val: sensorData ){
      print( ", " + Integer.toString(val) );
    }
  }



}

/*   =================================================================================       
 Serial
 =================================================================================*/

void SerialPortSetup() {

  println( Serial.list() );

  String portName = Serial.list()[PortSelected];
  arduinoPort = new Serial(this, portName, BAUD);
  delay(50);
  arduinoPort.clear(); 
  arduinoPort.buffer(20);
}

/* ============================================================    
 serialEvent will be called when something is sent to the 
 serial port being used. 
 ============================================================   */

void serialEvent(Serial arduinoPort) {

  while (arduinoPort.available() > 0)
  {
    String inBuffer = myPort.readString();   
  
    if (inBuffer != null) {
      println(inBuffer);
  
      updateSensors(splitTokens(inBuffer, ", "));

    }
  }
}

/* ============== Sensor Value Methods ========================= */

// destructive
void updateSensors(String[] data) {

  for( int i = 0; i < NUM_SENSORS; i++ ){
    if( i < data.size() ) {
      sensorData[i] = Integer.parseIntdata(data[i]);
    }
  }

}

boolean objectDetected( int data ) { 
  return false;
}