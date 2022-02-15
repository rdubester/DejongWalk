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
    t += 0.005;
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
int numFrames = 300;
int windup = 0;
float shutterAngle = 1.0001;

Mode mode = Mode.PLAY;
//Mode mode = Msode.INSPECT;
//Mode mode = Mode.RECORD;

//////////////////////////////////////////////////////////////////////

int numPoints = 40000;
int iterations = 10;
int steps = 40;
int iter = 0;

PVector[] points;
int[] count;

void setup() {

  size(600, 600, P2D);
  result = new int[width*height][3];
  count = new int[width*height];
  blendMode(ADD);
  background(0);

  points = new PVector[numPoints];
}

void draw_(float t) {
  
  float tt = t;

  //background(0);
  count = new int[width*height];
  //float a = 2.6794055837885518;
  //float b = 2.45212306296863;
  //float c = -1.7515416509942803;
  //float d = 0.5026476820226775;
  float a = -2;
  float b = -2;
  float c = -1.2;
  float d = 2;
  
  a += 0.2*sin(tt * TAU);
  b += 0.2*cos(tt * TAU);
  c += 0.2*sin((tt-0.2) * TAU);
  d += 0.2*cos(tt * TAU);


  drawDejong(a, b, c, d, count, height, width);
  setPixels();
}


color[] colors = {color(100,100,255), color(255,100,100)};
void setPixels() {
  println(frameCount);
  loadPixels();
  float maxVal = 0;
  float avgVal = 0;
  for (int i : count) {
    if (i > maxVal) {
      maxVal = i;
      avgVal += i;
    }
  }
  avgVal /= count.length;
  println(maxVal, avgVal);
  
  for (int i = 0; i < pixels.length; i++) {
    float p = constrain(count[i]/maxVal, 0, 0.99);
    float p_o = pow(p,0.25);
    float p_c = pow(p,0.4);
    //println(p, pp);
    color c = lerpColors(colors, p_c);
    color cc = lerpColor(color(0), c, p_o);
    pixels[i] = cc;
  }
  updatePixels();
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

  //int[] hist = new int[20];
  //for(int i : count) {
  //  hist[(int) (i * 19 / maxVal)]++;
  //}
  //println(hist);
