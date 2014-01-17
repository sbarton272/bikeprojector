
// Main application

//Apps
BikeProximity bikeProximity;
SensorData sensorData;
compassClass compass;
Shells shells;

void setup() {
  size(960,720);
  
  sensorData = new SensorData(this);
  //bikeProximity = new BikeProximity(this, sensorData);
  //compass = new compassClass(sensorData, 10,10,100, 100);
  shells = new Shells(this, sensorData);
}

void draw() {
  sensorData.update();                //update the sensors
  //bikeProximity.display();            //show the bikeProximity
  //compass.display();
  shells.display();                 //show the shells game concept
}
