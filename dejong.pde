enum Mode {
  PLAY,
    RECORD,
    INSPECT
}

int[][] result;
float t = 0;

void draw() {
  switch (mode) {
    // endless loop
  case PLAY:
    t += 0.01;
    draw_(t % 1);
    break;
    // mouse controls current frame
  case INSPECT:
    t = mouseX/float(width);
    draw_(t);
    break;
    // save to series of PNG files with motion blur
  case RECORD:
    // set all result values to 0
    for (int i=0; i<result.length; i++)
      for (int a=0; a<3; a++)
        result[i][a] = 0;
    // draw each sample for the current frame
    for (int sample=0; sample<samplesPerFrame; sample++) {
      t = map(
        (frameCount - 1) % numFrames + sample*shutterAngle/samplesPerFrame,
        0, numFrames,
        0, 1);
      // draw the sample and save to the pixels array
      draw_(t);
      loadPixels();
      // add the sample rgb values to the corresponding chanel of result
      for (int i=0; i<pixels.length; i++) {
        result[i][0] += pixels[i] >> 16 & 0xff;
        result[i][1] += pixels[i] >> 8 & 0xff;
        result[i][2] += pixels[i] & 0xff;
      }
    }
    // load the result back into the pixel array
    for (int i=0; i<pixels.length; i++) {
      pixels[i] = 0xff << 24 |
        int(result[i][0]/float(samplesPerFrame)) << 16 |
        int(result[i][1]/float(samplesPerFrame)) << 8 |
        int(result[i][2]/float(samplesPerFrame));
    }
    // update the canvas and save to a png
    updatePixels();
    println(frameCount);
    if (frameCount < numFrames * windup) break;
    saveFrame("out/fr####.png");
    println(frameCount, "/", numFrames);
    if (frameCount == numFrames * (windup + 1)) {
      exit();
    }
    break;
  }
}

//////////////////////////////////////////////////////////////////////

int samplesPerFrame = 1;
int numFrames = 500;
int windup = 0;
float shutterAngle = 1.0001;

//Mode mode = Mode.PLAY;
//Mode mode = Msode.INSPECT;
Mode mode = Mode.RECORD;

//////////////////////////////////////////////////////////////////////

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
  result = new int[width*height][3];
  blendMode(ADD);
  background(0);

  points = new PVector[numPoints];
}

void draw_(float t) {

  background(0);
  float a = 2*sin(t * TAU);
  float b = 2*cos(t * TAU);
  float c = 2*sin(-t * TAU);
  float d = 2*cos(-t * TAU);
  drawDejong(a, b, c, d);
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
