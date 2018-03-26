PVector v1, v2,v3;
  int value = 0;

void setup() {
  size(300,300);
  noLoop();
  v1 = new PVector(0, 0);
  v2 = new PVector(70, 70); 
}


void draw() {
   float xD1=v2.x - v1.x; //vector a.x
   float yD1=v2.y - v1.y; //vector a.y
   float d1Mag=sqrt(xD1*xD1+yD1*yD1); //vector a magnitude
   print(xD1+","+yD1+","+d1Mag+","+ "\n");
  for(int i =0; i<=width; i++)
  {
    for(int j=0; j<=height; j++)
    {
     
      float xD2=i - v1.x;   //vector b.x
      float yD2=j - v1.y;  //vector b.y
     
      float d2Mag=sqrt(xD2*xD2+yD2*yD2);  //vector b magnitude
      //b pojectaMag= |b|cos@ => |b|*(a dot b)/|a||b| => (a dot b) /|a| 
      //b projecta= |b|cos@*a/|a| =>  (a dot b) /|a| * a/|a| => (a dot b)/|a||a| *a 
      float dot=(xD2*xD1+yD2*yD1); // a,b dot product
      float projMag =dot/d1Mag;
    
      float projectx = projMag*(xD1/d1Mag);
      float projecty = projMag*(yD1/d1Mag);
      float projectMag = sqrt(projectx*projectx + projecty*projecty);
      print(projMag+"= "+ i+":"+projectx +","+j+":"+ projecty + "=>"+projectMag+"\t");
      //((a dot b)/|a||a|)*a = (a dot b)/(a dot a) * a
       //linear interpolation
      //map => (c-a)/(b-a):(e-d)/(f-d) => (e-d)= (c-a)/(b-a)*(f-d) => e= (c-a)/(b-a)*(f-d) + d
      float projMap = projMag/d1Mag * 1;
      //print(projMap+ "\t");
      //
      if(projMap<=1 && projMap>= 0)
         stroke(255*projMap);
      else if(projMap <0)
         stroke(0);
      else
         stroke(255);
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
     println("v1:"+v1.x,v1.y);
     value=255;
  }
    else
  {
     v2.x=mouseX;
     v2.y=  mouseY;
     println("v2:"+v2.x,v2.y);
        value=0;
  }
  
}