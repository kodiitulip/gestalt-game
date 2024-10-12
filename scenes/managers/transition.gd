extends CanvasLayer
class_name Transition

signal scene_loaded()

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var scene_container: Node

static var transition: Transition

func _ready() -> void:
	if !transition:
		transition = self


static func transition_to(scene: PackedScene, skip_trans_in: bool = false) -> void:
	if not skip_trans_in:
		transition.animation_player.play("transition_in")
		await transition.animation_player.animation_finished
	transition._request_load(scene)


func _request_load(scene: PackedScene) -> void:
	if not scene:
		push_warning('There is no scene to load!')
		_on_scene_ready()
		return

	if scene_container.get_child_count() > 0:
		scene_container.get_child(0).queue_free()

	if !scene.can_instantiate():
		push_error('Scene could not be loaded')
		return

	var new_loaded_scene: Node = scene.instantiate()
	new_loaded_scene.ready.connect(_on_scene_ready)
	scene_container.add_child(new_loaded_scene)


func _on_scene_ready() -> void:
	animation_player.play("transition_out")
	await animation_player.animation_finished
	scene_loaded.emit()
