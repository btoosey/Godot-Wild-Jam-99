extends Camera2D

@export var target: CharacterBody2D


func _process(_delta: float) -> void:
	_update_camera_position()


func _update_camera_position() -> void:
	global_position = target.global_position
