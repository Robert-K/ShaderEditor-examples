#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

#define PI 3.14159

uniform vec2 resolution;
uniform float time;
uniform vec2 touch;

vec2 remap(vec2 coord) {
	if (resolution.x>resolution.y) {
		return coord / resolution * vec2(resolution.x/resolution.y,1.0);
	} else {
		return coord / resolution * vec2(1.0,resolution.y/resolution.x);
	}
}

float lerp(float a, float b, float t) {
	return a + (a - b) * t;
}

float circle(vec2 uv, vec2 pos, float rad) {
	return step(length(uv-pos),rad);
}

float ring(vec2 uv, vec2 pos, float innerRad, float outerRad) {
	return step(length(uv-pos),outerRad)*step(innerRad,length(uv-pos));
}

vec3 hsv2rgb(vec3 c) {
  vec3 rgb = clamp(abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),6.0)-3.0)-1.0, 0.0, 1.0 );
  rgb = rgb*rgb*(3.0-2.0*rgb);
  return c.z * mix( vec3(1.0), rgb, c.y);
}

void main(void) {
 vec2 uv = remap(gl_FragCoord.xy);

 vec2 t = remap(touch);

 vec3 col = vec3(0.0);

 vec2 center = vec2(0.5);

 vec2 d = uv - center;
 float a = atan(d.x,d.y)*PI*0.05;

 col += ring(uv,center,0.47,0.5) * hsv2rgb(vec3(a,1.0,0.5));

 d = t - center;
 a = atan(d.x,d.y)*PI*0.05;

 col += circle(uv,center,0.2) * hsv2rgb(vec3(a,1.0,0.5));

 //col += radialGradient(uv,center,0.1,0.4);

 gl_FragColor = vec4(col, 1.0);
}
