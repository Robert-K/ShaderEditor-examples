#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

 float rot = time;

 uv = vec2(uv.x - 0.5, uv.y - 0.5) * mat2(cos(rot), sin(rot), -sin(rot), cos(rot));

 vec3 o = vec3(mod(uv.y+sin(time),uv.x));

	gl_FragColor = vec4(o, 1.0);
}
