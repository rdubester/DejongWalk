void drawDejong(float a, float b, float c, float d, int[] count, int rows, int cols) {
  
  for (int iter = 0; iter < iterations; iter++) {
    //println(iter);
    randomPoints(points);
    for (int step = 0; step < steps; step++) {
      //println(" " + step);
      for (int i = 0; i < numPoints; i++) {
        PVector p = points[i];
        int x = (int) map(p.x, -2, 2, 20, width - 21);
        int y = (int) map(p.y, -2, 2, 20, height - 21);
        // println(x,y,(int) (y * rows + x));
        if (step > 15)
          count[(y * cols + x)]++;
          
        // (height - 1) * cols + width - 1
        // (height - 1) * width + width - 1
        // width * height - width + width - 1
        // width * height - 1

        //if (step > 5){
        //  stroke(255, 3);
        //  point(x, y);
        //}
        

        points[i] = dejongIFS(p, a, b, c, d);
      }
    }
  }
}

PVector dejongIFS(PVector p, float a, float b, float c, float d) {
  float x = sin(a * p.y) - cos(b * p.x);
  float y = sin(c * p.x) - cos(d * p.y);
  return new PVector(x, y);
}
