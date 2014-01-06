/*
    This class uses Minim. When using Processing.js, we don't have 
    access to Minim so we have an equivalent class, SoundManager.js
    that handles audio.
*/
public class SoundManager{
  boolean muted = false;
  Minim minim;
  
  ArrayList <PlayerQueue> queuedSounds;
  ArrayList <String> queuedSoundNames;

  /*
      Handles the issue where we want to play multiple audio streams from the same clip.
  */
  private class PlayerQueue{
    private ArrayList <AudioPlayer> players;
    private String path;

    public PlayerQueue(String audioPath){

      path = audioPath;
      players = new ArrayList<AudioPlayer>();
      appendPlayer();
    }

    public void close(){
      for(int i = 0; i < players.size(); i++){
        players.get(i).close();
      }
    }

    public void play(){
      int freePlayerIndex = -1;
      for(int i = 0; i < players.size(); i++){
        if(players.get(i).isPlaying() == false){
          freePlayerIndex = i;
          break;
        }
      }

      if(freePlayerIndex == -1){
        appendPlayer();
        freePlayerIndex = players.size()-1;
      }

      players.get(freePlayerIndex).play();
      players.get(freePlayerIndex).rewind();
    }

    private void appendPlayer(){
      AudioPlayer player = minim.loadFile(path);
      players.add(player);
    }

    public void setMute(boolean m){
      for(int i = 0; i < players.size(); i++){
        if(m){
          players.get(i).mute();
        }
        else{
          players.get(i).unmute(); 
        }
      }
    }
  }
  
  /*
  */
  public SoundManager(PApplet applet){
    minim = new Minim(applet);

    queuedSounds = new ArrayList<PlayerQueue>();
    queuedSoundNames = new ArrayList<String>();
  }
  
  /*
  */
  public void setMute(boolean isMuted){
    muted = isMuted;

    for(int i = 0; i < queuedSounds.size(); i++){
      queuedSounds.get(i).setMute(muted);
    }
  }
  
  /*
  */
  public boolean isMuted(){
    return muted;
  }

  /*private void play(AudioPlayer player){
    if(muted || player.isPlaying()){
      return;
    }
    
    player.play();
    player.rewind();
  }*/
  
  /*
  */
  public void addSound(String soundName){
    queuedSounds.add(new PlayerQueue("audio/" + soundName + ".wav"));
    queuedSoundNames.add(soundName);
  }

  /*
  */
  public void playSound(String soundName){
    if(muted){
      return;
    }

    int index = -1;

    for(int i = 0; i < queuedSoundNames.size(); i++){
      if(soundName.equals(queuedSoundNames.get(i))){
        index = i;
        break;
      }
    }

    if(index != -1){
      queuedSounds.get(index).play();
    }
  }
  
  /*
  */
  public void stop(){

    for(int i = 0; i < queuedSounds.size(); i++){
      queuedSounds.get(i).close();
    }

    minim.stop();
  }
}
