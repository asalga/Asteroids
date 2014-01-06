/*
    Small particle system is created when some of the sprites
    are destroyed.
*/
public class ParticleSystem extends Sprite{

  private PVector position;
  
  private ArrayList particles;
  
  private PVector minVelocityRange;
  private PVector maxVelocityRange;
  
  private int numParticlesAlive;
  private float minLifeTimeRange;
  private float maxLifeTimeRange;
    


  class cParticle{
    
    PVector position;
    PVector velocity;
    PVector acceleration;
    
    // lifetime
    float age;
    float lifeTime;
    boolean alive;
      
    public cParticle(){
      position = new PVector();
      velocity = new PVector();
      acceleration = new PVector();
      
      age = 0.0f;
      lifeTime = 1.0f;
      alive = true;
    }
  
    public void update(float deltaTimeInSeconds){
      
      velocity.x += acceleration.x * deltaTimeInSeconds;
      velocity.y += acceleration.y * deltaTimeInSeconds;
      
      position.x += velocity.x * deltaTimeInSeconds;
      position.y += velocity.y * deltaTimeInSeconds;

      age += deltaTimeInSeconds;
      if(age >= lifeTime){
        alive = false;
      }
    }
    
    public boolean isAlive(){
      return alive;
    }
    
    public void setPosition(PVector pos){
      position = pos;
    }
    
    public void setVelocity(PVector vel){
      velocity = vel;
    }
    
    public void setAcceleration(PVector accel){
      acceleration = accel;
    }
    
    public void setLifeTime(float l){
      if(l > 0.0f){
        lifeTime = l;
      }
    }
    
    public void draw(){
      float opacity =  255 * (1 - (age/lifeTime));
      pushStyle();
      fill(255, opacity);
      noStroke();
      ellipse(position.x, position.y, 4, 4);
      popStyle();
    }
  }
  
  
 
  public ParticleSystem(int numParticles){
    
    setPosition(new PVector());
    
    numParticlesAlive = numParticles;
    
    setParticleLifeTime(0, 0);
    setParticleVelocity(new PVector(), new PVector());
    
    particles = new ArrayList();
    for(int i = 0; i < numParticles; i++){
      cParticle particle = new cParticle();      
      particles.add(particle);
    }
  }
  
  public void setPosition(PVector pos){
    position = new PVector(pos.x, pos.y);
  }

  public void setParticleVelocity(PVector vel1, PVector vel2){
    minVelocityRange = vel1;
    maxVelocityRange = vel2;
  }

  public void update(float deltaTimeInSeconds){
    // update all the particles
    for(int i = 0; i < particles.size(); i++){
      cParticle particle = (cParticle)particles.get(i);
      particle.update(deltaTimeInSeconds);
    }
  }
  
  public void draw(){
    // update all the particles
    for(int i = 0; i < particles.size(); i++){
      cParticle particle = (cParticle)particles.get(i);
      if(particle.isAlive()){
        particle.draw();
      }
    }
  }
          
  public void emit(float numParticles){
    for(int i = 0; i < particles.size(); i++){
      cParticle particle = (cParticle)particles.get(i);
      particle.setPosition(new PVector(position.x, position.y));
      
      particle.setVelocity(getRandomVector(minVelocityRange, maxVelocityRange));
      //particle.setAcceleration(acceleration);
      
      particle.setLifeTime(getRandomFloat(minLifeTimeRange, maxLifeTimeRange));
    }
  }
          
  public void setParticleLifeTime(float minLifeTime, float maxLifeTime){
    minLifeTimeRange = minLifeTime;
    maxLifeTimeRange = maxLifeTime;
  }
  
  public boolean isDead(){
    
    // if we found at least one particle which is alive, 
    // the system isn't dead.
    for(int i = 0; i < particles.size(); i++){
      cParticle particle = (cParticle)particles.get(i);
      if(particle.isAlive()){
        return false;
      }
    }
    return true;
  }
}
