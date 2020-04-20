class Particle extends SimSphere {
  String test = "test";
  PVector vel;
  int mass = 1;
  PVector centre;
  PVector gravity = vec(0, 0.2, 0);

  Particle(float pRad) {
    this.vel = vec(random(-0.5, 0.5), random(-0.5, 0.5), random(-0.5, 0.5));
    this.setRadius(pRad);
    centre = vec(random(-40, 40), random(-40, 40), random(-40, 40));
    this.setCentre(centre);
  }

  void moveMe() {
    centre = this.getCentre().add(vel);
    this.setCentre(centre);
  }

  void moveMe(float mult) {
    PVector tempVel = new PVector();
    tempVel.add(vel);
    tempVel.mult(mult);
    //print("=== \n vel: " + vel + "\n tempVel: " + tempVel + "\n");
    centre = this.getCentre().add(tempVel);
    centre = centre.add(gravity);    
    this.setCentre(centre);
  }

  void moveMe(PVector move) {
    centre.add(move);
    this.setCentre(centre);
  }

  public void bounce(String axis) {
    //print("Centre: " + getCentre() + "\n");
    //print("bounce " + axis + "\n");
    switch (axis) {
    case "-x":
      this.vel.x *= -1;
      this.moveMe(vec(1, 0, 0));
      //print("new Vel: " + this.vel + "\n");
      break;
    case "-y":
      this.vel.y *= -1;
      this.moveMe(vec(0, 1, 0));
      //print("new Vel: " + this.vel + "\n");
      break;
    case "-z":
      this.vel.z *= -1;
      this.moveMe(vec(0, 0, 1));
      //print("new Vel: " + this.vel + "\n");
      break;
    case "x":
      this.vel.x *= -1;
      this.moveMe(vec(-1, 0, 0));
      //print("new Vel: " + this.vel + "\n");
      break;
    case "y":
      this.vel.y *= -1;
      this.moveMe(vec(0, -1, 0));
      //print("new Vel: " + this.vel + "\n");
      break;
    case "z":
      this.vel.z *= -1;
      this.moveMe(vec(0, 0, -1));
      //print("new Vel: " + this.vel + "\n");
      break;
    }
  }
}
