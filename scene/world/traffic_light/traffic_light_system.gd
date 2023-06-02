extends Node2D
class_name traffic_light_system

@export var vahicle_wait_time:int
@export var padestrian_wait_time:int
@onready var vahicle_update_counter = $vahicle_update_counter
@onready var padestrian_update_counter = $padestrian_update_counter

var traffic_area_points = []
var flow = true

func counter_loader():
	vahicle_update_counter.wait_time    = vahicle_wait_time
	padestrian_update_counter.wait_time = padestrian_wait_time
	
	vahicle_update_counter.start()
	padestrian_update_counter.start()
	
func traffic_area_point_loader():
	traffic_area_points = self.get_tree().get_nodes_in_group("traffic_light_system")
	
# Called when the node enters the scene tree for the first time.
func _ready():
	counter_loader()
	traffic_area_point_loader()
	initial_traffic_light_sign_logic()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func initial_traffic_light_sign_logic():
	for traffic_area_point in traffic_area_points:
			if traffic_area_point.index % 2 == 0:
				traffic_area_point.padestrian_stop_status = !flow as int
				traffic_area_point.vehicle_stop_status    = flow as int
			else:
				traffic_area_point.padestrian_stop_status = flow as int
				traffic_area_point.vehicle_stop_status    = !flow as int

func traffic_light_padestrian_sign_logic():
	if !traffic_area_points.is_empty():
		for traffic_area_point in traffic_area_points:
			traffic_area_point.padestrian_stop_status = 1
	
func traffic_light_sign_logic():
	if len(traffic_area_points) == 4:
		for traffic_area_point in traffic_area_points:
			if traffic_area_point.index % 2 == 0:
				traffic_area_point.padestrian_stop_status = !flow as int
				traffic_area_point.vehicle_stop_status    = flow as int
			else:
				traffic_area_point.padestrian_stop_status = flow as int
				traffic_area_point.vehicle_stop_status    = !flow as int


func _on_padestrian_update_counter_timeout():
	traffic_light_padestrian_sign_logic()
	


func _on_vahicle_update_counter_timeout():
	flow = !flow
	traffic_light_sign_logic()
	vahicle_update_counter.start()
	padestrian_update_counter.start()
