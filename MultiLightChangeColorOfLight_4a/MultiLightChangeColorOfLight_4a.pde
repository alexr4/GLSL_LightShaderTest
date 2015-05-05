/* inspiration from 
https://processing.org/tutorials/pshader/
and
https://github.com/processing/processing/blob/master/core/src/processing/opengl/LightVert.glsl
*/

PShape can;
float angle;

PShader pixlightShader;

void setup() {
  size(640, 360, P3D);
  can = createCan(100, 200, 32);
  pixlightShader = loadShader("pixlightfrag.glsl", "pixlightvert.glsl");
}

void draw() {    
  background(0);
  
  shader(pixlightShader);
  
  float redData = 250 ;
  float greenData = 25 ;
  float blueData = 25 ;
  float alphaData = 125 ;
  Vec4 colorLightOne = new Vec4(redData, greenData, blueData, alphaData) ;
  Vec4 colorLightTwo = new Vec4(greenData, blueData,  redData, alphaData) ;
  Vec4 colorLightThree = new Vec4(blueData, redData,  greenData, alphaData) ;
  
  float posLightX = mouseX ;
  float posLightY = mouseY ;
  float posLightZ = 200 ;
  Vec3 posLightOne = new Vec3(posLightX, posLightY, posLightZ) ;
  posLightX = width -mouseX ;
  posLightY = height -mouseY ;
  Vec3 posLightTwo = new Vec3(posLightX, posLightY, posLightZ) ;
  posLightX = width *sin(frameCount *.002) ;
  posLightY = height *sin(frameCount *.01) ;
  Vec3 posLightThree = new Vec3(posLightX, posLightY, posLightZ) ;
  
  float dirX = 0 ;
  float dirY = 0 ;
  float dirZ = -1 ;
  Vec3 dirLight = new Vec3(dirX, dirY, dirZ) ;
  
  float ratio = 1.2 +(5 *abs(sin(frameCount *.003))) ;
  
  float angle = TAU/ratio ; // good from PI/2 to
  float concentration = 1+ 100 *abs(sin(frameCount *.004)); // try 1 > 1000

  
  spotLightShader(colorLightOne, posLightOne, dirLight, angle, concentration, pixlightShader) ;
  spotLightShader(colorLightTwo, posLightTwo, dirLight, angle, concentration, pixlightShader) ;
  spotLightShader(colorLightThree, posLightThree, dirLight, angle, concentration, pixlightShader) ;

  translate(width/2, height/2);
  rotateY(angle);  
  shape(can);  
  angle += 0.01;
  

}

// annexe
void spotLightShader(Vec4 rgba, Vec3 pos, Vec3 dir, float angle, float concentration, PShader s) {
   float alpha = map(rgba.a,0,255,0,1) ;
   spotLight(rgba.r *alpha, rgba.g *alpha, rgba.b *alpha, pos.x, pos.y, pos.z, dir.x, dir.y, dir.z, angle, concentration) ;
}


// object
PShape createCan(float r, float h, int detail) {
  textureMode(NORMAL);
  PShape sh = createShape();
  sh.beginShape(QUAD_STRIP);
  sh.noStroke();
  sh.fill(255,255,255) ;
  for (int i = 0; i <= detail; i++) {
    float angle = TWO_PI / detail;
    float x = sin(i * angle);
    float z = cos(i * angle);
    float u = float(i) / detail;
    sh.normal(x, 0, z);
    sh.vertex(x * r, -h/2, z * r, u, 0);
    sh.vertex(x * r, +h/2, z * r, u, 1);    
  }
  sh.endShape(); 
  return sh;
}
