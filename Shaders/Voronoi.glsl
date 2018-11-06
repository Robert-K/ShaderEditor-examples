#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform int pointerCount;
uniform vec3 pointers[10];
uniform vec2 resolution;

vec3 hsv2rgb(vec3 c) {
  vec3 rgb = clamp(abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),6.0)-3.0)-1.0, 0.0, 1.0 );
  rgb = rgb*rgb*(3.0-2.0*rgb);
  return c.z * mix( vec3(1.0), rgb, c.y);
}

void main(void) {
	float mx = max(resolution.x, resolution.y);
	vec2 uv = gl_FragCoord.xy / mx;
	float p = 0.0;
	float d = max(resolution.x,resolution.y);
	for (int n = 0; n < pointerCount; ++n) {
		 float dp =distance(uv, pointers[n].xy / mx);
	   if(dp<d) {
	   	d=dp;
	   	p = float(n+1);
	   	}
	}

	vec3 col = min(p,1.0) * hsv2rgb(vec3(p / float(pointerCount),1.0,0.6));

	gl_FragColor = vec4(col, 1.0);
}
