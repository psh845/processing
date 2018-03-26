size(1000,400);

smooth();
strokeWeight(1);

color c1 = color(255,255,0);
color c2 = color(0,255,255);

float a = (red(c1)-red(c2))/float(width-1);
float b = (green(c1)-green(c2))/float(width-1);
float c = (blue(c1)-blue(c2))/float(width);
float d = (height-1)/10;
float v = float(1)/float(height-1);


print(a,b,c,d,v+"\n");


for(int i=0; i<width; i++)
{
   
   float t = red(c1)-i*a;
   float r= green(c1)-i*b;
   float e= blue(c1)-i*c;
   
   float w = 1.0;
   /*
   float t = red(c2)-i*a;
   float r= green(c2)-i*b;
   float e= blue(c2)-i*c;
   */
   
   //print(t,r,e+"\n");
   for(int j=0; j<height; j++)
   {
      float u = w-(j*v);  //bezier
      print(j,u+"\n");
      /*
     if(j!=0 && j%d == 0)  //linear
     {
       w -= 0.1;
       //print(j,w+"\n");
     }
     */
     stroke(t*u,r*u,e*u);
     point(i,j);
     
     
   }
     
}



