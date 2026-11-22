class_name Paintbrush extends Node2D

signal cell_painted
signal solution_checked(correct: bool)

@export var player: Player
@export_range(0.0, 1.0) var inactive_layer_alpha: float = 0.3
@export var paint_sfx: AudioStream
@export var erase_sfx: AudioStream
@export var wrong_sfx: AudioStream

@export_group("Check Animation")
@export var layer_spread: Vector2 = Vector2(-24, -48)
@export var wait_time: float = 0.8
@export var spread_time: float = 0.8
@export var combine_time: float = 0.8
@export var blend_time: float = 0.4

@onready var skin: Sprite2D = $Visuals/Skin
@onready var palette: Node2D = $Palette
@onready var walls: TileMapLayer = $"../Tilemaps/Walls"
@onready var blockers: TileMapLayer = $"../Tilemaps/Blockers"
@onready var red_layer: TileMapLayer = $"../Tilemaps/PaintRed"
@onready var yellow_layer: TileMapLayer = $"../Tilemaps/PaintYellow"
@onready var blue_layer: TileMapLayer = $"../Tilemaps/PaintBlue"
@onready var result_layer: TileMapLayer = $"../Tilemaps/PaintResult"

var layers := {}
var layer_home_positions := {}

var current_cell: Vector2i = Vector2i.ZERO
var paint_button_held: bool = false
var erase_button_held: bool = false

var show_combined: bool = false
var is_checking: bool = false

var paint_state := {}


func _ready() -> void:
	layers = {palette.RED: red_layer, palette.YELLOW: yellow_layer, palette.BLUE: blue_layer}
	for colour: int in layers:
		layer_home_positions[colour] = layers[colour].position

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
		skin.region_rect.position.x = 32
		if player.grid_mover.is_moving:
			return
		_try_paint()
	elif event.is_action_released("paint"):
		skin.region_rect.position.x = 0
		paint_button_held = false

	elif event.is_action_pressed("erase"):
		erase_button_held = true
		if player.grid_mover.is_moving:
			return
		_try_paint()
	elif event.is_action_released("erase"):
		erase_button_held = false

	elif event.is_action_pressed("toggle_combine"):
		check_solution()


func _try_paint() -> void:
	if is_checking or show_combined:
		return

	if not paint_button_held and not erase_button_held:
		return

	if not _can_paint(current_cell):
		return

	if paint_button_held:
		_remove_blocker(current_cell)
		_paint_cell(current_cell)
		SFXPlayer.play(paint_sfx)
	else:
		if blockers.get_cell_tile_data(current_cell):
			_remove_blocker(current_cell)
		elif red_layer.get_cell_tile_data(current_cell) == null and yellow_layer.get_cell_tile_data(current_cell) == null and blue_layer.get_cell_tile_data(current_cell) == null:
			_add_blocker(current_cell)
		else:
			_erase_cell(current_cell)
			SFXPlayer.play(erase_sfx)


func _can_paint(cell: Vector2i) -> bool:
	if walls.get_cell_tile_data(cell):
		return false

	return true


func _paint_cell(cell: Vector2i) -> void:
	_set_cell_mask(cell, paint_state.get(cell, 0) | palette.current_paint_colour)


func _erase_cell(cell: Vector2i) -> void:
	_set_cell_mask(cell, paint_state.get(cell, 0) & ~palette.current_paint_colour)


func _remove_blocker(cell: Vector2i) -> void:
	blockers.erase_cell(cell)


func _add_blocker(cell: Vector2i) -> void:
	blockers.set_cell(cell, 0, Vector2i(0,0))


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
	match primary:
		1:
			skin.region_rect.position = Vector2(0, 0)
		2:
			skin.region_rect.position = Vector2(0, 32)
		_:
			skin.region_rect.position = Vector2(0, 64)
	_update_view()


func _editing_alpha(colour: int) -> float:
	if colour == palette.current_paint_colour:
		return 1.0
	else:
		return inactive_layer_alpha


func _update_view() -> void:
	if layers.is_empty() or is_checking and not show_combined:
		return

	for colour: int in layers:
		var layer: TileMapLayer = layers[colour]
		var is_active: bool = colour == palette.current_paint_colour
		layer.visible = not show_combined
		layer.modulate.a = _editing_alpha(colour)
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


func check_solution() -> void:
	if is_checking or show_combined:
		return

	is_checking = true
	
	_prepare_check_view()

	await _move_layers(1.0, spread_time, true)
	await  _move_layers(0.0, combine_time)
	await _blend_paint(true)

	var correct: bool = _is_solved()
	solution_checked.emit(correct)
	if correct:
		show_combined = true
		_update_view()
		return

	await _paint_shake()
	await get_tree().create_timer(wait_time).timeout
	await _blend_paint(false)
	is_checking = false
	_update_view()


func _is_solved() -> bool:
	return paint_state == get_parent().level_data.solution


func _prepare_check_view() -> void:
	for colour: int in layers:
		var layer: TileMapLayer = layers[colour]
		layer.show()
		layer.z_index = 0

	result_layer.show()
	result_layer.modulate.a = 0.0


func _move_layers(spread: float, duration: float, fade_to_full: bool = false) -> void:
	var tween := create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

	for colour: int in layers:
		var layer: TileMapLayer = layers[colour]
		tween.tween_property(layer, "position", layer_home_positions[colour] + _spread_offset(colour) * spread, duration)
		if fade_to_full:
			tween.tween_property(layer, "modulate:a", 1.0, duration)

	await tween.finished


func _spread_offset(colour: int) -> Vector2:
	match colour:
		palette.YELLOW:
			return layer_spread
		palette.BLUE:
			return - layer_spread
		_:
			return Vector2.ZERO


func _paint_shake() -> void:
	SFXPlayer.play(wrong_sfx)
	var home := result_layer.position
	var tween := create_tween()

	for i in 3:
		tween.tween_property(result_layer, "position", home + Vector2(6, 0), 0.06)
		tween.tween_property(result_layer, "position", home - Vector2(6, 0), 0.06)
	tween.tween_property(result_layer, "position", home, 0.06)

	await  tween.finished


func _blend_paint(to_mix: bool) -> void:
	var tween := create_tween().set_parallel(true)

	tween.tween_property(result_layer, "modulate:a", 1.0 if to_mix else 0.0, blend_time)
	for colour: int in layers:
		var target_alpha := 0.0 if to_mix else _editing_alpha(colour)
		tween.tween_property(layers[colour], "modulate:a", target_alpha, blend_time)

	await tween.finished
