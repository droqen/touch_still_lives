extends Node2D

func _ready():
	for unit in get_children():
		if unit.team == 0:
			unit.final_goalcell = Vector2i(13,7)
		else:
			unit.final_goalcell = (unit.position / 10) as Vector2i

func _physics_process(delta: float) -> void:
	for i in range(get_child_count()-1):
		for j in range(i+1, get_child_count()):
			if randf()<0.5:
				get_child(j).proc_proximity(get_child(i))
				get_child(i).proc_proximity(get_child(j))
			else:
				get_child(i).proc_proximity(get_child(j))
				get_child(j).proc_proximity(get_child(i))
