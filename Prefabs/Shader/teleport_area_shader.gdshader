shader_type spatial;

// unshaded makes it glow in VR. cull_disabled lets you see it from the inside out.
render_mode unshaded, cull_disabled, blend_mix;

// These will appear in your Inspector so you can easily change colors without touching code
uniform vec4 hologram_color : source_color = vec4(0.0, 0.4, 1.0, 0.3);
uniform vec4 scanline_color : source_color = vec4(0.5, 0.9, 1.0, 1.0);
uniform float scan_speed = 0.5;

void fragment() {
    // 1. Soft Edges: Fades the cylinder out at the very top and bottom so it blends into the world
    float edge_fade = smoothstep(0.0, 0.1, UV.y) * smoothstep(1.0, 0.9, UV.y);

    // 2. The Engine: fract(TIME) makes a value smoothly loop between 0.0 and 1.0 endlessly
    float scan_position = fract(TIME * scan_speed);

    // Calculate how far the current pixel is from the moving scan position
    float distance_to_scan = abs(UV.y - scan_position);

    // 3. The Laser: Creates a bright line that is thickest in the middle and soft on the edges
    float scanline = smoothstep(0.08, 0.0, distance_to_scan);

    // Combine everything together
    vec3 final_albedo = mix(hologram_color.rgb, scanline_color.rgb, scanline);
    float final_alpha = max(hologram_color.a, scanline) * edge_fade;

    ALBEDO = final_albedo;
    ALPHA = final_alpha;
}