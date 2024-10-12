extends AspectRatioContainer
class_name MainMenuButton

var MAIN_UI: PackedScene = load("res://scenes/main_ui.tscn")

func _on_button_pressed() -> void:
	if not Transition.transition:
		push_error('There is no TransitionManager!')
		return
	Transition.transition_to(MAIN_UI)
