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
  	BoundingCircle b = new BoundingCircle();
  	b.position = copyVector(position);
  	b.radius = radius;
  	return b;
  }
}
