SimCamera myCamera;
SimBox cage;
ArrayList<Particle> particles;

// fps
int frameCounter = 0;
int currSec;
int prevSec;
int fps = -1;



void setup() { 
  size(600, 600, P3D);
  noStroke();
  // create camera
  myCamera = new SimCamera();
  myCamera.setPositionAndLookat(vec(100, -20, 200), vec(0, 0, 0));
  // starter objects
  cage = new SimBox();
  cage.setTransformAbs(vec(0, 0, 0), 50, 0, 0, 0);
  particles = new ArrayList<Particle>();
  for (int i = 0; i < 100; i++) {
    particles.add(new Particle());
  }
}

void draw() {
  background(255);
  lights();
  myCamera.update();


  // display fps
  frameCounter++;
  currSec = second();
  if (currSec != prevSec) {
    print(frameCounter + "fps \n");
    fps = frameCounter;
    frameCounter = 0;
    prevSec = currSec;
  }

  // Update Particles
  for (Particle p : particles) {
    p.moveMe();
    if (p.getCentre().x > 48 || p.getCentre().x < -48) {
      p.bounce("x");
    }
    if (p.getCentre().y > 48 || p.getCentre().y < -48) {
      p.bounce("y");
    }
    if (p.getCentre().z > 48 || p.getCentre().z < -48) {
      p.bounce("z");
    }
  }
  
  // Particle Collision
  for (int i = 0; i < particles.size()-1; i++) {
    for (int j = i+1; j< particles.size(); j++) {
      Particle a = particles.get(i);
      Particle b = particles.get(j);
      if (dist(a.centre.x, a.centre.y, b.centre.x, b.centre.y) < a.radius+b.radius) {
        print("bonk \n");
        collisionResponse_mass(a, b);
      }
    }
  }

  // DRAW HUD FEATURES BETWEEN THESE FUNCTIONS
  myCamera.startDrawHUD();
  if (fps != -1) {
    pushMatrix();
    fill(0);
    rect(10, 10, 55, 25);
    popMatrix();
    fill(50,255,50);
    textSize(20);
    textAlign(LEFT, CENTER);
    text(fps + "fps", 10, 20);
  }
  myCamera.endDrawHUD();

  // Draw Cage
  pushMatrix();
  stroke(0);
  strokeWeight(5);
  noFill();
  cage.drawMe();
  popMatrix();
  // draw particles
  for (Particle p : particles) {
    p.drawMe();
  }
}

void keyPressed() {
  if (key == CODED) {
  }
}

class Particle extends SimSphere {
  String test = "test";
  PVector vel;
  int mass = 1;
  int radius = 2;
  PVector centre;

  Particle() {
    this.vel = vec(random(-0.5, 0.5), random(-0.5, 0.5), random(-0.5, 0.5));
    this.setRadius(radius);
    centre = getOrigin();
  }

  void moveMe() {
    centre =vec(this.getCentre().x + this.vel.x, this.getCentre().y + this.vel.y, this.getCentre().z + this.vel.z);
    this.setCentre(centre);
  }
  
  void moveMe(PVector move){
    centre.add(move);
    this.setCentre(centre);
  }

  public void bounce(String axis) {
    //print("Centre: " + getCentre() + "\n");
    //print("bounce " + axis + "\n");
    switch (axis) {
    case "x":
      this.vel.x *= -1;
      //print("new Vel: " + this.vel + "\n");
      break;
    case "y":
      this.vel.y *= -1;
      //print("new Vel: " + this.vel + "\n");
      break;
    case "z":
      this.vel.z *= -1;
      //print("new Vel: " + this.vel + "\n");
      break;
    }
  }
}

void collisionResponse_mass(Particle a, Particle b) {
  PVector v1 = a.vel;
  PVector v2 = b.vel;

  PVector cen1 = a.centre;
  PVector cen2 = b.centre;

  // calculate v1New, the new velocity of this mover
  float massPart1 = 2*b.mass / (a.mass + b.mass);
  PVector v1subv2 = PVector.sub(v1, v2);
  PVector cen1subCen2 = PVector.sub(cen1, cen2);
  float topBit1 = v1subv2.dot(cen1subCen2);
  float bottomBit1 = cen1subCen2.mag()*cen1subCen2.mag();

  float multiplyer1 = massPart1 * (topBit1/bottomBit1);
  PVector changeV1 = PVector.mult(cen1subCen2, multiplyer1);

  PVector v1New = PVector.sub(v1, changeV1);

  // calculate v2New, the new velocity of other mover
  float massPart2 = 2*a.mass/(a.mass + b.mass);
  PVector v2subv1 = PVector.sub(v2, v1);
  PVector cen2subCen1 = PVector.sub(cen2, cen1);
  float topBit2 = v2subv1.dot(cen2subCen1);
  float bottomBit2 = cen2subCen1.mag()*cen2subCen1.mag();

  float multiplyer2 = massPart2 * (topBit2/bottomBit2);
  PVector changeV2 = PVector.mult(cen2subCen1, multiplyer2);

  PVector v2New = PVector.sub(v2, changeV2);

  a.vel = v1New;
  b.vel = v2New;
  //ensureNoOverlap(a, b);
}


void ensureNoOverlap(Particle a, Particle b) {
  // the purpose of this method is to avoid ball sticking together:
  // if they are overlapping it moves this ball directly away from the other ball to ensure
  // they are not still overlapping come the next collision check 


  PVector cen1 = a.centre;
  PVector cen2 = b.centre;

  float cumulativeRadii = (a.radius + b.radius)+0.2; // extra fudge factor
  float distanceBetween = cen1.dist(cen2);

  float overlap = cumulativeRadii - distanceBetween;
  if (overlap > 0) {
    // move this away from other
    PVector vectorAwayFromOtherNormalized = PVector.sub(cen1, cen2).normalize();
    PVector amountToMove = PVector.mult(vectorAwayFromOtherNormalized, overlap);
    a.moveMe(amountToMove);
  }
}
