/*
    If an asteroid collides with the player's ship, the user is
    immediately killed.
*/
public class Asteroid extends Sprite{
  
  private float rotSpeed;
  private PImage img;
  private float scaleSize;
  private float size;
  
  public Asteroid(){
    // range from half of image height to full size of image height
    setSize(1.0);

    rotSpeed = random(-.5, .5);
    img = loadImage("data/asteroid.png");  
    
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
    soundManager.playSound("asteroid_destroyed");
    createParticleSystem(position);

    if(size == 1){
      for(int i = 0; i < 2; i++){
        Asteroid a = new Asteroid();
        a.setSize(0.5);
        a.position = copyVector(position);
        a.velocity = getRandomVector(new PVector(-30, -30), new PVector(30,30));
        asteroids.add(a);
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
    scale(scaleSize/img.width, scaleSize/img.height);
    rotate(rotation);
    image(img, 0, 0);
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
/*
    All collision detection in game is done with simple circle/circle intersection tests
*/
public class BoundingCircle{
  public PVector position;
  public float radius;

  public BoundingCircle(){
  	position = new PVector();
  	radius = 0;
  }

  public BoundingCircle clone(){
  	BoundingCircle b = new BoundingCircle();
  	b.position = copyVector(position);
  	b.radius = radius;
  	return b;
  }
}
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
/*
    User controls the ship with their keyboard
*/
public class Ship extends Sprite{
  
  private float accel;  
  private final float ROT_SPEED = 1.0f;
  private Timer thrustTimer;
  
  public Ship(){    
    rotation = 0.0f;
    position = new PVector(width/2, height/2);
    velocity = new PVector();
    thrustTimer = new Timer();
    
    bounds = new BoundingCircle();
    bounds.radius = 20/2.0;
    bounds.position = copyVector(position);
  }
  
  public void fire(){
    soundManager.playSound("shoot");
    createBullet(copyVector(position), new PVector(cos(rotation) * BULLET_SPEED, sin(rotation) * BULLET_SPEED));
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
    if(thrustTimer.getTotalTime() < 0.05 && upKeyDown){
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
    if(leftKeyDown && upKeyDown){
      rotation -= ROT_SPEED * deltaTime;
    }
    
    if(rightKeyDown && upKeyDown){
      rotation += ROT_SPEED * deltaTime;
    }
    
    // slow down faster than speeding up
    // to help player avoid astroid collision.
    if(downKeyDown){
      accel -= 100;
    }
    else if(upKeyDown){
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
/*
*
*/
function SoundManager(){

  var muted;

  var BASE_PATH = "data/audio/";

  var sounds = [];
  var soundNames = [];

  /*
  *
  */
  this.setMute = function(mute){
    muted = mute;
  };

  /*
  */
  this.isMuted = function(){
    return muted;
  };

  /*
  */
  this.stop = function(){
  }

  this.addSound = function(soundName){
    var i = sounds.push(document.createElement('audio')) - 1 ;
    sounds[i].setAttribute('src', BASE_PATH + soundName + ".ogg");
    console.log(sounds[i]);
    sounds[i].preload = 'auto';
    sounds[i].load();
    sounds[i].volume = 0;
    sounds[i].setAttribute('autoplay', 'autoplay');

    soundNames[i] = soundName;
  }

  /*
  */
  this.playSound = function(soundName){
    var soundID = -1;

    if(muted){
      return;
    }

    for(var i = 0; i < sounds.length; i++){
      if(soundNames[i] === soundName){
        soundID = i;
        break;
      }
    }

    // return early if the soundName wasn't found to prevent AOOB
    if(soundID === -1){
      return;
    }

    sounds[soundID].volume = 1.0;

    // Safari does not want to play sounds...??
    try{
      sounds[soundID].volume = 1.0;
      sounds[soundID].play();
      sounds[soundID].currentTime = 0;
    }catch(e){
      console.log("Could not play audio file.");
    }
  };
}
/*
  @pjs preload="data/asteroid.png";
*/
 
// A clone of Asteroids
// November 2014

import ddf.minim.*;

final int ASTEROID_POINTS = 100;

final float BULLET_SPEED = 200.0f;

PFont font;

Starfield starfield;
Ship ship;
ArrayList <Asteroid> asteroids;
ArrayList <Bullet> bullets;
ArrayList <ParticleSystem> particleSystems;

Timer timer;

boolean gameOver = false;
boolean debugOn = false;

final int NUM_ASTEROIDS = 25;
int numAsteroidsAlive = NUM_ASTEROIDS;

SoundManager soundManager;

int score = 0;

// keyboard stuff
final int KEY_SPACE = 32;
final int KEY_D = 68;
boolean leftKeyDown = false;
boolean rightKeyDown = false;
boolean upKeyDown = false;
boolean downKeyDown = false;

void setup() {
  size(400, 400);
  imageMode(CENTER);
  
  timer = new Timer();
  starfield = new Starfield(100);
  ship = new Ship();

  // Init sprites
  generateAsteroids();
  bullets = new ArrayList<Bullet>();
  particleSystems = new ArrayList<ParticleSystem>();

  // 
  soundManager = new SoundManager(this);
  soundManager.addSound("shoot");
  soundManager.addSound("asteroid_destroyed");
  soundManager.addSound("ship_destroyed");

  font = createFont("VectorBattle", 32);
  textFont(font, 24);
}

void draw() {
  update();
  
  background(0);
  
  // Not strictly requires for Processing, but
  // a bug in pjs requires this line here.
  resetMatrix();

  if(!gameOver){
    starfield.draw();
    
    // ASTEROIDS
    for(int i = 0; i < asteroids.size(); i++){
      asteroids.get(i).draw();
    }
  
    // BULLETS
    for(int i = 0; i < bullets.size(); i++){
      bullets.get(i).draw();
    }

    // PSYS
    for(int i = 0; i < particleSystems.size(); i++){
      particleSystems.get(i).draw();
    }

    // SHIP
    ship.draw();


     
    // Not strictly requires for Processing, but
    // a bug in pjs requires this line here.
    resetMatrix();
    
    // SCORE
    pushStyle();
    fill(255);
    textAlign(CENTER);

    text(prependStringWithString("" + score, "0", 8), width/2, 50);
    popStyle();
  }else{
    pushStyle();
    textAlign(CENTER, CENTER);
    fill(255);
    text("Game Over", width/2, height/2);
    popStyle();
  }
}

void generateAsteroids(){
  asteroids = new ArrayList<Asteroid>(0);
  
  for(int i = 0; i < NUM_ASTEROIDS; i++){
    Asteroid a = new Asteroid();
    
    // Place asteroids around the ship so they don't
    // immediately collide with the player. 
    PVector pvec = randomVector();
    pvec.x *= width/4;
    pvec.y *= height/4;
    
    pvec.x *= random(1, 2);
    pvec.y *= random(1, 2);

    pvec.x += width/2;
    pvec.y += height/2;

    a.position = pvec;
    a.setSize(1);
    
    asteroids.add(a);
  }  
}

/*
  Create a particle system in place of a sprite.
*/
void createParticleSystem(PVector pos){
  ParticleSystem psys = new ParticleSystem(15);
  particleSystems.add(psys);

  psys.setParticleVelocity(new PVector(-35,-35), new PVector(35,35));
  psys.setParticleLifeTime(0.2, 1);
  psys.setPosition(pos);
  psys.emit(15);
}

void update(){
  timer.tick();
  float deltaTime = timer.getDeltaSec();
    
  if(ship.isDestroyed() || numAsteroidsAlive == 0){
    //endGame();
    //return;
  }
  
  for(int i = 0; i < asteroids.size(); i++){
    asteroids.get(i).update(deltaTime);
  }
  
  for(int i = 0; i < bullets.size(); i++){
    bullets.get(i).update(deltaTime);
  }

  for(int i = 0; i < particleSystems.size(); i++){
    particleSystems.get(i).update(deltaTime);
  }
  
  ship.update(deltaTime);
  
  testCollisions();
}

void testCollisions(){
  for(int currAsteroid = 0; currAsteroid < asteroids.size(); currAsteroid++){
    for(int currBullet = 0; currBullet < bullets.size(); currBullet++){
      if(bullets.get(currBullet).isDestroyed() || asteroids.get(currAsteroid).isDestroyed()){
        continue;
      }
      
      BoundingCircle bulletBounds  = bullets.get(currBullet).getBoundingCircle();
      BoundingCircle asteroidBounds = asteroids.get(currAsteroid).getBoundingCircle();
      
      if( testCircleCollision(bulletBounds, asteroidBounds)){
        bullets.get(currBullet).destroy();
        asteroids.get(currAsteroid).destroy();
        numAsteroidsAlive--;
        score += ASTEROID_POINTS;
      }
    }
  }
  
  // Test collision against player's ship
  for(int currAsteroid = 0; currAsteroid < asteroids.size(); currAsteroid++){
    
    Asteroid a = asteroids.get(currAsteroid);
    // We recycle the list, so make sure we don't check against and element that is not active.
    if(a.isDestroyed()){
      continue;
    }
    
    BoundingCircle asteroidBounds = a.getBoundingCircle();
    BoundingCircle ShipBounds = ship.getBoundingCircle();
    
    if(testCircleCollision(asteroidBounds, ShipBounds)){
      //endGame();
    }
  }
}

void endGame(){
  gameOver = true;
}

void keyReleased(){

  if(keyCode == RIGHT){
    rightKeyDown = false;
  } 
  
  if(keyCode == LEFT){
    leftKeyDown = false;
  }
  
  if(keyCode == UP){
    upKeyDown = false;
  }
  
  if(keyCode == DOWN){
    downKeyDown = false;
  }
}

void keyPressed() {
  if (keyCode == LEFT) {
    leftKeyDown = true;
  }
  
  if (keyCode == RIGHT) {
    rightKeyDown = true;
  }
  
  if(keyCode == UP){
    upKeyDown = true;
  }
  
  if(keyCode == DOWN){
    downKeyDown = true;
  }
  
  if (keyCode == SHIFT) {
    ship.fire();
  }
  
  // key 'D' for debugging
  if(keyCode == KEY_D){
    debugOn = !debugOn;
  }
}

/**
    Recycle bullets when we can.
*/
void createBullet(PVector position, PVector velocity){
  
  int index = -1;
  for(int i = 0; i < bullets.size(); i++){
    if(bullets.get(i).isDestroyed()){
      index = i;
      break;
    }
  }
  
  Bullet bullet = new Bullet();
  bullet.position = position;
  bullet.velocity = velocity;
  
  if(index == -1){
    bullets.add(bullet);
  }
  else{
    bullets.set(index, bullet);
  }
}
/*
    Base class for Asteroids, Bullets and Ship
*/
public class Sprite{

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
  
  public void updateBounds(){
    bounds.position = copyVector(position);
  }
  
  public BoundingCircle getBoundingCircle(){
    return bounds.clone();
    //copyBoundingCircle(bounds);
  }
}
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
/**
  * A ticker class to manage animation timing.
  */
public class Timer{

  private int lastTime;
  private float deltaTime;
  private boolean isPaused;
  private float totalTime;
  private boolean countingUp; 
  
  public Timer(){
    reset();
  }
  
  public void setDirection(int d){
    countingUp = false;
  }
  
  public void reset(){
    deltaTime = 0f;
    lastTime = -1;
    isPaused = false;
    totalTime = 0f;
    countingUp = true;
  }
  
  //
  public void pause(){
    isPaused = true;
  }
  
  public void resume(){
    deltaTime = 0f;
    lastTime = -1;
    isPaused = false;
  }
  
  public void setTime(int min, int sec){    
    totalTime = min * 60 + sec;
  }
  
  /*
      Format: 5.5 = 5 minutes 30 seconds
  */
  public void setTime(float minutes){
    int int_min = (int)minutes;
    int sec = (int)((minutes - (float)int_min) * 60);
    setTime( int_min, sec);
  }
  
  public float getTotalTime(){
    return totalTime;
  }
  
  /*
  */
  public float getDeltaSec(){
    if(isPaused){
      return 0;
    }
    return deltaTime;
  }
  
  /*
  * Calculates how many seconds passed since the last call to this method.
  *
  */
  public void tick(){
    if(lastTime == -1){
      lastTime = millis();
    }
    
    int delta = millis() - lastTime;
    lastTime = millis();
    deltaTime = delta/1000f;
    
    if(countingUp){
      totalTime += deltaTime;
    }
    else{
      totalTime -= deltaTime;
    }
  }
}
/*
    General utility functions
*/

public PVector copyVector(PVector vec){
  if(vec == null){
    println("vec was null");
    return new PVector();
  }
  return new PVector(vec.x, vec.y, vec.z);
}

public PVector randomVector(){
  PVector pvec = new PVector(random(-1,1), random(-1,1), 0);
  pvec.normalize();
  return pvec;
}

public PVector getRandomVector(PVector vec1, PVector vec2){
  float minX = vec1.x <= vec2.x ? vec1.x : vec2.x;
  float maxX = vec1.x >= vec2.x ? vec1.x : vec2.x;
  
  float minY = vec1.y <= vec2.y ? vec1.y : vec2.y;
  float maxY = vec1.y >= vec2.y ? vec1.y : vec2.y;
 
  return new PVector(random(minX, maxX), random(minY, maxY));
}


public float getRandomFloat(float num1, float num2){
  if(num1 < num2){
    return random(num1, num2);
  }
  return random(num2, num1);
}

/*public BoundingCircle copyBoundingCircle(BoundingCircle bc){
    BoundingCircle b = new BoundingCircle();
    b.radius = bc.radius;
    b.position = copyVector(bc.position);
    return b;
}*/

public boolean testCircleCollision(BoundingCircle c1, BoundingCircle c2){
  PVector pvec = PVector.sub(c1.position, c2.position);
  if(c1.position.dist(c2.position) > c1.radius + c2.radius){
    return false;
  }
  return true;
}

/*
*  Used when rendering the score
*/
public static String prependStringWithString(String baseString, String prefix, int newStrLength){
  if(newStrLength <= baseString.length()){
    return baseString;
  }
  
  int zerosToAdd = newStrLength - baseString.length();
  
  for(int i = 0; i < zerosToAdd; i++){
    baseString = prefix + baseString;
  }
  
  return baseString;
}

/*
    Small particle system is created when some of the sprites
    are destroyed.
*/
public class ParticleSystem{
  

  private PVector position;
  
  private ArrayList particles;
  
  private PVector minVelocityRange;
  private PVector maxVelocityRange;
  
  private int numParticlesAlive;
  private float minLifeTimeRange;
  private float maxLifeTimeRange;
    


  class cParticle{
    
    PVector position;
    PVector velocity;
    PVector acceleration;
    
    // lifetime
    float age;
    float lifeTime;
    boolean alive;
      
    public cParticle(){
      position = new PVector();
      velocity = new PVector();
      acceleration = new PVector();
      
      age = 0.0f;
      lifeTime = 1.0f;
      alive = true;
    }
  
    public void update(float deltaTimeInSeconds){
      
      velocity.x += acceleration.x * deltaTimeInSeconds;
      velocity.y += acceleration.y * deltaTimeInSeconds;
      
      position.x += velocity.x * deltaTimeInSeconds;
      position.y += velocity.y * deltaTimeInSeconds;

      age += deltaTimeInSeconds;
      if(age >= lifeTime){
        alive = false;
      }
    }
    
    public boolean isAlive(){
      return alive;
    }
    
    public void setPosition(PVector pos){
      position = pos;
    }
    
    public void setVelocity(PVector vel){
      velocity = vel;
    }
    
    public void setAcceleration(PVector accel){
      acceleration = accel;
    }
    
    public void setLifeTime(float l){
      if(l > 0.0f){
        lifeTime = l;
      }
    }
    
    public void draw(){
      float opacity =  255 * (1 - (age/lifeTime));
      pushStyle();
      fill(255, opacity);
      noStroke();
      ellipse(position.x, position.y, 1, 1);
      popStyle();
    }
  }
  
  
 
  public ParticleSystem(int numParticles){
    
    setPosition(new PVector());
    
    numParticlesAlive = numParticles;
    
    setParticleLifeTime(0, 0);
    setParticleVelocity(new PVector(), new PVector());
    
    particles = new ArrayList();
    for(int i = 0; i < numParticles; i++){
      cParticle particle = new cParticle();      
      particles.add(particle);
    }
  }
  
  public void setPosition(PVector pos){
    position = new PVector(pos.x, pos.y);
  }

  public void setParticleVelocity(PVector vel1, PVector vel2){
    minVelocityRange = vel1;
    maxVelocityRange = vel2;
  }

  public void update(float deltaTimeInSeconds){
    // update all the particles
    for(int i = 0; i < particles.size(); i++){
      cParticle particle = (cParticle)particles.get(i);
      particle.update(deltaTimeInSeconds);
    }
  }
  
  public void draw(){
    // update all the particles
    for(int i = 0; i < particles.size(); i++){
      cParticle particle = (cParticle)particles.get(i);
      if(particle.isAlive()){
        particle.draw();
      }
    }
  }
          
  public void emit(float numParticles){
    for(int i = 0; i < particles.size(); i++){
      cParticle particle = (cParticle)particles.get(i);
      particle.setPosition(new PVector(position.x, position.y));
      
      particle.setVelocity(getRandomVector(minVelocityRange, maxVelocityRange));
      //particle.setAcceleration(acceleration);
      
      particle.setLifeTime(getRandomFloat(minLifeTimeRange, maxLifeTimeRange));
    }
  }
          
  public void setParticleLifeTime(float minLifeTime, float maxLifeTime){
    minLifeTimeRange = minLifeTime;
    maxLifeTimeRange = maxLifeTime;
  }
  
  public boolean isDead(){
    
    // if we found at least one particle which is alive, 
    // the system isn't dead.
    for(int i = 0; i < particles.size(); i++){
      cParticle particle = (cParticle)particles.get(i);
      if(particle.isAlive()){
        return false;
      }
    }
    return true;
  }
}
