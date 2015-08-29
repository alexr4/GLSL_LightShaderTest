#version 150
//based on  OpenGL 4 shading Language chapter 3
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
varying float rimColor;

uniform float timer;


// MAIN
void main() {

  //animation 
  vec4 vert = vertex + sin(timer) * color.w;

  ecVertex = vec3(modelview * vert);  

  ecNormal = normalize(normalMatrix *normal);

  for(int i = 0 ;i < lightCount ;i++) { 
     lightDir[i] = normalize(lightPosition[i].xyz - ecVertex);
  }

  vertColor = vec4(color.xyz, 1.0) ;

  //rim
  vec3 v = normalize(-ecVertex);
  vec3 n = normalize(mat3(modelview) * normal);      // convert normal to view space                     // vector towards eye
  rimColor = 1.0 - max(dot(v, n), 0.0);        // the rim-shading contribution



  gl_Position = transform * vert;  
}