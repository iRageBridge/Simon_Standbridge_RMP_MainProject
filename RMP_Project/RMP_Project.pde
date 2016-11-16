import processing.video.*;
import ddf.minim.*;
import java.awt.*;
import javax.swing.JOptionPane;

Minim minim;
AudioInput audioInput;

PImage image;
PImage readImage;
PImage newImageBottom;
PImage newImageRows;
boolean showImage = true;
boolean clapRegistered = false;
boolean movePic = false;
float rotation=0;
float yPos=0;
float xPos=0;
float transWidth=0;
float transHeight=0;
float imageScale=0;

Capture videoInput;
void setup(){
  frameRate(48);
  size(640,480);

  videoInput = new Capture(this,640,480);
  videoInput.start();
  
  minim = new Minim(this);
  audioInput = minim.getLineIn();
  
  background(127);
  
  image = loadImage("processing.png");
  JOptionPane.showMessageDialog(null, "Put your face in the hole, clap to take a picture!");
}

void draw(){
  if(clapRegistered == true){
    imageScale = imageScale % 100;
    rotation +=0.3;
    xPos+=10;
    yPos +=10;
    transWidth = width/2;
    transHeight = height/2;
  }
  
  if(yPos >= height/2){
    yPos= -height/2;
    rotation -=.6;
  }
  
  if(xPos >= width/2){
    xPos= -width/2;
    rotation -=.6;
  }

  if(videoInput.available()){
    videoInput.read();
    image(videoInput,0,0);
  }
  
  if(showImage == true){
    image(image,0,0);
  }
  
  else if(showImage != true){
    shatterImage(4);
  }
  
  if(((audioInput.left.level()*100) > 99) && clapRegistered == false){
    clapRegistered = true;
  }
}

void keyPressed(){
  if(keyCode == ENTER){
    save("data/screenShotSaved.tif");
    showImage = false;
  }
}

void shatterImage(int rows){
  for(int j = 2; j <= rows+1; j++){
    readImage = loadImage ("screenShotSaved.tif");
    newImageRows = createImage(readImage.width, readImage.height/j, ARGB);
    for(int x = 0; x < readImage.width; x++){
      for(int  y = 0; y < readImage.height/j; y++){
        int i = (x+(y * readImage.width));
        if(readImage.pixels[i] == color(0)){
          newImageRows.pixels[i] = color(255,0);
        } 
        else {
          newImageRows.pixels[i] = readImage.pixels[i];
        }
      }
    }
    
    newImageRows.save("screenShotSaved.tif");
    translate(transWidth,transHeight); 
    rotate(rotation);
    translate(-transWidth,-transHeight);
    image(newImageRows,xPos,yPos); 
  
    readImage = loadImage ("screenShotSaved.tif");
    newImageBottom = createImage(readImage.width, readImage.height, ARGB);
    for(int x = 0; x < readImage.width; x++){
      for(int  y = readImage.height/2; y < readImage.height; y++){
        int i = (x+(y * readImage.width));
        if(readImage.pixels[i] == color(0)){
          newImageBottom.pixels[i] = color(255,0);
        } 
        else {
          newImageBottom.pixels[i] = readImage.pixels[i];
        }
      }
    }
    
    newImageBottom.save("screenShotSaved.tif");
    translate(transWidth,transHeight); 
    rotate(rotation);
    translate(-transWidth,-transHeight);
    image(newImageBottom,xPos,yPos);
  }
}