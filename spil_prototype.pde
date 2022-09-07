import java.util.Iterator;

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
  //qs = new Box();
  //qs.maker();
  //b = new Ball();
  last = millis();
  angle = 0.0;
  lifeTime=millis();
  wave = millis();
 streak = 0;
}

void draw() {
  background(255);
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
  if (front.hit(b.loc.x,b.loc.y)){
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

  if (life <= 0) {
    background(255);
    textSize(150);
    text("GAME OVER", 120, height/2+20);
    textSize(30);
    text("streak: "+streak,130,height/2+70);
    noLoop();
  }

  if (front.ohno() && millis()-lifeTime > 100) {
    life--;
    lifeTime = millis();
  }

  if (millis() - wave >= 3000){
    boxes.add(new Box());
    wave = millis();
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
  //if (millis() - last > 50) {
    balls.add(new Ball());
    Ball b = balls.get(balls.size()-1);
    PVector direction = new PVector(mouseX-55, (mouseY-height/2));

    direction.mult(0.05);
    
    b.addForce(direction);



    b.loc.x = 56;
    //last = millis();
  //}
}
