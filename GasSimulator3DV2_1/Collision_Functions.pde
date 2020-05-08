void moveParticles(ArrayList<Particle> pl, int pCount) {
  for (int i = 0; i < pl.size(); i++) {
    Particle p = pl.get(i);
    p.moveMe(pMult);
    if (p.getCentre().x >= bSize-pRad) { 
      p.bounce("x");
    }
    if (p.getCentre().x <= -bSize+pRad) {
      p.bounce("-x");
    }
    if (p.getCentre().y >= bSize-pRad) {
      p.bounce("y");
    }
    if (p.getCentre().y <= -bSize+pRad) {
      p.bounce("-y");
    }
    if (p.getCentre().z >= bSize-pRad) {
      p.bounce("z");
    }
    if (p.getCentre().z <= -bSize+pRad) {
      p.bounce("-z");
    }
  }
}

void checkForCollisionSimSphere(ArrayList<Particle> pl, int pCount) {
  for (int i = 0; i < pl.size()-1; i++) {
    for (int j = i+1; j< pl.size(); j++) {
      Particle a = pl.get(i);
      Particle b = pl.get(j);
      if (a.intersectsSphere(b)) {
        //print("bonk \n");
        collisionResponse_mass(a, b);
      }
    }
  }
}
void checkForCollisionShortList(ArrayList<Particle> pl, int pCount) {
  if (unlocked) {
    for (int i = 0; i < pl.size()-1; i++) {
      for (int j = i+1; j< pl.size(); j++) {
        Particle a = pl.get(i);
        Particle b = pl.get(j);
        float gap = a.centre.dist(b.centre); //dist(a.centre.x, a.centre.y, a.centre.z, b.centre.x, b.centre.y, b.centre.z);
        if (gap < 10) {
          if (a.intersectsSphere(b)) {
            //print("bonk \n");
            collisionResponse_mass(a, b);
          }
        }
      }
    }
  } else {
    for (int i = 0; i < pCount-1; i++) {
      for (int j = i+1; j< pCount; j++) {
        Particle a = pl.get(i);
        Particle b = pl.get(j);
        float gap = a.centre.dist(b.centre); //dist(a.centre.x, a.centre.y, a.centre.z, b.centre.x, b.centre.y, b.centre.z);
        if (gap < 10) {
          if (a.intersectsSphere(b)) {
            //print("bonk \n");
            collisionResponse_mass(a, b);
          }
        }
      }
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
  ensureNoOverlap(a, b);
}


void ensureNoOverlap(Particle a, Particle b) {
  // the purpose of this method is to avoid ball sticking together:
  // if they are overlapping it moves this ball directly away from the other ball to ensure
  // they are not still overlapping come the next collision check 
  PVector cen1 = a.centre;
  PVector cen2 = b.centre;

  float cumulativeRadii = (a.getRadius() + b.getRadius())+0.5; // extra fudge factor
  float distanceBetween = cen1.dist(cen2);

  float overlap = cumulativeRadii - distanceBetween;
  if (overlap > 0) {
    // move this away from other
    PVector vectorAwayFromOtherNormalized = PVector.sub(cen1, cen2).normalize();
    PVector amountToMove = PVector.mult(vectorAwayFromOtherNormalized, overlap);
    a.moveMe(amountToMove);
  }
}
