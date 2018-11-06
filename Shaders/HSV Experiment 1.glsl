#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;
uniform sampler2D backbuffer;

float lerp(float a, float b, float t) {
	return a + (b-a) * t;
}

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

	vec3 b = texture2D(backbuffer, uv).rgb;

	uv.y /= resolution.x / resolution.y;

 vec2 c = vec2(sin(time*0.2),cos(time*0.1));

 float rot = time*0.5;

 vec2 muv = vec2((uv.x - c.x), uv.y - c.y) * mat2(cos(rot), sin(rot), -sin(rot), cos(rot));

 float s = (sin(time)*0.5+0.5)*100.0;

 float w = smoothstep(0.9,1.0,sin(s*muv.x));
 w += smoothstep(0.9,1.0,sin(s*muv.y));

 w = step(w,0.5);

 float k = 1.0-smoothstep(0.0,1.0,length(uv-(c*0.5+0.5)));

 vec3 col= k * w * hsv2rgb(vec3(0.1*time+rand(vec2(floor(uv.x*20.0),floor(20.0*uv.y+time))),0.92,4.0));

 col.r += 0.2*time;

 col = hsv2rgb(col);

	gl_FragColor = vec4(col, 1.0);
}
