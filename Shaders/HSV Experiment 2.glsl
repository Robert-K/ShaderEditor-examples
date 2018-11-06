#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

float frac(float c) {
	return c - floor(c);
}

float rand(vec2 co) {
	return frac(sin(dot(co.yx+1.0,vec2(17.8509,75.7137)))*43674.894);
}

vec3 hsv2rgb(vec3 c) {
  vec3 rgb = clamp(abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),6.0)-3.0)-1.0, 0.0, 1.0 );
  rgb = rgb*rgb*(3.0-2.0*rgb);
  return c.z * mix( vec3(1.0), rgb, c.y);
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution;

	float v = length(uv-vec2(0.5))*1.5;

	uv.y /= resolution.x / resolution.y;

 vec3 col= hsv2rgb(vec3(
 	0.03*time+rand(vec2(floor(uv.x*20.0),floor(20.0*uv.y+0.5*time))),
 	1.0,1.0));

  col.r += floor(uv.x*20.0)/20.0;

  col = hsv2rgb(col);

	gl_FragColor = vec4(col-v, 1.0);
}
