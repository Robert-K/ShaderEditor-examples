#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

float frac(float c) {
	return c - floor(c);
}

float lerp(float a, float b, float t) {
	return a + (b-a) * t;
}

float pingpong(float t) {
	return abs(frac(t)-0.5)*2.0;
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	float as = resolution.y / resolution.x;
  uv.y*= as;

 float t = time*0.5;

 vec2 pos = vec2(pingpong(t*1.31)*0.8+0.1,pingpong(t)*as*0.8+0.1*as);

 vec3 a;

 a += step(0.95*as, uv.y) * step(abs(uv.x-lerp(pingpong(ceil(t-1.0)*1.31),pingpong(ceil(t)*1.31),frac(t))*0.6-0.2),0.2);

 a += step(uv.y,0.05*as) * step(abs(uv.x-lerp(pingpong(ceil(t+0.5)*1.31),pingpong(ceil(t+1.5)*1.31),frac(t+0.5))*0.6-0.2),0.2);

 a += vec3(1.0,0.0,0.0) * step(length(uv-pos),0.1);
 //a += max(0.0,1.9-10.0*length(pos-uv));

	gl_FragColor = vec4(a, 1.0);
}
