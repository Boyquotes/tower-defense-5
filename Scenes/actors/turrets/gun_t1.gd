extends Node2D

var target = null
var currTargets = []

@onready var _gun_node = get_node("gun")
@onready var _muzzle = $gun/muzzle
@onready var _ray_cast = $gun/RayCast2D
@onready var _cooldown_timer = $Timer

var _projectile_scene = preload("res://Scenes/actors/turrets/bullet_sm.tscn")
var _can_fire := true

@export var rotaion_speed = PI #radians per second, so 180 degrees
@export var fire_rate = 1.0 #shots per second
@export var damage = 10

func _ready():
	_cooldown_timer.wait_time = 1/fire_rate

func _spawn_projectile():
	var projectile = _projectile_scene.instantiate()
	projectile.add_collision_exception_with(self)
	projectile.damage = damage
	projectile.transform = _muzzle.global_transform
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
	if target != null:
		_aim(delta)
		
	if _can_fire and _ray_cast.is_colliding():
		_spawn_projectile()
		_can_fire = false
		_cooldown_timer.start()

func _on_range_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	#get all bodies in range and add to targets array if they are enemies
	for bodies in get_node("base/range").get_overlapping_bodies():
		if bodies.is_in_group("enemies"):
			if !currTargets.has(bodies):
				currTargets.append(bodies)
			
			#if no current target set first body in array as target
			if target == null:
				target = currTargets[0]

func _on_range_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body == target:
		if currTargets.has(body):
			currTargets.remove_at(currTargets.find(body))
			target = null


func _on_timer_timeout():
	_can_fire = true
