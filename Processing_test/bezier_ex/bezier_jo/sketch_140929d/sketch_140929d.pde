
int tt=0;
int a = 0;
int b = 0;
int cou =0;
int cou2=0;
PVector [] P = {  


  new PVector( 50, 350 ), 


  new PVector(100, 60 ), 


  new PVector( 300, 60 ), 


  new PVector( 350, 350 ) 


}; 


PVector [] empty = new PVector[8];
PVector [] t = new PVector[8];
PVector [] div = new PVector[16];
void setup() 


{ 

  size(400,400); 
   noFill(); 
  
   for(int z=0; z<8; z++)
   {
    t[z] = new PVector(0,0);
   }
   for(int x=0; x<8; x++)
   {
     empty[x] = new PVector(0,0);
   }

   for(int y=0; y<16; y++)
   {
     div[y] = new PVector(0,0);
   }
} 


  


void draw() 
{ 
  stroke(255.0, 0.0, 0.0); 
  strokeWeight(5.0); 
  PVector [] Q = new PVector [P.length];
  for(int i=0; i<Q.length; i++)
  {
    point(P[i].x,P[i].y);
  }

   
  if(tt<2)
  {

    if(tt==0)
     getPt(P);
    else
    {
      getPt(div);
    }
     tt++;
  }
  
  for(int i=0; i<15; i++)
  {
    stroke(0.0, 0.0, 255.0); 
    point(div[i].x,div[i].y); 
    line(div[i].x,div[i].y,div[i+1].x,div[i+1].y);
  }
} 






void getPt( PVector [] n1)
{
   cou =0;
   int count = 0;
   int jug = 0;
   if(tt<1)
   {
      PVector [] Q = new PVector [n1.length];
      jug = Q.length;
   }
   else
   {
     print("!!!! "+cou2+" !!!!\n");
     jug = cou2;
   }

   print("!!!! "+jug+" !!!!\n");
   for(int z=0; z<jug/4; z++)
   {
    
     a=0; 
     print(jug/4);
    
      
     if(count == 4)
     {
       count = 0;
     }
     
     if(count ==0);
     {
       
       t[a]= n1[count+(z*4)];
       count++;
       print("\n"+ t[a]);
     }
     for(int i=0; i<3; i++)
     {
       a++;
       t[a].x= n1[i+(z*4)].x +(n1[(i+1)+(z*4)].x-n1[i+(z*4)].x)/2;
       t[a].y= n1[i+(z*4)].y +(n1[(i+1)+(z*4)].y-n1[i+(z*4)].y)/2;
       print("\n"+ t[a]);
     }
     count++;
     for(int j=1; j<3; j++)
     {
       a++;
       t[a].x = t[j].x+(t[j+1].x-t[j].x)/2;
       t[a].y = t[j].y+(t[j+1].y-t[j].y)/2;
       print("\n"+ t[a]);
     }
     a++;
     //print("\n"+a);
     t[a].x = t[a-2].x + (t[a-1].x-t[a-2].x)/2; 
     t[a].y = t[a-2].y + (t[a-1].y-t[a-2].y)/2;
     print("\n"+ t[a]);
     a++;
     count++;
     if(count == 3)
     {
       t[a] = n1[count+(z*4)];  
       print("\n"+ t[a]);
     }
     
//     for(int k=0; k<7; k++)
//     {
//       if(b<)
//      {
//       empty[b] = t[c[k]];
//       b++;
//       print(empty[b].x + "\n" + empty[b].y);
//      }
//      
//     }

   
     getPt2(t);
    count++;
   }
} 


void getPt2( PVector [] n)
{
 
  int [] c = {0,1,4,6,5,3,7};
  empty[b] = n[0];
  empty[b+1] = n[1];
  empty[b+2] = n[4];
  empty[b+3] = n[6];
  empty[b+4] = n[5];
  empty[b+5] = n[3];
  empty[b+6] = n[7];  
  
  for(int i=0; i<8; i++)
  {
    if(i>=4)
    {  
      div[cou] = empty[i-1];
      
    }
    else
    {
      div[cou] = empty[i];
     
    } 
    cou++;
    print("\n"+cou+ "\n");
  }
   
   cou2 = cou; 
  
}

