shader_type canvas_item;

uniform float speed = 0.03;
uniform float density = 1.5;
uniform float softness = 0.4;

float noise(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float smooth_noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);

    float a = noise(i);
    float b = noise(i + vec2(1.0, 0.0));
    float c = noise(i + vec2(0.0, 1.0));
    float d = noise(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
           (c - a) * u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

void fragment() {
    vec2 uv = UV;

    // движение тумана слева направо
    float t = TIME * speed;

    vec2 pos = uv * density;
    pos.x += t;

    float n = smooth_noise(pos);

    // мягкая маска тумана
    float fog = smoothstep(0.4, 0.8, n);

    vec3 fog_color = vec3(0.8, 0.85, 0.9);

    COLOR = vec4(fog_color, fog * 0.6);
}