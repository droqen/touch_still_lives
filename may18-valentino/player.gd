extends CharacterBody2D

var stepbuf : int = 0
var animbuf : int = 0
var animi : int = 0

var fight_target : Node2D = null

func _physics_process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		$MazeGuide.goal = get_global_mouse_position()
		$fight_target_finder.global_position = get_global_mouse_position()
		fight_target = null
		for body in $fight_target_finder.get_overlapping_bodies():
			fight_target = body
	if fight_target:
		$MazeGuide.goal = fight_target.position
		
	if stepbuf > 0:
		stepbuf -= 1
	elif fight_target and fight_target.position.distance_to(position) < 8:
		stepbuf = 20
		# attack!
		if fight_target.position.x - position.x:
			$spr.flip_h = fight_target.position.x - position.x < 0
		$spr.frame = 32
		fight_target.queue_free() # deleted
		$MazeGuide.clear()
	else:
		stepbuf = 1
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
			$spr.frame = [30,31,30,31][animi]
