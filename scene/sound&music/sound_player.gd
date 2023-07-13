extends Node2D

enum SOUND{WHISTLE, WALK, DOG, VEHICLE, CRIMINAL, HIT, CLICK}

@onready var audioPlayers = $AudioPlayers
@onready var current_bgm  = 0
@onready var bgmn = preload("res://assets/wav/bgm-n.wav")
@onready var bgmd = preload("res://assets/wav/bgm-d4.wav")
		
func play_sfx(sound):
	match sound:
		SOUND.WHISTLE:
			self.get_node("AudioPlayers/whistle").play()
		SOUND.WALK:
			self.get_node("AudioPlayers/walk").play()
		SOUND.DOG:
			self.get_node("AudioPlayers/dog").play()
		SOUND.VEHICLE:
			self.get_node("AudioPlayers/vehicle").play()
		SOUND.CRIMINAL:
			self.get_node("AudioPlayers/criminal").play()
		SOUND.HIT:
			self.get_node("AudioPlayers/hit").play()
		SOUND.CLICK:
			self.get_node("AudioPlayers/click").play()

func stop_sfx(sound):
	match sound:
		SOUND.WHISTLE:
			self.get_node("AudioPlayers/whistle").stop()
		SOUND.WALK:
			self.get_node("AudioPlayers/walk").stop()
		SOUND.DOG:
			self.get_node("AudioPlayers/dog").stop()
		SOUND.VEHICLE:
			self.get_node("AudioPlayers/vehicle").stop()
		SOUND.CRIMINAL:
			self.get_node("AudioPlayers/criminal").stop()
		SOUND.CLICK:
			self.get_node("AudioPlayers/click").stop()

func peace_music():
	self.get_node("MusicPlayers/bgm-n").play()
	self.get_node("MusicPlayers/bgm-d").stop()
	
func danger_music():
	self.get_node("MusicPlayers/bgm-n").stop()
	self.get_node("MusicPlayers/bgm-d").play()
