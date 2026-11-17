extends Node

var allow_undo := true
var turn_number := 0
var level_log := []


func _input(event: InputEvent) -> void:
	if not allow_undo:
		return

	if event.is_action_pressed("undo"):
		_undo()


func _undo() -> void:
	if level_log.size() <= 1:
		return

	var player: Player = get_tree().get_nodes_in_group("players")[0]
	player.global_position = level_log[-2][0]
	level_log.pop_back()
	turn_number -= 1


func log_level_state() -> void:
	var new_state := []

	for player: CharacterBody2D in get_tree().get_nodes_in_group("players"):
		new_state.append(player.global_position)

	if level_log.is_empty() or level_log[-1] != new_state:
		level_log.append(new_state)
		turn_number += 1
