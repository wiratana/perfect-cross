class_name Vehicle extends Mob

@export  var direction:Route.DIRECTION = Route.DIRECTION.LEFT
@onready var animationPlayer = $AnimationPlayer
@onready var do_process = false
var initial_crossing_area_entered
var final_crossing_area_entered
var entity_detected = false
var must_go = false

func animation():
	match direction:
		Route.DIRECTION.LEFT:
			animationPlayer.play("left")
		Route.DIRECTION.RIGHT:
			animationPlayer.play("right")
		Route.DIRECTION.UP:
			animationPlayer.play("up")
		Route.DIRECTION.BUTTOM:
			animationPlayer.play("buttom")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_node("Sprite2D").hide()
	animation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(do_process):
		pass
	pass

func must_stop():
	if self.must_go:
		return false #negative stop
	elif self.entity_detected:
		return true
	elif self.initial_crossing_area_entered != null:
		return self.initial_crossing_area_entered.vehicle_stop_status as bool
	return false

func _on_entity_detector_body_entered(body):
	if(body.is_in_group("player") || body.is_in_group("padestrian") || body.is_in_group("vehicle")):
		self.entity_detected = true

func _on_entity_detector_body_exited(_body):
	self.entity_detected = false

func _on_end_of_vision_area_entered(area):
	if area.is_in_group("traffic_light_system"):
		if (initial_crossing_area_entered == null):
			initial_crossing_area_entered = area
		else:
			final_crossing_area_entered   = area

func _on_center_position_area_exited(area):
	if initial_crossing_area_entered != null && area == initial_crossing_area_entered:
		must_go = true
		initial_crossing_area_entered = null
	
	if final_crossing_area_entered != null && area == final_crossing_area_entered:
		must_go = false
		final_crossing_area_entered = null
		


func _on_visible_on_screen_notifier_2d_screen_entered():
	self.get_node("Sprite2D").show()
	self.do_process = true
	SoundPlayer.play_sfx(SoundPlayer.SOUND.VEHICLE)


func _on_visible_on_screen_notifier_2d_screen_exited():
	self.get_node("Sprite2D").hide()
	self.do_process = false
	SoundPlayer.stop_sfx(SoundPlayer.SOUND.VEHICLE)
