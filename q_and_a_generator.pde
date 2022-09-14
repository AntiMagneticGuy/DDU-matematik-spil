import java.util.Iterator;
class QA
{
  
  QA(){
   
  }  
  
  String[] newQuestion(){
    
   int spørgsmål = (int) random(1,5);
   
   if (spørgsmål == 1) {
     
    //Plus Generator
  int svar = (int) random(3,19);
  int tal1 = (int) random(2,10);
  while (svar <= tal1) {
   tal1 = (int) random(1,4);
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
    
    print(spørgsmål);
    return s;
   
   } else if (spørgsmål == 2) {
   
   // Minus Generator
   int svar = (int) random(1,10);
  int tal1 = (int) random(2,19);
  while (svar >= tal1) {
   tal1 = (int) random(2,19);
  }
  int tal2 = abs(svar-tal1);
   
   int t1 = (int)random(-4,4);
   int t2 = (int)random(-4,4);
   
   while (t1 == 0 || t2 == 0 || t1 == t2 || svar+t1 < 0 || svar + t2 < 0){
    t1 = (int)random(-4,4);
   t2 = (int)random(-4,4);
   }
   
   String[] s = new String[5];
    s[0] = str(tal1) + "-" + str(tal2); // question
    s[1] = str(svar+t1);
    s[2] = str(svar+t2);
    s[3] = str(svar);
    s[4] = str(svar); //correct answer
    
    print(spørgsmål);
    return s;
    
 
   } else if (spørgsmål == 3){
   
   //Gange Generator
   
   int tal1 = (int) random(2,10);
   int tal2 = (int) random(2,10);
   int svar = tal1*tal2;
   
   int t1 = (int)random(-4,4);
   int t2 = (int)random(-4,4);
   
   while (t1 == 0 || t2 == 0 || t1 == t2 || svar+t1 < 0 || svar + t2 < 0){
    t1 = (int)random(-4,4);
   t2 = (int)random(-4,4);
   }
   
   String[] s = new String[5];
    s[0] = str(tal1) + "×" + str(tal2); // question
    s[1] = str(svar+t1);
    s[2] = str(svar+t2);
    s[3] = str(svar);
    s[4] = str(svar); //correct answer
    
    print(spørgsmål);
    return s;
   
   } else {
     
   int tal2 = (int) random(2,10);
   int svar = (int) random(2,10);
   int tal1 = svar*tal2;
     
     int t1 = (int)random(-4,4);
   int t2 = (int)random(-4,4);
   
   while (t1 == 0 || t2 == 0 || t1 == t2 || svar+t1 < 0 || svar + t2 < 0){
    t1 = (int)random(-4,4);
   t2 = (int)random(-4,4);
   }
   
   String[] s = new String[5];
    s[0] = str(tal1) + "÷" + str(tal2); // question
    s[1] = str(svar+t1);
    s[2] = str(svar+t2);
    s[3] = str(svar);
    s[4] = str(svar); //correct answer
    
       print(spørgsmål);
    return s;
   }
   

   
   
   /*
    String[] s = new String[5];
    s[0] = str(tal1) + "-" + str(tal2); // question
    s[1] = str(svar+t1);
    s[2] = str(svar+t2);
    s[3] = str(svar);
    s[4] = str(svar); //correct answer
    
    
    return s;
    */
   
  }
  
  
  
  
  
  
  
  
  
  
}
