extends Control

@export var player:Node2D
@export var pinalty_confirmation_panel_size = 250
@onready var police_alert = $police_alert/Police
@onready var pinalty_confirmation = $pinalty_confirmation
@onready var pc_text   = $pinalty_confirmation/pinalty_text
@onready var pc_button = $pinalty_confirmation/pinalty_button
@onready var pinalties = $pinalty

func setup_ui_police_alert():
	police_alert.hide()
	police_alert.position.x = ceil(get_viewport().get_visible_rect().size.x/2) + ceil((police_alert.texture.get_size().x*police_alert.scale.x)/2)
	
func setup_ui_pinalty_confirmation():
	pinalty_confirmation.hide()
	pinalty_confirmation.position.x = ceil(get_viewport().get_visible_rect().size.x/2) - ceil(pinalty_confirmation.size.x/2)
	pinalty_confirmation.position.y = ceil(get_viewport().get_visible_rect().size.y/2) - ceil(pinalty_confirmation.size.y/2)
	pinalty_confirmation.size.x = pinalty_confirmation_panel_size
	pinalty_confirmation.size.y = pinalty_confirmation_panel_size
	pc_text.size.x = pinalty_confirmation.size.x
	pc_text.size.y = ceil(pinalty_confirmation.size.y/2)
	pc_text.add_theme_font_size_override("font_size", 16)
	pc_button.position.x = ceil(pinalty_confirmation.size.x/2) - ceil(pc_button.size.x/2)
	pc_button.position.y = ceil(pinalty_confirmation.size.y/2) + ceil(pc_button.size.y/2)

func setup_ui_pinalty():
	pinalties.get_children().map(func (a): a.hide())
	
func refresh_pinalty():
	for i in range(pinalties.get_child_count()):
		if i+1 <= player.pinalty:
			pinalties.get_children()[i].show()

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_ui_police_alert()
	setup_ui_pinalty_confirmation()
	setup_ui_pinalty()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_in_danger_area():
	var tween = create_tween()
	police_alert.show()
	tween.tween_property(
		police_alert, 
		"position", 
		Vector2((ceil(get_viewport().get_visible_rect().size.x/2) - ceil((police_alert.texture.get_size().x*police_alert.scale.x)/2)), 0),
		0.2
	)
	pc_text.text = "Kamu Melanggar Lalu lintas dengan Tidak Menyebrang difasilitas penyebrangan"
	tween.tween_callback(func (): pinalty_confirmation.show()).set_delay(1)


func _on_pinalty_button_pressed():
	pinalty_confirmation.hide()
	player.disable_movement = false
	player.imune.start()
	player.is_in_danger_area = false
	var tween = create_tween()
	tween.tween_property(
		police_alert, 
		"position", 
		Vector2((ceil(get_viewport().get_visible_rect().size.x/2) + ceil((police_alert.texture.get_size().x*police_alert.scale.x)/2)), 0),
		0.2
	)
	tween.tween_callback(func(): police_alert.hide()).set_delay(1)
	
	refresh_pinalty()


func _on_player_game_over():
	var tween = create_tween()
	pc_text.text = "GAME OVER"
	tween.tween_callback(func (): pinalty_confirmation.show()).set_delay(1)
	
	refresh_pinalty()
