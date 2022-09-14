class Knap {
  PVector loc;
  boolean valgt;
  color col;
  int sizeX;
  int sizeY;
  String txt;

  Knap(int x_, int y_,int sx, int sy,String t) {
    loc = new PVector(x_, y_);
    valgt = false;
    col = color(200,200,200);
    sizeX = sx;
    sizeY = sy;
    txt = t;
  }

  void display() {
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
  
  void updateColor(int col1,int col2, int col3){
    col = color(col1,col2,col3);
  }

void hover(){
  //println((width/2+loc.x),(height/2+loc.y));
  if (mouseX >= (width/2+loc.x)-sizeX/2 && mouseX <= (width/2+loc.x)+sizeX/2 && mouseY >= (height/2+loc.y)-sizeY/2 && mouseY <= (height/2+loc.y)+sizeY/2){
    updateColor(200,70,70);
}
else{
  updateColor(200,200,200);
}

}



}
