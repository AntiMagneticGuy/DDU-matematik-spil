class Knap {
  PVector loc;
  boolean valgt;
  color col;
  int sizeX;
  int sizeY;

  Knap(int x_, int y_,int sx, int sy) {
    loc = new PVector(x_, y_);
    valgt = false;
    col = color(200,200,200);
    sizeX = sx;
    sizeY = sy;
  }

  void display(String txt) {
    pushMatrix();
    fill(col);
    rectMode(CENTER);
    rect(loc.x,loc.y,sizeX,sizeY);
    textAlign(CENTER);
    fill(0);
    textSize(50);
    text(txt,loc.x,loc.y);
    
    textAlign(LEFT);
    popMatrix();
  }
  
  void updateColor(int col1,int col2, int col3){
    col = color(col1,col2,col3);
  }

void hover(){
  if (mouseX >= loc.x-sizeX/2 && mouseX <= loc.x+sizeX/2 && mouseY >= loc.y+sizeY/2 && mouseY <= loc.y+sizeY/2){
    updateColor(200,70,70);
}
else{
  updateColor(200,200,200);
}

}

}
