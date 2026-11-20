class_name Clue extends Node2D

@export var colour: Color
@export var value: int

@onready var label: Label = $ClueUI/Label


func _ready() -> void:
	label.add_theme_color_override("font_color", Color.RED)
	label.text = str(value)
