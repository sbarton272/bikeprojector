
class Shells {
  AudioPlayer song;
  PApplet parent;

  boolean debounced = true;
  int lastMillis = 0;

  Shell[] shells;
  SensorData sensorData;

  Shells (PApplet parent, SensorData _sensorData) {
    sensorData = _sensorData;
    this.parent = parent;

    shells = new Shell[3];

    shells[0] = new Shell(1, 0);
    shells[1] = new Shell(2, 2*PI*2/3);
    shells[2] = new Shell(3, PI*2/3);

    minim = new Minim(parent);

    // this loads mysong.wav from the data folder
    song = minim.loadFile("mario_kart_song.mp3");
    song.play();
    song.loop();
    song.mute();
  }

  void display() {
    song.unmute();
    background(0);

    // Move reference point to the center of the screen to make things easy
    //translate(width/2, height/2);

    for (int i = 0; i < 3; i++) {
      shells[i].move();
      shells[i].display();
    }

    if (millis() - lastMillis > 200)
      debounced = true;

    if (debounced && sensorData.stateVal == 8) { //if the button is pressed
      //search for the shell in front of me
      int aux = 0;
      int min = 10000;
      for (int i = 0; i < 3; i++) {
        if (!(shells[i].launched) && shells[i].y < min) {
          min = shells[i].y;
          aux = i;
        }
      }
      if (min != 10000) //if not all shells have been launched
        shells[aux].launch();

      lastMillis = millis();
      debounced = false;
    }
  }

  void cleanup () {
    song.mute();
  }

  class Shell {
    PImage img;  
    float speed = 1;
    int cx = width/2;
    int cy = height;
    int x = 0;
    int y = 0;
    int r = width/2;
    int imgWidth = 200;
    float offsetAngle = 0;
    int stepSize = 20;
    boolean launched = false;
    int id = 0;

    Shell (int id, float angle) {
      this.id = id;
      offsetAngle = angle;
      img = loadImage("shell.gif");
    }

    void move() {
      float t = millis()/250.0f;

      if (!launched) {
        x = (int)(cx+r*cos(t + offsetAngle));
        y = (int)(cy+r*sin(t + offsetAngle));
      } 
      else {
        y -= stepSize;
      }
    }

    void display() {
      image(img, x - imgWidth/2, y - imgWidth/2);

      /*
    if (launched)
       fill(255, 0, 0);
       else
       fill(255);
       
       textSize(40);
       text("" + id, x, y);
       */
    }

    void launch() {
      launched = true;
      x = cx;
      y = cy-r;
    }
  }
}

