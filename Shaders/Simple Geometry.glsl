#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

#define PI 3.14159

uniform vec2 resolution;
uniform float time;

vec2 remap(vec2 coord) {
	if (resolution.x>resolution.y) {
		return coord / resolution * vec2(resolution.x/resolution.y,1.0);
	} else {
		return coord / resolution * vec2(1.0,resolution.y/resolution.x);
	}
}

float rect(vec2 uv, vec2 pos, vec2 size, float rot) {
	uv = (uv-pos) * mat2(cos(rot), sin(rot), -sin(rot), cos(rot));
	uv += pos;
 return (step(uv.x,pos.x+size.x/2.0) - step(uv.x,pos.x-size.x/2.0)) * (step(uv.y,pos.y+size.y/2.0) - step(uv.y,pos.y-size.y/2.0));
}

float circle(vec2 uv, vec2 pos, float rad) {
	return step(length(uv-pos),rad);
}

void main(void) {
 vec2 uv = remap(gl_FragCoord.xy);

 float geo = 0.0;

 int rectCount = 10;
 for (int i=0;i<rectCount;i++) {
 	float val = float(i) / float(rectCount);
 	vec2 pos = vec2(sin(time+2.0*PI*val)*0.5+0.5,cos(time+2.0*PI*val)*0.5+0.5);
 	geo += circle(uv,pos,0.03);
 }

 geo += rect(uv,vec2(0.5),vec2(0.5),time);

 vec3 col = vec3(uv,1.0);

 gl_FragColor = vec4(col * geo, 1.0);
}
