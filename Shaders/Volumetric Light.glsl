#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

#define PI 3.14159
#define NORM vec2(resolution.x / resolution.y,1.0)

uniform vec2 resolution;
uniform sampler2D backbuffer;///min:l;mag:l;s:c;t:c;
uniform vec2 touch;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

 vec3 b;

 vec2 t = touch / resolution;
 float d = length((uv-t)*NORM);

 b += (1.0-smoothstep(0.05,0.3,d));

 b *= 1.0 - step(abs(uv.x-0.5),0.1);
 b *= 1.0 - step(0.55,uv.y) * (1.0-smoothstep(0.65,0.67,uv.y));

 b += 0.8 * texture2D(backbuffer,0.9*(uv-0.5)+0.5).rgb;

 b *= vec3(1.0,0.75,0.4);

	gl_FragColor = vec4(b, 1.0);
}
