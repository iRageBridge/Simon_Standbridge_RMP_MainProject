import processing.video.*;
import java.awt.*;

PImage image;
PImage readImage;
boolean showImage = true;

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
  
  else if(showImage != true){
    readImage = loadImage ("screenShotSaved.tif");
    readImage.loadPixels();
    //image(readImage,0,0);
    for(int x = 0; x < readImage.width; x++){
      for(int  y = 0; y < readImage.height; y++){
        int i = (x+(y * readImage.width));
        if(readImage.pixels[i] == color(0)){
          readImage.pixels[i] = color(255,0);
        } 
        else {
          readImage.pixels[i] = readImage.pixels[i];
        }
      }
    }
    image(videoInput,0,0);
    readImage.updatePixels();
    image(readImage,0,0);
    noLoop();
  }
}

void keyPressed(){
  if(keyCode == ENTER){
    save("data/screenShotSaved.tif");
    showImage = false;
  }
}