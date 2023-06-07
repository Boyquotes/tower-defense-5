extends "res://Scenes/actors/turrets/bullets.gd"
#missiles are just bullets that explode :thonk:

var guided = false
var chase_target

func _physics_process(delta):
	if not guided:
		super(delta)
	else:
		chase_target = get_parent().target
		if chase_target != null:
			direction = global_position.direction_to(chase_target.global_position)
			look_at(chase_target.global_position)
			var v = direction * speed * delta
			var c := move_and_collide(v)
			if c and c.get_collider():
				var collider = c.get_collider()
				hit(collider)

func hit(target):
	for hits in $explosion_range.get_overlapping_bodies():
		if hits.is_in_group("enemies"):
			hits.take_damage(damage)
	queue_free()
