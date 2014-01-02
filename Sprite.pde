/*
    Base class for Asteroids, Bullets and Ship
*/
public abstract class Sprite{

  private boolean dead;  
  
  protected PVector position;
  protected PVector velocity;
  protected float rotation;
  
  protected BoundingCircle bounds;
 
  public Sprite(){
    dead = false;
    position = new PVector();
    velocity = new PVector();
    rotation = 0;
  }
  
  public void destroy(){
    dead = true;
  }
  
  public boolean isDestroyed(){
    return dead;
  }
  
  public void moveIfPastBounds(){
   if(position.x > width){
      position.x = 0; 
    }
    else if(position.x < 0){
      position.x = width; 
    }
    else if(position.y < 0){
        position.y = height; 
    }
    else if(position.y > height){
      position.y = 0;
    }
  }

  public void update(float deltaTime){}

  public abstract void draw();
  
  public void updateBounds(){
    bounds.position = copyVector(position);
  }
  
  public BoundingCircle getBoundingCircle(){
    return bounds.clone();
  }
}
