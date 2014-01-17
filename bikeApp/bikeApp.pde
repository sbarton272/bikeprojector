
// Main application

//Apps
BikeProximity bikeProximity;
SensorData sensorData;

void setup() {
  size(960,720);
  
  sensorData = new SensorData(this);
  bikeProximity = new BikeProximity(this, sensorData);
  
}

void draw() {
  sensorData.update();                //update the sensors
  bikeProximity.display();            //show the bikeProximity
}
