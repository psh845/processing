import processing.opengl.*; //<>// //<>// //<>// //<>// //<>// //<>//

PShape tri; 

float[][][] table;

int wid_img =0;
int heg_img =0;
float g_size =0;


FloatList curve_x;
FloatList curve_y;
FloatList curve_z;
FloatList curve_radius;
FloatList curve_weight;
FloatList curve_Cr;
FloatList curve_Cg;
FloatList curve_Cb;
FloatList curve_r;

float threshold;
int a;
int b;
String s;

PVector c;
PVector[][][] C_list;

int numSegments;
int CpNum;
int hNum;

PVector [][][]VerCube;

void setup()
{
  size(500, 500, P3D);

  g_size = 20.0;
  wid_img = ceil(width/g_size);
  heg_img = ceil(height/g_size);


  curve_x = new FloatList();
  curve_y = new FloatList();
  curve_z = new FloatList();
  curve_radius = new FloatList();
  curve_weight = new FloatList();
  curve_Cr = new FloatList();
  curve_Cg = new FloatList();
  curve_Cb = new FloatList();
  curve_r = new FloatList();

  noLoop();
  noStroke();
  smooth();
  threshold =1.0;
  a=0;

  numSegments = 4;
  CpNum =1;
  hNum =4;

  VerCube = new PVector[hNum][(numSegments*4)*CpNum+1][(numSegments)*4+1];
  table = new float[hNum][(numSegments*4)*CpNum+1][numSegments*4+1];
  C_list = new PVector[hNum][(numSegments*4)*CpNum+1][numSegments*4+1];

  //for (int i=0; i< hNum; i++)
  //{
  //  for (int j=0; j< (numSegments*4)*CpNum+1; j++)
  // {
  //  for (int k=0; k< numSegments*4+1; k++)
  //   {
  //     VerCube[i][j][k] = new PVector();
  //     C_list[i][j][k] = new PVector();
  //   }

  // }
  //}
}

void draw()
{
  // mouseX = int(width/7);
  //mouseY = int(height/10);


  //translate(0, 0, 0);
  //rotateY(radians(60));
  background(0);

  // lights();

  //float camZ=(height/2.0)/tan(PI*50.0/360.0);
  //camera(mouseX*2.0, mouseY*2.0, camZ, width/2.0, height/2.0, 0, 0, 1, 0);



  noFill();
  //Grid_cube(wid_img, heg_img, g_size, g_size);

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
  curve_radius.append(50);
  curve_radius.append(70);
   curve_radius.append(90);
  curve_weight.append(2.0);
  curve_Cr.append(0.0);
  curve_Cg.append(200.0);
  curve_Cb.append(0.0);

  curve_r.append(90);

  bezier(curve_x.get(0), curve_y.get(0), curve_z.get(0), curve_x.get(1), curve_y.get(1), curve_z.get(1), 
    curve_x.get(2), curve_y.get(2), curve_z.get(2), curve_x.get(3), curve_y.get(3), curve_z.get(3));


  print(curve_x.size());
  CURCLECUBE curclecube = new CURCLECUBE();
  curclecube.segset(numSegments, CpNum, hNum);
  curclecube.Position(curve_x, curve_y, curve_z);
  curclecube.rad(curve_radius);
  curclecube.MC_normal(hNum);
  curclecube.setCube(hNum); //<>//


  for (int i=0; i< hNum; i++)
  {
    for (int j=0; j<= (numSegments*4)*CpNum; j++)
    {
      for (int k=0; k<= numSegments*4; k++)
      {
        VerCube[i][j][k] = new PVector();
        VerCube[i][j][k].set(curclecube.vcube(i, j, k));
        //C_list[i][j][k] = new PVector();
        c = new PVector(0.0, 0.0, 0.0);
        float sum = metaball_curve(VerCube[i][j][k].x, VerCube[i][j][k].y, VerCube[i][j][k].z, 0);
        C_list[i][j][k] = new PVector(c.x, c.y, c.z);   
        table[i][j][k] = sum;
        print(table[i][j][k] + "\t");
      }
    }
  }


  for (int i=0; i< hNum-1; i++) //<>//
  {
   for (int j=0; j< (numSegments*4)*CpNum; j++)
   {
     for (int k=0; k< numSegments*4; k++)
     {
       GRIDCELL gridcell = new GRIDCELL();
       gridcell.set(VerCube[i][j][k].x, VerCube[i][j][k].y, VerCube[i][j][k].z, table[i][j][k]);
       gridcell.set(VerCube[i][j+1][k].x, VerCube[i][j+1][k].y, VerCube[i][j+1][k].z, table[i][j+1][k]);
       gridcell.set(VerCube[i][j+1][k+1].x, VerCube[i][j+1][k+1].y, VerCube[i][j+1][k+1].z, table[i][j+1][k+1]);
       gridcell.set(VerCube[i][j][k+1].x, VerCube[i][j][k+1].y, VerCube[i][j][k+1].z, table[i][j][k+1]);

       gridcell.set(VerCube[i+1][j][k].x, VerCube[i+1][j][k].y, VerCube[i+1][j][k].z, table[i+1][j][k]);
       gridcell.set(VerCube[i+1][j+1][k].x, VerCube[i+1][j+1][k].y, VerCube[i+1][j+1][k].z, table[i+1][j+1][k]);
       gridcell.set(VerCube[i+1][j+1][k+1].x, VerCube[i+1][j+1][k+1].y, VerCube[i+1][j+1][k+1].z, table[i+1][j+1][k+1]);
       gridcell.set(VerCube[i+1][j][k+1].x, VerCube[i+1][j][k+1].y, VerCube[i+1][j][k+1].z, table[i+1][j][k+1]);


       gridcell.setColor(C_list[i][j][k]);
       gridcell.setColor(C_list[i][j+1][k]);
       gridcell.setColor(C_list[i][j+1][k+1]);
       gridcell.setColor(C_list[i][j][k+1]);

       gridcell.setColor(C_list[i+1][j][k]);
       gridcell.setColor(C_list[i+1][j+1][k]);
       gridcell.setColor(C_list[i+1][j+1][k+1]);
       gridcell.setColor(C_list[i+1][j][k+1]);

       gridcell.divColor();

       Marchint_Cube(threshold, gridcell); //<>//
     }
   }
  }


  //  translate(width/2.0, height/2.0, -width);
}

void Grid_cube(float wid_img, float heg_img, float squre_size, float g_size)
{
  //stroke(100);
  for (int i=0; i< wid_img; i++)
  {
    for (int j=0; j< heg_img; j++)
    {
      for (int k=0; k< wid_img; k++)
      {
        pushMatrix();
        translate(i*g_size+g_size/2.0, j*g_size+g_size/2.0, k*g_size+g_size/2.0);
        box(squre_size, squre_size, squre_size);
        popMatrix();
      }
    }
  }
}

void Grid_circle(float g_size, int radius, float x, float y, float z)
{
  pushMatrix();
  translate(x*g_size, y*g_size, z*g_size);
  sphere(radius);
  popMatrix();
}



float metaball_curve(float x, float y, float z, int button)
{

  float sum= 0.0;

  float d = 0.0;
  float dd = 0.0;

  float r =0.0;

  float w =0.0;
  //c = new PVector(0.0,0.0,0.0);

  for (int n=0; n<curve_r.size(); n++)
  {

    PVector p = new PVector(x, y, z);
    PVector p0 = new PVector(curve_x.get(n*4), curve_y.get(n*4), curve_z.get(n*4));
    PVector p1 = new PVector(curve_x.get(n*4+1), curve_y.get(n*4+1), curve_z.get(n*4+1));
    PVector p2 = new PVector(curve_x.get(n*4+2), curve_y.get(n*4+2), curve_z.get(n*4+2));
    PVector p3 = new PVector(curve_x.get(n*4+3), curve_y.get(n*4+3), curve_z.get(n*4+3));
    PVector pf = new PVector(p0.x, p0.y, p0.z);
    PVector pt = new PVector(p0.x, p0.y, p0.z);



    for ( float t = 0; t <= 1.0; t += 0.05 )
    { 
      t= floor(t*100)*0.01;
      float b0 = (1 - t) * (1 - t) * (1 - t); 
      float b1 = 3 * t * (1 - t) * (1 - t); 
      float b2 = 3 * t * t * (1 - t); 
      float b3 = t * t * t; 
      pt.x = p0.x * b0 + p1.x * b1 + p2.x * b2 + p3.x * b3; 
      pt.y = p0.y * b0 + p1.y * b1 + p2.y * b2 + p3.y * b3; 
      pt.z = p0.z * b0 + p1.z * b1 + p2.z * b2 + p3.z * b3;

      //pt.x = p0.x*((1-t)*(1-t)*(1-t)) + p1.x*(3*t)*((1-t)*(1-t))+p2.x*3*(1-t)*(t*t)+ p3.x*(t*t*t);
      //pt.y = p0.y*((1-t)*(1-t)*(1-t)) + p1.y*(3*t)*((1-t)*(1-t))+p2.y*3*(1-t)*(t*t)+ p3.y*(t*t*t);
      //pt.z = p0.z*((1-t)*(1-t)*(1-t)) + p1.z*(3*t)*((1-t)*(1-t))+p2.z*3*(1-t)*(t*t)+ p3.z*(t*t*t);
      PVector v = new PVector(pt.x, pt.y, pt.z);
      v.sub(pf);
      PVector tt = new PVector(p.x, p.y, p.z);
      tt.sub(pf);
      float a = tt.dot(v)/v.dot(v);
      v.mult(a);
      v.add(pf);

      if (a<=0)
      {
        dd = sqrt(sq(p.x - pf.x) + sq(p.y - pf.y) + sq(p.z - pf.z));
      } else if (a>0 && a<1)
      {
        dd = sqrt(sq(p.x - v.x) + sq(p.y - v.y) + sq(p.z - v.z));
      } else
      {
        dd = sqrt(sq(p.x - pt.x) + sq(p.y - pt.y) + sq(p.z - pt.z));
      }


      if (t==0)
        d=dd;
      else
      {
        if (dd<d)
          d= dd;
      }

      if (t<=1.0)
      {
        pf.x= pt.x;
        pf.y = pt.y;
      }
    }

    r = curve_r.get(n);

    switch(button)
    {
    case 0:
      /*meta ball*/
      if (d>=0 && d<=r/3)
      {
        w= curve_weight.get(n)*(1-((3*sq(d))/sq(r)));
        sum +=w;
        ColorMeta_curve(w, n);
      } else if (d>r/3 && d<=r)
      {
        w= (3*curve_weight.get(n)/2)*sq(1-(d/r));
        sum +=w;
        ColorMeta_curve(w, n);
      } else
      {
        w=0;
        sum+= w;
      }
      //print("metaball"+"\t");
      s = "metaball";
      break;
    case 1:
      /*Soft Objects*/
      if (d>=0 && d<=r)
      {
        w = curve_weight.get(n)*(1-(4*pow(d, 6)/(9*pow(r, 6)))+(17*pow(d, 4)/(9*pow(r, 4)))-(22*pow(d, 2)/(9*pow(r, 2))));
        sum +=w;
        ColorMeta_curve(w, n);
        print(sum);
      } else
      {
        w=0;
        sum+=w;
      }
      //print("Soft Objects"+"\t");
      s = "Soft Objects";         
      break;
    default:
      s= "no metaball";
      //print("no metaball type: 0.metaball    1.Soft Objects");
    }
    //print(x+","+y+":"+int(sum)+"\t"); //<>//
  }
  //print(x+","+y+":"+int(sum)+"\t"); //<>//
  //return d;
  return sum ;
}


int Marchint_Cube(float isolevel, GRIDCELL grid )
{

  int edgeTable[]={
    0x0, 0x109, 0x203, 0x30a, 0x406, 0x50f, 0x605, 0x70c, 
    0x80c, 0x905, 0xa0f, 0xb06, 0xc0a, 0xd03, 0xe09, 0xf00, 
    0x190, 0x99, 0x393, 0x29a, 0x596, 0x49f, 0x795, 0x69c, 
    0x99c, 0x895, 0xb9f, 0xa96, 0xd9a, 0xc93, 0xf99, 0xe90, 
    0x230, 0x339, 0x33, 0x13a, 0x636, 0x73f, 0x435, 0x53c, 
    0xa3c, 0xb35, 0x83f, 0x936, 0xe3a, 0xf33, 0xc39, 0xd30, 
    0x3a0, 0x2a9, 0x1a3, 0xaa, 0x7a6, 0x6af, 0x5a5, 0x4ac, 
    0xbac, 0xaa5, 0x9af, 0x8a6, 0xfaa, 0xea3, 0xda9, 0xca0, 
    0x460, 0x569, 0x663, 0x76a, 0x66, 0x16f, 0x265, 0x36c, 
    0xc6c, 0xd65, 0xe6f, 0xf66, 0x86a, 0x963, 0xa69, 0xb60, 
    0x5f0, 0x4f9, 0x7f3, 0x6fa, 0x1f6, 0xff, 0x3f5, 0x2fc, 
    0xdfc, 0xcf5, 0xfff, 0xef6, 0x9fa, 0x8f3, 0xbf9, 0xaf0, 
    0x650, 0x759, 0x453, 0x55a, 0x256, 0x35f, 0x55, 0x15c, 
    0xe5c, 0xf55, 0xc5f, 0xd56, 0xa5a, 0xb53, 0x859, 0x950, 
    0x7c0, 0x6c9, 0x5c3, 0x4ca, 0x3c6, 0x2cf, 0x1c5, 0xcc, 
    0xfcc, 0xec5, 0xdcf, 0xcc6, 0xbca, 0xac3, 0x9c9, 0x8c0, 
    0x8c0, 0x9c9, 0xac3, 0xbca, 0xcc6, 0xdcf, 0xec5, 0xfcc, 
    0xcc, 0x1c5, 0x2cf, 0x3c6, 0x4ca, 0x5c3, 0x6c9, 0x7c0, 
    0x950, 0x859, 0xb53, 0xa5a, 0xd56, 0xc5f, 0xf55, 0xe5c, 
    0x15c, 0x55, 0x35f, 0x256, 0x55a, 0x453, 0x759, 0x650, 
    0xaf0, 0xbf9, 0x8f3, 0x9fa, 0xef6, 0xfff, 0xcf5, 0xdfc, 
    0x2fc, 0x3f5, 0xff, 0x1f6, 0x6fa, 0x7f3, 0x4f9, 0x5f0, 
    0xb60, 0xa69, 0x963, 0x86a, 0xf66, 0xe6f, 0xd65, 0xc6c, 
    0x36c, 0x265, 0x16f, 0x66, 0x76a, 0x663, 0x569, 0x460, 
    0xca0, 0xda9, 0xea3, 0xfaa, 0x8a6, 0x9af, 0xaa5, 0xbac,  //<>//
    0x4ac, 0x5a5, 0x6af, 0x7a6, 0xaa, 0x1a3, 0x2a9, 0x3a0, 
    0xd30, 0xc39, 0xf33, 0xe3a, 0x936, 0x83f, 0xb35, 0xa3c, 
    0x53c, 0x435, 0x73f, 0x636, 0x13a, 0x33, 0x339, 0x230, 
    0xe90, 0xf99, 0xc93, 0xd9a, 0xa96, 0xb9f, 0x895, 0x99c, 
    0x69c, 0x795, 0x49f, 0x596, 0x29a, 0x393, 0x99, 0x190, 
    0xf00, 0xe09, 0xd03, 0xc0a, 0xb06, 0xa0f, 0x905, 0x80c, 
    0x70c, 0x605, 0x50f, 0x406, 0x30a, 0x203, 0x109, 0x0   };

  int triTable[][] =
    {{-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {0, 8, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {0, 1, 9, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {1, 8, 3, 9, 8, 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {1, 2, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {0, 8, 3, 1, 2, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {9, 2, 10, 0, 2, 9, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {2, 8, 3, 2, 10, 8, 10, 9, 8, -1, -1, -1, -1, -1, -1, -1}, 
    {3, 11, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {0, 11, 2, 8, 11, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {1, 9, 0, 2, 3, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {1, 11, 2, 1, 9, 11, 9, 8, 11, -1, -1, -1, -1, -1, -1, -1}, 
    {3, 10, 1, 11, 10, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {0, 10, 1, 0, 8, 10, 8, 11, 10, -1, -1, -1, -1, -1, -1, -1}, 
    {3, 9, 0, 3, 11, 9, 11, 10, 9, -1, -1, -1, -1, -1, -1, -1}, 
    {9, 8, 10, 10, 8, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {4, 7, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {4, 3, 0, 7, 3, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {0, 1, 9, 8, 4, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {4, 1, 9, 4, 7, 1, 7, 3, 1, -1, -1, -1, -1, -1, -1, -1}, 
    {1, 2, 10, 8, 4, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {3, 4, 7, 3, 0, 4, 1, 2, 10, -1, -1, -1, -1, -1, -1, -1}, 
    {9, 2, 10, 9, 0, 2, 8, 4, 7, -1, -1, -1, -1, -1, -1, -1}, 
    {2, 10, 9, 2, 9, 7, 2, 7, 3, 7, 9, 4, -1, -1, -1, -1}, 
    {8, 4, 7, 3, 11, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {11, 4, 7, 11, 2, 4, 2, 0, 4, -1, -1, -1, -1, -1, -1, -1}, 
    {9, 0, 1, 8, 4, 7, 2, 3, 11, -1, -1, -1, -1, -1, -1, -1}, 
    {4, 7, 11, 9, 4, 11, 9, 11, 2, 9, 2, 1, -1, -1, -1, -1}, 
    {3, 10, 1, 3, 11, 10, 7, 8, 4, -1, -1, -1, -1, -1, -1, -1}, 
    {1, 11, 10, 1, 4, 11, 1, 0, 4, 7, 11, 4, -1, -1, -1, -1}, 
    {4, 7, 8, 9, 0, 11, 9, 11, 10, 11, 0, 3, -1, -1, -1, -1}, 
    {4, 7, 11, 4, 11, 9, 9, 11, 10, -1, -1, -1, -1, -1, -1, -1}, 
    {9, 5, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {9, 5, 4, 0, 8, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {0, 5, 4, 1, 5, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {8, 5, 4, 8, 3, 5, 3, 1, 5, -1, -1, -1, -1, -1, -1, -1}, 
    {1, 2, 10, 9, 5, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {3, 0, 8, 1, 2, 10, 4, 9, 5, -1, -1, -1, -1, -1, -1, -1}, 
    {5, 2, 10, 5, 4, 2, 4, 0, 2, -1, -1, -1, -1, -1, -1, -1}, 
    {2, 10, 5, 3, 2, 5, 3, 5, 4, 3, 4, 8, -1, -1, -1, -1}, 
    {9, 5, 4, 2, 3, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {0, 11, 2, 0, 8, 11, 4, 9, 5, -1, -1, -1, -1, -1, -1, -1}, 
    {0, 5, 4, 0, 1, 5, 2, 3, 11, -1, -1, -1, -1, -1, -1, -1}, 
    {2, 1, 5, 2, 5, 8, 2, 8, 11, 4, 8, 5, -1, -1, -1, -1}, 
    {10, 3, 11, 10, 1, 3, 9, 5, 4, -1, -1, -1, -1, -1, -1, -1}, 
    {4, 9, 5, 0, 8, 1, 8, 10, 1, 8, 11, 10, -1, -1, -1, -1}, 
    {5, 4, 0, 5, 0, 11, 5, 11, 10, 11, 0, 3, -1, -1, -1, -1}, 
    {5, 4, 8, 5, 8, 10, 10, 8, 11, -1, -1, -1, -1, -1, -1, -1}, 
    {9, 7, 8, 5, 7, 9, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {9, 3, 0, 9, 5, 3, 5, 7, 3, -1, -1, -1, -1, -1, -1, -1}, 
    {0, 7, 8, 0, 1, 7, 1, 5, 7, -1, -1, -1, -1, -1, -1, -1}, 
    {1, 5, 3, 3, 5, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {9, 7, 8, 9, 5, 7, 10, 1, 2, -1, -1, -1, -1, -1, -1, -1}, 
    {10, 1, 2, 9, 5, 0, 5, 3, 0, 5, 7, 3, -1, -1, -1, -1}, 
    {8, 0, 2, 8, 2, 5, 8, 5, 7, 10, 5, 2, -1, -1, -1, -1}, 
    {2, 10, 5, 2, 5, 3, 3, 5, 7, -1, -1, -1, -1, -1, -1, -1}, 
    {7, 9, 5, 7, 8, 9, 3, 11, 2, -1, -1, -1, -1, -1, -1, -1}, 
    {9, 5, 7, 9, 7, 2, 9, 2, 0, 2, 7, 11, -1, -1, -1, -1}, 
    {2, 3, 11, 0, 1, 8, 1, 7, 8, 1, 5, 7, -1, -1, -1, -1}, 
    {11, 2, 1, 11, 1, 7, 7, 1, 5, -1, -1, -1, -1, -1, -1, -1}, 
    {9, 5, 8, 8, 5, 7, 10, 1, 3, 10, 3, 11, -1, -1, -1, -1}, 
    {5, 7, 0, 5, 0, 9, 7, 11, 0, 1, 0, 10, 11, 10, 0, -1}, 
    {11, 10, 0, 11, 0, 3, 10, 5, 0, 8, 0, 7, 5, 7, 0, -1}, 
    {11, 10, 5, 7, 11, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {10, 6, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {0, 8, 3, 5, 10, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {9, 0, 1, 5, 10, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {1, 8, 3, 1, 9, 8, 5, 10, 6, -1, -1, -1, -1, -1, -1, -1}, 
    {1, 6, 5, 2, 6, 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {1, 6, 5, 1, 2, 6, 3, 0, 8, -1, -1, -1, -1, -1, -1, -1}, 
    {9, 6, 5, 9, 0, 6, 0, 2, 6, -1, -1, -1, -1, -1, -1, -1}, 
    {5, 9, 8, 5, 8, 2, 5, 2, 6, 3, 2, 8, -1, -1, -1, -1}, 
    {2, 3, 11, 10, 6, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {11, 0, 8, 11, 2, 0, 10, 6, 5, -1, -1, -1, -1, -1, -1, -1}, 
    {0, 1, 9, 2, 3, 11, 5, 10, 6, -1, -1, -1, -1, -1, -1, -1}, 
    {5, 10, 6, 1, 9, 2, 9, 11, 2, 9, 8, 11, -1, -1, -1, -1}, 
    {6, 3, 11, 6, 5, 3, 5, 1, 3, -1, -1, -1, -1, -1, -1, -1}, 
    {0, 8, 11, 0, 11, 5, 0, 5, 1, 5, 11, 6, -1, -1, -1, -1}, 
    {3, 11, 6, 0, 3, 6, 0, 6, 5, 0, 5, 9, -1, -1, -1, -1}, 
    {6, 5, 9, 6, 9, 11, 11, 9, 8, -1, -1, -1, -1, -1, -1, -1}, 
    {5, 10, 6, 4, 7, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {4, 3, 0, 4, 7, 3, 6, 5, 10, -1, -1, -1, -1, -1, -1, -1}, 
    {1, 9, 0, 5, 10, 6, 8, 4, 7, -1, -1, -1, -1, -1, -1, -1}, 
    {10, 6, 5, 1, 9, 7, 1, 7, 3, 7, 9, 4, -1, -1, -1, -1}, 
    {6, 1, 2, 6, 5, 1, 4, 7, 8, -1, -1, -1, -1, -1, -1, -1}, 
    {1, 2, 5, 5, 2, 6, 3, 0, 4, 3, 4, 7, -1, -1, -1, -1}, 
    {8, 4, 7, 9, 0, 5, 0, 6, 5, 0, 2, 6, -1, -1, -1, -1}, 
    {7, 3, 9, 7, 9, 4, 3, 2, 9, 5, 9, 6, 2, 6, 9, -1}, 
    {3, 11, 2, 7, 8, 4, 10, 6, 5, -1, -1, -1, -1, -1, -1, -1}, 
    {5, 10, 6, 4, 7, 2, 4, 2, 0, 2, 7, 11, -1, -1, -1, -1}, 
    {0, 1, 9, 4, 7, 8, 2, 3, 11, 5, 10, 6, -1, -1, -1, -1}, 
    {9, 2, 1, 9, 11, 2, 9, 4, 11, 7, 11, 4, 5, 10, 6, -1}, 
    {8, 4, 7, 3, 11, 5, 3, 5, 1, 5, 11, 6, -1, -1, -1, -1}, 
    {5, 1, 11, 5, 11, 6, 1, 0, 11, 7, 11, 4, 0, 4, 11, -1}, 
    {0, 5, 9, 0, 6, 5, 0, 3, 6, 11, 6, 3, 8, 4, 7, -1}, 
    {6, 5, 9, 6, 9, 11, 4, 7, 9, 7, 11, 9, -1, -1, -1, -1}, 
    {10, 4, 9, 6, 4, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {4, 10, 6, 4, 9, 10, 0, 8, 3, -1, -1, -1, -1, -1, -1, -1}, 
    {10, 0, 1, 10, 6, 0, 6, 4, 0, -1, -1, -1, -1, -1, -1, -1}, 
    {8, 3, 1, 8, 1, 6, 8, 6, 4, 6, 1, 10, -1, -1, -1, -1}, 
    {1, 4, 9, 1, 2, 4, 2, 6, 4, -1, -1, -1, -1, -1, -1, -1}, 
    {3, 0, 8, 1, 2, 9, 2, 4, 9, 2, 6, 4, -1, -1, -1, -1}, 
    {0, 2, 4, 4, 2, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {8, 3, 2, 8, 2, 4, 4, 2, 6, -1, -1, -1, -1, -1, -1, -1}, 
    {10, 4, 9, 10, 6, 4, 11, 2, 3, -1, -1, -1, -1, -1, -1, -1}, 
    {0, 8, 2, 2, 8, 11, 4, 9, 10, 4, 10, 6, -1, -1, -1, -1}, 
    {3, 11, 2, 0, 1, 6, 0, 6, 4, 6, 1, 10, -1, -1, -1, -1}, 
    {6, 4, 1, 6, 1, 10, 4, 8, 1, 2, 1, 11, 8, 11, 1, -1}, 
    {9, 6, 4, 9, 3, 6, 9, 1, 3, 11, 6, 3, -1, -1, -1, -1}, 
    {8, 11, 1, 8, 1, 0, 11, 6, 1, 9, 1, 4, 6, 4, 1, -1}, 
    {3, 11, 6, 3, 6, 0, 0, 6, 4, -1, -1, -1, -1, -1, -1, -1}, 
    {6, 4, 8, 11, 6, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {7, 10, 6, 7, 8, 10, 8, 9, 10, -1, -1, -1, -1, -1, -1, -1}, 
    {0, 7, 3, 0, 10, 7, 0, 9, 10, 6, 7, 10, -1, -1, -1, -1}, 
    {10, 6, 7, 1, 10, 7, 1, 7, 8, 1, 8, 0, -1, -1, -1, -1}, 
    {10, 6, 7, 10, 7, 1, 1, 7, 3, -1, -1, -1, -1, -1, -1, -1}, 
    {1, 2, 6, 1, 6, 8, 1, 8, 9, 8, 6, 7, -1, -1, -1, -1}, 
    {2, 6, 9, 2, 9, 1, 6, 7, 9, 0, 9, 3, 7, 3, 9, -1}, 
    {7, 8, 0, 7, 0, 6, 6, 0, 2, -1, -1, -1, -1, -1, -1, -1}, 
    {7, 3, 2, 6, 7, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {2, 3, 11, 10, 6, 8, 10, 8, 9, 8, 6, 7, -1, -1, -1, -1}, 
    {2, 0, 7, 2, 7, 11, 0, 9, 7, 6, 7, 10, 9, 10, 7, -1}, 
    {1, 8, 0, 1, 7, 8, 1, 10, 7, 6, 7, 10, 2, 3, 11, -1}, 
    {11, 2, 1, 11, 1, 7, 10, 6, 1, 6, 7, 1, -1, -1, -1, -1}, 
    {8, 9, 6, 8, 6, 7, 9, 1, 6, 11, 6, 3, 1, 3, 6, -1}, 
    {0, 9, 1, 11, 6, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {7, 8, 0, 7, 0, 6, 3, 11, 0, 11, 6, 0, -1, -1, -1, -1}, 
    {7, 11, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {7, 6, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {3, 0, 8, 11, 7, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {0, 1, 9, 11, 7, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {8, 1, 9, 8, 3, 1, 11, 7, 6, -1, -1, -1, -1, -1, -1, -1}, 
    {10, 1, 2, 6, 11, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {1, 2, 10, 3, 0, 8, 6, 11, 7, -1, -1, -1, -1, -1, -1, -1}, 
    {2, 9, 0, 2, 10, 9, 6, 11, 7, -1, -1, -1, -1, -1, -1, -1}, 
    {6, 11, 7, 2, 10, 3, 10, 8, 3, 10, 9, 8, -1, -1, -1, -1}, 
    {7, 2, 3, 6, 2, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {7, 0, 8, 7, 6, 0, 6, 2, 0, -1, -1, -1, -1, -1, -1, -1}, 
    {2, 7, 6, 2, 3, 7, 0, 1, 9, -1, -1, -1, -1, -1, -1, -1}, 
    {1, 6, 2, 1, 8, 6, 1, 9, 8, 8, 7, 6, -1, -1, -1, -1}, 
    {10, 7, 6, 10, 1, 7, 1, 3, 7, -1, -1, -1, -1, -1, -1, -1}, 
    {10, 7, 6, 1, 7, 10, 1, 8, 7, 1, 0, 8, -1, -1, -1, -1}, 
    {0, 3, 7, 0, 7, 10, 0, 10, 9, 6, 10, 7, -1, -1, -1, -1}, 
    {7, 6, 10, 7, 10, 8, 8, 10, 9, -1, -1, -1, -1, -1, -1, -1}, 
    {6, 8, 4, 11, 8, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {3, 6, 11, 3, 0, 6, 0, 4, 6, -1, -1, -1, -1, -1, -1, -1}, 
    {8, 6, 11, 8, 4, 6, 9, 0, 1, -1, -1, -1, -1, -1, -1, -1}, 
    {9, 4, 6, 9, 6, 3, 9, 3, 1, 11, 3, 6, -1, -1, -1, -1}, 
    {6, 8, 4, 6, 11, 8, 2, 10, 1, -1, -1, -1, -1, -1, -1, -1}, 
    {1, 2, 10, 3, 0, 11, 0, 6, 11, 0, 4, 6, -1, -1, -1, -1}, 
    {4, 11, 8, 4, 6, 11, 0, 2, 9, 2, 10, 9, -1, -1, -1, -1}, 
    {10, 9, 3, 10, 3, 2, 9, 4, 3, 11, 3, 6, 4, 6, 3, -1}, 
    {8, 2, 3, 8, 4, 2, 4, 6, 2, -1, -1, -1, -1, -1, -1, -1}, 
    {0, 4, 2, 4, 6, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {1, 9, 0, 2, 3, 4, 2, 4, 6, 4, 3, 8, -1, -1, -1, -1}, 
    {1, 9, 4, 1, 4, 2, 2, 4, 6, -1, -1, -1, -1, -1, -1, -1}, 
    {8, 1, 3, 8, 6, 1, 8, 4, 6, 6, 10, 1, -1, -1, -1, -1}, 
    {10, 1, 0, 10, 0, 6, 6, 0, 4, -1, -1, -1, -1, -1, -1, -1}, 
    {4, 6, 3, 4, 3, 8, 6, 10, 3, 0, 3, 9, 10, 9, 3, -1}, 
    {10, 9, 4, 6, 10, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {4, 9, 5, 7, 6, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {0, 8, 3, 4, 9, 5, 11, 7, 6, -1, -1, -1, -1, -1, -1, -1}, 
    {5, 0, 1, 5, 4, 0, 7, 6, 11, -1, -1, -1, -1, -1, -1, -1}, 
    {11, 7, 6, 8, 3, 4, 3, 5, 4, 3, 1, 5, -1, -1, -1, -1}, 
    {9, 5, 4, 10, 1, 2, 7, 6, 11, -1, -1, -1, -1, -1, -1, -1}, 
    {6, 11, 7, 1, 2, 10, 0, 8, 3, 4, 9, 5, -1, -1, -1, -1}, 
    {7, 6, 11, 5, 4, 10, 4, 2, 10, 4, 0, 2, -1, -1, -1, -1}, 
    {3, 4, 8, 3, 5, 4, 3, 2, 5, 10, 5, 2, 11, 7, 6, -1}, 
    {7, 2, 3, 7, 6, 2, 5, 4, 9, -1, -1, -1, -1, -1, -1, -1}, 
    {9, 5, 4, 0, 8, 6, 0, 6, 2, 6, 8, 7, -1, -1, -1, -1}, 
    {3, 6, 2, 3, 7, 6, 1, 5, 0, 5, 4, 0, -1, -1, -1, -1}, 
    {6, 2, 8, 6, 8, 7, 2, 1, 8, 4, 8, 5, 1, 5, 8, -1}, 
    {9, 5, 4, 10, 1, 6, 1, 7, 6, 1, 3, 7, -1, -1, -1, -1}, 
    {1, 6, 10, 1, 7, 6, 1, 0, 7, 8, 7, 0, 9, 5, 4, -1}, 
    {4, 0, 10, 4, 10, 5, 0, 3, 10, 6, 10, 7, 3, 7, 10, -1}, 
    {7, 6, 10, 7, 10, 8, 5, 4, 10, 4, 8, 10, -1, -1, -1, -1}, 
    {6, 9, 5, 6, 11, 9, 11, 8, 9, -1, -1, -1, -1, -1, -1, -1}, 
    {3, 6, 11, 0, 6, 3, 0, 5, 6, 0, 9, 5, -1, -1, -1, -1}, 
    {0, 11, 8, 0, 5, 11, 0, 1, 5, 5, 6, 11, -1, -1, -1, -1}, 
    {6, 11, 3, 6, 3, 5, 5, 3, 1, -1, -1, -1, -1, -1, -1, -1}, 
    {1, 2, 10, 9, 5, 11, 9, 11, 8, 11, 5, 6, -1, -1, -1, -1}, 
    {0, 11, 3, 0, 6, 11, 0, 9, 6, 5, 6, 9, 1, 2, 10, -1}, 
    {11, 8, 5, 11, 5, 6, 8, 0, 5, 10, 5, 2, 0, 2, 5, -1}, 
    {6, 11, 3, 6, 3, 5, 2, 10, 3, 10, 5, 3, -1, -1, -1, -1}, 
    {5, 8, 9, 5, 2, 8, 5, 6, 2, 3, 8, 2, -1, -1, -1, -1}, 
    {9, 5, 6, 9, 6, 0, 0, 6, 2, -1, -1, -1, -1, -1, -1, -1}, 
    {1, 5, 8, 1, 8, 0, 5, 6, 8, 3, 8, 2, 6, 2, 8, -1}, 
    {1, 5, 6, 2, 1, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {1, 3, 6, 1, 6, 10, 3, 8, 6, 5, 6, 9, 8, 9, 6, -1}, 
    {10, 1, 0, 10, 0, 6, 9, 5, 0, 5, 6, 0, -1, -1, -1, -1}, 
    {0, 3, 8, 5, 6, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {10, 5, 6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {11, 5, 10, 7, 5, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {11, 5, 10, 11, 7, 5, 8, 3, 0, -1, -1, -1, -1, -1, -1, -1}, 
    {5, 11, 7, 5, 10, 11, 1, 9, 0, -1, -1, -1, -1, -1, -1, -1}, 
    {10, 7, 5, 10, 11, 7, 9, 8, 1, 8, 3, 1, -1, -1, -1, -1}, 
    {11, 1, 2, 11, 7, 1, 7, 5, 1, -1, -1, -1, -1, -1, -1, -1}, 
    {0, 8, 3, 1, 2, 7, 1, 7, 5, 7, 2, 11, -1, -1, -1, -1}, 
    {9, 7, 5, 9, 2, 7, 9, 0, 2, 2, 11, 7, -1, -1, -1, -1}, 
    {7, 5, 2, 7, 2, 11, 5, 9, 2, 3, 2, 8, 9, 8, 2, -1}, 
    {2, 5, 10, 2, 3, 5, 3, 7, 5, -1, -1, -1, -1, -1, -1, -1}, 
    {8, 2, 0, 8, 5, 2, 8, 7, 5, 10, 2, 5, -1, -1, -1, -1}, 
    {9, 0, 1, 5, 10, 3, 5, 3, 7, 3, 10, 2, -1, -1, -1, -1}, 
    {9, 8, 2, 9, 2, 1, 8, 7, 2, 10, 2, 5, 7, 5, 2, -1}, 
    {1, 3, 5, 3, 7, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {0, 8, 7, 0, 7, 1, 1, 7, 5, -1, -1, -1, -1, -1, -1, -1}, 
    {9, 0, 3, 9, 3, 5, 5, 3, 7, -1, -1, -1, -1, -1, -1, -1}, 
    {9, 8, 7, 5, 9, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {5, 8, 4, 5, 10, 8, 10, 11, 8, -1, -1, -1, -1, -1, -1, -1}, 
    {5, 0, 4, 5, 11, 0, 5, 10, 11, 11, 3, 0, -1, -1, -1, -1}, 
    {0, 1, 9, 8, 4, 10, 8, 10, 11, 10, 4, 5, -1, -1, -1, -1}, 
    {10, 11, 4, 10, 4, 5, 11, 3, 4, 9, 4, 1, 3, 1, 4, -1}, 
    {2, 5, 1, 2, 8, 5, 2, 11, 8, 4, 5, 8, -1, -1, -1, -1}, 
    {0, 4, 11, 0, 11, 3, 4, 5, 11, 2, 11, 1, 5, 1, 11, -1}, 
    {0, 2, 5, 0, 5, 9, 2, 11, 5, 4, 5, 8, 11, 8, 5, -1}, 
    {9, 4, 5, 2, 11, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {2, 5, 10, 3, 5, 2, 3, 4, 5, 3, 8, 4, -1, -1, -1, -1}, 
    {5, 10, 2, 5, 2, 4, 4, 2, 0, -1, -1, -1, -1, -1, -1, -1}, 
    {3, 10, 2, 3, 5, 10, 3, 8, 5, 4, 5, 8, 0, 1, 9, -1}, 
    {5, 10, 2, 5, 2, 4, 1, 9, 2, 9, 4, 2, -1, -1, -1, -1}, 
    {8, 4, 5, 8, 5, 3, 3, 5, 1, -1, -1, -1, -1, -1, -1, -1}, 
    {0, 4, 5, 1, 0, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {8, 4, 5, 8, 5, 3, 9, 0, 5, 0, 3, 5, -1, -1, -1, -1}, 
    {9, 4, 5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {4, 11, 7, 4, 9, 11, 9, 10, 11, -1, -1, -1, -1, -1, -1, -1}, 
    {0, 8, 3, 4, 9, 7, 9, 11, 7, 9, 10, 11, -1, -1, -1, -1}, 
    {1, 10, 11, 1, 11, 4, 1, 4, 0, 7, 4, 11, -1, -1, -1, -1}, 
    {3, 1, 4, 3, 4, 8, 1, 10, 4, 7, 4, 11, 10, 11, 4, -1}, 
    {4, 11, 7, 9, 11, 4, 9, 2, 11, 9, 1, 2, -1, -1, -1, -1}, 
    {9, 7, 4, 9, 11, 7, 9, 1, 11, 2, 11, 1, 0, 8, 3, -1}, 
    {11, 7, 4, 11, 4, 2, 2, 4, 0, -1, -1, -1, -1, -1, -1, -1}, 
    {11, 7, 4, 11, 4, 2, 8, 3, 4, 3, 2, 4, -1, -1, -1, -1}, 
    {2, 9, 10, 2, 7, 9, 2, 3, 7, 7, 4, 9, -1, -1, -1, -1}, 
    {9, 10, 7, 9, 7, 4, 10, 2, 7, 8, 7, 0, 2, 0, 7, -1}, 
    {3, 7, 10, 3, 10, 2, 7, 4, 10, 1, 10, 0, 4, 0, 10, -1}, 
    {1, 10, 2, 8, 7, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {4, 9, 1, 4, 1, 7, 7, 1, 3, -1, -1, -1, -1, -1, -1, -1}, 
    {4, 9, 1, 4, 1, 7, 0, 8, 1, 8, 7, 1, -1, -1, -1, -1}, 
    {4, 0, 3, 7, 4, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {4, 8, 7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {9, 10, 8, 10, 11, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {3, 0, 9, 3, 9, 11, 11, 9, 10, -1, -1, -1, -1, -1, -1, -1}, 
    {0, 1, 10, 0, 10, 8, 8, 10, 11, -1, -1, -1, -1, -1, -1, -1}, 
    {3, 1, 10, 11, 3, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {1, 2, 11, 1, 11, 9, 9, 11, 8, -1, -1, -1, -1, -1, -1, -1}, 
    {3, 0, 9, 3, 9, 11, 1, 2, 9, 2, 11, 9, -1, -1, -1, -1}, 
    {0, 2, 11, 8, 0, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {3, 2, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {2, 3, 8, 2, 8, 10, 10, 8, 9, -1, -1, -1, -1, -1, -1, -1}, 
    {9, 10, 2, 0, 9, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1},  //<>//
    {2, 3, 8, 2, 8, 10, 0, 1, 8, 1, 10, 8, -1, -1, -1, -1}, 
    {1, 10, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {1, 3, 8, 9, 1, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {0, 9, 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {0, 3, 8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, 
    {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}};


  int i, ntriang;
  int cubeindex;
  PVector vertlist[] = new PVector[12];
  PVector triangles[] = new PVector[3];

  PVector Colorlist[] = new PVector[12];

  cubeindex = 0;
  if (grid.VAL.get(0) > isolevel) cubeindex |= 1;
  if (grid.VAL.get(1) > isolevel) cubeindex |= 2; //<>//
  if (grid.VAL.get(2) > isolevel) cubeindex |= 4;
  if (grid.VAL.get(3) > isolevel) cubeindex |= 8;
  if (grid.VAL.get(4) > isolevel) cubeindex |= 16;
  if (grid.VAL.get(5) > isolevel) cubeindex |= 32; //<>//
  if (grid.VAL.get(6) > isolevel) cubeindex |= 64;
  if (grid.VAL.get(7) > isolevel) cubeindex |= 128;

  print(cubeindex+"\t");
  /* Cube is entirely in/out of the surface */
  if (edgeTable[cubeindex] == 0)
    return(0);

  /* Find the vertices where the surface intersects the cube */
  if (boolean(edgeTable[cubeindex] & 1) ) //edgeTable[cubeindex] &1 ==1
  {
    vertlist[0] =
      VertexInterp(isolevel, grid.p[0], grid.p[1], grid.VAL.get(0), grid.VAL.get(1));

    Colorlist[0] =
      ColorInterp(isolevel, grid.c[0], grid.c[1], grid.VAL.get(0), grid.VAL.get(1));
  }
  if (boolean(edgeTable[cubeindex] & 2)) {
    vertlist[1] =
      VertexInterp(isolevel, grid.p[1], grid.p[2], grid.VAL.get(1), grid.VAL.get(2));

    Colorlist[1] =
      ColorInterp(isolevel, grid.c[1], grid.c[2], grid.VAL.get(1), grid.VAL.get(2));
  }
  if (boolean(edgeTable[cubeindex] & 4)) {
    vertlist[2] =
      VertexInterp(isolevel, grid.p[2], grid.p[3], grid.VAL.get(2), grid.VAL.get(3));

    Colorlist[2] =
      ColorInterp(isolevel, grid.c[2], grid.c[3], grid.VAL.get(2), grid.VAL.get(3));
  }
  if (boolean(edgeTable[cubeindex] & 8)) {
    vertlist[3] =
      VertexInterp(isolevel, grid.p[3], grid.p[0], grid.VAL.get(3), grid.VAL.get(0));

    Colorlist[3] =
      ColorInterp(isolevel, grid.c[3], grid.c[0], grid.VAL.get(3), grid.VAL.get(0));
  }
  if (boolean(edgeTable[cubeindex] & 16)) {
    vertlist[4] =
      VertexInterp(isolevel, grid.p[4], grid.p[5], grid.VAL.get(4), grid.VAL.get(5));

    Colorlist[4] =
      ColorInterp(isolevel, grid.c[4], grid.c[5], grid.VAL.get(4), grid.VAL.get(5));
  }
  if (boolean(edgeTable[cubeindex] & 32)) {
    vertlist[5] =
      VertexInterp(isolevel, grid.p[5], grid.p[6], grid.VAL.get(5), grid.VAL.get(6));

    Colorlist[5] =
      ColorInterp(isolevel, grid.c[5], grid.c[6], grid.VAL.get(5), grid.VAL.get(6));
  }
  if (boolean(edgeTable[cubeindex] & 64)) {
    vertlist[6] =
      VertexInterp(isolevel, grid.p[6], grid.p[7], grid.VAL.get(6), grid.VAL.get(7));

    Colorlist[6] =
      ColorInterp(isolevel, grid.c[6], grid.c[7], grid.VAL.get(6), grid.VAL.get(7));
  }
  if (boolean(edgeTable[cubeindex] & 128)) {
    vertlist[7] =
      VertexInterp(isolevel, grid.p[7], grid.p[4], grid.VAL.get(7), grid.VAL.get(4));

    Colorlist[7] =
      ColorInterp(isolevel, grid.c[7], grid.c[4], grid.VAL.get(7), grid.VAL.get(4));
  }
  if (boolean(edgeTable[cubeindex] & 256)) {
    vertlist[8] =
      VertexInterp(isolevel, grid.p[0], grid.p[4], grid.VAL.get(0), grid.VAL.get(4));

    Colorlist[8] =
      ColorInterp(isolevel, grid.c[0], grid.c[4], grid.VAL.get(0), grid.VAL.get(4));
  }
  if (boolean(edgeTable[cubeindex] & 512)) {
    vertlist[9] =
      VertexInterp(isolevel, grid.p[1], grid.p[5], grid.VAL.get(1), grid.VAL.get(5));

    Colorlist[9] =
      ColorInterp(isolevel, grid.c[1], grid.c[5], grid.VAL.get(1), grid.VAL.get(5));
  }
  if (boolean(edgeTable[cubeindex] & 1024)) {
    vertlist[10] =
      VertexInterp(isolevel, grid.p[2], grid.p[6], grid.VAL.get(2), grid.VAL.get(6));

    Colorlist[10] =
      ColorInterp(isolevel, grid.c[2], grid.c[6], grid.VAL.get(2), grid.VAL.get(6));
  }
  if (boolean(edgeTable[cubeindex] & 2048)) { //<>//
    vertlist[11] =
      VertexInterp(isolevel, grid.p[3], grid.p[7], grid.VAL.get(3), grid.VAL.get(7));

    Colorlist[11] =
      ColorInterp(isolevel, grid.c[3], grid.c[7], grid.VAL.get(3), grid.VAL.get(7));
  }
  ntriang = 0;
  for (i=0; triTable[cubeindex][i]!=-1; i+=3) {

    triangles[0] = vertlist[triTable[cubeindex][i  ]];
    triangles[1] = vertlist[triTable[cubeindex][i+1]];
    triangles[2]= vertlist[triTable[cubeindex][i+2]];

    PVector polyColor = new PVector();
    int count =0;
    polyColor.add(Colorlist[triTable[cubeindex][i  ]]);
    count++;
    polyColor.add(Colorlist[triTable[cubeindex][i+1]]);
    count++;
    polyColor.add(Colorlist[triTable[cubeindex][i+2]]);
    count++;
    polyColor.div(count);
    tri = createShape();
    tri.beginShape(TRIANGLES);
    //tri.fill(polyColor.x, polyColor.y, polyColor.z, 200); //polygon
    tri.fill(grid.cc.x, grid.cc.y, grid.cc.z, 255);  //average //<>//
    tri.stroke(0);
    tri.strokeWeight(2);
    tri.vertex(triangles[0].x, triangles[0].y, triangles[0].z);
    tri.vertex(triangles[1].x, triangles[1].y, triangles[1].z);
    tri.vertex(triangles[2].x, triangles[2].y, triangles[2].z);
    tri.endShape(CLOSE);
    shape(tri);
    ntriang++;
  }

  return(ntriang);
}


PVector VertexInterp(float isolevel, PVector p1, PVector p2, float valp1, float valp2)
{

  float mu;
  PVector p = new PVector();

  if (abs(isolevel-valp1) < 0.00001)
    return(p1);
  if (abs(isolevel-valp2) < 0.00001)
    return(p2);
  if (abs(valp1-valp2) < 0.00001)
    return(p1);
  mu = (isolevel - valp1) / (valp2 - valp1);
  p.x = p1.x + mu * (p2.x - p1.x);
  p.y = p1.y + mu * (p2.y - p1.y);
  p.z = p1.z + mu * (p2.z - p1.z);

  return(p);
}

PVector ColorInterp(float isolevel, PVector c1, PVector c2, float valp1, float valp2)
{

  float mu;
  PVector c = new PVector();

  if (abs(isolevel-valp1) < 0.00001)
    return(c1);
  if (abs(isolevel-valp2) < 0.00001)
    return(c2);
  if (abs(valp1-valp2) < 0.00001)
    return(c1);
  mu = (isolevel - valp1) / (valp2 - valp1);
  c.x = c1.x + mu * (c2.x - c1.x);
  c.y = c1.y + mu * (c2.y - c1.y);
  c.z = c1.z + mu * (c2.z - c1.z);

  return(c);
}


void ColorMeta_curve(float w, int n)
{
  if (w<=0)
  {
    c.x += 0;
    c.y += 0;
    c.z += 0;
  } else if (w<=threshold)
  {
    c.x+= map(w, 0, threshold, 0, curve_Cr.get(n));
    c.y+= map(w, 0, threshold, 0, curve_Cg.get(n));
    c.z+= map(w, 0, threshold, 0, curve_Cb.get(n));
  } else
  {
    c.x+= curve_Cr.get(n);
    c.y+= curve_Cg.get(n);
    c.z+= curve_Cb.get(n);
  }
}