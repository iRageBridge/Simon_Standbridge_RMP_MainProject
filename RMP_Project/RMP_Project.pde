import processing.video.*;

Capture videoInput;
void setup(){
  size(640,480);
  
  videoInput = new Capture(this,640,480);
  videoInput.start();
  
}

void draw(){
  
  if(videoInput.available()){
    videoInput.read();
    //scale(-1,1);
    image(videoInput,0,0);
  }
println("No video input detected");
  
  fill(0,0,0);
  ellipse(width/2,height/2,200,250);
}