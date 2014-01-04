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
