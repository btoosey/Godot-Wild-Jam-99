extends Node

@onready var level: Node2D = $"../Level"
@onready var pause_menu: CanvasLayer = %PauseMenu

var level_scene


func instantiate_level() -> void:
	var level_instance = level_scene.instantiate()
	level.add_child(level_instance)
	level_instance.level_select_button_pressed.connect(pause_menu._on_level_select_button_pressed)
	level_instance.next_level_button_pressed.connect(_go_to_next_level.bind(level_instance.level_data.next_level))


func reload_level() -> void:
	clear_current_level()
	instantiate_level()


func clear_current_level() -> void:
	if level.get_child_count() > 0:
		var lv = level.get_child(0)
		level.remove_child(lv)
		lv.queue_free()


func _go_to_next_level(lvl: PackedScene) -> void:
	level_scene = lvl
	clear_current_level()
	instantiate_level()
