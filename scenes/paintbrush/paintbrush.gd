class_name Paintbrush extends Node2D

signal cell_painted

@export var player: Player

@onready var palette: Node2D = $Palette
@onready var walls: TileMapLayer = $"../Tilemaps/Walls"
@onready var paint: TileMapLayer = $"../Tilemaps/Paint"

var current_cell: Vector2i = Vector2i.ZERO
var paint_button_held: bool = false
var paint_state := {}


func _ready() -> void:
	player.player_moved.connect(_try_paint)


func _process(_delta: float) -> void:
	var hovered_cell: Vector2i = paint.local_to_map(paint.to_local(global_position))

	if hovered_cell == current_cell:
		return
	else:
		current_cell = hovered_cell
		if not player.grid_mover.is_moving:
			_try_paint()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("paint"):
		paint_button_held = true
		if player.grid_mover.is_moving:
			return
		_try_paint()

	if event.is_action_released("paint"):
		paint_button_held = false


func _try_paint() -> void:
	if not paint_button_held:
		return

	if _can_paint(current_cell):
		_paint_cell(current_cell)


func _can_paint(cell: Vector2i) -> bool:
	if walls.get_cell_tile_data(cell):
		return false

	return true


func _paint_cell(cell: Vector2i) -> void:
	var old_mask: int = paint_state.get(cell, 0)
	var new_mask: int = old_mask | palette.current_paint_colour
	if old_mask == new_mask:
		return

	paint_state[cell] = new_mask
	paint.set_cell(cell, 0, palette.MASK_TO_ATLAS[new_mask])
	cell_painted.emit()


func get_paint_snapshot() -> Dictionary:
	return paint_state.duplicate()


func restore_paint(snapshot: Dictionary) -> void:
	paint_state = snapshot.duplicate()
	paint.clear()

	for cell: Vector2i in paint_state:
		paint.set_cell(cell, 0, palette.MASK_TO_ATLAS[paint_state[cell]])
