extends Resource
class_name DialogLine

enum Faces {
	NORMAL = 0,
	HAPPY = 1,
	LOOKING_DOWN = 2,
	SQUINT = 3,
}

@export_multiline var line: String
@export var face: Faces
