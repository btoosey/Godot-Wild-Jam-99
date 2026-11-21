extends VBoxContainer

signal change_to_colour(colour: int)

@onready var red: Button = $Red
@onready var yellow: Button = $Yellow
@onready var blue: Button = $Blue

const RED := 1
const YELLOW := 2
const BLUE := 4


func _on_red_pressed() -> void:
	change_to_colour.emit(RED)


func _on_yellow_pressed() -> void:
	change_to_colour.emit(YELLOW)


func _on_blue_pressed() -> void:
	change_to_colour.emit(BLUE)


func remove_unnecessary_paints(level_data: LevelData) -> void:
	var values: Array = level_data.solution.values()
	if values.has(1) or values.has(4) or values.has(6) or values.has(7):
		red.show()
	if values.has(2) or values.has(4) or values.has(5) or values.has(7):
		yellow.show()
	if values.has(4) or values.has(5) or values.has(6) or values.has(7):
		blue.show()
