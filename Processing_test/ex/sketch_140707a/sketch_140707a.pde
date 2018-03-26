void setup() {
  size(400, 400);
  frameRate(100);
}
int pos = 0;
int a = int(random(4));
int r = int(random(255));
int g = int(random(255));
int b = int(random(255));
void draw() {
  background(204);
  pos++;
  fill(r,g,b);
  geo(a,pos);
  
  //line(pos, 20, pos, 80);
  if (pos > width+100) {
    pos = 0;
    a = int(random(4));
    r = int(random(255));
    g = int(random(255));
    b = int(random(255));
  }
}

void geo(int a, int pos)
{
  
switch(a)
{
 case 0: 
   line(pos, 150, pos, 300);
   break;
 case 1:
   ellipse(pos, 200, 200,  200);
   break;
 case 2:
   rect(pos, 120, 200,  200);
   break;
 case 3:
   triangle(pos, 300, pos+100, 100, pos+200, 300);
   break;
}
}
