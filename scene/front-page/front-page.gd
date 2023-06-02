extends Node2D

@onready var start_button  = $VBoxContainer/start_btn
@onready var credit_button = $VBoxContainer/credit_btn
@onready var exit_button   = $VBoxContainer/exit_btn

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_btn_pressed():
	get_tree().change_scene_to_file("res://scene/game.tscn")


func _on_credit_btn_pressed():
	pass # Replace with function body.


func _on_exit_btn_pressed():
	pass # Replace with function body.
