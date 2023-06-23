extends Node2D

@onready var map = $TileMap
@onready var player_system = $player_system

# Called when the node enters the scene tree for the first time.
func _ready():
	global.set_main_scene(self)
	global.set_normal_camera(player_system.get_node("Marker2D/Camera2D"))
	global.get_encounter_camera().enabled = false
	global.get_normal_camera().enabled = true
	global.set_main_player(player_system.get_node("Player"))
	player_system.player.map = map


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		global.goto_prev_screen(self.get_path())


func _on_player_in_danger_area():
	print("waaaaaaaaa..........!!!")
	pass


func _on_checkpoint_get_finish():
	print("yeaaaaaayyyyyyy.....!!!")
