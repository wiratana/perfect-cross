extends Node2D

@onready var map = $TileMap
@onready var player_system = $player_system

# Called when the node enters the scene tree for the first time.
func _ready():
	player_system.player.map = map


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_in_danger_area():
	print("waaaaaaaaa..........!!!")
	pass


func _on_checkpoint_get_finish():
	print("yeaaaaaayyyyyyy.....!!!"                                                                                                                                                                                                                                                                                                                                    )
