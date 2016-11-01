import processing.video.*;
import java.awt.*;

PImage image;
PImage readImage;
PImage newImage;
boolean showImage = true;

Capture videoInput;
void setup(){
  size(640,480);

  videoInput = new Capture(this,640,480);
  videoInput.start();
  
  background(127);
  
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
    //image(videoInput,0,0);
    //readImage.updatePixels();
    image(newImage,0,0);
    //noLoop();
  }
}

void keyPressed(){
  if(keyCode == ENTER){
    save("data/screenShotSaved.tif");
    showImage = false;
  }
}