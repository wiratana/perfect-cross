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
@onready var encounter     = load("res://scene/world/mobs/criminal/encounter/encounter.tscn").instantiate()
@onready var animation_tree = $AnimationTree
@onready var last_direction = Vector2.ZERO
@onready var do_process     = false

var is_time_to_rush = false
var target:Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_node("ProgressBar").hide()
	self.get_node("Sprite2D").hide()
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
			
func animation():
	match encounter_state:
		STATE.NORMAL:
			if target != null && is_time_to_rush:
				animation_tree["parameters/conditions/is_dash"] = true
				animation_tree["parameters/conditions/idle"]   = false
				print("executed")
			else:
				animation_tree["parameters/conditions/is_dash"] = false
				animation_tree["parameters/conditions/idle"]   = true
				print("executed 2")
			animation_tree["parameters/dash/blend_position"]  = self.last_direction
			animation_tree["parameters/idle/blend_position"]  = self.last_direction
				
		STATE.ENCOUNTER:
			if encounter_target != null:
				animation_tree["parameters/conditions/is_dash"] = true
				animation_tree["parameters/conditions/idle"]   = false
				print("executed 3")
			else:
				animation_tree["parameters/conditions/is_dash"] = false
				animation_tree["parameters/conditions/idle"]   = true
				print("executed 4")
			animation_tree["parameters/dash/blend_position"]  = self.last_direction
			animation_tree["parameters/idle/blend_position"]  = self.last_direction				

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if self.do_process:
		if !hold.is_stopped():	
			progress_bar.value = hold.wait_time - hold.time_left
			
		if num_of_arrests == 0:
			emit_signal("is_maximum_number_of_arrests")
		
		last_direction = to_local(nav_agent.get_next_path_position()).normalized()
		match encounter_state:
			STATE.NORMAL:
				if target != null && is_time_to_rush:
					velocity = last_direction * dash_speed
					move_and_slide()
					
			STATE.ENCOUNTER:
				if encounter_target != null:
					velocity = last_direction * (dash_speed if is_time_to_rush else walk_speed)
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
			if(body.is_in_group("player") && !body.is_still_fight):
				target = body
				hold.start()
				SoundPlayer.play_sfx(SoundPlayer.SOUND.CRIMINAL)
				
		STATE.ENCOUNTER:
			SoundPlayer.play_sfx(SoundPlayer.SOUND.CRIMINAL)
			pass

func _on_viewing_distance_body_exited(body):
	match encounter_state:
		STATE.NORMAL:
			if(body.is_in_group("player")):
				target = null
				is_time_to_rush = false
				progress_bar.value = 0
				hold.stop()
				SoundPlayer.stop_sfx(SoundPlayer.SOUND.CRIMINAL)
				animation()
				
		STATE.ENCOUNTER:
			pass

func _on_hold_timeout():
	match encounter_state:
		STATE.NORMAL,STATE.ENCOUNTER:
			progress_bar.value = 0
			is_time_to_rush = true
			make_path()
			animation()
			hold.start()

func _on_hurtbox_body_entered(body):
	if (body.is_in_group("player") && !body.is_still_fight):
		is_time_to_rush = false
		hold.stop()
		emit_signal("is_criminal_catch_player")
		
		match encounter_state:
			STATE.NORMAL:
				target = null
				progress_bar.value = 0
				
			STATE.ENCOUNTER:
				num_of_arrests -= 1
				
		if self.encounter_state == STATE.NORMAL:
			var root = get_tree().get_root()
			root .add_child(encounter)
			global.set_enct_scene(encounter)
			global.get_main_scene().hide()
			self.queue_free()

func _on_navigation_agent_2d_navigation_finished():
	is_time_to_rush = false
	print("haiya")
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
				animation()


func _on_visible_on_screen_notifier_2d_screen_entered():
	self.get_node("ProgressBar").show()
	self.get_node("Sprite2D").show()
	self.do_process = true
	SoundPlayer.danger_music()


func _on_visible_on_screen_notifier_2d_screen_exited():
	self.get_node("ProgressBar").hide()
	self.get_node("Sprite2D").hide()
	self.do_process = false
	SoundPlayer.peace_music()
	



func _on_navigation_agent_2d_link_reached(details):
	print("criminal : link reached")


func _on_navigation_agent_2d_waypoint_reached(details):
	animation_tree["parameters/conditions/is_dash"] = false
	animation_tree["parameters/conditions/idle"]    = true
	print("criminal : waypoint reached")
