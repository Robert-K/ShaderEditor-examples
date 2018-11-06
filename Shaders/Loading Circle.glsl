#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

#define PI 3.14159

#define THICCNESS 0.06
#define RADIUS 0.2
#define SPEED 4.0

uniform vec2 resolution;
uniform float time;

vec2 remap(vec2 coord) {
	if (resolution.x>resolution.y) {
		return coord / resolution * vec2(resolution.x/resolution.y,1.0);
	} else {
		return coord / resolution * vec2(1.0,resolution.y/resolution.x);
	}
}

float circle(vec2 uv, vec2 pos, float rad) {
	return step(length(uv-pos),rad);
}

float ring(vec2 uv, vec2 pos, float innerRad, float outerRad) {
	return step(length(uv-pos),outerRad)*step(innerRad,length(uv-pos));
}

void main(void) {
 vec2 uv = remap(gl_FragCoord.xy);

 float geo = 0.0;

 vec2 center = vec2(0.5,0.975);

 geo += ring(uv,center,RADIUS-THICCNESS,RADIUS);

 float rot = -time * SPEED;

 uv = vec2((uv.x - center.x), uv.y - center.y) * mat2(cos(rot), sin(rot), -sin(rot), cos(rot));

 float a = atan(uv.x,uv.y)*PI*0.05;

 a += 0.5;

 a = max(a,circle(uv,vec2(0.0,-RADIUS+THICCNESS/2.0),THICCNESS/2.0));

 gl_FragColor = vec4(vec3(a*geo), 1.0);
}
