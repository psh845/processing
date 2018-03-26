


int x1 = 50;
int y1 = 350;
int x2 = 100;
int y2 = 60;
int x3 = 300;
int y3 = 60;
int x4 = 350;
int y4 = 350;



void setup() 
{ 

  size(400,400); 
  noFill(); 
  

} 



void draw() 
{ 
  stroke(255.0, 0.0, 0.0); 
  strokeWeight(5.0);

 
 recursive_bezier( x1,  y1, x2,  y2, x3,  y3, x4, y4,0);

 
}



void recursive_bezier( int x1, int y1, 
                      int x2, int y2, 
                      int x3, int y3, 
                      int x4, int y4,
                      int level)
{
    
    int x12   = (x1 + x2) / 2;
    int y12   = (y1 + y2) / 2;
    int x23   = (x2 + x3) / 2;
    int y23   = (y2 + y3) / 2;
    int x34   = (x3 + x4) / 2;
    int y34   = (y3 + y4) / 2;
    int x123  = (x12 + x23) / 2;
    int y123  = (y12 + y23) / 2;
    int x234  = (x23 + x34) / 2;
    int y234  = (y23 + y34) / 2;
    int x1234 = (x123 + x234) / 2;
    int y1234 = (y123 + y234) / 2; 
    
    
     stroke(0.0, 0.0, 255.0); 
    strokeWeight(5.0);
     point(x1,y1);
     point(x2,y2);
     point(x3,y3);
     point(x4,y4);
     
    stroke(0.0, 0.0, 0.0); 
    strokeWeight(1.0);
     line(x1,y1,x2,y2);
     line(x2,y2,x3,y3);
     line(x3,y3,x4,y4);
     
     float a= random(255);
     float b = random(255);
     float c = random(255);
     
     a= 255.0;
     b= 255.0;
     c= 255.0;
    stroke(a,b,c); 
    strokeWeight(3.0);
    
    line(x1,y1,x12,y12);
    line(x12,y12,x123,y123);
    line(x123,y123,x1234,y1234);
    line(x1234,y1234,x234,y234);
    line(x234,y234,x34,y34);
    line(x34,y34,x4,y4);
   
    if(level>4)
    {
        return;
    }
    else
    {
        recursive_bezier(x1, y1, x12, y12, x123, y123, x1234, y1234,level+1);
        recursive_bezier(x1234, y1234, x234, y234, x34, y34, x4, y4,level+1); 
    }
}
