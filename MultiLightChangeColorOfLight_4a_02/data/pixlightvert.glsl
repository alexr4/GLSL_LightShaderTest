#define PROCESSING_TEXTLIGHT_SHADER

//from Processing univers
uniform mat4 modelview;
uniform mat4 transform;
uniform mat3 normalMatrix;

//from Processing light
uniform int lightCount;
uniform vec4 lightPosition[8];
uniform vec3 lightNormal[8];

// explain to the computer where or what is use by the GPU
attribute vec4 vertex;
attribute vec4 color;
attribute vec3 normal;

// bridge between the vertex and fragment code GLSL
varying vec4 vertColor;
varying vec3 ecNormal;
varying vec3 lightDir[8];
varying vec3 ecVertex;



// MAIN
void main() {
  gl_Position = transform *vertex;    
  ecVertex = vec3(modelview * vertex);  

  ecNormal = normalize(normalMatrix *normal);

  for(int i = 0 ;i < lightCount ;i++) { 
     lightDir[i] = normalize(lightPosition[i].xyz - ecVertex);
  }

  vertColor = color ;
}


