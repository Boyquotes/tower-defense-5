extends Node2D

var target
var currTargets = []

func _physics_process(delta):
	pass


func _on_range_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	for bodies in get_node("base/range").get_overlapping_bodies():
		if bodies.is_in_group("enemies"):
			currTargets.append(bodies)
			if target == null:
				target = currTargets[0]
				print(target)

func _on_range_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if currTargets.has(body):
		currTargets.erase(body)
		if currTargets != []:
			target = currTargets[0]
			print(target)
		else:
			target = null
	pass
