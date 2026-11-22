shader_type spatial;

uniform sampler2D noise;
uniform mediump float noise_scale = 0.4;
uniform mediump float height_scale = 300.0;
uniform sampler2D color_gradient;
uniform mediump float metallic: hint_range(0.0, 1.0) = 0.0;
uniform mediump float roughness: hint_range(0.0, 1.0) = 0.2;
uniform mediump float specular: hint_range(0.0, 1.0) = 0.3;

varying float height;

void vertex() {
	// Called for every vertex the material is visible on.
	vec2 world_pos = (MODEL_MATRIX * vec4(0.0, 0.0, 0.0, 1.0)).xz;
	vec2 global_pos = world_pos + VERTEX.xz * noise_scale;
	height = texture(noise, global_pos).x * height_scale;
	VERTEX.y += height;
	
	NORMAL = normalize(vec3(height - texture(noise, global_pos + vec2(0.01, 0.0)).x * height_scale, 0.01, texture(noise, global_pos + vec2(0.0, 0.01)).x * height_scale));
	
	float height_ratio = height / height_scale;
	
	COLOR = texture(color_gradient, vec2(height_ratio, height_ratio));//smoothstep(base_color, peak_color, color * height_ratio);
}


void fragment() {
	METALLIC = metallic;
	SPECULAR = specular;
	
	ALBEDO = COLOR.rgb;
	
	ROUGHNESS = roughness;
}
