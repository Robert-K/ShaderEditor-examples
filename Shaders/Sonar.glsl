	#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 cameraAddent;
uniform mat2 cameraOrientation;
uniform samplerExternalOES cameraBack;
uniform float time;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	vec2 st = cameraAddent + uv * cameraOrientation;

  vec3 cam = texture2D(cameraBack, st).rgb;

  float l = (cam.r+cam.g+cam.b)/3.0;

  float t = 1.0*time;

  float s = t-floor(t);

  float m = step(abs(l-s),0.02);

  vec3 col = vec3(0.2,0.9,1.1)*m;

	gl_FragColor = vec4(cam+col,1.0);
}
