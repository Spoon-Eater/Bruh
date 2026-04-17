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

func select_a_slot(slot_pos: int, select: bool = true):
	var slot = h_box_container.find_child(str(slot_pos))
	if select: slot.update_panel_color("white")
	else:
		slot.update_panel_color("black")

func get_item_from_slot(slot_pos: int) -> item:
	var slot = h_box_container.find_child(str(slot_pos))
	if slot: return slot.current_item
	else: return preload("uid://jqkete66xnjp")
