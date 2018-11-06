#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform int pointerCount;
uniform vec3 pointers[10];
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main(void) {
	float mx = max(resolution.x, resolution.y);
	vec2 uv = gl_FragCoord.xy / mx;
	float o = 1.0 * texture2D(backbuffer,gl_FragCoord.xy/resolution).r;
	float b = 0.0;
	for (int n = 0; n < pointerCount; ++n) {
		 float d = 1.0-8.0*distance(uv, pointers[n].xy / mx);
		 b += d;
	}
	o = max(o,b);
	o= step(o,0.9);

	gl_FragColor = vec4(o,o,o, 1.0);
}
