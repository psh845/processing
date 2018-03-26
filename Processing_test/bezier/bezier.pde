PVector p0, p1, p2, p3, p, pf, pfx, pc,pdd;
PVector [][]tempP = new PVector[20][4];

void setup() { 
  size(200, 200,P3D); 
  p0= new PVector(10, 20,0.0);
  p1= new PVector(10, 190,0.0);
  p2= new PVector(190, 190,0.0);
  p3= new PVector(190, 20,0.0);
  p = new PVector(p0.x, p0.y,p0.z);
  pf = new PVector(p0.x, p0.y,p0.z);
  pfx = new PVector(p0.x, p0.y,p0.z);
  pc = new PVector(p0.x, p0.y,p0.z);
  pdd = new PVector(p0.x, p0.y,p0.z);

  noLoop();
}

void draw() { 
  stroke(0, 0, 0); 
  strokeWeight(1.0); 
  //color c = color(255,0,0);
  line( p0.x, p0.y,p0.z, p1.x, p1.y,p1.z); 
  line( p1.x, p1.y, p1.z,p2.x, p2.y,p2.z);
  line( p2.x, p2.y, p2.z,p3.x, p3.y, p3.z);

  int x=0;
  for ( float t = 0.0; t <=1.0; t += 0.1 )
  {

    t= floor(t*10)*0.1;
    //p.x = int(p0.x*((1-t)*(1-t)) + p1.x*(2*t)*(1-t) + p2.x*(t*t));
    p.x = p0.x*((1-t)*(1-t)*(1-t)) + p1.x*(3*t)*((1-t)*(1-t))+p2.x*3*(1-t)*(t*t) + p3.x*(t*t*t);
    //p.y = int(p0.y*((1-t)*(1-t)) + p1.y*(2*t)*(1-t) + p2.y*(t*t));
    p.y = p0.y*((1-t)*(1-t)*(1-t)) + p1.y*(3*t)*((1-t)*(1-t))+p2.y*3*(1-t)*(t*t)+ p3.y*(t*t*t);

    pc.x = (3*((1-t)*(1-t))*(p1.x-p0.x)+6*(1-t)*t*(p2.x-p1.x) + 3*(t*t)*(p3.x - p2.x));
    pc.y = (3*((1-t)*(1-t))*(p1.y-p0.y)+6*(1-t)*t*(p2.y-p1.y) + 3*(t*t)*(p3.y - p2.y));

    pfx.x=(6*(1-t)*(p2.x-2*p1.x+p0.x) + 6*t*(p3.x-2*p2.x+p1.x));
    pfx.y=(6*(1-t)*(p2.y-2*p1.y+p0.y) + 6*t*(p3.y-2*p2.y+p1.y));

    
    pc.normalize();
   
    pfx.normalize();
    
    if(t==0.0)
      pdd.set(1,0,0);
    else if(t==1.0)
      pdd.set(-1,0,0);
    else
      pdd.set(0,-1,0);
    pdd.normalize();
    
    PVector v1 = new PVector(pc.x,pc.y,pc.z);
     v1.normalize();
    PVector v2 = new PVector(pdd.x, pdd.y, pdd.z); 
      v2.normalize();
      
    
    PVector v3 = v1.cross(v2);
     v3.normalize();
    PVector v4 = v1.cross(v3);
    v4.normalize();
    
    PVector v5 = v3.cross(v1);
    
    float a = v1.dot(v4);
    println(a+"////");
    
    float b = v4.dot(pdd);
    println("////"+b+"////");
    
    float aa = acos(v4.dot(pdd)/v4.mag()*pdd.mag());
    println("////"+degrees(aa));
    println(t, p.x, p.y,p.z, pc.x, pc.y,pc.z,pdd.x,pdd.y,pdd.z);
    println(v1.x,v1.y,v1.z,v2.x,v2.y,v2.z,v3.x,v3.y,v3.z,v4.x,v4.y,v4.z);
    
    pc.mult(50);
    pc.add(p);
    
    pfx.mult(50);
    pfx.add(p);
    
    pdd.mult(50);
    pdd.add(p);
    
    v3.mult(50);
    v3.add(p);
    
    v4.mult(10);
    v4.add(p);
    
    v5.mult(10);
    v5.add(p);
    
    tempP[x][0]=new PVector(v4.x,v4.y,v4.z+20);
    tempP[x][1]=new PVector(v4.x,v4.y,v4.z-20);
    tempP[x][2]=new PVector(v5.x,v5.y,v5.z-20);
    tempP[x][3]=new PVector(v5.x,v5.y,v5.z+20);
    x++;
    if (pf.x <= p.x)
    {
      //println(pf.x,pf.y,p.x,p.y);
      stroke(255.0, 0.0, 0.0);
      strokeWeight(1.0);  
      line(pf.x, pf.y, pf.z,p.x, p.y,p.z);
      stroke(0.0, 0.0, 255.0);
      strokeWeight(1.0);
      line(p.x, p.y, p.z,pc.x, pc.y, pc.z);
    
  
     stroke(0.0, 255.0, 255.0);
      line(p.x, p.y,p.z, pfx.x, pfx.y ,pfx.z);
     stroke(255.0, 255.0, 0.0);
    // line(p.x, p.y, p.z,pdd.x, pdd.y,pdd.z);
     
     stroke(0.0, 255.0, 255.0);
     line(p.x,  p.y, p.z,v3.x, v3.y,v3.z);
     
     stroke(0, 255.0, 0.0);
     line(p.x,  p.y, p.z,v4.x, v4.y,v4.z);
     line(p.x,  p.y, p.z,v5.x, v5.y,v5.z); 
     
      pf.x= p.x;
      pf.y = p.y;

    }
    
    pushMatrix();
    translate(p.x, p.y, p.z);
    if(t>0&&t<=0.5)
     rotateZ(-aa);
    else if(t==0 || t ==1.0)
     rotateZ(aa/2);
    else
     rotateZ(aa);
    noFill();
   //box(25,20,20);
    popMatrix();
  }
  
  for(int a=0; a<x-1; a++)
  {
    println(tempP[a][0].x,tempP[a][0].y,tempP[a][0].z);
    println(tempP[a][1].x,tempP[a][1].y,tempP[a][1].z);
    println(tempP[a][2].x,tempP[a][2].y,tempP[a][2].z);
    println(tempP[a][3].x,tempP[a][3].y,tempP[a][3].z);
   
    beginShape(QUADS);
    //fill(255,255,255,10);
    stroke(255,255,255);
    vertex(tempP[a][0].x,tempP[a][0].y,tempP[a][0].z);
    vertex(tempP[a][1].x,tempP[a][1].y,tempP[a][1].z);
    vertex(tempP[a][2].x,tempP[a][2].y,tempP[a][2].z);
    vertex(tempP[a][3].x,tempP[a][3].y,tempP[a][3].z);
    
    vertex(tempP[a][0].x,tempP[a][0].y,tempP[a][0].z);
    vertex(tempP[a+1][0].x,tempP[a+1][0].y,tempP[a+1][0].z);
    vertex(tempP[a+1][3].x,tempP[a+1][3].y,tempP[a+1][3].z);
    vertex(tempP[a][3].x,tempP[a][3].y,tempP[a][3].z);
    
    vertex(tempP[a][3].x,tempP[a][03].y,tempP[a][3].z);
    vertex(tempP[a+1][3].x,tempP[a+1][3].y,tempP[a+1][3].z);
    vertex(tempP[a+1][2].x,tempP[a+1][2].y,tempP[a+1][2].z);
    vertex(tempP[a][2].x,tempP[a][2].y,tempP[a][2].z);
    
    vertex(tempP[a][1].x,tempP[a][1].y,tempP[a][1].z);
    vertex(tempP[a+1][1].x,tempP[a+1][1].y,tempP[a+1][1].z);
    vertex(tempP[a+1][2].x,tempP[a+1][2].y,tempP[a+1][2].z);
    vertex(tempP[a][2].x,tempP[a][2].y,tempP[a][2].z);
    
    vertex(tempP[a][0].x,tempP[a][0].y,tempP[a][0].z);
    vertex(tempP[a+1][0].x,tempP[a+1][0].y,tempP[a+1][0].z);
    vertex(tempP[a+1][1].x,tempP[a+1][1].y,tempP[a+1][1].z);
    vertex(tempP[a][1].x,tempP[a][1].y,tempP[a][1].z);
    
    vertex(tempP[a+1][0].x,tempP[a+1][0].y,tempP[a+1][0].z);
    vertex(tempP[a+1][1].x,tempP[a+1][1].y,tempP[a+1][1].z);
    vertex(tempP[a+1][2].x,tempP[a+1][2].y,tempP[a+1][2].z);
    vertex(tempP[a+1][3].x,tempP[a+1][3].y,tempP[a+1][3].z);
    

    endShape();
    
  }
}