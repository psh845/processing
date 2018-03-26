int WIDTH = 200;
int HEIGHT = 200;
int ENTITIES_COUNT = 200;

class Entity {
  int myX;
  int myY;
  int myMood;
  color myColor;
  
  Entity(){
    myX = int(random( width ));
    myY = int(random( height ));
    myMood = 1;
    myColor = color( random(255),random(255),random(255) );
  }

  void simulate(){
    if( get(myX, myY) != color(0) ){
      myMood=7;
    } 
    else if( myMood > 1) {
      myMood--;
    } 
    else { 
      myMood = 1; 
    }
    strokeWeight( myMood );
    stroke(myColor);
    point( myX, myY );
    myX+=int(random(3)); 
    myX--;
    myY+=int(random(3)); 
    myY--;
  }
}

Entity[] Entities;

void setup() {
  size( WIDTH, HEIGHT ); 
  Entities = new Entity[ENTITIES_COUNT];
  for( int i = 0; i< Entities.length; i++) {
    Entities[i] = new Entity();
  }
}

void draw() {
  background(0); 
  for( int i = 0; i< Entities.length; i++) {
    Entities[i].simulate();
  }
}

