tool
extends Container
class_name FiniteViewContainer

func _get_configuration_warning():
	if has_node("ViewportContainer/Viewport/ArcadeScreen"):
		return "" # great!
	else:
		return "Missing proper child ViewportContainer/Viewport/ArcadeScreen."

func _notification(what):
	match what:
		NOTIFICATION_SORT_CHILDREN:
			if has_node("ViewportContainer/Viewport/ArcadeScreen"):
				var vpc = $ViewportContainer
				var vport = $ViewportContainer/Viewport
				var arcade = $ViewportContainer/Viewport/ArcadeScreen
				vport.size = arcade.size
				if vport.size.x > 0 and vport.size.y > 0:
					var pixel_scale : int = int(max(1,min(
						floor(rect_size.x / vport.size.x),
						floor(rect_size.y / vport.size.y)
					)))
					vpc.rect_size = vport.size * pixel_scale
					vpc.rect_position = (rect_size - vpc.rect_size) / 2
					vpc.stretch = true
					vpc.stretch_shrink = pixel_scale

func calc_arcade_mouse_pos() -> Vector2:
	if has_node("ViewportContainer"):
		var mpos = $ViewportContainer.get_local_mouse_position() / $ViewportContainer.stretch_shrink
		return mpos
	else:
		push_error("No ViewportContainer, can't calc_arcade_mouse_pos")
		return Vector2(0, 0)

func _input(event):
	if has_node("ViewportContainer/Viewport/ArcadeScreen"):
		var arcade : ArcadeScreen = $ViewportContainer/Viewport/ArcadeScreen
		if event is InputEventMouseMotion or event is InputEventScreenDrag:
			arcade.emit_signal("cursor_moved", calc_arcade_mouse_pos())
		if event is InputEventMouseButton or event is InputEventScreenTouch:
			arcade.emit_signal(
				"cursor_pressed" if event.pressed else "cursor_released",
				calc_arcade_mouse_pos())
			
