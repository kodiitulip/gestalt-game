extends Node2D

@onready var info_button: InfoButton = $CanvasLayer/InfoButton
@onready var heart_line: DrawLinePath = $Anim/Heart/DrawLinePath
@onready var animation_player: AnimationPlayer = $Anim/AnimationPlayer
@onready var area_2d: Area2D = $Anim/Area2D

@export var start_dialog: Array[DialogLine] = []
@export var first_dialog: Array[DialogLine] = []
@export var end_dialog: Array[DialogLine] = []

static var has_spoken: bool = false
var running: bool = false

func _ready() -> void:
	if not (Transition.transition and DialogSystem.dialog_system):
		push_warning('There is no TransitionManager or DialogSystem!')
		area_2d.mouse_entered.connect(_on_area_2d_mouse_entered)
		return
	if not has_spoken:
		await Transition.transition.scene_loaded
		info_button._on_pressed()
		has_spoken = true
		await DialogSystem.dialog_system.dialog_ended
		area_2d.mouse_entered.connect(_on_area_2d_mouse_entered)


func _start_dialog() -> void:
	heart_line.path_ended.disconnect(_start_dialog)
	if DialogSystem.dialog_system:
		DialogSystem.dialog_system.start_dialog(start_dialog)
		await DialogSystem.dialog_system.dialog_ended
	else:
		push_error('There is no DialogSystem!')

	animation_player.play('heart-to-shapes')


func _first_dialog() -> void:
	if DialogSystem.dialog_system:
		DialogSystem.dialog_system.start_dialog(first_dialog)
		await DialogSystem.dialog_system.dialog_ended
	else:
		push_error('There is no DialogSystem!')

	animation_player.play('move-shapes')


func end() -> void:
	if DialogSystem.dialog_system:
		DialogSystem.dialog_system.start_dialog(end_dialog)
		await DialogSystem.dialog_system.dialog_ended
	else:
		push_error('There is no DialogSystem!')

	animation_player.play('black-again')


func _reset() -> void:
	running = false
	animation_player.play('blink')


func _on_area_2d_mouse_entered() -> void:
	if not running:
		running = true
		heart_line.is_on = true
		heart_line.path_ended.connect(_start_dialog)
		animation_player.play('reset-blink')
