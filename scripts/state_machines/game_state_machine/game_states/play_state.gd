extends GameState

@onready var pause_menu: CanvasLayer = %PauseMenu


func enter() -> void:
	pause_menu.pausable = true


func exit() -> void:
	pause_menu.pausable = false
