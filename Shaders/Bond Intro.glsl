#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

#define BLOOD 5.

float frac(float c) {
	return c - floor(c);
}

float rand(vec2 co) {
	return frac(sin(dot(co.yx+1.0,vec2(17.8509,75.7137)))*43674.894);
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
  uv.y /= resolution.x/resolution.y;

  vec2 d = uv-vec2(0.5,0.9);
  float v = step(0.9,sin(atan(d.x,d.y)*10.0+10.0*pow(length(d),0.5)));
  v = max(v, step(length(d),0.2));


  float a = 0.3;
  float r = 0.5;
  for(int i=0;i<10;i++) {
  	float x = (rand(vec2(i))*2.0-1.0)*50.0;
  	r += sin(uv.x*x+time);
  }
  r /= 10.0;
  float m = step((r*0.5+0.5)*a+0.5-a/2.0,uv.y-1.0+(time-BLOOD)/10.0);

	gl_FragColor = vec4(v-m*(1.0-vec3(0.75,0.0,0.0)), 1.0);
}
