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

#define SEEDS 30
#define SEEDING 5./60.
#define STEP 1.
#define FLOODING .7 / STEP
#define COLORING 1./60.
#define PAUSE 2.
#define RESETTING 1./60.

float frac(float c) {
	return c - floor(c);
}

float rand(vec2 co) {
	return frac(sin(dot(co.yx+1.0,vec2(17.8509,75.7137)))*43674.894);
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution;
	float res = max(resolution.x, resolution.y);

	float t = mod(time, SEEDING + FLOODING + COLORING + PAUSE);

  if(t < SEEDING) {

  vec3 bb = texture2D(backbuffer, uv).rgb;

  float seed = 0.;

  if(bb.x != 0. || bb.y != 0.) seed = 1.;

  for(int i = 0; i < SEEDS; i++) {
  vec2 ran = vec2(rand(vec2(time * 15.37, startRandom + float(i))), rand(vec2(time * 26.38, startRandom +.5+float(i))));

  seed += step(distance(uv, ran), 1. / res);
  }

  gl_FragColor = vec4(seed * uv, 0,1);

  } else if(t < SEEDING + FLOODING) {

  vec3 bb = texture2D(backbuffer, uv).rgb;

  float iter = max(0., t - SEEDING) * 59. * STEP;
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
  } else if(t < SEEDING + FLOODING + COLORING){
  	vec3 bb = texture2D(backbuffer, uv).rgb;

  	vec3 col = (.5+smoothstep(.1,1.,1.-distance(bb.xy, uv)*5.)) * vec3(rand(vec2(bb.x+bb.y+time,bb.z+38.2)), rand(vec2(bb.x+bb.y+time,bb.z+26.71)), rand(vec2(bb.x+bb.y,bb.z+10.25)));

  	gl_FragColor = vec4(col, 1);
  } else if (t < SEEDING + FLOODING + COLORING + PAUSE - RESETTING){
  	vec3 bb = texture2D(backbuffer, uv).rgb;

  	gl_FragColor = vec4(bb, 1);
  }
}
