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

float rand(vec2 co, float e) {
	return frac(sin(dot(co.yx+1.0,vec2(17.8509,75.7137)))*(43674.894+e));
}

void main(void) {
	gl_FragColor = vec4(vec3(rand(gl_FragCoord.xy, time)), 1.0);
}
