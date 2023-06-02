class_name Padestrian extends Mob

var crossing_area_entered
var entity_detected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func must_stop():
	if self.entity_detected:
		return true
	elif self.crossing_area_entered != null:
		return self.crossing_area_entered.padestrian_stop_status as bool
	return false

func _on_area_2d_area_entered(area):
	if (crossing_area_entered == null):
		if area.is_in_group("traffic_light_system"):
			crossing_area_entered = area

func _on_area_2d_area_exited(area):
	crossing_area_entered = null

func _on_entity_detector_body_entered(body):
	if(body.is_in_group("player")):
		self.entity_detected = true

func _on_entity_detector_body_exited(body):
	self.entity_detected = false
