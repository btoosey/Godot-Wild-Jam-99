extends CanvasLayer


@onready var level_loader_reloader: Node = $"../LevelLoaderReloader"
@onready var game_state_machine: GameStateMachine = $"../GameStateMachine"
@onready var easy_levels: VBoxContainer = $Levels/Difficulties/Easy/EasyLevels
@onready var medium_levels: VBoxContainer = $Levels/Difficulties/Medium/MediumLevels
@onready var hard_levels: VBoxContainer = $Levels/Difficulties/Hard/HardLevels


func _ready() -> void:
	var levels = []
	for btn in easy_levels.get_children():
		levels.append(btn)
	for btn in medium_levels.get_children():
		levels.append(btn)
	for btn in hard_levels.get_children():
		levels.append(btn)

	for button in levels:
		button.level_selected.connect(_on_level_selected)


func _on_level_selected(level_scene: PackedScene) -> void:
	level_loader_reloader.level_scene = level_scene
	level_loader_reloader.instantiate_level()
	game_state_machine._on_transition_requested(game_state_machine.current_state, GameState.State.PLAY)
