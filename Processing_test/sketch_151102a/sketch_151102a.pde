size(800,800);

float a =200.0;
int cx= 400;
int cy= 400;


for(float x=-cx; x<=cx; x+=10.0)
{
    for(float y=-cy; y<=cy; y+=10.0)
    {
        float dist = sqrt(x*x + y*y);
        if(dist<=a)
        {
           
           rect(x+cx-5,y+cy-5,10,10);
           //point(x+cx,y+cy);
           
        }
       
    }
     //r++;
}


rect(0,0,20,20);
color red = color(255,0,0);
set(100, 100, red);
noFill();
ellipse(400,400,200.25*2,200.25*2);