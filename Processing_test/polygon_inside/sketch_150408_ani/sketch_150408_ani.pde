
class Polygonex{
//  private static final String     TAG = Polygon.class.getSimpleName();
     
    private ArrayList<PVector> mVertexs = new ArrayList<PVector>();
     
    public void addPoint(float xPos, float yPos) {
        mVertexs.add(new PVector(xPos, yPos));
        //print(mVertexs);
    }
     
    public void clear() {
        mVertexs.clear();
    }
    
    PVector display(int j) 
    {
   
      return mVertexs.get(j);
    }
     
    public boolean contains(float xPosf, float yPosf) {
        int sizeOfVertexs = mVertexs.size();
         //print("\n"+sizeOfVertexs);
        if (sizeOfVertexs < 3) 
        {
            return false;
        }
         
        int followIndex = sizeOfVertexs - 1;
        //print("\n"+followIndex);
        boolean isOddNodes = false;
 
        for (int frontIndex = 0; frontIndex < sizeOfVertexs; frontIndex++) {
            PVector frontPoint   = mVertexs.get(frontIndex);
            //print("\n"+frontPoint);
            PVector followPoint  = mVertexs.get(followIndex);
            //print("\n"+followPoint);
             
            //if (frontPoint.y < yPosf && followPoint.y >= yPosf || followPoint.y < yPosf && frontPoint.y >= yPosf) 
            //if ((frontPoint.y < yPosf && followPoint.y >= yPosf || followPoint.y < yPosf && frontPoint.y >= yPosf) &&  (frontPoint.x<=xPosf || followPoint.x<=xPosf))
             if ((frontPoint.y < yPosf) == (followPoint.y >= yPosf)  &&  (frontPoint.x<=xPosf || followPoint.x<=xPosf))
            {
                 
              float pp = frontPoint.x + (yPosf - frontPoint.y) / (followPoint.y - frontPoint.y) * (followPoint.x - frontPoint.x);
//                /**
//                 *      y - y1 = M * (x - x1)
//                 *      M = (y2 - y1) / (x2 - x1)
//                 */
//                 
//                 //print(pp);
//                if (pp < xPosf) {
//                    isOddNodes = !isOddNodes;
//                    //print(isOddNodes);
//                }
                  
                  isOddNodes ^= (pp < xPosf);  //^:XOR op1^= op2   op1 = op1 ^ op2
  
            }            
            followIndex = frontIndex;
        }
        return isOddNodes;
    }
    
    
     public boolean contains2(float xPosf, float yPosf) {
        int sizeOfVertexs = mVertexs.size();
     
        if (sizeOfVertexs < 3) 
        {
            return false;
        }
         
        int followIndex = sizeOfVertexs - 1;
    
        boolean isOddNodes = false;
        float[] constant = new float[sizeOfVertexs];
        float[] multiple = new float[sizeOfVertexs];
        PVector frontPoint = new PVector(); 
        PVector followPoint= new PVector(); 
        
        float x1,y1;
        float x2,y2;
 ///////////1
 
        for (int frontIndex = 0; frontIndex < sizeOfVertexs; frontIndex++) 
        {
           frontPoint   = mVertexs.get(frontIndex);
           followPoint  = mVertexs.get(followIndex);
           
           if(frontPoint.x > followPoint.x)
           {
              x1 = followPoint.x;
              x2 = frontPoint.x;
              y1 = followPoint.y;
              y2 = frontPoint.y;
           }
           else
           {
              x1 = frontPoint.x;
              x2 = followPoint.x;
              y1 = frontPoint.y;
              y2 = followPoint.y;
           }
            //if ((frontPoint.x < xPosf) == (xPosf <= followPoint.x) && (yPosf-y1)*(x2-x1) < (y2-y1)*(xPosf-x1))
            if ((frontPoint.x < xPosf) == (xPosf <= followPoint.x)) //&& (frontPoint.y<=yPosf || followPoint.y<=yPosf)
            {
              if((yPosf-y1)*(x2-x1) < (y2-y1)*(xPosf-x1))
                   isOddNodes = !isOddNodes;
            }

           followIndex = frontIndex;
        }
  
        
 ///////////2
 /*
        for (int frontIndex = 0; frontIndex < sizeOfVertexs; frontIndex++)
        {
          frontPoint   = mVertexs.get(frontIndex);
          followPoint  = mVertexs.get(followIndex);
          
          if(followPoint.y==frontPoint.y)
          {
             constant[frontIndex]=frontPoint.x;
             multiple[frontIndex]=0; 
          }
          else 
          {
             constant[frontIndex]=frontPoint.x-(frontPoint.y*followPoint.x)/(followPoint.y-frontPoint.y)+(frontPoint.y*frontPoint.x)/(followPoint.y-frontPoint.y);
             multiple[frontIndex]=(followPoint.x-frontPoint.x)/(followPoint.y-frontPoint.y); 
           }
            followIndex = frontIndex;
         }

         
        for (int frontIndex = 0; frontIndex < sizeOfVertexs; frontIndex++) 
        {
           if ((frontPoint.y < yPosf && followPoint.y >= yPosf || followPoint.y< yPosf && frontPoint.y >= yPosf)) 
            {
//              if((yPosf*multiple[frontIndex]+constant[frontIndex] <xPosf)
//              {
//                 isOddNodes = !isOddNodes;
//              }
              
               float p= yPosf*multiple[frontIndex]+constant[frontIndex];
               isOddNodes^=(p < xPosf); 
            }

           followIndex = frontIndex;
        }
        */
////////////
        return isOddNodes;
    }
}


Polygonex pl;
int i;
float radius1;
float radius2; 
int npoints;
float angle;
float halfAngle;


void setup()
{
    size(300,300);
    i=0;
    pl = new Polygonex();
//    pl.addPoint(100,50);
//    i++;
//    pl.addPoint(100,100);
//    i++;
//    pl.addPoint(200,100);
//    i++;
//    pl.addPoint(200,50);
//    i++;
    
  int k,l;
  k= 150;
  l= 80;
//  if(pl.contains(k,l))
//  {
//    point(k,l);
//  } 
  
  frameRate(30);
/*
  radius1 = 35;
  radius2 = 80; 
  npoints = 20;
  angle = TWO_PI / npoints;
  halfAngle = angle/2.0;
  for (float a = 0+PI/2; a < TWO_PI+PI/2; a += angle) 
  {
    float sx = width/2 + cos(a) * radius2;
    float sy = height/2 - sin(a) * radius2;
    //vertex(sx, sy);
    //point(sx, sy);
    print(sx, sy+"\n");
    pl.addPoint(sx, sy);
    i++;
    sx = width/2 + cos(a+halfAngle) * radius1;
    sy = height/2 - sin(a+halfAngle) * radius1;
    //vertex(sx, sy);
   // point(sx, sy);
    print(sx, sy+"\n");
    pl.addPoint(sx, sy);
    i++;
  }
  
  /*
  for(i=0,ang=90; i < 10; i++,ang+=36) 

   {    

      if (i%2) rad=size*0.38; 

         else rad=size; 

       ptPos[i].x=x+(int)(rad*cos(PI*ang/180.0)); 

      ptPos[i].y=y-(int)(rad*sin(PI*ang/180.0)); 

    } 


*/

}

void draw()
{
 
  background(255);
  
  stroke(0);
  strokeWeight(5);
  pl.clear();
  int z=3;
  if(frameCount<300 && frameCount>=30)
  {
      z = frameCount/10;
  }
  else if(frameCount>=300)
  {
     z=30;
  }
  radius1 = 35;
  radius2 = 80; 
  npoints = z;
  angle = TWO_PI / npoints;
  halfAngle = angle/2.0;

  i=0;
  for (float a = 0+PI/2; a < TWO_PI+PI/2; a += angle) 
  {
    float sx = width/2 + cos(a) * radius2;
    float sy = height/2 - sin(a) * radius2;
    vertex(sx, sy);
    point(sx, sy);
    pl.addPoint(sx, sy);
    i++;
    sx = width/2 + cos(a+halfAngle) * radius1;
    sy = height/2 - sin(a+halfAngle) * radius1;
    vertex(sx, sy);
    point(sx, sy);
    pl.addPoint(sx, sy);
    i++;
  }
  
  for(int j=0; j<i;j++)
  {
      stroke(0);
      strokeWeight(1);
     if(j==i-1)
        line(pl.display(j).x,pl.display(j).y,pl.display(0).x,pl.display(0).y);
      else
     {
       //point(pl.display(j).x,pl.display(j).y);
       line(pl.display(j).x,pl.display(j).y,pl.display(j+1).x,pl.display(j+1).y);
       
     }
 }
  
  for(int k=0; k<=width; k++)
  {
    for(int l=0; l<=width; l++)
    {
      //if(pl.contains(k,l)){
      if(pl.contains2(k,l)){
          stroke(255,0,0);
          strokeWeight(0.5);
          point(k,l);
      } 
    }
  }
  
    pl.clear();
   saveFrame(); 
}



