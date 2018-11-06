#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform sampler2D backbuffer;
uniform vec3 pointers[10];
uniform int pointerCount;

vec3 hsv2rgb(vec3 c) {
  vec3 rgb = clamp(abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),6.0)-3.0)-1.0, 0.0, 1.0 );
  rgb = rgb*rgb*(3.0-2.0*rgb);
  return c.z * mix( vec3(1.0), rgb, c.y);
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

  float width = 0.02;

  float step = 0.002;

  float w = step(1.0 - step, uv.y);

  vec3 col = vec3(0.0);

  for(int x=0;x<pointerCount;x++){
    col += step(abs(uv.x-pointers[x].x/resolution.x), width)*w*hsv2rgb(vec3(float(x)/10.,1.,.5));
  }
  for(int y=0;y<pointerCount;y++){
    col += step(abs(uv.x-pointers[y].y/resolution.y), width)*w*hsv2rgb(vec3(float(y+pointerCount)/10.,1.,.5));
  }

  vec2 co = vec2(uv.x, uv.y + step);
  vec3 buf = step(uv.y,1.0-step)*texture2D(backbuffer, co).rgb;

	gl_FragColor = vec4(col+buf, 1.0);
}
