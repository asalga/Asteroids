/*
    All collision detection in game is done with simple circle/circle intersection tests
*/
public class BoundingCircle{
  public PVector position;
  public float radius;

  public BoundingCircle(){
  	position = new PVector();
  	radius = 0;
  }

  public BoundingCircle clone(){
  	BoundingCircle copy = new BoundingCircle();
  	copy.position = copyVector(position);
  	copy.radius = radius;
  	return copy;
  }
}
