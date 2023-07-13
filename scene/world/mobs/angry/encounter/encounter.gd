extends Node2D

@onready var initial_player_position = $player_marker
@onready var initial_criminal_position = $criminal_marker
@onready var player_system = $player_system
@onready var angry = $angry
@onready var player:Node2D = Node2D.new()
@onready var after_match = $after_match
@onready var encounter_progress:ProgressBar
@onready var encounter_timer:Timer = $encounter_timer
@onready var reset_progress = false
@export var knockback:Vector2 = Vector2(20,20)
@export var health_decrease_value = 1
@onready var life_point = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	player = player_system.get_node("Player")
	player_system.get_node("Marker2D/UI").set_condition(Player.CONDITION.ENCOUNTER)
	encounter_progress = player_system.get_node("Marker2D/UI/survival_bar")
	player.position   = initial_player_position.position
	angry.target   = player
	angry.position = Vector2(global.get_center_position_h(), global.get_center_position_v())
	global.set_encounter_camera(player_system.get_node("Marker2D/Camera2D"))
	global.get_encounter_camera().enabled = true
	global.get_normal_camera().enabled = false
	after_match.position.x = global.get_center_position_h() - after_match.size.x/2
	after_match.position.y = global.get_center_position_v() - after_match.size.y/2
	after_match.hide()

	global.get_main_player().disable_movement = true
	
	encounter_timer.wait_time = 30
	encounter_progress.max_value  = encounter_timer.wait_time
	encounter_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !encounter_timer.is_stopped() && !reset_progress:	
		encounter_progress.value = encounter_timer.wait_time - encounter_timer.time_left


func _on_criminal_is_maximum_number_of_arrests():
	reset_progress = true
	angry.queue_free()
	player_system.queue_free()
	var tween = create_tween()
	tween.tween_callback(func(): after_match.show()).set_delay(1)
	SoundPlayer.peace_music()
	SoundPlayer.stop_sfx(SoundPlayer.SOUND.WALK)
	pass


func _on_pinalty_button_pressed():
	var data = {}
	data["knockback"] = knockback
	data["attribute"] = "health_decrease"
	data["value"]     = health_decrease_value
	global.impact = data
	global.pop_scene()


func _on_encounter_timer_timeout():
	global.pop_scene()


func _on_player_shot():
	if life_point == 0:
		reset_progress = true
		angry.queue_free()
		player_system.queue_free()
		var tween = create_tween()
		for bullet in get_tree().get_nodes_in_group("bullets"):
			bullet.queue_free()
		tween.tween_callback(func(): after_match.show()).set_delay(1)
		pass
	else:
		life_point -= 1

