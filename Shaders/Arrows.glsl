#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform sampler2D noisergb;
uniform float time;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

 float v = uv.y+mod(-time*2.0,2.0)+abs(uv.x-0.5);

 v = floor(v*5.0);

 vec3 n = texture2D(noisergb,vec2(v*0.5)).rgb;

	gl_FragColor = vec4(n, 1.0);
}
