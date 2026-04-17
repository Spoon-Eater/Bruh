extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var pickup_notification_vbox: VBoxContainer = $pickup_notifications/MarginContainer/VBoxContainer

const PICKUP_NOTIFICATION = preload("uid://ds0w6pyvcide7")

func _ready() -> void:
	for node in get_children():
		if node.name != "AnimationPlayer" and node.name != "pickup_notifications":
			node.hide()

func pickup_notification(item_picked_up: item, quantity: int):
	var notification = PICKUP_NOTIFICATION.instantiate()
	pickup_notification_vbox.add_child(notification)
	notification.set_notif(item_picked_up, quantity)

func inventory_full():
	animation_player.stop()
	animation_player.play("inventory_full")
func dropped_item():
	animation_player.stop()
	animation_player.play("item_dropped")
