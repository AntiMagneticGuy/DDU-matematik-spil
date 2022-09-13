import java.util.Iterator;
class Baloon{
  PVector loc;
  float sinOff;
  String value; // answer
  float orgY; //original y-værdi

  
  Baloon(String number,int h){
    loc = new PVector(width,h);
    orgY = h;
    value = number;
    sinOff = (float) random(0,6.3);
  }
  
  void update(){
    if (loc.x > 225){
    loc.x -= 0.6;
    loc.y = orgY + 5*sin(millis()*0.005+sinOff); //float
    }
    
  }
  
  
  void display(){
    pushMatrix();
    translate(loc.x,loc.y);
    fill(255,0,0);
    ellipse(0,0,50,50);
    line(0,25,0,50);
    popMatrix();

  }
  
 void displayText(){
    pushMatrix();
    textAlign(CENTER);
    translate(loc.x,loc.y);
    fill(0);
    textSize(25);
    text(value,0,0);
    textAlign(LEFT);
    popMatrix();
 }
 
  
  
  
  
  
  
  
  
  
  
  
  
}
