class Particle extends SimSphere {
  String test = "test";
  PVector vel;
  int mass = 1;
  float radius = 2.5;
  PVector centre;

  Particle() {
    this.vel = vec(random(-0.5, 0.5), random(-0.5, 0.5), random(-0.5, 0.5));
    this.setRadius(radius);
    centre = vec(random(-40, 40), random(-40, 40), random(-40, 40));
    this.setCentre(centre);
  }

  void moveMe() {
    centre = vec(this.getCentre().x + this.vel.x, this.getCentre().y + this.vel.y, this.getCentre().z + this.vel.z);
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
