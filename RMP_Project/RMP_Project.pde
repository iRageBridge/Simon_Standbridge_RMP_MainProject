import processing.video.*;
import ddf.minim.*;
import java.awt.*;
import javax.swing.JOptionPane;

Minim minim;
AudioInput audioInput;

color trackColor;

int closestX = 0;
int closestY = 0;

PImage image;
PImage readImage;
PImage newImage;
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

XML xmlDialogue;

Capture videoInput;

void setup(){
  xmlDialogue = loadXML ("dialogue.xml");
  XML[]dialogues = xmlDialogue.getChildren("box");
  for(int i = 0; i < dialogues.length; i++){
    String dialogueIntro = dialogues[i].getString("text");
    JOptionPane.showMessageDialog(null,dialogueIntro);
  }
  
  frameRate(48);
  size(640,480);

  videoInput = new Capture(this,640,480);
  videoInput.start();
  
  minim = new Minim(this);
  audioInput = minim.getLineIn();
  
  background(127);
  
  image = loadImage("processing.png");
  
  trackColor = color(255,0,0);
}

void draw(){
  if(clapRegistered == true){
    imageScale = imageScale % 100;
    rotation +=0.3;
    transWidth = 0;
    transHeight = 0;
  }
  
  if(videoInput.available()){
    videoInput.read();
    videoInput.loadPixels();
    image(videoInput,0,0);
  }
  
  if(showImage == true){
    image(image,0,0);
  }
  
  else if(showImage != true){
    shatterImage();
  }
  
  if(((audioInput.left.level()*100) > 99) && clapRegistered == false){
    save("data/screenShotSaved.tif");
    showImage = false;
    clapRegistered = true;
  }
}

void mousePressed(){
  int loc = mouseX + mouseY*videoInput.width;
  trackColor = videoInput.pixels[loc];
}

void trackGreen(){
  float worldRecord = 10;
  
  for (int x = 0; x < videoInput.width; x ++ ) {
    for (int y = 0; y < videoInput.height; y ++ ) {
      int loc = x + y*videoInput.width;
      color currentColor = videoInput.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);
      float d = dist(r1, g1, b1, r2, g2, b2);
      if (d < worldRecord) {
        worldRecord = d;
        closestX = x;
        closestY = y;
      }
    }
  }


  if (worldRecord < 10) { 
    xPos = closestX-300;
    yPos = closestY-300;
    fill(trackColor);
    strokeWeight(4.0);
    stroke(0);
    ellipse(closestX, closestY, 16, 16);
  }
}
 
void shatterImage(){
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
  image(newImage,closestX-300,closestY-300);
  trackGreen();
}