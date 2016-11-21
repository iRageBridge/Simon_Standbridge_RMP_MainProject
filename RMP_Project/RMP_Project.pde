import processing.video.*;
import ddf.minim.*;
import java.awt.*;
import javax.swing.JOptionPane;

Minim minim;
AudioInput audioInput;

color track;

int newX = 0;
int newY = 0;

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
  
  track = color(255,0,0);
}

void draw(){  
  print (audioInput.left.level()*100);
  if(videoInput.available()){
    videoInput.read();
    videoInput.loadPixels();
    image(videoInput,0,0);
  }
  
  if(showImage == true){
    image(image,0,0);
  }
  
  else if(showImage != true){
    takePicture();
  }
  
  if(((audioInput.left.level()*100) > 99) && clapRegistered == false){
    save("data/screenShotSaved.tif");
    showImage = false;
    clapRegistered = true;
  }
}

void mousePressed(){
  int loc = mouseX + mouseY*videoInput.width;
  track = videoInput.pixels[loc];
}

void trackGreen(){
  float colourGap = 10;
  
  for (int x = 0; x < videoInput.width; x ++ ) {
    for (int y = 0; y < videoInput.height; y ++ ) {
      int loc = x + y*videoInput.width;
      color current = videoInput.pixels[loc];
      float r1 = red(current);
      float g1 = green(current);
      float b1 = blue(current);
      float r2 = red(track);
      float g2 = green(track);
      float b2 = blue(track);
      float d = dist(r1, g1, b1, r2, g2, b2);
      if (d < colourGap) {
        colourGap = d;
        newX = x;
        newY = y;
      }
    }
  }

  if (colourGap < 10) { 
    xPos = newX-300;
    yPos = newY-300;
    fill(track);
    strokeWeight(4.0);
    stroke(0);
    ellipse(newX, newY, 16, 16);
  }
}
 
void takePicture(){
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
  image(newImage,newX-300,newY-300);
  trackGreen();
}