import processing.video.*;
import java.awt.*;

PImage backgroundImage;
PImage readImage;
PImage newImage;
boolean showImage = true;
int xPos = -width/2;
Capture videoInput;
void setup(){
  size(640,480);

  videoInput = new Capture(this,640,480);
  videoInput.start();
  
  background(127);
  
  backgroundImage = loadImage("processing.png");
}

void draw(){  
  xPos+=10;
  if(xPos >= width){
    xPos= -width/2;
  }

  if(videoInput.available()){
    videoInput.read();
    image(videoInput,0,0);
  }
  
  if(showImage == true){
    image(backgroundImage,0,0);
    textSize(22);
    text("Put your face in the hole!", 10, 30);
    text("Press Enter To Take Screenshot! (Saved to /data)", 10,height-50);
  }
  
  else if(showImage != true){
    image(videoInput,0,0);
    readingAndAddingImage();
  }
}

void keyPressed(){
  if(keyCode == ENTER){
    save("data/screenShotSaved.tif");
    showImage = false;
  }
}

void readingAndAddingImage(){
  readImage = loadImage ("screenShotSaved.tif");
  newImage = createImage(readImage.width, readImage.height, ARGB);
  for(int x = 0; x < readImage.width; x++){
    for(int  y = 0; y < readImage.height; y++){
      int i = (x+(y * readImage.width));
      if(readImage.pixels[i] == color(0)){
        newImage.pixels[i] = color(255,0);
      } 
      else {
        newImage.pixels[i] = readImage.pixels[i];
      }
    }
  }
  newImage.save("screenShotSaved.tif");
  image(newImage,xPos,0);
}