extends GameState

@onready var level_select: CanvasLayer = %LevelSelect


func enter() -> void:
	level_select.show()


func exit() -> void:
	level_select.hide()
