#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 cameraAddent;
uniform mat2 cameraOrientation;
uniform samplerExternalOES cameraBack;

vec3 hsv2rgb(vec3 c) {
  vec3 rgb = clamp(abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),6.0)-3.0)-1.0, 0.0, 1.0 );
  rgb = rgb*rgb*(3.0-2.0*rgb);
  return c.z * mix( vec3(1.0), rgb, c.y);
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	vec2 st = cameraAddent + uv * cameraOrientation;

	vec3 cam = texture2D(cameraBack, st).rgb;

	vec3 col = cam;
	col.r *= 10.0;
	col.g *= 3.0;
	col = hsv2rgb(col);

	gl_FragColor = vec4(col,1.0);
}
