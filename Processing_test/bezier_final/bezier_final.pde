int numSegments = 15;  //<>//
PVector  p1, p2, p3, p4, pt, p0, pp, p00; //<>// //<>//
PVector []p = new PVector[4];
PVector []CP = new PVector[16];

PVector []verP = new PVector[4];
PVector []ver;

PShape s;  

void setup()
{
  size(200, 200, P3D);
  noLoop();

  p1= new PVector(50, 50, 0.0);
  p2= new PVector(50, 150, 0.0);
  p3= new PVector(150, 150, 0.0);
  p4= new PVector(150, 50, 0.0);
  pt = new PVector();
  p0 = new PVector();
  pp = new PVector();
  p00 = new PVector();

  ver = new PVector[(numSegments+1)*(numSegments+1)];
  for (int i=0; i<4; ++i)
  {
    p[i] = new PVector();
    verP[i] = new PVector();
  }
  int a=0;
  int xup=20;
  int yup=20;
  int zup=0;
  for (int i=0; i<16; ++i)
  {

    CP[i] = new PVector(xup, yup, zup);
    a++;
    if (a==1)
      zup += 50;
    else if (a==3)
      zup -= 50;
    xup +=50;
    if (a==4)
    {
      a=0;
      yup += 50;
      xup =20;
      zup = 0;
    }
    print(CP[i]+"\n");
  }
}

void draw() {  
  background(204);
  strokeWeight(4);
  stroke(255, 0, 0);
  for (int i=0; i<16; i++)
  {
    point(CP[i].x, CP[i].y, CP[i].z);
  }

  strokeWeight(1);
  stroke(0);
  //for (int i = 0; i <= numSegments; ++i) 
  //{ 
  //float t = i / (float)numSegments; 
  //// compute coefficients
  //float k1 = (1 - t) * (1 - t) * (1 - t); 
  //float k2 = 3 * (1 - t) * (1 - t) * t; 
  //float k3 = 3 * (1 - t) * t * t; 
  //float k4 = t * t * t; 
  //// weight the four control points using coefficients

  ////pt.x = p1.x * k1 +p2.x * k2 + p3.x * k3 + p4.x * k4;
  ////pt.y = p1.x * k1 +p2.y * k2 + p3.y * k3 + p4.y* k4;
  ////pt.z = p1.z * k1 +p2.z * k2 + p3.z * k3 + p4.z* k4;
  ////pt.set(evalBezierCurve(p,t));
  //point(pt.x,pt.y,pt.z);

  //if(count>0)
  //  line(p0.x,p0.y,p0.z,pt.x,pt.y,pt.z);
  // p0.set(pt);
  // count++;
  //} 


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
    count=0;
    float v = j / (float)numSegments; 
    for (int k=0; k<= numSegments; ++k, ++y) 
    {
      ver[y]=new PVector();
      float u = k / (float)numSegments; 
      print(k+":"+j+"\n");
      print(u+":"+v+"\n");
      pt.set(evalBezierPatch(CP, u, v));
      pp.set(evalBezierPatch(CP, v, u));
      
      ver[y].set(pt);
      //point(pt.x, pt.y, pt.z);
      print(pt+"\n");
      print(pp+"\n");
      if (count>0 ) {
        line(p0.x, p0.y, p0.z, pt.x, pt.y, pt.z);
        line(p00.x, p00.y, p00.z, pp.x, pp.y, pp.z);
      }
      p0.set(pt);
      p00.set(pp);
      count++;
    }
  }

  // face connectivity
  for (int i=0, y=0; i< numSegments; ++i) 
  {
    for (int j=0; j< numSegments; ++j, ++y) 
    {
      int a = (numSegments+1)*i+j;
      int b = (numSegments+1)*(i+1)+j;
      int c = (numSegments+1)*(i+1)+j+1;
      int d = (numSegments+1)*i+j+1;
      
      verP[0].set(ver[a]);
      verP[1].set(ver[b]);
      verP[2].set(ver[c]);
      verP[3].set(ver[d]);
      
      //s = createShape();
      beginShape();
      fill(random(255), random(255), random(255));
      noStroke();
      vertex(verP[0].x, verP[0].y,verP[0].z);
      vertex(verP[1].x, verP[1].y,verP[1].z);
      vertex(verP[2].x, verP[2].y,verP[2].z);
      vertex(verP[3].x, verP[3].y,verP[3].z);
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

PVector evalBezierPatch(PVector []controlPoints, float u, float v) 
{ 
  PVector []uCurve = new PVector[4]; 

  for (int i=0; i<4; i++)
  {
    p[0].set(controlPoints[i*4]); 
    p[1].set(controlPoints[i*4+1]); 
    p[2].set(controlPoints[i*4+2]); 
    p[3].set(controlPoints[i*4+3]); 
    uCurve[i] = evalBezierCurve(p, u);
    print("uCurve" + uCurve[i]+"\n");
  }
  return evalBezierCurve(uCurve, v);
} 

PVector evaluateBezierSurface(PVector[]P, float u, float v) 
{ 
  PVector[]Pu = new PVector[4]; 
  // compute 4 control points along u direction
  for (int i = 0; i < 4; ++i) { 
    PVector curveP[] = new PVector[4]; 
    curveP[0] = P[i * 4]; 
    curveP[1] = P[i * 4 + 1]; 
    curveP[2] = P[i * 4 + 2]; 
    curveP[3] = P[i * 4 + 3]; 
    Pu[i] = evalBezierCurve(curveP, u);
  } 
  // compute final position on the surface using v
  return evalBezierCurve(Pu, v);
} 