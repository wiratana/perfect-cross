class_name Criminal extends Mob

signal is_criminal_catch_player
signal is_maximum_number_of_arrests

enum STATE{NORMAL, ENCOUNTER}

@export var dash_speed			  = 500
@export var walk_speed			  = 220
@export var refresh_time		  = 0.5
@export var encounter_state:STATE = STATE.NORMAL
@export var encounter_target:Node2D
@export var num_of_arrests:int    = 3

@onready var hold:Timer	   = $hold
@onready var refresh:Timer = $refresh
@onready var progress_bar  = $ProgressBar
@onready var nav_agent	   = $NavigationAgent2D

var is_time_to_rush = false
var target:Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	hold.wait_time 		   = progress_bar.value
	refresh.wait_time	   = refresh_time
	progress_bar.max_value = hold.wait_time
	progress_bar.value     = 0
	
	match encounter_state:
		STATE.NORMAL:
			print("normal start")
			
		STATE.ENCOUNTER:
			print("encounter start")
			refresh.start()
			hold.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !hold.is_stopped():	
		progress_bar.value = hold.wait_time - hold.time_left
		
	if num_of_arrests == 0:
		emit_signal("is_maximum_number_of_arrests")
		
	match encounter_state:
		STATE.NORMAL:
			if target != null && is_time_to_rush:
				var direction = to_local(nav_agent.get_next_path_position()).normalized()
				velocity = direction * dash_speed
				move_and_slide()
				
		STATE.ENCOUNTER:
			if encounter_target != null:
				var direction = to_local(nav_agent.get_next_path_position()).normalized()
				velocity = direction * (dash_speed if is_time_to_rush else walk_speed)
				move_and_slide()

func make_path():
	var current_target
	
	match encounter_state:
		STATE.NORMAL:
			current_target = self.target
			
		STATE.ENCOUNTER:
			current_target = self.encounter_target
				
	if current_target != null:
		nav_agent.target_position = current_target.global_position	

func _on_viewing_distance_body_entered(body):
	match encounter_state:
		STATE.NORMAL:
			if(body.is_in_group("player")):
				target = body
				hold.start()
				
		STATE.ENCOUNTER:
			pass

func _on_viewing_distance_body_exited(body):
	match encounter_state:
		STATE.NORMAL:
			if(body.is_in_group("player")):
				target = null
				progress_bar.value = 0
				hold.stop()
				
		STATE.ENCOUNTER:
			pass

func _on_hold_timeout():
	match encounter_state:
		STATE.NORMAL,STATE.ENCOUNTER:
			progress_bar.value = 0
			is_time_to_rush = true
			make_path()
			hold.start()

func _on_hurtbox_body_entered(body):
	if (body.is_in_group("player")):
		is_time_to_rush = false
		hold.stop()
		emit_signal("is_criminal_catch_player")
		
		match encounter_state:
			STATE.NORMAL:
				target = null
				progress_bar.value = 0
				
			STATE.ENCOUNTER:
				num_of_arrests -= 1

func _on_navigation_agent_2d_navigation_finished():
	is_time_to_rush = false
	
	match encounter_state:
		STATE.NORMAL:
			if target != null && hold.is_stopped():
				hold.start()
				
		STATE.ENCOUNTER:
			if encounter_target != null && hold.is_stopped():
				hold.start()

func _on_refresh_timeout():
	match encounter_state:
		STATE.ENCOUNTER:
			if !is_time_to_rush:
				make_path()
