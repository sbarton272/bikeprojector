
// Main application

//Apps
BikeProximity bikeProximity;
SensorData sensorData;

void setup() {
  
  sensorData = new SensorData();
  bikeProximity = new BikeProximity(this, sensorData);
  
}

void draw() {
  
}
