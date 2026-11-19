extends CanvasLayer

@onready var levels: VBoxContainer = $VBoxContainer/Levels
@onready var level_loader_reloader: Node = $"../LevelLoaderReloader"
@onready var game_state_machine: GameStateMachine = $"../GameStateMachine"


func _ready() -> void:
	for button in levels.get_children():
		button.level_selected.connect(_on_level_selected)


func _on_level_selected(level_scene: PackedScene) -> void:
	level_loader_reloader.level_scene = level_scene
	level_loader_reloader.instantiate_level()
	game_state_machine._on_transition_requested(game_state_machine.current_state, GameState.State.PLAY)
