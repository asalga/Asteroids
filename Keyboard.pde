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

