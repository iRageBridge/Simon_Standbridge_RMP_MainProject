import processing.video.*;
import java.awt.*;

PImage image;
Capture videoInput;
void setup(){
  size(640,480);
  
 
  videoInput = new Capture(this,640,480);
  videoInput.start();
  
  background(0);
  
  image = loadImage("processing.png");
}

void draw(){  
  if(videoInput.available()){
    videoInput.read();
    //scale(-1,1);
    image(videoInput,0,0);
    
  }
  //fill(0,0,0);
  //ellipse(width/2,height/2,-200,-250);
  image(image,0,0);
}

void keyPressed(){
    save("screenShot" + frameCount + ".tif");
}