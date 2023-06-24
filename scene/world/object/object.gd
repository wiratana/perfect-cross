class_name ObjectEntity extends CharacterBody2D

enum Test{
	HEALTH_DECREASE,
	HEALTH_INCREASE,
	PINALTY_DECREASE,
	PINALTY_INCREASE
	}

@export var type_of_testing:Test
@export var health_decrease_value:int
@export var health_increase_value:int
@export var pinalty_decrease_value:int
@export var pinalty_increase_value:int
@export var knockback:Vector2

@onready var label = $Label 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func give_impact():
	var data = {}
	
	data["knockback"] = knockback
	
	match type_of_testing:
		Test.HEALTH_DECREASE:
			data["attribute"] = "health_decrease"
			data["value"]     = health_decrease_value
		Test.HEALTH_INCREASE:
			data["attribute"] = "health_increase"
			data["value"]     = health_increase_value
		Test.PINALTY_DECREASE:
			data["attribute"] = "pinalty_decrease"
			data["value"]     = pinalty_decrease_value
		Test.PINALTY_INCREASE:
			data["attribute"] = "pinalty_increase"
			data["value"]     = pinalty_increase_value
	return data

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
