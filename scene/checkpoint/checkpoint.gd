class_name Checkpoint extends Node2D

signal get_finish

@onready var animation_player = $AnimationPlayer
@onready var start_point	  = $start_point
@onready var end_point		  = $end_point

# Called when the node enters the scene tree for the first time.
func _ready():
		animation_player.play("aura_idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_start_point_area_body_exited(body):
	if body.is_in_group("player"):
		start_point.queue_free()
		


func _on_end_point_area_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("get_finish")
