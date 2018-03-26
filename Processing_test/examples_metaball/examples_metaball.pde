Cell[] cells;
int cellSize = 10;
float extraBlobby = -0.02;

int numMovers = 20;
ArrayList<Mover> movers = new ArrayList<Mover>();

void setup() {
  size(600, 200);

  int numX = ceil( width / (float) cellSize );
  int numY = ceil( height / (float) cellSize );
  cells = new Cell[ numX * numY ];
  for (int x = 0; x < numX; x++) {
    for (int y = 0; y < numY; y++) {
      int index = y * numX + x;
      cells[index] = new Cell(x*cellSize, y*cellSize, cellSize);
    }
  }

  for (int i = 0; i < numMovers; i++) {
    movers.add( new Mover(random(width), random(height), random(20, 40)) );
  }
}

void draw() {
  background(0);

  for (int i = 0; i < cells.length; i++) {
    cells[i].update();
    cells[i].display();
  }

  for (int i = 0; i < movers.size(); i++) {
    Mover m = movers.get(i);
    m.run();
  }
}

class Cell {
  float x, y;
  int cellSize;
  Corner[] corners;

  int config;

  Cell(float _x, float _y, int _cs) {
    x = _x;
    y = _y;
    cellSize = _cs;
    corners = new Corner[4];
    setupCorners();
  }

  void setupCorners() {
    corners[0] = new Corner(x, y);
    corners[1] = new Corner(x+cellSize, y);
    corners[2] = new Corner(x+cellSize, y+cellSize);
    corners[3] = new Corner(x, y+cellSize);
  }

  int getConfig() {
    int[] states = new int[corners.length]; 
    for (int i = 0; i < states.length; i++) {
      corners[i].setTotalScore();
      if (corners[i].getTotalScore() >= 1) states[i] = 1;
    }
    String bin = str(states[0]) + str(states[1]) + str(states[2]) + str(states[3]); 
    return unbinary(bin);
  }

  PVector interpolate(Corner one, Corner two) {
    float x, y = 0;
    float delta = two.getTotalScore() - one.getTotalScore();
    if (one.x == two.x) {
      x = one.x;
      if (delta == 0) y = abs(two.y - one.y) * 0.5;
      else y = one.y + (two.y-one.y) * (1-one.getTotalScore()) / delta;
    } else {
      y = one.y;
      if (delta == 0) x = abs(two.x - one.x) * 0.5;
      else x = one.x + (two.x-one.x) * (1-one.getTotalScore()) / delta;
    }
    PVector result = new PVector(x, y);
    return result;
  }

  void update() {
    config = getConfig();
  }

  void display() {
    /*
    noFill();
    stroke(120);
    strokeWeight(1);
    rectMode(CORNER);
    rect(x, y, cellSize, cellSize);
    */

    // top, right, bottom, left
    PVector t = interpolate(corners[0], corners[1]);
    PVector r = interpolate(corners[1], corners[2]);
    PVector b = interpolate(corners[2], corners[3]);
    PVector l = interpolate(corners[3], corners[0]);

    stroke(255);
    switch(config) {
    case 0:
      break;
    case 1:
      line(l.x, l.y, b.x, b.y);
      break;
    case 2:
      line(b.x, b.y, r.x, r.y);
      break;
    case 3:
      line(l.x, l.y, r.x, r.y);
      break;
    case 4:
      line(t.x, t.y, r.x, r.y);
      break;
    case 5:
      line(l.x, l.y, b.x, b.y);
      line(t.x, t.y, r.x, r.y);
      break;
    case 6:
      line(t.x, t.y, b.x, b.y);
      break;
    case 7:
      line(l.x, l.y, t.x, t.y);
      break;
    case 8:
      line(l.x, l.y, t.x, t.y);
      break;
    case 9:
      line(t.x, t.y, b.x, b.y);
      break;
    case 10:
      line(l.x, l.y, t.x, t.y);
      line(b.x, b.y, r.x, r.y);
      break;
    case 11:
      line(t.x, t.y, r.x, r.y);
      break;
    case 12:
      line(l.x, l.y, r.x, r.y);
      break;
    case 13:
      line(b.x, b.y, r.x, r.y);
      break;
    case 14:
      line(l.x, l.y, b.x, b.y);
      break;
    case 15:
      break;
    }
  }
}

class Corner {
  float x;
  float y;
  float totalScore;

  Corner(float _x, float _y) {
    x = _x;
    y = _y;
    totalScore = 0;
  }

  boolean isInsideCircle(float _cx, float _cy, float _radius) {
    float sqDist = sq(x - _cx) + sq(y - _cy);
    float sqRadius = sq(_radius);
    return sqDist <= sqRadius;
  }

  float getScoreFromCircle(float _cx, float _cy, float _radius) {
    float sqDist = sq(x - _cx) + sq(y - _cy);
    if (sqDist == 0) sqDist = 0.01; // arbitrary value to avoid dividing by 0
    float sqRadius = sq(_radius);
    float score = extraBlobby + (sqRadius / sqDist);
    return score;
  }

  void setTotalScore() {
    float sum = 0.0;
    for (int i = 0; i < movers.size(); i++) {
      Mover m = movers.get(i);
      sum += getScoreFromCircle(m.loc.x, m.loc.y, m.moverRadius);
    }
    totalScore = sum;
  }

  float getTotalScore() {
    return totalScore;
  }
}

class Mover {
  PVector loc;
  PVector vel;
  PVector acc;
  float moverRadius;

  Mover(float _x, float _y, float _r) {
    loc = new PVector(_x, _y);
    vel = PVector.random2D();
    //acc = new PVector();
    vel.mult(random(.5, 1));
    moverRadius = _r;
  }

  void run() {
    checkEdges();
    update();
    //display();
  }

  void checkEdges() {
    if (loc.x < 0 || loc.x > width) vel.x *= -1;
    if (loc.y < 0 || loc.y > height) vel.y *= -1;
  }

  void update() {
    //vel.add(acc);
    loc.add(vel);
    //acc.mult(0); // reset
  }

  void display() {
    pushStyle();
    noFill();
    stroke(255, 0, 0);
    strokeWeight(2);
    ellipse(loc.x, loc.y, moverRadius*2, moverRadius*2);
    popStyle();
  }
}