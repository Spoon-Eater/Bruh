extends CenterContainer

signal unpause

# hides it on ready
func _ready() -> void:
	self.hide()

# play animation according to open or close (trigger)
func open_close(trigger):
	if trigger == true:
		get_tree().paused = true
		self.show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		self.hide()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# emit signal to player for him to unpause
func unpause_button() -> void:
	unpause.emit()
	self.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
# self exp
func quit() -> void:
	get_tree().quit()
