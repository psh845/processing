size(500, 500);
int a=0;
int b=width;
int c=0;
int d=255;

for(int i=0; i<=width; i++)
{
  //stroke(i);
  //line(i,0,i,height);
  float m;
  m= map(i,a,b,c,d);
  m = (float(i)-a)/(b-a)*(d-c)+c;
  println(m);
  //stroke(m);
  stroke(m,0,d-m);
  line(i,0,i,height);

}

//for(int i=width; i>=0; i--)
//{
//  float m;
//   m= map(i,a,b,c,d);
//   m = (float(i)-a)/(b-a)*(d-c)+c;
//   stroke(m);
//   println(m);
//   rect(0,0,i,i);
   
//}