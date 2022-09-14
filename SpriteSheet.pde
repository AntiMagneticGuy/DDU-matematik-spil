class SpriteSheet{

  PVector Location;
  
  PImage Sprite;
  
  int frame;
  float frameFloat;
  
  float time = 0.0;
  
  int AnimFrameCap;
  int MaxFrames;
  
  int Xframes;
  int Yframes;
  
  int startFrame;
  
  float SpriteScale = 1.0;
  
  
  
  float LoopPause;
  float LoopReachTime;
  boolean WaitingForLoop = false;
  
  
  
  
  float FPS;
  boolean IsPlaying;
  boolean Looping;

  SpriteSheet(){
   frame = 0; 
   frameFloat = 0.0;
   startFrame = 0;
   IsPlaying = false;
   Looping = true;
   LoopPause = 0.0;
   Sprite = new PImage();
   Location = new PVector(0,0);
   AnimFrameCap = 0;
   FPS = 12;
    
  }

  void playAnimation(int start, int end){
    setFrame(start);
    AnimFrameCap = end;
    IsPlaying = true;
    startFrame = start;
  }
  void setFrame(int new_frame){
     frameFloat = float(new_frame);
     frame = new_frame;
  }
  void display(){

  if (Sprite != null){
  
    if (IsPlaying){
    frameFloat += FPS/60.0;

    if (frame >= AnimFrameCap){
      if (Looping){
        
        
        if (WaitingForLoop == false){
          WaitingForLoop = true;
          LoopReachTime = millis();
          
        }
        //int pause = int(LoopPause * 1000);
        //delay(pause);
        

        
        if (WaitingForLoop){
          frameFloat = AnimFrameCap; 
        }
        
        if (LoopReachTime + (LoopPause * 1000.0) < millis()){
        
         
          setFrame(startFrame);

          IsPlaying = true;
          WaitingForLoop = false;
        }
      }
      else{
      IsPlaying = false;
      }
    }
  
    }
    
    
    
    if (Looping){
      frame = int(frameFloat) % MaxFrames;
    } else {
     frame = int(frameFloat); 
     if (frame == MaxFrames){
      IsPlaying = false; 
     }
    }
    int w = Sprite.width/Xframes;  
    int h = Sprite.height/Yframes;
    int x = (frame % Xframes)* w;
    int y = (frame / Xframes) * h;    
    scale(SpriteScale);    
    PImage displaySprite = Sprite.get(x,y,w,h);
    image(displaySprite,Location.x/1,Location.y/1);

  }
  }

}
