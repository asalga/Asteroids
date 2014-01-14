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
