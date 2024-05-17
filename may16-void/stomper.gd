extends Node2D

@onready var target : Vector2 = position

var animi : int = 0
var animt : int = 0

func _physics_process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		target = get_global_mouse_position()
	var totarget = target - position
	
	if target.x < 0 or target.x >= 200:
		totarget.x = posmod(totarget.x+100, 200)-100
	if target.y < 0 or target.y >= 200:
		totarget.y = posmod(totarget.y+100, 200)-100
	
	position += totarget.limit_length()
	
	if position.x < -4:
		position.x += 208
		target.x += 208
	if position.y < -4:
		position.y += 208
		target.y += 208
	if position.x > 204:
		position.x -= 208
		target.x -= 208
	if position.y > 204:
		position.y -= 208
		target.y -= 208
	
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
