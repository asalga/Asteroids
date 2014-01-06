/*
  @pjs globalKeyEvents="true"; preload="data/images/asteroid.png, data/images/ship-life.png, data/fonts/asteroids-large-font.png, data/fonts/small-font.png";
*/
 
// Andor Salga
// A clone of Asteroids
// November 2014

import ddf.minim.*;

//final int ASTEROID_POINTS = 100;

final float BULLET_SPEED = 200.0f;
final boolean GOD_MODE = false;

PFont font;

Starfield starfield;
Ship ship;
ArrayList <Sprite> asteroids;
ArrayList <Sprite> bullets;
ArrayList <Sprite> particleSystems;

RetroFont fontSmall;
RetroFont largeFont;

RetroLabel copyright;
RetroLabel currentScore;
RetroPanel scorePanel;
RetroLabel pushEnterToContinueLabel;
RetroLabel gameOverLabel;

Timer timer;

boolean gameOver = false;
boolean debugOn = false;

// Original game has score roll over
final boolean ALLOW_99_990_BUG = false;
//final boolean ALLOW_LURKING = false;

final int NUM_ASTEROIDS = 10;
int numAsteroidsAlive = NUM_ASTEROIDS;



SoundManager soundManager;

int level = 1;
int score = 0;
int numLives = 3;

boolean waitingToRespawn = false;

// 
PImage shipLifeImage;
PImage asteroidImage;
PImage ufoImage;

void setup() {
  size(400, 400);
  imageMode(CENTER);

  // get a nice pixelated look
  noSmooth();

  resetGame();

  fontSmall = new RetroFont("data/fonts/small-font.png", 4, 4, 1);
  largeFont = new RetroFont("data/fonts/asteroids-large-font.png", 12, 14, 2);

  scorePanel = new RetroPanel();
  scorePanel.setWidth(50);
  scorePanel.pixelsFromTopLeft(15, 50);

  gameOverLabel = new RetroLabel(largeFont);
  gameOverLabel.setText("GAME OVER");
  gameOverLabel.setHorizontalTrimming(true);
  gameOverLabel.pixelsFromCenter(0,0);

  pushEnterToContinueLabel = new RetroLabel(largeFont);
  pushEnterToContinueLabel.setText("PRESS ENTER TO CONTINUE");
  pushEnterToContinueLabel.setHorizontalTrimming(true);
  pushEnterToContinueLabel.pixelsFromCenter(0, 40);

  copyright = new RetroLabel(fontSmall);
  copyright.setHorizontalSpacing(1);
  copyright.pixelsFromTop(height-40);
  copyright.setHorizontalTrimming(true);

  // We don't want the score bouncing around, so leave the trimming off.
  currentScore = new RetroLabel(largeFont);
  //currentScore.setHorizontalSpacing(1);
  //currentScore.setHorizontalTrimming(true);
  currentScore.pixelsFromRight(0);
  scorePanel.addWidget(currentScore);

  // Images!
  shipLifeImage = loadImage("data/images/ship-life.png");
  asteroidImage = loadImage("data/images/asteroid.png");
  //ufoImage
      
  // 
  soundManager = new SoundManager(this);
  soundManager.addSound("mame_fire");
  soundManager.addSound("mame_explode0");
  soundManager.addSound("mame_explode1");
  soundManager.addSound("mame_explode2");
  
  Keyboard.lockKeys(new int[]{KEY_B, KEY_M});
}

/*
  This is called at the start of the game and any time
  the user gets a game over.
*/
void resetGame(){
  gameOver = false;
  score = 0;
  
  numLives = 3;

  timer = new Timer();
  starfield = new Starfield(100);
  ship = new Ship();

  // Init sprites
  generateAsteroids();
  numAsteroidsAlive = asteroids.size();
  bullets = new ArrayList<Sprite>();
  particleSystems = new ArrayList<Sprite>();
}

void draw() {
  update();
  
  background(0);
  copyright.setText("2014 ANDOR INC");
  
  // Based on screenshots, the score starts off with two zeros
  currentScore.setText(prependStringWithString("" + score, "0", 2));

  if(!gameOver){
    ship.draw();
  }else{
    gameOverLabel.draw();
    pushEnterToContinueLabel.draw();

    if(Keyboard.isKeyDown(KEY_ENTER)){
      resetGame();
    }
  }

  starfield.draw();
    
  drawSpriteList(asteroids);
  drawSpriteList(bullets);
  drawSpriteList(particleSystems);

  copyright.draw();
  
  scorePanel.draw();

  // Draw the small player ships that represent player lives
  // Lives are removed from left to right, so draw from right to left.
  pushMatrix();
  scale(1);
  for(int lives = 0; lives < numLives; lives++){
    image(shipLifeImage, 100 - (lives * (shipLifeImage.width+1)), 34);//, width, height);
  }
  popMatrix();

  // Add scanlines for a retro look
  stroke(16, 128);
  strokeWeight(1);
  for(int i = 0; i < height; i += 2 ){
    line(0, i, width, i);
  }
  
  for(int i = 0; i < width; i += 2 ){
    line(i, 0, i, height);
  }
}

void generateAsteroids(){
  asteroids = new ArrayList<Sprite>(0);
  
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
    //a.setSize(2);
    
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

/*
*/
void loadNextLevel(){
  //timer = new Timer();
  //starfield = new Starfield(100);
  level++;
  ship = new Ship();

  // Init sprites
  generateAsteroids();
  numAsteroidsAlive = asteroids.size();
  //bullets = new ArrayList<Sprite>();
  particleSystems = new ArrayList<Sprite>();
}

void respawn(){
  waitingToRespawn = false;
  ship = new Ship();
}

void update(){
  timer.tick();
  float deltaTime = timer.getDeltaSec();

  // B for show bounding circles
  debugOn = Keyboard.isKeyDown(KEY_B);  
  
  if(numAsteroidsAlive == 0){
    loadNextLevel();
  }

  if(Keyboard.isKeyDown(KEY_SPACE)){
    ship.fire();
  }
  
  updateSpriteList(asteroids, deltaTime);
  updateSpriteList(bullets, deltaTime);
  updateSpriteList(particleSystems, deltaTime);  
  
  if(!gameOver){
    ship.update(deltaTime);
    testCollisions();
  }

  // Once there are no astroids
  // TODO: add check for bullets from saucer
  if(waitingToRespawn){
    BoundingCircle b = new BoundingCircle();
    b.position = new PVector(width/2, height/2);
    b.radius = 30;

    if(checkoutAsteroidCollisionAgainstBounds(b) == -1){
      waitingToRespawn = false;
      respawn();
    }
  }
}

void updateSpriteList(ArrayList<Sprite> spriteList, float deltaTime){
  for(int i = 0; i < spriteList.size(); i++){
    spriteList.get(i).update(deltaTime);
  }
}

void drawSpriteList(ArrayList<Sprite> spriteList){
  for(int i = 0; i < spriteList.size(); i++){
    spriteList.get(i).draw();
  }
}

void testCollisions(){
  for(int currAsteroid = 0; currAsteroid < asteroids.size(); currAsteroid++){
    for(int currBullet = 0; currBullet < bullets.size(); currBullet++){
      if(bullets.get(currBullet).isDestroyed() || asteroids.get(currAsteroid).isDestroyed()){
        continue;
      }
      
      BoundingCircle bulletBounds  = bullets.get(currBullet).getBoundingCircle();
      BoundingCircle asteroidBounds = asteroids.get(currAsteroid).getBoundingCircle();
      
      if(testCircleCollision(bulletBounds, asteroidBounds)){
        bullets.get(currBullet).destroy();
        asteroids.get(currAsteroid).destroy();
        numAsteroidsAlive--;


        increaseScore(((Asteroid)asteroids.get(currAsteroid)).getPoints());
      }
    }
  }
  
  // Test collision against player's ship
  // Prevent destroying it if already destroyed
  if(checkoutAsteroidCollisionAgainstBounds(ship.getBoundingCircle()) != -1 && ship.isDestroyed() == false){
    numLives--;

    ship.destroy();

    if(numLives == 0){
      endGame();
    }
    else{
      waitingToRespawn = true;
    }
  }
}

/*
*/
void increaseScore(int amt){
  score += amt;
  
  if(ALLOW_99_990_BUG && score >= 99990){
    score = 0;
  }
}

/*
  Returns -1 if there is no collision. Otherwise returns the index
  of the asteroid that collided with the ship.

  Made this into a function since Ship needs to use it for the teleport method.


*/
public int checkoutAsteroidCollisionAgainstBounds(BoundingCircle bounds){
  for(int currAsteroid = 0; currAsteroid < asteroids.size(); currAsteroid++){
    
    Asteroid a = (Asteroid)asteroids.get(currAsteroid);
    // We recycle the list, so make sure we don't check against and element that is not active.
    if(a.isDestroyed()){
      continue;
    }
    
    BoundingCircle asteroidBounds = a.getBoundingCircle();
    //BoundingCircle shipBounds = ship.getBoundingCircle();
    
    if(testCircleCollision(asteroidBounds, bounds)){
      return currAsteroid;
    }
  }

  return -1;
}


/*

*/
void endGame(){
  if(GOD_MODE == true){
    return;
  }

  //resetGame();
  gameOver = true;
}

void keyReleased(){
  Keyboard.setKeyDown(keyCode, false);
}

void keyPressed() {
  Keyboard.setKeyDown(keyCode, true);

  if(Keyboard.isKeyDown(KEY_M)){
    soundManager.setMute(Keyboard.isKeyDown(KEY_M));
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
