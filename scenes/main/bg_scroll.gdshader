shader_type canvas_item;

uniform float x_speed = .15;
uniform float y_speed = .3;

void vertex() {
	UV.x += TIME * x_speed;
	UV.y += TIME * y_speed;
}
