extends Position2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var target_pos : Vector2
var blinker : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().connect("cursor_moved", self, "_on_cursor_moved")

func _on_cursor_moved(newpos):
	target_pos.x = round(newpos.x/10.0)*10.0
	target_pos.y = round(newpos.y/10.0)*10.0

func _physics_process(_delta):
	if position != target_pos:
		blinker = 0
		position.x = move_toward(position.x, target_pos.x, 2)
		position.y = move_toward(position.y, target_pos.y, 2)
	else:
		blinker = (blinker + 1) % 40
	for child in get_children:
		child.get_node("Sprite")
