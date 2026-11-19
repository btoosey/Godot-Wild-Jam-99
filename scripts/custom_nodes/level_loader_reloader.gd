extends Node

@onready var level: Node2D = $"../Level"

var level_scene


func instantiate_level() -> void:
	var level_instance = level_scene.instantiate()
	level.add_child(level_instance)


func reload_level() -> void:
	clear_current_level()
	instantiate_level()


func _on_reload_level() -> void:
	reload_level()


func clear_current_level() -> void:
	if level.get_child_count() > 0:
		var lv = level.get_child(0)
		level.remove_child(lv)
		lv.queue_free()
