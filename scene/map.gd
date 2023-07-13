extends Node2D

@onready var map = $TileMap
@onready var player_system = $entity/player_system
@onready var checkpoint = $entity/checkpoint
@onready var ccg = $entity/ccg

# Called when the node enters the scene tree for the first time.
func _ready():
	var player = player_system.get_node("Player")
	global.set_main_scene(self)
	global.set_normal_camera(player_system.get_node("Marker2D/Camera2D"))
	global.get_encounter_camera().enabled = false
	global.get_normal_camera().enabled = true
	global.set_main_player(player)
	#player_system.player.map = map
	
	var start_point   = checkpoint.get_node("start_point")
	var finish_point  = checkpoint.get_node("end_point")
	start_point.global_position   = to_global(ccg.start_point.position - Vector2(0, start_point.get_node("Sprite2D").texture.get_size().y/4))
	finish_point.global_position  = to_global(ccg.finish_point.position - Vector2(0, finish_point.get_node("Sprite2D").texture.get_size().y/4))
	player.global_position = ccg.start_point.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		global.goto_prev_screen(self.get_path())


func _on_player_in_danger_area():
	print("waaaaaaaaa..........!!!")
	pass


func _on_checkpoint_get_finish():
	print("yeaaaaaayyyyyyy.....!!!")
