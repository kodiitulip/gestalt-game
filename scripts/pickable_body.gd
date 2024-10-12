extends CharacterBody2D
class_name PickableBody2D

@export var has_gravity: bool = true

var _is_mouse_hover: bool = false
var picked_up: bool = false: set = _set_picked_up

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	input_pickable = true


func _set_picked_up(value: bool) -> void:
	picked_up = value


func _unhandled_input(event: InputEvent) -> void:
	if not _is_mouse_hover:
		return
	if event.is_action_pressed("pick_item_up") and not picked_up:
		picked_up = true
	elif event.is_action_pressed("pick_item_up") and picked_up:
		picked_up = false
	get_viewport().set_input_as_handled()


func _process(delta: float) -> void:
	if has_gravity and not is_on_floor() and not picked_up:
		velocity += get_gravity() * delta
	
	if picked_up:
		global_position = get_global_mouse_position()
	else:
		move_and_slide()


func _on_mouse_entered() -> void:
	_is_mouse_hover = true


func _on_mouse_exited() -> void:
	_is_mouse_hover = false
