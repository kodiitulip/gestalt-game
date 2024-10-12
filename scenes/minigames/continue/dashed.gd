@tool
extends MultiMeshInstance2D
class_name DashedMeshInstance

@onready var dashed: MeshInstance2D = get_child(0)
@onready var path: Path2D = get_parent()

@export var distance: float = 32:
	set = set_dash_distance

func _ready() -> void:
	_update_dashes()


func _update_dashes() -> void:
	if not dashed:
		return
	
	var dash: MultiMesh = multimesh
	dash.mesh = dashed.mesh
	
	var curvelength: float = path.curve.get_baked_length()
	var count: int = round(curvelength / distance)
	dash.instance_count = count
	
	for i: int in range(count):
		var t: Transform2D = Transform2D()
		var pos: Vector2 = path.curve.sample_baked(
			(i * distance) + distance / 2.0)
		var next_pos: Vector2 = path.curve.sample_baked(
			(i + 1) * distance)
		t = t.rotated((next_pos - pos).normalized().angle())
		t.origin = pos
		dash.set_instance_transform_2d(i, t)


func set_dash_distance(new_dist: float) -> void:
	distance = new_dist
	_update_dashes()
