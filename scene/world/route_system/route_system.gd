extends Node2D
class_name RouteSystem

var movement_mobs   = []

@onready var padestrian = preload("res://scene/world/mobs/padestrian/padestrian.tscn")
@onready var vehicle    = preload("res://scene/world/mobs/vehicle/vehicle.tscn")

func mob_spawn_generator():
	var mobs = [padestrian, vehicle]
	var pathFollow2D
	var mob
	for route in self.get_children():
		pathFollow2D = PathFollow2D.new()
		if route.belong_to == Route.Entity.Padestrian:
			mob		= padestrian.instantiate()
		if route.belong_to == Route.Entity.Vehicle:
			mob		= vehicle.instantiate()
		#if route.belong_to == Route.Entity.Animal:
		#	mob		= animal.instantiate()
		#if route.belong_to == Route.Entity.Criminal:
		#	mob		= criminal.instantiate()
		
		movement_mobs.append(pathFollow2D)
		pathFollow2D.add_child(mob)
		route.add_child(pathFollow2D)

func mob_position_setter():
	if(!movement_mobs.is_empty()):
		for movement_mob in movement_mobs:
			movement_mob.set_progress_ratio(0)
			#obstacle.set_progress_ratio(randf_range(0, 1))

func mob_behaviour_setter():
	if(!movement_mobs.is_empty()):
		for movement_mob in movement_mobs:
			movement_mob.set_loop(true)
			movement_mob.set_rotates(false)
			movement_mob.set_h_offset(0.0)
	
func mob_movement_control(delta):
	if(!movement_mobs.is_empty()):
		for movement_mob in movement_mobs:
			if !movement_mob.get_child(0).must_stop():
				movement_mob.progress += 100*delta

func _ready():
	mob_spawn_generator()
	mob_position_setter()
	mob_behaviour_setter()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mob_movement_control(delta)
	
