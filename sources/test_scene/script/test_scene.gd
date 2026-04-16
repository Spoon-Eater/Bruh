extends Node3D

const APPLE = preload("uid://b640gd0s8iwu7")
@onready var dropped_loot: RigidBody3D = $dropped_loot

func _ready() -> void:
	print("APPLE qty: "+str(APPLE.quantity))
	print("dropped_loot.current_item qty: "+str(dropped_loot.current_item.quantity))
	if APPLE == dropped_loot.current_item: print("apple")
