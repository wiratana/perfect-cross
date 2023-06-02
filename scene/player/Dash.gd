class_name Dash extends Node2D

@onready var dash_timer : Timer = $DashTimer
@onready var dash_delay : Timer = $DashDelay

@export var dash_duration = 0.3
@export var dash_cooldown = 0.3

func _ready():
	dash_timer.wait_time = dash_duration

func start_dash():
	dash_timer.start()
	
func is_dashing_stop():
	return dash_timer.is_stopped()

func is_delay_stop():
	return dash_delay.is_stopped()
	
func _on_dash_timer_timeout():
	dash_delay.wait_time = dash_cooldown
	dash_delay.start()
