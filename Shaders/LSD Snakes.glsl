#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform int pointerCount;
uniform vec3 pointers[10];
uniform sampler2D backbuffer;

vec3 hsv2rgb(vec3 c) {
  vec3 rgb = clamp(abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),6.0)-3.0)-1.0, 0.0, 1.0 );
  rgb = rgb*rgb*(3.0-2.0*rgb);
  return c.z * mix( vec3(1.0), rgb, c.y);
}

void main() {
	vec3 col = texture2D(
		backbuffer,
		gl_FragCoord.xy/ resolution).rgb;

	float tap = min(resolution.x, resolution.y) * .05;
	for (int n = 0; n < pointerCount; ++n) {
		if (distance(pointers[n].xy, gl_FragCoord.xy) < tap) {
			col = vec3(1);
			break;
		}
	}

	gl_FragColor = vec4(hsv2rgb(vec3(length(col)*3.7837,1.,1.)) * step(0.1,length(col)), 1.);
}
