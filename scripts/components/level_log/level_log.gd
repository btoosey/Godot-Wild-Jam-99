extends Node

@export var paintbrush: Paintbrush
@export var player: Player

@onready var paint: TileMapLayer = $"../Tilemaps/Paint"

var allow_undo := true
var turn_number := 0
var level_log: Array[Dictionary] = []


func _ready() -> void:
	paintbrush.cell_painted.connect(log_level_state)
	player.player_moved.connect(log_level_state)


func _input(event: InputEvent) -> void:
	if not allow_undo:
		return

	if event.is_action_pressed("undo"):
		_undo()


func _undo() -> void:
	if level_log.size() <= 1:
		return

	level_log.pop_back()
	turn_number -= 1
	
	var state := level_log[-1]

	player.global_position = state["player"]
	paintbrush.restore_paint(state["paint"])


func log_level_state() -> void:
	var player_position = player.global_position

	var new_state := {
		"player": player_position,
		"paint": paintbrush.get_paint_snapshot(),
	}

	if level_log.is_empty() or level_log[-1] != new_state:
		level_log.append(new_state)
		turn_number += 1
