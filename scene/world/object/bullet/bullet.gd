class_name Bullet extends Node2D

@export var speed = 100
@onready var kill_timer:Timer = $KillTimer
@onready var kill_timer_wait_time = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	kill_timer.wait_time = kill_timer_wait_time
	kill_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.x * delta * speed
	


func _on_kill_timer_timeout():
	queue_free()
