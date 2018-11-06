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

float rand(vec2 co) {
	return frac(sin(dot(co.yx+1.0,vec2(17.8509,75.7137)))*(43674.894+time/50.0));
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

  float m = step(uv.y,rand(uv));

	gl_FragColor = vec4(vec3(m), 1.0);
}
