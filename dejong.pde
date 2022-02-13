int numPoints = 10000;
int iterations = 5;
int steps = 10;
int iter = 0;

PVector[] points;

void drawDejong(float a, float b, float c, float d) {
  for (int iter = 0; iter < iterations; iter++) {
    //println(iter);
    randomPoints(points);
    for (int step = 0; step < steps; step++) {
      //println(" " + step);
      for (int i = 0; i < numPoints; i++) {
        PVector p = points[i];
        float x = map(p.x, -2, 2, 0, width);
        float y = map(p.y, -2, 2, 0, height);

        stroke(255, 8);
        point(x, y);

        points[i] = dejongIFS(p, a, b, c, d);
      }
    }
  }
}

void setup() {

  size(600, 600, P2D);
  blendMode(ADD);
  background(0);

  points = new PVector[numPoints];
}

float t = 0;
void draw() {
  
  background(0);
  float a = 2*sin(t * TAU);
  float b = 2*cos(t * TAU);
  t += 0.001;
  drawDejong(a, b, b, a);
  //noLoop();

  //if (iter < iterations) {
  //  println(iter);
  //  iter++;
  //  for (int i = 0; i < numPoints; i++) {
  //    PVector p = points[i];
  //    float x = map(p.x, -2, 2, 0, width);
  //    float y = map(p.y, -2, 2, 0, height);

  //    stroke(255, 4);
  //    point(x, y);

  //    points[i] = dejongIFS(p, 1.97, -1.6, -1.6, -1.2);
  //  }
  //} else {
  //  randomPoints(points);
  //  iter = 0;
  //}
}

PVector dejongIFS(PVector p, float a, float b, float c, float d) {
  float x = sin(a * p.x) - cos(b * p.y);
  float y = sin(c * p.x) - cos(d * p.y);
  return new PVector(x, y);
}

void randomPoints(PVector[] points) {
  for (int i = 0; i < numPoints; i++) {
    float x = map(random(1), 0, 1, -2, 2);
    float y = map(random(1), 0, 1, -2, 2);
    points[i] = new PVector(x, y);
  }
}

//cool systems!
//1.97, -1.6, -1.6, -1.2
