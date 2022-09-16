class Ball {
  PVector loc;
  PVector vel;
  PVector acc;
  color col;
  float mass;

  
  
  Ball() {
  loc = new PVector(55,height/2 - 2);
  vel = new PVector(0,0);
  acc = new PVector(0,0);
  col = 0;//(color) random(#000000);
  mass = 10;

  }
  
  void display() {
    fill(col);
    ellipse(0,0,mass,mass);
  }
  
  void update() {
    vel.add(acc);
    loc.add(vel);
    acc.mult(0);
    
  }
    void addForce(PVector f) {
      acc.add(f);
    }
    
}
