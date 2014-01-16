const int numReadings = 20;      //number of readings to be averaged


int readingsA[numReadings];     // the readings from the analog input
int indexA = 0;                  // the index of the current reading
int totalA = 0;                  // the running total
int averageA = 0;                // the averageA
int sonarA = 0;

int readingsB[numReadings];     // the readings from the analog input
int indexB = 0;                  // the index of the current reading
int totalB = 0;                  // the running total
int averageB = 0;                // the averageA
int sonarB = 5;


void setup() {
   
  Serial.begin(9600);
    // initialize all the readings to 0: 
    Serial.println("initializing...");
   
   
      for (int thisReading = 0; thisReading < numReadings; thisReading++) 
      {
          readingsA[thisReading] = 0;   
      }
      
      for (int thisReading = 0; thisReading < numReadings; thisReading++) 
      {
          readingsB[thisReading] = 0;   
      }
   }
   



void loop() {

//----------------------------------------------------
//-----------------read and smooth sonarA-------------
  // subtract the last reading:
    totalA = totalA - readingsA[indexA];         
    // read from the sensor:  
    readingsA[indexA] = analogRead(sonarA);
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

//----------------------------------------------------
//-----------------read and smooth sonarB-------------
  // subtract the last reading:
    totalB = totalB - readingsB[indexB];         
    // read from the sensor:  
    readingsB[indexB] = analogRead(sonarB);
    // add the reading to the total:
    totalB = totalB + readingsB[indexB];       
    // advance to the next position in the array:  
    indexB = indexB + 1;                    

    // if we're at the end of the array...
    if (indexB >= numReadings) 
    {
        // ...wrap around to the beginning: 
        indexB = 0;                           
    }

    // calculate the average:
    averageB = totalB / numReadings;  
    
    
    Serial.print(averageA);
    Serial.print(", ");
    Serial.println(averageB);
    
  
}    
