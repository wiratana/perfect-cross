extends CharacterBody2D

@export var target:Marker2D

@onready var speed     = 100
@onready var nav_agent = $NavigationAgent2D

func _ready():
	make_path()
	
func _physics_process(delta):
	if target != null:
		var direction = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = direction * speed
		move_and_slide()

func make_path():
	if target != null:
		nav_agent.target_position = target.global_position
