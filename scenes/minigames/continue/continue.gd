extends Node2D

@onready var info_button: InfoButton = $CanvasLayer/InfoButton
@onready var camera_2d: Camera2D = $Camera2D
@onready var remote_transform_2d: RemoteTransform2D = $Path2D/PathFollow2D/RemoteTransform2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var path_follow_2d: PathFollow2D = $Path2D/PathFollow2D
@onready var image_player: AnimationPlayer = $ImagePlayer
@onready var line_2d: Line2D = $Path2D/Line2D

@export var speed: int = 200
@export var end_dialog: Array[DialogLine] = []

var mouse_over: bool = false
var has_ended: bool = false
static var has_spoken: bool = false

func _ready() -> void:
	animation_player.play('blink')
	if not (Transition.transition and DialogSystem.dialog_system):
		push_warning('There is no TransitionManager or DialogSystem!')
		return
	if not has_spoken:
		await Transition.transition.scene_loaded
		info_button._on_pressed()
		has_spoken = true


func _process(delta: float) -> void:
	if has_ended:
		path_follow_2d.progress += speed * delta
		return
	if not mouse_over:
		return

	path_follow_2d.progress += speed * delta
	line_2d.add_point(path_follow_2d.position)
	if path_follow_2d.progress_ratio >= 1:
		path_follow_2d.loop = true
		_on_end()


func _on_end() -> void:
	mouse_over = false
	has_ended = true
	remote_transform_2d.remote_path = ''
	animation_player.play('camera')
	await animation_player.animation_finished
	image_player.play('fadein')
	if not DialogSystem.dialog_system:
		push_error('No DialogSystem')
		return
	DialogSystem.dialog_system.start_dialog(end_dialog)


func _on_camera_path_mouse_entered() -> void:
	if has_ended:
		return
	mouse_over = true
	if animation_player.current_animation == 'blink':
		animation_player.stop()


func _on_camera_path_mouse_exited() -> void:
	if has_ended:
		return
	mouse_over = false
	animation_player.play('blink')
