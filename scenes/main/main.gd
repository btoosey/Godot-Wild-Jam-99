extends Node

@onready var game_state_machine: GameStateMachine = $GameStateMachine as GameStateMachine

@export var main_music_stream: AudioStream

func _ready() -> void:
	game_state_machine.init()
	MusicPlayer.play(main_music_stream)
