import java.util.Iterator;
class Baloon{
  PVector loc;
  float sinOff;
  String value; // answer
  float orgY; //original y-værdi
  float modifier;
  SpriteSheet BallonSprite;
  PFont boldFont;


  
  Baloon(String number,int h){
    loc = new PVector(width + 30,h);
    orgY = h;
    value = number;
    sinOff = (float) random(0,6.3);
    boldFont = loadFont("Arial-BoldMT-48.vlw");
    
    BallonSprite = new SpriteSheet();
    BallonSprite.Sprite = loadImage("ballon_sheet.png");
    BallonSprite.Xframes = 9;
    BallonSprite.Yframes = 2;
    BallonSprite.MaxFrames = 8;
    BallonSprite.FPS = 12;
    BallonSprite.IsPlaying = true;
    BallonSprite.Looping = true;
    BallonSprite.AnimFrameCap = 8;
  }
  
  void update(){
    if (loc.x >= 225){
      
    modifier = streak*0.05;
    loc.x -= 0.6+modifier;
     if (loc.x < 225) {
      loc.x = 225;
     }
    loc.y = orgY + 5*sin(millis()*0.005+sinOff); //float
    }
 
  }
  
  
  void display(){
    pushMatrix();
    translate(loc.x - 27,loc.y - 68);
    //fill(255,0,0);
    //ellipse(0,0,50,50);
    BallonSprite.display();
    //line(0,25,0,50);
    popMatrix();

  }
  
 void displayText(){
    pushMatrix();
    textAlign(CENTER);
    translate(loc.x,loc.y);
    textFont(boldFont);
    textSize(25);
    
    fill(0);
    text(value, 1, 9);
     fill(142,208,164);
     textSize(25);
    text(value,-1,7);
    textAlign(LEFT);
    popMatrix();
 }
 
  
  
  
  
  
  
  
  
  
  
  
  
}
