PVector v1, v2; //<>// //<>//
int value = 0;

void setup() {
  size(400, 400);
  //noLoop();
  v1 = new PVector(300, 300);
  v2 = new PVector(350, 350);
}


void draw() {
  int dev = 0;
  if (v1.x>v2.x && v1.y<v2.y)
    dev = 1;
  else if (v1.x<v2.x && v1.y>v2.y)
    dev = 1;
  else 
  dev = 0;

  //print(dev);
   float dd=0;

  for (float i =0; i<=width; i++)
  {
    for (float j=0; j<=height; j++)
    {
      float a = sqrt((v1.x*i)+(v1.y*j));
      float b= sqrt((v1.x*v2.x)+(v1.y*v2.y));
      //float c = sqrt((v2.x*i)+(v2.y*j));
      //print(a+ "\t"+ b+ "\t" + c + "\t");
     
      if (dev == 0)
      {
        if (v1.x <= v2.x)
        {
          if (a<b) {
            dd= a/b; //<>//
            print(dd+ "\t");
            stroke(255*(a/b)); //<>//
          } else 
          {
            stroke(255);
          }
        } else
        {
          if (a>b) {
            stroke(255*(b/a));
          } else 
          {
            stroke(255);
          }
        }
        point(i, j);
      } else
      {
        if (v1.x <= v2.x)
        {
          if (a<b) {
            stroke(255*(1-a/b));
          } else 
          {
            stroke(0);
          }
        } else
        {
          if (a>b) {
            stroke(255*(1-b/a));
          } else 
          {
            stroke(0);
          }
        }
        point(width-i, j);
      }
    }
  }
}




//void mousePressed() 
//{
//  if (value == 0) 
//  {
//    v1.x=mouseX;
//    v1.y= mouseY;
//    println("v1:"+v1.x, v1.y);
//    value=255;
//  } else
//  {
//    v2.x=mouseX;
//    v2.y=  mouseY;
//    println("v2:"+v2.x, v2.y);
//    value=0;
//  }
//}