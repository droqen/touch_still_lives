extends Node2D

@onready var target : Vector2 = position

var animi : int = 0
var animt : int = 0
var locked_until_release : bool = false

func _physics_process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if not locked_until_release:
			target = get_global_mouse_position()
	else:
		locked_until_release = false
	var totarget = target - position
	
	position += totarget.limit_length()
	
	if position.x < -3:
		position.x += 185
		target.x += 180
		locked_until_release = true
	if position.y < -3:
		position.y += 205
		target.y += 200
		locked_until_release = true
	if position.x >= 183:
		position.x -= 185
		target.x -= 180
		locked_until_release = true
	if position.y >= 203:
		position.y -= 205
		target.y -= 200
		locked_until_release = true
	
	if animt > 0:
		animt -= 1
	else:
		if totarget:
			animt = 13
			animi = (animi + 1) % 4
			$Sprite2D.frame = [0,1,0,2][animi]
		else:
			animi = 0
			$Sprite2D.frame = 0
