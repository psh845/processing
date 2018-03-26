PVector v1, v2;
int value = 0;


void setup() {
  size(200, 200);
  //noLoop();
  v1 = new PVector(100, 100);
  v2 = new PVector(150, 150);
}


void draw() {


  for (int i =0; i<=width; i++)
  {
    for (int j=0; j<=height; j++)
    {
      float xD1=v2.x - v1.x;
      float yD1=v2.y - v1.y;
      float xD2=i - v1.x;
      float yD2=j - v1.y;
      float len1=sqrt(xD1*xD1+yD1*yD1);
      float len2=sqrt(xD2*xD2+yD2*yD2);
      float dot=(xD2*xD1+yD2*yD1); // dot product
      float deg=acos(dot/(len1*len2));
      
      float bb = cos(deg);
      float degg= degrees(bb);
      //print(deg +"\t");
  
      if ((abs(deg)<=1) && (abs(deg)>=0)) 
      {
        stroke(255);
        stroke(255*(1-abs(deg)));
      }
      else 
        stroke(0);
     
      point(i, j);
    }
  }
}


void mousePressed() 
{


  if (value == 0) 
  {
    v1.x=mouseX;
    v1.y=  mouseY;
    println("v1:"+ v1.x, v1.y);
    value=255;
  } else
  {
    v2.x=mouseX;
    v2.y=  mouseY;
    println("v2:"+v2.x, v2.y);
    value=0;
  }
}