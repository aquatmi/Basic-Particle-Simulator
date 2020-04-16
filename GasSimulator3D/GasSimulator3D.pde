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
  fill(200);
  // create camera
  myCamera = new SimCamera();
  myCamera.setPositionAndLookat(vec(100, -20, 200), vec(0, 0, 0));
  // starter objects
  cage = new SimBox();
  cage.setTransformAbs(vec(0, 0, 0), 50, 0, 0, 0);
  particles = new ArrayList<Particle>();
  for (int i = 0; i < 50; i++) {
    particles.add(new Particle());
  }
}

void draw() {
  background(255);
  lights();
  myCamera.update();


  // calculate fps
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
    if (p.getCentre().x >= 48) {
      p.bounce("x");
    }
    if (p.getCentre().x <= -48) {
      p.bounce("-x");
    }
    if (p.getCentre().y >= 48) {
      p.bounce("y");
    }
    if (p.getCentre().y <= -48) {
      p.bounce("-y");
    }
    if (p.getCentre().z >= 48) {
      p.bounce("z");
    }
    if (p.getCentre().z <= -48) {
      p.bounce("-z");
    }
  }

  // Particle Collision
  for (int i = 0; i < particles.size()-1; i++) {
    for (int j = i+1; j< particles.size(); j++) {
      Particle a = particles.get(i);
      Particle b = particles.get(j);
      if (a.intersectsSphere(b)) {
        //print("bonk \n");
        collisionResponse_mass(a, b);
      }
    }
  }

  // draw particles
  for (Particle p : particles) {
    p.drawMe();
  }
  // Draw Cage
  pushMatrix();
  stroke(0);
  strokeWeight(5);
  noFill();
  cage.drawMe();
  popMatrix();
  
  
  
  // DRAW HUD FEATURES BETWEEN THESE FUNCTIONS
  myCamera.startDrawHUD();
  // fps
  if (fps != -1) {
    pushMatrix();
    fill(0);
    rect(10, 10, 55, 25);
    popMatrix();
    fill(50, 255, 50);
    textSize(20);
    textAlign(LEFT, CENTER);
    text(fps + "fps", 10, 20);
  }
  // sliders
  myCamera.endDrawHUD();
}

void keyPressed() {
  if (key == CODED) {
  }
}
