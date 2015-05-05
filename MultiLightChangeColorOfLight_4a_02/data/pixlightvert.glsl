#define PROCESSING_TEXTLIGHT_SHADER

// the number of light need to be a constant, not uniform from our sketch, because there is glitch bug
const int numLight = 3 ;

//from Processing univers
uniform mat4 modelview;
uniform mat4 transform;
uniform mat3 normalMatrix;

//from Processing light
uniform int lightCount;
uniform vec4 lightPosition[8];
uniform vec3 lightNormal[8];



// from your sketch
uniform vec3 colorLightZero;
uniform vec3 colorLightOne;

vec3 colorLight[8] ;

// explain to the computer where or what is use by the GPU
attribute vec4 vertex;
attribute vec4 color;
attribute vec3 normal;

// bridge between the vertex and fragment code GLSL
varying vec4 vertColor;
varying vec3 ecNormal;
varying vec3 lightDir[8];
varying vec3 ecVertex ;



// MAIN
void main() {
  gl_Position = transform *vertex;    
  ecVertex = vec3(modelview *vertex);  

  ecNormal = normalize(normalMatrix *normal);

  for(int i = 0 ;i < numLight ;i++) { 
     lightDir[i] = normalize(lightPosition[i].xyz - ecVertex);
  }
  vertColor = color ;
}


