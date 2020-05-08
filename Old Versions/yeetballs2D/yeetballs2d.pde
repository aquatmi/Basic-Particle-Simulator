ArrayList<Ball> balls = new ArrayList<Ball>();
int ball_num;
int counter;
int frameCounter;
int currSec;
int prevSec;

void setup() {
  size(900, 900, P3D);
  ball_num = 50;
  counter = 0;
  frameCounter = 0;
  for (int i = 0; i < ball_num; i++) {
    balls.add(new Ball());
  }
}

void draw() {
  background(255);
  lights();

  frameCounter++;
  currSec = second();
  if (currSec != prevSec) {
    print(frameCounter + "fps, " + balls.size() + " balls\n");
    frameCounter = 0;
    prevSec = currSec;
  }

  checkCollisions();
  for (Ball ball : balls) {
    ball.moveMe();
    ball.drawMe();
  }
}

void keyPressed() {
  print("Key Pressed");
  if (key == CODED) {
    if (keyCode == UP) {
      balls.add(new Ball());
      print("new bol");
    }
    if (keyCode == DOWN) {
      balls.remove(0);
    }
  }
}


void checkCollisions() {
  for (int i = 0; i < balls.size()-1; i++) {
    for (int j = i+1; j< balls.size(); j++) {
      Ball a = balls.get(i);
      Ball b = balls.get(j);
      if (dist(a.pos.x, a.pos.y, b.pos.x, b.pos.y) < a.r+b.r) {
        collisionResponse_mass(a, b);
        a.toggleColour();
        b.toggleColour();
      }
    }
  }
}

void collisionResponse_mass(Ball a, Ball b) {
  PVector v1 = a.vel;
  PVector v2 = b.vel;

  PVector cen1 = a.pos;
  PVector cen2 = b.pos;

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
  ensureNoOverlap(a, b);
}


void ensureNoOverlap(Ball a, Ball b) {
  // the purpose of this method is to avoid ball sticking together:
  // if they are overlapping it moves this ball directly away from the other ball to ensure
  // they are not still overlapping come the next collision check 


  PVector cen1 = a.pos;
  PVector cen2 = b.pos;

  float cumulativeRadii = (a.r + b.r)+2; // extra fudge factor
  float distanceBetween = cen1.dist(cen2);

  float overlap = cumulativeRadii - distanceBetween;
  if (overlap > 0) {
    // move this away from other
    PVector vectorAwayFromOtherNormalized = PVector.sub(cen1, cen2).normalize();
    PVector amountToMove = PVector.mult(vectorAwayFromOtherNormalized, overlap);
    a.pos.add(amountToMove);
  }
}

PVector vec(float x, float y) {
  return new PVector(x, y);
}
