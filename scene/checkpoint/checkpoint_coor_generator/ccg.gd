class_name CCG extends Node2D

@onready var start_point:Marker2D  = Marker2D.new()
@onready var finish_point:Marker2D = Marker2D.new()

func _ready():
	start_point  = self.get_tree().get_nodes_in_group("start_point")[0]
	finish_point = self.get_tree().get_nodes_in_group("finish_point")[randi() % 10]
