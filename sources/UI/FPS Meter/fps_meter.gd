extends MarginContainer

@onready var fps_label = $fps_label

func _process(_delta: float) -> void:
	fps_label.text = " " + str(Engine.get_frames_per_second()) + " FPS "
