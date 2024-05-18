extends CharacterBody2D

@export var target : Node2D

var stepbuf : int = 0
var animbuf : int = 0
var animi : int = 0

func _physics_process(delta: float) -> void:
	if target.position.distance_to(position) < 40:
		$MazeGuide.goal = target.position
	elif target.position.distance_to(position) > 50:
		$MazeGuide.clear()
	if stepbuf > 0:
		stepbuf -= 1
	elif target.position.distance_to(position) < 9:
		stepbuf = 20 # attack.
		if target.position.x - position.x: $spr.flip_h = target.position.x - position.x < 0
		$spr.frame = 42
	else:
		stepbuf = 2 # chase.
		var tonext = $MazeGuide.tonext
		var v : Vector2 = tonext.limit_length(1.0)
		#var v : Vector2 = Vector2(
			#clampf(tonext.x, -1, 1),
			#clampf(tonext.y, -1, 1),
		#)
		if v.x: $spr.flip_h = v.x < 0
		move_and_collide(Vector2(v.x, 0))
		move_and_collide(Vector2(0, v.y))
		if animbuf > 0:
			animbuf -= 1
		else:
			if v:
				animi = (animi+1)%4
				animbuf = 3
			else:
				animi = 0
			$spr.frame = [40,41,40,41][animi]
