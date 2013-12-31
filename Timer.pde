/**
  * A ticker class to manage animation timing.
  */
public class Timer{

  private int lastTime;
  private float deltaTime;
  private boolean isPaused;
  private float totalTime;
  private boolean countingUp; 
  
  public Timer(){
    reset();
  }
  
  public void setDirection(int d){
    countingUp = false;
  }
  
  public void reset(){
    deltaTime = 0f;
    lastTime = -1;
    isPaused = false;
    totalTime = 0f;
    countingUp = true;
  }
  
  //
  public void pause(){
    isPaused = true;
  }
  
  public void resume(){
    deltaTime = 0f;
    lastTime = -1;
    isPaused = false;
  }
  
  public void setTime(int min, int sec){    
    totalTime = min * 60 + sec;
  }
  
  /*
      Format: 5.5 = 5 minutes 30 seconds
  */
  public void setTime(float minutes){
    int int_min = (int)minutes;
    int sec = (int)((minutes - (float)int_min) * 60);
    setTime( int_min, sec);
  }
  
  public float getTotalTime(){
    return totalTime;
  }
  
  /*
  */
  public float getDeltaSec(){
    if(isPaused){
      return 0;
    }
    return deltaTime;
  }
  
  /*
  * Calculates how many seconds passed since the last call to this method.
  *
  */
  public void tick(){
    if(lastTime == -1){
      lastTime = millis();
    }
    
    int delta = millis() - lastTime;
    lastTime = millis();
    deltaTime = delta/1000f;
    
    if(countingUp){
      totalTime += deltaTime;
    }
    else{
      totalTime -= deltaTime;
    }
  }
}
