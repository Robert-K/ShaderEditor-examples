#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec2 touch;
uniform sampler2D backbuffer;


float sphereSDF(vec2 p, float size) {
	return length(p) - size;
}

float boxSDF(vec2 p, vec2 size) {
	vec2 r = abs(p) - size;
    return min(max(r.x, r.y),0.) + length(max(r,vec2(0,0)));
}

float segmentSDF(vec2 p, vec2 a, vec2 b)
{
	vec2 c = p - a;
	vec2 v = normalize(b - a);
	float d = distance(a, b);
	float t = dot(v,c);

	if(t < 0.) return distance(p, a);
	if(t > d) return distance(p, b);

	v *= t;

  return distance(p, a + v);
}


void AddObj(inout float dist, inout vec3 color, float d, vec3 c) {
    if (dist > d) {dist = d; color = c; }
}

float random (in vec2 _st) {
    return fract(sin(dot(_st.xy,
        vec2(12.9898,78.233)))*
        43758.5453123);
}

#define SAMPLES 32.
#define TIMESPAN 5.

void scene(in vec2 pos, out vec3 color, out float dist) {
    dist = 100.0; color = vec3(0,0,0);
    //AddObj(dist, color, boxSDF(pos - vec2(-3,1), vec2(1,1)), vec3(.5));
    //AddObj(dist, color, sphereSDF(pos - vec2(3,1), 1.), vec3(2,2,1));
    //AddObj(dist, color, boxSDF(pos - vec2(0,2), vec2(1.5,0.25)), 2.*vec3(.5,.1,.1));

    AddObj(dist, color, segmentSDF(pos, vec2(2,-2), vec2(2,2)), vec3(.2,.5,.1));
    AddObj(dist, color, segmentSDF(pos, vec2(-2,-2), vec2(-2,2)), vec3(1));
    AddObj(dist, color, segmentSDF(pos, vec2(2,-2), vec2(-2,-2)), vec3(0));
    AddObj(dist, color, segmentSDF(pos, vec2(2,2), vec2(-2,2)), vec3(.5,.1,.2));

    //AddObj(dist, color, sphereSDF(pos - vec2(1,-3), .5), vec3(4.,2.,1.));
    //AddObj(dist, color, boxSDF(pos - vec2(-1,1), vec2(.5)), vec3(.1));

    vec2 t = touch-resolution.xy/2.;
    t /= resolution.y/10.;

    AddObj(dist, color, sphereSDF(pos - t, .5), vec3(4.,2.,1.));
}

void trace(vec2 p, vec2 dir, out vec3 c) {

    float d;
    for (;;) {
        scene(p, c, d);
        if (d < 0.01) return;
        if (d > 3.0) break;
        p += dir * d;
    }
    c = vec3(.2,.2,.2);
}

void main(void){
   //vec2 jitter = vec2(random(time*.5*gl_FragCoord.xy)-.5, random(time*gl_FragCoord.xy)-.5);
   vec2 uv = (gl_FragCoord.xy /*+ jitter*/) / resolution.xy;
   vec3 prevCol = texture2D(backbuffer, uv).rgb;

   uv = gl_FragCoord.xy-resolution.xy/2.;
   uv /= resolution.y/10.;

    vec3 col = vec3(0,0,0);
    for (float i = 0.0; i < SAMPLES; i++) {
        float t;
        vec3 c;
        t = (i + random(uv+i+fract(time))) / SAMPLES * 2. * 3.1415;
        trace(uv, vec2(cos(t), sin(t)), c);
        col += c;

    }
    col /= SAMPLES;
    float st = 1.0/TIMESPAN;
    col = prevCol*(1.0-st)+col*st;

    gl_FragColor = vec4(col,1.0);
}