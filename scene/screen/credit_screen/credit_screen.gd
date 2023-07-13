extends Node2D

@onready var logo = $Logo
@onready var text = $RichTextLabel
@onready var back_button = $back_button

# Called when the node enters the scene tree for the first time.
func _ready():
	logo.position.x = global.get_center_position_h()
	logo.position.y = ceil(logo.texture.get_size().y*logo.scale.y)/2
	text.size.x 	= global.get_center_position_h() * 1.5
	text.size.y     = global.get_center_position_v() * 1.5
	text.position.x = abs(global.get_center_position_h() - ceil(text.size.x))
	text.position.y = abs(global.get_center_position_v() - ceil(text.size.y))
	back_button.position.x = ceil(back_button.size.x*back_button.scale.x)/4
	back_button.position.y = ceil(back_button.size.y*back_button.scale.y)/4
	
	text.text		= "Philodoxia GEMASTIK 16 2023"
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		global.goto_prev_screen(self.get_path())

func _on_back_button_pressed():
	SoundPlayer.play_sfx(SoundPlayer.SOUND.CLICK)
	global.goto_prev_screen(self.get_path())
