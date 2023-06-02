class_name Knockback extends Node2D

@onready var stunt_timer : Timer  = $StuntTimer
@onready var player		 : Node2D = self.get_parent()

@export var stunt_duration = 0.5

func _ready():
	stunt_timer.wait_time = stunt_duration

func apply(knockback_distance):
	stunt_timer.start()
	var tween = create_tween()
	tween.tween_property(
		player, 
		"position", 
		(player.position + (Input.get_vector("left", "right", "up", "down")*Vector2(-1,-1))*knockback_distance),
		0.2
	)

func is_stunt_stop():
	return stunt_timer.is_stopped()
