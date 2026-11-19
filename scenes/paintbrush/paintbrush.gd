class_name Paintbrush extends Node2D

signal cell_painted

@export var player: Player
@export_range(0.0, 1.0) var inactive_layer_alpha: float = 0.3

@onready var palette: Node2D = $Palette
@onready var walls: TileMapLayer = $"../Tilemaps/Walls"
@onready var red_layer: TileMapLayer = $"../Tilemaps/PaintRed"
@onready var yellow_layer: TileMapLayer = $"../Tilemaps/PaintYellow"
@onready var blue_layer: TileMapLayer = $"../Tilemaps/PaintBlue"
@onready var result_layer: TileMapLayer = $"../Tilemaps/PaintResult"

var layers := {}
var current_cell: Vector2i = Vector2i.ZERO
var paint_button_held: bool = false
var erase_button_held: bool = false
var show_combined: bool = false

var paint_state := {}


func _ready() -> void:
	layers = {palette.RED: red_layer, palette.YELLOW: yellow_layer, palette.BLUE: blue_layer}
	player.player_moved.connect(_try_paint)
	_update_view()


func _process(_delta: float) -> void:
	var hovered_cell: Vector2i = result_layer.local_to_map(result_layer.to_local(global_position))

	if hovered_cell == current_cell:
		return
	else:
		current_cell = hovered_cell
		if not player.grid_mover.is_moving:
			_try_paint()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("paint"):
		paint_button_held = true
		if player.grid_mover.is_moving:
			return
		_try_paint()
	elif event.is_action_released("paint"):
		paint_button_held = false

	elif event.is_action_pressed("erase"):
		erase_button_held = true
		if player.grid_mover.is_moving:
			return
		_try_paint()
	elif event.is_action_released("erase"):
		erase_button_held = false

	elif event.is_action_pressed("toggle_combine"):
		set_combined(not show_combined)


func _try_paint() -> void:
	if show_combined:
		return

	if not paint_button_held and not erase_button_held:
		return

	if not _can_paint(current_cell):
		return

	if paint_button_held:
		_paint_cell(current_cell)
	else:
		_erase_cell(current_cell)


func _can_paint(cell: Vector2i) -> bool:
	if walls.get_cell_tile_data(cell):
		return false

	return true


func _paint_cell(cell: Vector2i) -> void:
	_set_cell_mask(cell, paint_state.get(cell, 0) | palette.current_paint_colour)


func _erase_cell(cell: Vector2i) -> void:
	_set_cell_mask(cell, paint_state.get(cell, 0) & ~palette.current_paint_colour)


func _set_cell_mask(cell: Vector2i, new_mask: int) -> void:
	var old_mask: int = paint_state.get(cell, 0)
	if old_mask == new_mask:
		return

	if new_mask == 0:
		paint_state.erase(cell)
	else:
		paint_state[cell] = new_mask

	_redraw_cell(cell)
	cell_painted.emit()


func _redraw_cell(cell: Vector2i) -> void:
	var mask: int = paint_state.get(cell, 0)

	for primary: int in layers:
		var layer: TileMapLayer = layers[primary]
		if mask & primary:
			layer.set_cell(cell, 0, palette.MASK_TO_ATLAS[primary])
		else:
			layer.erase_cell(cell)

	if mask == 0:
		result_layer.erase_cell(cell)
	else:
		result_layer.set_cell(cell, 0, palette.MASK_TO_ATLAS[mask])


func set_colour(primary: int) -> void:
	palette.current_paint_colour = primary
	_update_view()


func set_combined(value: bool) -> void:
	show_combined = value
	_update_view()


func _update_view() -> void:
	if layers.is_empty():
		return

	for primary: int in layers:
		var layer: TileMapLayer = layers[primary]
		var is_active: bool = primary == palette.current_paint_colour
		layer.visible = not show_combined
		layer.modulate.a = 1.0 if is_active else inactive_layer_alpha
		layer.z_index = 1 if is_active else 0

	result_layer.visible = show_combined


func get_paint_snapshot() -> Dictionary:
	return paint_state.duplicate()


func restore_paint(snapshot: Dictionary) -> void:
	paint_state = snapshot.duplicate()

	for layer: TileMapLayer in layers.values():
		layer.clear()
	result_layer.clear()

	for cell: Vector2i in paint_state:
		_redraw_cell(cell)
