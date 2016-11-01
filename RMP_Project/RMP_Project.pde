import processing.video.*;
import java.awt.*;

PImage image;
PImage readImage;
boolean showImage = true;
int time = millis();

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
  if(showImage == true){
    image(image,0,0);
    textSize(22);
    text("Put your face in the hole!", 10, 30);
    text("Press Enter To Take Screenshot! (Saved to /data)", 10,height-50);
  }
  else{
    readImage = loadImage ("screenShotSaved.tif");
    image(readImage,0,0);
  }
}


void keyPressed(){
  if(keyCode == ENTER){
    save("data/screenShotSaved.tif");
    readImage();
  }
}

void readImage(){
  showImage = false;
}