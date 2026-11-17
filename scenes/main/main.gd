extends Node

@onready var game_state_machine: GameStateMachine = $GameStateMachine as GameStateMachine
@onready var level_log: Node = $LevelLog
@onready var player: Player = $Player


func _ready() -> void:
	game_state_machine.init()
	#TODO relocate following lines to the level scene
	level_log.log_level_state()
	player.player_moved.connect(level_log.log_level_state)
