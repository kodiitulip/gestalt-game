extends Node2D

const MAIN_UI: PackedScene = preload("res://scenes/main_ui.tscn")

func _ready() -> void:
	Transition.transition_to(MAIN_UI, true)
