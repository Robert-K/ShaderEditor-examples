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

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
  vec2 muv = uv;
  muv.y /= resolution.x/resolution.y;

	vec2 c = vec2(0.5);

	vec2 tv = touch / resolution;
	vec2 mtv = tv;
	mtv.y /= resolution.x/resolution.y;

 float l = length(muv-mtv);
 l = 1.0/l;
 //l = step(l,0.3);
 uv += (vec2(0.5)*tv) * l;
	uv /= 1.0 + l * 0.5;

	uv.x = 1.0 - uv.x;

	vec2 st = cameraAddent + uv * cameraOrientation;

  vec3 cam = texture2D(cameraFront, st).rgb;

	gl_FragColor = vec4(cam,1.0);
}