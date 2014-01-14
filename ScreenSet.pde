/**
*/
public class ScreenSet{
  
  private ArrayList<IScreen> screens;
  public IScreen curr;
  
  public ScreenSet(){
    screens = new ArrayList<IScreen>();
    curr = null;
  }
  
  public void add(IScreen s){
    screens.add(s);
    if(curr == null){
      curr = s;
      curr.OnTransitionTo();
    }
  }
  
  public void setCurr(IScreen s){
    curr = s;
  }
  
  /*
      TODO: add awesome transition effect
  */
  public void transitionTo(String s){
    for(int i = 0; i < screens.size(); i++){
      if(s == screens.get(i).getName()){
        curr = screens.get(i);
        curr.OnTransitionTo();
        break;
      }
    }
  }
}
