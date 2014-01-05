/*
    If an asteroid collides with the player's ship, the user is
    immediately killed.
*/
public class Asteroid extends Sprite{
  
  // Original version of the game didn't have rotating asteroids.
  private static final boolean ALLOW_ROTATION = true;

  private float rotSpeed;
  private float scaleSize;
  private float size;
  
  public Asteroid(){
    // range from half of image height to full size of image height
    setSize(1.0);

    rotSpeed = random(-.5, .5);
    
    float randVel = 10;
    
    position = new PVector(random(0, width), random(0,height));
    velocity = new PVector(random(-randVel, randVel), random(-randVel, randVel));

    bounds = new BoundingCircle();
    bounds.radius = scaleSize/2.0f;
  }
  
  public void update(float deltaTime){
    if(isDestroyed()){
      return;
    }
    
    position.x += velocity.x * deltaTime;
    position.y += velocity.y * deltaTime;
    
    rotation += rotSpeed * deltaTime;
    
    bounds.position = copyVector(position);
    
    moveIfPastBounds();
    updateBounds();    
  }

  public void destroy(){
    super.destroy();
    soundManager.playSound("mame_explode1");
    createParticleSystem(position);

    if(size == 1){
      for(int i = 0; i < 2; i++){
        Asteroid a = new Asteroid();
        a.setSize(0.5);
        a.position = copyVector(position);
        a.velocity = getRandomVector(new PVector(-30, -30), new PVector(30,30));
        a.bounds = this.bounds.clone();
        a.bounds.radius *= 0.5;
        asteroids.add(a);
        numAsteroidsAlive++;
      }
    }
  }

  /*
    s is normalized
  */
  public void setSize(float s){
    if(s > 0){
      size = s;
      scaleSize = s * 32;
      //random(16, 32);
    }
  }

  public void draw(){
    if(isDestroyed()){
      return;
    }

    
    pushMatrix();
    translate(position.x, position.y);
    scale(scaleSize/asteroidImage.width, scaleSize/asteroidImage.height);
    
    if(ALLOW_ROTATION){
      rotate(rotation);
    }
    
    pushStyle();
    imageMode(CENTER);
    image(asteroidImage, 0, 0);
    popStyle();
    
    popMatrix();
    
    if(debugOn){
      pushMatrix();
      translate(position.x, position.y);
      pushStyle();
      stroke(255, 0, 0);
      ellipse(0, 0, scaleSize, scaleSize);
      popStyle();
      popMatrix();
    }
  }
}
