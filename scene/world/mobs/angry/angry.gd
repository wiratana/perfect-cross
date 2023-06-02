class_name Angry extends CharacterBody2D

enum SHOT_TYPE{BASIC, AOE}

signal shoot(shot_type:SHOT_TYPE)

@export var rotate_speed:int = 50
@export var spawn_point_count:int = 10
@export var radius:int = 40
@export var shoot_time:float = 1
@export var aoe_shoot_time:float = 0.2
@export var aoe_shoot_duration:float = 5
@export var shoot_aoe_cycle:int = 10
@export var target:Node2D
@export var life_time_duration:int = 60

@onready var shoot_refresh:Timer = $shoot
@onready var aoe_shoot_refresh:Timer = $aoe_shoot
@onready var rotater:Node2D = $rotater
@onready var life_time:Timer = $life_time
@onready var life_time_progress:ProgressBar = $life_time_progress
@onready var bullet_scn = preload("res://scene/world/object/bullet/bullet.tscn")
@onready var cycle_count:int = 0
@onready var current_shooting_type = SHOT_TYPE.BASIC


# Called when the node enters the scene tree for the first time.
func _ready():
	life_time.wait_time = life_time_duration
	life_time_progress.max_value = life_time.wait_time
	life_time_progress.value = 0
	
	var step  = 2 * PI / spawn_point_count
	
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var pos         = Vector2(radius, 0).rotated(step*i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotater.add_child(spawn_point)
	
	aoe_shoot_refresh.wait_time = aoe_shoot_duration
	shoot_refresh.wait_time = shoot_time
	shoot_refresh.start()
	life_time.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !life_time.is_stopped():
		life_time_progress.value = life_time.wait_time - life_time.time_left
	
	match current_shooting_type:
		SHOT_TYPE.AOE:
			var new_rotation = rotater.rotation_degrees + rotate_speed * delta
			rotater.rotation_degrees = fmod(new_rotation, 360)
		SHOT_TYPE.BASIC:
			if target != null:
				rotater.look_at(target.position)
		
func shooting(shot_type:SHOT_TYPE):
	match shot_type:
		SHOT_TYPE.BASIC:
			var bullet = bullet_scn.instantiate()
			get_tree().root.add_child(bullet)
			bullet.speed = 400
			bullet.global_position = rotater.get_child(0).global_position
			bullet.global_rotation = rotater.get_child(0).global_rotation
		SHOT_TYPE.AOE:
			for i in rotater.get_children():
				var bullet = bullet_scn.instantiate()
				get_tree().root.add_child(bullet)
				bullet.speed = 100
				bullet.global_position = i.global_position
				bullet.global_rotation = i.global_rotation

func _on_shoot_timeout():
	self.cycle_count += 1
	
	match current_shooting_type:
		SHOT_TYPE.AOE:
			shoot.emit(SHOT_TYPE.AOE)
			self.shooting(SHOT_TYPE.AOE)
		SHOT_TYPE.BASIC:
			shoot.emit(SHOT_TYPE.BASIC)
			self.shooting(SHOT_TYPE.BASIC)
			
			if self.cycle_count % shoot_aoe_cycle == 0:
				aoe_shoot_refresh.start()
				shoot_refresh.wait_time = aoe_shoot_time
				current_shooting_type = SHOT_TYPE.AOE
	


func _on_aoe_shoot_timeout():
	current_shooting_type = SHOT_TYPE.BASIC
	shoot_refresh.wait_time = shoot_time


func _on_life_time_timeout():
	queue_free()
