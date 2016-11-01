import processing.video.*;
import java.awt.*;

PImage image;
PImage readImage;
PImage newImage;
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
    int x;
    int y;
    int i;
    readImage = loadImage ("screenShotSaved.tif");
    newImage = createImage (readImage.width, readImage.height, ARGB);
    image(readImage,0,0);
    for( x = 0; x < readImage.width; x++ ){
      for( y = 0; y < readImage.height; y++ ){
        i = ( ( y * readImage.width ) + x );
        if( readImage.pixels[i] == color( 0, 0, 0 ) ){
          newImage.pixels[i] = color( 0, 0, 0, 0 );
        } 
        else {
          newImage.pixels[i] = readImage.pixels[i];
        }
      }
    }
    newImage.save("data/screenShotSaved.tif");
  }
}

void keyPressed(){
  if(keyCode == ENTER){
    save("data/screenShotSaved.tif");
    showImage = false;
  }
}