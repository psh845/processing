int w = 200;
size(w, 120);
for (int i = 0; i < w; i++) {
  float x = (float)i/(float)w;
  float b = x;
  float ib = b * 255;
  stroke(ib);
  line(i, 0, i, 119);
}
