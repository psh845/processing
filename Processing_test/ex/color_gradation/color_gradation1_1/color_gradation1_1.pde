size(1000,255);

color c1 = color(255,255,0);
color c2 = color(0,255,255);

//float a = (red(c1)-red(c2))/float(width);
//float b = (green(c1)-green(c2))/float(width);
//float c = (blue(c1)-blue(c2))/float(width);
//print(a,b,c+"\n");

for(int i=0; i<width; i++)
{
   float x= float(i)/float(width);
   
   float t = (red(c1)-red(c2))*x+red(c2);
   float r= (green(c1)-green(c2))*x+green(c2);
   float e= (blue(c1)-blue(c2))*x+blue(c2);

   /*
   float t = red(c2)-i*a;
   float r= green(c2)-i*b;
   float e= blue(c2)-i*c;
   */
   
  //print(t,r,e+"\n");
  
   stroke(t,r,e);
   line(i,0,i,height);
     
}



