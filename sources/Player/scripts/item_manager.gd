extends Node3D

@onready var hotbar: Control = $"../../../HUD/Inventory".hotbar
@onready var item_position: Marker3D = $item_position

var current_item: item
var current_selected_slot: int
var current_viewmodel: Node3D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("hotbar_1"):
		select_new_slot(0)
	if event.is_action_pressed("hotbar_2"):
		select_new_slot(1)
	if event.is_action_pressed("hotbar_3"):
		select_new_slot(2)
	if event.is_action_pressed("hotbar_4"):
		select_new_slot(3)
	if event.is_action_pressed("hotbar_5"):
		select_new_slot(4)
	if event.is_action_pressed("hotbar_6"):
		select_new_slot(5)
	if event.is_action_pressed("hotbar_7"):
		select_new_slot(6)
	if event.is_action_pressed("hotbar_8"):
		select_new_slot(7)

	if event.is_action_pressed("scroll_down"):
		if (current_selected_slot+1) < 8 :
			select_new_slot(current_selected_slot+1)
		else: select_new_slot(0)
	if event.is_action_pressed("scroll_up"):
		if (current_selected_slot-1) > -1 :
			select_new_slot(current_selected_slot-1)
		else: select_new_slot(7)

func select_new_slot(slot: int):
	hotbar.select_a_slot(slot, true)
	if slot != current_selected_slot:
		hotbar.select_a_slot(current_selected_slot, false)
		for mesh in item_position.get_children():
			mesh.queue_free()
	current_selected_slot = slot
	if is_instance_valid(hotbar.get_item_from_slot(slot)):
		current_item = hotbar.get_item_from_slot(slot)
		create_3D_mesh(hotbar.get_item_from_slot(slot))

func create_3D_mesh(item_to_create: item):
	var mesh: Node3D = item_to_create.dropped_model.instantiate()
	item_position.add_child(mesh)
	mesh.position = item_to_create._3D_position
	mesh.scale = item_to_create._3D_scale
	mesh.rotation = item_to_create._3D_rotation
	current_viewmodel = mesh
