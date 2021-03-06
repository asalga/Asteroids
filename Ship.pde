/*
    User controls the ship with their keyboard.
*/
public class Ship extends Sprite{
  
  private final float ROT_SPEED = 5.0f;
  private final float DRAG = 0.5f;

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

    name = "ship";
  }
  
  public void destroy(){
    super.destroy();
    soundManager.playSound("mame_explode1");
  }

  /*
    Move the ship to a random location without teleporting it into an asteroid.
  */
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

   // do{
      float randX = random(40, width - 40);
      float randY = random(40, height - 40);

      position = new PVector(randX, randY);
      bounds.position = copyVector(position);

      //AS!!
   // }while(checkoutAsteroidCollisionAgainstBounds(bounds) != -1);*/ //AS!!!

    bounds.radius /= 3;
  }

  /*
    self - can't happen
    asteroid - destroy
    ufo - destroy
    self bullet - nothing
  */
  public void onCollision(Sprite s){
    if(s.getName() == "asteroid"){
      destroy();
    }
  }

  /*
    Prevent the player from firing too frequently.
  */
  public void fire(){
    if(isDestroyed()){
      return;
    }

    // TODO: fix
    if(shootingTimer.getTotalTime() > 0.25f){
      shootingTimer.reset();
      soundManager.playSound("mame_fire");

      Bullet b = new Bullet();
      b.position = copyVector(position);
      b.velocity = new PVector(cos(rotation) * BULLET_SPEED, sin(rotation) * BULLET_SPEED);
      scene.addSprite(b);
    }
  }
  
  public void draw(){
    if(isDestroyed() || visible == false){
      return;
    }

    pushMatrix();

    translate(position.x, position.y);
    rotate(rotation);
    
    pushStyle();
    stroke(255);
    strokeWeight(3);
    fill(0);
    
    line(10, 0, -10, 5);
    line(10, 0, -10, -5);
    line(-6, 4, -6, -4);

    // We need to show the thruster if the user is pressing down
    // for a brief period, then hide it to make it look animated.
    if(thrustTimer.getTotalTime() < 0.05 && Keyboard.isKeyDown(KEY_UP)){
      // thruster
      line(-6, 3, -12, 0);
      line(-6, -3, -12, 0);
    }

    //line(-5, -5, -10, 5 );
    //rect(-10,-10, 10, 10);
    //beginShape();
    //  vertex(-8, 8);
    //  vertex(-8, -8);
    //  vertex(8,  0);
    //endShape(CLOSE);
    
    if(debugOn){
      noFill();
      stroke(255, 0, 0);
      ellipse(0, 0, bounds.radius * 2, bounds.radius * 2);
    }

    popStyle();
    popMatrix();
  }
  
  /*
  */
  public void update(float deltaTime){
    if(isDestroyed()){
      return;
    }

    shootingTimer.tick();
    teleportTimer.tick();

    if(Keyboard.isKeyDown(KEY_SPACE)){
      fire();
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
  }
}
