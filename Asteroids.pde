/*
  @pjs globalKeyEvents="true"; preload="data/images/ship-life.png, data/fonts/asteroids-large-font.png, data/fonts/small-font.png";
*/
 
 /*
    - Remove bullet velocity reference from Ship
    - Add thrust audio
    - Fix audio on Safari
 */

// Andor Salga
// A clone of Asteroids
// January 2014

import ddf.minim.*;

final float BULLET_SPEED = 200.0f;

// Original game has score roll over
final boolean ALLOW_99_990_BUG = false;

boolean godMode = false;

Starfield starfield;

boolean debugOn = true;

boolean gameOver = false;
int level = 1;
int score = 0;
int numLives = 3;

ScreenSet screens = new ScreenSet();
Scene scene;
SoundManager soundManager;
PImage scanLinesOverlay;

/*
*/
void setup() {
  size(400, 400);
  imageMode(CENTER);

  scene = new Scene();

  // get a nice pixelated look
  noSmooth();
  strokeCap(PROJECT);
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


  // Experimenting with pGraphics
  /*scanLines = createGraphics(width, height);
  scanLines.beginDraw();
  scanLines.stroke(16, 255);
  scanLines.noSmooth();
  scanLines.strokeWeight(3);
  for(int i = 0; i < height; i+=5){
    scanLines.line(0,i,width, i);
  }
  scanLines.endDraw();*/

  // Avoid several draw calls to line by just making one image call
  scanLinesOverlay = new createImage(width, height, ARGB);
  scanLinesOverlay.loadPixels();

  // Setup scanline overlay
  boolean drawingLine = false;
  for(int i = 0; i < scanLinesOverlay.pixels.length; i++){
    if (i % width == 0){
      drawingLine = !drawingLine;
    }
    if(drawingLine){
      scanLinesOverlay.pixels[i] = color(16, 255);
    }
  }
  scanLinesOverlay.updatePixels();
}

/*
*/
void draw() {
  update();

  screens.curr.draw();
  image(scanLinesOverlay, 0, 0);

  if(debugOn){
    text("FPS:"+ floor(frameRate), 30, 30);
  }
}

/*
  Deprecated, replaced with a single call to image()
*/
void scanLinePostProcess(){
  pushStyle();
  stroke(16, 128);
  strokeWeight(1);
  for(int i = 0; i < height; i += 2 ){
    line(0, i, width, i);
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
  if(godMode == true){
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
