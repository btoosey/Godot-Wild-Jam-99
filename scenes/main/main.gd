extends Node

@onready var game_state_machine: GameStateMachine = $GameStateMachine as GameStateMachine


func _ready() -> void:
	game_state_machine.init()
