#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 touch;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

 float w = step(mod(gl_FragCoord.x,touch.x),1.0);
 w += step(mod(gl_FragCoord.y,touch.y),1.0);

	gl_FragColor = vec4(vec3(w), 1.0);
}
