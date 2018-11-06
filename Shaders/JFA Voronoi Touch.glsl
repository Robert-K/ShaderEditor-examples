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

#define SEEDING 2.

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution;
	float res = min(resolution.x, resolution.y);

  if(time < SEEDING) {

	float obj = 0.;

  for (int n = 0; n < pointerCount; ++n) {
		obj += step(distance(gl_FragCoord.xy, pointers[n].xy), 1.);
	}

  gl_FragColor = vec4(obj * uv, 0,1);
  return;
  }

  vec3 bb = texture2D(backbuffer, uv).rgb;

  float iter = max(0., time - SEEDING) * 60.;
  float offset = .5 / iter;

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
}
