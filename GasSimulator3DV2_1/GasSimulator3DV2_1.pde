// The Different UIs that can be enabled
SimpleUI menuUI; // top left menu that allows changes of UI
SimpleUI userUI; // default UI 
SimpleUI quitUI; // ui to question user quitting
SimpleUI unlockedUI; // unlocked ui to allow for custom values

SimCamera myCamera; // camera
SimBox cage; // the box the particles are contained in

ArrayList<Particle> particles;
ArrayList<Particle> u_particles;
String[] menuItems = {"Quit", "Show UI", "Show FPS", "Unlock", "Background"};

boolean showUI = true;    //
boolean showFPS = false;  // bools to show which
boolean showQuit = false; // ui is shown
boolean unlocked = false;  //
boolean showBG = true;

// custom made font to allow for better scaling of text size
PFont font; 
PImage bg;

// fps
int frameCounter = 0;
int currSec;
int prevSec;
int fps = -1;

// particles
float pRad = 1.5;  //radius
int pMax = 1000;   //max amount in locked mode
int pCount = 500;  //amount of particles
float pMult = 1.5; //speed
color pColour = color(40, 40, 40); //colour
int bSize = 50;  //box size


void setup() { 
  //base setup
  size(800, 600, P3D);
  noStroke();
  fill(200);
  bg = loadImage("bg.jpg");

  // make font
  // font file is empty, this causes an error in console,
  // however all it means is processing will use default font
  // which every pc with processing will have.
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
  u_particles = new ArrayList<Particle>();
  for (int i = 0; i < pCount; i++) {
    u_particles.add(new Particle(pRad));
  }
}


void draw() {
  if (showBG) {
    background(bg);
  } else {
    background(255);
  }
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
  if (unlocked) {
    moveParticles(u_particles, pCount);
  } else {
    moveParticles(particles, pCount);
  }

  // Particle Collision
  //checkForCollisionSimSphere(particles);
  checkForCollisionShortList(particles, pCount);

  // draw particles
  if (unlocked) {
    for (int i = 0; i < u_particles.size(); i++) {
      Particle p = u_particles.get(i);
      p.drawMe();
    }
  } else {
    for (int i = 0; i < pCount; i++) {
      Particle p = particles.get(i);
      p.drawMe();
    }
  }

  // Draw Cage
  pushMatrix();
  stroke(0);
  strokeWeight(5);
  noFill();
  cage.drawMe();
  popMatrix();

  // DRAW HUD FEATURES BETWEEN THESE FUNCTIONS
  /////////////////////////////////////////////////////////////////////
  // THERE IS A LOT OF FORMATTING CODE IN THIS SECTION, THAT IS BECAUSE
  // THE WAY THAT DRAWING IS DONE IN YOUR SIM LIBRARIES IS DIFFERENT TO HOW
  // I LIKE TO DO IT SO I CHANGE TO MY FORMATTING, THEN BACK TO YOURS TO
  // THE UI ELEMENTS
  /////////////////////////////////////////////////////////////////////
  myCamera.startDrawHUD();
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
    if (!unlocked) {
      textAlign(LEFT, BOTTOM);
      userUI.update();
      rectMode(RADIUS);
      textAlign(LEFT, TOP);
      rectMode(CORNER);
    } else  {
      textAlign(LEFT, BOTTOM);
      unlockedUI.update();
    }
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
  // I May have needed it, I didnt.
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
      showQuit = true;  // enables showing quit menu
      println(">> showQuit: ", showQuit);
      break;
    case "Show UI":
      showUI = toggle(showUI);  // toggles showing ui
      println(">> showUI: ", showUI);
      break;
    case "Show FPS":
      showFPS = toggle(showFPS); // toggles showing fps
      println(">> showFPS: ", showFPS);
      break;
    case "Unlock":
      unlocked = toggle(unlocked); // toggles unlocking ui
      println(">> unlocked: ", unlocked);
      break;
    case "Background":
      showBG = toggle(showBG);
      println(">> showBG: ", showBG);
      break;
    }
  }

  if (uied.uiComponentType == "Slider") {  // check if user is interacting with a slider
    switch(uied.uiLabel) {  // check which slider user is interacting with
    case "Temperature":  // set speed multiplier depending on slider value
      pMult = uied.sliderValue*5 + 0.1;
      int temp = (int)(uied.sliderValue*255);
      if (temp > 255/2) {                      //
        pColour = color(-255+(temp*2), 40, 40);  // Make more red or blue depending on
      } else {                                 // temperature value
        pColour = color(40, 255-(temp*2), 40);   //
      }                                        
      println(">> pMult: ", pMult);
      println(">> pColour: ", pColour);
      break;
    case "Size":
      pRad = uied.sliderValue*2 + 0.5;
      for (Particle p : particles) { 
        p.setRadius(pRad);
      }
      println(">> pRad: ", pRad);
      break;
    case "Pressure":
      pCount = int(uied.sliderValue*999)+1;
      println(">> pCount: ", pCount);
      break;
    case "Box Size":
      bSize = int(uied.sliderValue*100)+50;
      cage.setTransformAbs(vec(0, 0, 0), bSize, 0, 0, 0);
      println(">> bSize: ", bSize);
      break;
    }
  }
  if (uied.uiComponentType == "TextInputBox") {
    switch(uied.uiLabel) {
    case "Temperature":
      String t_value = uied.textContent;
      if (t_value == null || t_value == "") { 
        return;
      } else {
        t_value = t_value.replaceAll("[^\\d.]", "");
        pMult = Integer.valueOf(t_value);
      }
      println(">> unlocked pMult: ", pMult);
      break;
    case "Size":
      String s_value = uied.textContent;
      if (s_value == null || s_value == "") { 
        return;
      } else {
        s_value = s_value.replaceAll("[^\\d.]", "");
        pRad = Integer.valueOf(s_value);
        for (Particle p : u_particles) { 
          p.setRadius(pRad);
        }
        println(">> unlocked pRad: ", pRad);
      }
      break;
    case "Pressure":
      String p_value = uied.textContent;
      if (p_value == null || p_value == "") { 
        return;
      } else {
        p_value = p_value.replaceAll("[^\\d.]", "");
        pCount = Integer.valueOf(p_value);
        createParticles();
        println(">> unlocked pCount: ", pCount);
      }
      break;
    case "Box Size":
      String b_value = uied.textContent;
      if (b_value == null || b_value == "") { 
        return;
      } else {
        b_value = b_value.replaceAll("[^\\d.]", "");
        bSize = Integer.valueOf(b_value);
        cage.setTransformAbs(vec(0, 0, 0), bSize, 0, 0, 0);
        println(">> unlocked bSize: ", bSize);
      }
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
  userUI.addSlider("Temperature", 5, 135, 0.5);
  userUI.addSlider("Pressure", 5, 170, 0.5);
  userUI.addSlider("Size", 5, 205, 0.5);
  userUI.addSlider("Box Size", 5, 240, 0);
  // QUIT UI
  quitUI = new SimpleUI();
  quitUI.addPlainButton("Yes", (width/2)-80, height/2);
  quitUI.addPlainButton("No", (width/2)+10, height/2);
  // unlocked UI
  unlockedUI = new SimpleUI();
  unlockedUI.addTextInputBox("Temperature", 5, 135);
  unlockedUI.addTextInputBox("Pressure", 5, 170);
  unlockedUI.addTextInputBox("Size", 5, 205);
  unlockedUI.addTextInputBox("Box Size", 5, 240);
  unlockedUI.addLabel("DEFAULTS", 0, height - 15, " Temp= 1.5, Pressure= 500, Size= 1.5, Box Size= 50");
  unlockedUI.addLabel("WARNING", 0, height - 40, " Unlocking can cause performance and crashing issues");
}

boolean toggle(boolean b) {
  return !b;
}

void createParticles() {
  u_particles = new ArrayList<Particle>();
  for (int i = 0; i < pCount; i++) {
    u_particles.add(new Particle(pRad));
  }
}
