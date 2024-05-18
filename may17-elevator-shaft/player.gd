extends Node2D

var xvel : float = 0.0
var spranidelay : int = 0
var sprframe : int = 0
const WALKFRAMES : Array = [0,10,0,20]

func _physics_process(delta: float) -> void:
	if xvel:
		$Sprite2D.flip_h = xvel < 0
		if spranidelay > 0:
			spranidelay -= 1
		else:
			sprframe = (sprframe + 1) % len(WALKFRAMES)
			$Sprite2D.frame = WALKFRAMES[sprframe]
			spranidelay = 8
	else:
		if spranidelay > 0:
			spranidelay -= 2
		else:
			sprframe = 0
			$Sprite2D.frame = WALKFRAMES[sprframe]
			# spranidelay = 0
	
