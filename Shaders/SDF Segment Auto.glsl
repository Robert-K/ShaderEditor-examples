#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;

uniform sampler2D backbuffer;///min:n;mag:n;s:r;t:r;
uniform float time;
uniform float startRandom;

#define SCROLL vec2(.001* sin(time),.004)

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

vec3 hsv2rgb(vec3 c) {
  vec3 rgb = clamp(abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),6.0)-3.0)-1.0, 0.0, 1.0 );
  rgb = rgb*rgb*(3.0-2.0*rgb);
  return c.z * mix( vec3(1.0), rgb, c.y);
}

void main(void) {
	vec2 coord = gl_FragCoord.xy;

	vec3 bb = texture2D(backbuffer, SCROLL + coord / resolution).rgb;

	float t1 = time * startRandom * .75;
	float t2 = time + startRandom * .75;

	vec2 p1 = vec2(sin(t1+sin(t2*1.31))*.5+.5, cos(t2+sin(t1*.357))*.5+.5) * resolution;
	vec2 p2 = vec2(sin(t2+cos(t1*.314))*.5+.5, cos(t1+cos(t2*1.179))*.5+.5) * resolution;

	float dist = segment(coord, p1, p2);

	float o = 1. - dist / 10.;

	if(o>= 0.) {

	gl_FragColor = vec4(hsv2rgb(vec3(.05*t1,1.,1.))*o, 1);

	} else {
		gl_FragColor = vec4(bb, 1);
	}
}
