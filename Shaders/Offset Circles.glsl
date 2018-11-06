#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

#define PI 3.14159

uniform vec2 resolution;
uniform float time;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
  vec2 muv = uv;
  muv.y /= resolution.x/resolution.y;

  float count = 10.0;
  float tunnel = time * 0.9;
  float zoom = 0.5;
  float rot = time * 2.0;

  vec2 c = vec2(0.5);
  c.y /= resolution.x/resolution.y;

	vec2 d = muv - c;

  float l = length(d) / zoom - tunnel;

  float cir = sin(l*50.0);

  cir = step(cir,0.0);

  float a = sin(atan(d.x,d.y) * 0.5 * count + rot);

  a = step(a,0.0);

  vec3 col = vec3(1.0);
  col *= ((a-0.5)*2.0 * (cir-0.5)*2.0);

	gl_FragColor = vec4(col, 1.0);
}
