extends Node2D

@onready var start_button  = $VBoxContainer/start_btn
@onready var credit_button = $VBoxContainer/credit_btn
@onready var exit_button   = $VBoxContainer/exit_btn
@onready var anim_player   = $AnimationPlayer
@onready var load_scene    = preload("res://scene/load_scene/load_scene.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_player.play("logo_dancing")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_start_btn_pressed():
	SoundPlayer.play_sfx(SoundPlayer.SOUND.CLICK)
	global.goto_target_screen(
		"res://scene/map.tscn", 
		"res://scene/screen/home_screen/home_screen.tscn")

func _on_credit_btn_pressed():
	SoundPlayer.play_sfx(SoundPlayer.SOUND.CLICK)
	global.goto_target_screen(
		"res://scene/screen/credit_screen/credit_screen.tscn", 
		"res://scene/screen/home_screen/home_screen.tscn")


func _on_exit_btn_pressed():
	SoundPlayer.play_sfx(SoundPlayer.SOUND.CLICK)
	get_tree().quit()
