

void setup() {

  size(400, 400);


  //float arrowx = cos(aa);
  //float arrowy= sin(aa);
  //print(arrowx);
  //println(arrowy);

  //noLoop(); 
}

void draw() {

  int x1=0;
  int y1=0;
  int x2=300;
  int y2=100;
  int a=0;
  int b=width;
  int c=0;
  int d=255;
  float aa = atan2((y2-y1),(x2-x1));
  float aaa =degrees(aa);
  //println(aaa);
   background(c);
  for (float i=x1; i<=x2+width*1.2; i+=aa)
  {
 
    pushMatrix();
    translate(width/2, height/2); 
    rotate(aa);
    translate(-width/2, -height/2); 
    float m;
    //m= map(i, a, b, c, d);
    m= map(i, x1, x2, c, d);
    strokeWeight(aa*3);
    stroke(m);
    
    
    line(i, 0-height/2*aa, i, height+height/2*aa);
    popMatrix();
  }
  
  resetMatrix();
  
}