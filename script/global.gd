class_name Global extends Node

var target_scene_for_load = ""
var previous_scene        = ""

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
