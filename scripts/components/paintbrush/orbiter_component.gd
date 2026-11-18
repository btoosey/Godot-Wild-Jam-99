extends Node2D

@export var target: Paintbrush
@export var player: Player
@export var target_to_player_buffer: float = 10.0
@export var squircle_radius: float = 34.0
@export var corner_radius: float = 5.0
@export var turn_speed: float = 24.0

var angle := 0.0
var orbit_offset := Vector2.ZERO


func _process(delta: float) -> void:
	_update_orbit(delta)


func _update_orbit(delta: float) -> void:
	var to_mouse := get_global_mouse_position() - player.global_position

	if to_mouse.length_squared() > target_to_player_buffer:
		angle = lerp_angle(angle, to_mouse.angle(), 1.0 - exp(-turn_speed * delta))

	orbit_offset = _squircle_point(Vector2.from_angle(angle))
	target.global_position = player.global_position + orbit_offset


func _squircle_point(direction: Vector2) -> Vector2:
	var n := corner_radius
	var reach := pow(pow(absf(direction.x), n) + pow(absf(direction.y), n), 1.0 / n)
	return direction * squircle_radius / reach
