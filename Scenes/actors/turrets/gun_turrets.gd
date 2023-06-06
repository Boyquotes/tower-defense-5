extends Node2D

#base script for all gun turrets to be extended from

#base variables to be set per turret
@export var rotaion_speed = PI #radians per second, so 180 degrees
@export var fire_rate = 1.0 #shots per second
@export var damage = 10
@export var pierce = 3 #how many enemies it can hit with each shot
var _projectile_scene = preload("res://Scenes/actors/turrets/bullet_sm.tscn")

#scene tree variables, parts of the turret to be loaded by each scene based on which turret
#all turrets have a immobile base that has a area2D to serve as the range detection
#a sibling node to the base called gun is the part that rotates
#gun has multiple muzzle children from which projectiles fire from, each muzzle has a child timer
#gun node also has a raycast child

@onready var _gun_node = $gun
@onready var _range = $base/range
@onready var _ray_cast = $gun/RayCast2D
@onready var _muzzles = []
@onready var _timer = $Timer

#instance variables
var currTargets = []
var target = null
var can_fire := true
var current_muzzle = 0 #so they alternate when shooting

var shots = 0

func _ready():
	var i = 1
	while true:
		var currMuzz := get_node_or_null("gun/muzzle"+str(i))
		if currMuzz != null:
			_muzzles.append(currMuzz)
			i = i+1
		else:
			break
	#end of while loop
	_range.body_shape_entered.connect(body_enter)
	_range.body_shape_exited.connect(body_exit)
	_timer.timeout.connect(timeout)
	_timer.wait_time = 1/fire_rate
	
func _physics_process(delta):
	if target != null:
		aim(delta)
		if can_fire and _ray_cast.is_colliding():
			if current_muzzle == _muzzles.size():
				current_muzzle = 0 #resets to the first when reaching final muzzle
			shoot(_muzzles[current_muzzle])
			current_muzzle += 1
			can_fire = false
			_timer.start()

func body_enter(_body_rid, _body, _body_shape_index, _local_shape_inde):
	#get all bodies in range and add to targets array if they are enemies
	for bodies in _range.get_overlapping_bodies():
		if bodies.is_in_group("enemies"):
			if !currTargets.has(bodies):
				currTargets.append(bodies)			
			#if no current target set first body in array as target
			if target == null:
				target = currTargets[0]	

func body_exit(_body_rid, body, _body_shape_index, _local_shape_index):
	if body == target:
		target = null
	if currTargets.has(body):
		currTargets.remove_at(currTargets.find(body))

func aim(phy_delta):
	#vector from turret to ship and it's angle
	var v =target.global_position - global_position
	var angle = v.angle()
	#rotation allowed per frame
	var angle_delta = rotaion_speed * phy_delta
	#get full rotation and limit it to allowed rotation
	var r = _gun_node.get_rotation()
	angle = lerp_angle(r,angle,1.0)
	angle = clamp(angle, r - angle_delta, r + angle_delta)
	#spain without a
	_gun_node.set_rotation(angle)

func shoot(muzzle):
	shots += 1
	print("shots fired: #"+str(shots))
	var projectile = _projectile_scene.instantiate()
	projectile.transform = muzzle.global_transform	
	projectile.damage = damage
	projectile.pierce = pierce
	projectile.speed = 800
	add_child(projectile)

func timeout():
	can_fire = true
