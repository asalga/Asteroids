/*
  @pjs globalKeyEvents="true"; preload="data/asteroid.png";
*/
 
// A clone of Asteroids
// November 2014

import ddf.minim.*;

final int ASTEROID_POINTS = 100;

final float BULLET_SPEED = 200.0f;
final boolean GOD_MODE = false;

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


/*boolean leftKeyDown = false;
boolean rightKeyDown = false;
boolean upKeyDown = false;
boolean downKeyDown = false;*/

void setup() {
  size(400, 400);
  imageMode(CENTER);

  // get a nice pixelated look
  noSmooth();
  
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
    endGame();
    return;
  }

  if(Keyboard.isKeyDown(KEY_SPACE)){
    ship.fire();
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
      ship.destroy();
      endGame();
    }
  }
}

/*

*/
void endGame(){
  if(GOD_MODE == true){
    return;
  }
  gameOver = true;
}

void keyReleased(){
  Keyboard.setKeyDown(keyCode, false);
}

void keyPressed() {
  Keyboard.setKeyDown(keyCode, true);  
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
