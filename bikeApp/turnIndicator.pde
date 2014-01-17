class turnIndicator{
  
PImage arrow;
float centerThreshold;
SensorData sensordata;
int arrowheight, arrowwidth, indicatorWidth;
// This is called once
turnIndicator(){
  // Set up an arbitrary screen size
  size(800,600);
  
  
  // Initialize arrow crap
  arrowheight = 225;
  arrowwidth = 150;
  indicatorWidth = 100;
  
  centerThreshold=.2;
  arrow = loadImage("newArrow.gif");
  
}

// This is called about 60 times a second
void draw(){
  // Draw a black background on top of everything every frame. Acts as a clean slate
  background(0);

  if (-sensordata.rotVal < -centerThreshold) { //Turned right
       print("right");
       rect(800-indicatorWidth,0,indicatorWidth,600);
  } else if (-sensordata.rotVal > centerThreshold) {  //Turned left
       print("left");
       rect(0,0,indicatorWidth,600);
  }
  
  // Set the fill color of the next object
  fill(255);
 
  // Move reference point to the center of the screen to make things easy
  translate(width/2, (height/2) + 50);
  
  
  //redraw arrow adjusted for image height and width
  image(arrow, -arrowwidth, -arrowheight - 75);
  
}
}
