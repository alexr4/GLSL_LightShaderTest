class Vec2 {
  
  // inspireted by GLSL code
  float x,y ;
  float s,t ;
  Vec2(float x, float y) {
    this.x = x ;
    this.y = y ;
    
    this.s = x ;
    this.t = y ;
  }
}

class Vec3 {
  // inspireted by GLSL code
  float x,y,z ;
  float r, g, b ;
  float s, t, p ;
  Vec3(float x, float y, float z) {
    this.x = x ;
    this.y = y ;
    this.z = z ;
    
    this.r = x ;
    this.g = y ;
    this.b = z ;
    
    this.s = x ;
    this.t = y ;
    this.p = z ;
  }
}

class Vec4 {
  
  // inspireted by GLSL code
  float x,y,z,w ;
  float r, g, b, a ;
  float s, t, p, q ;
  Vec4(float x, float y, float z, float w) {
    this.x = x ;
    this.y = y ;
    this.z = z ;
    this.w = w ;
    
    this.r = x ;
    this.g = y ;
    this.b = z ;
    this.a = w ;
    
    this.s = x ;
    this.t = y ;
    this.p = z ;
    this.q = w ;
  }
}
