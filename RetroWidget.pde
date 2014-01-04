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
