extends Node
@export var noise : FastNoiseLite
var chop : int = 0
func _physics_process(delta: float) -> void:
	if chop > 0:
		chop -= 1
	else:
		noise.offset.x = randi_range(-10,10)*200
		noise.offset.y = randi_range(-10,10)*200
		noise.frequency = randf_range(0.1,0.2)
		chop = 13
