float angle = 90; //Change this value for angle of bezier //<>// //<>// //<>//
float kappa;
float rad =100;
float rad2 = 100;
PVector b1, b2, b3, b4;
int numSegments = 0;  //surface segment
int num = 0; //hull cp
int CPnum =0; //v num
int heigtNum =0;
PVector  p1, p2, p3, p4, pt, p0, pp, p00;
PVector []p = new PVector[4];
PVector []verP = new PVector[4];
PVector []vCube = new PVector[8];

PVector [][]CP;
PVector []ver;
PVector []hull;
PVector [][]hullArray;
PVector []PK;
PVector [][]PK2;
PVector [][]Ver;
PVector [][][]VerCube;

int vv=0;
int tt=0;
int uu=0;
int cc=0;
int yy=0;
int zz=0;

int cou =0;


FloatList curve_x;
FloatList curve_y;
FloatList curve_z;
FloatList curve_radius;
FloatList curve_normal;

PVector ee;
PVector ef;



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


  curve_x = new FloatList();
  curve_y = new FloatList();
  curve_z = new FloatList();
  curve_radius = new FloatList();
  curve_normal = new FloatList();

  curve_x.append(100);
  curve_y.append(height/3);
  curve_z.append(0);
  curve_x.append(200);
  curve_y.append(height/2);
  curve_z.append(0);
  curve_x.append(300);
  curve_y.append(height/2);
  curve_z.append(0);
  curve_x.append(400);
  curve_y.append(height/3);
  curve_z.append(0);
  curve_radius.append(30);

  numSegments = 6;  //surface segment
  num = 13; //circle cp
  CPnum =(curve_x.maxIndex()+1)/4; //v surface number
  print(CPnum+"\n");
  heigtNum =1; //cylinder number


  CP = new PVector[CPnum*4][16];
  hull = new PVector[num*(CPnum*4)];
  hullArray = new PVector[CPnum*4-(CPnum-1)][num];
  PK = new PVector[16];
  PK2 = new PVector[4][4];

  ver = new PVector[(numSegments+1)*(numSegments+1)];
  Ver = new PVector[(numSegments)*CPnum+1][(numSegments)*4+1];
  VerCube = new PVector[heigtNum][(numSegments)*CPnum+1][(numSegments)*4+1];

  for (int i=0; i<4; ++i)
  {
    p[i] = new PVector();
    verP[i] = new PVector();
  }

  for (int i=0; i<8; ++i)
  {
    vCube[i] = new PVector();
  }

  noLoop();
}

void draw()
{

  print(num); //<>//

   curve_normal = new FloatList();
  noFill();

  for(int i=0; i<4; i++)
  {
    float angle =normVec(i); //<>//
    curve_normal.append(angle);
    print("angle"+angle,curve_normal.get(i)+"\n");
  }
  
  //CirCleCP(curve_radius.get(0), curve_x.get(3), curve_y.get(3), curve_z.get(3), CPnum, degrees(90),1);
  PointToCircle(CPnum); //<>//


  if(heigtNum>1)
  SumfaceCube(numSegments);
  else
  SumfaceConnect(numSegments);
}

float normVec(int i)
{
  float ang=0;
  stroke(0);
  bezier(curve_x.get(0), curve_y.get(0), curve_z.get(0), curve_x.get(1), curve_y.get(1), curve_z.get(1), 
    curve_x.get(2), curve_y.get(2), curve_z.get(2), curve_x.get(3), curve_y.get(3), curve_z.get(3));
  float x0 = curve_x.get(0), 
    x1 = curve_x.get(1), 
    x2 = curve_x.get(2), 
    x3 = curve_x.get(3);
  float y0 = curve_y.get(0), 
    y1 = curve_y.get(1), 
    y2 = curve_y.get(2), 
    y3 = curve_y.get(3);
  float z0 = curve_z.get(0), 
    z1 = curve_z.get(1), 
    z2 = curve_z.get(2), 
    z3 = curve_z.get(3);        

    float t=round((float(i)*10/3))*0.1;
    //t= round(float(i)/3);
    float dx = -3*x0*pow((1-t), 2) + 3*x1*(pow((1-t), 2)-(2*t)*(1-t)) + 3*x2*(-pow(t, 2)+(1-t)*(2*t)) + 3*x3*pow(t, 2);
    float dy = -3*y0*pow((1-t), 2) + 3*y1*(pow((1-t), 2)-(2*t)*(1-t)) + 3*y2*(-pow(t, 2)+(1-t)*(2*t)) + 3*y3*pow(t, 2);
    float dz = -3*z0*pow((1-t), 2) + 3*z1*(pow((1-t), 2)-(2*t)*(1-t)) + 3*z2*(-pow(t, 2)+(1-t)*(2*t)) + 3*z3*pow(t, 2);
    float angle = atan(dy/dx);

    PVector p = new PVector(curve_x.get(i), curve_y.get(i), curve_z.get(i));
    PVector u = new PVector(dx, dy, dz);
    PVector v = new PVector(dx, dy, dz);
    
    u.normalize();
    u.add(p);
    
    v.normalize();
    v.add(p);

    print("vec::"+t,degrees(angle),u,p);

    
    float ccc= radians(90);
    float c; 
    float d;
    if(t<0.5){
      c = cos(ccc)*(u.x-p.x)-sin(ccc)*(u.y-p.y)+p.x;
      d = sin(ccc)*(u.x-p.x)+cos(ccc)*(u.y-p.y)+p.y; 
    }
    else{
      c = cos(ccc)*(u.x-p.x)-sin(ccc)*(u.y-p.y)+p.x;
      d = sin(ccc)*(u.x-p.x)+cos(ccc)*(u.y-p.y)+p.y; 
    }
    u.z += p.z;

    ee = new PVector(c, d, u.z);
    ef = new PVector(c, d, u.z);
    
    ee.sub(p);
    ee.normalize();
    u.sub(p);
    
    float ttttt=u.dot(ee);

    print(ttttt,ee,ef);
    PVector ec =new PVector(1, 0, 0);
    ec.normalize();
    print(ec,ee);
   
    PVector b = new PVector();

    b.cross(u, ee,b);
    b.normalize();

    PVector n = new PVector();
    n.cross(ee, b,n);
    n.normalize();
    print(n, b);
    float yy=u.dot(ee);
    float yy2=n.dot(ee);
    float yy3=ee.dot(b);
    float yy4=u.dot(b);
    float yy5=n.dot(b);
    float yyy = ee.dot(ec);
    float yyy2 = u.dot(ec);
    float yyy3 = n.dot(ec);
    float yyy4 = b.dot(ec);
    
    float len = ee.mag()*ec.mag();
    float nor= acos(yyy/len);
    print("\n"+"v:::::::"+len,nor);
    len = u.mag()*ec.mag();
    float nor2= acos(yyy2/len);
    print("\n"+"v:::::::"+len,nor2);
    len = n.mag()*ec.mag();
    float nor3= acos(yyy3/len);
    print("\n"+"v:::::::"+len,nor3);
    
    print("\n"+yy, yy2, yy3, yy4, yy5,yyy,yyy2,yyy3,yyy4); //<>//
    print("\n"+nor,degrees(nor),degrees(nor2),nor2,degrees(nor3),nor3+"\n");

    
    

    n.mult(100);
    n.add(p);
   



    ee.mult(100);
    ee.add(p);

    b.mult(100);
    b.add(p);

    stroke(255, 0, 0);
    //line(u.x, u.y, u.z, p.x, p.y, p.z);
    line(n.x, n.y, n.z, p.x, p.y, p.z);  
     stroke(0, 0, 255);
    line(ee.x, ee.y, ee.z, p.x, p.y, p.z);
  
    stroke(255, 0, 255);
    line(b.x, b.y, b.z, p.x, p.y, p.z);
    
    ang= nor;
    print(ang,degrees(ang),radians(degrees(ang))+"\n");
    return ang;
}

void PointToCircle(int CPnum) //cpnum
{

   int aa=0;
  for (int i=0, k=0; i<CPnum; i++)
  {
    Reset();
    for (int j=0; j<4; j++, k++)
    {
      print(curve_x.get(k), curve_y.get(k), curve_z.get(k)+"\n");

       if(k<2)
         aa = 0;
       else
         aa = 1;
         
      CirCleCP(curve_radius.get(i), curve_x.get(k), curve_y.get(k), curve_z.get(k), CPnum, curve_normal.get(k),aa); //<>//
      // popMatrix();
    }
  }

  CircleHull(num, CPnum);

  circle_hullArray(num, CPnum);

  for (int v=0; v<CPnum; ++v)
  {
    for (int u=0; u<4; ++u)
    {
      //SurfaceCP(1);
      TotalSurfaceCP(u, v);
      CircleBezier(numSegments, u, v);
    }
  }


  cou++;
}



void Reset()
{
  //vv=0;
  tt=0;
  uu=0;
  cc=0; //<>//
  yy=0;
  //zz=0;

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


void CirCleCP(float radius, float xup, float yup, float zup, int Vnum, float ang,int y)
{
  stroke(0,255,0);
  
  for (int i=0; i<4; ++i)
  {
    print("angle::"+degrees(ang)+"\n");
    if (i%4==0)
    {

      b1= new PVector(xup, yup, zup+radius);
      b4= new PVector(xup+radius, yup, zup);
      b2 = new PVector(b1.x+ (radius* kappa), b1.y, b1.z);
      b3 = new PVector( b4.x, b4.y, b4.z+(radius*kappa));
      
      if(y==0){
      b1.x= (b1.x-xup)*cos(ang)+(b1.y-yup)*sin(ang)+xup;
      b1.y= -(b1.x-xup)*sin(ang)+(b1.y-yup)*cos(ang)+yup;


      b2.x= (b2.x-xup)*cos(ang)+(b2.y-yup)*sin(ang)+xup;
      b2.y= -(b2.x-xup)*sin(ang)+(b2.y-yup)*cos(ang)+yup;


      b3.x= (b3.x-xup)*cos(ang)+(b3.y-yup)*sin(ang)+xup;
      b3.y= -(b3.x-xup)*sin(ang)+(b3.y-yup)*cos(ang)+yup;


      b4.x= (b4.x-xup)*cos(ang)+(b4.y-yup)*sin(ang)+xup;
      b4.y= -(b4.x-xup)*sin(ang)+(b4.y-yup)*cos(ang)+yup;
      }
      else{

      b1.x= (b1.x-xup)*cos(ang)-(b1.y-yup)*sin(ang)+xup;
      b1.y= (b1.x-xup)*sin(ang)+(b1.y-yup)*cos(ang)+yup;


      b2.x= (b2.x-xup)*cos(ang)-(b2.y-yup)*sin(ang)+xup;
      b2.y= (b2.x-xup)*sin(ang)+(b2.y-yup)*cos(ang)+yup;


      b3.x= (b3.x-xup)*cos(ang)-(b3.y-yup)*sin(ang)+xup;
      b3.y= (b3.x-xup)*sin(ang)+(b3.y-yup)*cos(ang)+yup;


      b4.x= (b4.x-xup)*cos(ang)-(b4.y-yup)*sin(ang)+xup;
      b4.y= (b4.x-xup)*sin(ang)+(b4.y-yup)*cos(ang)+yup;
      }
  
   print(b1,b2,b3,b4);
      CP[0+(Vnum-1)*4][tt++] = new PVector(b1.x, b1.y, b1.z);
      CP[0+(Vnum-1)*4][tt++] = new PVector(b2.x, b2.y, b2.z);
      CP[0+(Vnum-1)*4][tt++] = new PVector(b3.x, b3.y, b3.z);
      CP[0+(Vnum-1)*4][tt++] = new PVector(b4.x, b4.y, b4.z);
      
      stroke(0,0,0);
      strokeWeight(5);
      point(b4.x,b4.y,b4.z);
      
      
    } else if (i%4==1)
    {
      b1= new PVector(xup+radius, yup, zup);
      b4= new PVector(xup, yup, zup-radius);
      b2 = new PVector(b1.x, b1.y, b1.z-(radius* kappa));
      b3 = new PVector(b4.x+(radius* kappa), b4.y, b4.z);

     if(y==0){
      b1.x= (b1.x-xup)*cos(ang)+(b1.y-yup)*sin(ang)+xup;
      b1.y= -(b1.x-xup)*sin(ang)+(b1.y-yup)*cos(ang)+yup;


      b2.x= (b2.x-xup)*cos(ang)+(b2.y-yup)*sin(ang)+xup;
      b2.y= -(b2.x-xup)*sin(ang)+(b2.y-yup)*cos(ang)+yup;


      b3.x= (b3.x-xup)*cos(ang)+(b3.y-yup)*sin(ang)+xup;
      b3.y= -(b3.x-xup)*sin(ang)+(b3.y-yup)*cos(ang)+yup;


      b4.x= (b4.x-xup)*cos(ang)+(b4.y-yup)*sin(ang)+xup;
      b4.y= -(b4.x-xup)*sin(ang)+(b4.y-yup)*cos(ang)+yup;
      }
      else{

      b1.x= (b1.x-xup)*cos(ang)-(b1.y-yup)*sin(ang)+xup;
      b1.y= (b1.x-xup)*sin(ang)+(b1.y-yup)*cos(ang)+yup;


      b2.x= (b2.x-xup)*cos(ang)-(b2.y-yup)*sin(ang)+xup;
      b2.y= (b2.x-xup)*sin(ang)+(b2.y-yup)*cos(ang)+yup;


      b3.x= (b3.x-xup)*cos(ang)-(b3.y-yup)*sin(ang)+xup;
      b3.y= (b3.x-xup)*sin(ang)+(b3.y-yup)*cos(ang)+yup;


      b4.x= (b4.x-xup)*cos(ang)-(b4.y-yup)*sin(ang)+xup;
      b4.y= (b4.x-xup)*sin(ang)+(b4.y-yup)*cos(ang)+yup;
      }
     
   print(b1,b2,b3,b4);
      CP[1+(Vnum-1)*4][uu++] = new PVector(b1.x, b1.y, b1.z);
      CP[1+(Vnum-1)*4][uu++] = new PVector(b2.x, b2.y, b2.z);
      CP[1+(Vnum-1)*4][uu++] = new PVector(b3.x, b3.y, b3.z);
      CP[1+(Vnum-1)*4][uu++] = new PVector(b4.x, b4.y, b4.z);
    } else if (i%4==2)
    {
      b1= new PVector(xup, yup, zup-radius);
      b4= new PVector(xup-radius, yup, zup);
      b2 = new PVector(b1.x-(radius* kappa), b1.y, b1.z);
      b3 = new PVector(b4.x, b4.y, b4.z-(radius* kappa));


    if(y==0){
      b1.x= (b1.x-xup)*cos(ang)+(b1.y-yup)*sin(ang)+xup;
      b1.y= -(b1.x-xup)*sin(ang)+(b1.y-yup)*cos(ang)+yup;


      b2.x= (b2.x-xup)*cos(ang)+(b2.y-yup)*sin(ang)+xup;
      b2.y= -(b2.x-xup)*sin(ang)+(b2.y-yup)*cos(ang)+yup;


      b3.x= (b3.x-xup)*cos(ang)+(b3.y-yup)*sin(ang)+xup;
      b3.y= -(b3.x-xup)*sin(ang)+(b3.y-yup)*cos(ang)+yup;


      b4.x= (b4.x-xup)*cos(ang)+(b4.y-yup)*sin(ang)+xup;
      b4.y= -(b4.x-xup)*sin(ang)+(b4.y-yup)*cos(ang)+yup;
      }
      else{

      b1.x= (b1.x-xup)*cos(ang)-(b1.y-yup)*sin(ang)+xup;
      b1.y= (b1.x-xup)*sin(ang)+(b1.y-yup)*cos(ang)+yup;


      b2.x= (b2.x-xup)*cos(ang)-(b2.y-yup)*sin(ang)+xup;
      b2.y= (b2.x-xup)*sin(ang)+(b2.y-yup)*cos(ang)+yup;


      b3.x= (b3.x-xup)*cos(ang)-(b3.y-yup)*sin(ang)+xup;
      b3.y= (b3.x-xup)*sin(ang)+(b3.y-yup)*cos(ang)+yup;


      b4.x= (b4.x-xup)*cos(ang)-(b4.y-yup)*sin(ang)+xup;
      b4.y= (b4.x-xup)*sin(ang)+(b4.y-yup)*cos(ang)+yup;
      }
      
   print(b1,b2,b3,b4);
      CP[2+(Vnum-1)*4][cc++] = new PVector(b1.x, b1.y, b1.z);
      CP[2+(Vnum-1)*4][cc++] = new PVector(b2.x, b2.y, b2.z);
      CP[2+(Vnum-1)*4][cc++] = new PVector(b3.x, b3.y, b3.z);
      CP[2+(Vnum-1)*4][cc++] = new PVector(b4.x, b4.y, b4.z);
    } else if (i%4==3)
    {

      b1= new PVector(xup-radius, yup, zup);
      b4= new PVector(xup, yup, zup+radius);
      b2 = new PVector(b1.x, b1.y, b1.z+(radius* kappa));
      b3 = new PVector(b4.x-(radius* kappa), b4.y, b4.z);


   if(y==0){
      b1.x= (b1.x-xup)*cos(ang)+(b1.y-yup)*sin(ang)+xup;
      b1.y= -(b1.x-xup)*sin(ang)+(b1.y-yup)*cos(ang)+yup;


      b2.x= (b2.x-xup)*cos(ang)+(b2.y-yup)*sin(ang)+xup;
      b2.y= -(b2.x-xup)*sin(ang)+(b2.y-yup)*cos(ang)+yup;


      b3.x= (b3.x-xup)*cos(ang)+(b3.y-yup)*sin(ang)+xup;
      b3.y= -(b3.x-xup)*sin(ang)+(b3.y-yup)*cos(ang)+yup;


      b4.x= (b4.x-xup)*cos(ang)+(b4.y-yup)*sin(ang)+xup;
      b4.y= -(b4.x-xup)*sin(ang)+(b4.y-yup)*cos(ang)+yup;
      }
      else{

      b1.x= (b1.x-xup)*cos(ang)-(b1.y-yup)*sin(ang)+xup;
      b1.y= (b1.x-xup)*sin(ang)+(b1.y-yup)*cos(ang)+yup;


      b2.x= (b2.x-xup)*cos(ang)-(b2.y-yup)*sin(ang)+xup;
      b2.y= (b2.x-xup)*sin(ang)+(b2.y-yup)*cos(ang)+yup;


      b3.x= (b3.x-xup)*cos(ang)-(b3.y-yup)*sin(ang)+xup;
      b3.y= (b3.x-xup)*sin(ang)+(b3.y-yup)*cos(ang)+yup;


      b4.x= (b4.x-xup)*cos(ang)-(b4.y-yup)*sin(ang)+xup;
      b4.y= (b4.x-xup)*sin(ang)+(b4.y-yup)*cos(ang)+yup;
      }
  
   print(b1,b2,b3,b4);
      CP[3+(Vnum-1)*4][yy++] = new PVector(b1.x, b1.y, b1.z);
      CP[3+(Vnum-1)*4][yy++] = new PVector(b2.x, b2.y, b2.z);
      CP[3+(Vnum-1)*4][yy++] = new PVector(b3.x, b3.y, b3.z);
      CP[3+(Vnum-1)*4][yy++] = new PVector(b4.x, b4.y, b4.z);
    }
    stroke(1);
    stroke(255,255,0);
    bezier(b1.x, b1.y, b1.z, b2.x, b2.y, b2.z, b3.x, b3.y, b3.z, b4.x, b4.y, b4.z);
 
    print(i+"\t"+tt+uu+cc+yy+"\n");
  }
}

void CircleHull(int num, int Vnum)
{
  PShape s;  
  //int j=0;
  vv=0;
  int y=0;
  for (int k=0; k<Vnum; k++)
  {
    for (int i=0; i<4; ++i)
    {
      for (int l=0; l<4; ++l)
      {
        int j=(k*4)+l;

        hull[vv++] = new PVector(CP[j][i*4].x, CP[j][i*4].y, CP[j][i*4].z);
        hull[vv++] = new PVector(CP[j][i*4+1].x, CP[j][i*4+1].y, CP[j][i*4+1].z);
        hull[vv++] = new PVector(CP[j][i*4+2].x, CP[j][i*4+2].y, CP[j][i*4+2].z);
        hull[vv] = new PVector(CP[j][i*4+3].x, CP[j][i*4+3].y, CP[j][i*4+3].z);

        print("count:"+k+"\t"+vv+"\t"+hull[vv]+"\n");
        //}
      }
      y++;
      vv++;    
      //print("count:"+count+"\t"+hull[count-1]+"\n");
    }
  }


  //for (int i=0; i< 4*Vnum-1; ++i) 
  //{
  //  for (int k=0; k<num-1; ++k) 
  //  {
  //    int a = (num)*i+k;
  //    int b = (num)*(i+1)+k;
  //    int c = (num)*(i+1)+k+1;
  //    int d = (num)*i+k+1;
  //    print("row:"+a+","+b+","+c+","+d+"\n");

  //    verP[0].set(hull[a]);
  //    verP[1].set(hull[b]);
  //    verP[2].set(hull[c]);
  //    verP[3].set(hull[d]);

  //    print("row:"+verP[0]+","+verP[1]+","+verP[2]+","+verP[3]+"\n");

  //    fill(255, 255, 255, 150);
  //    s = createShape();
  //    beginShape();
  //    //fill(random(255), random(255), random(255));
  //    noStroke();
  //    vertex(verP[0].x, verP[0].y, verP[0].z);
  //    vertex(verP[1].x, verP[1].y, verP[1].z);
  //    vertex(verP[2].x, verP[2].y, verP[2].z);
  //    vertex(verP[3].x, verP[3].y, verP[3].z);
  //    endShape(CLOSE);
  //  }
  //}
}


void circle_hullArray(int num, int Vnum)
{ 
  int k=0;
  for (int i=0; i<4*Vnum; ++i)
  { 

    for (int j=0; j<num; ++j)
    {
      if (i==4) {
        k--;
        break;
      }
      hullArray[k][j] = new PVector();
      hullArray[k][j].set( hull[(num)*i+j]);

      print("count:"+k+"\t"+i+"\t"+j+"\t"+((num)*i+j)+hull[(num)*i+j]+hullArray[k][j]+"\n");
    }

    k++;
  }

  PShape s;  
  for (int i=0; i< (4*Vnum-1)-1; ++i) 
  {
    for (int j=0; j< num-1; ++j) 
    {

      verP[0].set(hullArray[i][j]);
      verP[1].set(hullArray[i+1][j]);
      verP[2].set(hullArray[i+1][j+1]);
      verP[3].set(hullArray[i][j+1]);


      //fill(255, 255, 255, 100);
      s = createShape();
      beginShape();
      //fill(random(255), random(255), random(255));
      noStroke();
      noFill();
      vertex(verP[0].x, verP[0].y, verP[0].z);
      vertex(verP[1].x, verP[1].y, verP[1].z);
      vertex(verP[2].x, verP[2].y, verP[2].z);
      vertex(verP[3].x, verP[3].y, verP[3].z);
      endShape(CLOSE);
    }
  }
}

void SurfaceCP(int n)
{

  for (int i=0; i<4; ++i)
  {

    PK[i*4] = new PVector();
    PK[i*4].set(hull[(i*13+n*3)]);
    PK[i*4+1] = new PVector();
    PK[i*4+1].set(hull[(i*13+n*3)+1]);
    PK[i*4+2] = new PVector();
    PK[i*4+2].set(hull[(i*13+n*3)+2]);
    PK[i*4+3] = new PVector();
    PK[i*4+3].set(hull[(i*13+n*3)+3]);
  }
}

void TotalSurfaceCP(int u, int v)
{

  for (int y=0; y<4; ++y)
  {
    for (int i=0; i<4; ++i)
    {

      PK2[y][i] = new PVector();
      print((y+v*3)+","+(i+u*3)+"\n");
      print(hullArray[y+v*3][i+u*3]+"\n");
      PK2[y][i].set(hullArray[y+v*3][i+u*3]);
    }
  }
}


void CircleBezier(int numSegments, int un, int vn )
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


    float v = j / (float)numSegments; 
    for (int k=0; k<= numSegments; ++k, ++y) 
    {
      ver[y]=new PVector();
      float u = k / (float)numSegments; 
      print(k+":"+j+"\n");
      print(u+":"+v+"\n");

      pt.set(evalBezierPatch2(PK2, u, v));
      // pp.set(evalBezierPatch2(PK2, v, u));

      print("y:"+y+","+vn+" "+un+" "+count+"\n");
      ver[y].set(pt);
      //if (n!=4&&k!= numSegments)
      //{
      Ver[vn*numSegments+j][un*numSegments+k] = new PVector(ver[y].x, ver[y].y, ver[y].z);
      // zz++;
      //} else
      //{
      //  Ver[j][n*3+k] = new PVector(ver[y].x, ver[y].y, ver[y].z);
      //  zz++;
      //}
      VerCube[cou][vn*numSegments+j][un*numSegments+k] = new PVector(ver[y].x, ver[y].y, ver[y].z);
      print((vn*2+j)+","+(un*3+k)+","+Ver[vn*2+j][un*3+k]+","+ver[y] +"\n");

      point(pt.x, pt.y, pt.z);
      print(pt+"\n");
      print(pp+"\n");
      if (count>0 ) {
        //  line(p0.x, p0.y, p0.z, pt.x, pt.y, pt.z);
        //  line(p00.x, p00.y, p00.z, pp.x, pp.y, pp.z);
      }
      p0.set(pt);
      p00.set(pp);
    }
  }
}

void faceConnect(int numSegments)
{

  PShape s;  
  for (int i=0, y=0; i< numSegments; ++i) 
  {
    for (int j=0; j< numSegments; ++j, ++y) 
    {
      int a = (numSegments+1)*i+j;
      int b = (numSegments+1)*(i+1)+j;
      int c = (numSegments+1)*(i+1)+j+1;
      int d = (numSegments+1)*i+j+1;
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

void SumfaceConnect(int numSegments)
{
  PShape s;  

  for (int i=0; i< numSegments*CPnum; ++i) 
  {
    for (int j=0; j<numSegments*4; ++j) 
    {

      print(i+":"+j+"  "+Ver[i][j], Ver[i+1][j], Ver[i+1][j+1], Ver[i][j+1]+"\n");
      verP[0].set(Ver[i][j]);
      verP[1].set(Ver[i+1][j]);
      verP[2].set(Ver[i+1][j+1]);
      verP[3].set(Ver[i][j+1]);
      //print(i+":"+j+"  "+Ver[i][j],Ver[i+1][j],Ver[i+1][j+1],Ver[i][j+1]+"\n");

      //fill(0, 0, 0,100);
      s = createShape();
      beginShape();
      //stroke(0,0,0);
      fill(random(255), random(255), random(255));

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

PVector evalBezierPatch(PVector []pk, float u, float v) 
{ 
  PVector []uCurve = new PVector[4]; 

  for (int i=0; i<4; i++)
  {
    p[0].set(pk[i*4]); 
    p[1].set(pk[i*4+1]); 
    p[2].set(pk[i*4+2]); 
    p[3].set(pk[i*4+3]); 
    uCurve[i] = evalBezierCurve(p, u);
    //print("uCurve" + uCurve[i]+"\n");
  }
  return evalBezierCurve(uCurve, v);
} 

PVector evalBezierPatch2(PVector [][]pk, float u, float v) 
{ 
  PVector []uCurve = new PVector[4]; 

  for (int i=0; i<4; i++)
  {
    p[0].set(pk[i][0]); 
    p[1].set(pk[i][1]); 
    p[2].set(pk[i][2]); 
    p[3].set(pk[i][3]); 
    uCurve[i] = evalBezierCurve(p, u);
    print("uCurve" + uCurve[i]+"\n");
  }
  return evalBezierCurve(uCurve, v);
} 

void SumfaceCube(int numSegments)
{
  PShape s;  
  for (int k=0; k<heigtNum-1; k++)
  {
    for (int i=0; i< numSegments*CPnum; ++i) 
    {
      for (int j=0; j<numSegments*4; ++j) 
      {

        //print(i+":"+j+"  "+Ver[i][j],Ver[i+1][j],Ver[i+1][j+1],Ver[i][j+1]+"\n");
        vCube[0].set(VerCube[k][i][j]);
        vCube[1].set(VerCube[k][i+1][j]);
        vCube[2].set(VerCube[k][i+1][j+1]);
        vCube[3].set(VerCube[k][i][j+1]);
        vCube[4].set(VerCube[k+1][i][j]);
        vCube[5].set(VerCube[k+1][i+1][j]);
        vCube[6].set(VerCube[k+1][i+1][j+1]);
        vCube[7].set(VerCube[k+1][i][j+1]);

        //print(i+":"+j+"  "+Ver[i][j],Ver[i+1][j],Ver[i+1][j+1],Ver[i][j+1]+"\n");

        //fill(0, 0, 0,100);
        s = createShape();
        beginShape(QUADS);
        fill(random(255), random(255), random(255));
        //noFill();
        //stroke(255,255,255);
        vertex(vCube[0].x, vCube[0].y, vCube[0].z);
        vertex(vCube[1].x, vCube[1].y, vCube[1].z);
        vertex(vCube[2].x, vCube[2].y, vCube[2].z);
        vertex(vCube[3].x, vCube[3].y, vCube[3].z);

        vertex(vCube[0].x, vCube[0].y, vCube[0].z);
        vertex(vCube[3].x, vCube[3].y, vCube[3].z);
        vertex(vCube[7].x, vCube[7].y, vCube[7].z);
        vertex(vCube[4].x, vCube[4].y, vCube[4].z);

        vertex(vCube[0].x, vCube[0].y, vCube[0].z);
        vertex(vCube[4].x, vCube[4].y, vCube[4].z);
        vertex(vCube[5].x, vCube[5].y, vCube[5].z);
        vertex(vCube[1].x, vCube[1].y, vCube[1].z);

        vertex(vCube[1].x, vCube[1].y, vCube[1].z);
        vertex(vCube[5].x, vCube[5].y, vCube[5].z);
        vertex(vCube[6].x, vCube[6].y, vCube[6].z);
        vertex(vCube[2].x, vCube[2].y, vCube[2].z);

        vertex(vCube[2].x, vCube[2].y, vCube[2].z);
        vertex(vCube[6].x, vCube[6].y, vCube[6].z);
        vertex(vCube[7].x, vCube[7].y, vCube[7].z);
        vertex(vCube[3].x, vCube[3].y, vCube[3].z);

        vertex(vCube[4].x, vCube[4].y, vCube[4].z);
        vertex(vCube[7].x, vCube[7].y, vCube[7].z);
        vertex(vCube[6].x, vCube[6].y, vCube[6].z);
        vertex(vCube[5].x, vCube[5].y, vCube[5].z);
        endShape();
      }
    }
  }
}