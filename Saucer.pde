/*
    One saucer will appear at random times. At early waves
    the saucer will be large and randomly shoot. At later waves

    Saucers don't wrap around since they only appear briefly on the screen and move 
    horizontally.

    Saucers can also vanish at random times.
*/
public class Saucer extends Sprite{

  public static final int SMALL_TYPE = 0;
  public static final int LARGE_TYPE = 1;

  private int type;
  private Sprite target;
  private PVector destination;
  //private float bulletTimer;

  /*
  */
  public Saucer(){
    setType(LARGE_TYPE);
    //setPosition(new PVector(0, 0));
    position = new PVector(0, 0);
    bounds = new BoundingCircle();
    bounds.radius = 10;
  }

  /*
  */
  public void onCollision(Sprite s){
  }

  /*
    Saucer.SMALL_TYPE or Saucer.LARGER_TYPE
  */
  public void setType(int t){
    if(t == SMALL_TYPE || t == LARGE_TYPE){
      type = t;
    }
  }

  /*
    The Sprite that the saucer will shoot at. Typically will be the users
    ship.
  */
  public void setTarget(Sprite t){
    target = t;
  }

  /*
    accuracy must be normalized.
  */
  public void setAccuracy(float accuracy){

  }

  public void goTo(PVector d){
    destination = d;
  }

  /*
  */
  public void destroy(){
    super.destroy();
    soundManager.playSound("mame_explode1");
  }
  
  public void update(float deltaTime){
    bounds.position = copyVector(position);

    position.x += velocity.x * deltaTime;
    position.y += velocity.y * deltaTime;
  }

  /*
  */
  public void draw(){
    if(isDestroyed()){
      return;
    }

    pushMatrix();

    translate(position.x, position.y);

    pushStyle();

    if(type == SMALL_TYPE){
      fill(255,0,0);
      ellipse(position.x, position.y,3,3);
    }
    else{
      fill(255,0,255);
      ellipse(position.x, position.y,3,3);
    }
    
    
    //stroke(255);
    //strokeWeight(3);
    //fill(0);


    
    //line(10, 0, -10, 5);
    //line(10, 0, -10, -5);
    //line(-6, 4, -6, -4);

    //if(debugOn){
      //noFill();
      stroke(255, 0, 0);
      ellipse(0, 0, bounds.radius * 2, bounds.radius * 2);
    //}

    popStyle();
    popMatrix();
  }

  /*
  private final float ROT_SPEED = 5.0f;

  private Timer thrustTimer;
  private Timer shootingTimer;
  private Timer teleportTimer;

  public Ship(){
    rotation = 0.0f;
    
    position = new PVector(width/2, height/2);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);

    thrustTimer = new Timer();
    shootingTimer = new Timer();
    teleportTimer = new Timer();
    
    bounds = new BoundingCircle();
    bounds.radius = 20/2.0;
    bounds.position = copyVector(position);
  }
  
  public void destroy(){
    super.destroy();
    soundManager.playSound("mame_explode1");
  }
  
    Move the ship to a random location without teleporting it into an asteroid.
  
  private void teleport(){

    // player needs to wait at least 1 second before teleporting again
    if(teleportTimer.getTotalTime() < 1.0f){
      return;
    }

    teleportTimer.reset();

    // Make sure not to teleport too close to an astroid, the player
    // needs a chance to dodge astroids in their new position.
    bounds.radius *= 3;

    // Don't spawn the player too close to the edge of the game border, it
    // might be too hard to see.
    int border = 40;

    do{
      float randX = random(40, width - 40);
      float randY = random(40, height - 40);

      position = new PVector(randX, randY);
      bounds.position = copyVector(position);

    }while(checkoutAsteroidCollisionAgainstBounds(bounds) != -1);

    bounds.radius /= 3;
  }

  
    Prevent the player from firing too frequently.
  
  public void fire(){
    if(isDestroyed()){
      return;
    }

    if(shootingTimer.getTotalTime() > 0.25f){
      shootingTimer.reset();
      soundManager.playSound("mame_fire");
      createBullet(copyVector(position), new PVector(cos(rotation) * BULLET_SPEED, sin(rotation) * BULLET_SPEED));
    }
  }
  

  
  public void update(float deltaTime){
    shootingTimer.tick();
    teleportTimer.tick();

    if(isDestroyed()){
      return;
    }

    // Some versions have teleporting others have a shield
    // TODO: add shield option
    if(Keyboard.isKeyDown(KEY_DOWN) || Keyboard.isKeyDown(KEY_S)){
      teleport();
    }

    if(Keyboard.isKeyDown(KEY_LEFT) || Keyboard.isKeyDown(KEY_A)){
      rotation -= ROT_SPEED * deltaTime;
    }
    
    if(Keyboard.isKeyDown(KEY_RIGHT) || Keyboard.isKeyDown(KEY_D)){
      rotation += ROT_SPEED * deltaTime;
    }

    if(Keyboard.isKeyDown(KEY_UP) || Keyboard.isKeyDown(KEY_W)){
      acceleration.x = cos(rotation) * 50.0f;
      acceleration.y = sin(rotation) * 50.0f;

      thrustTimer.tick();
      if(thrustTimer.getTotalTime() > 0.1){
        thrustTimer.reset();
      }
    }
    else{
      acceleration.x = 0;
      acceleration.y = 0;
    }
    
    velocity.x += acceleration.x * deltaTime;
    velocity.y += acceleration.y * deltaTime;

    velocity.x = (1.0 - DRAG * deltaTime) * velocity.x;
    velocity.y = (1.0 - DRAG * deltaTime) * velocity.y;
    
    position.x += velocity.x * deltaTime;
    position.y += velocity.y * deltaTime;
    
    updateBounds();
    moveIfPastBounds();
  }*/
}
