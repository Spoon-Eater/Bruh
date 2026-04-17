extends Control

@onready var h_box_container: HBoxContainer = $PanelContainer/margincontainer/HBoxContainer

const EMPTY_SLOT = preload("uid://jqkete66xnjp")

var hotbar_inventory_quantities: Array[int] = [-1, -1, -1, -1, -1, -1, -1, -1]
var hotbar_inventory_data: Array[item] = [EMPTY_SLOT, EMPTY_SLOT, EMPTY_SLOT, EMPTY_SLOT, EMPTY_SLOT, EMPTY_SLOT, EMPTY_SLOT, EMPTY_SLOT]

func init_hotbar(_inventory_manager: Node):
	for hot_slot in h_box_container.get_children():
		hot_slot.set_empty_slot()
		hot_slot.inventory_manager = _inventory_manager
	show()

func update_a_hotbar_slot(slot_to_update: int, data: item, quantity: int):
	hotbar_inventory_data[slot_to_update] = data
	hotbar_inventory_quantities[slot_to_update] = quantity
