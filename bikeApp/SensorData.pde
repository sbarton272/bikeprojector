import processing.serial.*;
import oscP5.*;
import netP5.*;
import cc.arduino.*;


class SensorData{

// Global variables for anyone to access
float accelX, accelY, accelZ, compassVal, rotVal, proxData;

//worker variables
float PaccelX, PaccelY, PaccelZ, RawAccelX, RawAccelY, RawAccelZ;
float smooth; ;
int smoothedProxData;


int numReadings = 20;
int[] readingsA = new int[numReadings];     // the readings from the analog input
int indexA = 0;                  // the index of the current reading
int totalA = 0;                  // the running total
int averageA = 0;                // the averageA

float[] rotationVals = new float[16];



/////////////////////////////////////////////////////////////////
//////        set to false when running as a class //////////////
boolean DEBUG = false;
PFont f;

/*   =================================================================================       
 Objects
 =================================================================================*/
OscP5 oscP5;
Arduino arduino;
PApplet parent;


/*   =================================================================================       
 Setup
 =================================================================================*/
 SensorData(PApplet thisParent){
  parent = thisParent;
  
  if(DEBUG)
  {
    size(400,600);
    f = createFont("Arial",10,true);
    textFont(f,36);
    fill(0,255,0);
  }

  // Initialize the oscP5 library object
  oscP5 = new OscP5(this,12000);
  
  // Initialize accelerometer floats
  accelX = 0;
  accelY = 0;
  accelZ = 0;
  
  PaccelX = 0;
  PaccelY = 0;
  PaccelZ = 0;
  
  smooth = 0.5;
  
  //set up arduino 
  println(Arduino.list());
  if(Arduino.list()!=null){
    arduino = new Arduino(parent, Arduino.list()[0], 57600);
  }
}

// This is called about 60 times a second
void update(){
  //-----------------------DEBUG VIEW------------------------------
  if(DEBUG)
  {
    background(0);
    showData();
  }
  
  
  
  //-------------------------update ACCEL values-------------------------------
  accelX = RawAccelX + smooth * (PaccelX - accelX);
  accelY = RawAccelY + smooth * (PaccelY - accelY);
  accelZ = RawAccelZ + smooth * (PaccelZ - accelZ);
  PaccelX = RawAccelX;
  PaccelY = RawAccelY;
  
  
  //-------------------------update proxData values-------------------------------
  int sensorRaw = arduino.analogRead(0);
  proxData = averaged(sensorRaw);
  
  
}



/*   =================================================================================       
 parse OSC messages
 =================================================================================*/
void oscEvent(OscMessage theOscMessage) {
  
  // Debug information
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
  
  //--------------------------get accel vals --------------------------------------------
  if (theOscMessage.checkAddrPattern("/gyrosc/accel") == true) 
  {
    // Check to see if the OscMessage contains the right amount of values. Eg. fff means 3 float values
    if (theOscMessage.checkTypetag("fff")) {
      
      // Map the incoming values with a range of -3.0-3.0 to something more visible on screen, like -200.0-200.0
      RawAccelX = map(theOscMessage.get(0).floatValue(), -3.0, 3.0, -500.0, 500.0);
      RawAccelY = map(theOscMessage.get(1).floatValue(), -3.0, 3.0, -500.0, 500.0);
      RawAccelZ = map(theOscMessage.get(2).floatValue(), -3.0, 3.0, -500.0, 500.0);
    }
  }
  
  //--------------------------get compassVal-----------------------------------------------
  else if (theOscMessage.checkAddrPattern("/gyrosc/comp") == true) 
  {
    // Check to see if the OscMessage contains the right amount of values. Eg. fff means 3 float values
    if (theOscMessage.checkTypetag("f")) {
      //rotation = map(theOscMessage.get(0).floatValue(), 0, 360, -mapval, mapval);
      compassVal = theOscMessage.get(0).floatValue();
    }
  }
  
  
  //------------------------get rotVal---------------------------------------
  else if (theOscMessage.checkAddrPattern("/gyrosc/rmatrix") == true) 
  {
    int rotationMapVal =  2;
    // Check to see if the OscMessage contains the right amount of values. Eg. fff means 3 float values
    if (theOscMessage.checkTypetag("fffffffff")) {
      //maps each item in the rotation matrix between two values
      for(int i =0; i<9;i++){
         rotationVals[i] = map(theOscMessage.get(i).floatValue(), -1, 1, -rotationMapVal, rotationMapVal);
      } 
      rotVal = rotationVals[3];
    }  
  } 
}




//----------------------------showData-----------------------------
void showData()
{
  int inc = 35;
  text("accelX: " + str(accelX), 5, inc);
  text("accelY: " + str(accelY), 5, inc*2);
  text("accelZ: " + str(accelZ), 5, inc*3);
  text("compassVal: " + str(compassVal), 5, inc*4);
  text("rotVal: " + str(rotVal), 5, inc*5);
  text("proxData: " + str(proxData), 5, inc*6);
}



//----------------------------averaged-----------------------------
int averaged(int data){
  // subtract the last reading:
    totalA = totalA - readingsA[indexA];         
    // read from the sensor:  
    readingsA[indexA] = data;
    // add the reading to the total:
    totalA = totalA + readingsA[indexA];       
    // advance to the next position in the array:  
    indexA = indexA + 1;                    

    // if we're at the end of the array...
    if (indexA >= numReadings) 
    {
        // ...wrap around to the beginning: 
        indexA = 0;                           
    }
    // calculate the average:
    averageA = totalA / numReadings;  
    return averageA;
}

}
