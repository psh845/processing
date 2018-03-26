float angle = 90; //Change this value for angle of bezier
float kappa;
float rad =150;
PVector b1, b2, b3, b4;
int numSegments = 3; 
int num = 16;
PVector  p1, p2, p3, p4, pt, p0, pp, p00;
PVector []p = new PVector[4];
PVector [][]CP = new PVector[4][16];

PVector []verP = new PVector[4];
PVector []ver;
PVector []hull;


int tt=0;
int uu=0;
int cc=0;
int yy=0;

void setup() {
  size(500, 500, P3D);
  kappa = 4 * tan(radians(angle/4))/3; //The equation responsible for the distance between control points.
  //b1= new PVector(0,0+radius);
  //print(b1);
  //b4= new PVector(0+radius,0);
  //print(kappa);
  //b2 = new PVector(b1.x+ radius* kappa,b1.y);
  //print(b2);
  //b3 = new PVector( b4.x, b4.y+radius*kappa);
  //print(b3);

  pt = new PVector();
  p0 = new PVector();
  pp = new PVector();
  p00 = new PVector();

  ver = new PVector[(numSegments+1)*((numSegments+1)*4)];
  hull = new PVector[num*4];
  
  for (int i=0; i<4; ++i)
  {
    p[i] = new PVector();
    verP[i] = new PVector();
  }
  noLoop();
}

void draw()
{
 
  pushMatrix();
  translate(width/2, height/2, 0);
  rotateX(70);
  noFill();
  Reset();
  CirCleCP(rad,0,0,0);
  CirCleCP(rad,0,50,0);
  CirCleCP(rad,0,100,0);
  CirCleCP(rad,0,150,0);
  CircleBezier(numSegments);
  faceConnect(numSegments);
  CircleHull(num);
  popMatrix();


  pushMatrix();
  translate(width/2, height/2, 0);
  rotateX(70);
  noFill();
  Reset();
  CirCleCP(rad/2,0,0,0);
  CirCleCP(rad/2,0,50,0);
  CirCleCP(rad/2,0,100,0);
  CirCleCP(rad/2,0,150,0);
  CircleBezier(numSegments);
  faceConnect(numSegments);
  CircleHull(num);
  popMatrix();

}

void Reset()
{
 tt=0;
 uu=0;
 cc=0;
 yy=0;
 
  pt = new PVector();
  p0 = new PVector();
  pp = new PVector();
  p00 = new PVector();

  for (int i=0; i<4; ++i)
  {
    p[i] = new PVector();
    verP[i] = new PVector();
  }
 
}

void CirCleCP(float radius, float xup, float yup, float zup)
{

  for (int i=0; i<4; ++i)
  {

    if (i%4==0)
    {
      b1= new PVector(xup, yup, zup+radius);
      b4= new PVector(xup+radius, yup, zup);
      b2 = new PVector(b1.x+ (radius* kappa), b1.y, b1.z);
      b3 = new PVector( b4.x, b4.y, b4.z+(radius*kappa));

      CP[0][tt++] = new PVector(b1.x, b1.y, b1.z);
      CP[0][tt++] = new PVector(b2.x, b2.y, b2.z);
      CP[0][tt++] = new PVector(b3.x, b3.y, b3.z);
      CP[0][tt++] = new PVector(b4.x, b4.y, b4.z);
    } else if (i%4==1)
    {
      b1= new PVector(b4.x, b4.y, b4.z);
      b4= new PVector(xup, yup, zup-radius);
      b2 = new PVector(b1.x, b1.y, b1.z-(radius* kappa));
      b3 = new PVector(b4.x+(radius* kappa), b4.y, b4.z);

      CP[1][uu++] = new PVector(b1.x, b1.y, b1.z);
      CP[1][uu++] = new PVector(b2.x, b2.y, b2.z);
      CP[1][uu++] = new PVector(b3.x, b3.y, b3.z);
      CP[1][uu++] = new PVector(b4.x, b4.y, b4.z);
    } else if (i%4==2)
    {
      b1= new PVector(b4.x, b4.y, b4.z);
      b4= new PVector(xup-radius, yup, zup);
      b2 = new PVector(b1.x-(radius* kappa), b1.y, b1.z);
      b3 = new PVector(b4.x, b4.y, b4.z-(radius* kappa));

      CP[2][cc++] = new PVector(b1.x, b1.y, b1.z);
      CP[2][cc++] = new PVector(b2.x, b2.y, b2.z);
      CP[2][cc++] = new PVector(b3.x, b3.y, b3.z);
      CP[2][cc++] = new PVector(b4.x, b4.y, b4.z);
    } else if (i%4==3)
    {
      b1= new PVector(b4.x, b4.y, b4.z);
      b4= new PVector(xup, yup, zup+radius);
      b2 = new PVector(b1.x, b1.y, b1.z+(radius* kappa));
      b3 = new PVector(b4.x-(radius* kappa), b4.y, b4.z);

      CP[3][yy++] = new PVector(b1.x, b1.y, b1.z);
      CP[3][yy++] = new PVector(b2.x, b2.y, b2.z);
      CP[3][yy++] = new PVector(b3.x, b3.y, b3.z);
      CP[3][yy++] = new PVector(b4.x, b4.y, b4.z);

      yup+=50;
    }
    print(i+"\t"+tt+uu+cc+yy+"\n");


    strokeWeight(2);
    stroke(0);
    bezier(b1.x, b1.y, b1.z, b2.x, b2.y, b2.z, b3.x, b3.y, b3.z, b4.x, b4.y, b4.z);

    stroke(0, 0, 255);
    strokeWeight(4);
    point(b1.x, b1.y, b1.z);
    point(b2.x, b2.y, b2.z);
    point(b3.x, b3.y, b3.z);
    point(b4.x, b4.y, b4.z);
    print(b1+"," +b2+"," +b3+"," + b4+"\n");
  }
}

void CircleHull(int numSegments)
{
  int count=0;
   PShape s;  
  
   for(int i=0; i<4; ++i)
   {
      for(int j=0; j<4; ++j)
      {
        hull[count++] = new PVector(CP[j][i*4].x,CP[j][i*4].y,CP[j][i*4].z);
        hull[count++] = new PVector(CP[j][i*4+1].x,CP[j][i*4+1].y,CP[j][i*4+1].z);
        hull[count++] = new PVector(CP[j][i*4+2].x,CP[j][i*4+2].y,CP[j][i*4+2].z);
        hull[count++] = new PVector(CP[j][i*4+3].x,CP[j][i*4+3].y,CP[j][i*4+3].z);
      }
       print("count:"+count+"\n");
   }
   
  
  for (int i=0; i< 3; ++i) 
  {
    for (int j=0; j<numSegments-1; ++j) 
    {
      int a = (numSegments)*i+j;
      int b = (numSegments)*(i+1)+j;
      int c = (numSegments)*(i+1)+j+1;
      int d = (numSegments)*i+j+1;
      print("row:"+a+","+b+","+c+","+d+"\n");

      verP[0].set(hull[a]);
      verP[1].set(hull[b]);
      verP[2].set(hull[c]);
      verP[3].set(hull[d]);
      
      print("row:"+verP[0]+","+verP[1]+","+verP[2]+","+verP[3]+"\n");
      
      fill(255, 255, 255,100);
      s = createShape();
      beginShape();
      //fill(random(255), random(255), random(255));
      noStroke();
      vertex(verP[0].x, verP[0].y, verP[0].z);
      vertex(verP[1].x, verP[1].y, verP[1].z);
      vertex(verP[2].x, verP[2].y, verP[2].z);
      vertex(verP[3].x, verP[3].y, verP[3].z);
      endShape(CLOSE);
    }
    
  }
  
}

void CircleBezier(int numSegments)
{
  int count=0;
  //set the control points for the current patch   

  for (int j=0, y=0; j<= numSegments; ++j) 
  {
    //float t = j / (float)numSegments; 
    //pt.set(evalBezierCurve(p,t));
    //point(pt.x,pt.y,pt.z);
    //if(count>0 )
    //  line(p0.x,p0.y,p0.z,pt.x,pt.y,pt.z);
    //p0.set(pt);
    //count++;
    for (int z=0; z<4; z++)
    {
      count=0;
      float v = j / (float)numSegments; 
      for (int k=0; k<= numSegments; ++k, ++y) 
      {
        ver[y]=new PVector();
        float u = k / (float)numSegments; 
        print(k+":"+j+"\n");
        print(u+":"+v+"\n");

        pt.set(evalBezierPatch(CP, z, u, v));
        pp.set(evalBezierPatch(CP, z, v, u));

        print("y:"+y+"\n");
        ver[y].set(pt);
        point(pt.x, pt.y, pt.z);
        print(pt+"\n");
        print(pp+"\n");
        if (count>0 ) {
         //  line(p0.x, p0.y, p0.z, pt.x, pt.y, pt.z);
         //  line(p00.x, p00.y, p00.z, pp.x, pp.y, pp.z);
        }
        p0.set(pt);
        p00.set(pp);
        count++;
      }
    }
  }
  
}

void faceConnect(int numSegments)
{
  
  PShape s;  
  for (int i=0, y=0; i< numSegments; ++i) 
  {
    for (int j=0; j< (numSegments+1)*4-1; ++j, ++y) 
    {
      int a = (numSegments+1)*4*i+j;
      int b = (numSegments+1)*4*(i+1)+j;
      int c = (numSegments+1)*4*(i+1)+j+1;
      int d = (numSegments+1)*4*i+j+1;
      print("row:"+a+","+b+","+c+","+d+"\n");

      verP[0].set(ver[a]);
      verP[1].set(ver[b]);
      verP[2].set(ver[c]);
      verP[3].set(ver[d]);
      
      print("row:"+verP[0]+","+verP[1]+","+verP[2]+","+verP[3]+"\n");
      
      //fill(0, 0, 0,100);
      s = createShape();
      beginShape();
      fill(random(255), random(255), random(255));
      noStroke();
      vertex(verP[0].x, verP[0].y, verP[0].z);
      vertex(verP[1].x, verP[1].y, verP[1].z);
      vertex(verP[2].x, verP[2].y, verP[2].z);
      vertex(verP[3].x, verP[3].y, verP[3].z);
      endShape(CLOSE);
    }
  }
}

PVector evalBezierCurve(PVector[] P, float t) 
{ 
  PVector pt = new PVector();
  float b0 = (1 - t) * (1 - t) * (1 - t); 
  float b1 = 3 * t * (1 - t) * (1 - t); 
  float b2 = 3 * t * t * (1 - t); 
  float b3 = t * t * t; 
  pt.x = P[0].x * b0 + P[1].x * b1 + P[2].x * b2 + P[3].x * b3; 
  pt.y = P[0].y * b0 + P[1].y * b1 + P[2].y * b2 + P[3].y * b3; 
  pt.z = P[0].z * b0 + P[1].z * b1 + P[2].z * b2 + P[3].z * b3; 
  //print(pt);
  return pt;
} 

PVector evalBezierPatch(PVector [][]controlPoints, int k, float u, float v) 
{ 
  PVector []uCurve = new PVector[4]; 

  for (int i=0; i<4; i++)
  {
    p[0].set(controlPoints[k][i*4]); 
    p[1].set(controlPoints[k][i*4+1]); 
    p[2].set(controlPoints[k][i*4+2]); 
    p[3].set(controlPoints[k][i*4+3]); 
    uCurve[i] = evalBezierCurve(p, u);
    print("uCurve" + uCurve[i]+"\n");
  }
  return evalBezierCurve(uCurve, v);
} 