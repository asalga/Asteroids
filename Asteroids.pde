/*
  @pjs globalKeyEvents="true"; preload="data/images/asteroid.png, data/images/ship-life.png, data/fonts/asteroids-large-font.png, data/fonts/small-font.png";
*/
 
 /*
    - Remove bullet velocity reference from Ship
    - Add thrust audio
    - Fix scanline perf
    - Fix scanlines on Safari
    - Fix audio on Safari
 */

// Andor Salga
// A clone of Asteroids
// January 2014

import ddf.minim.*;

final float BULLET_SPEED = 200.0f;

// Original game has score roll over
final boolean ALLOW_99_990_BUG = false;

final boolean GOD_MODE = false;

Starfield starfield;

boolean debugOn = false;

boolean gameOver = false;
int level = 1;
int score = 0;
int numLives = 3;

ScreenSet screens = new ScreenSet();
Scene scene;
SoundManager soundManager;

/*
*/
void setup() {
  size(400, 400);
  imageMode(CENTER);

  scene = new Scene();

  // get a nice pixelated look
  noSmooth();
      
  // 
  soundManager = new SoundManager(this);
  soundManager.addSound("mame_fire");
  soundManager.addSound("mame_explode0");
  soundManager.addSound("mame_explode1");
  soundManager.addSound("mame_explode2");

  screens.add(new ScreenHighScores());
  screens.add(new GameplayScreen());

  // Toggle keys for showing Bounds and Mute.
  Keyboard.lockKeys(new int[]{KEY_B, KEY_M});
}

/*
*/
void draw() {
  update();
  screens.curr.draw();
  scanLinePostProcess();
}

/*
  Add scanlines for a retro look
*/
void scanLinePostProcess(){
  pushStyle();
  
  stroke(16, 128);
  strokeWeight(1);
  
  for(int i = 0; i < height; i += 2 ){
    line(0, i, width, i);
  }
  
  for(int i = 0; i < width; i += 2 ){
   // line(i, 0, i, height);
  }

  popStyle();
}

/*
*/
void update(){
  screens.curr.update();
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
  screens.curr.keyReleased();
}

void keyPressed(){
  Keyboard.setKeyDown(keyCode, true);

  if(Keyboard.isKeyDown(KEY_M)){
    soundManager.setMute(Keyboard.isKeyDown(KEY_M));
  }

  screens.curr.keyPressed();
}
