final int tnfmax=15000; //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
final int tnemax=30000;
final int tnpmax=15000;
final int tfrnpmax=500;
final int tnfrmax=20;
final float eps8=0.00001;

class tface_dat
{
  int p1, p2, p3;
  void tface_dat()
  {
    p1=0;
    p2=0;
    p3=0;
  }
}

class tpoint_dat
{
  PVector p, nv, tv1, tv2;
  boolean full, achange;
  float angle;

  void tpoint_dat()
  {
    p = new PVector();
    nv= new PVector();
    tv1 = new PVector();
    tv2 =new PVector();
  }
}

class implicit3d
{
  PVector fgradf;
  float f;


  void implicit3dset(PVector p, float r )
  {

    f=p.x*p.x+p.y*p.y+p.z*p.z-r*r;
    print(f);
    fgradf = new PVector();
    //fgradf.set(p);
    fgradf.x = 2*p.x;
    fgradf.y = 2*p.y;
    fgradf.z = 2*p.z;
    //fgradf.mult(2);
  }

  void f_gradg_c1(PVector p, float r, float _x1, float _y1)
  {
    f= sq(p.x-_x1)+sq(p.y-_y1)-sq(r);
    fgradf = new PVector();
    fgradf.x = 2*(p.x-_x1);
    fgradf.y = 2*(p.y-_y1);
    fgradf.z = 0;
  }
}

tface_dat tface[] = new tface_dat[tnfmax];
tpoint_dat tpoint[] = new tpoint_dat[tnpmax];
int tfrontpt[]= new int[tfrnpmax];
int tfrontnp;
int tfr[][] = new int[tnfrmax][tfrnpmax];
float tfrbox[][] = new float[tnfrmax][6];
int tnp, tne, tnf, tnfr;
float tstepl, tstepl_square, xmin, xmax, ymin, ymax, zmin, zmax, minangle;
int n_triang, fullcount, frontnumber;
implicit3d f_gradf;
int actual_ip; 
boolean nearpointtest;
int cuttype;
float xcut, ycut, zcut, rcut, rcut_square;

PVector pn1, pn2, pn0, p_start, pc_start, pn11, pn22;
PVector p0, p1, nv0, tv10, tv20; //startpoint
PVector p, nv, tv1, tv2;

float fi;
PVector p_i1, gradfi;

float x1, y1, r;
int ip, ip1, ip2, ipi1, ipi2, ipf, ipf1, ipf2, delay, ne_rest;




void setup()
{
  size(800, 800, P3D);
  noLoop();
}

void draw()
{
  translate(400, 400, 0);
  scale(60);

  stroke(0);
  strokeWeight(0.05);

  n_triang=6;
  cuttype=0; 
  r=2.0;
  x1=-2;
  y1=-5;
  p_start = new PVector(0, -3, 1);
  tnp=0;
  tnf=0;
  tnfr=0;
  f_gradf = new implicit3d();
  //f_gradf.implicit3dset(p_start,r);
  tstepl=0.4;
  xmin=-10;
  xmax=10;
  ymin=-10;
  ymax=10;
  zmin=-5;
  zmax=5;
  
  start_trangulation(p_start, f_gradf);
  println(tnp);
  nearpointtest= true;
  triangulation(nearpointtest);
  
  println("tfrontnp: "+tfrontnp+" fullcount: "+fullcount+" tnf: "
             +tnf+" n_triang: "+n_triang);
  println("tnp: "+tnp+"   tnf: "+tnf);  
    
  PVector tp = new PVector();
  for (int i=0; i<=tnp; i++)
  {
    tp= tpoint[i].p;
    print(tp+"\t");
    //stroke(0);
    point(tp.x, tp.y, tp.z);
  }
  PVector tpf = new PVector();
  int a=0;
  for (int i=0; i<tnf; i++)
  {
    beginShape(TRIANGLES);
    fill(255, 0, 0);
    a= tface[i].p1;
    tpf = tpoint[a].p;
    vertex(tpf.x, tpf.y, tpf.z);
    a= tface[i].p2;
    tpf = tpoint[a].p;
    vertex(tpf.x, tpf.y, tpf.z);
    a= tface[i].p3;
    tpf = tpoint[a].p;
    vertex(tpf.x, tpf.y, tpf.z);
    endShape();
  }
}

void start_trangulation(PVector p_start, implicit3d f_gradf)
{

  int i, tnp0;
  float dw, cw, sw;

  p0 = new PVector();
  p1 = new PVector();
  nv0 = new PVector();
  tv10 = new PVector();
  tv20 = new PVector();

  //tnp = tnp+1;

  surface_point_normal_tangentvts(p_start, f_gradf, p0, nv0, tv10, tv20, 0);
  if (!point_ok(p0))
  {
    n_triang=0;
    return;
  }
  tpoint[tnp] = new tpoint_dat();
  tpoint[tnp].p=p0;
  tpoint[tnp].nv=nv0;
  tpoint[tnp].tv1=tv10;
  tpoint[tnp].tv2=tv20;
  tnp0=tnp;
  for (i=0; i<=5; i++)
  {
    dw= PI/3;
    cw= cos(i*dw);
    sw= sin(i*dw);
    p1=lcomb3vt3d(1, p0, tstepl*cw, tv10, tstepl*sw, tv20);
    tnp = tnp+1;
    tfrontpt[i+1]=tnp;
    tpoint[tnp] = new tpoint_dat();
    surface_point_normal_tangentvts(p1, f_gradf, tpoint[tnp].p, tpoint[tnp].nv, tpoint[tnp].tv1, tpoint[tnp].tv2, 1);
    tpoint[tnp].achange =true;
  }

  tfrontnp=6;
  tpoint[0].full=true;

  for (i=1; i<=6; i++)
  {
    tface[tnf]=new tface_dat();
    tface[tnf].p1=tnp0;
    tface[tnf].p2=tnp0+i;
    tface[tnf].p3=tnp0+i+1;
    tnf=tnf+1;
  }
  tface[tnf-1].p3 = tnp0+1;
}

void surface_point_normal_tangentvts(PVector p_start, implicit3d f_gradf, PVector _p, 
  PVector _nv, PVector _tv1, PVector _tv2, int num)
{
  p = new PVector();
  nv = new PVector();
  tv1 = new PVector();
  tv2 = new PVector();

  //p= _p;
  //nv= _nv;
  //tv1= _tv1;
  //tv2= _tv2;

  surface_point(p_start);
  nv.normalize();
  if ((abs(nv.x)>0.5)&&(abs(nv.y)>0.5))
  {
    tv1.x = nv.y;
    tv1.y= -nv.x;
    tv1.z =0;
  } else {
    tv1.x= -nv.z;
    tv1.y= 0;
    tv1.z = nv.x;
  }

  tv1.normalize();
  tv2=vectorp(nv, tv1);

  if (num !=0)
  {
    tpoint[tnp].p = p;
    tpoint[tnp].nv= nv;
    tpoint[tnp].tv1 = tv1;
    tpoint[tnp].tv2 = tv2;
  } else
  { 
    p0 = p;
    nv0= nv;
    tv10= tv1;
    tv20= tv2;
  }
}

void surface_point(PVector p0)
{
  float delta;

  PVector p_i = new PVector();

  PVector dv = new PVector();
  p_i1 = new PVector();

  p_i=p0;

  do
  {
    newton_step(p_i);
    dv = diff3d(p_i1, p_i);
    delta = abs3d(dv);
    p_i=p_i1;
    print("delta"+delta);
  } 
  while (delta>eps8);

  p=p_i1;
  nv=gradfi;
}

void newton_step(PVector _p_i)
{

  float t, cc;

  gradfi = new PVector();
  f_gradf.f_gradg_c1(_p_i, r, x1, y1);

  fi= f_gradf.f;
  gradfi.set(f_gradf.fgradf);
  print(gradfi, fi);

  cc= scalarp3d(gradfi, gradfi);

  if (cc>eps8)
    t=-fi/cc;
  else
    t=0;

  p_i1=lcomb2vt3d(1, _p_i, t, gradfi);
}

float scalarp3d(PVector p, PVector p1)
{
  float scalarp;
  print(p, p1);
  scalarp = (p.x*p1.x)+(p.y*p1.y)+(p.z*p1.z);
  return scalarp;
}

PVector lcomb2vt3d(float r1, PVector v1, float r2, PVector v2)
{
  PVector vlc = new PVector();
  vlc.x = r1*v1.x+r2*v2.x;
  vlc.y = r1*v1.y+r2*v2.y;
  vlc.z = r1*v1.z+r2*v2.z;
  return vlc;
}

PVector lcomb3vt3d(float r1, PVector v1, float r2, PVector v2, float r3, PVector v3)
{
  PVector vlc = new PVector();
  vlc.x = r1*v1.x+r2*v2.x+r3*v3.x;
  vlc.y = r1*v1.y+r2*v2.y+r3*v3.y;
  vlc.z = r1*v1.z+r2*v2.z+r3*v3.z;
  return vlc;
}

PVector diff3d(PVector v1, PVector v2)
{
  PVector vs = new PVector();
  vs.x = v1.x-v2.x;
  vs.y = v1.y-v2.y;
  vs.z = v1.z-v2.z;
  return vs;
}

float abs3d(PVector v)
{
  float abs3d;
  abs3d = (abs(v.x)+abs(v.y)+abs(v.z));

  return abs3d;
}

PVector normalize3d(PVector p)
{
  float c;
  PVector v = new PVector();
  c= 1/length3d(p);
  v.x = c*p.x;
  v.y = c*p.y;
  v.z = c*p.z;
  return v;
}

float length3d(PVector v) 
{
  float length3d;
  length3d= sqrt( sq(v.x) + sq(v.y) + sq(v.z));  
  return length3d;
}

PVector vectorp(PVector v1, PVector v2 )
{
  PVector vp = new PVector();
  vp.x=  v1.y*v2.z - v1.z*v2.y ;
  vp.y= -v1.x*v2.z + v2.x*v1.z ;
  vp.z=  v1.x*v2.y - v2.x*v1.y ;

  return vp;
}

PVector put3d(float x, float y, float z)
{
  PVector v = new PVector();
  v.x= x;  
  v.y= y;  
  v.z= z;   
  return v;
}

PVector scale3d(float r, PVector v)
{
  PVector vs= new PVector();
  vs.x= r*v.x;  
  vs.y= r*v.y;
  vs.z= r*v.z; 
  return vs;
}

PVector rotorz(float cos_rota, float sin_rota, PVector p)
{
  PVector pr= new PVector();
  pr.x= p.x*cos_rota - p.y*sin_rota;
  pr.y= p.x*sin_rota + p.y*cos_rota;    
  pr.z= p.z;

  return pr;
}


boolean point_ok(PVector p)
{
  boolean point_ok;
  if (cuttype ==1)
  {
    point_ok = point_ok_cyl(p);
  } else if (cuttype ==2)
  {
    point_ok = point_ok_sph(p);
  } else
    point_ok = point_ok_box(p);
  return point_ok;
}

boolean point_ok_cyl(PVector p)   
{
  boolean point_ok_cyl;
  if ((p.z<=zmax)&&(p.z>=zmin)&&(sq(p.x-xcut)+sq(p.y-ycut)<rcut_square))
    point_ok_cyl =true;
  else 
  point_ok_cyl =false;

  return point_ok_cyl;
}

boolean point_ok_sph(PVector p)   
{
  boolean point_ok_sph;
  if (sq(p.x-xcut)+sq(p.y-ycut)+sq(p.z-zcut)<rcut_square)
    point_ok_sph =true;
  else 
  point_ok_sph =false;

  return point_ok_sph;
}

boolean point_ok_box(PVector p)   
{
  boolean point_ok_box;
  if ((p.x<=xmax)&&(p.x>=xmin)&&(p.y<=ymax)&&(p.y>=ymin)&&(p.z<=zmax)&&(p.z>=zmin))
    point_ok_box =true;
  else 
  point_ok_box =false;

  return point_ok_box;
}

void triangulation(boolean nearpointtest)
{
  PVector _p = new PVector();
  for (int i=0; i<=tfrontnp; i++)
  {
    if (!point_ok(tpoint[tfrontpt[i]].p))
    {
      print("!!!Strating front points not in bounding box!!!\n");
      strokeWeight(10);
      quader(xmin, xmax, ymin, ymax, zmin, zmax);
      strokeWeight(1);
      _p=tpoint[tfrontpt[i]].p;
      point(_p.x, _p.y, _p.z);
      n_triang=0;
      return;
    }
  }  
  for (int k=0; k<=tnfr; k++)
  {
    for (int i=0; i<=k; i++)
    {
      if (!point_ok(tpoint[tfr[k][i]].p))
      {
        print("!!!Boundary points not in bounding box!!!\n");
        strokeWeight(10);
        quader(xmin, xmax, ymin, ymax, zmin, zmax);
        strokeWeight(1);
        _p=tpoint[tfr[k][i]].p;
        point(_p.x, _p.y, _p.z);
        n_triang=0;
        return;
      }
    }
  }

  print("*******************************************\n");
  if (nearpointtest)
    print("trinang.:nearpoint test is ON!\n");
  if (cuttype==1)
    print("triang.:bounded by cylinder\n");
  else if (cuttype==2)
    print("trang.:bounded by sphere\n");
  else
    print("triang.:bounded by o box\n");

  print("********************************\n");
  tstepl_square = tstepl*tstepl;
  fullcount =0;

  while ((tnfr>=0)&&(tnf<n_triang)&&(fullcount<tfrontnp))
  {
    fullcount=0; 
    delay=0;
    minangle=0;
    while (((tnf<n_triang)&&(fullcount<tfrontnp)&&(tfrontnp>3)))
    {  
      if (((!nearpointtest)||(tfrontnp<10)||(minangle<1.5)))
        delay=1;
      if (delay==0)
        find_pair_of_nearpts(ipf1, ipf2, frontnumber);
      else {
        delay=delay-1;
        ipf2=-1;
      }
      if (ipf2>0)
      {
        ipi1=tfrontpt[ipf1];
        if (frontnumber==0)
          ipi2=tfrontpt[ipf2];
        else
          ipi2=tfr[frontnumber][ipf2];
        delay=0;
        print("triangles:'.tnf.' nearpoints detected:'.ipi1.'+++"+ipi2);
        if (frontnumber==0)
          divide_front(ipf1, ipf2);
        if (frontnumber>0)
          unite_front(ipf1, ipf2, frontnumber);
      }

      for (int i=0; i<=tfrontnp; i++)
      {
        make_angle(i);
      }

      ipf=minanglept(); //<>//

      if (ipf>0)
        complete_point(ipf, f_gradf);

      for (int i=0; i<=tfrontnp; i++)
      {
        make_angle(i);
      }
      ipf=minanglept();
      fullcount=0;

      for (int i=0; i<=tfrontnp; i++)
      {
        if (tpoint[tfrontpt[i]].full)
          fullcount=fullcount+1;
      }
    }

    if (tfrontnp==3) {
      new_triangle(tfrontpt[1], tfrontpt[2], tfrontpt[3]);
      tfrontnp=0;
    }

    if (((tfrontnp==0)||(fullcount==tfrontnp))&&(tnfr>0)) 
    {
      tfrontnp=tfr[tnfr][0];

      for (int i=0; i<=tfrontnp; i++)
      {
        tfrontpt[i]=tfr[tnfr][i];
        tpoint[tfrontpt[i]].achange=true;
      }

      tnfr=tnfr-1; 
      fullcount=0;
      print("tnfr:"+tnfr);
    }
  }

  print("*********************************************\n");
  print("triang.: total number of triangles: "+tnf);
  print("triang.: remaining front points: "+tfrontnp);
  print("triang.: remaining fronts: "+ tnfr);
  print("*********************************************\n");
  if (tnf>tnfmax)
    print("triang. warning:tnfmax to small!!!!");
  if (tnp>tnpmax)
    print("triang. warning:tnpmax to small!!!");
  if (tfrontnp>tfrnpmax)
    print("triang. warning: tfrnpmax to small!!!");
  if (tnfr>tnfrmax)
    print("triang. warning: tnfrmax to small!!!");
}


void quader(float _xmin, float _xmax, float _ymin, float _ymax, float _zmin, float _zmax)
{
  PVector p1, p2, p3, p4, p5, p6, p7, p8;

  p1=put3d(_xmin, _ymin, _zmin);
  p2=put3d(_xmax, _ymin, _zmin);
  p3=put3d(_xmax, _ymax, _zmin);
  p4=put3d(_xmin, _ymax, _zmin);
  p5=put3d(_xmin, _ymin, _zmax);
  p6=put3d(_xmax, _ymin, _zmax);
  p7=put3d(_xmax, _ymax, _zmax);
  p8=put3d(_xmin, _ymax, _zmax);

  line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
  line(p2.x, p2.y, p2.z, p3.x, p3.y, p3.z);
  line(p3.x, p3.y, p3.z, p4.x, p4.y, p4.z);
  line(p4.x, p4.y, p4.z, p1.x, p1.y, p1.z);
  line(p5.x, p5.y, p5.z, p6.x, p6.y, p6.z);
  line(p6.x, p6.y, p6.z, p7.x, p7.y, p7.z);
  line(p7.x, p7.y, p7.z, p8.x, p8.y, p8.z);
  line(p8.x, p8.y, p8.z, p5.x, p5.y, p5.z);
  line(p1.x, p1.y, p1.z, p5.x, p5.y, p5.z);
  line(p2.x, p2.y, p2.z, p6.x, p6.y, p6.z);
  line(p3.x, p3.y, p3.z, p7.x, p7.y, p7.z);
  line(p4.x, p4.y, p4.z, p8.x, p8.y, p8.z);
} 

void find_pair_of_nearpts(int _ipf, int _ipf_nearp, int _frontnumber)
{

  int i, k, i1, i2, ip, ipj, inp, tfrontnpi;
  PVector p0 = new PVector();
  _ipf=0; 
  _ipf_nearp=-1; 
  _frontnumber=0;
  for (i=0; i<=tfrontnp; i++)
  {
    inp =test_criticalpt(i);
    if (inp>0) 
    {
      _ipf=i; 
      _ipf_nearp=inp;
      _frontnumber=0;
      return;
    }
  }
  for ( i=0; i<=tnfr; i++)
  {
    tfrontnpi = tfr[i][0];
  label10:
    for ( k =0; k<=tfrontnp; k++)
    {

      ip=tfrontpt[k];
      if (tpoint[ip].full)
        continue label10;
      else
        p0=p;

      for (int j=0; j<=tfrontnpi; j++)
      {
        ipj=tfr[i][j];
        if (abs(p0.x-tpoint[ipj].p.x)<tstepl) {
          if (abs(p0.y-tpoint[ipj].p.y)<tstepl) {
            if (abs(p0.z-tpoint[ipj].p.z)<tstepl) {
              if (distance3d_square(p0, tpoint[ipj].p)<tstepl_square) {
                if (outside(ip, tfrontpt[reduce(k-1)], ipj)) {
                  _frontnumber=i;
                  _ipf=k;
                  _ipf_nearp=j;
                  //frontnumber = _frontnumber;
                  //ipf= _ipf;
                  //ipf_nearp= _ipf_nearp;
                  return;
                }
              }
            }
          }
        }
      }//for j
    }//for k
  }//for i
}


int test_criticalpt(int ipf)
{

  int i, k, ip, ip1, ip2, ip11, ip22, ip111, ip222, ipi, nn;  
  int ipf_nearp;
  PVector p0;

  ip= tfrontpt[ipf];                
  ipf_nearp= -1;    
  if ( tpoint[ip].full)
    return 0; 
  else 
  p0= tpoint[ip].p; 
  if (ipf<3)
    nn= tfrontnp-3+ipf; 
  else 
  nn= tfrontnp;
  //tests only front points i>ipf+3 ! important for divide_front    
label10: 
  for (i=ipf+3; i<=nn; i++) 
  {

    //ipi not neighbor or neighbor of neighbors
    ipi= tfrontpt[i];     
    if (!tpoint[ipi].full) 
    {

      if ( abs(p0.x-tpoint[ipi].p.x)<tstepl) {
        if (abs(p0.y-tpoint[ipi].p.y)<tstepl) {
          if (abs(p0.z-tpoint[ipi].p.z)<tstepl) {    
            if (distance3d_square(p0, tpoint[ipi].p) < tstepl_square) {
              if (!outside(ip, tfrontpt[reduce(ipf-1)], ipi)) 
                continue label10;
              if (scalarp3d(tpoint[ip].nv, tpoint[ipi].nv)<0)
                continue label10;
              ipf_nearp= i;   
              return 0;
            }
          }
        }
      }
    } // if
  }//for
  return ipf_nearp;
}

float distance3d(PVector p, PVector q)
{
  float distance3d= sqrt( sq(p.x-q.x) + sq(p.y-q.y) +sq(p.z-q.z) );
  return distance3d;
}

float distance3d_square(PVector p, PVector q)
{
  float distance3d_square= sq(p.x-q.x) + sq(p.y-q.y) + sq(p.z-q.z);
  return distance3d_square;
}

boolean outside(int ip0, int ip1, int iptest)
{//is point p[iptest] in not triangulated region at point p[ip0] ?
  PVector pn1, pn11, ptest, ptestt;  
  float w1, wtest; 
  boolean outside;


  pn1= tpoint[ip1].p;       
  pn11=newcoordinates3d(pn1, tpoint[ip0].p, tpoint[ip0].tv1, tpoint[ip0].tv2, tpoint[ip0].nv);  
  ptest= tpoint[iptest].p;  
  ptestt=newcoordinates3d(ptest, tpoint[ip0].p, tpoint[ip0].tv1, tpoint[ip0].tv2, tpoint[ip0].nv); 
  w1= polar_angle(pn11.x, pn11.y);    
  wtest=polar_angle(ptestt.x, ptestt.y);     
  if (wtest<w1) 
    wtest= wtest+PI*2;
  if (wtest<w1+tpoint[ip1].angle) 
    outside= true; 
  else outside= false;

  return outside;
}   

float fangle(int ipf)
{//calculates the front angle at ipf-th front point
  PVector pn1, pn2, pn11, pn22;    
  int ip, ip1, ip2;    
  float w1, w2; 
  float fangle;
  ip=  tfrontpt[ipf];    

  ip1= tfrontpt[reduce(ipf-1)]; 
  ip2= tfrontpt[reduce(ipf+1)];  
  pn1= tpoint[ip1].p;  
  pn11=newcoordinates3d(pn1, tpoint[ip].p, tpoint[ip].tv1, tpoint[ip].tv2, tpoint[ip].nv);  
  pn2= tpoint[ip2].p;  
  pn22=newcoordinates3d(pn2, tpoint[ip].p, tpoint[ip].tv1, tpoint[ip].tv2, tpoint[ip].nv); 
  w1= polar_angle(pn11.x, pn11.y);    
  w2= polar_angle(pn22.x, pn22.y);     
  if ( w2<w1)
    w2= w2+TWO_PI;
  fangle= w2-w1;
  return fangle;
}


PVector newcoordinates3d(PVector p, PVector b0, PVector b1, PVector b2, PVector b3)
{//determines the coordinates of p for the basis b1,b2,b3 with origin b0.
  float det;   
  PVector p0 = new PVector();
  PVector pnew =new PVector();

  p0=diff3d(p, b0);              
  det= determ3d(b1, b2, b3);
  pnew.x= determ3d(p0, b2, b3)/det;
  pnew.y= determ3d(b1, p0, b3)/det;
  pnew.z= determ3d(b1, b2, p0)/det;
  //  newcoordinates3d
  return pnew;
}

float determ3d(PVector v1, PVector v2, PVector v3)
{//determinant of 3 vectors.

  float determ3d= v1.x*v2.y*v3.z + v1.y*v2.z*v3.x + v1.z*v2.x*v3.y
    - v1.z*v2.y*v3.x - v1.x*v2.z*v3.y - v1.y*v2.x*v3.z;
  return determ3d;
  //end determ3d
}

float polar_angle(float x, float y)
{// determines the polar angle of point (x,y)
  float polar_angle;
  float w;

  if ((x==0) && (y==0))
    w= 0;
  else
  {
    if (abs(y)<=abs(x)) 
    {
      w= atan(y/x);
      if (x<0) 
        w=PI+w;
      else  if ((y<0) &&( w!=0))
        w= TWO_PI+w;
    } else
    {

      w= HALF_PI-atan(x/y);
      if (y<0) 
        w= PI+w;
    }
  }
  polar_angle= w;
  return polar_angle;
  //end  polar_angle
}

void divide_front(int _ipf1, int _ipf2)
{
  int nn;
  float fa1, fa2;
  tnfr=tnfr+1;
  tpoint[tfrontpt[_ipf1]].achange=true;
  tpoint[tfrontpt[_ipf2]].achange=true;
  for (int i=0; i<=_ipf2-_ipf1; i++)
  {
    tfr[tnfr][i+1] = tfrontpt[_ipf1+i];
  }
  for (int i=0; i<=tfrontnp-_ipf2+1; i++)
  {
    tfrontpt[_ipf1+i] = tfrontpt[_ipf2+i-1];
  }
  tfrontnp=tfrontnp-(_ipf2-_ipf1-1);
  tfr[tnfr][0]=_ipf2-_ipf1+1;
  fa1=fangle(_ipf1);
  fa2=fangle(_ipf1+1);
  if (fa1<fa2)
  {
    nn=tfrontnp;
    complete_point(_ipf1, f_gradf);
    complete_point(_ipf1+tfrontnp-nn+1, f_gradf);
  } else {
    complete_point(_ipf1+1, f_gradf);
    complete_point(_ipf1, f_gradf);
  }
}  

void unite_front(int _ipf1, int _ipf2, int _frontnumber)
{
  int ipf, tfrontnpi, nn;
  float fa1, fa2;
  tfrontnpi=tfr[_frontnumber][0];
  for (int i=0; i<=tfrontnpi; i++)
  {
    ipf = _ipf2+i-1;
    if (ipf>tfrontnpi)
      ipf=ipf-tfrontnpi;
    insert_point(tfr[_frontnumber][ipf], _ipf1+i);
  }
  insert_point(tfrontpt[_ipf1+1], _ipf1+tfrontnpi+1);
  insert_point(tfrontpt[_ipf1], _ipf1+tfrontnpi+2);
  for (int i=0; i<=tnfr; i++)
  {
    tfr[_frontnumber][i]=tfr[tnfr][i];
  }
  tnfr=tnfr-1;
  tpoint[tfrontpt[_ipf1]].achange=true;
  tpoint[tfrontpt[_ipf1]].full=false;
  tpoint[tfrontpt[_ipf1+1]].achange = true;
  tpoint[tfrontpt[_ipf1+1]].full = false;
  fa1= fangle(_ipf1);
  fa2=fangle(_ipf1+1);
  if (fa1<fa2) {
    nn = tfrontnp;
    complete_point(_ipf1, f_gradf);
    complete_point(_ipf1+tfrontnp-nn+1, f_gradf);
  } else {
    complete_point(_ipf1+1, f_gradf);
    complete_point(_ipf1, f_gradf);
  }
}

void make_angle(int _ipf)
{
  //PVector pn1, pn2, pn11, pn22;
  int ip, ip1, ip2;
  float w1, w2;
  ip=tfrontpt[_ipf];
  if (tpoint[ip].full || !tpoint[ip].achange)
    return;
  else {
    ip1=tfrontpt[reduce(_ipf-1)];
    ip2=tfrontpt[reduce(_ipf+1)];
    pn1=tpoint[ip1].p;
    pn11=newcoordinates3d(pn1, tpoint[ip].p, tpoint[ip].tv1, tpoint[ip].tv2, tpoint[ip].nv);
    pn2=tpoint[ip2].p;
    pn22=newcoordinates3d(pn2, tpoint[ip].p, tpoint[ip].tv1, tpoint[ip].tv2, tpoint[ip].nv);
    w1=polar_angle(pn11.x, pn11.y);
    w2=polar_angle(pn22.x, pn22.y);
    if (w2<w1)
      w2=w2+PI;
    tpoint[ip].angle=w2-w1;
    tpoint[ip].achange=false;
  }
}

int minanglept()
{//determines the front point with minimal front angle
  int minanglept;
  int imin=0; 
  float min;
  min=10; //<>//
  for (int i=0; i<=tfrontnp; i++)
  {
    if (((!tpoint[tfrontpt[i]].full)&&(tpoint[tfrontpt[i]].angle<min))) 
    {
      min=tpoint[tfrontpt[i]].angle; 
      imin=i;
    }
  }
  if (min<10)
  {
    minanglept = imin;
    minangle=min;
  } else
  {
    minanglept = -1;
  }

  return minanglept; //<>//
}

void complete_point(int _ipf, implicit3d f_gradf)
{

  //int ip, ip1, ip2, ipf1, ipf2, ne_rest;
  float dw, cdw, sdw; //<>//
  if (tfrontnp<=3)
    return;
  ip=tfrontpt[_ipf]; //<>//
  actual_ip=ip;
  if (tpoint[ip].full)
    return;
  ipf1=reduce(_ipf-1);
  ipf2=reduce(_ipf+1);
  ip1=tfrontpt[ipf1]; 
  ip2=tfrontpt[ipf2];
  pn1=tpoint[ip1].p;
  pn11=newcoordinates3d(pn1, tpoint[ip].p, tpoint[ip].tv1, tpoint[ip].tv2, tpoint[ip].nv);
  pn11.z=0;
  pn11.normalize();
  pn11=scale3d(tstepl, pn11);
  pn2=tpoint[ip2].p;
  pn22=newcoordinates3d(pn2, tpoint[ip].p, tpoint[ip].tv1, tpoint[ip].tv2, tpoint[ip].nv);
  if (tpoint[ip].achange)
    tpoint[ip].angle=fangle(_ipf);
  ne_rest= floor(tpoint[ip].angle*3/PI);
  dw= tpoint[ip].angle/(ne_rest+1);
  if (((dw<0.8)&&(ne_rest>0)))
  {
    ne_rest=ne_rest-1;
    dw=tpoint[ip].angle/(ne_rest+1);
  }
  float distance3d = distance3d(pn1, pn2);
  if (((ne_rest==0)&&(dw>0.8)&&(distance3d>(1.25*tstepl))))
  {
    ne_rest=1; 
    dw=dw/2;
  }
  p0=tpoint[ip].p;
  nv0=tpoint[ip].nv;
  tv10= tpoint[ip].tv1;
  tv20 = tpoint[ip].tv2;
  float distance3d_square = distance3d_square(p0, pn1); //<>//
  float distance3d_square1 =distance3d_square(p0, pn2);
  if (((distance3d_square<(0.2*tstepl_square))||(distance3d_square1<(0.2*tstepl_square))))
  {
    ne_rest=0;
  }
  if (ne_rest==0)
  {
    new_triangle(ip1, ip2, ip);
  } else
  {
    for (int i=0; i<=ne_rest; i++)
    {
      cdw=cos(dw); 
      sdw=sin(dw);
      pn11=rotorz(cdw, sdw, pn11);
      p_start=lcomb3vt3d(1, p0, pn11.x, tv10, pn11.y, tv20);
      tnp=tnp+1;
      tpoint[tnp] = new tpoint_dat();
      if (point_ok(p_start))
      {
        tpoint[tnp].full=false;
        pc_start=p_start;
      } else {
        tpoint[tnp].full=true; 
        pc_start=cut_seg(p0, p_start);
      }
      surface_point_normal_tangentvts(pc_start, f_gradf, tpoint[tnp].p, tpoint[tnp].nv, tpoint[tnp].tv1, tpoint[tnp].tv2, 1);
      float scalarp3d = scalarp3d(tpoint[tnp].nv, tpoint[ip].nv);
      if (scalarp3d<0)
      {
        tpoint[tnp].nv=scale3d(-1, tpoint[tnp].nv);
        //change3d(tpoint[tnp].tv1, tpoint[tnp].tv2);
        PVector temp = new PVector();
        temp = tpoint[tnp].tv1;
        tpoint[tnp].tv1 = tpoint[tnp].tv2;
        tpoint[tnp].tv2 = temp;
      }
      tpoint[tnp].achange=true;
      if (i==1)
        new_triangle(ip1, tnp, ip);
      if (i==ne_rest)  
        new_triangle(tnp, ip2, ip);
      else
        new_triangle(tnp, tnp+1, ip);
    }
    delete_point(_ipf);
    for (int i=0; i<=ne_rest-1; i++)
    {
      insert_point(tnp-i, _ipf);
    }
    tpoint[ip1].achange=true;
    tpoint[ip2].achange=true;
  }
}


PVector cut_seg(PVector p0, PVector p)
{//cuts new edge p0-p at bounding box or cylinder -> p0-pc
  PVector pc= new PVector();

  if (cuttype==1)
    pc=cut_seg_cyl(p0, p);
  else if ( cuttype==2)
    pc=cut_seg_sph(p0, p);              
  else 
  pc=cut_seg_box(p0, p);

  return pc;
}

PVector cut_seg_box(PVector p0, PVector p)
{//cuts new edge p0-p at bounding box -> p0-pc
  PVector pc= new PVector();
  PVector dv = new PVector(); 
  float x0, y0, z0, t;

  dv=diff3d(p, p0);  
  t= 1;  
  //get3d(p0, x0,y0,z0);
  x0=p0.x;
  y0=p0.y;
  z0=p0.z;

  if (dv.x>0) 
    t= min(t, (xmax-x0)/dv.x); 
  else 
  t= min(t, (xmin-x0)/dv.x);

  if (dv.y>0)
    t= min(t, (ymax-y0)/dv.y); 
  else 
  t= min(t, (ymin-y0)/dv.y);

  if ( dv.z>0)
    t= min(t, (zmax-z0)/dv.z);
  else 
  t= min(t, (zmin-z0)/dv.z);

  pc=lcomb2vt3d(1, p0, t, dv);
  return pc;
}

PVector cut_seg_cyl(PVector p0, PVector p)
{//cuts new edge p0-p at bounding cylinder -> p0-pc
  PVector pc= new PVector();
  PVector dv = new PVector(); 
  float t, x0, y0, z0, a, b, d2;

  dv=diff3d(p, p0);  
  t= 1;  
  //get3d(p0, x0,y0,z0);
  x0=p0.x;
  y0=p0.y;
  z0=p0.z;

  if (dv.z>0)
    t= min(t, (zmax-z0)/dv.z); 
  else 
  t= min(t, (zmin-z0)/dv.z);
  d2=dv.x*dv.x+dv.y*dv.y;
  if (d2>0) {
    x0= p0.x-xcut;  
    y0=p0.y-ycut;   
    a= (x0*dv.x+y0*dv.y)/d2;  
    b= (x0*x0+y0*y0-rcut_square)/d2;
    t= min(t, -a+sqrt(a*a-b));
  }

  pc=lcomb2vt3d(1, p0, t, dv); 

  return pc;
}

PVector cut_seg_sph(PVector p0, PVector p)
{//cuts new edge p0-p at bounding sphere -> p0-pc
  PVector pc= new PVector();
  PVector dv = new PVector(); 
  float t, x0, y0, z0, a, b, d2;

  dv=diff3d(p, p0);    
  t= 1;  
  //get3d(p0, x0,y0,z0);
  x0=p0.x;
  y0=p0.y;
  z0=p0.z;

  d2=dv.x*dv.x+dv.y*dv.y+dv.z*dv.z;
  if (d2>0) {

    x0= p0.x-xcut;  
    y0=p0.y-ycut; 
    z0= p0.z-zcut;
    a= (x0*dv.x+y0*dv.y+z0*dv.z)/d2;
    b= (x0*x0+y0*y0+z0*z0-rcut_square)/d2;
    t= min(t, -a+sqrt(a*a-b));
  }

  pc=lcomb2vt3d(1, p0, t, dv); 

  return pc;
}



void insert_point(int ip_new, int i_new)
{//inserts point ip_new as i_new-th front point

  for (int i= tfrontnp+1; i>= i_new; i--) {
    tfrontpt[i+1]=  tfrontpt[i];
  }
  tfrontpt[i_new]= ip_new;  //<>//
  tfrontnp= tfrontnp+1;
}


void delete_point(int i_del)
{//deletes i_del-th front point

  tfrontnp= tfrontnp-1; //<>//
  for (int i= i_del; i<=tfrontnp+1; i++) {
    tfrontpt[i]=  tfrontpt[i+1];
  }
}
 //<>//

void new_triangle(int q1, int q2, int q3)
{
  tface[tnf] = new tface_dat(); //<>//
  tface[tnf].p1=q1;
  tface[tnf].p2=q2;
  tface[tnf].p3=q3;
  tnf=tnf+1;
}


int reduce(int n)
{
  int reduce;
  reduce = n;

  if (n<1)
    reduce = n+tfrontnp;
  if (n>tfrontnp)
    reduce = n-tfrontnp;
  return reduce;
}