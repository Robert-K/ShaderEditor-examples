#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

#define PI 3.1415

uniform vec2 resolution;
uniform float time;
uniform vec2 touch;
uniform vec3 gravity;

float sphere(vec3 pos, float r) {
	return length(pos) - r;
}

float box(vec3 pos, vec3 s) {
	return length(max(abs(pos) - s, 0.));
}

float box(vec3 pos, vec3 s, float r) {
	return length(max(abs(pos) - s, 0.)) - r;
}

float add(float a, float b) {return min(a, b);}
float mul(float a, float b) {return max(a, b);}
float sub(float a, float b) {return max(-a, b);}

vec3 rep(vec3 pos, vec3 area) {return mod(pos, area) - .5 * area;}
mat4 rot(vec3 axis, float angle) {
	axis = normalize(axis);
	float s = sin(angle);
	float c = cos(angle);
	float oc = 1.0 - c;
	return mat4(
		oc * axis.x * axis.x + c,
		oc * axis.x * axis.y - axis.z * s,
		oc * axis.z * axis.x + axis.y * s,
		0,
		oc * axis.x * axis.y + axis.z * s,
		oc * axis.y * axis.y + c,
		oc * axis.y * axis.z - axis.x * s,
		0,
		oc * axis.z * axis.x - axis.y * s,
		oc * axis.y * axis.z + axis.x * s,
		oc * axis.z * axis.z + c,
		0, 0, 0, 0, 1);
}
vec3 mat(vec3 pos, mat4 m) {return vec3(m * vec4(pos, 1));}

float map(vec3 pos) {
	//pos = rep(pos, vec3(5));
  return add(add(add(
  	sub(sphere(pos, 1.3), box(pos, vec3(1), .1)),
  	sphere(pos + vec3(0, sin(time * 3. + PI / 3.) * 2., 0), .2)),
  	sphere(pos + vec3(sin(time * 3. + PI / 1.5) * 2., 0, 0), .2)),
  	sphere(pos + vec3(0, 0, sin(time * 3.) * 2.), .2));
}

void main(void) {
	const int MAX_ITER = 300;
	const float MAX_DIST = 100.;
	const float EPSILON = .0002;

	const float SPEED = .5;

	float time = time * SPEED;
	vec2 touch = touch / resolution;

  vec3 lightPos = vec3(3. * MAX_DIST);
  vec3 diffuseCol = vec3(.5, .9, .3);
  vec3 specularCol = vec3(1, .9, .9);
  vec3 ambientCol = vec3(.1, .2, .6) * .5;

  vec3 camPos = mat(vec3(0, touch.y * 10. - 5., 4),
  	rot(vec3(0, 1, 0), touch.x * PI * 2.));
  //vec3 camPos = normalize(-gravity) * 6.;
  vec3 camTarget = vec3(0);
  vec3 upDir = vec3(0, 1, 0);

  vec3 camDir = normalize(camTarget-camPos);
  vec3 camRight = normalize(cross(upDir,camPos));
  vec3 camUp = normalize(cross(camDir,camRight));

  vec2 uv = gl_FragCoord.xy / resolution.xy;
  vec2 screenPos = -1. + 2. * uv;
  screenPos.x *= resolution.x / resolution.y;

  vec3 rayDir = normalize(camRight * screenPos.x
  	+ camUp * screenPos.y + camDir);

  float totalDist = 0.;
  vec3 pos = camPos;
  float dist = EPSILON;

  for(int i = 0; i < MAX_ITER; i++) {
  	if(dist < EPSILON || totalDist > MAX_DIST) {
  		break;
  	}
  	dist = map(pos);
  	totalDist += dist;
  	pos += dist * rayDir;
  }

  if(dist < EPSILON) {
  	vec2 eps = vec2(0, EPSILON);
  	vec3 normal = normalize(vec3(
  		map(pos + eps.yxx) - map(pos - eps.yxx),
  		map(pos + eps.xyx) - map(pos - eps.xyx),
  		map(pos + eps.xxy) - map(pos - eps.xxy)));

    vec3 lightDir = normalize(pos - lightPos);
  	float diffuse = max(0., dot(lightDir, normal));
  	vec3 lightRef = normalize(reflect(lightDir, normal));
  	float specular = max(0., pow(dot(rayDir, lightRef), 64.));

  	vec3 col = diffuseCol * diffuse
  	+ specularCol * specular
  	+ ambientCol;
  	gl_FragColor = vec4(col, 1);
	} else {
		gl_FragColor = vec4(ambientCol * .5, 1);
	}
}
