extends Node

@onready var game_state_machine: GameStateMachine = $GameStateMachine as GameStateMachine
@onready var level_loader_reloader: Node = $LevelLoaderReloader
const LEVEL_001 = preload("uid://bihqm1ntlmqo1")


func _ready() -> void:
	game_state_machine.init()
	level_loader_reloader.level_scene = LEVEL_001
	level_loader_reloader.instantiate_level()
