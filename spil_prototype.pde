import java.util.Iterator;
import processing.sound.*; // kræver at librariet 'Sound' er installeret

PImage gun;
PImage heart;

ArrayList<Box> boxes = new ArrayList<Box>();
ArrayList<Ball> balls = new ArrayList<Ball>();
Box front;
int last;
float angle;
int life;
int lifeTime;
int wave;
int streak;
boolean menu;
String[] highscore;
SoundFile musik;
SoundFile pop;

void setup() {
  size(1000, 500);
  gun = loadImage("gun.jpg");
  heart = loadImage("hjerte.png");
  //bal = new Baloon();
  boxes.add(new Box());
  balls.add(new Ball());
  Iterator<Box> iter = boxes.iterator();
  while (iter.hasNext()) {
    Box bs = iter.next();
    bs.maker();
    bs.made = true;
  }
  life = 100;
  last = millis();
  angle = 0.0;
  lifeTime=millis();
  wave = millis();
 streak = 0;
 menu = true;
 highscore = loadStrings("highscore.txt");
 
 //musik og lydeffekt
 musik = new SoundFile(this,"war.mp3");
 musik.amp(0.7);
 musik.play();
 musik.loop();
 pop = new SoundFile(this,"pop.mp3");
 pop.amp(1.2);
}

void draw() {
  background(255);
  
  if (!menu){
  line(200, 0, 200, height);
  angle = atan2(mouseY-250, (mouseX-55));
  drawCannon();
  


  front = boxes.get(0);
  textSize(40);
  fill(0);
  front.front = true;
  text(front.question[0], 10, 470);
  Iterator<Box> iter = boxes.iterator();
  while (iter.hasNext()) {
 /* for (int i = boxes.size(); i < boxes.size();i--){*/
    Box bs = iter.next();
    bs.mover();
    if (!bs.made){
     bs.maker(); 
    }
  }
front.display();
 
//println(boxes.size());

Iterator<Ball> ballIter = balls.iterator();
while (ballIter.hasNext()){
  Ball b = ballIter.next();
  if (b.loc.x != 55) { //aka hvis der er blevet skudt
    pushMatrix();
    translate(b.loc.x, b.loc.y);
    //rotate(b.angle);
    b.addForce(new PVector(0, 0.05));
    b.update();
    b.display();
    //println(b.angle);
    //line(0,0,50,-50);
    popMatrix();
  }
  if (b.loc.x > width){
    ballIter.remove();
  }
  else if (front.hit(b.loc.x,b.loc.y)){
       pop.play();
    if (front.guessedCorrect == false){
     life -= 10; 
    }
    else {
     streak++; 
    }
    boxes.remove(0);
    
    if (boxes.size() == 0){
     boxes.add(new Box());
     
       wave = millis();
    }
    ballIter.remove();
    
    
   
    
  } 
 
  
  }
  imageMode(CENTER);
  textSize(30);
  image(heart, 25, 25, 25+3*sin(millis()*0.01), 25+3*sin(millis()*0.01));
  fill(0);
  text(life, 40, 35);
  imageMode(CORNER);
  text("streak: "+streak,10,70);

  if (life <= 0) { //død
    background(255);
    textSize(150);
    text("GAME OVER", 120, height/2+20);
    textSize(30);
    text("Score: "+streak,130,height/2+70);
    if (streak > int(highscore[0])){
      text("Tidligere bedste score: "+highscore[0],130,height/2+140);
      String[] high = new String[1];
      high[0] = str(streak);
      saveStrings("highscore.txt",high);
    }
    else{
      text("Bedste score: "+int(highscore[0]),130,height/2+140);
    }
    noLoop();
  }

  if (front.ohno() && millis()-lifeTime > 100) {
    life--;
    lifeTime = millis();
  }

  if (millis() - wave >= 4500){
    boxes.add(new Box());
    wave = millis();
  }
  

  }
   else if (menu) { //menu
    background(255);
    rectMode(CENTER);
    textAlign(CENTER);
    
    pushMatrix();
    translate(width/2,height/2);
    
    textSize(100); //title
    fill(150,20,20);
    text("Bloons TD7 (c)",0,-140);
    
    fill(200); //rectangels
    rect(-250,0,400,100);
    rect(-250,150,400,100);
    rect(250,0,400,100);
    rect(250,150,400,100);
    
    
    fill(200,70,70); //rød
    
    if (mouseX >= 50 && mouseX <= 450){ //rør musen en af knapperne?
      if (mouseY >= 200 && mouseY <= 300){
      rect(-250,0,400,100);
      }
      else if (mouseY >= 350 && mouseY <= 450){
        rect(-250,150,400,100);
      }
    }
    else if (mouseX >= 550 && mouseX <= 950){
      if (mouseY >= 200 && mouseY <= 300){
      rect(250,0,400,100);
      }
      else if (mouseY >= 350 && mouseY <= 450){
        rect(250,150,400,100);
      } 
    }
    textSize(50); //text
    fill(0);
    text("start",-250,10);
    println(mouseX,mouseY);
    
    textAlign(LEFT);
    popMatrix();
  }
}


void drawCannon() {

  pushMatrix();
  translate(55, height/2);
  rotate(angle);
  image(gun, 0, 0, -50, 50);
  popMatrix();
}

void mouseClicked() { // aka kode kluddermor

    if (menu){
      if (mouseX >= 50 && mouseX <= 450 && mouseY >= 200 && mouseY <= 300){ //startknappen
      menu = false;
      wave = millis();
      }
      
      
    }
    else {
    balls.add(new Ball());
    Ball b = balls.get(balls.size()-1);
    PVector direction = new PVector(mouseX-55, (mouseY-height/2));

    direction.mult(0.05);
    
    b.addForce(direction);



    b.loc.x = 56;
    }


}
