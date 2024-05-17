extends Node
var chop : int = 0
func _physics_process(delta: float) -> void:
	if chop > 0:
		chop -= 1
	else:
		var noise = get_parent().texture as NoiseTexture2D
		noise.noise.offset.x = randi_range(-10,10)*200
		noise.noise.offset.y = randi_range(-10,10)*200
		noise.noise.frequency = randf_range(0.1,0.2)
		chop = 13
