class compassClass {
    PImage compass;
    float rotation, compassx, compassy, oldrotation;
    int compassheight, compasswidth, w, h;
    SensorData sensorData;
    
   /*   =================================================================================       
 constructor
 =================================================================================*/
    compassClass(SensorData _sensorData, float x, float y, int w, int h) {
      sensorData = _sensorData;
      compassheight = w;
      compasswidth = h;
      compassx = x;
      compassy = y;
      compass = loadImage("compass.gif");
    }
  
  // This is called about 60 times a second
  void display(){
    background(0);
    oldrotation = rotation;
    rotation = (sensorData.compassVal+ (.15*oldrotation));
    pushMatrix();
      translate(width/2, height/2);
      rotate(radians(rotation));
      image(compass, compassx-compasswidth, compassy-compassheight, compasswidth, compassheight);
    popMatrix();
    
  }
}
