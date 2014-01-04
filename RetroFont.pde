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
    int asciiCode = charCodeAt(ch);
    
    if(asciiCode-32 >= 96 || asciiCode-32 <= 0){
      return chars[0];
    }
 
    return chars[asciiCode-32];
  }
  
  public PImage getTrimmedGlyph(char ch){
    int asciiCode = charCodeAt(ch);
    return trimmedChars[asciiCode-32];
  }
  
  public int getGlyphWidth(){
    return glyphWidth;
  }
  
  public int getGlyphHeight(){
    return glyphHeight;
  }
}
