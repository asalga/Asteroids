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

  public boolean visible;

  protected String name;
 
  public Sprite(){
    dead = false;
    visible = true;
    position = new PVector();
    velocity = new PVector();
    rotation = 0;
    name = "";
  }
  
  public boolean collidable(){
    return true;
  }

  public void destroy(){
    dead = true;
  }

  public String getName(){
    return name;
  }
  
  public boolean isDestroyed(){
    return dead;
  }
  
  /*
    Graceful placement of the sprite, we wait until it is
    entirely out of view, then place it on the opposite side
    entirely out of view so that the sprites don't appear and
    disappear which isn't nice to see.
  */
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
  
  public void updateBounds(){
    bounds.position = copyVector(position);
  }
  
  public BoundingCircle getBoundingCircle(){
    return bounds.clone();
  }

  public abstract void update(float deltaTime);
  public abstract void onCollision(Sprite s);
  public abstract void draw();
}
