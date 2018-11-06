#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

 const bool array[] = true;

	gl_FragColor = vec4(uv, 1.0, 1.0);
}
