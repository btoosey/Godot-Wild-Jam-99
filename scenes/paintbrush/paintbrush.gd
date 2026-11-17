class_name Paintbrush extends Node2D

signal cell_painted(cell: Vector2i)

@export var player: Player

@onready var walls: TileMapLayer = $"../Tilemaps/Walls"
@onready var paint: TileMapLayer = $"../Tilemaps/Paint"

var current_cell: Vector2i = Vector2i.ZERO
var paint_button_held: bool = false


func _process(_delta: float) -> void:
	var hovered_cell: Vector2i = paint.local_to_map(paint.to_local(global_position))

	if hovered_cell == current_cell:
		return
	else:
		current_cell = hovered_cell
		if not player.grid_mover.is_moving:
			try_paint()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("paint"):
		paint_button_held = true
		try_paint()

	if event.is_action_released("paint"):
		paint_button_held = false


func try_paint() -> void:
	if not paint_button_held:
		return

	if can_paint(current_cell):
		paint_cell(current_cell)


func can_paint(cell: Vector2i) -> bool:
	if paint.get_cell_tile_data(cell) or walls.get_cell_tile_data(cell):
		return false

	return true


func paint_cell(cell: Vector2i) -> void:
	paint.set_cell(cell, 0, Vector2i.ZERO)
	cell_painted.emit(cell)
