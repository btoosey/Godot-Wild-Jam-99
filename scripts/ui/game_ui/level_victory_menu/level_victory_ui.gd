extends CanvasLayer

signal level_select_button_pressed
signal next_level_button_pressed

@onready var blockers: TileMapLayer = $"../Tilemaps/Blockers"
@onready var walls: TileMapLayer = $"../Tilemaps/Walls"
@onready var level_ui: CanvasLayer = $"../LevelUI"
@onready var paintbrush: Paintbrush = $"../Paintbrush"
@onready var buttons: VBoxContainer = $Buttons
@onready var next_level_button: Button = $Buttons/NextLevelButton
@onready var clue_container: Node2D = $"../ClueContainer"


func _ready() -> void:
	if not get_parent().level_data.next_level:
		next_level_button.hide()


func solution_checked(correct: bool) -> void:
	if correct:
		paintbrush.hide()
		level_ui.hide()
		buttons.show()
		clue_container.hide_clues()
		blockers.hide()
		var tween := create_tween()
		tween.tween_property(walls, "modulate:a", 0.0, 1)
		PlayerProgress.increment_highest_unlocked()


func _on_level_select_button_pressed() -> void:
	level_select_button_pressed.emit()


func _on_next_level_button_pressed() -> void:
	next_level_button_pressed.emit()
