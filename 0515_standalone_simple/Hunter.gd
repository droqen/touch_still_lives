extends Node2D

onready var my_target = $"../MouseChaser"

var aware : bool = false
var faceright : bool = false

func _physics_process(_delta):
	var to_target = my_target.position - position
	if my_target.visible and faceright == (to_target.x > 0):
		position += to_target.limit_length(0.5)
		aware = true
	else:
		var to_middle = Vector2(50,50)-position
		if to_middle.x != 0:
			faceright = (to_middle.x > 0)
		position += to_middle.limit_length(0.25)
		aware = false
	$SheetSprite.flip_h = faceright
