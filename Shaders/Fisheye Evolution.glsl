#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 cameraAddent;
uniform mat2 cameraOrientation;
uniform samplerExternalOES cameraFront;
uniform vec2 touch;
uniform float time;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	uv.x = 1.0 - uv.x;

	vec2 c = vec2(0.5);

	vec2 tv = touch / resolution;
	tv.x = tv.x * 10.0 + 1.0;

	float s = sin(time*tv.x)*tv.y;

	vec2 de = uv - c;

	uv += de * s;

	de *= s * length(de) * 2.0;

	uv -= de;

	vec2 st = cameraAddent + uv * cameraOrientation;

  vec3 cam = texture2D(cameraFront, st).rgb;

	gl_FragColor = vec4(cam,1.0);
}
