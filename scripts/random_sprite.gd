extends Sprite2D
class_name RandomSprite2D

@export var random_rotation: bool = false

func _ready() -> void:
	region_enabled = true
	_set_random_sprite()


func _set_random_sprite() -> void:
	var frames: int = roundi(texture.get_size().x / region_rect.size.x)
	region_rect.position.x = randi_range(0, frames - 1) * region_rect.size.x
	if random_rotation:
		rotation_degrees = randf_range(0, 360)
