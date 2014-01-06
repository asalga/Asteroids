/*
    If an asteroid collides with the player's ship, the user is
    immediately killed.

    There are 3 types of asteroids
*/
public class Asteroid extends Sprite{
  
  // Original version of the game didn't have rotating asteroids.
  private static final boolean ALLOW_ROTATION = true;

  // 
  private int[] type0Coords = new int[]{24,0, 0,24,  16,30, 0,40, 17,60, 33,40, 33,60, 50,60, 64,40, 64,24, 48,0,  24,0}; // mushroom
  private int[] type1Coords = new int[]{20,0, 26,16, 0,16,  0,40, 18,60, 40,54, 50,60, 66,46, 42,31, 66,23, 66,18, 44,0, 20,0}; // dinosaur
  private int[] type2Coords = new int[]{18,0,  0,16, 10,30, 0,46, 18,60, 26,53, 50,60, 65,38, 50,22, 65,16, 50,0,  33,8, 18,0}; // x
  private int[] arrType;

  private float rotSpeed;
  private int size;
  private int type;

  private final int SMALL   = 0;
  private final int MEDIUM  = 1;
  private final int LARGE   = 2;
  
  public Asteroid(){
    // range from half of image height to full size of image height
    
    rotSpeed = random(-.5, .5);
    
    float randVel = 10;
    
    setRandomType();

    position = new PVector(random(0, width), random(0, height));
    velocity = new PVector(random(-randVel, randVel), random(-randVel, randVel));

    setSize(LARGE);
  }

  private void setRandomType(){
    int r = (int)random(0, 3);

    switch(r){
      case 0: arrType = type0Coords;break;
      case 1: arrType = type1Coords;break;
      case 2: arrType = type2Coords;break;
    }
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

  /*

  */
  public void destroy(){
    super.destroy();

    soundManager.playSound("mame_explode" + size);
    
    createParticleSystem(position);

    if(size != SMALL){
      for(int i = 0; i < 2; i++){
        
        Asteroid a = new Asteroid();
        
        a.position = copyVector(position);
        a.velocity = getRandomVector(new PVector(-30, -30), new PVector(30, 30));
        
        a.bounds = this.bounds.clone();
        
        a.setSize(size - 1);
        
        asteroids.add(a);
        numAsteroidsAlive++;
      }
    }
  }
  
  /*
      Points depends on size of asteroid.
  */
  public int getPoints(){
    switch(size){
      case LARGE:   return 20;
      case MEDIUM:  return 50;
      case SMALL:   return 100;
    }
    return 0;
  }

  /*
    s must range from 0 to 2.
  */
  public void setSize(int s){
    if(s == SMALL || s == MEDIUM || s == LARGE){
      size = s;
      
      bounds = new BoundingCircle();

      if(size == 0){ bounds.radius = 8;}
      if(size == 1){ bounds.radius = 16;}
      if(size == 2){ bounds.radius = 32;}
    }
  }

  public void draw(){
    if(isDestroyed()){
      return;
    }
    
    pushMatrix();
    translate(position.x, position.y);
    //scale(scaleSize/asteroidImage.width, scaleSize/asteroidImage.height);
    
    if(ALLOW_ROTATION){
      rotate(rotation);
    }
    
    pushStyle();
    imageMode(CENTER);
    
    stroke(255);
    strokeWeight(2);

    scale(bounds.radius/32);

    //image(asteroidImage, 0, 0);
    
    for(int i = 0; i < arrType.length - 2; i+=2 ){
      line(arrType[i]-32, arrType[i+1]-32, arrType[i+2]-32, arrType[i+3]-32);
    }

    popStyle();
    
    popMatrix();

    if(debugOn){
      pushMatrix();
      translate(position.x, position.y);
      pushStyle();
      stroke(255, 0, 0);
      noFill();
      ellipse(0, 0, bounds.radius * 2 , bounds.radius * 2);
      popStyle();
      popMatrix();
    }
  }
}
