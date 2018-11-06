#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform float startRandom;

float frac(float c) {
	return c - floor(c);
}

vec3 hsv2rgb(vec3 c) {
  vec3 rgb = clamp(abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),6.0)-3.0)-1.0, 0.0, 1.0 );
  rgb = rgb*rgb*(3.0-2.0*rgb);
  return c.z * mix( vec3(1.0), rgb, c.y);
}

void main(void) {
	vec3 col = hsv2rgb(vec3(
		startRandom,
		frac(startRandom)+0.3,
		frac(startRandom*2.18647)+0.3));

	gl_FragColor = vec4(col, 1.0);
}
