#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

// the number of light need to be a constant, not uniform from your sketch because there is glitch bug
uniform int lightCount;// = 8;
uniform vec3 lightNormal[8];
uniform vec4 lightPosition[8];
// diffuse is the color element of the light
uniform vec3 lightDiffuse[8];
// spot light
uniform vec2 lightSpot[8];



varying vec4 vertColor;
varying vec3 ecNormal;
varying vec3 lightDir[8];
varying vec3 ecVertex ;

//material
uniform vec3 kd;//Diffuse reflectivity
uniform vec3 ka;//Ambient reflectivity
uniform vec3 ks;//Specular reflectivity
uniform float shininess;//shine factor
uniform vec3 emissive;

vec3 ads(vec3 dir, vec3 color)
{
	vec3 n = normalize(ecNormal);
	vec3 s = normalize(dir);
	vec3 v = normalize(-ecVertex.xyz);
	vec3 r = reflect(-s, n);
	vec3 h = normalize(v + s);
	float intensity = max(0.0, dot(s, n));

	//return color * intensity * (ka + kd * max(dot(s, n), 0.0) + ks * pow(max(dot(r, v), 0.0), shininess));
	return color * intensity * (ka + kd * max(dot(s, ecNormal), 0.0) + ks * pow(max(dot(h, n), 0.0), shininess));
}


void main() {
	vec4 final_color ;
	
	for(int i = 0 ; i <  lightCount ; i++) 
	{
	  vec3 direction = normalize(lightDir[i]);
	  final_color += vec4(ads(direction, lightDiffuse[i].xyz), 1.0);
	}

	gl_FragColor = vec4(emissive, 1.0) + final_color * vertColor;//vec4(emissive, 1.0) + 
}