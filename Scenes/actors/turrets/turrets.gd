extends Node2D

func _physics_process(delta):
	turn()
	pass

func turn():
	var enemyPos = get_global_mouse_position()
	get_node("gun").look_at(enemyPos)
	pass
