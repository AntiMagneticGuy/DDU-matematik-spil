import java.util.Iterator;
import processing.sound.*; // kræver at librariet 'Sound' er installeret
import de.bezier.data.sql.*;
SQLite db;

SpriteSheet gun;
SpriteSheet heart;
PImage platform;

ArrayList<Box> boxes = new ArrayList<Box>();
ArrayList<Ball> balls = new ArrayList<Ball>();
ArrayList<Knap> knapper = new ArrayList<Knap>();
String tmptext;
Box front;
int last;
float angle;
int life;
int lifeTime;
int wave;
int streak;
int menu;
//String[] highscore;
SoundFile musik;
SoundFile pop;
Knap back;
Knap login;
PImage fork;
ArrayList<Integer> regne = new ArrayList<Integer>();
String hov;
PImage mur;
PImage baggrund;
String high_navn;
int highscore;
String pname;
boolean search;
boolean nameExists;

void setup() {
  size(1000, 500);
  pname= "Gæst";
  nameExists = false;
  
  tmptext = "";
  search = false;

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
  heart.Location = new PVector(25, 25);
  heart.playAnimation(12, 17);

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
  //highscore = loadStrings("highscore.txt");

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
  login = new Knap(width-70, 30, 100, 25, "login"); // tilbageknap

  db = new SQLite( this, "Highscores.sqlite" );
  if ( !db.connect() )
  {
    println("Guh!");
  } else
  {
    db.query("SELECT user, highscore FROM personer ORDER BY highscore DESC LIMIT 0,1;");
    high_navn = db.getString("user");
    highscore = db.getInt("highscore");
    
  }
}

void draw() {
  background(255);

  if (menu == 5) { // når spillet er startet
    imageMode(CORNERS);
    tint(255, 110);
    image(baggrund, 0, 0, width, height);
    imageMode(CORNER);
    tint(255, 255);
    angle = atan2(mouseY-250, (mouseX-55));
    drawCannon();
    image(platform, 70, height/2 - 36);
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
    text("Score: "+streak, 10, 70);


    if (life <= 0) { //død
      background(255);
      textSize(100);
      text("Spil slut", 120, height/2+20);
      textSize(30);
      text("Score: "+streak, 130, height/2+70);
      if (streak > highscore) {
        text("Tidligere bedste score: "+str(highscore)+" af "+high_navn, 130, height/2+140);
        
      } else {
        text("Bedste score: "+str(highscore)+" af "+high_navn, 130, height/2+140);
      }
        if (pname !="Gæst" && streak >0 && !nameExists)
        {
        db.execute("INSERT INTO personer (user, highscore) VALUES ('"+pname+"',"+streak+");");
        } else if (pname !="Gæst" && streak >0 && nameExists)
        {
          db.execute("UPDATE personer set highscore = "+streak+" where user = '"+pname+"' AND (SELECT highscore FROM personer where user = '"+pname+"') < "+streak+";");
          println("updated");
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
  } else if (menu == 0) { // Main menu
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

    login.hover();
    login.display(20);
    
  } else if (menu == 1) { // eksempel menu
    pushMatrix();
    translate(width/2, height/2);

    textAlign(CENTER);
    textSize(60); //title
    fill(150, 20, 20);
    text("Vælg en regneart", 0, -140);

    if (knapper.size() >0) {
      for (Knap kn : knapper) {
        kn.hover();
        kn.display();
      }
    } else
    {
      imageMode(CENTER);
      image(fork, 0, 0, 800, height);
    }


    popMatrix();
  } else if (menu == 2) { // slå matematik spørgsmålene til eller fra
    pushMatrix();
    translate(width/2, height/2);
    textAlign(CENTER);
    textSize(60); //title
    fill(150, 20, 20);
    text("Slå til eller fra", 0, -140);

    if (knapper.size() >0) {
      for (Knap kn : knapper) {
        kn.hover();
        kn.display();
      }
    }

    popMatrix();
  } else if (menu == 3) { // slå matematik spørgsmålene til eller fra
    pushMatrix();
    //translate(width/2, height/2);
    textAlign(CENTER);
    textSize(60); //title
    fill(150, 20, 20);
    text("Highscores", width/2, 140);
    textSize(25);
    fill(0);

    db.query("SELECT user, highscore FROM personer ORDER BY highscore DESC LIMIT 0,5;");
    int iy = 200;
    while (db.next())
    {
      text("Navn: " + db.getString("user")+" \t, Score: " + db.getInt("highscore"), width/2, iy);
      iy+=40;
    }

    popMatrix();
  } else if (menu == 4) { // slå matematik spørgsmålene til eller fra
    pushMatrix();
    //translate(width/2, height/2);
    textAlign(CENTER);
    textSize(60); //title
    fill(150, 20, 20);
    text("Dit Navn:" + pname, width/2, 140);
    textSize(30);
    text("Tryk enter når du har skrevet det", width/2, 180);
    textSize(25);
    
    fill(0);
    Knap tmp = knapper.get(0);
    tmp.hover();
    
    if (tmptext.length() > 12)
    {
      tmp.display(50-(tmptext.length()-12)*2);
    }
    else
    {
      tmp.display();
    }
    
    tmp.txt = tmptext;
    if (tmptext.equals(""))
    {
      textAlign(CENTER);
    text("Skriv navn",width/2, height/2+125);
    
    
    }
    db.query("select exists(select 1 from personer where user = '"+tmptext+"');");
    
    if (db.getInt("exists(select 1 from personer where user = '"+tmptext+"')") == 1)
    {
      textSize(20);
      textAlign(CENTER);
      text("Navn eksisterer i database. Eksisterende highscore vil blive opdateret.", width/2, 210);
    }
    textAlign(LEFT);
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
    gun.playAnimation(0, 4);
    direction.mult(0.05);

    b.addForce(direction);



    b.loc.x = 56;
  }

  if (menu != 5) { // altså, hvis spillet ikke er i gang
    hov = "";
    login.hover();
    for (Knap kn : knapper) { //tjekker hvilken knap musen er over
      if (kn.hovering)
      {
        hov = kn.txt;
      }
    }
    if (back.hovering && menu != 0)
    {
      hov = back.txt;
    } else if (login.hovering && menu == 0)
    {
      hov = login.txt;
      
    }
    println(hov);
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
      } else if (hov.equals("Vis eksempler"))
      {
        menu = 1;
        sletknapper();
        initMenu();
      } else if (hov.equals("Vælg spørgsmål"))
      {
        menu = 2;
        sletknapper();
        initMenu();
        //println(knapper.size());
      } else if (hov.equals("Se highscores"))
      {
        menu = 3;
        sletknapper();
        initMenu();
      } else if (hov.equals("login"))
      {
        menu = 4;
        sletknapper();
        initMenu();
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
      } else if (hov.equals("Plus (+)"))
      {
        fork = loadImage("plus.PNG");
        sletknapper();
      } else if (hov.equals("Minus (-)"))
      {
        fork = loadImage("minus.PNG");
        sletknapper();
      } else if (hov.equals("Gange (×)"))
      {
        fork = loadImage("gange.PNG");
        sletknapper();
      } else if (hov.equals("Dividere (÷)"))
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
      } else if (hov.equals("Plus (+)"))
      {
        Knap tmp = knapper.get(0);
        tmp.on = !tmp.on;
        if (tmp.on)
        {
          regne.add(1);
        } else
        {
          for (int i = regne.size()-1; i > -1; i--)
          {
            if (regne.get(i) == 1)
            {
              regne.remove(i);
            }
          }
        }
      } else if (hov.equals("Minus (-)"))
      {
        Knap tmp = knapper.get(1);
        tmp.on = !tmp.on;
        if (tmp.on)
        {
          regne.add(2);
        } else
        {
          for (int i = regne.size()-1; i > -1; i--)
          {
            if (regne.get(i) == 2)
            {
              regne.remove(i);
            }
          }
        }
      } else if (hov.equals("Gange (×)"))
      {
        Knap tmp = knapper.get(2);
        tmp.on = !tmp.on;
        if (tmp.on)
        {
          regne.add(3);
        } else
        {
          for (int i = regne.size()-1; i > -1; i--)
          {
            if (regne.get(i) == 3)
            {
              regne.remove(i);
            }
          }
        }
      } else if (hov.equals("Dividere (÷)"))
      {
        Knap tmp = knapper.get(3);
        tmp.on = !tmp.on;
        if (tmp.on)
        {
          regne.add(4);
        } else
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
    } else if (menu == 3)
    {
      if (hov.equals("tilbage"))
      {
        menu = 0;
        sletknapper();
        initMenu();
      }
    } else if (menu == 4)
    {
      if (hov.equals("tilbage"))
      {
        menu = 0;
        sletknapper();
        initMenu();
      }
    }
  } ///
}

void initMenu() { // laver knapper
  if (menu == 0)
  {
    knapper.add(new Knap(-250, 0, 400, 100, "Start"));
    knapper.add(new Knap(-250, 150, 400, 100, "Vælg spørgsmål"));
    knapper.add(new Knap(250, 0, 400, 100, "Vis eksempler"));
    knapper.add(new Knap(250, 150, 400, 100, "Se highscores"));
  } else if (menu == 2)
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
  } else if (menu == 1)
  {

    knapper.add(new Knap(-250, 0, 400, 100, "Plus (+)"));
    knapper.add(new Knap(-250, 150, 400, 100, "Minus (-)"));
    knapper.add(new Knap(250, 0, 400, 100, "Gange (×)"));
    knapper.add(new Knap(250, 150, 400, 100, "Dividere (÷)"));
  } else if (menu == 3) //highscore
  {
    String searchTerm = "";
  } else if (menu == 4) //login
  {
    knapper.add(new Knap(width/2, height/2+120, 400, 100, ""));
  }
}


void sletknapper() { //sletter knapper
  for (int i = knapper.size(); knapper.size() > 0; i--) {
    knapper.remove(i-1);
  }
}

void keyReleased() {
  if (!search)
  {
  if ((key >= 'A' && key <= 'Z') || (key >= 'a' && key <= 'z') || str(key).equals(" "))
  {
    if (tmptext.length() < 25)
    {
    tmptext += str(key);
    }
    
  } else if (key == BACKSPACE)
  {
    if ( tmptext.length() >0)
    {
    tmptext = tmptext.substring(0, tmptext.length()-1);
    }
  } else if (key == ENTER)
  {
    if (tmptext != "")
    {
    pname = tmptext;
    
    db.query("select exists(select 1 from personer where user = '"+pname+"');");
    if (db.getInt("exists(select 1 from personer where user = '"+pname+"')") == 1)
    {
      nameExists = true;
    }
    else
    {
     nameExists = false; 
    }
    
    }
    else
    {
      pname = "Gæst";
    }
  }
}
  else
  {
    
  }
  
  
}
