import java.util.Iterator;
class Box {
  String[] question;
  ArrayList<Baloon> baloons = new ArrayList<Baloon>();
  QA quest = new QA();
  boolean front;
  boolean made;
  boolean guessedCorrect;
  
  Box() {
    made = false; // den har ikke lavet ballonerne
  }

  void maker(ArrayList<Integer> valgte) {
    question = quest.newQuestion(valgte); // generer et spørgsmål
    boolean diff = false;
    int[] hs = new int[3]; // vælger 3 tilfældige højder til ballonerne
    hs[0] = (int) random(25, height-25);
    hs[1] = (int) random(25, height-25);
    hs[2] = (int) random(25, height-25);
    
    while (!diff) { // sørger for at ballonerne ikke spawner inden i hinanden.
      diff = true;
      if (abs(hs[0] - hs[1]) < 70 || abs(hs[0] - hs[2]) < 70 ) { //check 1
        hs[0] = (int) random(25, height-25);
        diff = false;
      }
      if (abs(hs[0] - hs[1]) < 70 || abs(hs[1] - hs[2]) < 70 ) { //check 2//
        hs[1] = (int) random(25, height-25);
        diff = false;
      }
    }

    baloons.add(new Baloon(question[1], hs[0]));
    baloons.add(new Baloon(question[2], hs[1]));
    baloons.add(new Baloon(question[3], hs[2]));
    made = true;
  }

  void mover() { // flytter ballonerne
    for (Baloon bs : baloons) {
      bs.update();
      bs.display();

      if (front) { // viser kun tekst på de foreste balloner
        bs.displayText();
      }
    }
  }
  
  void display(){
   for (Baloon bs : baloons) {
      bs.display(); 
      bs.displayText(); 
  }
  }

  boolean ohno() { // tab af liv, når ballonerne rør muren
  if (baloons.size() != 0){
    return (baloons.get(0).loc.x <= 225);
  }
  return false;
  }

  boolean hit(float x, float y) { // om ballonerne er blevet skudt.
    for (Baloon bs : baloons) {
      if (abs(x- bs.loc.x) < 30 && abs(y- bs.loc.y) < 30) {
        if (bs.value.equals(question[4]))
        {
        println("Correct");
        guessedCorrect = true;
        }
        else{
         println("Incorrect!");
         guessedCorrect = false;
        }
        return true;
      }
    }
    return false;
  }
}
