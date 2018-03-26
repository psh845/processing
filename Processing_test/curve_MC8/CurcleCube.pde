class CURCLECUBE //<>// //<>//
{
  float angle = 90; //Change this value for angle of bezier
  float kappa;
  float rad;
  float rad2;
  PVector b1, b2, b3, b4;
  int numSegments;  //surface segment
  int num = 13; //hull cp
  int CPnum =1; //v num
  int heigtNum =1;
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

  PVector sp[][][];
  PVector sp1[][][];
  PVector srp[][][];
  PVector srp1[][][];

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
  
  IntList curve_g;

  PVector ee;
  PVector ef;

  float theta, phi;
  int index =0;
  int index2=0;
  int index3=0;


  CURCLECUBE()
  {

    kappa=0;
    rad =0;
    rad2 = 0;
    numSegments = 1;  //surface segment
    num = 13; //hull u cp
    CPnum =1; //v num
    heigtNum =1; //height

    kappa = 4 * tan(radians(angle/4))/3;
    pt = new PVector();
    p0 = new PVector();
    pp = new PVector();
    p00 = new PVector();


    curve_x = new FloatList();
    curve_y = new FloatList();
    curve_z = new FloatList();
    curve_radius = new FloatList();
    curve_normal = new FloatList();
    
    curve_g = new IntList();

    for (int i=0; i<4; ++i)
    {
      p[i] = new PVector();
      verP[i] = new PVector();
    }

    for (int i=0; i<8; ++i)
    {
      vCube[i] = new PVector();
    }
  }

  void segset(int seg, int vnum, int hnum )
  {
    numSegments = seg;  //surface segment
    num = 13; //circle cp
    CPnum =vnum; //v num
    heigtNum =hnum; //height

    CP = new PVector[CPnum*4][16];
    hull = new PVector[num*(CPnum*4)];
    hullArray = new PVector[CPnum*4-(CPnum-1)][num];
    PK = new PVector[16];
    PK2 = new PVector[4][4];

    ver = new PVector[(numSegments*4+1)*(numSegments+1)];
    Ver = new PVector[(numSegments*4)*CPnum+1][(numSegments)*4+1];
    VerCube = new PVector[heigtNum][(numSegments*4)*CPnum+1][(numSegments)*4+1];

    sp = new PVector[heigtNum][numSegments*4/2+1][numSegments*4+1];
    sp1 = new PVector[heigtNum][numSegments*4/2+1][numSegments*4+1];
    srp = new PVector[heigtNum][numSegments*4/2+1][numSegments*4+1];
    srp1 = new PVector[heigtNum][numSegments*4/2+1][numSegments*4+1];
  }

  void Position(FloatList x, FloatList y, FloatList z, int t)
  {
    float a, b, c;
    //print(curve_x.get(0));
    for (int i=t; i<x.size(); i++)
    {
      a = x.get(i);
      b = y.get(i);
      c = z.get(i);
      curve_x.append(a);
      curve_y.append(b);
      curve_z.append(c);
      print(a, b, c);
    }
  }

  void rad(FloatList rad, int t)
  {
    for (int i=t; i<rad.size(); i++)
    {
      curve_radius.append(rad.get(i));
    }
  }

  PVector vcube(int i, int j, int k)
  {

    return VerCube[i][j][k];
  }

  PVector srpcube(int i, int j, int k)
  {

    return srp[i][j][k];
  }

  PVector srpcube2(int i, int j, int k)
  {

    return srp1[i][j][k];
  }


  void MC_normal(int heigtNum, int g)
  { 
    float angle =0;

    for (int j=0; j<heigtNum; j++)
    {
      for (int i=0; i<4; i++)
      {
        angle =normVec(i);
        print(angle);
        curve_normal.append(angle);
      }

      PointToCircle(CPnum, j, g);
    }
  }

  void setCube(int hNum)
  {
    cap1( curve_normal.get(0), hNum,curve_g.get(0));
    cap2( curve_normal.get(3*CPnum), hNum,curve_g.get(3*CPnum));
    if (hNum>1) {
      SumfaceCube(numSegments);
      half_spPolyCube(srp);
      half_spPolyCube(srp1);
    } else {
      SumfaceConnect(numSegments);
      half_spPoly(srp);
      half_spPoly(srp1);
    }
  }

  float normVec(int i)
  {
    float ang=0;
    stroke(0);
    //bezier(curve_x.get(0), curve_y.get(0), curve_z.get(0), curve_x.get(1), curve_y.get(1), curve_z.get(1), 
    //curve_x.get(2), curve_y.get(2), curve_z.get(2), curve_x.get(3), curve_y.get(3), curve_z.get(3));
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
    //u.add(p);

    v.normalize();
    //v.add(p);

    print("vec::"+t, degrees(angle), u, p);


    float ccc= PI/2;
    float c; 
    float d;

    if (t<0.5)
    {
      c = cos(ccc)*(u.x)-sin(ccc)*(u.y);
      d = sin(ccc)*(u.x)+cos(ccc)*(u.y); 
      c = -u.y;
      d = u.x;
    } else {
      c = cos(ccc)*(u.x)-sin(ccc)*(u.y);
      d = sin(ccc)*(u.x)+cos(ccc)*(u.y); 
      c = -u.y;
      d = u.x;
    }

    //u.z += p.z;

    ee = new PVector(c, d, u.z);
    ef = new PVector(c, d, u.z);

    //ee.sub(p);
    ee.normalize();
    //u.sub(p);

    float ttttt=u.dot(ee);

    print("\n"+ttttt, ee, ef);
    PVector ec =new PVector(1, 0, 0);
    ec.normalize();
    print(ec, ee);

    PVector b = new PVector();

    b.cross(u, ee, b);
    b.normalize();

    PVector n = new PVector();
    n.cross(ee, b, n);
    n.normalize();
    print(n, b);

    ttttt=u.dot(b);
    print("\n"+ttttt+"\n");
    ttttt=ee.dot(b);
    print(ttttt+"\n");
    ttttt=ee.dot(n);
    print(ttttt+"\n");

    float yyyyy = n.mag()*ec.mag();
    float tanrad =acos(n.dot(ec)/yyyyy);
    print(tanrad, degrees(tanrad)+"\n");

    yyyyy = ee.mag()*ec.mag();
    float nornrad=acos(ee.dot(ec)/yyyyy);
    print(nornrad, degrees(nornrad)+"\n");


    u.mult(100);
    u.add(p);

    ee.mult(100);
    ee.add(p);

    b.mult(100);
    b.add(p);

    n.mult(100);
    n.add(p);



    strokeWeight(2);
    stroke(255, 0, 0);
    line(u.x, u.y, u.z, p.x, p.y, p.z);
    stroke(0, 255, 0);
    line(ee.x, ee.y, ee.z, p.x, p.y, p.z);
    stroke(0, 0, 255);
    line(b.x, b.y, b.z, p.x, p.y, p.z);
    stroke(255, 255, 255);
    line(n.x, n.y, n.z, p.x, p.y, p.z);

    if (t<0.5)
      ang = nornrad;
    else {
      ang = nornrad;
    }
    print(ang, degrees(ang)+"\n");
    return ang;
  }


  void PointToCircle(int CPnum, int rad, int g) //cpnum
  {

    int aa=0;
    for (int i=0, k=0; i<CPnum; i++)
    {
      Reset();
      for (int j=0; j<4; j++, k++)
      {
        print(curve_x.get(k), curve_y.get(k), curve_z.get(k)+"\n");
        if (g==0)
        {
          curve_g.append(1);
          aa=1;
        } else if (g==1) {
          if (k<2){
            curve_g.append(1);
            aa = 1;
          }else{
            curve_g.append(0);
            aa = 0;
          }
        } else if (g==2)
        {
          if (k>2){
             curve_g.append(1);
            aa = 1;
          }else{
            curve_g.append(0);
            aa = 0;
          }
        } else
        {
           curve_g.append(0);
          aa = 0;
        }

        PVector p = new PVector(curve_x.get(k), curve_y.get(k), curve_z.get(k));
        CirCleCP(curve_radius.get(rad), curve_x.get(k), curve_y.get(k), curve_z.get(k), CPnum, curve_normal.get(k), aa, p);
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
    cc=0;
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


  void CirCleCP(float radius, float xup, float yup, float zup, int Vnum, float ang, int y, PVector p)
  {
    stroke(0, 255, 0);

    PVector rotV = new PVector();
    for (int i=0; i<4; ++i)
    {
      print("angle::"+degrees(ang)+"\n");
      if (i%4==0)
      {

        b1= new PVector(xup, yup, zup+radius);
        b4= new PVector(xup+radius, yup, zup);
        b2 = new PVector(b1.x+ (radius* kappa), b1.y, b1.z);
        b3 = new PVector( b4.x, b4.y, b4.z+(radius*kappa));
        print(b1, b2, b3, b4+"\n");

        //b1.rotate(ang);
        //b2.rotate(ang);
        //b3.rotate(ang);
        //b4.rotate(ang);

        //b1.add(p);
        //b2.add(p);

        //b3.add(p);
        //b4.add(p);

        if (y==0) {
          rotV.x= (b1.x-xup)*cos(ang)+(b1.y-yup)*sin(ang)+xup;
          rotV.y= -(b1.x-xup)*sin(ang)+(b1.y-yup)*cos(ang)+yup;
          rotV.z = b1.z; 
          b1.set(rotV);

          rotV.x= (b2.x-xup)*cos(ang)+(b2.y-yup)*sin(ang)+xup;
          rotV.y= -(b2.x-xup)*sin(ang)+(b2.y-yup)*cos(ang)+yup;
          rotV.z = b2.z; 
          b2.set(rotV);


          rotV.x= (b3.x-xup)*cos(ang)+(b3.y-yup)*sin(ang)+xup;
          rotV.y= -(b3.x-xup)*sin(ang)+(b3.y-yup)*cos(ang)+yup;
          rotV.z = b3.z; 
          b3.set(rotV);

          rotV.x= (b4.x-xup)*cos(ang)+(b4.y-yup)*sin(ang)+xup;
          rotV.y = -(b4.x-xup)*sin(ang)+(b4.y-yup)*cos(ang)+yup;
          rotV.z = b4.z; 
          b4.set(rotV);
        } else {

          rotV.x= (b1.x-xup)*cos(ang)-(b1.y-yup)*sin(ang)+xup;
          rotV.y= (b1.x-xup)*sin(ang)+(b1.y-yup)*cos(ang)+yup;
          rotV.z = b1.z; 
          b1.set(rotV);

          rotV.x= (b2.x-xup)*cos(ang)-(b2.y-yup)*sin(ang)+xup;
          rotV.y= (b2.x-xup)*sin(ang)+(b2.y-yup)*cos(ang)+yup;
          rotV.z = b2.z; 
          b2.set(rotV);


          rotV.x= (b3.x-xup)*cos(ang)-(b3.y-yup)*sin(ang)+xup;
          rotV.y= (b3.x-xup)*sin(ang)+(b3.y-yup)*cos(ang)+yup;
          rotV.z = b3.z; 
          b3.set(rotV);

          rotV.x= (b4.x-xup)*cos(ang)-(b4.y-yup)*sin(ang)+xup;
          rotV.y = (b4.x-xup)*sin(ang)+(b4.y-yup)*cos(ang)+yup;
          rotV.z = b4.z; 
          b4.set(rotV);
        }


        print(b1, b2, b3, b4);
        CP[0+(Vnum-1)*4][tt++] = new PVector(b1.x, b1.y, b1.z);
        CP[0+(Vnum-1)*4][tt++] = new PVector(b2.x, b2.y, b2.z);
        CP[0+(Vnum-1)*4][tt++] = new PVector(b3.x, b3.y, b3.z);
        CP[0+(Vnum-1)*4][tt++] = new PVector(b4.x, b4.y, b4.z);

        stroke(0, 0, 0);
        strokeWeight(5);
        point(b4.x, b4.y, b4.z);
      } else if (i%4==1)
      {
        b1= new PVector(xup+radius, yup, zup);
        b4= new PVector(xup, yup, zup-radius);
        b2 = new PVector(b1.x, b1.y, b1.z-(radius* kappa));
        b3 = new PVector(b4.x+(radius* kappa), b4.y, b4.z);
        print(b1, b2, b3, b4+"\n");

        if (y==0) {
          rotV.x= (b1.x-xup)*cos(ang)+(b1.y-yup)*sin(ang)+xup;
          rotV.y= -(b1.x-xup)*sin(ang)+(b1.y-yup)*cos(ang)+yup;
          rotV.z = b1.z; 
          b1.set(rotV);

          rotV.x= (b2.x-xup)*cos(ang)+(b2.y-yup)*sin(ang)+xup;
          rotV.y= -(b2.x-xup)*sin(ang)+(b2.y-yup)*cos(ang)+yup;
          rotV.z = b2.z; 
          b2.set(rotV);


          rotV.x= (b3.x-xup)*cos(ang)+(b3.y-yup)*sin(ang)+xup;
          rotV.y= -(b3.x-xup)*sin(ang)+(b3.y-yup)*cos(ang)+yup;
          rotV.z = b3.z; 
          b3.set(rotV);

          rotV.x= (b4.x-xup)*cos(ang)+(b4.y-yup)*sin(ang)+xup;
          rotV.y = -(b4.x-xup)*sin(ang)+(b4.y-yup)*cos(ang)+yup;
          rotV.z = b4.z; 
          b4.set(rotV);
        } else {

          rotV.x= (b1.x-xup)*cos(ang)-(b1.y-yup)*sin(ang)+xup;
          rotV.y= (b1.x-xup)*sin(ang)+(b1.y-yup)*cos(ang)+yup;
          rotV.z = b1.z; 
          b1.set(rotV);

          rotV.x= (b2.x-xup)*cos(ang)-(b2.y-yup)*sin(ang)+xup;
          rotV.y= (b2.x-xup)*sin(ang)+(b2.y-yup)*cos(ang)+yup;
          rotV.z = b2.z; 
          b2.set(rotV);


          rotV.x= (b3.x-xup)*cos(ang)-(b3.y-yup)*sin(ang)+xup;
          rotV.y= (b3.x-xup)*sin(ang)+(b3.y-yup)*cos(ang)+yup;
          rotV.z = b3.z; 
          b3.set(rotV);

          rotV.x= (b4.x-xup)*cos(ang)-(b4.y-yup)*sin(ang)+xup;
          rotV.y = (b4.x-xup)*sin(ang)+(b4.y-yup)*cos(ang)+yup;
          rotV.z = b4.z; 
          b4.set(rotV);
        }

        print(b1, b2, b3, b4);
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
        print(b1, b2, b3, b4+"\n");

        if (y==0) {
          rotV.x= (b1.x-xup)*cos(ang)+(b1.y-yup)*sin(ang)+xup;
          rotV.y= -(b1.x-xup)*sin(ang)+(b1.y-yup)*cos(ang)+yup;
          rotV.z = b1.z; 
          b1.set(rotV);

          rotV.x= (b2.x-xup)*cos(ang)+(b2.y-yup)*sin(ang)+xup;
          rotV.y= -(b2.x-xup)*sin(ang)+(b2.y-yup)*cos(ang)+yup;
          rotV.z = b2.z; 
          b2.set(rotV);


          rotV.x= (b3.x-xup)*cos(ang)+(b3.y-yup)*sin(ang)+xup;
          rotV.y= -(b3.x-xup)*sin(ang)+(b3.y-yup)*cos(ang)+yup;
          rotV.z = b3.z; 
          b3.set(rotV);

          rotV.x= (b4.x-xup)*cos(ang)+(b4.y-yup)*sin(ang)+xup;
          rotV.y = -(b4.x-xup)*sin(ang)+(b4.y-yup)*cos(ang)+yup;
          rotV.z = b4.z; 
          b4.set(rotV);
        } else {

          rotV.x= (b1.x-xup)*cos(ang)-(b1.y-yup)*sin(ang)+xup;
          rotV.y= (b1.x-xup)*sin(ang)+(b1.y-yup)*cos(ang)+yup;
          rotV.z = b1.z; 
          b1.set(rotV);

          rotV.x= (b2.x-xup)*cos(ang)-(b2.y-yup)*sin(ang)+xup;
          rotV.y= (b2.x-xup)*sin(ang)+(b2.y-yup)*cos(ang)+yup;
          rotV.z = b2.z; 
          b2.set(rotV);


          rotV.x= (b3.x-xup)*cos(ang)-(b3.y-yup)*sin(ang)+xup;
          rotV.y= (b3.x-xup)*sin(ang)+(b3.y-yup)*cos(ang)+yup;
          rotV.z = b3.z; 
          b3.set(rotV);

          rotV.x= (b4.x-xup)*cos(ang)-(b4.y-yup)*sin(ang)+xup;
          rotV.y = (b4.x-xup)*sin(ang)+(b4.y-yup)*cos(ang)+yup;
          rotV.z = b4.z; 
          b4.set(rotV);
        }


        print(b1, b2, b3, b4);
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
        print(b1, b2, b3, b4+"\n");

        if (y==0) {
          rotV.x= (b1.x-xup)*cos(ang)+(b1.y-yup)*sin(ang)+xup;
          rotV.y= -(b1.x-xup)*sin(ang)+(b1.y-yup)*cos(ang)+yup;
          rotV.z = b1.z; 
          b1.set(rotV);

          rotV.x= (b2.x-xup)*cos(ang)+(b2.y-yup)*sin(ang)+xup;
          rotV.y= -(b2.x-xup)*sin(ang)+(b2.y-yup)*cos(ang)+yup;
          rotV.z = b2.z; 
          b2.set(rotV);


          rotV.x= (b3.x-xup)*cos(ang)+(b3.y-yup)*sin(ang)+xup;
          rotV.y= -(b3.x-xup)*sin(ang)+(b3.y-yup)*cos(ang)+yup;
          rotV.z = b3.z; 
          b3.set(rotV);

          rotV.x= (b4.x-xup)*cos(ang)+(b4.y-yup)*sin(ang)+xup;
          rotV.y = -(b4.x-xup)*sin(ang)+(b4.y-yup)*cos(ang)+yup;
          rotV.z = b4.z; 
          b4.set(rotV);
        } else {

          rotV.x= (b1.x-xup)*cos(ang)-(b1.y-yup)*sin(ang)+xup;
          rotV.y= (b1.x-xup)*sin(ang)+(b1.y-yup)*cos(ang)+yup;
          rotV.z = b1.z; 
          b1.set(rotV);

          rotV.x= (b2.x-xup)*cos(ang)-(b2.y-yup)*sin(ang)+xup;
          rotV.y= (b2.x-xup)*sin(ang)+(b2.y-yup)*cos(ang)+yup;
          rotV.z = b2.z; 
          b2.set(rotV);


          rotV.x= (b3.x-xup)*cos(ang)-(b3.y-yup)*sin(ang)+xup;
          rotV.y= (b3.x-xup)*sin(ang)+(b3.y-yup)*cos(ang)+yup;
          rotV.z = b3.z; 
          b3.set(rotV);

          rotV.x= (b4.x-xup)*cos(ang)-(b4.y-yup)*sin(ang)+xup;
          rotV.y = (b4.x-xup)*sin(ang)+(b4.y-yup)*cos(ang)+yup;
          rotV.z = b4.z; 
          b4.set(rotV);
        }

        print(b1, b2, b3, b4);
        CP[3+(Vnum-1)*4][yy++] = new PVector(b1.x, b1.y, b1.z);
        CP[3+(Vnum-1)*4][yy++] = new PVector(b2.x, b2.y, b2.z);
        CP[3+(Vnum-1)*4][yy++] = new PVector(b3.x, b3.y, b3.z);
        CP[3+(Vnum-1)*4][yy++] = new PVector(b4.x, b4.y, b4.z);
      }
      stroke(1);
      stroke(255, 255, 0);
     // bezier(b1.x, b1.y, b1.z, b2.x, b2.y, b2.z, b3.x, b3.y, b3.z, b4.x, b4.y, b4.z);

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

    for (int j=0, y=0; j<= numSegments*4; ++j) 
    {
      //float t = j / (float)numSegments; 
      //pt.set(evalBezierCurve(p,t));
      //point(pt.x,pt.y,pt.z);
      //if(count>0 )
      //  line(p0.x,p0.y,p0.z,pt.x,pt.y,pt.z);
      //p0.set(pt);
      //count++;


      float v = j / (float)(numSegments*4); 
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
        Ver[vn*(numSegments*4)+j][un*numSegments+k] = new PVector(ver[y].x, ver[y].y, ver[y].z);
        // zz++;
        //} else
        //{
        //  Ver[j][n*3+k] = new PVector(ver[y].x, ver[y].y, ver[y].z);
        //  zz++;
        //}
        VerCube[cou][vn*(numSegments*4)+j][un*numSegments+k] = new PVector(ver[y].x, ver[y].y, ver[y].z);
        //print((vn*2+j)+","+(un*3+k)+","+Ver[vn*2+j][un*3+k]+","+ver[y] +"\n");

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
    for (int i=0, y=0; i< numSegments*4; ++i) 
    {
      for (int j=0; j< numSegments; ++j, ++y) 
      {
        int a = (numSegments*4+1)*i+j;
        int b = (numSegments*4+1)*(i+1)+j;
        int c = (numSegments*4+1)*(i+1)+j+1;
        int d = (numSegments*4+1)*i+j+1;
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

    for (int i=0; i< numSegments*4*CPnum; ++i) 
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
        beginShape(QUAD);
        strokeWeight(3);
        stroke(255, 255, 255);
        fill(random(255), random(255), random(255), 100);
        //noFill();

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
      for (int i=0; i< numSegments*4*CPnum; ++i) 
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
          //fill(random(255), random(255), random(255), 100);
          // fill(255,255, 255, 100);
          //noFill();
          noStroke();
          strokeWeight(1);
          //stroke(255, 255, 255, 100);
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


  void cap1( float rot, int hnum, int g)
  {
    float r=0;
    for (int k=0; k< hnum; k++)
    {
      r = curve_radius.get(k);
      for (int j=0; j<=numSegments*4/2; j++) 
      { // top cap
        for (int i=0; i<=numSegments*4; i++) {
          theta = i * TWO_PI / float(numSegments*4);
          phi =  PI * j /float(numSegments*4);
          sp[k][j][i] = new PVector();
          sp[k][j][i].x= r * cos(phi) * cos(theta)+curve_x.get(0); 
          sp[k][j][i].y = r * sin(phi)+curve_y.get(0);
          sp[k][j][i].z= r * cos(phi) * sin(theta)+curve_z.get(0);

          srp[k][j][i] = new PVector();
          
          if (g==1) {
            srp[k][j][i].x =   (sp[k][j][i].x-curve_x.get(0))*cos(rot) - (sp[k][j][i].y-curve_y.get(0))*sin(rot)+curve_x.get(0);
            srp[k][j][i].y = (sp[k][j][i].x-curve_x.get(0))*sin(rot)+ (sp[k][j][i].y-curve_y.get(0))*cos(rot)+curve_y.get(0);
            srp[k][j][i].z =   sp[k][j][i].z;
          } else {
            srp[k][j][i].x =   (sp[k][j][i].x-curve_x.get(0))*cos(rot) + (sp[k][j][i].y-curve_y.get(0))*sin(rot)+curve_x.get(0);
            srp[k][j][i].y = -(sp[k][j][i].x-curve_x.get(0))*sin(rot)+ (sp[k][j][i].y-curve_y.get(0))*cos(rot)+curve_y.get(0);
            srp[k][j][i].z =   sp[k][j][i].z;
          }
          //p[index].y -= 50;
          strokeWeight(1);
          stroke(255, 0, 0);
          //point(srp[k][j][i].x, srp[k][j][i].y, srp[k][j][i].z);
          //point(srp[j][i].x, srp[j][i].y, srp[j][i].z);
          print(index+"\n");
          print(srp[k][j][i].x, srp[k][j][i].y, srp[k][j][i].z+"\n");

          index++;
        }
      }
    }
  }

  void cap2( float rot, int hnum, int g)
  {
    float r=0;
    for (int k=0; k<hnum; k++)
    {
      r = curve_radius.get(k);
      for (int j=0; j<=numSegments*4/2; j++) 
      { // top cap
        for (int i=0; i<=numSegments*4; i++) 
        {
          theta = i * TWO_PI / float(numSegments*4);
          phi =  -PI * j /float(numSegments*4);
          sp1[k][j][i] = new PVector();
          sp1[k][j][i].x= r * cos(phi) * cos(theta)+curve_x.get(3); 
          sp1[k][j][i].y = r * sin(phi)+curve_y.get(3);
          sp1[k][j][i].z= r * cos(phi) * sin(theta)+curve_z.get(3);

          srp1[k][j][i] = new PVector();
          
          if (g==1) {
            srp1[k][j][i].x =   (sp1[k][j][i].x-curve_x.get(3))*cos(rot) - (sp1[k][j][i].y-curve_y.get(3))*sin(rot)+curve_x.get(3);
            srp1[k][j][i].y = (sp1[k][j][i].x-curve_x.get(3))*sin(rot)+ (sp1[k][j][i].y-curve_y.get(3))*cos(rot)+curve_y.get(3);
            srp1[k][j][i].z =   sp1[k][j][i].z;
          } else
          {
            srp1[k][j][i].x =   (sp1[k][j][i].x-curve_x.get(3))*cos(rot) + (sp1[k][j][i].y-curve_y.get(3))*sin(rot)+curve_x.get(3);
            srp1[k][j][i].y = -(sp1[k][j][i].x-curve_x.get(3))*sin(rot)+ (sp1[k][j][i].y-curve_y.get(3))*cos(rot)+curve_y.get(3);
            srp1[k][j][i].z =   sp1[k][j][i].z;
          }
          //p[index].y -= 50;
          strokeWeight(1);
          stroke(255, 0, 0);
          //point(srp1[k][j][i].x, srp1[k][j][i].y, srp1[k][j][i].z);
          //point(srp[j][i].x, srp[j][i].y, srp[j][i].z);
          print(index2+"\n");
          print(srp1[k][j][i].x, srp1[k][j][i].y, srp1[k][j][i].z+"\n");

          index2++;
        }
      }
    }
  }

  void half_spPoly(PVector ss[][][])
  {
    int i1, i2, i3, i4;
    for (int j=0; j<numSegments*4/2; j++) {
      for (int i=0; i<numSegments*4; i++) {
        i1 =  j*(numSegments*4+1)  + i;
        i2 = (j+1)   * (numSegments*4+1) + i    ;
        i3 =  (j+1) * (numSegments*4+1) + (i + 1)  ;
        i4 =  (j) * (numSegments*4+1)+ (i + 1);
        print(i1, i2, i3, i4+"\n");
        fill(random(255), random(255), random(255), 100);
        strokeWeight(3);
        stroke(255, 255, 255);
        beginShape(QUADS);
        vertex(ss[0][j][i].x, ss[0][j][i].y, ss[0][j][i].z);
        vertex(ss[0][j+1][i].x, ss[0][j+1][i].y, ss[0][j+1][i].z);
        vertex(ss[0][j+1][i+1].x, ss[0][j+1][i+1].y, ss[0][j+1][i+1].z);
        vertex(ss[0][j][i+1].x, ss[0][j][i+1].y, ss[0][j][i+1].z);
        endShape(CLOSE);
        print(index3);
        index3++;
      }
    }
  }


  void half_spPolyCube(PVector ss[][][])
  {
    PShape s;
    int i1, i2, i3, i4;
    for (int k=0; k<heigtNum-1; k++)
    {
      for (int i=0; i<numSegments*4/2; i++) 
      {
        for (int j=0; j<numSegments*4; j++) {
          //i1 =  j*(numSegments*4+1)  + i;
          //i2 = (j+1)   * (numSegments*4+1) + i    ;
          //i3 =  (j+1) * (numSegments*4+1) + (i + 1)  ;
          //i4 =  (j) * (numSegments*4+1)+ (i + 1);
          // print(i1, i2, i3, i4+"\n");

          vCube[0].set(ss[k][i][j]);
          vCube[1].set(ss[k][i+1][j]);
          vCube[2].set(ss[k][i+1][j+1]);
          vCube[3].set(ss[k][i][j+1]);
          vCube[4].set(ss[k+1][i][j]);
          vCube[5].set(ss[k+1][i+1][j]);
          vCube[6].set(ss[k+1][i+1][j+1]);
          vCube[7].set(ss[k+1][i][j+1]);

          //print(i+":"+j+"  "+Ver[i][j],Ver[i+1][j],Ver[i+1][j+1],Ver[i][j+1]+"\n");

          //fill(0, 0, 0,100);
          s = createShape();
          beginShape(QUADS);
          // fill(random(255), random(255), random(255), 100);
          noFill();
          strokeWeight(1);
          noStroke();
          //stroke(255, 255, 255, 100);
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
          print(index3+"\n");
          index3++;
        }
      }
    }
  }

  void setIntersection(int hNum, PVector [][][]c)
  {
    cap1( curve_normal.get(0), hNum,curve_g.get(0));
    cap2( curve_normal.get(3*CPnum), hNum,curve_g.get(3*CPnum));
    if (hNum>1) {
      SumfaceCube2(numSegments, c);
      half_spPolyCube(srp);
      half_spPolyCube(srp1);
    } else {
      SumfaceConnect(numSegments);
      // half_spPoly(srp);
      //half_spPoly(srp1);
    }
  }


  void SumfaceCube2(int numSegments, PVector [][][]c)
  {
    PShape s;  

    boolean bool = false;
    for (int k=0; k<heigtNum-1; k++)
    {

      for (int i=0; i< numSegments*4*CPnum; ++i) 
      {
        for (int j=0; j<numSegments*4; ++j) 
        {
          bool = false;
          //print(i+":"+j+"  "+Ver[i][j],Ver[i+1][j],Ver[i+1][j+1],Ver[i][j+1]+"\n");
          vCube[0].set(VerCube[k][i][j]);
          vCube[1].set(VerCube[k][i+1][j]);
          vCube[2].set(VerCube[k][i+1][j+1]);
          vCube[3].set(VerCube[k][i][j+1]);
          vCube[4].set(VerCube[k+1][i][j]);
          vCube[5].set(VerCube[k+1][i+1][j]);
          vCube[6].set(VerCube[k+1][i+1][j+1]);
          vCube[7].set(VerCube[k+1][i][j+1]);


          bool = Intersection(c, vCube);
          print("cm::"+bool+"\n");

          //print(i+":"+j+"  "+Ver[i][j],Ver[i+1][j],Ver[i+1][j+1],Ver[i][j+1]+"\n");
          if (!bool) {
            //fill(0, 0, 0,100);
            s = createShape();
            beginShape(QUADS);
            //fill(random(255), random(255), random(255), 100);
            // fill(255,255, 255, 100);
            //noFill();
            noStroke();
            strokeWeight(1);
            //stroke(255, 255, 255, 200);
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
  }


  boolean Intersection(PVector [][][]c, PVector []VC)
  {
    PVector []vCube2 = new PVector[8];
    PVector min = new PVector();
    PVector max = new PVector();
    PVector min2 = new PVector();
    PVector max2 = new PVector();

    boolean bool=false; 

    min.x = VC[0].x;
    max.x= VC[0].x;
    min.y = VC[0].y;
    max.y = VC[0].y;
    min.z = VC[0].z;
    max.z = VC[0].z;
    for (int z=0; z<8; z++)
    {
      if (min.x>=VC[z].x)
        min.x = VC[z].x;
      if (min.y>=VC[z].y)
        min.y = VC[z].y;
      if ( min.z >=VC[z].z)
        min.z  = VC[z].z;

      if ( max.x<=VC[z].x)
        max.x = VC[z].x;
      if ( max.y<=VC[z].y)
        max.y = VC[z].y;
      if ( max.z<=VC[z].z)
        max.z = VC[z].z;

      vCube2[z] = new PVector();
    }


    for (int k=0; k<heigtNum-2; k++)
    {

      for (int i=0; i< numSegments*4*CPnum; ++i) 
      {
        for (int j=0; j<numSegments*4; ++j) 
        {
          vCube2[0].set(c[k][i][j]);
          vCube2[1].set(c[k][i+1][j]);
          vCube2[2].set(c[k][i+1][j+1]);
          vCube2[3].set(c[k][i][j+1]);
          vCube2[4].set(c[k+1][i][j]);
          vCube2[5].set(c[k+1][i+1][j]);
          vCube2[6].set(c[k+1][i+1][j+1]);
          vCube2[7].set(c[k+1][i][j+1]);

          min2.x = vCube2[0].x;
          max2.x= vCube2[0].x;
          min2.y = vCube2[0].y;
          max2.y = vCube2[0].y;
          min2.z = vCube2[0].z;
          max2.z = vCube2[0].z;

          for (int z=0; z<8; z++)
          {
            if (min2.x>=vCube2[z].x)
              min2.x = vCube2[z].x;
            if (min2.y>=vCube2[z].y)
              min2.y = vCube2[z].y;
            if ( min2.z >=vCube2[z].z)
              min2.z  = vCube2[z].z;

            if ( max2.x<=vCube2[z].x)
              max2.x = vCube2[z].x;
            if ( max2.y<=vCube2[z].y)
              max2.y = vCube2[z].y;
            if ( max2.z<=vCube2[z].z)
              max2.z = vCube2[z].z;
          }

          if ( AABBtoAABB(min, max, min2, max2))
            bool = true;
        }
      }
    }
    return bool;
  }


  boolean AABBtoAABB(PVector Amin, PVector Amax, PVector Bmin, PVector Bmax)
  {
    //print(Amin, Amax,Bmin,Bmax);
    //Check if Box1's max is greater than Box2's min and Box1's min is less than Box2's max
    //return(Amax.x > Bmin.x && 
    //   Amin.x < Bmax.x &&
    //   Amax.y > Bmin.y &&
    //   Amin.y < Bmax.y &&
    //   Amax.z > Bmin.z &&
    //   Amin.z < Bmax.z);
    return(Amax.x >= Bmin.x && 
      Amin.x <= Bmax.x &&
      Amax.y >= Bmin.y &&
      Amin.y <= Bmax.y &&
      Amax.z >= Bmin.z &&
      Amin.z <= Bmax.z);

    //If not, it will return false
  }


  void drawCube()
  {
  }
}