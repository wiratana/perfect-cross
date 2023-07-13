extends Area2D
class_name traffic_sign_system

@export var vehicle_stop_status = 0
@export var padestrian_stop_status = 0
@export var index = 0

@onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.get_node("Sprite2D").frame = 1 if padestrian_stop_status else 0
	self.get_node("Sprite2D2").frame = 1 if padestrian_stop_status else 0
	label.text = "p : {pss}  v : {vss}".format({"pss":padestrian_stop_status, "vss":vehicle_stop_status})
