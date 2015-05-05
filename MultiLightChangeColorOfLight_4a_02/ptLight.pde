class PtLight
{
  PVector pos;
  PVector rgb;
  
  float x, y, z, r, g, b;
  
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
}
