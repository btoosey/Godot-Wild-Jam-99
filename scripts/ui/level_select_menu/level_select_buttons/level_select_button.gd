extends Button

signal level_selected(level_scene: PackedScene)

@export var level_scene: PackedScene


func _on_pressed() -> void:
	level_selected.emit(level_scene)
