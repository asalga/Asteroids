/*
    Base class for Asteroids, Bullets and Ship
*/
public abstract class Sprite{

  private boolean dead;  
  
  protected PVector acceleration;
  protected PVector velocity;
  protected PVector position;

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
   if(position.x - bounds.radius > width){
      position.x = -bounds.radius; 
    }
    else if(position.x + bounds.radius < 0){
      position.x = width + bounds.radius;
    }
    else if(position.y + bounds.radius < 0){
        position.y = height + bounds.radius;
    }
    else if(position.y - bounds.radius > height){
      position.y = -bounds.radius;
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
