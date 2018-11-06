#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec3 pointers[10];
uniform int pointerCount;
uniform sampler2D backbuffer;///min:n;mag:n;s:r;t:r;

float segment(vec2 p, vec2 a, vec2 b)
{
	vec2 c = p - a;
	vec2 v = normalize(b - a);
	float d = distance(a, b);
	float t = dot(v,c);

	if(t < 0.) return distance(p, a);
	if(t > d) return distance(p, b);

	v *= t;

  return distance(p, a + v);
}

void main(void) {
	vec2 coord = gl_FragCoord.xy;

	float bb = texture2D(backbuffer, coord / resolution).r;

  float dist = 9999.;

  for (int n = 0; n < pointerCount; n++) {
  	int prev = int(mod(float(n - 1), float(pointerCount)));
		dist = min(dist, segment(coord, pointers[prev].xy, pointers[n].xy));
	}

	float o = 1. - dist / 10.;

	if(o>= 0.) {

	gl_FragColor = vec4(vec3(o), 1);

	} else {
		gl_FragColor = vec4(vec3(bb), 1);
	}
}
