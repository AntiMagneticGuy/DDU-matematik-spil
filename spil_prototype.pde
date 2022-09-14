import java.util.Iterator;
import processing.sound.*; // kræver at librariet 'Sound' er installeret

PImage gun;
PImage heart;

ArrayList<Box> boxes = new ArrayList<Box>();
ArrayList<Ball> balls = new ArrayList<Ball>();
ArrayList<Knap> knapper = new ArrayList<Knap>();
Box front;
int last;
float angle;
int life;
int lifeTime;
int wave;
int streak;
int menu;
String[] highscore;
SoundFile musik;
SoundFile pop;
Knap back;
String[] bill;
PImage fork;

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
  menu = 0;
  highscore = loadStrings("highscore.txt");

  //musik og lydeffekt
  musik = new SoundFile(this, "war.mp3");
  musik.amp(0.5);
  //musik.play();
  //musik.loop();
  pop = new SoundFile(this, "pop.mp3");


  initMenu();

  bill = new String[4];
  bill[0] = "plus.png";
bill[0] = "minus.png";
bill[0] = "gange.png";
bill[0] = "div.png";
//fork = loadImage(

  back = new Knap(70, 30, 100, 25, "tilbage");
}

void draw() {
  background(255);

  if (menu == 5) {
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
      if (!bs.made) {
        bs.maker();
      }
    }
    front.display();

    //println(boxes.size());

    Iterator<Ball> ballIter = balls.iterator();
    while (ballIter.hasNext()) {
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
      if (b.loc.x > width) {
        ballIter.remove();
      } else if (front.hit(b.loc.x, b.loc.y)) {
        pop.play();
        if (front.guessedCorrect == false) {
          life -= 10;
        } else {
          streak++;
        }
        boxes.remove(0);

        if (boxes.size() == 0) {
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
    text("streak: "+streak, 10, 70);

    if (life <= 0) { //død
      background(255);
      textSize(150);
      text("GAME OVER", 120, height/2+20);
      textSize(30);
      text("Score: "+streak, 130, height/2+70);
      if (streak > int(highscore[0])) {
        text("Tidligere bedste score: "+highscore[0], 130, height/2+140);
        String[] high = new String[1];
        high[0] = str(streak);
        saveStrings("highscore.txt", high);
      } else {
        text("Bedste score: "+int(highscore[0]), 130, height/2+140);
      }
      noLoop();
    }

    if (front.ohno() && millis()-lifeTime > 100) {
      life--;
      lifeTime = millis();
    }

    if (millis() - wave >= 4500) {
      boxes.add(new Box());
      wave = millis();
    }
  } else if (menu == 0) { //menu
    background(255);
    rectMode(CENTER);
    textAlign(CENTER);

    pushMatrix();
    translate(width/2, height/2);

    textSize(100); //title
    fill(150, 20, 20);
    text("Bloons TD7 (c)", 0, -140);


    for (Knap kn : knapper) {
      kn.hover();
      kn.display();
    }
    textAlign(LEFT);
    popMatrix();
  }

  if (menu == 1) {
    pushMatrix();
    translate(width/2, height/2);
    
    
    if (knapper.size() >0){
    for (Knap kn : knapper) {
      kn.hover();
      kn.display();
    }
    }
    else
    {
      image(fork,100,100);
      
    }
    
    
    popMatrix();
  }

  if (menu != 0 && menu != 5) { // backbutton
    
    back.hover();
    back.display(20);
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

  if (menu != 5) {

    String hov;
    hov = "";
    for (Knap kn : knapper) {
      if (kn.hovering)
      {
        hov = kn.txt;
      }
    }
    if (menu == 0)
   {
    if (hov.equals("Start")) { //startknappen //mouseX >= 50 && mouseX <= 450 && mouseY >= 200 && mouseY <= 300
      menu = 5;
      wave = millis();
    }
    else if (hov.equals("tilbage"))
    {
      menu = 0;
      sletknapper();
      initMenu();
    }
    else if (hov.equals("Vis eksempler"))
    {
      menu = 1;
      sletknapper();
      initMenu();
      println(knapper.size());
    }
   }
   if (menu == 1) ///////////////////////////////////////////////////////////////////////////////////////
   {
  
     if (hov.equals("tilbage"))
    {
      menu = 0;
      initMenu();
      sletknapper();
   }
   else if (hov.equals("Plus (+)"))
    {
      fork = loadImage(bill[0]);
      sletknapper();
   }
   
   
  }

  } //hvis menu != 5


  if (menu == 5) { // skyde
    balls.add(new Ball());
    Ball b = balls.get(balls.size()-1);
    PVector direction = new PVector(mouseX-55, (mouseY-height/2));

    direction.mult(0.05);

    b.addForce(direction);



    b.loc.x = 56;
  }
}

void initMenu(){
  if (menu == 0)
  {
  knapper.add(new Knap(-250, 0, 400, 100, "Start"));
  knapper.add(new Knap(-250, 150, 400, 100, "Vælg spørgsmål"));
  knapper.add(new Knap(250, 0, 400, 100, "Vis eksempler"));
  knapper.add(new Knap(250, 150, 400, 100, "Placeholder"));
  }
  else if (menu == 1)
  {
    
  knapper.add(new Knap(-250, 0, 400, 100, "Plus (+)"));
  knapper.add(new Knap(-250, 150, 400, 100, "Minus (-)"));
  knapper.add(new Knap(250, 0, 400, 100, "Gange (×)"));
  knapper.add(new Knap(250, 150, 400, 100, "dividere (%)"));
  
  }
}



void sletknapper(){
 for (int i = knapper.size(); knapper.size() > 0; i--){
 knapper.remove(i-1);
 }
 
 }
 
