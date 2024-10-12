extends CanvasLayer
class_name DialogSystem

signal dialog_ended()

@onready var rich_text_label: RichTextLabel = $DialogBox/MarginContainer/RichTextLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var texture_rect: TextureRect = $TextureRect
@onready var texture_button: TextureButton = $TextureButton
@onready var timer: Timer = $Timer

@export var test: Array = []

var texture: AtlasTexture
var dialog_lines: Array[DialogLine]
static var dialog_system: DialogSystem

func _ready() -> void:
	if !dialog_system:
		dialog_system = self

	hide()
	animation_player.play("RESET")
	texture = texture_rect.texture \
		if texture_rect.texture is AtlasTexture \
		else null


func start_dialog(dialogs: Array[DialogLine], auto_skip: bool = false) -> void:
	if not dialogs:
		push_warning('No DialogLines were provided!')
		dialog_lines.clear()
		dialog_ended.emit()
		return

	if dialog_lines.size() > 0:
		await dialog_ended

	if auto_skip:
		texture_button.hide()
	else:
		texture_button.show()

	show()
	dialog_lines.clear()
	dialog_lines = dialogs.duplicate()

	await _set_current_dialog(dialog_lines[0], auto_skip)

	hide()
	dialog_lines.clear()
	animation_player.play("RESET")
	rich_text_label.text = ''
	dialog_ended.emit()


func _set_current_dialog(dialog_line: DialogLine, auto_skip: bool, i: int = 0) -> void:
	_set_facial_expression(dialog_line.face)
	_set_line_in_text_box(dialog_line.line)
	if auto_skip:
		timer.start()
		await timer.timeout
	else:
		await texture_button.pressed

	if dialog_lines.size() > i + 1:
		await _set_current_dialog(dialog_lines[i + 1], auto_skip, i + 1)
	elif dialog_lines.size() == i + 1:
		dialog_ended.emit()


func _set_line_in_text_box(line: String) -> void:
	rich_text_label.text = line
	animation_player.play("typewriter")


func _set_facial_expression(face: int) -> void:
	texture.region.position.x = texture.get_width() * face
