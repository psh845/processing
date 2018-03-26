size(600,400);
float[] wold = {-3,3,-3,3,-1,1};
float[][] vertices ={{-1,-1,-1},{1,-1,-1},{-1,1,-1},{1,1,-1}
                     ,{-1,-1,1},{1,-1,1},{-1,1,1},{1,1,1}};
int [] linenum = {0,1,0,2,1,3,2,3,4,5,4,6,5,7,6,7,0,4,1,5,2,6,3,7};

float[] normalilze ={-1,1,-1,1};
float[][] normalizevertice = new float[8][2];
float tx =0,ty=0,tz=0;
float[][] matrix = {{1,0,0,tx},{0,1,0,ty},{0,0,1,tz}};
float [][]wcs = new float[8][3];
for(int i=0; i<8; i++)
{
  int k=0;
   for(int j=0; j<3; j++)
    {
      if(k==4)
       k=0;
       
       wcs[i][j] = matrix[j][k] * vertices[i][j];
       k++;
    } 
    print(wcs[i][0],wcs[i][1],wcs[i][2]+"\n");
}
for(int i=0; i<8; i++)
{
  normalizevertice[i][0] = (normalilze[1]-(normalilze[0]))*(wcs[i][0]-(wold[0]))/(wold[1]-(wold[0]))-1;
  normalizevertice[i][1] = (normalilze[3]-(normalilze[2]))*(wcs[i][1]-(wold[2]))/(wold[3]-(wold[2]))-1;
  print(normalizevertice[i][0],normalizevertice[i][1]+"\n");
}
float factor = width > height ? height : width;

float widthfactor = width/factor;
float heightfactor = height/factor;
print(factor, widthfactor, heightfactor+"\n");
float[] normalilze2 = {-1*widthfactor,1*widthfactor,-1*heightfactor,1*heightfactor};
float[][] screenvertex = new float[8][2];
//print(width);
for(int j=0; j<8; j++)
{
   screenvertex[j][0] = width * (normalizevertice[j][0] -(normalilze2[0])) / (normalilze2[1]-(normalilze2[0]));
   screenvertex[j][1] = height * (normalilze2[3] - normalizevertice[j][1]) /(normalilze2[3]-(normalilze2[2]));
   print(screenvertex[j][0],screenvertex[j][1]+ "\n");
}
 int a =0;
for(int i=0; i<linenum.length; i++)
{
 
  if(a==24)
    break;
    for(int j=0; j<3; j++)
    {
      line(screenvertex[linenum[a]][0],screenvertex[linenum[a]][1],screenvertex[linenum[a+1]][0],screenvertex[linenum[a+1]][1]);
      a=a+2;  
    }
  
}
save("box2.jpg");






