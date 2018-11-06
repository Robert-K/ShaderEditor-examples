#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform float time;
uniform vec3 pointers[10];
uniform int pointerCount;
uniform sampler2D noise;
uniform vec2 resolution;

void main(void) {
	vec2 uv = gl_FragCoord.xy;

 float t = time * 8.0;

 uv.x += sin(t + uv.y/90.0)*25.0;
 uv.y += cos(t + uv.x/90.0)*25.0;

  float val = 0.0;

 for(int i=0; i<pointerCount; i++) {
 	float dist = 1.3 * distance(uv, pointers[i].xy);
 	dist *= 1.0 - dist * 0.0015;
 	float inter = sin(time * 10.0 - dist/10.0);
 	inter *= smoothstep(0.0, 1.0, 100.0/dist);
 	val += inter;
 }

 uv /= resolution;

 vec3 col = vec3(uv,1.0);

 col += val / 2.0;
 //col = texture2D(noise,gl_FragCoord.xy).rgb;

	gl_FragColor = vec4(col,1.0);
}
mit