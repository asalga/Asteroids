/*
    General utility functions
*/

public PVector copyVector(PVector vec){
  if(vec == null){
    println("vec was null");
    return new PVector();
  }
  return new PVector(vec.x, vec.y, vec.z);
}

public PVector randomVector(){
  PVector pvec = new PVector(random(-1,1), random(-1,1), 0);
  pvec.normalize();
  return pvec;
}

public PVector getRandomVector(PVector vec1, PVector vec2){
  float minX = vec1.x <= vec2.x ? vec1.x : vec2.x;
  float maxX = vec1.x >= vec2.x ? vec1.x : vec2.x;
  
  float minY = vec1.y <= vec2.y ? vec1.y : vec2.y;
  float maxY = vec1.y >= vec2.y ? vec1.y : vec2.y;
 
  return new PVector(random(minX, maxX), random(minY, maxY));
}


public float getRandomFloat(float num1, float num2){
  if(num1 < num2){
    return random(num1, num2);
  }
  return random(num2, num1);
}

/*public BoundingCircle copyBoundingCircle(BoundingCircle bc){
    BoundingCircle b = new BoundingCircle();
    b.radius = bc.radius;
    b.position = copyVector(bc.position);
    return b;
}*/

public boolean testCircleCollision(BoundingCircle c1, BoundingCircle c2){
  PVector pvec = PVector.sub(c1.position, c2.position);
  if(c1.position.dist(c2.position) > c1.radius + c2.radius){
    return false;
  }
  return true;
}

/*
*  Used when rendering the score
*/
public static String prependStringWithString(String baseString, String prefix, int newStrLength){
  if(newStrLength <= baseString.length()){
    return baseString;
  }
  
  int zerosToAdd = newStrLength - baseString.length();
  
  for(int i = 0; i < zerosToAdd; i++){
    baseString = prefix + baseString;
  }
  
  return baseString;
}

