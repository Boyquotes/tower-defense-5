extends Node2D

#base script for all gun turrets to be extended from

#base variables to be set per turret
@export var rotaion_speed = PI #radians per second, so 180 degrees
@export var fire_rate = 1.0 #shots per second
@export var damage = 10
@export var pierce = 3 #how many enemies it can hit with each shot

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

func initialize(): #why wont _ready function run from outside >:(
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

func test():
	for muzzle in _muzzles:
		print("pew pew "+str(muzzle))

func body_enter(body_rid, body, body_shape_index, local_shape_inde):
	print("hello " + str(body))

func body_exit(body_rid, body, body_shape_index, local_shape_index):
	print("bye " + str(body))
