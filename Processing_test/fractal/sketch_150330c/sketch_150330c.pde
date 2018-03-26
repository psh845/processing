void setup() 
{ 
  //size(400,600); 
  size(640,360); 
  smooth(); 

} 

void draw()
{
  
   background(255);
  drawCircle(width/2,height/2,200);
  //cantor(10, 20, width-20);
}


int factorial(int n) 
{
  int f = 1;

  for (int i = 0; i < n; i++) {
    f = f * (i+1);
  }



  return f;
}


int factorial2(int n) 
{
  if (n == 1) {
    return 1;
  } else {
    return n * factorial(n-1);
  }
}


void drawCircle(int x, int y, float radius) 
{
  stroke(0);
  noFill();
  ellipse(x, y, radius, radius);
//  if(radius > 2) 
//  {
//    radius *= 0.75f;
//    drawCircle(x, y, radius);
//  }
  if(radius > 12) 
  {
    drawCircle(x + int(radius/2), y, radius/2);
    drawCircle(x - int(radius/2), y, radius/2);
    drawCircle(x, y + int(radius/2), radius/2);
    drawCircle(x, y - int(radius/2), radius/2);

  }

}

void cantor(float x, float y, float len) {
  // Stop at 1 pixel!
  if (len >= 1) {
    line(x,y,x+len,y);
    y += 20;
    cantor(x,y,len/3);
    cantor(x+len*2/3,y,len/3);
  }
}
