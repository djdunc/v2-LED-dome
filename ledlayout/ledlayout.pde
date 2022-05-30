void setup() {
  size(640, 360);
}

void draw() {
  background(102);

  pushMatrix();
  translate(width/2, height/2);
  polygon(0, 0, 120, 6);  // Heptagon
  popMatrix();
}

void polygon(float x, float y, float radius, int npoints) {
  float angle = TWO_PI / npoints;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}
