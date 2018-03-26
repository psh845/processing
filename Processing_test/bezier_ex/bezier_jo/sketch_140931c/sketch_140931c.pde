PVector [] P = {  


  new PVector( 50, 350 ), 


  new PVector(100, 60 ), 


  new PVector( 300, 60 ), 


  new PVector( 350, 350 ) 


};


PVector [] midpoint = new PVector[6];
PVector [] mPoint = new PVector[8];
PVector [] divPoint = new PVector[4];
PVector [] divPoint2 = new PVector[4];
PVector [] tmpPoint = new PVector[16];
PVector [] tmpPoint2 = new PVector[16];

int t= 0;
int count =0;
int count2 =0;
int count3 =0;
void setup() 
{ 

  size(400,400); 
   noFill(); 
  

} 



void draw() 
{ 
  stroke(255.0, 0.0, 0.0); 
  strokeWeight(5.0);
 PVector [] Q = new PVector [P.length];
  
  //P point 
  for(int i=0; i<Q.length; i++)
  {
    point(P[i].x,P[i].y);
  }
  stroke(0.0, 0.0, 0.0); 
  strokeWeight(1.0);
  for(int j=0; j<3; j++)
  {
     line(P[j].x,P[j].y,P[j+1].x,P[j+1].y);
  }
  
//    midpoint(P);
//    midpointLinePoint(midpoint);
//    P7toP8(P,midpoint);

 
  if(t<3)
  {
   BezierbyMid(P,2);
   t++;
  }
}

void midpoint(PVector [] n)
{
   for(int z=0; z<6; z++)
   {
      midpoint[z] = new PVector(0,0);
   }
   int cot =0;
   for(int i=0; i<3; i++)
   {
       midpoint[cot].x =  n[i].x +(n[i+1].x-n[i].x)/2;
       midpoint[cot].y =  n[i].y +(n[i+1].y-n[i].y)/2;
       cot++;
   }
   
   for(int j=0; j<2; j++)
   {
       midpoint[cot].x  = midpoint[j].x+(midpoint[j+1].x-midpoint[j].x)/2;
       midpoint[cot].y = midpoint[j].y+(midpoint[j+1].y-midpoint[j].y)/2;
       cot++;
   }
   
    midpoint[cot].x = midpoint[cot-2].x + (midpoint[cot-1].x- midpoint[cot-2].x)/2; 
    midpoint[cot].y = midpoint[cot-2].y + (midpoint[cot-1].y- midpoint[cot-2].y)/2; 
   
}


void midpointLinePoint(PVector [] n)
{
  
   stroke(0.0, 0.0,255.0); 
   strokeWeight(5.0);
   for(int i=0; i<n.length; i++)
   {
      point(n[i].x,n[i].y);   
   }
   
   stroke(0.0, 255.0,0.0); 
   strokeWeight(1.0);
   for(int j=0; j<3; j++)
   {
     if(j ==2)
     {
       line(n[j+1].x,n[j+1].y,n[j+2].x,n[j+2].y); 
     }
     else
     {
       line(n[j].x,n[j].y,n[j+1].x,n[j+1].y); 
     }
   }
}

void P7toP8(PVector [] n1, PVector [] n2)
{
  for(int z=0; z<8; z++)
   {
      mPoint[z] = new PVector(0,0);
   }
   
   mPoint[0] = n1[0];
   mPoint[7]= n1[3];
   
   mPoint[1] = n2[0];
   mPoint[2] = n2[3];
   mPoint[3] = n2[5];
   mPoint[4] = n2[5];
   mPoint[5] = n2[4];
   mPoint[6] = n2[2]; 
   
//   stroke(0.0, 255.0,255.0); 
//   strokeWeight(2.0);
//   for(int i=0; i<7; i++)
//   {
//     line(mPoint[i].x,mPoint[i].y,mPoint[i+1].x,mPoint[i+1].y);
//   }
//   
}

void P8draw(PVector [] n)
{

   count2 =0;
  
  for(int y=0; y<16; y++)
   {
      tmpPoint[y] = new PVector(0,0);
   }
  for(int i=0; i<8; i++)
  {
    tmpPoint[count2] = n[i];
    count2++;
    print(tmpPoint[i].x +","+tmpPoint[i].y + "\n");
  }
  stroke(0.0, 255.0,255.0); 
  strokeWeight(2.0);
   for(int i=0; i<7; i++)
   {
     line(tmpPoint[i].x,tmpPoint[i].y,tmpPoint[i+1].x,tmpPoint[i+1].y);
   }
   
}


void BezierbyMid(PVector [] n, int n1)
{
      
     count =0;
     count2 =0;
     count3 =0;
      
       midpoint(P);
       midpointLinePoint(midpoint);
       P7toP8(P,midpoint);
       P8draw(mPoint);
       
       
      for(int i=1; i<4; i++)
      {
       
        BezierbyOuput(tmpPoint, n1);
      }
       
      
 
}

void BezierbyOuput(PVector [] n,int n1)
{
 
  int cot = count2;
   count =0;

     for(int j=0; j<16; j++)
         {
           tmpPoint2[j] = tmpPoint[j];
         }

  for(int z=0; z<4; z++)
   {
      divPoint[z] = new PVector(0,0);
   }
   
     for(int z=0; z<4; z++)
   {
      divPoint2[z] = new PVector(0,0);
   }

  for(int j=0; j<4; j++)
  {
     for(int i=0; i<4; i++)
     {
       
        print(count+"\n");
        
        divPoint[i]= tmpPoint2[count];
        //print(divPoint[i].x +","+divPoint[i].y + "\n");

        count++;
   
     }
      midpoint(divPoint);
      midpointLinePoint(midpoint);
      P7toP8(divPoint,midpoint);
      P8draw(mPoint);
  }
 
}



