extends Node2D

var target
var currTargets = []

func _physics_process(delta):
	pass



func _on_range_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print(get_node("base/range").get_overlapping_bodies())
	for bodies in get_node("base/range").get_overlapping_bodies():
		print(bodies[1])
		#if bodies.is_in_group("enemies"):
		#	print(bodies)



func _on_range_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	pass
