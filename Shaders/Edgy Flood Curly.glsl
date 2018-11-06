#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

#define coord gl_FragCoord.xy

uniform vec2 resolution;
uniform int pointerCount;
uniform vec3 pointers[10];
uniform float time;
uniform sampler2D backbuffer;///min:n;mag:n;s:r;t:r;

float get(float x, float y) {
	return texture2D(backbuffer,(coord + vec2(x, y)) / resolution).r;
}

void main() {
	float min = 0.1;
	float step = 0.02;

	float val = get(0., 0.);
	float sum = step(.9, get(0., 1.)) +
		          step(.9, get(0., -1.)) +
          		step(.9, get(-1., 0.)) +
          		step(.9, get(1., 0.)) +
          		step(.9, get(-1., 1.)) +
		          step(.9, get(-1., -1.)) +
          		step(.9, get(1., 1.)) +
          		step(.9, get(1., -1.));

	float tap = min(resolution.x, resolution.y) * .05;
	for (int n = 0; n < pointerCount; ++n) {
		if (distance(pointers[n].xy, coord) < tap) {
			val = 1.;
			break;
		}
	}

	if (val < min && sum > 2.5) {
		val = 1.;
	}
	else {
		val -= step;
	}

	gl_FragColor = vec4(vec3(val), 1.);
}
