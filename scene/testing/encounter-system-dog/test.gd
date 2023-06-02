extends Node2D

@onready var initial_player_position = $player_marker
@onready var initial_dog_position    = $dog_marker
@onready var player = $Player
@onready var dog    = $dog
@onready var battle_area = $battle_area

# Called when the node enters the scene tree for the first time.
func _ready():
	player.position = initial_player_position.position
	dog.position    = initial_dog_position.position

