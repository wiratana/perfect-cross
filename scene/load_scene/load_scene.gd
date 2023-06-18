class_name LoadScene extends Node2D

@export var target_scene_path = "res://scene/map.tscn"
var loading_status : int
var progress = []

@onready var progress_bar : ProgressBar = $ProgressBar

#func _init(path:String):
#	target_scene_path = path

func _ready() -> void:
	if global.target_scene_for_load:
		target_scene_path = global.target_scene_for_load
		
	ResourceLoader.load_threaded_request(target_scene_path, "", true, ResourceLoader.CACHE_MODE_REUSE)
	
func _process(_delta: float) -> void:
	# Update the status:
	loading_status = ResourceLoader.load_threaded_get_status(target_scene_path, progress)
	
	# Check the loading status:
	match loading_status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			progress_bar.value = progress[0]*100
		ResourceLoader.THREAD_LOAD_LOADED:
			# When done loading, change to the target scene:
			get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(target_scene_path))
			queue_free()
		ResourceLoader.THREAD_LOAD_FAILED:
			# Well some error happend:
			print("Error. Could not load Resource")
