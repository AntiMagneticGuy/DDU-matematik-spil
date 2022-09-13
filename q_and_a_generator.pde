import java.util.Iterator;
class QA
{
  
  QA(){
   
  }  
  
  String[] newQuestion(){
    
  int svar = (int) random(1,99);
  int tal1 = (int) random(1,98);
  while (svar <= tal1) {
   tal1 = (int) random(1,98);
  }
  int tal2 = abs(svar-tal1);
   
   int t1 = (int)random(-4,4);
   int t2 = (int)random(-4,4);
   
   while (t1 == 0 || t2 == 0 || t1 == t2){
    t1 = (int)random(-4,4);
   t2 = (int)random(-4,4);
   }
   
    String[] s = new String[5];
    s[0] = str(tal1) + "+" + str(tal2); // question
    s[1] = str(svar+t1);
    s[2] = str(svar+t2);
    s[3] = str(svar);
    s[4] = str(svar); //correct answer
    
    
    return s;
   
  }
  
  
  
  
  
  
  
  
  
  
}
