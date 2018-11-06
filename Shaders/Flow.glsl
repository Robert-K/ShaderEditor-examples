#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform int pointerCount;
uniform vec3 pointers[10];
uniform vec2 resolution;
uniform sampler2D backbuffer;
uniform sampler2D noise;
uniform float time;

void main(void) {
	float mx = max(resolution.x, resolution.y);
	vec2 uv = gl_FragCoord.xy / mx;
	vec3 o = 0.9 * texture2D(backbuffer,gl_FragCoord.xy/resolution).rgb;
	float b = 0.0;
	for (int n = 0; n < pointerCount; ++n) {
		 float d = 0.2/distance(uv, pointers[n].xy / mx);
		 d *= d;
		 b += d;
	}
	float t = time/3.0;
	vec2 m = vec2(sin(t),cos(t));
	m += vec2(sin(uv.y * 0.1 + sin(time) * 0.5)*1.7,0.0);
	m*=0.8;
  b *= texture2D(noise,m+gl_FragCoord.xy/resolution).r;

	o = max(o,b * vec3(uv,float(pointerCount)/10.0));

	gl_FragColor = vec4(o, 1.0);
}
