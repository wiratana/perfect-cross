extends Node2D
class_name traffic_light_system

@export var vahicle_wait_time:int
@export var padestrian_wait_time:int
@onready var vahicle_update_counter = $vahicle_update_counter
@onready var padestrian_update_counter = $padestrian_update_counter

@onready var traffic_area_points = []
@onready var flow = true

func counter_loader():
	self.vahicle_update_counter.wait_time    = self.vahicle_wait_time
	self.padestrian_update_counter.wait_time = self.padestrian_wait_time
	
	self.vahicle_update_counter.start()
	self.padestrian_update_counter.start()
	
func traffic_area_point_loader():
	self.traffic_area_points = [
		self.get_node("Area2D"),
		self.get_node("Area2D2"),
		self.get_node("Area2D3"),
		self.get_node("Area2D4")
	]
	
# Called when the node enters the scene tree for the first time.
func _ready():
	self.traffic_area_point_loader()
	self.initial_traffic_light_sign_logic()
	self.counter_loader()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func initial_traffic_light_sign_logic():
	if len(self.traffic_area_points) == 4:
		for traffic_area_point in self.traffic_area_points:
			if traffic_area_point.index % 2 == 0:
				traffic_area_point.padestrian_stop_status = !flow as int
				traffic_area_point.vehicle_stop_status    = flow as int
			else:
				traffic_area_point.padestrian_stop_status = flow as int
				traffic_area_point.vehicle_stop_status    = !flow as int

func traffic_light_padestrian_sign_logic():
	if !self.traffic_area_points.is_empty():
		for traffic_area_point in self.traffic_area_points:
			traffic_area_point.padestrian_stop_status = 1
	
func traffic_light_sign_logic():
	if len(self.traffic_area_points) == 4:
		for traffic_area_point in self.traffic_area_points:
			if traffic_area_point.index % 2 == 0:
				traffic_area_point.padestrian_stop_status = !flow as int
				traffic_area_point.vehicle_stop_status    = flow as int
			else:
				traffic_area_point.padestrian_stop_status = flow as int
				traffic_area_point.vehicle_stop_status    = !flow as int


func _on_padestrian_update_counter_timeout():
	self.traffic_light_padestrian_sign_logic()
	


func _on_vahicle_update_counter_timeout():
	self.flow = !flow
	self.traffic_light_sign_logic()
	self.vahicle_update_counter.start()
	self.padestrian_update_counter.start()
