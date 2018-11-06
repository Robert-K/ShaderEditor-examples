#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform float time;
uniform vec3 pointers[10];
uniform int pointerCount;

void main(void) {
	vec2 uv = gl_FragCoord.xy;

 uv.x += sin(time + uv.y/90.0)*10.0;

  float val = 0.0;

 for(int i=0; i<pointerCount; i++) {
 	float dist = 1.3 * distance(uv, pointers[i].xy);
 	float inter = sin(time * 10.0 - dist/10.0);
 	inter *= smoothstep(0.0, 1.0, 100.0/dist);
 	val += inter;
 }

 vec3 col = vec3(0.3,0.6,1.0);

 col += val / 2.0;

	gl_FragColor = vec4(col,1.0);
}
mit