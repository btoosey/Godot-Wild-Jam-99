extends Node2D

@export var level_data: LevelData

@onready var level_log: Node = $LevelLog
@onready var paintbrush: Paintbrush = $Paintbrush
@onready var layer_buttons: VBoxContainer = $LevelUI/LayerButtons


func _ready() -> void:
	level_log.log_level_state()
	layer_buttons.change_to_colour.connect(paintbrush.set_colour)
