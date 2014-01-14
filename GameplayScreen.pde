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
