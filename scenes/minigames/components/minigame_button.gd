extends AspectRatioContainer
class_name MiniGameButton

@onready var button: BaseButton = get_child(0)

@export var minigame_scene: PackedScene
@export var tooltip: String

func _ready() -> void:
	button.pressed.connect(_on_button_pressed)
	button.tooltip_text = tooltip


func _on_button_pressed() -> void:
	Transition.transition_to(minigame_scene)
