#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

#define PI 3.1415926535

uniform vec2 resolution;
uniform float time;

float frac(float c) {
	return c - floor(c);
}

float rand(vec2 co, float e) {
	return frac(sin(dot(co.yx+1.,vec2(17.8509,75.7137)))*(43674.894+e));
}

void main(void) {
	const int blurDist = 5;

	vec2 uv = gl_FragCoord.xy;

	float tot = 0.;

	for(int x=-blurDist;x<=blurDist;x++) {
		for(int y=-blurDist;y<=blurDist;y++) {
			float dist = length(vec2(x, y));
			tot += rand(uv + vec2(x, y), 0.01*time) * (1. - dist / float(blurDist));
	  }
  }

  //tot /= pow(float(blurDist * 2), 2.);
  tot /= PI * pow(float(blurDist) / 2., 2.);

	gl_FragColor = vec4(vec3(tot), 1.);
}
