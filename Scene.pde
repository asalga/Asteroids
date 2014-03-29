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
  
  private int numAsteroidsInLevel = 3;
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
    numAsteroidsInLevel++;
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
        else if(sprites.get(i).isDestroyed() && sprites.get(i).getName().equals("asteroid")){
          numAsteroidsAlive--;
        }
      }
      sprites = newList;
    }

    // 
    if(numAsteroidsAlive == 0){
      loadNextLevel();
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
    int checks = 0;

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

        checks++;
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

    //if(numAsteroidsAlive == 0){
    //  loadNextLevel();
    //}
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
    for(int i = 0; i < numAsteroidsInLevel; i++){
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
