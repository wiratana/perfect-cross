class_name Padestrian extends Mob

@onready var crossing_area_entered
@onready var entity_detected = false
@onready var encounter = load("res://scene/world/mobs/angry/encounter/encounter.tscn").instantiate()
@onready var do_process = false
@onready var direction:Route.DIRECTION = Route.DIRECTION.RIGHT
@onready var animationTree = $AnimationTree
@export var is_idle = true
@onready var keep_going = false

func animation():
	if self.must_stop() || is_idle:
		animationTree["parameters/conditions/idle"]    = true
		animationTree["parameters/conditions/is_walk"] = false
	else:
		animationTree["parameters/conditions/idle"] = false
		animationTree["parameters/conditions/is_walk"] = true
		
		match direction:
			Route.DIRECTION.LEFT:
				animationTree["parameters/walk/blend_position"] = Vector2(-1,0)
				pass
			Route.DIRECTION.RIGHT:
				animationTree["parameters/walk/blend_position"] = Vector2(1,0)
				pass
			Route.DIRECTION.UP:
				animationTree["parameters/walk/blend_position"] = Vector2(0,-1)
				pass
			Route.DIRECTION.BUTTOM:
				animationTree["parameters/walk/blend_position"] = Vector2(0,1)
				pass
	

# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_node("Sprite2D").hide()
	animation()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if do_process:
		print(is_idle)
	pass

func must_stop():
	if self.keep_going:
		return false
	elif self.entity_detected:
		return true
	elif self.crossing_area_entered != null:
		return self.crossing_area_entered.padestrian_stop_status as bool
	return false

func _on_area_2d_area_entered(area):
	if (crossing_area_entered == null):
		if area.is_in_group("traffic_light_system"):
			crossing_area_entered = area
			animation()

func _on_area_2d_area_exited(_area):
	crossing_area_entered = null

func _on_entity_detector_body_entered(body):
	animation()
	if(body.is_in_group("player")):
		self.entity_detected = true

func _on_entity_detector_body_exited(body):
	animation()
	if(body.is_in_group("player")):
		self.entity_detected = false


func _on_hurtbox_body_entered(body):
	if body.is_in_group("player"):
		if body.current_state == Player.STATE.DASH && !body.is_still_fight:
			#enter encounter space
			body.disable_movement = true
			body.is_still_fight   = true
			get_tree().get_root().add_child(encounter)
			global.set_enct_scene(encounter)
			global.get_main_scene().hide()


func _on_visible_on_screen_notifier_2d_screen_entered():
	self.do_process = true
	self.get_node("Sprite2D").show()
  

func _on_visible_on_screen_notifier_2d_screen_exited():
	self.do_process = false
	self.get_node("Sprite2D").hide()


func _on_ready():
	animation()


func _on_hurtbox_area_entered(area):
	if area.is_in_group("traffic_light_system"):
		self.keep_going = true


func _on_hurtbox_area_exited(_area):
	self.keep_going = false
