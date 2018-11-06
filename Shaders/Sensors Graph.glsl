#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform sampler2D backbuffer;
uniform vec3 gravity;
uniform vec3 magnetic;
uniform vec3 linear;
uniform vec2 touch;

#define COUNT 11

vec3 hsv2rgb(vec3 c) {
  vec3 rgb = clamp(abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),6.0)-3.0)-1.0, 0.0, 1.0 );
  rgb = rgb*rgb*(3.0-2.0*rgb);
  return c.z * mix( vec3(1.0), rgb, c.y);
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

  vec3 grav = (gravity + 9.81) / 19.62;
  vec3 mag = (magnetic + 65.0) / 130.0;
  vec3 lin = linear / 20.0 + 0.5;
  vec2 tch = touch / resolution;

  float vals[COUNT];
  vals[0] = grav.x;
  vals[1] = grav.y;
  vals[2] = grav.z;
  vals[3] = mag.x;
  vals[4] = mag.y;
  vals[5] = mag.z;
  vals[6] = lin.x;
  vals[7] = lin.y;
  vals[8] = lin.z;
  vals[9] = tch.x;
  vals[10] = tch.y;

  float width = 0.03;

  float step = 0.001;

  float x = step(1.0 - step, uv.y);

  vec3 col = vec3(0.0);

  for(int i=0;i<COUNT;i++){
    col += step(abs(uv.x-vals[i]), width)*x*hsv2rgb(vec3(float(i)/float(COUNT),1.0,0.5));
  }

  vec2 co = vec2(uv.x, uv.y + step);
  vec3 buf = step(uv.y,1.0-step)*texture2D(backbuffer, co).rgb;

	gl_FragColor = vec4(col+buf, 1.0);
}
