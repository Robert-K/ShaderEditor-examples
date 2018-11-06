#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform sampler2D backbuffer;
uniform vec3 magnetic;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

 vec3 mag = (magnetic + 65.0) / 130.0;

  float r = mag.r;
  float g = mag.g;
  float b = mag.b;

  float width = 0.03;

  float step = 0.001;

  float x = step(1.0 - step, uv.y);

  float rl = step(abs(uv.x-r), width) * x;
  float gl = step(abs(uv.x-g), width) * x;
  float bl = step(abs(uv.x-b), width) * x;

  vec2 co = vec2(uv.x, uv.y + step);
  vec3 buf = step(uv.y,1.0-step)*texture2D(backbuffer, co).rgb;

  vec3 col = vec3(min(1.0,rl+buf.r),
  	              min(1.0,bl+buf.g),
  	              min(1.0,gl+buf.b));

	gl_FragColor = vec4(col, 1.0);
}
