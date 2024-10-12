extends Node2D

@onready var animation_player: AnimationPlayer = $Anim/AnimationPlayer
@onready var info_button: InfoButton = $CanvasLayer/InfoButton
@onready var area_2d: Area2D = $Anim/Area2D

@export var first_dialog: Array[DialogLine] = []
@export var second_dialog: Array[DialogLine] = []
@export var third_dialog: Array[DialogLine] = []
@export var last_dialog: Array[DialogLine] = []
@onready var debug_timer: Timer = $DebugTimer

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


func start_first_dialog() -> void:
	if not DialogSystem.dialog_system:
		push_error('There is no DialogSystem!')
		debug_timer.start()
		await debug_timer.timeout
		animation_player.play('first')
		return

	DialogSystem.dialog_system.start_dialog(first_dialog)
	await DialogSystem.dialog_system.dialog_ended
	animation_player.play('blink')
	await area_2d.mouse_entered
	animation_player.play('first')


func start_second_dialog() -> void:
	if not DialogSystem.dialog_system:
		push_error('There is no DialogSystem!')
		debug_timer.start()
		await debug_timer.timeout
		animation_player.play('second')
		return

	DialogSystem.dialog_system.start_dialog(second_dialog)
	await DialogSystem.dialog_system.dialog_ended
	animation_player.play('blink')
	await area_2d.mouse_entered
	animation_player.play('second')


func start_third_dialog() -> void:
	if not DialogSystem.dialog_system:
		push_error('There is no DialogSystem!')
		debug_timer.start()
		await debug_timer.timeout
		animation_player.play('third')
		return

	DialogSystem.dialog_system.start_dialog(third_dialog)
	await DialogSystem.dialog_system.dialog_ended
	animation_player.play('blink')
	await area_2d.mouse_entered
	animation_player.play('third')


func start_last_dialog() -> void:
	if not DialogSystem.dialog_system:
		push_error('There is no DialogSystem!')
		debug_timer.start()
		await debug_timer.timeout
		animation_player.play('end')
		await animation_player.animation_finished
		running = false
		animation_player.play('blink')
		return

	DialogSystem.dialog_system.start_dialog(last_dialog)
	await DialogSystem.dialog_system.dialog_ended
	animation_player.play('blink')
	await area_2d.mouse_entered
	animation_player.play('end')
	await animation_player.animation_finished
	running = false
	animation_player.play('blink')


func _on_area_2d_mouse_entered() -> void:
	if not running:
		animation_player.play('start')
		running = true
