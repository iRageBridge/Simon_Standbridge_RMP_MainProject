//Importing Libraries
import processing.video.*;
import ddf.minim.*;
import java.awt.*;
import javax.swing.JOptionPane;

//Declaring Variables
color track;

PImage image;
PImage readImage;
PImage newImage;

boolean showImage;
boolean clapRegistered;

float yPos;
float xPos;
int newX;
int newY;
double randX;
double randY;

XML xmlDialogue;

AudioInput audioInput;
Minim minim;
Capture videoInput;

void setup(){
  
  //Assigning values
  newX = 0;
  newY = 0;
  
  
  showImage = true;
  clapRegistered = false;
  
  yPos=0;
  xPos=0;
  
  XML xmlDialogue;
  //Loading text fom XML file and displaying in dialog box
  xmlDialogue = loadXML ("dialogue.xml");
  XML[]dialogues = xmlDialogue.getChildren("box");
  JOptionPane.showMessageDialog(null,dialogues[0].getString("text") + "\n" + dialogues[1].getString("text") + "\n" + dialogues[2].getString("text"));
  
  frameRate(48);
  size(640,480);

  videoInput = new Capture(this,640,480);
  videoInput.start();
  //Reading sound input
  
  minim = new Minim(this);
  audioInput = minim.getLineIn();
  
  background(127);
  //Loading background image (black image with oval hole)
  
  image = loadImage("processing.png");
  
  
  
}

void draw(){ 
  
  //Reading video input, and flipping it on the x axis to avoid reversed video
  
  if(videoInput.available()){
    videoInput.read();
    videoInput.loadPixels();
    pushMatrix();
    scale(-1,1);
    image(videoInput,-width,0);
    popMatrix();
  }
  
  if(showImage == true){
    image(image,0,0);
  }
  
  else if(showImage != true){
    takePicture();
    fill(200,0,0);
    rect(0,0,240,100,10);
    textSize(60);
    fill(255);
    text("EXIT",60,70,10);
    
  }
  
  //Checking to see if audio level is over 99, clapRegistered it set to true after first clap to avoid double claps
  if(((audioInput.right.level()*100) > 99) && clapRegistered == false){
    save("data/screenShotSaved.tif");
    showImage = false;
    clapRegistered = true;
  }
}

//Changes position of the image(-300 because it was set to the top left) and setting the colour we are tracking to the colour of the pixel we last clicked on
//Also exits sketch when red exit box is clicked
void mousePressed(){
  newX = newX-300;
  newY = newY-300;
  int loc = mouseX + mouseY*videoInput.width;
  track = videoInput.pixels[loc];
  if(mouseX > 0 && mouseX < 240 && mouseY > 10 && mouseY < 100)
  {
    exit();
  }
}

void trackGreen(){
  //Colour gap is the range outside selected colour we are allowed to track
  float colourGap = 10;
  
  //Checks every single pixel seqentually, gets the r,g and b values of them, seeing if they are within the acceptable range of the selected colour, and if they are setting the x and y of the image to the location of that pixel
  for (int x = 0; x < videoInput.width; x ++) {
    for (int y = 0; y < videoInput.height; y ++) {
      int loc = (videoInput.width-x-1+(y*readImage.width));
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
        newX = x-width/2;
        newY = y-height/2;
      }
    }
  }
  
  if (colourGap < 10) { 
    xPos = newX-width/2;
    yPos = newY-height/2;
  }
}
 
//Checking every pixel in the image, checking to see if it us pure black, setting it to transparent if it is
//then taking the remaining pixels of the image (the oval in the centre), saving it as an image in data, and
//reading it back in over the video.
void takePicture(){
  readImage = loadImage ("screenShotSaved.tif");
  newImage = createImage(readImage.width, readImage.height, ARGB);
  for(int x = 0; x < readImage.width; x++){
    for(int  y = 0; y < readImage.height; y++){
      int i = (videoInput.width-x-1+(y*readImage.width));
      if(readImage.pixels[i] == color(0)){
        newImage.pixels[i] = color(255,0);
      } 
      else {
        newImage.pixels[i] = readImage.pixels[i];
      }
    }
  }
  //Reads the screenshot from data and places it in the middle of the screen
  
  newImage.save("screenShotSaved.tif");
  image(newImage,newX,newY);
  trackGreen();
}