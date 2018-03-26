
class Polygonex{
//  private static final String     TAG = Polygon.class.getSimpleName();
     
    private ArrayList<PVector> mVertexs = new ArrayList<PVector>();
     
    public void addPoint(float xPos, float yPos) {
        mVertexs.add(new PVector(xPos, yPos));
        print(mVertexs);
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
         print("\n"+sizeOfVertexs);
        if (sizeOfVertexs < 3) {
            return false;
        }
         
        int followIndex = sizeOfVertexs - 1;
        print("\n"+followIndex);
        boolean isOddNodes = false;
 
        /**
   
         */
        for (int frontIndex = 0; frontIndex < sizeOfVertexs; frontIndex++) {
            PVector frontPoint   = mVertexs.get(frontIndex);
            print("\n"+frontPoint);
            PVector followPoint  = mVertexs.get(followIndex);
            print("\n"+followPoint);
             
            if (frontPoint.y < yPosf && followPoint.y >= yPosf 
                || followPoint.y < yPosf && frontPoint.y >= yPosf) {
                 
                /**
                 *      y - y1 = M * (x - x1)
                 *      M = (y2 - y1) / (x2 - x1)
                 */
                 float pp = frontPoint.x + (yPosf - frontPoint.y) / (followPoint.y - frontPoint.y) * (followPoint.x - frontPoint.x);
                 print(pp);
                if (pp < xPosf) {
                    isOddNodes = !isOddNodes;
                    print(isOddNodes);
                }
                
            }
             
            followIndex = frontIndex;
        }
        
        

        /**
         */

        return isOddNodes;
    }
}


Polygonex pl;
int i;

void setup()
{
    size(300,300);
    i=0;
    pl = new Polygonex();
    pl.addPoint(100,50);
    i++;
    pl.addPoint(150,100);
    i++;
    pl.addPoint(200,50);
    i++;
    
       int a,b;
  a= 150;
  b= 80;
  if(pl.contains(a,b))
  {
    stroke(255,0,0);
    strokeWeight(3);
    point(a,b);
  } 
}

void draw()
{
 
  background(255);
  
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
  



}

