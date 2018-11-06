#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 touch;

void main(void) {
 float w = (step(mod(gl_FragCoord.x,touch.x),touch.x/2.0)-0.5)*2.0;
 w *= (step(mod(gl_FragCoord.y,touch.y),touch.y/2.0)-0.5)*2.0;

	gl_FragColor = vec4(w,w,w, 1.0);
}
