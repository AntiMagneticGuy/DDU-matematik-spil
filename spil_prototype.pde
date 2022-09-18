import java.util.Iterator;
import processing.sound.*; // kræver at librariet 'Sound' er installeret

SpriteSheet gun;
SpriteSheet heart;
PImage platform;

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
PImage fork;
ArrayList<Integer> regne = new ArrayList<Integer>();
String hov;
PImage mur;
PImage baggrund;

void setup() {
  size(1000, 500);

  noSmooth();
  platform = loadImage("platform.png");
  
  //Gun Ting
  gun = new SpriteSheet();
  gun.Sprite = loadImage("gun.png");
  gun.Yframes = 1;
  gun.Xframes = 5;
  gun.MaxFrames = 5;
  gun.FPS = 12;
  gun.IsPlaying = false;
  gun.Looping = false;
  gun.centered = true;
  gun.AnimFrameCap = 5;
  
  //Hjerte ting
  heart = new SpriteSheet();
  heart.Sprite = loadImage("heart_sheet.png");
  heart.Yframes = 3;
  heart.Xframes = 6;
  heart.MaxFrames = 18;
  heart.FPS = 12;
  heart.IsPlaying = false;
  heart.LoopPause = 1.0;
  heart.Looping = true;
  heart.Location = new PVector(25,25);
  heart.playAnimation(12,17);
  
//boks aka 3x ballon + spørgsmål
  boxes.add(new Box());
  balls.add(new Ball());
  
  
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
  musik.play();
  musik.loop();
  pop = new SoundFile(this, "pop.mp3");


  initMenu(); // laver startmenuen
  mur = loadImage("mur.png");
  baggrund = loadImage("baggrund.png");

  back = new Knap(70, 30, 100, 25, "tilbage"); // tilbageknap
}

void draw() {
  background(255);

  if (menu == 5) { // når spillet er startet
    imageMode(CORNERS);
    tint(255, 110);
    image(baggrund,0,0,width,height);
    imageMode(CORNER);
    tint(255,255);
    angle = atan2(mouseY-250, (mouseX-55));
    drawCannon();
    image(platform,70,height/2 - 36);
    imageMode(CORNERS);
    image(mur, 160, 0, 205, height);


    front = boxes.get(0); // den foreste
    textSize(40);
    fill(0);
    front.front = true;
    text(front.question[0], 10, 470);
    Iterator<Box> iter = boxes.iterator();
    while (iter.hasNext()) { // rykker alle balloner
      
      Box bs = iter.next();
      bs.mover();
      if (!bs.made) {
        bs.maker(regne);
      }
      
    }
    front.display();

  

    Iterator<Ball> ballIter = balls.iterator(); // rykker alle skud
    while (ballIter.hasNext()) {
      Ball b = ballIter.next();
      if (b.loc.x != 55) { //aka hvis der er blevet skudt
        pushMatrix();
        translate(b.loc.x, b.loc.y);
     
        b.addForce(new PVector(0, 0.05));
        b.update();
        b.display();
       
        popMatrix();
      }
      if (b.loc.x > width) { // fjern hvis uden for skærm
        ballIter.remove();
      } else if (front.hit(b.loc.x, b.loc.y)) { // hvis den rammer de forreste balloner
        pop.play();
        if (front.guessedCorrect == false) {
          life -= 10;
        } else {
          streak++;
        }
        boxes.remove(0);

        if (boxes.size() == 0) {
          boxes.add(new Box());
          
          
          Box bs = boxes.get(0);
      if (!bs.made) {
        bs.maker(regne);
      }
          
          wave = millis(); // nulstiller den nye "wave" af balloner
        }
        ballIter.remove(); // fjerner skudet
      }
    }
   
    
    
   
  
  imageMode(CENTER);
  textSize(30);
  heart.display();
  
  fill(0);
  text(life, 40, 35);
  imageMode(CORNER);
  text("Score: "+streak,10,70);


    if (life <= 0) { //død
      background(255);
      textSize(100);
      text("Spil slut", 120, height/2+20);
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

    if (front.ohno() && millis()-lifeTime > 100) { // taber liv når balloner rør mur
      life--;
      lifeTime = millis();
    }

    if (millis() - wave >= 4500-streak*40) { // laver nye balloner. Gøres hurtigere jo flere balloner du har skudt.
      boxes.add(new Box());
      wave = millis();
    }
    
  
  } 
  else if (menu == 0) { // Main menu
    background(255);
    rectMode(CENTER);
    textAlign(CENTER);

    pushMatrix();
    translate(width/2, height/2);

    textSize(100); //title
    fill(150, 20, 20);
    text("Mat Besat", 0, -140);


    for (Knap kn : knapper) {
      kn.hover();
      kn.display();
    }
    textAlign(LEFT);
    popMatrix();
  }

  else if (menu == 1) { // eksempel menu
    pushMatrix();
    translate(width/2, height/2);
    
     textAlign(CENTER);
     textSize(60); //title
    fill(150, 20, 20);
    text("Vælg en regneart", 0, -140);
    
    if (knapper.size() >0){
    for (Knap kn : knapper) {
      kn.hover();
      kn.display();
    }
    }
    else
    {
      imageMode(CENTER);
      image(fork,0,0,800,height);
      
    }
    
    
    popMatrix();
  }
  
  else if (menu == 2) { // slå matematik spørgsmålene til eller fra
    pushMatrix();
    translate(width/2, height/2);
    textAlign(CENTER);
     textSize(60); //title
    fill(150, 20, 20);
    text("Slå til eller fra", 0, -140);
    
    if (knapper.size() >0){
    for (Knap kn : knapper) {
      kn.hover();
      kn.display();
    }
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
  translate(70, height/2);
  rotate(angle);
  gun.display();
  
  popMatrix();
}

void mouseClicked() {

  if (menu == 5) { // Inde i spillet, så når man skyder
    balls.add(new Ball());
    Ball b = balls.get(balls.size()-1);
    PVector direction = new PVector(mouseX-55, (mouseY-height/2));
    gun.playAnimation(0,4);
    direction.mult(0.05);

    b.addForce(direction);



    b.loc.x = 56;
  }
  
  if (menu != 5) { // altså, hvis spillet ikke er i gang
    hov = "";
    for (Knap kn : knapper) { //tjekker hvilken knap musen er over
      if (kn.hovering)
      {
        hov = kn.txt;
      }
    }
    if (back.hovering && menu != 0)
      {
        hov = back.txt;
      }
      
    if (menu == 0) //////////////////////////////////////////////////////////////////////////////////////// Main menu
   {
     back.hover();
     back.hovering = false;
    if (hov.equals("Start")) { //startknappen
      menu = 5;
      wave = millis();
      Iterator<Box> iter = boxes.iterator();
      while (iter.hasNext()) {
    Box bs = iter.next();
    bs.maker(regne);
    bs.made = true;
  }
      
    }
    else if (hov.equals("Vis eksempler"))
    {
      menu = 1;
      sletknapper();
      initMenu();
      
    }
    else if (hov.equals("Vælg spørgsmål"))
    {
      menu = 2;
      sletknapper();
      initMenu();
      //println(knapper.size());
    }
    else if (hov.equals("afslut"))
    {
      exit();
    }
   }
   if (menu == 1) /////////////////////////////////////////////////////////////////////////////////////// eksempler
   {
    
    
      
     if (hov.equals("tilbage"))
    {
      menu = 0;
      sletknapper();
      initMenu();
      
      //sletknapper();
   }
   else if (hov.equals("Plus (+)"))
    {
      fork = loadImage("plus.PNG");
      sletknapper();
   }
   else if (hov.equals("Minus (-)"))
    {
      fork = loadImage("minus.PNG");
      sletknapper();
   }
   else if (hov.equals("Gange (×)"))
    {
      fork = loadImage("gange.PNG");
      sletknapper();
   }
   else if (hov.equals("Dividere (÷)"))
    {
      fork = loadImage("div.PNG");
      sletknapper();
   }
   
   
  } //

if (menu == 2) /////////////////////////////////////////////////////////////////////////////////////// Slå til eller fra
   {
  
     if (hov.equals("tilbage"))
    {
      menu = 0;
      sletknapper();
      initMenu();
      
      
   }
   else if (hov.equals("Plus (+)"))
    {
      Knap tmp = knapper.get(0);
      tmp.on = !tmp.on;
      if (tmp.on)
      {
        regne.add(1);
      }
      else
      {
        for (int i = regne.size()-1; i > -1; i--)
        {
          if (regne.get(i) == 1)
          {
            regne.remove(i);
          }
        }
        
      }
   }
   else if (hov.equals("Minus (-)"))
    {
      Knap tmp = knapper.get(1);
      tmp.on = !tmp.on;
      if (tmp.on)
      {
        regne.add(2);
      }
      else
      {
        for (int i = regne.size()-1; i > -1; i--)
        {
          if (regne.get(i) == 2)
          {
            regne.remove(i);
          }
        }
        
      }
   }
   
   else if (hov.equals("Gange (×)"))
    {
      Knap tmp = knapper.get(2);
      tmp.on = !tmp.on;
      if (tmp.on)
      {
        regne.add(3);
      }
      else
      {
        for (int i = regne.size()-1; i > -1; i--)
        {
          if (regne.get(i) == 3)
          {
            regne.remove(i);
          }
        }
        
      }
   }
   
   else if (hov.equals("Dividere (÷)"))
    {
      Knap tmp = knapper.get(3);
      tmp.on = !tmp.on;
      if (tmp.on)
      {
        regne.add(4);
      }
      else
      {
        for (int i = regne.size()-1; i > -1; i--)
        {
          if (regne.get(i) == 4)
          {
            regne.remove(i);
          }
        }
        
      }
   }
 
  } 

  } ///


  
}

void initMenu(){ // kaver knapper
  if (menu == 0)
  {
  knapper.add(new Knap(-250, 0, 400, 100, "Start"));
  knapper.add(new Knap(-250, 150, 400, 100, "Vælg spørgsmål"));
  knapper.add(new Knap(250, 0, 400, 100, "Vis eksempler"));
  knapper.add(new Knap(250, 150, 400, 100, "afslut"));
  }
  else if (menu == 2)
  {
    
  knapper.add(new Knap(-250, 0, 400, 100, "Plus (+)"));
  knapper.add(new Knap(-250, 150, 400, 100, "Minus (-)"));
  knapper.add(new Knap(250, 0, 400, 100, "Gange (×)"));
  knapper.add(new Knap(250, 150, 400, 100, "Dividere (÷)"));
  for (Integer is : regne)
  {
    Knap tmp = knapper.get(is-1);
    tmp.on = true;
    tmp.hover();
  }
  }
  else if (menu == 1)
  {
    
  knapper.add(new Knap(-250, 0, 400, 100, "Plus (+)"));
  knapper.add(new Knap(-250, 150, 400, 100, "Minus (-)"));
  knapper.add(new Knap(250, 0, 400, 100, "Gange (×)"));
  knapper.add(new Knap(250, 150, 400, 100, "Dividere (÷)"));
  }
}



void sletknapper(){ //sletter knapper
 for (int i = knapper.size(); knapper.size() > 0; i--){
 knapper.remove(i-1);
 }
 
 }
 
