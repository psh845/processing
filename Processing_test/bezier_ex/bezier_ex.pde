
float x1, y1, x2, y2, x3, y3, x4, y4; 
float xa,ya,xb,yb,x,y;

PVector p,pt; 
PVector pf; 
void setup() { 


  size(200,200); 
  x1 = 10; 
  y1 = 50; 
  x2 = 100; 
  y2 = 200; 
  x3 = 190; 
  y3 = 50; 
  x4 = 180;
  y4 = 100;
  
  p= new PVector();
  pt= new PVector();
  pf= new PVector(x1,y1);
  noFill(); 
  noLoop();

} 


void draw() { 
  

  strokeWeight(1.0); 

  
  for( float t = 0 ; t <= 1.0; t += 0.1 )
{
    xa = getPt( x1 , x2 , t );
    ya = getPt( y1 , y2 , t );
    xb = getPt( x2 , x3 , t );
    yb = getPt( y2 , y3 , t );
    // The Black Dot 
    //Linear
    //x = getPt( xa , xb , t );
    //y = getPt( ya , yb , t );
    //Quadratic
    x = getpt2( x1 , x2, x3 , t );
    y = getpt2( y1 , y2, y3 , t );
    //cubic
   // x = getpt3 (x1,x2,x3,x4,t);
    //y = getpt3 (y1,y2,y3,y4,t);
    
    p.x = 2*(1-t)*(x2-x1)+2*t*(x3-x2);
    p.y = 2*(1-t)*(y2-y1)+2*t*(y3-y2);
    pt.x = 2*(x3-(2*x2) + x1);
    pt.y = 2*(y3-(2*y2) + y1);
    
    float b= atan2(p.y,p.x);
    b +=PI;
    float c = b;
    c -= HALF_PI;
   p.normalize();
   p.mult(50);
   p.add(x,y);
   pt.normalize();
   pt.mult(50);
   pt.add(x,y);
    float a = p.dot(pt);
    print(a+"\t");
    if(pf.x<=x)
    {
        stroke(255.0, 0.0, 0.0); 
    line(pf.x,pf.y,x,y);


     stroke(0.0, 255 ,0.0);
        line(x,y, cos(b)*-50+x,sin(b)*-50+y);
         line(x,y, cos(c)*50+x,sin(c)*50+y);
            stroke(0.0, 0.0, 255.0);
    line(x,y,p.x,p.y);
        stroke(0.0, 255.0, 255.0);
    line(x,y,pt.x,pt.y);
      pf.x=x;
      pf.y=y;
    }
} 

}

float getPt( float n1 , float n2 , float t )
{  //Linear
    float diff = n2 - n1;

   return n1 +  diff * t ;
   //return int((1-perc)*n1 + perc*n2);
} 

float getpt2(float n1 , float n2 , float n3, float t )
{  //Quadratic
    float a;
    a = ((1-t)*(1-t))*n1+2*(1-t)*t*n2+(t*t)*n3;
    //a =int(pow((1-t),2)*n1 + 2*(1-t)*t*n2 + pow(t,2)*n3);
    //a= int( 2*(1-t)*(n2-n1) + 2*t*(n3-n2));
    //a = int(2*(n3 - 2*n2 + n1));
    return a;
}

float getpt3(float n1 , float n2 , float n3, float n4, float t )
{ //cubic
   float a;
    //a = int((1-t)*getpt2(n1,n2,n3,t) + t*getpt2(n2,n3,n4,t));
    a= ((1-t)*(1-t)*(1-t))*n1 + 3*((1-t)*(1-t))*t*n2 + 3*(1-t)*(t*t)*n3 + (t*t*t)*n4;
   return a; 
}