
// Main application

//Apps
BikeProximity bikeProximity;
SensorData sensorData;

void setup() {
  size(960,720);
  
  sensorData = new SensorData();
  bikeProximity = new BikeProximity(this, sensorData);
  
}

void draw() {
  bikeProximity.display();
}
