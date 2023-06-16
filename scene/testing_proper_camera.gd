extends Node2D

@onready var player = $Player
@onready var cam_pos = $Marker2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	cam_pos.position = Vector2(lerp(cam_pos.position.x, player.position.x, 8*delta), lerp(cam_pos.position.y, player.position.y, 8*delta))



