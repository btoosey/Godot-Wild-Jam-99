class_name Clue extends Node2D

@export var value: int
@export_enum("Red:1", "Yellow:2", "Blue:4", "Orange:3", "Green:6", "Purple:5", "Brown:7") var clue_colour: int

@onready var label: Label = $ClueUI/Label


func _ready() -> void:
	label.add_theme_color_override("font_color", Colours.colour_of(clue_colour))
	label.text = str(value)
