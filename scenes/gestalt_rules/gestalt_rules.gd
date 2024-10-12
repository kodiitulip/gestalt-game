extends Node2D
@onready var info_button: InfoButton = $CanvasLayer/InfoButton
@onready var camera_2d: Camera2D = $Camera2D

static var has_spoken: bool = false

var destination: Vector2 = Vector2(1280, 720):
	set(value):
		value.x = clampf(value.x, 0, 2560)
		value.y = clampf(value.y, 0, 1440)
		destination = value

func _ready() -> void:
	set_process(false)
	if not (Transition.transition and DialogSystem.dialog_system):
		push_warning('There is no TransitionManager or DialogSystem!')
		set_process(true)
		return
	await Transition.transition.scene_loaded
	if not has_spoken:
		info_button._on_pressed()
		has_spoken = true
		await DialogSystem.dialog_system.dialog_ended
	set_process(true)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"pick_item_up"):
		destination = get_global_mouse_position()


func _process(delta: float) -> void:
	var distance: float = camera_2d.global_position.distance_to(destination)
	camera_2d.global_position = lerp(
		camera_2d.global_position,
		destination,
		2.5 * delta
	) if distance > 0.1 else destination
