extends Button


func _ready() -> void:
	if !OS.is_debug_build():
		queue_free()
