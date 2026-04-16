extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	for node in get_children():
		if node.name != "AnimationPlayer":
			node.hide()

func inventory_full():
	print("hellothere!")
	animation_player.play("inventory_full")
