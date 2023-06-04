extends Node2D

var target
var currTargets = []

@onready var _gun_node = get_node("gun")
@onready var _ray_cast = $gun/RayCast2D
@onready var _cooldown_timer = $Timer

var _projectile_scene = preload("res://Scenes/actors/turrets/bullet_sm.tscn")
var _can_fire := true

@export var rotaion_speed = PI #radians per second, so 180 degrees
@export var fire_rate = 1

func _spawn_projectile():
	var direction = Vector2.RIGHT.rotated((_gun_node.get_rotation()))
	var projectile = _projectile_scene.instantiate()
	projectile.direction = direction
	projectile.global_position = _ray_cast.global_position
	projectile.add_collision_exception_with(self)
	add_child(projectile)

func _aim(phy_delta):
	#vector from turret to ship and it's angle
	var v =target.global_position - global_position
	var angle = v.angle()
	#rotation allowed per frame
	var angle_delta = rotaion_speed * phy_delta
	#get full rotation and limit it to allowed rotation
	var r = _gun_node.get_rotation()
	angle = lerp_angle(r,angle,1.0)
	angle = clamp(angle, r - angle_delta, r + angle_delta)
	_gun_node.set_rotation(angle)

func _physics_process(delta):
	if currTargets.is_empty():
		target = null
	else:
		target = currTargets[0]
	
	if target != null:
		_aim(delta)
		
	if _can_fire and _ray_cast.is_colliding():
		#_spawn_projectile()
		print("pew pew")
		_spawn_projectile()
		_can_fire = false
		_cooldown_timer.start()

func _on_range_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	for bodies in get_node("base/range").get_overlapping_bodies():
		if bodies.is_in_group("enemies"):
			currTargets.append(bodies)

func _on_range_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if currTargets.has(body):
		currTargets.remove_at(currTargets.find(body))
		if target == body:
			if currTargets.size() > 0:
				for bodies in get_node("base/range").get_overlapping_bodies():
					if bodies.is_in_group("enemies"):
						currTargets.append(bodies)
			else:
				target = null


func _on_timer_timeout():
	_can_fire = true
