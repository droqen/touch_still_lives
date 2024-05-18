extends Node2D

func _physics_process(delta: float) -> void:
	for i in range(get_child_count() - 1):
		for j in range(i, get_child_count()):
			var a : Node2D = get_child(i)
			var b : Node2D = get_child(j)
			var dist : float = a.position.distance_to(b.position)
			if dist < 6:
				var repel_force = (6+1) / (dist+1)
				var a2b = b.position - a.position
				a.position -= a2b.limit_length(1)
				b.position += a2b.limit_length(1)
	
