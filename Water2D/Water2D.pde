float[] landHeight, waterHeight, rotAmount;
int numElems = 32;
float g_SCALING_FACTOR = 1.0 / 100.0;
float g_DAMPENING_FACTOR = 9.9 / 10.0;

void setup() {
  size(640, 360, P2D);
  frameRate(60);
  
  landHeight = new float[numElems];
  waterHeight = new float[numElems];
  rotAmount = new float[numElems];
  for( int i = 0; i < numElems; ++i) {
    landHeight[i] = 255.0;
    waterHeight[i] = 0.0;
    rotAmount[i] = 0.0;
  }
  waterHeight[20] = 255.0;
  waterHeight[19] = 255.0;
  for( int i = 5; i < 27; ++i) {
    landHeight[i] = 1.0;
  }
}

void draw() {
  background(0);
  
  addWater();
  
  updateRotAmount();
  applyRotAmount();
  
  drawSurface();
  drawWaterSurface();
  
  printWaterAmount();
}

void addWater() {
  waterHeight[0] += random(0.0, 5.0);
}

void updateRotAmount() {
  float diff = 0.0;
  
  for(int i = 0; i < numElems-1; ++i) {
    diff = (landHeight[i]+waterHeight[i] - (landHeight[i+1]+waterHeight[i+1])) * g_SCALING_FACTOR;
    diff = constrain(diff, min(0.0, -waterHeight[i+1]), max(0.0, waterHeight[i]));
    rotAmount[i] -= diff;
    rotAmount[i+1] += diff;
  }
}

void applyRotAmount() {
  for(int i = 0; i < numElems; ++i) {
    rotAmount[i] *= g_DAMPENING_FACTOR;
    //if((waterHeight[i] + rotAmount[i]) < 0) {
    //  waterHeight[i] = 0.0;
    //}
    //else waterHeight[i] += rotAmount[i];
    waterHeight[i] += rotAmount[i];
  }
}

void drawSurface() {
  PShape surface = createShape();
  surface.beginShape();
  surface.noFill();
  surface.stroke(127, 63, 0);
  surface.strokeWeight(2.0);
  for(int i = 0; i < numElems; ++i) {
    surface.vertex(i*width/(numElems-1), -landHeight[i]);
  }
  surface.endShape();
  shape(surface, 0, height-1);
}

void drawWaterSurface() {
  PShape surface = createShape();
  surface.beginShape();
  surface.noFill();
  surface.stroke(0, 196, 255, 127);
  surface.strokeWeight(2.0);
  for(int i = 0; i < numElems; ++i) {
    surface.vertex(i*width/(numElems-1), -waterHeight[i]-landHeight[i]);
  }
  surface.endShape();
  shape(surface, 0, height-1);
}

void printWaterAmount() {
  float sum = 0.0;
  for(int i = 0; i < numElems; ++i) {
    sum += waterHeight[i];
  }
  print("The basin contains ");print(sum);println(" units of water");
}
