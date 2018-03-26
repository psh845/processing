import processing.opengl.*;
//import com.processinghacks.triangulate.*;

//Vector triangles = new Vector();
ArrayList<PVector> points = new ArrayList<PVector>();
float Xpos=0;
float Ypos=0;
float Zpos=0;

float z= 0;
float StepsH=100;
float StepsV =100;

void setup(){
 size(600, 600,OPENGL);

 background(0);
 lights();
 stroke(255);
 smooth();
 createPoints();
}

void createPoints (){


 for (int i = 1; i<=StepsV;i++){

   rotateY(radians(360/StepsV));
   for (float a = 90; a < 270; a+=(360/StepsV)*2) {


     float lineLength= width/3;
     float Xpos1=Xpos + ( cos(radians(a)) * lineLength );
     float Ypos1=Ypos + ( sin(radians(a)) * lineLength );
     float Zpos1=Zpos + ( sin(radians(z-HALF_PI) * lineLength) );

     points.add(new PVector(Xpos1,Ypos1,0));
     println("addElement");  

   }
 }

}  

void draw(){

 translate(width/2, height/2,0);
 background(0);
 ///*
 //////////////////////////////////////////////////////////////////
 camera(mouseX, mouseY, 220.0, // eyeX, eyeY, eyeZ
 0.0, 0.0, 0.0, // centerX, centerY, centerZ
 mouseX, 1.0, 0.0); // upX, upY, up
 /////////////////////////////////////////////////////////////////
 //*/

 stroke(255);
 strokeWeight(0.5);

 /*  float Xpos=0;
  float Ypos=0;
  float Zpos=0;
  
  float z= 0;
  float StepsH=100;
  float StepsV =100;
  */
 pushMatrix();

 for (int i = 1; i<=StepsV;i++){
   rotateY(radians(360/StepsV));
//    for (float a = 90; a < 270; a+=(360/StepsV)*2) {

   PVector p = points.get(i);
   stroke(0,255,0);
   ellipse(p.x,p.y,2.5,2.5);
//  }

 }
 /*  for (int i = 1; i<=StepsV;i++){
  
  rotateY(radians(360/StepsV));
  for (float a = 90; a < 270; a+=(360/StepsV)*2) {
  
  
  float lineLength= width/3;
  float Xpos1=Xpos + ( cos(radians(a)) * lineLength );
  float Ypos1=Ypos + ( sin(radians(a)) * lineLength );
  float Zpos1=Zpos + ( sin(radians(z-HALF_PI) * lineLength) );
  
  points.addElement(new Point3f(Xpos1,Ypos1,0));
  println("addElement");  
  
  stroke(0,255,0);
  ellipse(Xpos1,Ypos1,2.5,2.5);
  
  }
  }
  */
 popMatrix();
 //endShape();
}