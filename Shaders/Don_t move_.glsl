#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec3 linear;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution;
  float v = min(ceil(length(linear)-0.05),1.0); //.002
  vec3 i = vec3(1.0,0.0,0.0);
	gl_FragColor = vec4(i*v,1.0);
}
