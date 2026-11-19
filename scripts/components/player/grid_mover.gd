class_name GridMover
extends Node2D

signal player_moved

@export var speed: float
@export var grid_size: Vector2
@export var player: CharacterBody2D
@export var ground: TileMapLayer
@export var walls: TileMapLayer

@onready var movement_marker: Marker2D = $MovementMarker

const INPUT_DIRECTIONS := {
	"player_up": Vector2.UP,
	"player_down": Vector2.DOWN,
	"player_left": Vector2.LEFT,
	"player_right": Vector2.RIGHT,
}

var is_moving := false
var target_position: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO
var held_directions: Array[Vector2] = []


func _ready() -> void:
	target_position = movement_marker.global_position


func _process(delta: float) -> void:
	_update_held_directions()

	if is_moving:
		_advance(delta)

	if is_moving:
		return

	if held_directions.is_empty():
		return

	direction = held_directions.back()
	_process_input()


func _update_held_directions() -> void:
	for action in INPUT_DIRECTIONS:
		var dir: Vector2 = INPUT_DIRECTIONS[action]

		if Input.is_action_just_pressed(action):
			held_directions.erase(dir)
			held_directions.append(dir)
		elif not Input.is_action_pressed(action):
			held_directions.erase(dir)


func _advance(delta: float) -> void:
	var step := speed * delta
	player.global_position = player.global_position.move_toward(target_position, step)

	if player.global_position == target_position:
		player_moved.emit()
		is_moving = false


func _process_input() -> void:
	movement_marker.global_position = player.global_position + (direction * grid_size)

	if _check_direction_clear(movement_marker.global_position):
		target_position = movement_marker.global_position
		is_moving = true


func _check_direction_clear(pos: Vector2) -> bool:
	var target_tile := walls.local_to_map(walls.to_local(pos))
	var target_tile_data: TileData = walls.get_cell_tile_data(target_tile)
	if target_tile_data != null and target_tile_data.get_custom_data('walls'):
		return false
	else:
		return true
