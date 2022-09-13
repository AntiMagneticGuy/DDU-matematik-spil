import java.util.Iterator;
class QA
{
  ArrayList<String> questionList = new ArrayList<String>(); //spørgsmålne kommer i gruppe af 5: spørgsmål, svar*3 og korrekt svar
  int lastQ;
  QA(){
    lastQ = -1;
    questionList.add("9+10");
    questionList.add("19");
    questionList.add("20");
    questionList.add("21");
    questionList.add("19");
    
    questionList.add("16-9");
    questionList.add("7");
    questionList.add("6");
    questionList.add("5");
    questionList.add("7");
    
    questionList.add("19+5");
    questionList.add("24");
    questionList.add("23");
    questionList.add("22");
    questionList.add("24");
    
    /*
    questionList.add("32-9*2");
    questionList.add("14");
    questionList.add("12");
    questionList.add("16");
    questionList.add("14");
    
    questionList.add("2+2*3");
    questionList.add("12");
    questionList.add("8");
    questionList.add("10");
    questionList.add("10");
    
    questionList.add("(2+2)*3");
    questionList.add("12");
    questionList.add("8");
    questionList.add("10");
    questionList.add("12");
    
    questionList.add("95-7-36");
    questionList.add("52");
    questionList.add("54");
    questionList.add("51");
    questionList.add("52");
    
    questionList.add("93*2-213");
    questionList.add("-37");
    questionList.add("-39");
    questionList.add("-38");
    questionList.add("-37");
    */
  }
  
  
  String[] newQuestion(){
    int i = (int) random(0,questionList.size()/5);
    while (i == lastQ){
      i = (int) random(0,questionList.size()/5);
    }
    lastQ = i;
    String[] s = new String[5];
    s[0] = questionList.get(i*5); // question
    s[1] = questionList.get(i*5+1);
    s[2] = questionList.get(i*5+2);
    s[3] = questionList.get(i*5+3);
    s[4] = questionList.get(i*5+4); //correct answer
    return s;
    
  }
  
  
  
  
  
  
  
  
  
  
}
