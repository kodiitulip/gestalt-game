extends PathFollow2D
class_name DrawLinePath

signal path_ended()

@onready var line: Line2D = Line2D.new()

@export var is_on: bool = false
@export var foward: bool = true
@export var speed: float = 200
@export var color: Color

func _ready() -> void:
	add_sibling.call_deferred(line)
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	line.default_color = color
	line.width = 4
	line.antialiased = true
	loop = false


func _process(delta: float) -> void:
	if not is_on:
		return

	if foward:
		progress += speed * delta
		line.add_point(position)
	else:
		progress -= speed * delta
		var p: int = line.get_point_count() - 1
		if p > -1:
			line.remove_point(line.get_point_count() - 1)
	if progress_ratio >= 1 or progress_ratio <= 0:
		is_on = false
		path_ended.emit()
