extends CharacterBody2D
class_name Player

signal in_danger_area
signal game_over
signal shot
signal get_finish

enum STATE{IDLE, WALK, DASH, HIT}
enum CONDITION{NORMAL, ENCOUNTER}

@export var move_speed = 150
@export var dash_speed = 500
@export var max_health  = 5
@export var max_pinalty = 3
@export var current_condition = CONDITION.NORMAL
@export var map:TileMap
@export var imune_duration = 4

@onready var dash = $Dash
@onready var knockback = $Knockback
@onready var health_status:Label  = $labels/health_status
@onready var pinalty_status:Label = $labels/pinalty_status
@onready var imune:Timer = $imune
@onready var dashing : bool
@onready var current_state = STATE.IDLE
@onready var is_in_danger_area = false
@onready var disable_movement = false
@onready var health  = -1
@onready var pinalty = 0

@onready var direction_arrow = $direction_arrow
@export  var direction_arrow_target:Node
@export  var direction_arrow_radius		= 40

@onready var is_get_finish  = false
@onready var is_still_fight = false
@onready var animation_tree = $AnimationTree

func _ready():
	imune.wait_time = imune_duration
	self.health		= self.max_health
	direction_arrow.get_node("Sprite2D").position.x = self.get_node("Sprite2D").texture.get_size().y
			
func animation():
	match current_state:
		STATE.IDLE:
			animation_tree["parameters/conditions/idle"] = true
			animation_tree["parameters/conditions/is_walk"] = false
			animation_tree["parameters/conditions/is_dash"] = false
			animation_tree["parameters/conditions/is_knock"] = false
		STATE.HIT:
			animation_tree["parameters/conditions/is_knock"] = true
			animation_tree["parameters/conditions/is_walk"] = false
			animation_tree["parameters/conditions/is_dash"] = false
		STATE.WALK:
			animation_tree["parameters/conditions/is_walk"] = true
			animation_tree["parameters/conditions/idle"] = false
		STATE.DASH:
			animation_tree["parameters/conditions/is_dash"] = true
			animation_tree["parameters/conditions/is_walk"] = false
	
	var direction = Input.get_vector("left", "right", "up", "down")
	animation_tree["parameters/idle/blend_position"]	= direction
	animation_tree["parameters/dash/blend_position"]	= direction
	animation_tree["parameters/knock/blend_position"]	= direction
	animation_tree["parameters/walk/blend_position"]	= direction
	
	if(direction != Vector2.ZERO):
		print(direction)

func get_input():
	var input_direction = Vector2.ZERO if disable_movement else Input.get_vector("left", "right", "up", "down")
	var speed = move_speed
	
	if direction_arrow_target:
		direction_arrow.look_at(direction_arrow_target.global_position)
	
	match current_state:
		STATE.IDLE:
			if input_direction != Vector2.ZERO:
				current_state = STATE.WALK
				
		STATE.WALK:
			if input_direction == Vector2.ZERO:
				current_state = STATE.IDLE
			
			if Input.is_action_pressed("dash") && dash.is_delay_stop():
				current_state = STATE.DASH
				dash.start_dash()
				
		STATE.DASH:
			if input_direction != Vector2.ZERO:
				speed = dash_speed
					
				if dash.is_dashing_stop():
					current_state = STATE.IDLE
			
		STATE.HIT:
			input_direction = Vector2.ZERO
			
			if knockback.is_stunt_stop():
				current_state = STATE.IDLE
		
	velocity = input_direction * speed
	
func set_label():
	health_status.text  = "health : "  + str(self.health)
	pinalty_status.text = "pinalty : " + str(self.pinalty) 

func _physics_process(delta):
	self.animation()
	self.get_input()
	self.move_and_slide()
	self.set_label()
	
	if global.respawn_status:
		self.disable_movement = false
		self.is_still_fight   = false
		global.was_respawn()
		
	if self.health == 0:
		emit_signal("game_over")
		
	if global.impact:
		self.process_impact(global.impact)
		global.impact = {}
	
	if map:
		var data = map.get_cell_tile_data(0,map.local_to_map(self.position))
		if data && data.get_custom_data("danger_area") == 1 && not is_in_danger_area && imune.is_stopped():
			is_in_danger_area = true
			disable_movement  = true
			pinalty += 1
			
			if pinalty < max_pinalty:
				emit_signal("in_danger_area")
			
			if pinalty == max_pinalty:
				emit_signal("game_over")

func _on_hurtbox_body_entered(body):
	match current_condition:
		CONDITION.ENCOUNTER:
			if body.is_in_group("bullets"):
				emit_signal("shot")
	
	if current_state == STATE.DASH:
		if body.is_in_group("obstacle"):
			current_state = STATE.HIT
			self.process_impact(body.give_impact())
	else:
		pass
		#print("hurtbox : touch something")
		
func process_impact(effect):
	if effect.attribute == "health_decrease":
		self.health    -= effect.value
		knockback.apply(effect.knockback)
	if effect.attribute == "health_increase":
		self.health += effect.value
	if effect.attribute == "pinalty_decrease":
		self.pinalty -= effect.value
	if effect.attribute == "pinalty_increase":
		self.pinalty += effect.value
