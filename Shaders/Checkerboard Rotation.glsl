#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 touch;
uniform float time;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	float as = resolution.x / resolution.y;

	vec2 size = vec2(0.3);

 float rot = -time/2.0;

	uv = vec2((uv.x - 0.5) * as, uv.y - 0.5) * mat2(cos(rot), sin(rot), -sin(rot), cos(rot));

 float w = (step(mod(uv.x,size.x),size.x/2.0)-0.5)*2.0;
 w *= (step(mod(uv.y,size.y),size.y/2.0)-0.5)*2.0;

	gl_FragColor = vec4(w,w,w, 1.0);
}
