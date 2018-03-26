class KochLine {
  

  //[full] A line between two points: start and end
  PVector start;
  PVector end;
  //[end]

  KochLine(PVector a, PVector b)
  {
    start = a.get();
    end = b.get();
  }

  void display() 
  {
    stroke(0);
    // Draw the line from PVector start to end.
    line(start.x, start.y, end.x, end.y);
  }
  
  
  PVector kochA() 
{
    // Note the use of get(), which returns a copy of the PVector. As was noted in
    // Chapter 6, section 14, we want to avoid making copies whenever
    // possible, but here we will need a new PVector in case we want the segments to move
    // independently of each other.
    print(start.get());
    return start.get();
  }

  PVector kochE()
  {
    print(end.get());
    return end.get();
  }
  
  PVector kochB() {
    // PVector from start to end
    PVector v = PVector.sub(end, start);
    // One-third the length
    v.div(3);
    // Add that PVector to the beginning of the line
    // to find the new point.
    v.add(start);
    print(v);
    return v;
  }

  PVector kochD() {
    PVector v = PVector.sub(end, start);
    print(v);
    // Same thing here, only we need to move two-thirds
    // along the line instead of one-third.
    v.mult(2/3.0);
    print(v);
    print(start);
    v.add(start);
    print(v);
    return v;
  }
  
  
  
    PVector kochC() {
    // Start at the beginning.
    PVector a = start.get();
    
    PVector v = PVector.sub(end, start);
    // Move 1/3rd of the way to point B.
    v.div(3);
    a.add(v);
    print(a);
    // Rotate “above” the line 60 degrees.
    v.rotate(-radians(60));
    // Move along that vector to point C.
    a.add(v);
    print(a);
    return a;
  }
}

ArrayList<KochLine> lines;

void setup() {
  size(500, 500);
  background(255);
  lines = new ArrayList<KochLine>();
  PVector start = new PVector(50, 150);
  PVector end   = new PVector(width-50, 150);
 
  PVector v = PVector.sub(end,start);
  PVector a = start.get();
  v.rotate(radians(60));
  a.add(v);
  PVector v1 = PVector.sub(start,end);
  PVector a1 = end.get();
  v1.rotate(-radians(60));
  a1.add(v1);
  lines.add(new KochLine(start, end));
  lines.add(new KochLine(end, a1));
  lines.add(new KochLine(a, start));

  // Arbitrarily apply the Koch rules five times.
  for (int i = 0; i < 5; i++) {
    generate();
  }
}

void draw() {
  background(255);
  for (KochLine l : lines) {
    l.display();
  }
}

void generate() {
  ArrayList next = new ArrayList<KochLine>();
  for (KochLine l : lines) {

    //[full] The KochLine object has five functions,
    // each of which return a PVector according
    // to the Koch rules.
    PVector a = l.kochA();
    PVector b = l.kochB();
    PVector c = l.kochC();
    PVector d = l.kochD();
    PVector e = l.kochE();
    //[end]

    next.add(new KochLine(a, b));
    next.add(new KochLine(b, c));
    next.add(new KochLine(c, d));
    next.add(new KochLine(d, e));
  }

  lines = next;
}



