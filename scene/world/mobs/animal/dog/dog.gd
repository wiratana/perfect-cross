class_name Dog extends Animal

enum STATE{NORMAL, ENCOUNTER}

signal is_dog_catch_player

@export var speed 	            = 250	
@export var current_state:STATE = STATE.NORMAL
@export var encounter_target:Node2D

@onready var nav_agent = $NavigationAgent2D
@onready var refresh   = $refresh
 
var target:Node2D

func _ready():
	match current_state:
		STATE.ENCOUNTER:
			refresh.start()

func _physics_process(delta):
	match current_state:
		STATE.NORMAL:
			if target != null:
				var direction = to_local(nav_agent.get_next_path_position()).normalized()
				velocity = direction * speed
				move_and_slide()
				
		STATE.ENCOUNTER:
			if encounter_target != null:
				var direction = to_local(nav_agent.get_next_path_position()).normalized()
				velocity = direction * speed
				move_and_slide()

func make_path():
	match current_state:
		STATE.NORMAL:
			if target != null:
				nav_agent.target_position = target.global_position

		STATE.ENCOUNTER:
			if encounter_target != null:
				nav_agent.target_position = encounter_target.global_position

func _on_viewing_distance_body_entered(body):
	match current_state:
		STATE.NORMAL:
			if(body.is_in_group("player")):
				target = body
				refresh.start()

func _on_viewing_distance_body_exited(body):
	match current_state:
		STATE.NORMAL:
			if(body.is_in_group("player")):
				target = null
				refresh.stop()

func _on_refresh_timeout():
	match current_state:
		STATE.NORMAL:
			if (target != null):
				make_path()
		
		STATE.ENCOUNTER:
			if (encounter_target != null):
				make_path()


func _on_hurtbox_body_entered(body):
	match current_state:
		STATE.NORMAL:
			if(body.is_in_group("player")):
				refresh.stop()
				target = null
		
		STATE.ENCOUNTER:
			if(body.is_in_group("player")):
				refresh.stop()
				encounter_target = null
				emit_signal("is_dog_catch_player")
