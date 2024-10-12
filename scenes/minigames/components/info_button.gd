extends AspectRatioContainer
class_name InfoButton
@export var dialog: Array[DialogLine] = []

var dialog_manager: DialogSystem

func _ready() -> void:
	dialog_manager = DialogSystem.dialog_system


func _on_pressed() -> void:
	if not dialog_manager:
		push_error('There is no DialogSystem!')
		return
	dialog_manager.start_dialog(dialog)
