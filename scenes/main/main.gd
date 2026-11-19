extends Node

@onready var game_state_machine: GameStateMachine = $GameStateMachine as GameStateMachine
@onready var level_log: Node = $LevelLog
@onready var player: Player = $Player
@onready var paintbrush: Paintbrush = $Paintbrush
@onready var layer_buttons: VBoxContainer = $LevelUI/LayerButtons


func _ready() -> void:
	game_state_machine.init()
	#TODO relocate following lines to the level scene
	level_log.log_level_state()
	layer_buttons.change_to_colour.connect(paintbrush.set_colour)
