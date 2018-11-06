#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform sampler2D Power;///min:n;mag:l;s:c;t:c;
uniform float time;
uniform float battery;

float frac(float c) {
	return c - floor(c);
}

float rand(vec2 co) {
	return frac(sin(dot(co.yx+1.0,vec2(17.8509,75.7137)))*43674.894);
}

void main(void) {
	vec2 uv = gl_FragCoord.xy/resolution;
	uv.y *= resolution.y / resolution.x;
	uv = (uv-0.5)*1.5+0.5;
	uv.y-= 0.6;

float off = rand(vec2(floor(14.0*time),1.0))*0.1-0.05;

vec2 roff = vec2(off,off*0.2);
vec2 goff = vec2(-off,-off*0.2);
vec2 boff = vec2(0.0,0.0);

float g = step(frac(time)-battery,rand(vec2(floor(time))));

uv.x += (rand(vec2(floor(time),floor(uv.y*(10.0+rand(vec2(uv.y,floor(time)))))))*0.2-0.1)*(1.0-g);

float ori = texture2D(Power,uv).r;

 vec3 col = vec3(texture2D(Power,uv+roff).r,texture2D(Power,uv+goff).g,texture2D(Power,uv+boff).b);

 col = mix(col,vec3(ori),g);

 col += rand(uv*time)*(1.0-battery)*0.3;

	gl_FragColor = vec4(col, 1.0);
}
