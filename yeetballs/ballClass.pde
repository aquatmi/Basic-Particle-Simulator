class Ball {
  int r;
  int d;
  PVector vel;
  PVector pos;
  ArrayList<Ball> ballList; 
  color colour;
  int mass = 1;
  Ball() {
    this.r = 20;
    d = r*2;
    colour = color(255, 255, 255);
    this.vel = vec(random(-5, 5), random(-5, 5)); 
    this.pos = vec(random(20, width-20), random(20, height-20));
  }

  void drawMe() {
    strokeWeight(1);
    ellipseMode(CENTER);
    fill(colour);
    ellipse(pos.x, pos.y, d, d);
  }

  void moveMe() {
    //bounceWalls(); 
    passWalls();
    pos.x += vel.x; 
    pos.y += vel.y;
  }

  void passWalls() {
    if (pos.x-r < 0) { 
      pos.x = width-r;
    }
    if (pos.x+r > width) {
      pos.x = 0+r;
    }
    if (pos.y-r < 0) { 
      pos.y = width-r;
    }
    if (pos.y+r > width) {
      pos.y = 0+r;
    }
  }

  void bounceWalls() {
    if (pos.x-r < 0) { 
      pos.x = 0+r;
      vel.x *= -1;
    }
    if (pos.x+r > width) {
      pos.x = width-r;
      vel.x *= -1;
    }
    if (pos.y-r < 0) { 
      pos.y = 0+r;
      vel.y *= -1;
    }
    if (pos.y+r > width) {
      pos.y = width-r;
      vel.y *= -1;
    }
  }

  void toggleColour() {
    if (colour == color(160, 100, 180)) {
      colour = color(20, 220, 180);
    } else {
      colour = color(160, 100, 180);
    }
  }
}
