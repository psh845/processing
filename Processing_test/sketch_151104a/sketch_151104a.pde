PImage img;
int[][] table;
int[]table2; 
String[][] table3;

void setup()
{
  size(1000, 1000);

  img = loadImage("C:\\Users\\psh\\Pictures\\n52.png");
  image(img, 0, 0);

  table = new int[80][80];
  table2 = new int[80*80];
  table3 = new String[80][80];
  noLoop();
}

void draw()
{

  loadPixels();
  for (int i = 0; i < 80; i++) 
  {
    for (int j = 0; j < 80; j++) 
    {
      color a = color(100, 100, 100);
      int r = (a >> 16) & 0xFF;
      int g = (a >> 8) & 0xFF;  // Faster way of getting red(argb)
      int b = a & 0xFF;
      //print(r+"\t");
      //print(g+"\t");
      //print(b+"\t");
      color aa = get(i, j);
      int r1 = (aa >> 16) & 0xFF;
      int g1 = (aa >> 8) & 0xFF;  // Faster way of getting red(argb)
      int b1= aa & 0xFF;
      //print(r1+"\t");
      //print(g1+"\t");
      //print(b1+"\t");
      if (b <= b1)
      {

        table[i][j] = 1;
        table2[i*j] = 1;
      } else
      {

        table[i][j] = 0;
        table2[i*j] = 0;
        //print(b1+"\t");
        //print(b+"\t");
        //print(table[i]+ "\t");
      }
      //print(table[i][j]+ "\t");
    }
  }
  updatePixels();

  for (int i =0; i<79; i++)
  {
    for (int j=0; j<79; j++)
    {
      rect(100+i*10, 100+j*10, 10, 10);
    }
  }
  //print("\n\n");
  for (int i =0; i<80; i++)
  {
    for (int j=0; j<80; j++)
    {

      int a =j+i*80;
      //print(j+ ":"+a+"\t");
      //fill(table2[j+i*80]*255);
      fill(table[i][j]*255);
      ellipse(100+i*10, 100+j*10, 3, 3);
    }
  }

  int count =0;

  for (int i =0; i<79; i++)
  {

    for (int j=0; j<79; j++)
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
  if(!s.equals("1111") && !s.equals("0000")) //<>//
  {
    print(s.toString() +"\t"+ i+"\t"+ j+"\t"); //<>//
  

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