extends Node2D

signal level_select_button_pressed
signal next_level_button_pressed

@export var level_data: LevelData

@onready var level_log: Node = $LevelLog
@onready var paintbrush: Paintbrush = $Paintbrush
@onready var layer_buttons: VBoxContainer = $LevelUI/LayerButtons
@onready var level_victory_ui: CanvasLayer = $LevelVictoryUI


func _ready() -> void:
	level_log.log_level_state()
	layer_buttons.change_to_colour.connect(paintbrush.set_colour)
	layer_buttons.remove_unnecessary_paints(level_data)
	paintbrush.solution_checked.connect(level_victory_ui.solution_checked)
	level_victory_ui.level_select_button_pressed.connect(_on_level_select_button_pressed)
	level_victory_ui.next_level_button_pressed.connect(_on_next_level_button_pressed)
	


func _on_level_select_button_pressed() -> void:
	level_select_button_pressed.emit()


func _on_next_level_button_pressed() -> void:
	next_level_button_pressed.emit()
