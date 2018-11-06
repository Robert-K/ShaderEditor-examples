#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform sampler2D backbuffer;
uniform vec3 linear;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

  float sens = 20.0;

 vec3 lin = linear / sens + 0.5;
 float len = length(linear) / (sens*0.5);

  float r = lin.r;
  float g = lin.g;
  float b = lin.b;

  float ra = abs(r);
  float ga = abs(g);
  float ba = abs(b);

  vec3 dom;

  if(ra > max(ga,ba)) dom = vec3(1.0,0.0,0.0);
  if(ga > max(ra,ba)) dom = vec3(0.0,1.0,0.0);
  if(ba > max(ra,ga)) dom = vec3(0.0,0.0,1.0);

  float step = 0.001;

  float x = step(1.0 - step, uv.y);

  float rl = step(abs(uv.x-r), abs(r-0.5)*0.1+0.01) * x;
  float gl = step(abs(uv.x-g), abs(g-0.5)*0.1+0.01) * x;
  float bl = step(abs(uv.x-b), abs(b-0.5)*0.1+0.01) * x;

  vec2 co = vec2(uv.x, uv.y + step);
  vec3 buf = step(uv.y,1.0-step)*texture2D(backbuffer, co).rgb;

  vec3 col = vec3(min(1.0,rl+buf.r),
  	              min(1.0,bl+buf.g),
  	              min(1.0,gl+buf.b));
  if(uv.x>0.97&&uv.y>1.0-step) col = dom;
  if(length(col)==0.0) col = vec3(len);

	gl_FragColor = vec4(col, 1.0);
}
