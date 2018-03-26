// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

Mover[] m = new Mover[10]; 

void setup() {
  size(640,360);
  for(int i=0; i< m.length; i++)
    m[i] = new Mover(random(1,5),0,0); 
}

void draw() {
  background(255);

  
  for(int i=0; i< m.length; i++)
  {
    PVector wind = new PVector(0.01,0);
    
    float ma = m[i].mass;
    PVector gravity = new PVector(0,0.1*ma);
    
    float c =0.01;
    PVector friction = m[i].velocity.get();
    friction.mult(-1);
    friction.normalize();
    friction.mult(c);
    
     m[i].applyForce(friction);
    m[i].applyForce(wind);
    m[i].applyForce(gravity);
  
  
    m[i].update();
    m[i].display();
    m[i].checkEdges();
  }

}