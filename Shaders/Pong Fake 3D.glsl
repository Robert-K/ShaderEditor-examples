#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;
uniform sampler2D backbuffer;///min:l;mag:l;s:c;t:c;

#define PI 3.14159

float frac(float c) {
	return c - floor(c);
}

float lerp(float a, float b, float t) {
	return a + (b-a) * t;
}

float pingpong(float t) {
	return abs(frac(t)-0.5)*2.0;
}

float rand(vec2 co) {
	return frac(sin(dot(co.yx+1.0,vec2(17.8509,75.7137)))*43674.894);
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	float as = resolution.y / resolution.x;
	vec3 b = texture2D(backbuffer,(uv-0.5)*1.04+0.5).rgb;
  uv.y*= as;

 float t = time*0.6;

 vec2 pos = vec2(pingpong(t*1.31)*0.79+0.11,pingpong(t)*as*0.79+0.11	*as);

 vec3 a = 0.3*vec3(min(1.0,step(uv.x,0.01)+step(0.99,uv.x)+0.5*step(uv.y,0.01)+0.5*step(0.99*as,uv.y)));

 a += step(0.95*as, uv.y) * step(abs(uv.x-lerp(pingpong(ceil(t-1.0)*1.31),pingpong(ceil(t)*1.31),frac(t))*0.6-0.2),0.2);

 a += step(uv.y,0.05*as) * step(abs(uv.x-lerp(pingpong(ceil(t+0.5)*1.31),pingpong(ceil(t+1.5)*1.31),frac(t+0.5))*0.6-0.2),0.2);

 a = max(a,0.95*b);

 a += 0.5*step(length(uv-vec2(0.02+0.96*rand(vec2(time,1.31)),0.02+0.96*as*rand(vec2(time,2.61)))),0.02*rand(vec2(time,3.61)));

 a = max(vec3(0.0),a-step(length(uv-pos),0.1));

 a += vec3(1.0,0.0,0.0) * step(length(uv-pos),0.1);
 //a += max(0.0,1.9-10.0*length(pos-uv));

	gl_FragColor = vec4(a, 1.0);
}
