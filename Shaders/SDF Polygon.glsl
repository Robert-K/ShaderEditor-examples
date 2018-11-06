#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec3 pointers[10];
uniform int pointerCount;

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
	vec2 uv = gl_FragCoord.xy;

  float dist = 9999.;

  for (int n = 0; n < pointerCount; n++) {
  	int prev = int(mod(float(n - 1), float(pointerCount)));
		dist = min(dist, segment(uv, pointers[prev].xy, pointers[n].xy));
	}

	gl_FragColor = vec4(vec3(1. - dist / 10.), 1);
}
