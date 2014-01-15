/*
    First thing that is displayed to the user are the high scores.
*/
public class ScreenHighScores extends IScreen{
 
  private RetroFont largeFont;
  private RetroFont smallFont;

  private RetroLabel []leaderboardNumbers;
  private RetroLabel []leaderboardScores;
  private RetroLabel []leaderboardNames;
  private RetroLabel pressEnterBlink;
  private RetroLabel andorIncLabel;
  private RetroLabel highScoresLabel;

  private Timer pressEnterBlinkTimer;
  private boolean showingPressEnterLabel;

  private final int NUM_SCORES = 5;

  // Allows us to right-align scores
  private RetroPanel scorePanel;

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

    pressEnterBlink = new RetroLabel(largeFont);
    pressEnterBlink.setText("PRESS ENTER");
    pressEnterBlink.setHorizontalSpacing(2);
    pressEnterBlink.pixelsFromTop(100);

    pressEnterBlinkTimer = new Timer();
    showingPressEnterLabel = true;

    leaderboardNumbers = new RetroLabel[NUM_SCORES];
    leaderboardNames = new RetroLabel[NUM_SCORES];
    leaderboardScores = new RetroLabel[NUM_SCORES];

    for(int i = 0; i < NUM_SCORES; i++){
      leaderboardNumbers[i] = new RetroLabel(largeFont);
      leaderboardNumbers[i].setText("0" + (i+1) + ".");
      leaderboardNumbers[i].pixelsFromTopLeft(150 + (i * 16), 80);

      leaderboardScores[i] = new RetroLabel(largeFont);
      leaderboardScores[i].pixelsFromTopRight(150 + (i * 16), 10);
      scorePanel.addWidget(leaderboardScores[i]);

      leaderboardNames[i] = new RetroLabel(largeFont);
      leaderboardNames[i].pixelsFromTopLeft(150 + (i * 16), 280);
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

  /*
  */
  public void draw(){
    background(0);
    
    highScoresLabel.draw();
    
    scorePanel.draw();

    if(showingPressEnterLabel){
      pressEnterBlink.draw();
    }

    for(int i = 0; i < NUM_SCORES; i++){
      leaderboardNumbers[i].draw();
      leaderboardNames[i].draw();
    }

    andorIncLabel.draw();
  }
  
  public void keyPressed(){
    screens.transitionTo("gameplayscreen");
  }

  public void update(){
    pressEnterBlinkTimer.tick();

    if(pressEnterBlinkTimer.getTotalTime() > 0.5){
      pressEnterBlinkTimer.reset();
      showingPressEnterLabel = !showingPressEnterLabel;
    }
  }
  
  public String getName(){
    return "highscores";
  }
}
