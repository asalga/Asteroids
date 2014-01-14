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
/*
    A panel represents a generic container that can hold
    other widgets.
*/
public class RetroPanel extends RetroWidget{

  ArrayList<RetroWidget> children;
  protected boolean dirty;
  
  // Keep track of where the panel is pinned to its parent
  // If the panel becomes dirty, these values can be used to reposition
  // the panel to its proper placement.
  private int anchor;
  private int yPixels;
  private int xPixels;
  
  private static final int FROM_TOP = 0;
  private static final int FROM_CENTER = 1;
  private static final int FROM_BOTTOM = 2;
  private static final int FROM_LEFT = 3;
  private static final int FROM_RIGHT = 4;
  
  private static final int FROM_TOP_LEFT = 5;
  private static final int FROM_TOP_RIGHT = 6;

  private static final int FROM_BOTTOM_LEFT = 7;
  private static final int FROM_BOTTOM_RIGHT = 8;
  
  /*
  */
  public RetroPanel(){
    w = 0;
    h = 0;
    x = 0;
    y = 0;
    removeAllChildren();
    
    anchor = FROM_TOP;
    xPixels = yPixels = 0;
  }
  
  public void removeAllChildren(){
    children = new ArrayList<RetroWidget>();
  }

  public void addWidget(RetroWidget widget){
    widget.setParent(this);
    children.add(widget);
    
    widget.setDebug(debugDraw);
  }
  
  /*
    If the width changes, we'll need to tell all the children
    to readjust themselves.
  */
  public void setWidth(int w){
    this.w = w;
  }
  
  public int getX(){
    return x;
  }
  
  public int getY(){
    return y;
  }
  
  public int getWidth(){
    return w;
  }
  
  public RetroPanel(int x, int y, int w, int h){
    removeAllChildren();
    this.w = w;
    this.h = h;
    this.x = x;
    this.y = y;
  }
  
  /*
      Render widget from the top center relative to parent.
  */
  public void pixelsFromTop(int yPixels){
    RetroWidget p = getParent();
    
    anchor = FROM_TOP;
    this.yPixels = yPixels;

    x = (p.w/2) - (w/2);
    y = yPixels;
  }
  
  /*
  */
  public void pixelsFromTopLeft(int yPixels, int xPixels){
    RetroWidget p = getParent();
    
    anchor = FROM_TOP_LEFT;
    this.yPixels = yPixels;
    this.xPixels = xPixels;
    
    x = xPixels;
    y = yPixels;
  }
  
  /*
  */
  public void pixelsFromTopRight(int yPixels, int xPixels){
    RetroWidget p = getParent();
    
    anchor = FROM_TOP_RIGHT;
    this.yPixels = yPixels;
    this.xPixels = xPixels;

    x = p.w - w;
    y = yPixels;
  }
  
  
  
  /*
    TODO: needs debugging
  */
  public void pixelsFromBottomRight(int yPixels, int xPixels){
    RetroWidget p = getParent();
    
    anchor = FROM_BOTTOM_RIGHT;
    this.yPixels = yPixels;
    this.xPixels = xPixels;
    
    x = p.w - w + xPixels;
    y = p.h - yPixels - h;
  }
  
  /*
  */
  public void pixelsFromBottomLeft(int yPixels, int xPixels){
    RetroWidget p = getParent();
    
    anchor = FROM_BOTTOM_LEFT;
    this.yPixels = yPixels;
    this.xPixels = xPixels;
    
    x = xPixels;
    y = p.h - yPixels - h;
  }
    
  /**
   */
  public void pixelsFromCenter(int xPixels, int yPixels){
    RetroWidget p = getParent();
    
    anchor = FROM_CENTER;
    this.yPixels = yPixels;
    this.xPixels = xPixels;
    
    x = (p.w/2) - (w/2) + xPixels;
    y = (p.h/2) - (h/2) + yPixels;
  }
  
  /*
  */
  public void pixelsFromLeft(int xPixels){
    RetroWidget p = getParent();
    
    anchor = FROM_LEFT;
    this.xPixels = xPixels;
    
    x = xPixels;
    y = (p.h/2) - (h/2);
  }
  
  /*
  */
  public void pixelsFromRight(int xPixels){
    RetroWidget p = getParent();
    
    anchor = FROM_RIGHT;
    this.xPixels = xPixels;

    x = p.w - w - xPixels;
    y = (p.h/2) - (h/2);
  }
  
  
  public void updatePosition(){
    dirty = true;
  }
  
  /*
    If debugging is on, this widget along with all children will
    have a red outline around them.
  */
  public void setDebug(boolean debugOn){
    super.setDebug(debugOn);
    
    for(int i = 0; i < children.size(); i++){
      children.get(i).setDebug(debugOn);
    }
  }

  
  /*
  */
  public void draw(){
    
    // If the 
    if(dirty == true){
      dirty = false;
      
      //if(DEBUG_CONSOLE_ON){
        //println("No longer dirty");
      //}
      
      switch(anchor){
        case FROM_TOP: pixelsFromTop(yPixels);break;
        case FROM_CENTER:pixelsFromCenter(xPixels, yPixels);break;
        case FROM_BOTTOM:break;
        
        
        case FROM_LEFT:   pixelsFromLeft(xPixels);break;
        case FROM_RIGHT:  pixelsFromRight(xPixels);break;
        
        case FROM_TOP_LEFT:   pixelsFromTopLeft(yPixels, xPixels);break;
        case FROM_TOP_RIGHT:  pixelsFromTopRight(yPixels, xPixels);break;
        
        case FROM_BOTTOM_LEFT:  pixelsFromBottomLeft(yPixels, xPixels);break;
        case FROM_BOTTOM_RIGHT: pixelsFromBottomRight(yPixels, xPixels);break;
      }
    }
    
    if(debugDraw){
      pushStyle();
      noFill();
      stroke(255, 0, 0, 255);
      strokeWeight(1);
      rect(x, y, w, h);
      popStyle();
    }
    
    if(visible == false || children.size() == 0){
      return;
    }
    
    pushMatrix();
    translate(x, y);
    for(int i = 0; i < children.size(); i++){
      children.get(i).draw();
    }
    popMatrix();
  }
}
/*
*/
public class RetroFont{
  
  private PImage chars[];
  private PImage trimmedChars[];
  
  private int glyphWidth;
  private int glyphHeight;
  
  /*
      Removes the transparent pixels from the left and right sides of
      the glyph.
  */
  private PImage truncateImage(PImage glyph){
    
    int startX = 0;
    int endX = glyph.width - 1;
    int x, y;

    // Find the starting X coord of the image.
    for(x = glyph.width; x >= 0 ; x--){
      for(y = 0; y < glyph.height; y++){
        
        color testColor = glyph.get(x, y);
        if( alpha(testColor) > 0.0){
          startX = x;
        }
      }
    }

   // Find the ending coord
    for(x = 0; x < glyph.width; x++){
      for(y = 0; y < glyph.height; y++){
        
        color testColor = glyph.get(x,y);
        if( alpha(testColor) > 0.0){
          endX = x;
        }
      }
    }
    return glyph.get(startX, 0, endX - startX + 1, glyph.height);
  }
  
  
  // Do not instantiate directly
  public RetroFont(String imageFilename, int glyphWidth, int glyphHeight, int borderSize){
    this.glyphWidth = glyphWidth;
    this.glyphHeight = glyphHeight;
    
    PImage fontSheet = loadImage(imageFilename);
    
    chars = new PImage[96];
    trimmedChars = new PImage[96];
    
    int x = 0;
    int y = 0;
    
    //
    //
    for(int currChar = 0; currChar < 96; currChar++){  
      chars[currChar] = fontSheet.get(x, y, glyphWidth, glyphHeight);
      trimmedChars[currChar] = truncateImage(fontSheet.get(x, y, glyphWidth, glyphHeight));
      
      x += glyphWidth + borderSize;
      if(x >= fontSheet.width){
        x = 0;
        y += glyphHeight + borderSize;
      }
    }
    
    
    // For each character, truncate the x margin
    //for(int currChar = 0; currChar < 96; currChar++){
      //chars[currChar] = truncateImage( chars[currChar] );
    //}
  }
  
  //public static void create(String imageFilename, int charWidth, int charHeight, int borderSize){ 
  //PImage fontSheet = loadImage(imageFilename);
  public PImage getGlyph(char ch){
    int asciiCode = RetroUtils.charCodeAt(ch);
    
    if(asciiCode-32 >= 96 || asciiCode-32 <= 0){
      return chars[0];
    }
 
    return chars[asciiCode-32];
  }
  
  public PImage getTrimmedGlyph(char ch){
    int asciiCode = RetroUtils.charCodeAt(ch);
    return trimmedChars[asciiCode-32];
  }
  
  public int getGlyphWidth(){
    return glyphWidth;
  }
  
  public int getGlyphHeight(){
    return glyphHeight;
  }
}
/*
 * 
 */
public class RetroLabel extends RetroPanel{
  
  public static final int JUSTIFY_MANUAL = 0; 
  public static final int JUSTIFY_LEFT = 1;
  //public static final int JUSTIFY_RIGHT = 1;

  private final int NEWLINE = 10;

  private String text;
  private RetroFont font;
  
  //
  private int horizontalSpacing;
  private int verticalSpacing;
  private boolean horizontalTrimming;
  
  private int justification;
  
  public RetroLabel(RetroFont font){
    setFont(font);
    setVerticalSpacing(1);
    setHorizontalSpacing(1);
    //setJustification(JUSTIFY_LEFT);
    setHorizontalTrimming(false);
  }
  
  public void setHorizontalTrimming(boolean horizTrim){
    horizontalTrimming = horizTrim;
  }
  
  /**
  */
  public void setHorizontalSpacing(int spacing){
    horizontalSpacing = spacing;
    dirty = true;
  }
  
  public void setVerticalSpacing(int spacing){
    verticalSpacing = spacing;
    dirty = true;
  }
  
  /*
   * Will immediately calculate the width 
   */
  public void setText(String text){
    this.text = text;
    dirty = true;
    
    int newWidth = 0;
    int newHeight = font.getGlyphHeight();
    
    int longestLine = 0;
    
    for(int letter = 0; letter < text.length(); letter++){
    
      if((text.charAt(letter)) == 10){
        newHeight += font.getGlyphHeight();
      }
      else{
        PImage glyph = getGlyph(text.charAt(letter));
        
        if(glyph != null){
          newWidth += glyph.width + horizontalSpacing;
        }
      }
    }
    h = newHeight;
    w = newWidth;
  }
  
  public void setFont(RetroFont font){
    this.font = font;
    dirty = true;
    h = this.font.getGlyphHeight();
  }
  
  /**
  */
  private int getStringWidth(String str){
    return str.length() * font.getGlyphWidth() + (str.length() * horizontalSpacing );
  }
  
  //public void setJustification(int justify){
  //   justification = justify;
  //}
  
  /**
    Draws the text in the label depending on the
    justification of the panel is sits inside
  */
  public void draw(){
    pushStyle();
    imageMode(CORNER);

    super.draw();
    
    // Return if there is nothing to draw
    if(text == null || visible == false){
      return;
    }
    
    if(justification == JUSTIFY_MANUAL){
      int currX = x;
      int lineIndex = 0;
      
      for(int letter = 0; letter < text.length(); letter++){
        if((int)text.charAt(letter) == NEWLINE){
          lineIndex++;
          currX = x;
          continue;
        }
        PImage glyph = getGlyph(text.charAt(letter));
        
        if(glyph != null){
          image(glyph, currX, y + lineIndex * (font.getGlyphHeight() + verticalSpacing));

          currX += glyph.width + horizontalSpacing;
        }
      }
      currX += font.getGlyphWidth();
    }
    else{
    
      // iterate over each word and see if it would fit into the
      // panel. If not, add a line break
      String[] words = text.split(" ");
      int[] firstCharIndex = new int[words.length];
      
      // get indices of fist char of every word
      // for(int word = 0; word < words.length; word++){
      //  firstCharIndex[word] = 
      //}
       firstCharIndex[0] = 0;
      
       int iter = 1;
       for(int letter = 0; letter < text.length(); letter++){
         if(text.charAt(letter) == ' '){
           firstCharIndex[iter] = letter + 1;
           iter++;
         }
       }
       
       int[] wordWidths;
      
      // start drawing at the panel
      int currXPos = x;
      
      int lineIndex = 0;
      
      // Iterate over all the words
      for(int word = 0; word < words.length; word++){
        int wordWidth = getStringWidth(words[word]);
        
        if(justification == JUSTIFY_LEFT){
          if(word != 0 && currXPos + wordWidth + 0 >  getParent().getWidth() ){
            lineIndex++;
            currXPos = x;
          }
        }
        
        // Iterate over the letter of each word
        for(int letter = 0; letter < words[word].length(); letter++){
          
          int firstChar = firstCharIndex[word];
          
          //
          if((int)words[word].charAt(letter) == NEWLINE){
            lineIndex++;
            currXPos = x;
            continue;
          }
          
          PImage glyph = getGlyph(words[word].charAt(letter));
          
          if(glyph != null){
            image(glyph, currXPos, lineIndex * (font.getGlyphHeight() + verticalSpacing));
            currXPos += font.getGlyphWidth() + horizontalSpacing;
          }
        }
        currXPos += font.getGlyphWidth();
      }
    }
    popStyle();
  }
   
  private PImage getGlyph(char ch){
    if(horizontalTrimming == true){
      return font.getTrimmedGlyph(ch);
    }
    return font.getGlyph(ch);
  }
}
/*
 * JS Utilities interface
 */
var RetroUtils = {
  charCodeAt: function(ch){
    return ch.charCodeAt(0);
  }
};
/*

*/
public abstract class RetroWidget{

  // force access from getter so that the appropriate parent
  // can be returned.
  private RetroWidget parent;
  //protected RetroWidget defaultParent;
  protected int x, y, w, h;
  
  protected boolean visible = true;
  protected boolean debugDraw = false;
  
  public RetroWidget(){
    x = y = 0;
    w = h = 0;
    visible = true;
    parent = null;
    debugDraw = false;
  }
  
  public RetroWidget getParent(){
    if(parent != null){
      return parent;
    }
    return new RetroPanel(0, 0, width, height);
  }
  
  public void setVisible(boolean v){
    visible = v;
  }
  
  public boolean getVisible(){
    return visible;
  }
    
  public void setParent(RetroWidget widget){
    parent = widget;
    //defaultParent = null;
  }
  
  public int getWidth(){
    return w;
  }
  
  public int getHeight(){
    return h;
  }

  public void setPosition(int x, int y){
    this.x = x;
    this.y = y;
  }
  
  public void setDebug(boolean debugOn){
    debugDraw = debugOn;
  }
  
  public abstract void draw();
}
/*
    If an asteroid collides with the player's ship, the user is
    immediately killed.

    There are 3 types of asteroids
*/
public class Asteroid extends Sprite{
  
  // Original version of the game didn't have rotating asteroids.
  private static final boolean ALLOW_ROTATION = true;

  // 
  private int[] type0Coords = new int[]{24,0,  0,24, 16,30, 0,40, 17,60, 33,40, 33,60, 50,60, 64,40, 64,24, 48,0,  24,0}; // mushroom
  private int[] type1Coords = new int[]{20,0, 26,16,  0,16, 0,40, 18,60, 40,54, 50,60, 66,46, 42,31, 66,23, 66,18, 44,0, 20,0}; // dinosaur
  private int[] type2Coords = new int[]{18,0,  0,16, 10,30, 0,46, 18,60, 26,53, 50,60, 65,38, 50,22, 65,16, 50,0,  33,8, 18,0}; // x
  private int[] arrType;

  private float rotSpeed;
  private int size;
  private int type;

  private final int SMALL   = 0;
  private final int MEDIUM  = 1;
  private final int LARGE   = 2;
  
  /*
  */
  public Asteroid(){
    rotSpeed = random(-.5, .5);
    
    float randVel = 10;
    
    setRandomType();

    position = new PVector(random(0, width), random(0, height));
    velocity = new PVector(random(-randVel, randVel), random(-randVel, randVel));

    setSize(LARGE);

    name = "asteroid";
  }

  /*
    There are three 'models' of the asteroids.
    TODO: create procedural asteroid models.
  */
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

    ParticleSystem psys = new ParticleSystem(15);
    psys.setParticleVelocity(new PVector(-35,-35), new PVector(35,35));
    psys.setParticleLifeTime(0.2, 1);
    psys.setPosition(position);
    psys.emit(15);
    scene.addSprite(psys);

    if(size != SMALL){
      for(int i = 0; i < 2; i++){
        
        Asteroid a = new Asteroid();
        
        a.position = copyVector(position);
        a.velocity = getRandomVector(new PVector(-30, -30), new PVector(30, 30));
        a.name = "asteroid";

        a.bounds = this.bounds.clone();
        
        a.setSize(size - 1);
        
        scene.addSprite(a);
      }
    }

    // Do this only after the small asteroids have been added to make sure the asteroid
    // count never goes to zero and confuses the game state.
    scene.removeSprite(this);
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
  */
  public void onCollision(Sprite s){  
    if( s.getName().equals("bullet") ||
        //s.getName().equals("ship") ||
        s.getName().equals("saucer")){

      destroy();
    }
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

  /*
    The asteroids are rendered using simple lines.
  */
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
  	BoundingCircle copy = new BoundingCircle();
  	copy.position = copyVector(position);
  	copy.radius = radius;
  	return copy;
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
    name = "bullet";
  }
  
  public void onCollision(Sprite s){
    String other = s.getName();

    if(other.equals("ship") || other.equals("bullet")){
      return;
    }

    destroy();
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
    Base class for Asteroids, Bullets and Ship
*/
public abstract class Sprite{

  private boolean dead;  
  
  protected PVector acceleration;
  protected PVector velocity;
  protected PVector position;

  protected float rotation;
  
  protected BoundingCircle bounds;

  public boolean visible;

  protected String name;
 
  public Sprite(){
    dead = false;
    visible = true;
    position = new PVector();
    velocity = new PVector();
    rotation = 0;
    name = "";
  }
  
  public boolean collidable(){
    return true;
  }

  public void destroy(){
    dead = true;
  }

  public String getName(){
    return name;
  }
  
  public boolean isDestroyed(){
    return dead;
  }
  
  /*
    Graceful placement of the sprite, we wait until it is
    entirely out of view, then place it on the opposite side
    entirely out of view so that the sprites don't appear and
    disappear which isn't nice to see.
  */
  public void moveIfPastBounds(){
   if(position.x - bounds.radius > width){
      position.x = -bounds.radius; 
    }
    else if(position.x + bounds.radius < 0){
      position.x = width + bounds.radius;
    }
    else if(position.y + bounds.radius < 0){
        position.y = height + bounds.radius;
    }
    else if(position.y - bounds.radius > height){
      position.y = -bounds.radius;
    }
  }
  
  public void updateBounds(){
    bounds.position = copyVector(position);
  }
  
  public BoundingCircle getBoundingCircle(){
    return bounds.clone();
  }

  public abstract void update(float deltaTime);
  public abstract void onCollision(Sprite s);
  public abstract void draw();
}
/*
    Simple starfield acts as the background
*/
public class Starfield{
  private PVector[] stars;
  private int numStars;
  
  /*
  */
  public Starfield(int numStars){
    this.numStars = numStars;
    stars = new PVector[numStars];
    
    for(int i = 0; i < numStars; i++){
      stars[i] = new PVector(random(0, width), random(0,height));
    }
  }
  
  /*
    Stars should be a bit dimmer than bullets so the bullets
    are easier to see.
  */
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
public class ParticleSystem extends Sprite{

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
      ellipse(position.x, position.y, 4, 4);
      popStyle();
    }
  }
  
  
  /*
  */
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

    bounds = new BoundingCircle();
    bounds.radius = 0;
    bounds.position = new PVector(0, 0);
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
  
  /*
  */
  public void onCollision(Sprite s){

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
/*
 * Classes poll keyboard state to get state of keys.
 */
public static class Keyboard{
  
  private static final int NUM_KEYS = 128;
  
  // Locking keys are good for toggling things.
  // After locking a key, when a user presses and releases a key, it will register and
  // being 'down' (even though it has been released). Once the user presses it again,
  // it will register as 'up'.
  private static boolean[] lockableKeys = new boolean[NUM_KEYS];
  
  // Use char since we only need to store 2 states (0, 1)
  private static char[] lockedKeyPresses = new char[NUM_KEYS];
  
  // The key states, true if key is down, false if key is up.
  private static boolean[] keys = new boolean[NUM_KEYS];
  
  /*
   * The specified keys will stay down even after user releases the key.
   * Once they press that key again, only then will the key state be changed to up(false).
   */
  public static void lockKeys(int[] keys){
    for(int k : keys){
      if(isValidKey(k)){
        lockableKeys[k] = true;
      }
    }
  }
  
  /*
   * TODO: if the key was locked and is down, then we unlock it, it needs to 'pop' back up.
   */
  public static void unlockKeys(int[] keys){
    for(int k : keys){
      if(isValidKey(k)){
        lockableKeys[k] = false;
      }
    }
  }
  
  /*
   *
   */
  public static void reset(){
    
  }
  
  /* This is for the case when we want to start off the game
   * assuming a key is already down.
   */
  public static void setVirtualKeyDown(int key, boolean state){
    setKeyDown(key, true);
    setKeyDown(key, false);
  }
  
  /**
   */
  private static boolean isValidKey(int key){
    return (key > -1 && key < NUM_KEYS);
  }
  
  /*
   * Set the state of a key to either down (true) or up (false)
   */
  public static void setKeyDown(int key, boolean state){
    
    if(isValidKey(key)){
      
      // If the key is lockable, as soon as we tell the class the key is down, we lock it.
      if( lockableKeys[key] ){
          // First time pressed
          if(state == true && lockedKeyPresses[key] == 0){
            lockedKeyPresses[key]++;
            keys[key] = true;
          }
          // First time released
          else if(state == false && lockedKeyPresses[key] == 1){
            lockedKeyPresses[key]++;
          }
          // Second time pressed
          else if(state == true && lockedKeyPresses[key] == 2){
             lockedKeyPresses[key]++;
          }
          // Second time released
          else if (state == false && lockedKeyPresses[key] == 3){
            lockedKeyPresses[key] = 0;
            keys[key] = false;
          }
      }
      else{
        keys[key] = state;
      }
    }
  }
  
  /* 
   * Returns true if the specified key is down.
   */
  public static boolean isKeyDown(int key){
    return keys[key];
  }
}

// These are outside of keyboard simply because I don't want to keep
// typing Keyboard.KEY_* in the main Tetrissing.pde file
final int KEY_BACKSPACE = 8;
final int KEY_TAB       = 9;
final int KEY_ENTER     = 10;

final int KEY_SHIFT     = 16;
final int KEY_CTRL      = 17;
final int KEY_ALT       = 18;

final int KEY_CAPS      = 20;
final int KEY_ESC       = 27;

final int KEY_SPACE  = 32;
final int KEY_PGUP   = 33;
final int KEY_PGDN   = 34;
final int KEY_END    = 35;
final int KEY_HOME   = 36;

final int KEY_LEFT   = 37;
final int KEY_UP     = 38;
final int KEY_RIGHT  = 39;
final int KEY_DOWN   = 40;

final int KEY_0 = 48;
final int KEY_1 = 49;
final int KEY_2 = 50;
final int KEY_3 = 51;
final int KEY_4 = 52;
final int KEY_5 = 53;
final int KEY_6 = 54;
final int KEY_7 = 55;
final int KEY_8 = 56;
final int KEY_9 = 57;

final int KEY_A = 65;
final int KEY_B = 66;
final int KEY_C = 67;
final int KEY_D = 68;
final int KEY_E = 69;
final int KEY_F = 70;
final int KEY_G = 71;
final int KEY_H = 72;
final int KEY_I = 73;
final int KEY_J = 74;
final int KEY_K = 75;
final int KEY_L = 76;
final int KEY_M = 77;
final int KEY_N = 78;
final int KEY_O = 79;
final int KEY_P = 80;
final int KEY_Q = 81;
final int KEY_R = 82;
final int KEY_S = 83;
final int KEY_T = 84;
final int KEY_U = 85;
final int KEY_V = 86;
final int KEY_W = 87;
final int KEY_X = 88;
final int KEY_Y = 89;
final int KEY_Z = 90;

// Function keys
final int KEY_F1  = 112;
final int KEY_F2  = 113;
final int KEY_F3  = 114;
final int KEY_F4  = 115;
final int KEY_F5  = 116;
final int KEY_F6  = 117;
final int KEY_F7  = 118;
final int KEY_F8  = 119;
final int KEY_F9  = 120;
final int KEY_F10 = 121;
final int KEY_F12 = 122;

//final int KEY_INSERT = 155;

/*
  Mostly manages sprites 
*/
public class Scene{

  // ship, asteroids, bullets  
  private ArrayList <Sprite> sprites;

  private Ship tempShip;
  private Ship ship;
  private Starfield starfield;

  // When the ship is destroyed, we need to wait until 
  // the area is clear to spawn a user in the center of the screen.
  private boolean waitingToRespawn = false;
  
  private final int NUM_ASTEROIDS = 7;
  private int numAsteroidsAlive;

  private boolean runningCollisionTest = false;
  private boolean foundCollision = false;

  /*
  */
  public Scene(){
    starfield = new Starfield(100);
    resetGame();
  }

  /*
    This is called at the start of the game and any time
    the user gets a game over.
  */
  public void resetGame(){
    sprites = new ArrayList <Sprite>();
    gameOver = false;
    score = 0;
    numLives = 3;
    level = 0;
    loadNextLevel();
  }

  /*
    Place the ship back in the center and create a fresh set of asteroids
  */
  private void loadNextLevel(){
    level++;
    generateAsteroids();
    respawn();
  }

  /*
    Don't forget to remvoe the old ship
  */
  void respawn(){
    waitingToRespawn = false;
    
    removeSprite(ship);

    ship = new Ship();
    ship.position = new PVector(width/2, height/2);
    sprites.add(ship);
  }

  /*
    Update & Test Collisions
  */
  public void update(float deltaTime){
    for(int i = 0; i < sprites.size(); i++){
      sprites.get(i).update(deltaTime);
    }

    if(gameOver == false){
      int m = millis();
      testCollisions();
      //println("time: " + (millis() - m));
    }

    if(waitingToRespawn){
      if(SpriteCollidesWithSpriteList(tempShip) == false){
        waitingToRespawn = false;
        respawn();
      }
    }

    // If the game is in a game over state, we wait until the
    // player hits enter.
    if(gameOver){
      if(Keyboard.isKeyDown(KEY_ENTER)){
        resetGame();
      }
    }
    else if(ship.isDestroyed() && waitingToRespawn == false){

      removeSprite(ship);
      numLives--;

      if(numLives == 0){
        //endGame();
        gameOver = true;
      }
      else{
        waitingToRespawn = true;
        tempShip = new Ship();
        return;
      }
    }

    // 
    boolean needsUpdate = false;
    for(int i = 0; i < sprites.size(); i++){
      if(sprites.get(i).isDestroyed()){
        needsUpdate = true;
      }
    }

    if(needsUpdate){
      ArrayList<Sprite> newList = new ArrayList<Sprite>();
      for(int i = 0; i < sprites.size();i++){
        if(sprites.get(i).isDestroyed() == false){
          newList.add(sprites.get(i));
        }
      }

      sprites = newList;
    }
  }

  /*
  */
  private boolean SpriteCollidesWithSpriteList(Sprite s){
    for(int i = 0; i < sprites.size(); i++){
      if(testCircleCollision(s.getBoundingCircle(), sprites.get(i).getBoundingCircle())){
        return true;
      }
    }
    return false;
  }

  /*
    Store the collided sprites into a list, then resolve them.

    After all the sprites are updated, we test for collisions which 
    may mark some sprites as dead. Next update we iterate over our sprite
    list and any sprites marked dead are removed from the list.
  */
  private void testCollisions(){

    int j;

    for(int i = 0; i < sprites.size(); i++){
      for(j = i + 1; j < sprites.size(); j++){

        Sprite temp1 = sprites.get(i);
        Sprite temp2 = sprites.get(j);
        
        // there are no cases in which a sprite with the same type
        // need to test against a collision with the same type.
        if(temp1.getName().equals(temp2.getName())){
          continue;
        }

        BoundingCircle b1 = sprites.get(i).getBoundingCircle();
        BoundingCircle b2 = sprites.get(j).getBoundingCircle();

        if(testCircleCollision(b1, b2)){
          temp1.onCollision(temp2);
          temp2.onCollision(temp1);

          foundCollision = true;
          return;
        }
      }
    }
  }

  /*
    Add a sprite to the list of sprites that will be updated,
    tested for collisions and rendered.
  */
  public void addSprite(Sprite s){
    sprites.add(s);
    
    if(s.getName().equals("asteroid")){
      numAsteroidsAlive++;
    }
  }

  /*
    When an asteroid is destroyed, it calls this to remove
    itself. This helps us keep track of the count left
  */
  public void removeSprite(Sprite s){

    for(int i = 0; i < sprites.size(); i++){
      if(sprites.get(i) == s){
        if(sprites.get(i).getName().equals("asteroid")){
          numAsteroidsAlive--;
          int points = ((Asteroid)sprites.get(i)).getPoints();
          score += points;
        }
        sprites.remove(i);
        break;
      }
    }

    //
    if(numAsteroidsAlive == 0){
      loadNextLevel();
    }
  }

  /*
      O(n)
  */
  public Sprite getSpriteByName(String spriteName){
    for(int i = 0; i < sprites.size(); i++){
      if(sprites.get(i).getName() == spriteName){
        return sprites.get(i);
      }
    }
    return null;
  }

  /*
  */
  private void generateAsteroids(){
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
      
      addSprite(a);
    }  
  }

  /*
  */
  public void draw(){
    starfield.draw();

    for(int i = 0; i < sprites.size(); i++){
      sprites.get(i).draw();
    }
  }
}
/**
*/
public class ScreenSet{
  
  private ArrayList<IScreen> screens;
  public IScreen curr;
  
  public ScreenSet(){
    screens = new ArrayList<IScreen>();
    curr = null;
  }
  
  public void add(IScreen s){
    screens.add(s);
    if(curr == null){
      curr = s;
      curr.OnTransitionTo();
    }
  }
  
  public void setCurr(IScreen s){
    curr = s;
  }
  
  /*
      TODO: add awesome transition effect
  */
  public void transitionTo(String s){
    for(int i = 0; i < screens.size(); i++){
      if(s == screens.get(i).getName()){
        curr = screens.get(i);
        curr.OnTransitionTo();
        break;
      }
    }
  }
}
/*
    Displays game name and credits
*/
public class GameplayScreen extends IScreen{
  
  RetroLabel copyright;
  RetroLabel currentScore;
  RetroPanel scorePanel;
  RetroLabel pushEnterToContinueLabel;
  RetroLabel gameOverLabel;
   
  PImage shipLifeImage;
  RetroFont solarWindsFont;

  RetroFont fontSmall;
  RetroFont largeFont;

  RetroLabel creditsLabel;
  RetroLabel loadingLabel;
  RetroLabel mainTitleLabel;
  
  Timer timer;
  
  public void OnTransitionTo(){
    //resetGame();
  }

  /*
  */
  public GameplayScreen(){
    timer = new Timer();//AS!!
    
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
    copyright.setText("2014 ANDOR INC");

    // We don't want the score bouncing around, so leave the trimming off.
    currentScore = new RetroLabel(largeFont);
    //currentScore.setHorizontalSpacing(1);
    //currentScore.setHorizontalTrimming(true);
    currentScore.pixelsFromRight(0);
    scorePanel.addWidget(currentScore);

    // Images!
    shipLifeImage = loadImage("data/images/ship-life.png");
  }
  
  /**
  */
  public void draw(){
    background(0);
    
    scene.draw();

    // Based on screenshots, the score starts off with two zeros
    currentScore.setText(prependStringWithString("" + score, "0", 2));
 
    // Labels
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

    if(gameOver){
      pushEnterToContinueLabel.draw();
      gameOverLabel.draw();
    }
  }

  /*
  */
  public void update(){

    timer.tick();

    float deltaTime = timer.getDeltaSec();

    // B for show bounding circles
    debugOn = Keyboard.isKeyDown(KEY_B);  
    scene.update(deltaTime);

    if(gameOver && Keyboard.isKeyDown(KEY_ENTER)){
      scene = new Scene();
    }

   /*     
    // Once there are no astroids
    // TODO: add check for bullets from saucer
    if(waitingToRespawn){
      BoundingCircle b = new BoundingCircle();
      b.position = new PVector(width/2, height/2);
      b.radius = 30;
*/
     // if(checkoutAsteroidCollisionAgainstBounds(b) == -1){
      //  waitingToRespawn = false;
       // respawn();
      //} //AS!!!
    //}

    //screens.curr.update();
  }


 /* void updateSpriteList(ArrayList<Sprite> spriteList, float deltaTime){
    for(int i = 0; i < spriteList.size(); i++){
      spriteList.get(i).update(deltaTime);
    }
  }

  void drawSpriteList(ArrayList<Sprite> spriteList){
    for(int i = 0; i < spriteList.size(); i++){
      spriteList.get(i).draw();
    }
  }
  */
  public String getName(){
    return "gameplayscreen";
  }
}
/*
    First thing that is displayed to the user are the high scores

*/
public class ScreenHighScores extends IScreen{
 
  RetroFont largeFont;
  RetroFont smallFont;

  RetroLabel highScoresLabel;
  
  RetroLabel []leaderboardNumbers;
  RetroLabel []leaderboardScores;
  RetroLabel []leaderboardNames;

  // Allows us to right-align scores
  RetroPanel scorePanel;

  RetroLabel andorIncLabel;

  public ScreenHighScores(){
    largeFont = new RetroFont("data/fonts/asteroids-large-font.png", 12, 14, 2);
    smallFont = new RetroFont("data/fonts/small-font.png", 4, 4, 1);

    scorePanel = new RetroPanel();
    scorePanel.setWidth(width/2);
    scorePanel.pixelsFromTopLeft(0, 50);

    highScoresLabel = new RetroLabel(largeFont);
    highScoresLabel.setText("HIGH SCORES");
    highScoresLabel.setHorizontalSpacing(2);
    highScoresLabel.pixelsFromTop(50);

    leaderboardNumbers = new RetroLabel[5];
    leaderboardNames = new RetroLabel[5];
    leaderboardScores = new RetroLabel[5];

    for(int i = 0; i < 5; i++){
      leaderboardNumbers[i] = new RetroLabel(largeFont);
      leaderboardNumbers[i].setText("0" + (i+1) + ".");
      leaderboardNumbers[i].pixelsFromTopLeft(100 + (i * 16), 80);

      leaderboardScores[i] = new RetroLabel(largeFont);
      leaderboardScores[i].pixelsFromTopRight(100 + (i * 16), 10);
      scorePanel.addWidget(leaderboardScores[i]);

      leaderboardNames[i] = new RetroLabel(largeFont);
      leaderboardNames[i].pixelsFromTopLeft(100 + (i * 16), 280);
    }


    leaderboardScores[0].setText("6493100");
    leaderboardNames[0].setText("CPP");

    leaderboardScores[1].setText("4293600");
    leaderboardNames[1].setText("RPG");

    leaderboardScores[2].setText("3923800");
    leaderboardNames[2].setText("HAX");

    leaderboardScores[3].setText("2551900");
    leaderboardNames[3].setText("LUA");

    leaderboardScores[4].setText("27200");
    leaderboardNames[4].setText("CSS");


    andorIncLabel = new RetroLabel(smallFont);
    andorIncLabel.setText("2014 ANDOR INC");
    andorIncLabel.setVerticalSpacing(0);
    andorIncLabel.setHorizontalTrimming(true);
    andorIncLabel.pixelsFromTop(height - 20);
  }

  public void OnTransitionTo(){}

  /**
  */
  public void draw(){
    background(0);
    
    highScoresLabel.draw();
    
    scorePanel.draw();

    for(int i = 0; i < 5; i++){
      leaderboardNumbers[i].draw();
      leaderboardNames[i].draw();
    }

    andorIncLabel.draw();
  }
  
  public void keyPressed(){
    screens.transitionTo("gameplayscreen");
  }

  public void update(){
  }
  
  public String getName(){
    return "highscores";
  }
}
/*
    
*/
public class IScreen{
  
  public void draw(){}
  public void update(){}
  
  public void mousePressed(){}
  public void mouseReleased(){}
  public void mouseDragged(){}
  public void mouseMoved(){}
  
  public void keyPressed(){}
  public void keyReleased(){}
  public void OnTransitionTo(){}
  
  public String getName(){
    return "none";
  }
}
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
