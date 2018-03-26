
int x1, y1, x2, y2, x3, y3, x4, y4, t; 
int xa,ya,xb,yb,xc,yc,xd,yd,xe,ye,xf,yf,xz,yz,x,y,xC,yC;

  


void setup() { 


  size(200,200); 
  t = 0; 
  x1 = 10; 
  y1 = 180; 
  x2 = 10; 
  y2 = 5; 
  x3 = 180; 
  y3 = 5; 
  x4 = 180;
  y4= 180;
 
  
  noFill(); 

} 


void draw() { 
  
 stroke(255.0, 0.0, 0.0); 


  strokeWeight(5.0); 

  
    xa = getPt( x1 , x2 );
    ya = getPt( y1 , y2 );
    xb = getPt( x2 , x3);
    yb = getPt( y2 , y3 );
    xC = getPt( x3, x4);
    yC = getPt( y3,y4);
    xz = getPt (xa,xb);
    yz = getPt(ya,yb);
   

   point(x1,y1);
   point(x2,y2);
   point(x3,y3);
   point(x4,y4);
   point(xa,ya);
   point(xb,yb);
   point(xC,yC);
    point(xz,yz);
  

}

int getPt( int n1 , int n2 )
{
    int diff = n1 + (n2 - n1)/2;

    return int(diff);
} 
