extends Node2D


func hide_clues() -> void:
	for clue in get_children():
		clue.hide()
