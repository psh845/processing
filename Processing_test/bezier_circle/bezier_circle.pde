float angle = 90; //Change this value for angle of bezier
float kappa;
float radius =100;
PVector b1, b2, b3, b4;



void setup() {
  size(500, 500);
  kappa = 4 * tan(radians(angle/4))/3; //The equation responsible for the distance between control points.
  //b1= new PVector(0,0+radius);
  //print(b1);
  //b4= new PVector(0+radius,0);
  //print(kappa);
  //b2 = new PVector(b1.x+ radius* kappa,b1.y);
  //print(b2);
  //b3 = new PVector( b4.x, b4.y+radius*kappa);
  //print(b3);

  noLoop();
}

void draw() {
  translate(width/2, height/2);

  noFill();
  for (int i=0; i<4; ++i)
  {
    if (i==0)
    {
      b1= new PVector(0, 0+radius);
      b4= new PVector(0+radius, 0);
      b2 = new PVector(b1.x+ (radius* kappa), b1.y);
      b3 = new PVector( b4.x, b4.y+(radius*kappa));
    } else if (i==1)
    {
      b1= new PVector(b4.x, b4.y);
      b4= new PVector(0, 0-radius);
      b2 = new PVector(b1.x, b1.y-(radius* kappa));
      b3 = new PVector(b4.x+(radius* kappa), b4.y);
    } else if (i==2)
    {
      b1= new PVector(b4.x, b4.y);
      b4= new PVector(0-radius, 0);
      b2 = new PVector(b1.x-(radius* kappa), b1.y);
      b3 = new PVector(b4.x, b4.y-(radius* kappa));
    } else
    {
      b1= new PVector(b4.x, b4.y);
      b4= new PVector(0, 0+radius);
      b2 = new PVector(b1.x, b1.y+(radius* kappa));
      b3 = new PVector(b4.x-(radius* kappa), b4.y);
    }
   
    strokeWeight(2);
    stroke(0);
    bezier(b1.x, b1.y, b2.x, b2.y, b3.x, b3.y, b4.x, b4.y);
    
    stroke(0, 0, 255);
    strokeWeight(4);
    point(b1.x, b1.y);
    point(b2.x, b2.y);
    point(b3.x, b3.y);
    point(b4.x, b4.y);
    print(b1+"," +b2+"," +b3+"," + b4);
  }

  ellipseMode(CENTER);
  strokeWeight(0);
  stroke(255, 0, 0);
  ellipse(0, 0, 200, 200);
}