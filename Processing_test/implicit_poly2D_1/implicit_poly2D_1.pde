float r;
IntList radius;
IntList weight;
IntList cx;
IntList cy;
float threshold=0;
FloatList cPointX;
FloatList cPointY;

float[] table;
int[] table2; 
float ex, ey, eex, eey;

PVector pt;
PVector pc;
PVector pp;


void setup() {
  size(800, 800);
  smooth();
  strokeWeight(1);

  background(255);

  noLoop();


  table = new float[9];
  table2 = new int[9];

  cx = new IntList();
  cy = new IntList();
  radius = new IntList();
  weight = new IntList();

  cx.append(400);
  cy.append(400);
  cx.append(400);
  cy.append(500);
  radius.append(150);
  radius.append(150);
  weight.append(2);
  weight.append(2);

  threshold =1.0;
  r=30;

  noFill();
  noLoop();
  ellipse(cx.get(0), cy.get(0), radius.get(0)*2, radius.get(0)*2);
  ellipse(cx.get(0), cy.get(0), radius.get(0), radius.get(0));
  ellipse(cx.get(1), cy.get(1), radius.get(1)*2, radius.get(1)*2);
  ellipse(cx.get(1), cy.get(1), radius.get(1), radius.get(1));
}

void draw() {

  float dd =0;
  
  strokeWeight(2);
  stroke(255, 0, 0);
  float x=width/2;
  float y=height/2-(radius.get(0)/2);

 
   
  circle_center(x,y);
  
  for (int i=0; i<21; i++)
  {

   circle_poly(pc.x, pc.y);
   pc.set(pp);
   dd = pc.dist(pc,pt);
   print("dist"+i+","+dd+"\n");
   
   if((i>1) &&(dd<=r)){
    line(pc.x,pc.y,pt.x,pt.y);
    break;
   }
   
  }
}

void Grid_circle( int radius, float x, float y)
{

  ellipse(x, y, radius, radius);
}

float metaball(float x, float y, int button)
{

  float sum= 0;
  for (int n=0; n<radius.size(); n++)
  {

    //float d = sqrt(pow(cx.get(n)-(x*g_size), 2)+pow(cy.get(n)-(y*g_size), 2));
    float d= dist(cx.get(n), cy.get(n), x, y);
    //float di= pow(cx.get(n)-x*g_size, 2)+pow(cy.get(n)-y*g_size, 2);
    float r = radius.get(n);
    //float ri = r*r;


    switch(button)
    {
    case 0:
      /*meta ball*/
      if (d>=0 && d<=r/3)
      {
        sum+= weight.get(n)*(1-(3*pow(d, 2)/pow(r, 2)));
      } else if (d>r/3 && d<=r)
      {
        sum+= (3*weight.get(n)/2)*pow(1-(d/r), 2);
      } else
      {
        sum+= 0;
      }
      //print("metaball"+"\t");
      break;
    case 1:
      /*Soft Objects*/
      if (d>=0 && d<=r)
      {
        sum+= weight.get(n)*(1-(4*pow(d, 6)/(9*pow(r, 6)))+(17*pow(d, 4)/(9*pow(r, 4)))-(22*pow(d, 2)/(9*pow(r, 2))));
      } else
      {
        sum+=0;
      }
      //print("Soft Objects"+"\t");
      break;
    default:
      print("no metaball type: 0.metaball    1.Soft Objects");
    }
    //print(x+","+y+":"+int(sum)+"\t");
  }
  //print(x+","+y+":"+int(sum)+"\t");
  return sum;
}

float metalerp(float p0, float p1, float valp1, float valp2, float threshold)
{

  float mu;
  float p;
  if (abs(threshold-valp1) < 0.00001)
    return(p0);
  if (abs(threshold-valp2) < 0.00001)
    return(p1);
  if (abs(valp1-valp2) < 0.00001)
    return(p0);

  mu= (threshold-valp2)/(valp1-valp2);
  p = p1 + mu * (p0 - p1);

  return p;
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
  //p.z = p1.z + mu * (p2.z - p1.z);

  return(p);
}

void circle_center(float x, float y)
{
  PVector p = new PVector();
  PVector p1 = new PVector();
  noFill();
  strokeWeight(2);
  stroke(255, 0, 0);

  ellipse(x, y, r*2, r*2);
  
  cPointX = new FloatList();
  cPointY = new FloatList();
  cPointX.append(x);
  cPointY.append(y);
  cPointX.append(x);
  cPointY.append(y-r);
  cPointX.append(x);
  cPointY.append(y+r);

  for (int j=0; j<cPointX.size(); j++)
  {
    table[j]=metaball(cPointX.get(j), cPointY.get(j), 1);
    print(table[j]+"\t");
    if (table[j]>=threshold)
    {
      table2[j] = 1;
    } else
    {
      table2[j] = 0;
    }
    fill(table2[j]*255);
    stroke(0);
    Grid_circle(10, cPointX.get(j), cPointY.get(j));
  }

  if (table[0]>=threshold) {
    if (table[1]<threshold) {
      ex=metalerp(cPointX.get(0), cPointX.get(1), table[0], table[1], threshold);
      ey=metalerp(cPointY.get(0), cPointY.get(1), table[0], table[1], threshold);
    } else if (table[2]<threshold) {
      ex=metalerp(cPointX.get(0), cPointX.get(2), table[0], table[2], threshold);
      ey=metalerp(cPointY.get(0), cPointY.get(2), table[0], table[2], threshold);
    }
  } else
  {
    if (table[1]<threshold) {
      ex=metalerp(cPointX.get(0), cPointX.get(1), table[0], table[1], threshold);
      ey=metalerp(cPointY.get(0), cPointY.get(1), table[0], table[1], threshold);
    } else if (table[2]<threshold) {
      ex=metalerp(cPointX.get(0), cPointX.get(2), table[0], table[2], threshold);
      ey=metalerp(cPointY.get(0), cPointY.get(2), table[0], table[2], threshold);
    }
  }

  cPointX = new FloatList();
  cPointY = new FloatList();
  cPointX.append(ex);
  cPointY.append(ey);
  
   print(" center"+ex,ey);
  for (int i = 0; i < 360; i+=45) {
    float xx = r*cos(radians(i))+x;
    float yy = r*sin(radians(i))+y;


    point(xx, yy);
    print(" circle"+xx,yy);

    cPointX.append(xx);
    cPointY.append(yy);
  }

  for (int j=0; j<cPointX.size(); j++)
  {
    table[j]=metaball(cPointX.get(j), cPointY.get(j), 1);
    print(table[j]+"\t");
    if (table[j]>=threshold)
    {
      table2[j] = 1;
    } else
    {
      table2[j] = 0;
    }
    fill(table2[j]*255);
    stroke(0);
    Grid_circle(10, cPointX.get(j), cPointY.get(j));
  }


  ex=cPointX.get(0);
  ey=cPointY.get(0);

  if ((table[1]>=threshold)&&(table[8]<threshold)) { //<>//
    eex=metalerp(cPointX.get(1), cPointX.get(8), table[1], table[8], threshold);
    eey=metalerp(cPointY.get(1), cPointY.get(8), table[1], table[8], threshold);
  }  if ((table[2]>=threshold)&&(table[1]<threshold)) {
    eex=metalerp(cPointX.get(2), cPointX.get(1), table[2], table[1], threshold);
    eey=metalerp(cPointY.get(2), cPointY.get(1), table[2], table[1], threshold);
  } if ((table[3]>=threshold)&&(table[2]<threshold)) {
    eex=metalerp(cPointX.get(3), cPointX.get(2), table[3], table[2], threshold);
    eey=metalerp(cPointY.get(3), cPointY.get(2), table[3], table[2], threshold);
  }  if ((table[4]>=threshold)&&(table[3]<threshold)) {
    eex=metalerp(cPointX.get(4), cPointX.get(3), table[4], table[3], threshold);
    eey=metalerp(cPointY.get(4), cPointY.get(3), table[4], table[3], threshold);
  }  if ((table[5]>=threshold)&&(table[4]<threshold)) {
    eex=metalerp(cPointX.get(5), cPointX.get(4), table[5], table[4], threshold);
    eey=metalerp(cPointY.get(5), cPointY.get(4), table[5], table[4], threshold);
  }  if ((table[6]>=threshold)&&(table[5]<threshold)) {
    eex=metalerp(cPointX.get(6), cPointX.get(5), table[6], table[5], threshold);
    eey=metalerp(cPointY.get(6), cPointY.get(5), table[6], table[5], threshold);
  }  if ((table[7]>=threshold)&&(table[6]<threshold)) {
    eex=metalerp(cPointX.get(7), cPointX.get(6), table[7], table[6], threshold);
    eey=metalerp(cPointY.get(7), cPointY.get(6), table[7], table[6], threshold);
  } if ((table[8]>=threshold)&&(table[7]<threshold)) {
    eex=metalerp(cPointX.get(8), cPointX.get(7), table[8], table[7], threshold);
    eey=metalerp(cPointY.get(8), cPointY.get(7), table[8], table[7], threshold);
  }

  stroke(0, 0, 255);
  strokeWeight(2);
  line(ex, ey, eex, eey);

  p.set(ex, ey);
  p1.set(eex, eey);
  p1.sub(ex, ey);
  print(p1);
  p1.normalize();
  print(p1);
  p1.mult(r);
  print(p1);
  p1.add(ex, ey);

  print(p1);
  line(ex, ey, p1.x, p1.y); 
  
  pt=new PVector();
  pc=new PVector();
  
  pt.set(p);
  pc.set(p1);

}

void circle_poly(float ex, float ey)
{
  //float x, y;
  PVector p = new PVector();
  PVector p1 = new PVector();
  noFill();
  strokeWeight(2);
  stroke(255, 0, 0);

  ellipse(ex, ey, r*2, r*2);
  cPointX = new FloatList();
  cPointY = new FloatList();
  cPointX.append(ex);
  cPointY.append(ey);
  for (int i = 0; i < 360; i+=45) {
    float xx = r*cos(radians(i))+ex;
    float yy = r*sin(radians(i))+ey;


    point(xx, yy);

    cPointX.append(xx);
    cPointY.append(yy);
  }

  print("\n");

  for (int j=0; j<cPointX.size(); j++)
  {
    table[j]=metaball(cPointX.get(j), cPointY.get(j), 1);
    print(table[j]+"\t");
    if (table[j]>=threshold)
    {
      table2[j] = 1;
    } else
    {
      table2[j] = 0;
    }
    fill(table2[j]*255);
    stroke(0);
    Grid_circle(10, cPointX.get(j), cPointY.get(j));
  }


  ex=cPointX.get(0);
  ey=cPointY.get(0);

  if ((table[1]>=threshold)&&(table[8]<threshold)) {
    eex=metalerp(cPointX.get(1), cPointX.get(8), table[1], table[8], threshold);
    eey=metalerp(cPointY.get(1), cPointY.get(8), table[1], table[8], threshold);
  }  if ((table[2]>=threshold)&&(table[1]<threshold)) {
    eex=metalerp(cPointX.get(2), cPointX.get(1), table[2], table[1], threshold);
    eey=metalerp(cPointY.get(2), cPointY.get(1), table[2], table[1], threshold);
  }  if ((table[3]>=threshold)&&(table[2]<threshold)) {
    eex=metalerp(cPointX.get(3), cPointX.get(2), table[3], table[2], threshold);
    eey=metalerp(cPointY.get(3), cPointY.get(2), table[3], table[2], threshold);
  }  if ((table[4]>=threshold)&&(table[3]<threshold)) {
    eex=metalerp(cPointX.get(4), cPointX.get(3), table[4], table[3], threshold);
    eey=metalerp(cPointY.get(4), cPointY.get(3), table[4], table[3], threshold);
  }  if ((table[5]>=threshold)&&(table[4]<threshold)) {
    eex=metalerp(cPointX.get(5), cPointX.get(4), table[5], table[4], threshold);
    eey=metalerp(cPointY.get(5), cPointY.get(4), table[5], table[4], threshold);
  }  if ((table[6]>=threshold)&&(table[5]<threshold)) {
    eex=metalerp(cPointX.get(6), cPointX.get(5), table[6], table[5], threshold);
    eey=metalerp(cPointY.get(6), cPointY.get(5), table[6], table[5], threshold);
  }  if ((table[7]>=threshold)&&(table[6]<threshold)) {
    eex=metalerp(cPointX.get(7), cPointX.get(6), table[7], table[6], threshold);
    eey=metalerp(cPointY.get(7), cPointY.get(6), table[7], table[6], threshold);
  }  if ((table[8]>=threshold)&&(table[7]<threshold)) {
    eex=metalerp(cPointX.get(8), cPointX.get(7), table[8], table[7], threshold);
    eey=metalerp(cPointY.get(8), cPointY.get(7), table[8], table[7], threshold);
  }

  stroke(0, 0, 255);
  strokeWeight(2);
  line(ex, ey, eex, eey);

  p.set(ex, ey);
  p1.set(eex, eey);
  p1.sub(ex, ey);
  print(p1);
  p1.normalize();
  print(p1);
  p1.mult(r);
  print(p1);
  p1.add(ex, ey);

  print(p1);
  line(ex, ey, p1.x, p1.y); 

  pp=new PVector();

  pp.set(p1);
}