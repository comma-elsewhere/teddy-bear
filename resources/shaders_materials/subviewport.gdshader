shader_type canvas_item;

// The parameter name (e.g., "viewport_texture") is used in the inspector
uniform sampler2D viewport_texture : source_color, filter_linear_mipmap;

void fragment() {
    // Sample the texture using UV coordinates
    COLOR = texture(viewport_texture, UV);
}