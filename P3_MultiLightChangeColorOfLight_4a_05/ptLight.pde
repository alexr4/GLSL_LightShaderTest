class PtLight
{
  PVector pos;
  PVector rgb;

  float x, y, z, r, g, b;

  float eta, theta;
  float minRadius, maxRadius;
  float radiusX, radiusY, radiusZ;
  float speedEta, speedTheta;
  float speedRadius;

  PtLight(PVector loc_, PVector rgb_)
  {
    pos = loc_;
    rgb = rgb_;

    x = pos.x;
    y = pos.y;
    z = pos.z;

    r = rgb.x;
    g = rgb.y;
    b = rgb.z;
  }

  PtLight()
  {
    minRadius = random(100, 125);
    maxRadius = random(150, 175);

    radiusX = random(minRadius, maxRadius);
    radiusY = random(minRadius, maxRadius);
    radiusZ = random(minRadius, maxRadius);  
    speedRadius = random(0.01, 0.05); 

    eta = random(PI);
    theta = random(TWO_PI);
    speedEta =  radians(random(0.1, 0.5));
    speedTheta =  radians(random(0.1, 0.5));

    x =  sin(eta)*cos(theta)*radiusX;
    y =  sin(eta)*sin(theta)*radiusY;
    z =  cos(eta)*radiusZ;


    r = 0;//random(255);
    g = random(255);
    b = random(255);

    r = random(255);
    g = r;//random(255);
    b = r;//random(255);


    pos = new PVector(x, y, z);
    rgb = new PVector(r, g, b);
  }

  //Update
  void updates()
  {
   //updateAngles();
    updatePosition();
  }

  void updateEta()
  {
    eta += speedEta;
  }

  void updateTheta()
  {
    theta += speedTheta;
  }

  void updateAngles()
  {
    updateEta();
    updateTheta();
  }



  void updatePosition()
  {    

    radiusX += speedRadius;
    radiusY += speedRadius;
    radiusZ += speedRadius;
    float rx = minRadius + sin(radiusX) * maxRadius;
    float ry = minRadius + sin(radiusY) * maxRadius;
    float rz = minRadius + sin(radiusZ) * maxRadius;
    x =  sin(eta)*cos(theta)*rx;
    y =  sin(eta)*sin(theta)*rx;
    z =  cos(eta)*rx;

    pos = new PVector(x, y, z);
  }
}