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
uniform float startRandom;
uniform sampler2D Uma;
uniform sampler2D Absurdism;
uniform sampler2D spectrum256;
uniform sampler2D ElHuervo;
uniform sampler2D ModernInterior;
uniform sampler2D Uma2;
uniform sampler2D AntonFramed;

#define IMAGE Uma

#define UVCORRECT false

#define THRESHOLD .99
#define SEEDING 1./60.
#define STEP 1.
#define FLOODING 3. / STEP
#define COLORING 1./60.

float frac(float c) {
	return c - floor(c);
}

float rand(vec2 co) {
	return frac(sin(dot(co.yx+1.,vec2(17.8509,75.7137)))*(43674.894+startRandom));
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution;
	float res = max(resolution.x, resolution.y);

  if(time < SEEDING) {

  float seed = step(THRESHOLD, rand(uv));

  gl_FragColor = vec4(seed * uv, 0,1);

  } else if(time < SEEDING + FLOODING) {

  vec3 bb = texture2D(backbuffer, uv).rgb;

  float iter = max(0., time - SEEDING) * 59. * STEP;
  float offset = .5 / iter;
  //float offset = 1./res;

  float minDist = 2.;
  vec2 newSeed = vec2(0);

  for(float x = -1.; x <= 1.; x++) {
  	for(float y = -1.; y <= 1.; y++) {
      vec2 samplePos = uv + vec2(x, y) * offset;

      if(samplePos.x >=0. && samplePos.x <=1. && samplePos.y >=0. && samplePos.y <=1.)
      {
        vec2 seed = texture2D(backbuffer, samplePos).xy;

        if(seed.x != 0. && seed.y != 0.) {

          float seedDist = distance(seed, uv);

          if(seedDist < minDist) {
        	  minDist = seedDist;
        	  newSeed = seed;
          }
        }
      }
    }
  }
  gl_FragColor = vec4(newSeed, 0,1);
  } else if(time < SEEDING + FLOODING + COLORING){
  	vec3 bb = texture2D(backbuffer, uv).rgb;

  	if(UVCORRECT) bb.y /= resolution.x/resolution.y;

  	vec3 col = texture2D(IMAGE, bb.xy).rgb;

  	gl_FragColor = vec4(col, 1);
  } else {
  	vec3 bb = texture2D(backbuffer, uv).rgb;

  	gl_FragColor = vec4(bb, 1);
  }
}
