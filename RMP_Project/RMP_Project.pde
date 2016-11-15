
import processing.video.*;
import ddf.minim.*;
import java.awt.*;
import javax.swing.JOptionPane;

Minim minim;
AudioInput audioInput;
PImage image;
PImage readImage;
PImage newImage;
boolean showImage = true;
boolean clapRegistered = false;
boolean movePic = false;
float rotation=0;
float yPos=0;
float transWidth=0;
float transHeight=0;

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
    rotation +=0.3;
    yPos +=20;
    transWidth = width/2;
    transHeight = height/2;
  }
  if(yPos >= height/2){
        yPos= -height/2;
  }
  
  //println(audioInput.left.level()*100);
  
  if(videoInput.available()){
    videoInput.read();
    //scale(-1,1);
    image(videoInput,0,0);
  }
  
  if(showImage == true){
    image(image,0,0);
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
    translate(transWidth,transHeight); 
    rotate(rotation);
    translate(-transWidth,-transHeight);
    image(newImage,0,yPos); 
  }
  if(((audioInput.left.level()*100) > 70) && clapRegistered == false){
    clapRegistered = true;
  }
}

void keyPressed(){
  if(keyCode == ENTER){
    save("data/screenShotSaved.tif");
    showImage = false;
  }
}
  