size(200,200,P3D);  
PVector v1 = new PVector(1,0, 0);
PVector v2 = new PVector(0, 1, 0); 
PVector v3 = v1.cross(v2);
println(v3);  // Prints "[ -40.0, 60.0, -400.0 ]"
line(0,0,0,v1.x,v1.y,v1.z);
line(0,0,0,v2.x,v2.y,v2.z);
line(0,0,0,v3.x,v3.y,v3.z);