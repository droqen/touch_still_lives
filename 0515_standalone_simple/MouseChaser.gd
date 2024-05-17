extends Node2D

onready var target : Vector2 = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if Input.is_mouse_button_pressed(1): target = get_global_mouse_position()
	position += (target - position).limit_length(1)
