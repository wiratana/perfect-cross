class_name PadestrianStatic extends ObjectEntity

func _ready():
	self.get_node("Sprite2D").hide()
	self.get_node("Sprite2D").frame = randi() % 4


func _on_visible_on_screen_notifier_2d_screen_entered():
	self.get_node("Sprite2D").show()


func _on_visible_on_screen_notifier_2d_screen_exited():
	self.get_node("Sprite2D").hide()
