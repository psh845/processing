size(500, 500, P3D); //<>//
PShape s;
translate(width/2, height/2, 0);
int N = 24; // Mesh resolution
float radius = 100;
float height = 0;
int i, j = 0;
int i1, i2, i3, i4;
float theta, phi;
PVector p[] = new PVector[(N+1)*(N/2+1)];
PVector p1[] = new PVector[(N+1)*(N/2+1)];
PVector rp[] = new PVector[(N+1)*(N/2+1)];
PVector rp1[] = new PVector[(N+1)*(N/2+1)];
int index =0;
int index2=0;
int index3=0;

strokeWeight(3);
for (j=0; j<=N/2; j++) { // top cap
  for (i=0; i<=N; i++) {
    theta = i * TWO_PI / N;
    phi =  -PI * j /N;
    p[index] = new PVector();
    p[index].x= radius * cos(phi) * cos(theta); 
    p[index].y = radius * sin(phi);
    p[index].z= radius * cos(phi) * sin(theta);

    rp[index] = new PVector();
    rp[index].x = p[index].x*cos(radians(0))+p[index].y*sin(radians(0));
    rp[index].y = -p[index].x*sin(radians(0))+p[index].y*cos(radians(0));
    rp[index].z = p[index].z;
    // p[index].y -= 50;

    point(rp[index].x, rp[index].y, rp[index].z);
    print(index+"\n");
    print(rp[index].x, rp[index].y, rp[index].z+"\n");

    index++;
  }
}
for (j=0; j<=N/2; j++) { // bottom cap
  for (i=0; i<=N; i++) {
    theta = i * TWO_PI / N;
    phi = PI * j /N;
    p1[index2] = new PVector();
    p1[index2].x = radius * cos(phi) * cos(theta);
    p1[index2].y = radius * sin(phi);
    p1[index2].z = radius * cos(phi) * sin(theta);

    rp1[index2] = new PVector();
    rp1[index2].x = p1[index2].x*cos(radians(60))+p1[index2].y*sin(radians(60));
    rp1[index2].y = -p1[index2].x*sin(radians(60))+p1[index2].y*cos(radians(60));
    rp1[index2].z = p1[index2].z;

    // p1[index2].y += 50;
    point(rp1[index2].x, rp1[index2].y, rp1[index2].z);
    index2++;
  }
}

index3=0;
for (j=0; j<N/2; j++) {
  for (i=0; i<N; i++) {
    i1 =  j*(N+1)  + i;
    i2 = (j+1)   * (N+1) + i    ;
    i3 =  (j+1) * (N+1) + (i + 1)  ;
    i4 =  (j) * (N+1)+ (i + 1);
    print(i1, i2, i3, i4+"\n");

    beginShape(QUADS);
    vertex(rp[i1].x, rp[i1].y, rp[i1].z);
    vertex(rp[i2].x, rp[i2].y, rp[i2].z);
    vertex(rp[i3].x, rp[i3].y, rp[i3].z);
    vertex(rp[i4].x, rp[i4].y, rp[i4].z);
    endShape(CLOSE);
    print(index2);
    index3++;
  }
}

//for (j=0; j<N/2; j++) {
//  for (i=0; i<N; i++) {
//    i1 =  j*(N+1)  + i;
//    i2 = (j+1)   * (N+1) + i    ;
//    i3 =  (j+1) * (N+1) + (i + 1)  ;
//    i4 =  (j) * (N+1)+ (i + 1);
//    print(i1, i2, i3, i4+"\n");

//    beginShape(QUADS);
//    vertex(p1[i1].x, p1[i1].y, p1[i1].z);
//    vertex(p1[i2].x, p1[i2].y, p1[i2].z);
//    vertex(p1[i3].x, p1[i3].y, p1[i3].z);
//    vertex(p1[i4].x, p1[i4].y, p1[i4].z);
//    endShape(CLOSE);
//    print(index2);
//    index2++;
//  }
//}