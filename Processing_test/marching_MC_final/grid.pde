class GRIDCELL
{
  float x;
  float y;
  float z;
  float val;

  FloatList VAL;
  PVector p[];
  PVector c[];
  PVector cc;
  int add;
  int add_c;
  GRIDCELL()
  {
    x= 0;
    y= 0;
    z=0;
    val = 0;
    add =0;
    add_c =0;
    p = new PVector[8]; 
    c= new PVector[8];
    cc = new PVector();
    VAL = new FloatList();
    
    
  }

  void set(float _x, float _y, float _z, float density)
  {
    x = _x;
    y = _y;
    z = _z;
    val = density;
    p[add++] = new PVector(x, y, z);
    //p[i].set(x,y,z);
    VAL.append(val);
  }
  void setColor(PVector C)
  {
      c[add_c++] = new PVector(C.x,C.y,C.z);
      cc.add(C);
  }
  
  void divColor()
  {
     cc.div(add_c); 
  }
}