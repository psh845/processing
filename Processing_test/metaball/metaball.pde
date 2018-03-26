PImage img;
int[][] table;
int[]table2; 
String[][] table3;
int wid_img =0;
int heg_img =0;

int cx;
int cy;
int cx2;
int cy2;

void setup()
{
  size(1000, 1000);

  img = loadImage("C:\\Users\\psh\\Pictures\\n52.jpg");
  image(img, 0, 0);
  img.resize(80,80);
  image(img, 0, 0);
  wid_img =img.width;
  heg_img =img.height;
  table = new int[wid_img][heg_img];
  table2 = new int[wid_img*heg_img];
  table3 = new String[wid_img][heg_img];
  noLoop();
}

void draw()
{
  
  //loadPixels();
  //for (int i = 0; i < wid_img; i++) 
  //{
  //  for (int j = 0; j < heg_img; j++) 
  //  {
  //    color a = color(100, 100, 100);
  //    int r = (a >> 16) & 0xFF;
  //    int g = (a >> 8) & 0xFF;  // Faster way of getting red(argb)
  //    int b = a & 0xFF;
  //    //print(r+"\t");
  //    //print(g+"\t");
  //    print(b+"\t");
  //    color aa = get(i, j);
  //    int r1 = (aa >> 16) & 0xFF;
  //    int g1 = (aa >> 8) & 0xFF;  // Faster way of getting red(argb)
  //    int b1= aa & 0xFF;
  //    //print(r1+"\t");
  //    //print(g1+"\t");
  //    print(b1+"\t");
       
  //    if (r+g+b <= r1+g1+b1)
  //    {

  //      table[i][j] = 1;
  //      table2[i*j] = 1;
  //    } else
  //    {

  //      table[i][j] = 0;
  //      table2[i*j] = 0;
  //      //print(b1+"\t");
  //      //print(b+"\t");
  //      //print(table[i]+ "\t");
  //    }
  //    //print(table[i][j]+ "\t");
  //  }
  //}
  //updatePixels();

  for (int i =0; i<wid_img-1; i++)
  {
    for (int j=0; j<heg_img-1; j++)
    {
      rect(100+i*10, 100+j*10, 10, 10);
    }
  }
  //print("\n\n");
  cx=400;
  cy=400;
  cx2=550;
  cy2=550;
  //cx++;
  //cx2--;
  //cy++;
  //cy2--;
  noFill();

   ellipse(cx,cy,300,300);
   ellipse(cx2,cy2,300,300);
  for (int i =0; i<wid_img; i++)
  {
    for (int j=0; j<heg_img; j++)
    {

      int a =j+i*80;
      //print(j+ ":"+a+"\t");
      //fill(table2[j+i*80]*255);
      table[i][j] = int(random(0,1.1)); 
      float dis = sqrt(pow(cx-(100+i*10),2)+pow(cy-(100+j*10),2));
      float dis2 = dist(cx2,cy2,100+i*10,100+j*10);
      float sum = 150*150/(pow(cx-(100+i*10),2)+pow(cy-(100+j*10),2));
      float sum2 = 150*150/(pow(cx2-(100+i*10),2)+pow(cy2-(100+j*10),2));
      print(sum+"\t");
      if(sum>1||sum2>1)
      
      {
          //print(dis+"\t");
          table[i][j] =1;
      }
      else 
        table[i][j] =0;
      fill(table[i][j]*255);
      ellipse(100+i*10, 100+j*10, 3, 3);
    }
  }

  int count =0;

  for (int i =0; i<wid_img-1; i++)
  {

    for (int j=0; j<heg_img-1; j++)
    {

      table3[i][j] = str(table[i][j])+str(table[i+1][j])+str(table[i+1][j+1])+str(table[i][j+1]);
      //print(table3[i][j]+"\t");
      look(table3[i][j],i,j);
      count++;
    }
  }
  //print("\n"+ count);
}



void look(String s,int i, int j)
{
  if(!s.equals("1111") && !s.equals("0000"))
  {
    //print(s.toString() +"\t"+ i+"\t"+ j+"\t");
  

   int n = 10/2;
   stroke(255,0,0);
   strokeWeight(2);
   if( s.equals("1110"))
      line(100+i*10,100+j*10+n,100+((i+1)*10)-n,100+((j+1)*10)); //1110 case14
   if( s.equals("1101"))
      line(100+i*10+n,100+((j+1)*10),100+((i+1)*10),100+j*10+n);  //1101  case 13
   if( s.equals("1011"))
      line(100+i*10+n,100+j*10,100+((i+1)*10),100+((j+1)*10)-n);  //1011  case 11
   if( s.equals("0111"))
      line(100+((i+1)*10)-n,100+j*10,100+i*10,100+((j+1)*10)-n);  //0111 case 7
   if( s.equals("0001"))
      line(100+i*10,100+((j+1)*10)-n,100+i*10+n,100+((j+1)*10)); //0001 case 1
   if( s.equals("0010"))
      line(100+((i+1)*10)-n,100+((j+1)*10),100+((i+1)*10),100+((j+1)*10)-n);  //0010 case 2
   if( s.equals("0100"))
     line(100+((i+1)*10)-n,100+j*10,100+((i+1)*10),100+j*10+n); //0100 case 4
   if( s.equals("1000"))
       line(100+i*10+n,100+j*10,100+i*10,100+j*10+n); //1000  case 8
   if( s.equals("1100"))
      line(100+i*10,100+j*10+n,100+((i+1)*10),100+j*10+n);  //1100  case 12
   if( s.equals("1001"))
      line(100+i*10+n,100+j*10,100+i*10+n,100+((j+1)*10));  //1001  case 9
   if( s.equals("0011"))
      line(100+i*10,100+((j+1)*10)-n,100+((i+1)*10),100+((j+1)*10)-n); //0011  case 3
   if( s.equals("0110"))
      line(100+((i+1)*10)-n,100+j*10,100+((i+1)*10)-n,100+((j+1)*10));  //0110  case 6
   if( s.equals("1010"))
   {
      line(100+i*10,100+j*10+n,100+((i+1)*10)-n,100+((j+1)*10)); //1110   case 10
      line(100+i*10+n,100+j*10,100+((i+1)*10),100+((j+1)*10)-n);  //1011
   }
   if( s.equals("0101"))
   {
      line(100+i*10+n,100+((j+1)*10),100+((i+1)*10),100+j*10+n);  //1101  case 5
      line(100+((i+1)*10)-n,100+j*10,100+i*10,100+((j+1)*10)-n);  //0111
   }
  }
}