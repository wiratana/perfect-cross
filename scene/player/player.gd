extends CharacterBody2D
class_name Player

enum STATE{IDLE, WALK, DASH, HIT}
enum CONDITION{NORMAL, ENCOUNTER}

@export var move_speed = 150
@export var dash_speed = 500
@export var health     = 3
@export var pinalty    = 3
@export var current_condition = CONDITION.NORMAL

@onready var dash = $Dash
@onready var knockback = $Knockback
@onready var health_status:Label  = $labels/health_status
@onready var pinalty_status:Label = $labels/pinalty_status
@onready var dashing : bool
@onready var current_state = STATE.IDLE


func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	var speed = move_speed
	
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
			
			speed = move_speed
				
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
	self.get_input()
	self.move_and_slide()
	self.set_label()

func _on_hurtbox_body_entered(body):
	match current_condition:
		CONDITION.ENCOUNTER:
			if body.is_in_group("bullets"):
				body.queue_free()
	
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
