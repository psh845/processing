//<>// //<>// //<>//
float[][] table;
int[][] table2; 
String[][] table3;
int wid_img =0;
int heg_img =0;
float g_size =0;
FloatList cx;
FloatList cy;
FloatList radius;
FloatList weight;
FloatList Cr;
FloatList Cg;
FloatList Cb;

FloatList line_x;
FloatList line_y;
FloatList line_radius;
FloatList line_radius2;
FloatList line_weight;
FloatList line_Cr;
FloatList line_Cg;
FloatList line_Cb;

FloatList curve_x;
FloatList curve_y;
FloatList curve_radius;
FloatList curve_radius2;
FloatList curve_weight;
FloatList curve_Cr;
FloatList curve_Cg;
FloatList curve_Cb;

float threshold;
int a;
int b;
String s;

PVector c;
PVector[][] C_list;


void setup()
{
  size(1000, 1000);

  g_size = 10;
  wid_img = ceil(width/g_size);
  heg_img = ceil(height/g_size);


  a=650;
  b=1;
  s="";

  threshold =1.0;
  noLoop();

  frameRate(30);
}

void draw()
{

  background(0);
  C_list = new PVector[wid_img][heg_img];
  table = new float[wid_img][heg_img];
  table2 = new int[wid_img][heg_img];
  table3 = new String[wid_img][heg_img];
  cx = new FloatList();
  cy = new FloatList();
  radius = new FloatList();
  weight = new FloatList();
  Cr = new FloatList();
  Cg = new FloatList();
  Cb = new FloatList();

  line_x = new FloatList();
  line_y = new FloatList();
  line_radius = new FloatList();
  line_radius2 = new FloatList();
  line_weight = new FloatList();
  line_Cr = new FloatList();
  line_Cg = new FloatList();
  line_Cb = new FloatList();

  curve_x = new FloatList();
  curve_y = new FloatList();
  curve_radius = new FloatList();
  curve_radius2 = new FloatList();
  curve_weight = new FloatList();
  curve_Cr = new FloatList();
  curve_Cg = new FloatList();
  curve_Cb = new FloatList();

  stroke(0);
  strokeWeight(0);
  fill(0);
  Grid_squre(wid_img, heg_img, g_size, g_size);

  cx.append(width/2);
  cy.append(height/2-200);
  radius.append(width/3);
  weight.append(2);
  if (a > height-250) 
  {
    a = height-250;
    b*=-1;
  } else if (a < 0+250) {
    a = 0+250;
    b*=-1;
  }
  a+=(b*5);
  cx.append(width/2);
  cy.append(a);
  radius.append(width/3);
  weight.append(2);
  Cr.append(0.0);
  Cg.append(0.0);
  Cb.append(250.0);
  Cr.append(250.0);
  Cg.append(0.0);
  Cb.append(0.0);

  line_x.append(200);
  line_y.append(height/2-200);
  line_x.append(200);
  line_y.append(650);
  line_radius.append(50);
  line_radius2.append(100);
  line_weight.append(2);
  line_Cr.append(0.0);
  line_Cg.append(200.0);
  line_Cb.append(0.0);

  curve_x.append(100);
  curve_y.append(500);
  curve_x.append(350);
  curve_y.append(800);
  curve_x.append(650);
  curve_y.append(200);
  curve_x.append(900);
  curve_y.append(500);
  curve_radius.append(60);
  curve_radius2.append(60);
  curve_weight.append(2);
  curve_Cr.append(0.0);
  curve_Cg.append(200.0);
  curve_Cb.append(0.0);


  //fill(100, 100, 100, 100);
 // ellipse(cx.get(0), cy.get(0), radius.get(0)*2, radius.get(0)*2);
  //ellipse(cx.get(1), cy.get(1), radius.get(1)*2, radius.get(1)*2);
  //fill(Cr.get(0),Cg.get(0),Cb.get(0),100);
  //ellipse(cx.get(0), cy.get(0), radius.get(0), radius.get(0));
  //fill(Cr.get(1),Cg.get(1),Cb.get(1),100);
 // ellipse(cx.get(1), cy.get(1), radius.get(1), radius.get(1));

  stroke(line_Cr.get(0), line_Cg.get(0), line_Cb.get(0));
  strokeWeight(1);
 // line(line_x.get(0), line_y.get(0), line_x.get(1), line_y.get(1));

  noFill();
  stroke(curve_Cr.get(0), curve_Cg.get(0), curve_Cb.get(0));
  bezier(curve_x.get(0), curve_y.get(0), curve_x.get(1), curve_y.get(1), curve_x.get(2), curve_y.get(2), curve_x.get(3), curve_y.get(3));
  //threshold = 2;

  //metaball or small circle color
  for (int i =0; i<wid_img; i++)
  {
    for (int j=0; j<heg_img; j++)
    {
      float field =0.0;
      C_list[i][j] = new PVector(0, 0, 0);
      //field =metaball(i, j, g_size, 1);
      //table[i][j]+=field;
      //C_list[i][j].add(c);
      //field=metaball_line(i, j, g_size, 1);
      //table[i][j]+=field;
      //C_list[i][j].add(c);
      field=metaball_curve(i, j, g_size, 1);
      table[i][j]+=field;
      C_list[i][j].add(c);
      //print(i+","+j+":"+table[i][j] + "\t");
      //if (table[i][j]<=radius.get(0)/2)
      if (table[i][j]>=threshold)
      {
        table2[i][j] = 1;
        //print(i+","+j+":"+table[i][j] + "\t");
        stroke(C_list[i][j].x, C_list[i][j].y, C_list[i][j].z);
        //fill(C_list[i][j].x,C_list[i][j].y,C_list[i][j].z);
        Grid_circle(g_size, 2, i, j);
      } else
      {
        table2[i][j] = 0;
      }
    }
  }

  //marching squre 
  for (int i =0; i<wid_img-1; i++)
  {

    for (int j=0; j<heg_img-1; j++)
    {
      table3[i][j] = str(table2[i][j])+str(table2[i+1][j])+str(table2[i+1][j+1])+str(table2[i][j+1]);
      // print(i+","+j+":"+table3[i][j]+"\t");
      look(table3[i][j], i, j, g_size);
    }
  }
  //print("\n"+ count);

  //text metaball;
  textSize(32);
  fill(0, 155, 100);
  text(s, 30, 50);

  //if(frameCount < 150)
  //saveFrame("Metaball_####.tif");
}


void Grid_squre(float wid_img, float heg_img, float squre_size, float g_size)
{
  //stroke(0);
  fill(200);
  for (float i =0; i<wid_img; i++)
  {

    for (float j=0; j<heg_img; j++)
    {
      rect(i*g_size, j*g_size, squre_size, squre_size);
    }
  }
}

void Grid_circle(float g_size, int radius, float x, float y)
{

  ellipse(x*g_size, y*g_size, radius, radius);
}


float metaball(float x, float y, float g_size, int button)
{

  float sum= 0.0;
  float d = 0.0;
  float r =0.0;
  float w =0.0;
  c = new PVector(0.0, 0.0, 0.0);

  for (int n=0; n<radius.size(); n++)
  {
    d = sqrt(sq(cx.get(n) - x*g_size) + sq(cy.get(n) - y*g_size));
    //float d= dist(float(cx.get(n)), float(cy.get(n)), x*g_size,y*g_size);
    //float di= pow(cx.get(n)-x*g_size, 2)+pow(cy.get(n)-y*g_size, 2);
    r = radius.get(n);
    //float ri = r*r;
    //print(d+"\t");
    switch(button)
    {
    case 0:
      /*meta ball*/
      if (d>=0 && d<=r/3)
      {
        w = weight.get(n)*(1-((3*sq(d))/sq(r)));
        sum +=w;
        ColorMeta(w, n);
      } else if (d>r/3 && d<=r)
      {
        w = (3*weight.get(n)/2)*sq(1-(d/r));
        sum +=w;
        ColorMeta(w, n);
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
        w = weight.get(n)*(1-(4*pow(d, 6)/(9*pow(r, 6)))+(17*pow(d, 4)/(9*pow(r, 4)))-(22*pow(d, 2)/(9*pow(r, 2))));
        sum +=w;
        ColorMeta(w, n);
      } else
      {
        w=0;        
        sum+= w;
      }
      //print("Soft Objects"+"\t");
      s = "Soft Objects";         
      break;
    default:
      s= "no metaball";
      //print("no metaball type: 0.metaball    1.Soft Objects");
    }
    //print(x+","+y+":"+int(sum)+"\t");
  }
  //print(x+","+y+":"+int(sum)+"\t");

  //return d;

  return sum;
}

float metaball_line(float x, float y, float g_size, int button)
{

  float sum= 0.0;
  float d = 0.0;
  float r =0.0;
  float r1 =0.0;
  float r2 =0.0;
  float w =0.0;
  c = new PVector(0.0, 0.0, 0.0);

  for (int n=0; n<line_radius.size(); n++)
  {

    PVector p = new PVector(x*g_size, y*g_size);
    PVector p0 = new PVector(line_x.get(n*2), line_y.get(n*2));
    PVector p1 = new PVector(line_x.get(n*2+1), line_y.get(n*2+1));

    PVector v = new PVector(p1.x, p1.y);
    v.sub(p0);
    PVector t = new PVector(p.x, p.y);
    t.sub(p0);
    float a = t.dot(v)/v.dot(v);
    v.mult(a);
    v.add(p0);

    r1 = line_radius.get(n);
    r2 = line_radius2.get(n);

    if (a<=0)
    {
      d = sqrt(sq(p.x - p0.x) + sq(p.y - p0.y));
      r= r1;
    } else if (a>0 && a<1)
    {
      d = sqrt(sq(p.x - v.x) + sq(p.y - v.y));
      r= a*r2 + (1-a)*r1;
    } else
    {
      d = sqrt(sq(p.x - p1.x) + sq(p.y - p1.y));
      r =r2;
    }

    //r1 = line_radius.get(n);
    //r2 = line_radius2.get(n);
    //r= a*r2 + (1-a)*r1;
    
    switch(button)
    {
    case 0:
      /*meta ball*/
      if (d>=0 && d<=r/3)
      {
        w = line_weight.get(n)*(1-((3*sq(d))/sq(r)));
        sum +=w;
        ColorMeta_line(w, n);
      } else if (d>r/3 && d<=r)
      {
        w = (3*line_weight.get(n)/2)*sq(1-(d/r));
        sum +=w;
        ColorMeta_line(w, n);
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
        w = line_weight.get(n)*(1-(4*pow(d, 6)/(9*pow(r, 6)))+(17*pow(d, 4)/(9*pow(r, 4)))-(22*pow(d, 2)/(9*pow(r, 2))));
        sum +=w;
        ColorMeta_line(w, n);
      } else
      {
        w=0;        
        sum+= w;
      }
      //print("Soft Objects"+"\t");
      s = "Soft Objects";         
      break;
    default:
      s= "no metaball";
      //print("no metaball type: 0.metaball    1.Soft Objects");
    }
    //print(x+","+y+":"+int(sum)+"\t");
  }
  //print(x+","+y+":"+int(sum)+"\t");
  //return d;
  return sum ;
}


float metaball_curve(float x, float y, float g_size, int button)
{

  float sum= 0.0;

  float d = 0.0;
  float dd = 0.0;

  float r =0.0;
  float r1 =0.0;
  float r2 =0.0;
  float rt =0.0;
  float rt2 = 0.0;
  
  float w =0.0;
  c = new PVector(0.0, 0.0, 0.0);

  for (int n=0; n<curve_radius.size(); n++)
  {

    PVector p = new PVector(x*g_size, y*g_size);
    PVector p0 = new PVector(curve_x.get(n*4), curve_y.get(n*4));
    PVector p1 = new PVector(curve_x.get(n*4+1), curve_y.get(n*4+1));
    PVector p2 = new PVector(curve_x.get(n*4+2), curve_y.get(n*4+2));
    PVector p3 = new PVector(curve_x.get(n*4+3), curve_y.get(n*4+3));
    PVector pf = new PVector(p0.x, p0.y);
    PVector pt = new PVector(p0.x, p0.y);
    
    r1 = curve_radius.get(n);
    r2 = curve_radius2.get(n);
    for ( float t = 0; t <= 1.0; t += 0.1 )
    { 
      t= floor(t*10)*0.1;
      //pt.x = int(p0.x*((1-t)*(1-t)) + p1.x*(2*t)*(1-t) + p2.x*(t*t));
      pt.x = p0.x*((1-t)*(1-t)*(1-t)) + p1.x*(3*t)*((1-t)*(1-t))+p2.x*3*(1-t)*(t*t) + p3.x*(t*t*t);
      //pt.y = int(p0.y*((1-t)*(1-t)) + p1.y*(2*t)*(1-t) + p2.y*(t*t));
      pt.y = p0.y*((1-t)*(1-t)*(1-t)) + p1.y*(3*t)*((1-t)*(1-t))+p2.y*3*(1-t)*(t*t)+ p3.y*(t*t*t);

      PVector v = new PVector(pt.x, pt.y);
      v.sub(pf);
      PVector tt = new PVector(p.x, p.y);
      tt.sub(pf);
      float a = tt.dot(v)/v.dot(v);
      v.mult(a);
      v.add(pf);

      
      if (a<=0)
      {
        dd = sqrt(sq(p.x - pf.x) + sq(p.y - pf.y));   
        rt = r1;
      } else if (a>0 && a<1)
      {
        dd = sqrt(sq(p.x - v.x) + sq(p.y - v.y));
        rt2 = r1+ (r2-r1)*t;
        rt = a*rt2 + (1-a)*r1;
      } else
      {
        dd = sqrt(sq(p.x - pt.x) + sq(p.y - pt.y));
        rt = r1+ (r2-r1)*t;
      }  
        
      if (t==0)
      {
        d=dd;
        r=rt;
      }
      else
      {
       
        if (dd<d) //min distance find
        {
          d= dd;
          r=rt;
        }
      }

      if (t<=1.0)
      {
        pf.x= pt.x;
        pf.y = pt.y; 
        r1 =rt;
      }
    }
     
    //r = curve_radius.get(n); 
     
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
      } else
      {
        w=0;        
        sum+= w;
      }
      //print("Soft Objects"+"\t");
      s = "Soft Objects";         
      break;
    default:
      s= "no metaball";
      //print("no metaball type: 0.metaball    1.Soft Objects");
    }
    //print(x+","+y+":"+int(sum)+"\t");
  }
  //print(x+","+y+":"+int(sum)+"\t");
  //return d;
  return sum ;
}

void look(String s, int i, int j, float g_size)
{


  if (!s.equals("1111") && !s.equals("0000"))
  {
    //print(s.toString() +"\t"+ i+"\t"+ j+"\t");
    float coner0= metalerp(table[i][j], table[i+1][j], threshold) * g_size;  //x0
    float coner1= metalerp(table[i+1][j], table[i+1][j+1], threshold) * g_size;  //y1
    float coner2= metalerp(table[i][j+1], table[i+1][j+1], threshold) * g_size;  //x1
    float coner3= metalerp(table[i][j], table[i][j+1], threshold) * g_size;    //y0
    //print(coner0+","+coner1+","+coner2+","+coner3 + "\t");
    PVector C = new PVector();
    C.add(C_list[i][j]);
    C.add(C_list[i+1][j]);
    C.add(C_list[i+1][j+1]);
    C.add(C_list[i][j+1]);
    C.div(4);
    stroke(C.x, C.y, C.z);
    strokeWeight(1);
    if ( s.equals("1110"))
      line(i*g_size, ((j+1)*g_size)-coner3, i*g_size+coner2, ((j+1)*g_size)); //1110 case14
    if ( s.equals("1101"))
      line(((i+1)*g_size)-coner2, ((j+1)*g_size), ((i+1)*g_size), ((j+1)*g_size)-coner1);  //1101  case 13
    if ( s.equals("1011"))
      line(((i+1)*g_size)-coner0, j*g_size, ((i+1)*g_size), j*g_size+coner1);  //1011  case 11
    if ( s.equals("0111"))
      line(i*g_size+coner0, j*g_size, i*g_size, j*g_size+coner3);  //0111 case 7
    if ( s.equals("0001"))
      line(i*g_size, j*g_size+coner3, ((i+1)*g_size)-coner2, ((j+1)*g_size)); //0001 case 1
    if ( s.equals("0010"))
      line(i*g_size+coner2, ((j+1)*g_size), ((i+1)*g_size), j*g_size+coner1);  //0010 case 2
    if ( s.equals("0100"))
      line(i*g_size+coner0, j*g_size, ((i+1)*g_size), ((j+1)*g_size)-coner1); //0100 case 4
    if ( s.equals("1000"))
      line(((i+1)*g_size)-coner0, j*g_size, i*g_size, ((j+1)*g_size)-coner3); //1000  case 8
    if ( s.equals("1100"))
      line(i*g_size, ((j+1)*g_size)-coner3, ((i+1)*g_size), ((j+1)*g_size)-coner1);  //1100  case 12
    if ( s.equals("1001"))
      line(((i+1)*g_size)-coner0, j*g_size, ((i+1)*g_size)-coner2, ((j+1)*g_size));  //1001  case 9
    if ( s.equals("0011"))
      line(i*g_size, j*g_size+coner3, ((i+1)*g_size), j*g_size+coner1); //0011  case 3
    if ( s.equals("0110"))
      line(i*g_size+coner0, j*g_size, i*g_size+coner2, ((j+1)*g_size));  //0110  case 6
    if ( s.equals("1010"))
    {
      line(i*g_size, ((j+1)*g_size)-coner3, i*g_size+coner2, ((j+1)*g_size));  //1110   case 10
      line(((i+1)*g_size)-coner0, j*g_size, ((i+1)*g_size), j*g_size+coner1);  //1011
    }
    if ( s.equals("0101"))
    {
      line(((i+1)*g_size)-coner0, j*g_size, ((i+1)*g_size), j*g_size+coner1);  //1101  case 5
      line(i*g_size+coner0, j*g_size, i*g_size, j*g_size+coner3);  //0111
    }
  }
}


float metalerp(float p0, float p1, float threshold)
{

  float m=0;
  float ss = p0 + p1;

  float nn=0;
  //print(p0+","+p1+":"+nn+"\t");

  if (threshold>p0 && threshold<=p1)
  {
    nn= (threshold-p0)/(p1-p0);
    //if(p0<p1)
    //m = lerp(p0, p1, nn);
    //else if(p1<p0)
    //m = lerp(p1, p0, nn);
    //print("case1 "+p0+","+p1+":"+nn+","+m+"\t");
  } else if (threshold>p1 && threshold<=p0)
  {
    nn= (threshold-p1)/(p0-p1);
    //if(p0<p1)
    //m = lerp(p0, p1, nn);
    //else if(p1<p0)
    //m = lerp(p1, p0, nn);
    //print("case2 "+p0+","+p1+":"+nn+"\t");
  } else
  {
    nn =0;
  }


  return nn;
}

void ColorMeta(float w, int n)
{
  if (w<=0)
  {
    c.x += 0;
    c.y += 0;
    c.z += 0;
  } else if (w<=threshold)
  {
    c.x+= map(w, 0, threshold, 0, Cr.get(n));
    c.y+= map(w, 0, threshold, 0, Cg.get(n));
    c.z+= map(w, 0, threshold, 0, Cb.get(n));
  } else
  {
    c.x+= Cr.get(n);
    c.y+= Cg.get(n);
    c.z+= Cb.get(n);
  }
}

void ColorMeta_line(float w, int n)
{
  if (w<=0)
  {
    c.x += 0;
    c.y += 0;
    c.z += 0;
  } else if (w<=threshold)
  {
    c.x+= map(w, 0, threshold, 0, line_Cr.get(n));
    c.y+= map(w, 0, threshold, 0, line_Cg.get(n));
    c.z+= map(w, 0, threshold, 0, line_Cb.get(n));
  } else
  {
    c.x+= line_Cr.get(n);
    c.y+= line_Cg.get(n);
    c.z+= line_Cb.get(n);
  }
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