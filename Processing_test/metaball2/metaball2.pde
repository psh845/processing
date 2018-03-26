 //<>//
float[][] table;
int[][] table2; 
String[][] table3;
int wid_img =0;
int heg_img =0;
int g_size =0;
IntList cx;
IntList cy;
IntList radius;
IntList weight;
float threshold=0;
int a;
int b;

void setup()
{
  size(1000, 1000);

  wid_img = width/10;
  heg_img = height/10;
  g_size = 10;
  
  Grid_squre(wid_img, heg_img, g_size, 10);
  a=650;
  b=1;

 noLoop();
}

void draw()
{

  background(0);
  table = new float[wid_img+1][heg_img+1];
  table2 = new int[wid_img+1][heg_img+1];
  table3 = new String[wid_img+1][heg_img+1];
  cx = new IntList();
  cy = new IntList();
  radius = new IntList();
  weight = new IntList();

  stroke(0);
  strokeWeight(1);
  fill(0);
  Grid_squre(wid_img, heg_img, g_size, 10);

  cx.append(500);
  cy.append(350);
  radius.append(150);
  weight.append(2);
  if (a > height-200) 
  {
    a = height-200;
    b*=-1;
  } else if (a < 0+100) {
    a = 0+100;
    b*=-1;
  }
  a+=(b*10);
  cx.append(500);
  cy.append(a);
  radius.append(150);
  weight.append(2);

  fill(0, 0, 255, 100);
  //nofill();
  ellipse(cx.get(0), cy.get(0), radius.get(0)*2, radius.get(0)*2);
  ellipse(cx.get(1), cy.get(1), radius.get(1)*2, radius.get(1)*2);

  threshold = 1.01;
  //metaball or small circle color
  for (int i =0; i<=wid_img; i++)
  {
    for (int j=0; j<=heg_img; j++)
    {

      table[i][j]=metaball(i, j, g_size, 0);
      //print(table[i][j] + "\t");
      if (table[i][j] >= threshold)
      {
        table2[i][j] = 1;
        //print(i+","+j+":"+table[i][j] + "\t");
      } else
      {
        table2[i][j] = 0;
      }

      fill(table2[i][j]*255);
      Grid_circle(g_size, 3, i, j);
    }
  }

  //marching squre 
  for (int i =0; i<wid_img; i++)
  {

    for (int j=0; j<heg_img; j++)
    {
      table3[i][j] = str(table2[i][j])+str(table2[i+1][j])+str(table2[i+1][j+1])+str(table2[i][j+1]);

      look(table3[i][j], i, j, g_size);
    }
  }
  //print("\n"+ count);
}


void Grid_squre(int wid_img, int heg_img, int squre_size, int g_size)
{
  for (int i =0; i<wid_img; i++)
  {

    for (int j=0; j<heg_img; j++)
    {
      rect(i*g_size, j*g_size, squre_size, squre_size);
    }
  }
}

void Grid_circle(int g_size, int radius, int x, int y)
{

  ellipse(x*g_size, y*g_size, radius, radius);
}


float metaball(int x, int y, int g_size, int button)
{
  
  float sum= 0;
  for (int n=0; n<radius.size(); n++)
  {

    //float d = sqrt(pow(cx.get(n)-(x*g_size), 2)+pow(cy.get(n)-(y*g_size), 2));
    float d= dist(cx.get(n), cy.get(n), x*g_size, y*g_size);
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


void look(String s, int i, int j, int g_size)
{
  if (!s.equals("1111") && !s.equals("0000"))
  {
    //print(s.toString() +"\t"+ i+"\t"+ j+"\t");

    int n = g_size/2;
    stroke(255, 0, 0);
    strokeWeight(2);
    if ( s.equals("1110"))
      line(i*g_size, j*g_size+n, ((i+1)*g_size)-n, ((j+1)*g_size)); //1110 case14
    if ( s.equals("1101"))
      line(i*g_size+n, ((j+1)*g_size), ((i+1)*g_size), j*g_size+n);  //1101  case 13
    if ( s.equals("1011"))
      line(i*g_size+n, j*g_size, ((i+1)*g_size), ((j+1)*g_size)-n);  //1011  case 11
    if ( s.equals("0111"))
      line(((i+1)*g_size)-n, j*g_size, i*g_size, ((j+1)*g_size)-n);  //0111 case 7
    if ( s.equals("0001"))
      line(i*g_size, ((j+1)*g_size)-n, i*g_size+n, ((j+1)*g_size)); //0001 case 1
    if ( s.equals("0010"))
      line(((i+1)*g_size)-n, ((j+1)*g_size), ((i+1)*g_size), ((j+1)*g_size)-n);  //0010 case 2
    if ( s.equals("0100"))
      line(((i+1)*g_size)-n, j*g_size, ((i+1)*g_size), j*g_size+n); //0100 case 4
    if ( s.equals("1000"))
      line(i*g_size+n, j*g_size, i*g_size, j*g_size+n); //1000  case 8
    if ( s.equals("1100"))
      line(i*g_size, j*g_size+n, ((i+1)*g_size), j*g_size+n);  //1100  case 12
    if ( s.equals("1001"))
      line(i*g_size+n, j*g_size, i*g_size+n, ((j+1)*g_size));  //1001  case 9
    if ( s.equals("0011"))
      line(i*g_size, ((j+1)*g_size)-n, ((i+1)*g_size), ((j+1)*g_size)-n); //0011  case 3
    if ( s.equals("0110"))
      line(((i+1)*g_size)-n, j*g_size, ((i+1)*g_size)-n, ((j+1)*g_size));  //0110  case 6
    if ( s.equals("1010"))
    {
      line(i*g_size, j*g_size+n, ((i+1)*g_size)-n, ((j+1)*g_size)); //1110   case 10
      line(i*g_size+n, j*g_size, ((i+1)*g_size), ((j+1)*g_size)-n);  //1011
    }
    if ( s.equals("0101"))
    {
      line(i*g_size+n, ((j+1)*g_size), ((i+1)*g_size), j*g_size+n);  //1101  case 5
      line(((i+1)*g_size)-n, j*g_size, i*g_size, ((j+1)*g_size)-n);  //0111
    }
  }
}