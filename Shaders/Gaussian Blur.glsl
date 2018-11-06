#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform sampler2D backbuffer;///p:Uma;
uniform float time;

vec4 blur9(sampler2D image, vec2 uv, vec2 resolution, vec2 direction) {

vec4 color = vec4(0.0);

vec2 off1 = vec2(1.3846153846) * direction;

vec2 off2 = vec2(3.2307692308) * direction;

color += texture2D(image, uv) * 0.2270270270;

color += texture2D(image, uv + (off1 / resolution)) * 0.3162162162;

color += texture2D(image, uv - (off1 / resolution)) * 0.3162162162;

color += texture2D(image, uv + (off2 / resolution)) * 0.0702702703;

color += texture2D(image, uv - (off2 / resolution)) * 0.0702702703;

return color;

}

void main(void) {
	float time = max(0., time - 3.);

	vec2 uv = gl_FragCoord.xy / resolution.xy;

	gl_FragColor = mix(blur9(backbuffer, uv, resolution / time, vec2(1, 0)),
		blur9(backbuffer, uv, resolution / time, vec2(0, 1)), .5);
}
