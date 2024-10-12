extends CanvasLayer
@onready var info_button: InfoButton = $InfoButton

static var has_spoken: bool = false

func _ready() -> void:
	await Transition.transition.scene_loaded
	if not has_spoken:
		info_button._on_pressed()
		has_spoken = true
