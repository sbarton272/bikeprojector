

class compassClass {
    PImage compass;
    float rotation, compassx, compassy;
    int compassheight, compasswidth, w, h;
    
    compassClass(float x, float y, int w, int h) {
      compassheight = w;
      compasswidth = h;
      compassx = x;
      compassy = y;
      compass = loadImage("compass.gif");
    }
  
  // This is called about 60 times a second
  void display(){
    rotation = SensorData.compassVal();
    pushMatrix();
      rotate(radians(rotation));
      image(compass, compassx-compasswidth, compassy-compassheight);
    popMatrix();
    
  }
