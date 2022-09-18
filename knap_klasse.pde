class Knap {
  PVector loc;
  boolean valgt;
  color col;
  int sizeX;
  int sizeY;
  String txt;
  boolean on;
  boolean hovering;

  Knap(int x_, int y_,int sx, int sy,String t) {
    loc = new PVector(x_, y_);
    valgt = false;
    col = color(200,200,200);
    sizeX = sx;
    sizeY = sy;
    txt = t;
    on = false;
    hovering = false;
  }

  void display() { // viser knappen
    pushMatrix();
    fill(col);
    rectMode(CENTER);
    rect(loc.x,loc.y,sizeX,sizeY);
    textAlign(CENTER);
    fill(0);
    textSize(50);
    text(txt,loc.x,loc.y+7);
    
    textAlign(LEFT);
    popMatrix();
  }
  
  void display(int b) { // kun tilegnet tilbage-knappen. Viser teksten på knappen i en bestemt størreste.
    pushMatrix();
    fill(col);
    rectMode(CENTER);
    rect(loc.x,loc.y,sizeX,sizeY);
    textAlign(CENTER);
    fill(0);
    textSize(b);
    text(txt,loc.x,loc.y+7);
    
    textAlign(LEFT);
    popMatrix();
  }
  
  void updateColor(int col1,int col2, int col3){
    col = color(col1,col2,col3);
  }

void hover(){ // hvad der foregår når musen er over knappen.
  
  if (txt.equals("tilbage") && mouseX >= 20 && mouseX <= 120 && mouseY >= 5 && mouseY <= 45)
  {
    updateColor(200,70,70); // rød
    hovering = true;
    
  }
  else if (txt != "tilbage" && mouseX >= (width/2+loc.x)-sizeX/2 && mouseX <= (width/2+loc.x)+sizeX/2 && mouseY >= (height/2+loc.y)-sizeY/2 && mouseY <= (height/2+loc.y)+sizeY/2){
    updateColor(200,70,70); //rød
    hovering = true;
}
else{
  hovering = false;
  updateColor(200,200,200); // grå
  
}
if (on == true )
  {
    updateColor(70,200,70); // gør den grøn
    
}

}



}
