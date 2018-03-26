import processing.opengl.*;


 float Xpos=0;
 float Ypos=0;
 float Zpos=0;

 float z= 0;
 float StepsV =50;
 float StepsH=StepsV;


void setup(){
 size(600, 600,OPENGL);

 background(0);
 lights();
 stroke(255);
 smooth();
}



void draw(){

 translate(width/2, height/2,0);
 background(0);
 
 //////////////////////////////////////////////////////////////////
 camera(mouseX, mouseY, 220.0, // eyeX, eyeY, eyeZ
 0.0, 0.0, 0.0, // centerX, centerY, centerZ
 mouseX, 1.0, 0.0); // upX, upY, up
 /////////////////////////////////////////////////////////////////
 stroke(255);
 strokeWeight(0.5);

 pushMatrix();

 for (int i = 1; i<=StepsV;i++){

   rotateY(radians(360/StepsV));
   for (float a = 90; a < 270; a+=360/StepsV) {

     pushMatrix();
     float lineLength= width/3;
     float Xpos1=Xpos + ( cos(radians(a)) * lineLength );
     float Ypos1=Ypos + ( sin(radians(a)) * lineLength );
     float Zpos1=Zpos + ( sin(radians(z-HALF_PI) * lineLength) );

     stroke(0,255,0);


     point(Xpos1,Ypos1,Zpos1);

     //ellipse(Xpos1,Ypos1,2,5,2,5);
     popMatrix();
   }
 }

 popMatrix();
 //endShape();
}