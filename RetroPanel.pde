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
