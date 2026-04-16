extends Node

@onready var inventory_ui: Control = $".."

const INVENTORY_SLOT = preload("uid://3tj36qvnqqn2")
const EMPTY_SLOT = preload("uid://jqkete66xnjp")

var inventory_size: int = 8

var inventory_quantities: Array[int] = []
var inventory_data: Array[item] = []
var is_full: bool = false

# start the inventory by creating an empty slot for every inventory_size number
func init_inventory():
	for slot in inventory_size:
		var new_slot = INVENTORY_SLOT.instantiate()
		inventory_ui.grid_container.add_child(new_slot)
		new_slot.set_empty_slot()
		new_slot.name = str(slot)
		inventory_data.append(EMPTY_SLOT)
		inventory_quantities.append(0)

# used to give an item to the player
func add_item(new_item: item, quantity: int, slot: int):
	inventory_data[slot] = new_item
	inventory_quantities[slot] = quantity
	inventory_ui.update_specific_slot(new_item, quantity, slot)

func check_for_item(wanted_item: item) -> Array:
	var return_array: Array = [null] # [item, quantity, slot_positon, full_stack]
	for _item in inventory_data.size():
		if inventory_data[_item] != null and inventory_data[_item] == wanted_item:
			if inventory_data[_item].is_stackable:
				if inventory_quantities[_item] < inventory_data[_item].max_stack_number:
					return_array = [inventory_data[_item], inventory_quantities[_item], _item, false]
			return_array = [inventory_data[_item], inventory_quantities[_item], _item, true]
			return return_array
	return return_array

func check_for_empty_slot() -> Array:
	var return_array: Array[int] = [false,-1] # [status false: no_empty_slot true: empty_slot_found , slot_pos]
	var slot_pos: int = 0
	for slot: item in inventory_data:
		if slot == EMPTY_SLOT:
			is_full = false
			return_array = [true, slot_pos]
			return return_array
		slot_pos += 1
		if slot_pos == inventory_size+1:
			is_full = true
			return_array = [false, slot_pos]
			return return_array
	return_array = [is_full, slot_pos]
	return return_array

func update_a_slot(slot_to_update: int, data: item, quantity: int):
	inventory_data[slot_to_update] = data
	inventory_quantities[slot_to_update] = quantity
