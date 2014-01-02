/*
    User controls the ship with their keyboard.
*/
public class Ship extends Sprite{
  
  private float accel;
  
  private final float ROT_SPEED = 1.0f;
  private final boolean ALLOW_ROT_IN_PLACE = true;

  private Timer thrustTimer;
  private Timer shootingTimer;
  
  public Ship(){    
    rotation = 0.0f;
    position = new PVector(width/2, height/2);
    velocity = new PVector();
    thrustTimer = new Timer();
    shootingTimer = new Timer();
    
    bounds = new BoundingCircle();
    bounds.radius = 20/2.0;
    bounds.position = copyVector(position);
  }
  
  /*
    Prevent the player from firing too frequently.
  */
  public void fire(){
    if(isDestroyed()){
      return;
    }

    if(shootingTimer.getTotalTime() > 0.25f){
      shootingTimer.reset();
      soundManager.playSound("fire");
      createBullet(copyVector(position), new PVector(cos(rotation) * BULLET_SPEED, sin(rotation) * BULLET_SPEED));
    }
  }
  
  public void draw(){

    pushMatrix();    
    translate(position.x, position.y);
    rotate(rotation);
    
    pushStyle();
    stroke(128);
    strokeWeight(1);

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
      ellipse(0, 0, bounds.radius*2, bounds.radius*2);
    }
    
    popMatrix();
  }
  

  public void update(float deltaTime){
    shootingTimer.tick();

    if(Keyboard.isKeyDown(KEY_LEFT) && ((Keyboard.isKeyDown(KEY_UP) || ALLOW_ROT_IN_PLACE))){
      rotation -= ROT_SPEED * deltaTime;
    }
    
    if(Keyboard.isKeyDown(KEY_RIGHT) && (Keyboard.isKeyDown(KEY_UP) || ALLOW_ROT_IN_PLACE)){
      rotation += ROT_SPEED * deltaTime;
    }
    
    // slow down faster than speeding up
    // to help player avoid astroid collision.
    if(Keyboard.isKeyDown(KEY_DOWN)){ //downKeyDown){
      accel -= 100;
    }
    else if(Keyboard.isKeyDown(KEY_UP)){
      accel += 50;
      accel = min(accel, 10000);
      thrustTimer.tick();
      if(thrustTimer.getTotalTime() > 0.1){
        thrustTimer.reset();
      }
    }
    else{
      accel -= 50;
    }
    
    accel = max(accel, 0);
    
    velocity.x = accel * deltaTime;
    velocity.y = accel * deltaTime;
    
    position.x += cos(rotation) * deltaTime * velocity.x;
    position.y += sin(rotation) * deltaTime * velocity.y;
    
    updateBounds();
    moveIfPastBounds();
  }
}
