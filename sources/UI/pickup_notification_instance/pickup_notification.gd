extends Control

@onready var icon: TextureRect = $MarginContainer/HBoxContainer/icon
@onready var label: Label = $MarginContainer/HBoxContainer/Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var color: Color = Color.LIGHT_GRAY

func set_notif(item_picked_up: item, quantity: int):
	icon.texture = item_picked_up.icon
	label.text = "x"+str(quantity)+" "+str(item_picked_up._name)+" picked up."
	animation_player.play("notif")

	match item_picked_up.rarity:
		"Shit":
			color = Color.LIGHT_GRAY
		"Meh":
			color = Color.LIME_GREEN
		"I mean it's alright":
			color = Color.BLUE
		"Now we are talkin":
			color = Color.MAGENTA
		"Good Stuff":
			color = Color.YELLOW
		"YES":
			color = Color.RED
	label.modulate = color

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
