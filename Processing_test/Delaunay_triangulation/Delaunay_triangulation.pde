/**
* Delaunay Triangulations
*
* @author aa_debdeb
* @date 2015/12/02
*/
 
void setup(){
  size(500, 500);
  background(255);
  smooth();
  noLoop();
   
  ArrayList<Point> points = new ArrayList<Point>();
  for(int i = 0; i < 100; i++){
    points.add(new Point(random(width), random(height)));
  }
  ArrayList<Triangle> triangles = new ArrayList<Triangle>();
   
  float globalRadious = sqrt(sq(width) + sq(height)) / 2.0;
  Point globalPoint1 = new Point(width/2.0 - sqrt(3) * globalRadious,height/2.0 - globalRadious); //upper left                            
  Point globalPoint2 = new Point(width/2.0 + sqrt(3) * globalRadious,height/2.0 - globalRadious); //upper right
  Point globalPoint3 = new Point(width/2.0, height/2.0 + 2.0 * globalRadious); // lower center
   
  Triangle globalTriangle = new Triangle(globalPoint1, globalPoint2, globalPoint3);
   
  triangles.add(globalTriangle);
   
  for(Point point : points){
    ArrayList<Triangle> dividedTrianglesQueue = new ArrayList<Triangle>();
    for(Triangle triangle: triangles){
      if(triangle.isInTriangle(point)){
        dividedTrianglesQueue.add(triangle);       
      }
    }
    while(!dividedTrianglesQueue.isEmpty()){
      Triangle dividedTriangle = dividedTrianglesQueue.remove(0);
      triangles.remove(dividedTriangle);
      Triangle newTriangle1 = new Triangle(dividedTriangle.point1, dividedTriangle.point2, point);
      Triangle newTriangle2 = new Triangle(dividedTriangle.point1, point, dividedTriangle.point3);
      Triangle newTriangle3 = new Triangle(point, dividedTriangle.point2, dividedTriangle.point3);
      Side leagalizedEdge1 = new Side(dividedTriangle.point1, dividedTriangle.point2);
      Side leagalizedEdge2 = new Side(dividedTriangle.point1, dividedTriangle.point3);
      Side leagalizedEdge3 = new Side(dividedTriangle.point2, dividedTriangle.point3);
      ArrayList<Triangle> leagalizedTriangleQueue = new ArrayList<Triangle>();
      ArrayList<Side> leagalizedSideQueue = new ArrayList<Side>();
      leagalizedTriangleQueue.add(newTriangle1);
      leagalizedTriangleQueue.add(newTriangle2);
      leagalizedTriangleQueue.add(newTriangle3);
      leagalizedSideQueue.add(leagalizedEdge1);
      leagalizedSideQueue.add(leagalizedEdge2);
      leagalizedSideQueue.add(leagalizedEdge3);
 
      while(!leagalizedTriangleQueue.isEmpty()){
        Triangle leagalizedTriangle = leagalizedTriangleQueue.remove(0);
        Side leagalizedSide = leagalizedSideQueue.remove(0);
        Triangle triangleWithSameSide = findTriangleWithSameSide(triangles, leagalizedSide);
        if(triangleWithSameSide == null){
          triangles.add(leagalizedTriangle);
        } else {
          Point notOnSidePoint = triangleWithSameSide.getPointNotOnSide(leagalizedSide);
          if(leagalizedTriangle.isInCircumcircle(notOnSidePoint)){
            // flip
            triangles.remove(triangleWithSameSide);
            Point notOnSidePoint2 = leagalizedTriangle.getPointNotOnSide(leagalizedSide);
            leagalizedTriangleQueue.add(new Triangle(leagalizedSide.point1, notOnSidePoint, notOnSidePoint2));
            leagalizedSideQueue.add(new Side(leagalizedSide.point1, notOnSidePoint));
            leagalizedTriangleQueue.add(new Triangle(leagalizedSide.point2, notOnSidePoint, notOnSidePoint2));
            leagalizedSideQueue.add(new Side(leagalizedSide.point2, notOnSidePoint));
          } else {
            triangles.add(leagalizedTriangle);
          }
        }
      }
    }
  }
   
  noFill();
  stroke(0);
  strokeWeight(1);
  for(Triangle triangle: triangles){
    if(!triangle.hasGlobalPoint(globalPoint1, globalPoint2, globalPoint3)){
      triangle.display();
    }
  }
   
  fill(0);
  noStroke();
  for(Point point : points){
    point.display();
  }
   
}
 
Triangle findTriangleWithSameSide(ArrayList<Triangle> triangles, Side side){
  for(Triangle triangle: triangles){
    if(side.hasPoints(triangle.point1, triangle.point2) ||
       side.hasPoints(triangle.point1, triangle.point3) ||
       side.hasPoints(triangle.point2, triangle.point3)){
         return triangle;
       }
  }
  return null;
}
 
class Point {
 
  float x;
  float y;
   
  Point(float x, float y){
    this.x = x;
    this.y = y;
  }
   
  void display(){
    ellipse(x, y, 10, 10);
  }
}
 
class Side {
  Point point1;
  Point point2;
   
  Side(Point point1, Point point2){
    this.point1 = point1;
    this.point2 = point2;
  }
   
  boolean hasPoints(Point p1, Point p2){
    return (point1 == p1 && point2 == p2) || (point1 == p2 && point2 == p1);
  }
   
  boolean equals(Side side){
    return (point1 == side.point1 && point2 == side.point2) || (point1 == side.point2 && point2 == side.point1);
  }
   
}
 
class Triangle {
     
  Point point1;
  Point point2;
  Point point3;
  Point circumcircleCenter;
  float circumcircleRadious; 
   
  Triangle(Point point1, Point point2, Point point3){
    this.point1 = point1;
    this.point2 = point2;
    this.point3 = point3;
    float c = 2.0 * ((point2.x - point1.x) * (point3.y - point1.y) - (point2.y - point1.y) * (point3.x - point1.x));
    float centerX = ((point3.y - point1.y) * (sq(point2.x) - sq(point1.x) + sq(point2.y) - sq(point1.y)) +
                     (point1.y - point2.y) * (sq(point3.x) - sq(point1.x) + sq(point3.y) - sq(point1.y))) / c;
    float centerY = ((point1.x - point3.x) * (sq(point2.x) - sq(point1.x) + sq(point2.y) - sq(point1.y)) +
                     (point2.x - point1.x) * (sq(point3.x) - sq(point1.x) + sq(point3.y) - sq(point1.y))) / c;
    circumcircleCenter = new Point(centerX, centerY);
    circumcircleRadious = getDistance(point1, circumcircleCenter);
  }
   
  boolean isInTriangle(Point p){
    float c1 = (point3.x - point2.x) * (p.y - point2.y) - (point3.y - point2.y) * (p.x - point2.x);
    float c2 = (point1.x - point3.x) * (p.y - point3.y) - (point1.y - point3.y) * (p.x - point3.x);
    float c3 = (point2.x - point1.x) * (p.y - point1.y) - (point2.y - point1.y) * (p.x - point1.x);
    return (c1 > 0 && c2 > 0 && c3 > 0) || (c1 < 0 && c2 < 0 && c3 < 0);
  }
   
  boolean isInCircumcircle(Point p){
    return getDistance(p, circumcircleCenter) < circumcircleRadious;
  }
 
  float getDistance(Point p1, Point p2){
    return sqrt(sq(p1.x - p2.x) + sq(p1.y - p2.y));
  }
   
  boolean hasGlobalPoint(Point gp1, Point gp2, Point gp3){
    return ((gp1 == point1 || gp1 == point2 || gp1 == point3) ||
            (gp2 == point1 || gp2 == point2 || gp2 == point3) ||
            (gp3 == point1 || gp3 == point2 || gp3 == point3));
  }
   
  Point getPointNotOnSide(Side side){
    Side side1 = new Side(point1, point2);
    Side side2 = new Side(point1, point3);
    Side side3 = new Side(point2, point3);
    if(side.equals(side1)){
      return point3;
    } else if(side.equals(side2)){
      return point2;
    } else if(side.equals(side3)){
      return point1;
    } else {
      return null;
    }
  }
   
  void display(){
    triangle(point1.x, point1.y, point2.x, point2.y, point3.x, point3.y);
  }
}