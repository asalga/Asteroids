/*
    When bullets hit an astroid, they are destroyed along with the astroid.
    
    Since the bullets wrap around the edges of the screen, add a MAX_LIFETIME
    to eventually kill them off.
*/
public class Bullet extends Sprite{
  
  private final float MAX_LIFETIME = 2.5f;
  
  private float age;
  
  public Bullet(){
    age = 0.0f;
    
    bounds = new BoundingCircle();
    bounds.radius = 3;
  }
  
  public void draw(){
    if(isDestroyed()){
      return;
    }
    
    pushStyle();
    stroke(255);
    strokeWeight(bounds.radius);
    point(position.x, position.y);
    popStyle();
  }
  
  public void update(float deltaTime){
    if(isDestroyed()){
      return;
    }
    
    age += deltaTime;
    
    if(age >= MAX_LIFETIME){
      destroy();
    }
    
    position.x += velocity.x * deltaTime;
    position.y += velocity.y * deltaTime;
    
    moveIfPastBounds();
    updateBounds(); 
  }
}
