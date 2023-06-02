extends Node2D

@onready var player = $Player
@onready var angry  = $angry
@onready var initial_player_position = $player_marker
@onready var initial_angry_position  = $angry_marker


# Called when the node enters the scene tree for the first time.
func _ready():
	player.position = initial_player_position.global_position
	angry.position = initial_angry_position.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_angry_shoot(shot_type):
	pass
