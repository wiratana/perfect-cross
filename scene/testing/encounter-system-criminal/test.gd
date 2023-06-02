extends Node2D

@onready var initial_player_position = $player_marker
@onready var initial_criminal_position = $criminal_marker
@onready var player = $Player
@onready var criminal = $criminal

# Called when the node enters the scene tree for the first time.
func _ready():
	player.position   = initial_player_position.position
	criminal.position = initial_criminal_position.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_criminal_is_criminal_catch_player():
	player.position   = to_global(initial_player_position.position)
	criminal.position = to_global(initial_criminal_position.position)

func _on_criminal_is_maximum_number_of_arrests():
	criminal.queue_free()
