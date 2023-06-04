extends CharacterBody2D

@export var direction := Vector2.RIGHT
@export var damage = 10
var speed := 500

func _ready():
	set_as_top_level(true)
	direction = direction.normalized()
	look_at(direction + global_position)
	
func _physics_process(delta):
	var v = direction * speed * delta
	var c := move_and_collide(v)
	if c and c.get_collider():
		var collider = c.get_collider()
		if collider.is_in_group("enemies"):
			collider._damage(damage)
			queue_free()
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
