class_name Vehicle extends Mob

var initial_crossing_area_entered
var final_crossing_area_entered
var entity_detected = false
var must_go = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func must_stop():
	if self.entity_detected:
		return true
	
	if self.must_go:
		return false #negative stop
		
	if self.initial_crossing_area_entered != null:
		return self.initial_crossing_area_entered.vehicle_stop_status as bool
		
	return false

func _on_entity_detector_body_entered(body):
	if(body.is_in_group("player") || body.is_in_group("padestrian")):
		self.entity_detected = true

func _on_entity_detector_body_exited(body):
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
		
