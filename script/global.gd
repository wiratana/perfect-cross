class_name Global extends Node

var target_scene_for_load = ""
var previous_scene        = ""
var main_scene:Node2D	  = Node2D.new()
var main_player:Node2D	  = Node2D.new()
var enct_scene:Node2D	  = Node2D.new()
var enct_player:Node2D	  = Node2D.new()
var normal_camera:Camera2D    = Camera2D.new()
var encounter_camera:Camera2D = Camera2D.new()
var respawn_status		  = false
var impact:Dictionary

func must_respawn():
	self.respawn_status = true
	
func was_respawn():
	self.respawn_status = false
	
	
func get_main_player():
	return self.main_player

func set_main_player(player: Node2D):
	self.main_player = player


func get_enct_player():
	return self.enct_player
	
func set_enct_player(player: Node2D):
	self.enct_player = player


func get_center_position_h():
	return ceil(get_viewport().get_visible_rect().size.x/2)
	
func get_center_position_v():
	return ceil(get_viewport().get_visible_rect().size.y/2)


func goto_target_screen(target:String, current:String):
	self.target_scene_for_load = target
	self.previous_scene		   = current
	get_tree().change_scene_to_file("res://scene/load_scene/load_scene.tscn")

func goto_prev_screen(current_path:String):
	if self.previous_scene:
		self.target_scene_for_load = self.previous_scene
		self.previous_scene		   = current_path
		get_tree().change_scene_to_file("res://scene/load_scene/load_scene.tscn")

		
func get_main_scene():
	return self.main_scene

func set_main_scene(scene:Node2D):
	self.main_scene = scene


func get_enct_scene():
	return self.enct_scene

func set_enct_scene(scene:Node2D):
	self.enct_scene = scene


func get_normal_camera():
	return self.normal_camera

func set_normal_camera(camera:Camera2D):
	self.normal_camera = camera


func get_encounter_camera():
	return self.encounter_camera

func set_encounter_camera(camera:Camera2D):
	self.encounter_camera = camera

	
func push_scene():
	pass

func pop_scene():
	self.get_normal_camera().enabled = true
	self.get_enct_scene().queue_free()
	self.get_main_scene().show()
	self.must_respawn()
