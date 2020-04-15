//////////////////////////////////////////////////////////////////////////////////////////
// maths and other generally useful functions are to be added here.


float sqr(float a){
  return a*a;
}

boolean isBetweenInc(float v, float lo, float hi){
    if(v >= lo && v <= hi) return true;
    return false;
  }

boolean nearZero(float v){
  
  if( abs(v) <= EPSILON ) return true;
  return false;
}

// shorthand to get a PVector
PVector vec(float x, float y, float z){
  return new PVector(x,y,z);
}

//////////////////////////////////////////////////////////////////////////////////////////
// 3D geometry and viewing functions if you don't want to use the sim camera
//

//////////////////////////////////////////////////////////////////////////////////////////
// returns a SimRay object into the scene at the mouse position - used for picking

SimRay getMouseRay(){
  PVector mp = getMousePosIn3D(0);
  PVector cameraPos = getCameraPosition();
  SimRay mouseRay = new SimRay(cameraPos,mp);
  return mouseRay;
}



//////////////////////////////////////////////////////////////////////////////////////////
// returns the 3D point in the scene corresponding to the mouse x,y at a specified depth into the scene

PVector getMousePosIn3D(float depthVal){
  PVector mousePos3d = unProject(mouseX, mouseY, depthVal);
  return mousePos3d;
}



//////////////////////////////////////////////////////////////////////////////////////////
// Function to get the position of the viewpoint in the current coordinate system

PVector getCameraPosition() {
  PMatrix3D mat = (PMatrix3D)getMatrix(); //Get the model view matrix
  mat.invert();
  return new PVector( mat.m03, mat.m13, mat.m23 );
}


float getDistanceToCamera(PVector p){
  PVector cp = getCameraPosition();
  return PVector.dist(p,cp);
  
}

void setCamera(PVector pos, PVector lookat){
  camera(pos.x,pos.y, pos.z, lookat.x, lookat.y,lookat.z, 0,1,0);
}




//////////////////////////////////////////////////////////////////////////////////////////
// Performs conversion to the local coordinate system
//( reverse projection ) from the window coordinate system
// i.e. EyeSpace -> WorldSpace

PVector unProject(float winX, float winY, float winZ) {
  PMatrix3D mat = getMatrixLocalToWindow();  
  mat.invert();
 
  float[] in = {winX, winY, winZ, 1.0f};
  float[] out = new float[4];
  mat.mult(in, out);  // Do not use PMatrix3D.mult(PVector, PVector)
 
  if (out[3] == 0 ) {
    return null;
  }
 
  PVector result = new PVector(out[0]/out[3], out[1]/out[3], out[2]/out[3]);  
  return result;
}

//////////////////////////////////////////////////////////////////////////////////////////
// Function to compute the viewport transformation matrix to the window 
// coordinate system from the local coordinate system
PMatrix3D getMatrixLocalToWindow() {
  PMatrix3D projection = ((PGraphics3D)g).projection; 
  PMatrix3D modelview = ((PGraphics3D)g).modelview;   
 
  // viewport transf matrix
  PMatrix3D viewport = new PMatrix3D();
  viewport.m00 = viewport.m03 = width/2;
  viewport.m11 = -height/2;
  viewport.m13 =  height/2;
 
  // Calculate the transformation matrix to the window 
  // coordinate system from the local coordinate system
  viewport.apply(projection);
  viewport.apply(modelview);
  return viewport;
}




/////////////////////////////////////////////////////////////////
// simple rectangle class
//

class Rect{
  
  float left,top,right,bottom;
  
  public Rect(float x1, float y1, float x2, float y2){
    setRect(x1,y1,x2,y2);
  }
  
  void setRect(float x1, float y1, float x2, float y2){
    this.left = x1;
    this.top = y1;
    this.right = x2;
    this.bottom = y2;
  }
  
  PVector getCentre(){
    float cx =  (this.right - this.left)/2.0;
    float cy =  (this.bottom - this.top)/2.0;
    return new PVector(cx,cy);
  }
  
  boolean isPointInside(PVector p){
    // inclusive of the boundries
    if(   isBetweenInc(p.x, this.left, this.right) && isBetweenInc(p.y, this.top, this.bottom) ) return true;
    return false;
  }
  
  float getWidth(){
    return (this.right - this.left);
  }
  
  float getHeight(){
    return (this.bottom - this.top);
  }
  
  
}
