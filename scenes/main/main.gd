extends Node

@onready var game_state_machine: GameStateMachine = $GameStateMachine as GameStateMachine
@onready var level_log: Node = $LevelLog
@onready var player: Player = $Player
@onready var paintbrush: Paintbrush = $Paintbrush


func _ready() -> void:
	game_state_machine.init()
	#TODO relocate following lines to the level scene
	level_log.log_level_state()
	player.player_moved.connect(level_log.log_level_state)
	player.player_moved.connect(paintbrush.try_paint)
	paintbrush.cell_painted.connect(level_log.log_level_state)
