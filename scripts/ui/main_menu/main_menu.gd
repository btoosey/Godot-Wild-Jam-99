extends CanvasLayer

@onready var game_state_machine: GameStateMachine = $"../GameStateMachine"


func _on_start_game_pressed() -> void:
	game_state_machine._on_transition_requested(game_state_machine.current_state, GameState.State.LEVEL_SELECT)
