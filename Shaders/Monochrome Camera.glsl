#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 cameraAddent;
uniform mat2 cameraOrientation;
uniform samplerExternalOES cameraBack;
uniform vec2 touch;
uniform sampler2D spectrum256;///min:n;mag:l;s:c;t:c;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	vec2 st = cameraAddent + uv * cameraOrientation;

 vec2 t = touch / resolution;

 vec3 cam = texture2D(cameraBack, st).rgb;

 float l = (cam.r+cam.g+cam.b)/3.0;

 float s = floor(t.y * 16.0 + 0.5)-0.5;

 l = (floor(l * s+1.0)-1.0) / s;

 vec3 col = texture2D(spectrum256,vec2(l,t.x)).rgb;

	gl_FragColor = vec4(col,1.0);
}
