#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform int pointerCount;
uniform vec3 pointers[10];
uniform vec2 resolution;
uniform float time;
uniform sampler2D backbuffer;
uniform sampler2D noise;///min:l;mag:l;s:r;t:r;

void main(void) {
	float mx = max(resolution.x, resolution.y);
	vec2 uv = gl_FragCoord.xy / mx;
	uv.x += 0.01 * sin(uv.y * 20.0 + time);
	vec2 g = vec2(0.01*sin(0.1*uv.y * time),0.02*time);
	float o = 0.1 * (texture2D(noise,0.9*uv+g).g-0.5);
	//o = max(o, 0.2 * texture2D(backbuffer,vec2(0.0,0.2)+gl_FragCoord.xy/resolution).g);
	for (int n = 0; n < pointerCount; ++n) {
		 o += smoothstep(
			0.6,
			0.0,
			2.0*distance(uv, pointers[n].xy / mx));
	}
	o = step(0.7, o);

	vec3 color = o * vec3(0.3,1.0,0.3);

	gl_FragColor = vec4(color, 1.0);
}
