extends Node2D
class_name RouteSystemPadestrian

var movement_mobs   = []

@onready var padestrian = preload("res://scene/world/mobs/padestrian/padestrian.tscn")

func mob_spawn_generator():
	var pathFollow2D
	var mob
	for route in self.get_children():
		route.curve.set_bake_interval(40.0)
		pathFollow2D = PathFollow2D.new()
		pathFollow2D.rotates = false
		if route.belong_to == Route.Entity.Padestrian:
			mob		= padestrian.instantiate()
			mob.direction = route.direction
			mob.is_idle   = false
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
	
