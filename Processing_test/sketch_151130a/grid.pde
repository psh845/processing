class GRIDCELL
{
  float x;
  float y;
  float z;
  float val;

  FloatList VAL;
  PVector p[];
  int add;

  GRIDCELL()
  {
    x= 0;
    y= 0;
    z=0;
    val = 0;
    add =0;
    
    p = new PVector[8]; 
    VAL = new FloatList();
  }

  void set(float _x, float _y, float _z, float density)
  {
    x = _x;
    y = _y;
    z = _z;
    val = density;
    p[add++] = new PVector(x,y,z);
    //p[i].set(x,y,z); //<>//
    VAL.append(val);
    
    
    
  }
}