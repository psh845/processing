int x1=0;
  int y1=0;
  int x2 =100;
  int y2 =100;
  
  int value = 0;

void setup() {

  size(400, 400);


  //float arrowx = cos(aa);
  //float arrowy= sin(aa);
  //print(arrowx);
  //println(arrowy);

  //noLoop(); 
}

void draw() {
 background(0);
  
  int a=0;
  int b=width;
  int c=0;
  int d=255;
  float aa = atan2(abs(y2-y1), abs(x2-x1));
  float bb= abs((y2-y1)/(x2-x1));
  //println(aa);
  float aaa =degrees(aa);
  //println(aaa);
  
  if(x1<x2)
  {
  for (float i=x1; i<=x2+width/2; i+=aa)
  {
    
    pushMatrix();
    translate(width/2, height/2); 
    rotate(aa);
    translate(-width/2, -height/2); 
    float m;
    //m= map(i, a, b, c, d);
    m= map(i, x1, x2, c, d);
    strokeWeight(abs(bb+aa));
    stroke(m);
    
    //line(i+arrowx*width/2,0-arrowy*height/2,i-arrowx*width/2,height+arrowy*height/2);
    //line(i-width/2,0-height,i-width/2, height+height/2);
    line(i, 0-height/2*aa, i, height+height/2*aa);
    popMatrix();
  }
  resetMatrix();
  }
  else
  {
    for (float i=x2; i<=x1+width/2; i+=aa)
  {
    
    pushMatrix();
    translate(width/2, height/2); 
    rotate(-aa);
    translate(-width/2, -height/2); 
    float m;
    //m= map(i, a, b, c, d);
    m= map(i, x2, x1, c, d);
    strokeWeight(abs(bb+aa));
    stroke(m);
    
    //line(i+arrowx*width/2,0-arrowy*height/2,i-arrowx*width/2,height+arrowy*height/2);
    //line(i-width/2,0-height,i-width/2, height+height/2);
    line(i, 0-height/2*aa, i, height+height/2*aa);
    popMatrix();
  }
  resetMatrix();
  }
  
 
}

void mousePressed() 
{
  println(value);
  if (value == 0) 
  {
   
    value=255;
    
     x1 = mouseX;
    y1 = mouseY;
    println(x1,y1);
  } 
  else
  {
    
     value=0;
     
     x2 = mouseX;
    y2 = mouseY;
    println(x2,y2);
  }
 
}