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
	_timer.wait_time = 1/fire_rate

func _physics_process(delta):	
	if target != null:
		aim(delta)

func body_enter(body_rid, body, body_shape_index, local_shape_inde):
	#get all bodies in range and add to targets array if they are enemies
	for bodies in get_node("base/range").get_overlapping_bodies():
		if bodies.is_in_group("enemies"):
			if !currTargets.has(bodies):
				currTargets.append(bodies)			
			#if no current target set first body in array as target
			if target == null:
				target = currTargets[0]	

func body_exit(body_rid, body, body_shape_index, local_shape_index):
	if body == target:
		if currTargets.has(body):
			currTargets.remove_at(currTargets.find(body))
			target = null

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
	_gun_node.set_rotation(angle)

func shoot():
	var projectile = _projectile_scene.instantiate()
	projectile.add_collision_exception_with(self)
	projectile.damage = damage
	#projectile.transform = muzzle.global_transform
	add_child(projectile)
	
func on_timer_timeout():
	can_fire = true
