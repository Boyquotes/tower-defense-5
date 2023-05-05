extends Timer

@onready var path = preload("res://Scenes/maps/map_1_path.tscn")

func _on_timeout():
	var tempPath = path.instantiate()
	get_parent().add_child(tempPath)
