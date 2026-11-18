class_name Palette extends Node2D

@export_enum("RED:1", "BLUE:2", "YELLOW:4") var current_paint_colour: int = RED

const RED := 1
const BLUE := 2
const YELLOW := 4
const MASK_TO_ATLAS := {
	RED: Vector2i(0, 0),
	YELLOW: Vector2i(1, 0),
	BLUE: Vector2i(2, 0),
	RED | YELLOW: Vector2i(3, 0),
	YELLOW | BLUE: Vector2i(4, 0),
	RED | BLUE: Vector2i(5, 0),
	RED | YELLOW | BLUE: Vector2i(6, 0)
}
