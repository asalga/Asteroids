/*
    Simple starfield acts as the background
*/
public class Starfield{
  private PVector[] stars;
  private int numStars;
  
  public Starfield(int numStars){
    this.numStars = numStars;
    stars = new PVector[numStars];
    
    for(int i = 0; i < numStars; i++){
      stars[i] = new PVector(random(0, width), random(0,height));
    }
  }
  
  public void draw(){
    pushStyle();
    strokeWeight(1);
    stroke(100);
    
    for(int i = 0; i < numStars; i++){
      point(stars[i].x, stars[i].y);
    }
    
    popStyle();
  }
}
