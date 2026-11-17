class_name Player extends CharacterBody2D

signal player_moved

@onready var grid_mover: GridMover = $GridMover


func _ready() -> void:
	grid_mover.player_moved.connect(_on_player_moved)


func _on_player_moved() -> void:
	player_moved.emit()
