#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform sampler2D backbuffer;
uniform float time;
uniform vec3 pointers[10];
uniform int pointerCount;
uniform sampler2D Uma;

#define DRAWING 10.
#define LINE_WIDTH 20.
#define BRUSH_SIZE 20.
#define THRESHOLD .5

#define JFA 2.

#define SAMPLES 32.
#define MAX_DIST 2.
#define MAX_ITER 16.

#define EPSILON .001

#define PI 3.14159

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

float draw(vec2 uv, float bb) {
	  if(pointerCount == 1) {
		  bb += max(0., 1. - distance(gl_FragCoord.xy, pointers[0].xy) / BRUSH_SIZE);
	  } else {
	  	float dist = 9999.;
		  for (int n = 0; n < pointerCount; n++) {
  	    int prev = int(mod(float(n - 1), float(pointerCount)));
		    dist = min(dist, segment(gl_FragCoord.xy, pointers[prev].xy, pointers[n].xy));
	    }
	    bb += max(0., 1. - dist / LINE_WIDTH);
	 }
	return bb * step(1., gl_FragCoord.x)
	          * step(1., gl_FragCoord.y)
	          * step(gl_FragCoord.x, resolution.x - 1.)
	          * step(gl_FragCoord.y, resolution.y - 1.);
}

vec3 jfa(vec2 uv) {
	float iter = max(0., time - DRAWING - .1) * 60.;
  float offset = .5 / iter;

  float minDist = MAX_DIST;
  vec2 newSeed = vec2(0);

  for(float x = -1.; x <= 1.; x++) {
  	for(float y = -1.; y <= 1.; y++) {
      vec2 samplePos = uv + vec2(x, y) * offset;

      if(samplePos.x >=0. && samplePos.x <=1. && samplePos.y >=0. && samplePos.y <=1.)
      {
        vec3 seed = texture2D(backbuffer, samplePos).xyz;

        if((seed.x != 0. && seed.y != 0.) || seed.z != 0.) {

          float seedDist = distance(seed.xy, uv);

          if(seedDist < minDist) {
        	  minDist = seedDist;
        	  newSeed = seed.xy;
          }
        }
      }
    }
  }
  float b = texture2D(backbuffer, uv).b;
  return vec3(newSeed, b);
}

vec3 trace(vec2 uv, vec2 dir) {
	float totalDist = 0.;
  for(float i = 0.; i < MAX_ITER; i++) {
    vec2 p = uv + dir * totalDist;

    vec3 bb = texture2D(backbuffer, p).xyz;
    float dist = distance(bb.xy, p);
    if(bb.b > 0.) {
    	dist = 0.;
    }

    totalDist += dist;

    if(totalDist > MAX_DIST || dist < EPSILON) break;
    //if(p.x<0.||p.y<0.||p.x>1.||p.y>1.) break; //TEST KILL RAYS OUTSIDE VOLUME
  }
  return vec3(totalDist); //DEBUG TOTALDIST
  //vec3 color = texture2D(Uma, (uv + dir * totalDist)).rgb;
  //vec3 color = vec3(1.,.0,.1);
  //return color * max(0., 1. - totalDist);
}

float rand(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

vec3 render(vec2 uv) {
	vec3 color = vec3(0.);
	for(float i = 0.; i < SAMPLES; i++) {
		float rot = (i + rand(uv+i+fract(time))) / SAMPLES * 2. * PI;
		vec2 dir = vec2(sin(rot), cos(rot));
		color += trace(uv, dir);
	}
	return color / SAMPLES + vec3(.2,.2,.3);
}

float getVal() {
	return texture2D(backbuffer, vec2(0.)).r;
}

void setVal(float val) {
	if(length(gl_FragCoord.xy) < 1.)
		  gl_FragColor = vec4(val);
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution;
	float res = min(resolution.x, resolution.y);
	vec4 bb = texture2D(backbuffer, uv);

	float val = getVal();

	if(time < DRAWING) {
		gl_FragColor = vec4(vec3(draw(uv, bb.r)), 1.);
	} else if(time < DRAWING + .1) {
		gl_FragColor = bb;
		setVal(.2);
	} else if(val == .2) {
		gl_FragColor = vec4(vec3(uv, 1.) * step(THRESHOLD, bb.r), 1.);
	  setVal(1.);
	} else if(time < DRAWING + JFA) {
		gl_FragColor = vec4(jfa(uv), 1.);
	} else if(time < DRAWING + JFA + .1) {
		gl_FragColor = bb;
		setVal(0.);
	} else if(val == 0.) {
		gl_FragColor = vec4(render(uv), 1.);
	  setVal(1.);
	} else {
		gl_FragColor = bb;
		setVal(1.);
	}
}
