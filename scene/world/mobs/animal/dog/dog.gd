class_name Dog extends Animal

enum STATE{NORMAL, ENCOUNTER}

signal is_dog_catch_player

@export var speed 	            = 250	
@export var current_state:STATE = STATE.NORMAL
@export var encounter_target:Node2D

@onready var nav_agent = $NavigationAgent2D
@onready var refresh   = $refresh
@onready var encounter = load("res://scene/world/mobs/animal/dog/encounter/encounter.tscn").instantiate()
@onready var animation_tree = $AnimationTree 
@onready var last_direction = Vector2.ZERO
@onready var do_process = false

var target:Node2D

func _ready():
	self.get_node("Sprite2D").hide()
	animation()
	match current_state:
		STATE.ENCOUNTER:
			refresh.start()
			
func animation():
	match current_state:
		STATE.NORMAL:
			if target != null:
				var direction = to_local(nav_agent.get_next_path_position()).normalized()
				self.last_direction = direction
				animation_tree["parameters/conditions/is_run"] = true
				animation_tree["parameters/conditions/idle"]   = false
			else:
				animation_tree["parameters/conditions/is_run"] = false
				animation_tree["parameters/conditions/idle"]   = true
			animation_tree["parameters/run/blend_position"]  = self.last_direction
			animation_tree["parameters/run/blend_position"]  = self.last_direction
				
		STATE.ENCOUNTER:
			if encounter_target != null:
				var direction = to_local(nav_agent.get_next_path_position()).normalized()
				self.last_direction = direction
				animation_tree["parameters/conditions/is_run"] = true
				animation_tree["parameters/conditions/idle"]   = false
			else:
				animation_tree["parameters/conditions/is_run"] = false
				animation_tree["parameters/conditions/idle"]   = true
			animation_tree["parameters/run/blend_position"]  = self.last_direction
			animation_tree["parameters/run/blend_position"]  = self.last_direction

func _physics_process(_delta):
	if self.do_process:
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
			if(body.is_in_group("player")  && !body.is_still_fight):
				target = body
				refresh.start()
				SoundPlayer.play_sfx(SoundPlayer.SOUND.DOG)

func _on_viewing_distance_body_exited(body):
	match current_state:
		STATE.NORMAL:
			if(body.is_in_group("player")):
				target = null
				refresh.stop()
				SoundPlayer.stop_sfx(SoundPlayer.SOUND.DOG)

func _on_refresh_timeout():
	match current_state:
		STATE.NORMAL:
			if (target != null):
				make_path()
				animation()
		
		STATE.ENCOUNTER:
			if (encounter_target != null):
				make_path()
				animation()

func _on_hurtbox_body_entered(body):
	match current_state:
		STATE.NORMAL:
			if(body.is_in_group("player")  && !body.is_still_fight):
				refresh.stop()
				target = null
				
				if(encounter):
					#enter encounter space
					get_tree().get_root().add_child(encounter)
					global.set_enct_scene(encounter)
					global.get_main_scene().hide()
					self.queue_free()
		
		STATE.ENCOUNTER:
			if(body.is_in_group("player") && !body.is_still_fight):
				refresh.stop()
				encounter_target = null
				emit_signal("is_dog_catch_player")


func _on_visible_on_screen_notifier_2d_screen_entered():
	self.get_node("Sprite2D").show()
	self.do_process = true
	SoundPlayer.danger_music()


func _on_visible_on_screen_notifier_2d_screen_exited():
	self.get_node("Sprite2D").hide()
	self.do_process = false
	SoundPlayer.peace_music()
