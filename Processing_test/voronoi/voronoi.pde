float[] x = {}; 


float[] y = {}; 


float[] d = {}; 


int[] c = {}; 


void setup() { 


  size(400,400); 


  background(0); 

  for( int i=0; i<10; i++ ) 
  {
      x = append(x,random(400)); 


      y = append(y,random(400)); 


      d = append(d,0); 


      c = append(c,color(random(255),random(255),random(255))); 

  }

} 


  


void draw() { 


  for( int xx=0; xx<width; xx++ ) { 


    for( int yy=0; yy<height; yy++) { 


      int idx = 0; 


      float dd; 


      dd = dist(x[0],y[0],xx,yy); 


      for( int i=1; i<d.length; i++ ) { 


        float d0 = dist(x[i],y[i],xx,yy); 

        if( dd > d0 ) { 

          dd = d0; 

          idx = i; 


        } 


      } 


      set(xx,yy,c[idx]); 


    } 


  } 

  
  noStroke(); 


  for( int i=0; i<x.length; i++ ) { 


    ellipse(x[i],y[i],5,5); 


  } 


} 


