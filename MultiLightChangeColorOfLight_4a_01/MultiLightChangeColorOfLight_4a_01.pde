/* inspiration from 
 https://processing.org/tutorials/pshader/
 and
 https://github.com/processing/processing/blob/master/core/src/processing/opengl/LightVert.glsl
 */
import peasy.*;

PeasyCam cam;

int cols, rows;
PVector[][] vertice;
PShape can;
float angle;

PShader pixlightShader;

void setup() {
  size(1280, 720, P3D);
  can = createRandomPoly(20, 20, 100, 125);
  pixlightShader = loadShader("pixlightfrag.glsl", "pixlightvert.glsl");
  
   cam = new PeasyCam(this, 500);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(500);
}

void draw() {    
  background(40);
  //lights();

  float redData = 250 ;
  float greenData = 25 ;
  float blueData = 25 ;
  float alphaData = 125 ;
  Vec4 colorLightOne = new Vec4(redData, greenData, blueData, alphaData) ;
  Vec4 colorLightTwo = new Vec4(greenData, blueData, redData, alphaData) ;
  Vec4 colorLightThree = new Vec4(blueData, redData, greenData, alphaData) ;

  float posLightX = mouseX ;
  float posLightY = mouseY ;
  float posLightZ = 500 ;
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
  
 
  //shape
  shader(pixlightShader);
  shape(can);  
  
  drawAxis(250, "RVB");
}

// annexe
void spotLightShader(Vec4 rgba, Vec3 pos, Vec3 dir, float angle, float concentration, PShader s) {
  float alpha = map(rgba.a, 0, 255, 0, 1) ;
  
  PVector dirF = PVector.sub(new PVector(dir.x, dir.y, dir.z), new PVector(pos.x, pos.y, pos.z));
  dirF.normalize();
  dirF.mult(100);
  dirF.add(new PVector(pos.x, pos.y, pos.z));
  
  spotLight(rgba.r *alpha, rgba.g *alpha, rgba.b *alpha, pos.x, pos.y, pos.z, dir.x, dir.y, dir.z, angle, concentration) ;
  
  pushStyle();
  strokeWeight(5);
  stroke(rgba.r, rgba.g, rgba.b);
  point(pos.x, pos.y, pos.z);
  
  strokeWeight(1);
  line(pos.x, pos.y, pos.z, dirF.x, dirF.y, dirF.z);
  popStyle();
}


PShape createRandomPoly(float thetaOffset, float etaOffset, float minRadius, float maxRadius)
{
  //vertices generation
  cols = round(180 / thetaOffset);
  rows = round(360 / etaOffset);
  vertice = new PVector[cols][rows];

  for (int i = 0; i<cols; i++)
  {
    for (int j = 0; j<rows; j++)
    { 

      float radius = random(minRadius, maxRadius);   

      float alpha = map(i, 0, cols-1, 0, PI);
      float beta = map(j, 0, rows-1, 0, TWO_PI);

      float x =  sin(alpha)*cos(beta)*radius;
      float y =  sin(alpha)*sin(beta)*radius;
      float z =  cos(alpha)*radius;

      vertice[i][j] = new PVector(x, y, z);
    }
  }

  //Shape creation
  PShape sh = createShape();
  PVector origin = new PVector(0,0,0);
  sh.beginShape(QUAD_STRIP);
  for (int i =0; i<cols-1; i++)
  {
    for (int j=0; j<rows-1; j++)
    {
      PVector v0 = vertice[i][j];
      PVector v1 = vertice[i][j+1];
      PVector v2 = vertice[i+1][j];
      PVector v3 = vertice[i+1][j+1];

      PVector nV0 = PVector.sub(v0, origin);
      PVector nV1 = PVector.sub(v1, origin);
      PVector nV2 = PVector.sub(v2, origin);
      PVector nV3 = PVector.sub(v3, origin);
      nV0.normalize();
      nV1.normalize();
      nV2.normalize();
      nV3.normalize();
      nV0.add(v0);
      nV1.add(v1);
      nV2.add(v2);
      nV3.add(v3);
      


      sh.stroke(255, 10);
      sh.fill(127);
      //sh.noStroke();
      //sh.strokeWeight(1);
      //sh.noFill();
      //sh.fill(r0, g0, b0, alpha);
      sh.normal(nV0.x, nV0.y, nV0.z);
      sh.vertex(v0.x, v0.y, v0.z);
      //sh.fill(r1, g1, b1, alpha);
      sh.normal(nV1.x, nV1.y, nV1.z);
      sh.vertex(v1.x, v1.y, v1.z);
      //sh.fill(r2, g2, b2, alpha);
      sh.normal(nV2.x, nV2.y, nV2.z);
      sh.vertex(v2.x, v2.y, v2.z);
      //sh.fill(r3, g3, b3, alpha);
      sh.normal(nV3.x, nV3.y, nV3.z);
      sh.vertex(v3.x, v3.y, v3.z);
    }
  }

  sh.endShape(CLOSE);

  return sh;
}

void drawAxis(float l, String colorMode)
{
  color xAxis = color(255, 0, 0);
  color yAxis = color(0, 255, 0);
  color zAxis = color(0, 0, 255);

  if (colorMode == "rvb" || colorMode == "RVB")
  {
    xAxis = color(255, 0, 0);
    yAxis = color(0, 255, 0);
    zAxis = color(0, 0, 255);
  } else if (colorMode == "hsb" || colorMode == "HSB")
  {
    xAxis = color(0, 100, 100);
    yAxis = color(115, 100, 100);
    zAxis = color(215, 100, 100);
  }

  pushStyle();
  strokeWeight(1);
  //x-axis
  stroke(xAxis); 
  line(0, 0, 0, l, 0, 0);
  //y-axis
  stroke(yAxis); 
  line(0, 0, 0, 0, l, 0);
  //z-axis
  stroke(zAxis); 
  line(0, 0, 0, 0, 0, l);
  popStyle();
}

