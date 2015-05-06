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
PShape canNormals;
float angle;

PShader pixlightShader;

ArrayList<PtLight> lightPos;

PVector backgroundColor;
PVector glslBackgroundColor;

void setup() {
  size(1280, 720, P3D);
  
  backgroundColor = new PVector(40, 40, 40);
  glslBackgroundColor = new PVector();
  glslBackgroundColor.x = map(backgroundColor.x, 0, 255, 0, 1);
  glslBackgroundColor.y = map(backgroundColor.y, 0, 255, 0, 1);
  glslBackgroundColor.z = map(backgroundColor.z, 0, 255, 0, 1);

  //mesh;
  defineVertex(10, 10, 50, 150);
  can = createPoly();
  canNormals = createNormalPoly();

  //shader & lights
  defineLight(8);
  pixlightShader = loadShader("pixlightfrag.glsl", "pixlightvert.glsl");
  pixlightShader.set("kd", new PVector(0.25, 0.25, 0.25));
  pixlightShader.set("ka", new PVector(0.5, 0.5, 0.5));
  pixlightShader.set("ks", new PVector(1, 1, 1));
  pixlightShader.set("emissive", new PVector(0.1, 0.1, 0.1));
  pixlightShader.set("shininess", 10.0);
  pixlightShader.set("fogMinDist", 50.0);
  pixlightShader.set("fogMaxDist", 2000.0);
  pixlightShader.set("fogColor", glslBackgroundColor);

  //camera
  cam = new PeasyCam(this, 500);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(2000);
}

void draw() {
  //translate(0, 0, abs(sin(frameCount * 0.005) * 2000) * -1);
  rotateX(frameCount * 0.001);
  rotateY(frameCount * 0.001);
  rotateZ(frameCount * 0.001);
  background(backgroundColor.x, backgroundColor.y, backgroundColor.z);

  for (PtLight p : lightPos)
  {
    p.updates();
   /* stroke(p.r, p.g, p.b);
    point(p.x, p.y, p.z);*/
    pointLight(p.r, p.g, p.b, p.x, p.y, p.z);
  }

  //shape
  shader(pixlightShader);
  shape(can); 
  //shape(canNormals);   

  //drawAxis(250, "RVB");
}

void defineLight(int nb)
{
  lightPos = new ArrayList<PtLight>();

  for (int i=0; i<nb; i++)
  {

    lightPos.add(new PtLight());
  }
}


void defineVertex(float thetaOffset, float etaOffset, float minRadius, float maxRadius)
{
  //vertices generation
  cols = round(180 / thetaOffset);
  rows = round(360 / etaOffset);
  vertice = new PVector[cols][rows];
  

  for (int i = 0; i<cols; i++)
  {
    for (int j = 0; j<rows; j++)
    { 
       
     // float radius = random(minRadius, maxRadius);
      float radius = minRadius + noise(i, j) * (maxRadius - minRadius);// * maxRadius;
     

      float alpha = map(i, 0, cols-1, 0, PI);
      float beta = map(j, 0, rows-1, 0, TWO_PI);

      float x =  sin(alpha)*cos(beta)*radius;
      float y =  sin(alpha)*sin(beta)*radius;
      float z =  cos(alpha)*radius;

      if (j < rows-1)
      {
        vertice[i][j] = new PVector(x, y, z);
      } else
      {
        PVector v = vertice[i][0];
        vertice[i][j] = v;//new PVector(0, 0, 0);
      }
    }
  }
}

PShape createPoly()
{
  //Shape creation
  PShape sh = createShape();
  PVector origin = new PVector(0, 0, 0);
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

      PVector gabc = getGravityPoint(v0, v1, v2, v3);
      gabc.normalize();

      PVector n = PVector.sub(gabc, origin);

      PVector n0 = new PVector(0, 0, 0);
      n0.add(n);
      n0.add(nV0);
      n0.div(2);

      PVector n1 = new PVector(0, 0, 0);
      n1.add(n);
      n1.add(nV1);
      n1.div(2);

      PVector n2 = new PVector(0, 0, 0);
      n2.add(n);
      n2.add(nV0);
      n2.div(2);

      PVector n3 = new PVector(0, 0, 0);
      n3.add(n);
      n3.add(nV0);
      n3.div(2);


      //sh.stroke(255, 2);
      sh.fill(255);
      sh.noStroke();
      //sh.strokeWeight(1);
      //sh.noFill();

      //sh.normal(n.x, n.y, n.z);
      //sh.normal(n0.x, n0.y, n0.z);
      sh.normal(nV0.x, nV0.y, nV0.z);
      sh.vertex(v0.x, v0.y, v0.z);

      //sh.normal(n.x, n.y, n.z);    
      //sh.normal(n1.x, n1.y, n1.z);
       sh.normal(nV1.x, nV1.y, nV1.z);
      sh.vertex(v1.x, v1.y, v1.z);

      //sh.normal(n.x, n.y, n.z); 
      //sh.normal(n2.x, n2.y, n2.z);
      sh.normal(nV2.x, nV2.y, nV2.z);
      sh.vertex(v2.x, v2.y, v2.z);

      //sh.normal(n.x, n.y, n.z); 
      //sh.normal(n3.x, n3.y, n3.z);
      sh.normal(nV3.x, nV3.y, nV3.z);
      sh.vertex(v3.x, v3.y, v3.z);
    }
  }

  sh.endShape(CLOSE);

  return sh;
}

PShape createNormalPoly()
{
  //Shape creation
  PShape sh = createShape(GROUP);
  PVector origin = new PVector(0, 0, 0);

  for (int i =0; i<cols; i++)
  {
    for (int j=0; j<rows; j++)
    {
      PVector v0 = vertice[i][j];

      PVector nV0 = PVector.sub(v0, origin);
      nV0.normalize();
      nV0.mult(2.5);
      nV0.add(v0);

      PShape child = createShape();

      child.beginShape(LINES);
      child.stroke(127, 0, 127);
      child.vertex(v0.x, v0.y, v0.z);
      child.vertex(nV0.x, nV0.y, nV0.z);
      child.endShape();

      sh.addChild(child);
    }
  }

  return sh;
}

PVector getGravityPoint(PVector a, PVector b, PVector c, PVector d)
{
  PVector gabc = new PVector(0, 0, 0);
  gabc.add(a);
  gabc.add(b);
  gabc.add(c);
  gabc.add(d);
  gabc.div(4);

  return gabc;
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

