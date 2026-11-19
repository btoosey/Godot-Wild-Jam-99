extends VBoxContainer

signal change_to_colour(colour: int)

const RED := 1
const YELLOW := 2
const BLUE := 4


func _on_red_pressed() -> void:
	change_to_colour.emit(RED)


func _on_yellow_pressed() -> void:
	change_to_colour.emit(YELLOW)


func _on_blue_pressed() -> void:
	change_to_colour.emit(BLUE)
