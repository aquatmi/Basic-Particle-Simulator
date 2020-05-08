SimpleUI menuUI;
SimpleUI userUI;
SimpleUI quitUI;
SimCamera myCamera;
SimBox cage;
ArrayList<Particle> particles;
String[] menuItems = {"Quit", "Show UI", "Show FPS"};
boolean showUI = true;
boolean showFPS = false;
boolean showQuit = false;
PFont font;


// fps
int frameCounter = 0;
int currSec;
int prevSec;
int fps = -1;


// particles
float pRad = 1.5;
int pMax = 1000;
int pCount = 500;
float pMult = 1.5;
color pColour = color(0, 0, 0);
int bSize = 50;


void setup() { 
  size(600, 600, P3D);
  noStroke();
  fill(200);
  font = createFont("", 32, true);
  textFont(font);
  // create camera and UI
  myCamera = new SimCamera();
  myCamera.setPositionAndLookat(vec(60, -20, 200), vec(0, 0, 0));
  setupUI();
  // starter objects
  cage = new SimBox();
  cage.setTransformAbs(vec(0, 0, 0), bSize, 0, 0, 0);
  particles = new ArrayList<Particle>();
  for (int i = 0; i < pMax; i++) {
    particles.add(new Particle(pRad));
  }
}

void draw() {
  background(255);
  lights();
  directionalLight(128, 128, 128, 0, -1, 1);
  ambientLight(red(pColour), blue(pColour), green(pColour));
  myCamera.update();

  // calculate fps
  frameCounter++;
  currSec = second();
  if (currSec != prevSec) {
    //print(frameCounter + "fps \n");
    fps = frameCounter;
    frameCounter = 0;
    prevSec = currSec;
  }

  // Update Particles
  moveParticles(particles, pCount);

  // Particle Collision
  //checkForCollisionSimSphere(particles);
  checkForCollisionShortList(particles, pCount);

  // draw particles
  for (int i = 0; i < pCount; i++) {
    Particle p = particles.get(i);
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
  noLights();
  lights();
  ambientLight(20, 20, 20);
  textAlign(LEFT, TOP);
  // fps
  if (showFPS) {
    pushMatrix();
    fill(0);
    rect(width-65, 10, 55, 25);
    popMatrix();
    fill(50, 255, 50);
    textSize(20);
    text(fps + "fps", width-65, 10);
  }
  // UI
  menuUI.update();
  if (showUI) { 
    textAlign(LEFT, BOTTOM);
    userUI.update();
    rectMode(RADIUS);
    pushMatrix();

    popMatrix();
    textAlign(LEFT, TOP);
    rectMode(CORNER);
  }
  if (showQuit) {
    pushMatrix();
    fill(140);
    rectMode(RADIUS);
    rect(width/2, height/2, 100, 40);
    fill(0);
    textSize(25);
    textAlign(CENTER, BOTTOM);
    text("Are You Sure?", width/2, (height/2));
    popMatrix();
    rectMode(CORNER);
    textAlign(LEFT, TOP);
    quitUI.update();
  }
  myCamera.endDrawHUD();
  noLights();
}

////////////////////////////////////////////////////////////////////////////////////////
// KEYBOARD INPUT
////////////////////////////////////////////////////////////////////////////////////////

void keyPressed() {
  if (key == 'O' || key == 'o') {
    pMult += 0.01;
    print(pMult);
  }
}

////////////////////////////////////////////////////////////////////////////////////////
// UI INPUT
////////////////////////////////////////////////////////////////////////////////////////

void handleUIEvent(UIEventData uied) {
  if (uied.uiComponentType == "ButtonBaseClass") {
    switch(uied.uiLabel) {
    case "Yes":
      exit();
      break;
    case "No":
      showQuit = false;
      break;
    }
  }
  if (uied.uiComponentType == "Menu") {
    switch(uied.menuItem) {
    case "Quit":
      showQuit = true;
      break;
    case "Show UI":
      showUI = toggle(showUI);
      break;
    case "Show FPS":
      showFPS = toggle(showFPS);
      break;
    }
  }
  if (uied.uiComponentType == "Slider") {
    switch(uied.uiLabel) {
    case "Temperature":
      pMult = uied.sliderValue*5 + 0.1;
      int temp = (int)(uied.sliderValue*255);
      if (temp > 255/2) {
        pColour = color(-255+(temp*2), 0, 0);
      } else {
        pColour = color(0, 255-(temp*2), 0);
      }
      break;
    case "Size":
      pRad = uied.sliderValue*2 + 0.5;
      for (Particle p : particles) { 
        p.setRadius(pRad);
      }
      break;
    case "Pressure":
      pCount = int(uied.sliderValue*999)+1;
      break;
    case "Box Size":
      bSize = int(uied.sliderValue*100)+50;
      cage.setTransformAbs(vec(0, 0, 0), bSize, 0, 0, 0);
      break;
    }
  }
}

void setupUI() {
  // MENU UI
  menuUI = new SimpleUI();
  menuUI.addMenu("Menu", 5, 0, menuItems);
  // USER UI (dumb name i know)
  userUI = new SimpleUI();
  userUI.addSlider("Temperature", 5, 100, 0.5);
  userUI.addSlider("Pressure", 5, 135, 0.5);
  userUI.addSlider("Size", 5, 170, 0.5);
  userUI.addSlider("Box Size", 5, 205, 0);
  // QUIT UI
  quitUI = new SimpleUI();
  quitUI.addPlainButton("Yes", (width/2)-80, height/2);
  quitUI.addPlainButton("No", (width/2)+10, height/2);
}

boolean toggle(boolean b) {
  return !b;
}
