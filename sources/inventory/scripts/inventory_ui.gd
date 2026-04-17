extends Control

@onready var Anim_P = $AnimationPlayer
@onready var grid_container = $TabContainer/Inventory/PanelContainer/GridContainer
@onready var inventory_manager: Node = $inventory_manager
@onready var hotbar: Control = $hotbar

func _ready() -> void:
	self.hide()
	inventory_manager.init_inventory()
	hotbar.init_hotbar(inventory_manager)

# animate the open/close of the inventory
func open_close(trigger):
	if trigger == true:
		Anim_P.play("open_close")
		self.show()
	else:
		Anim_P.play_backwards("open_close")
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "open_close" and self.visible == false:
		self.hide()

func update_specific_slot(_item: item, quantity: int, slot_pos: int):
	for slot in grid_container.get_children():
		if slot.name == str(slot_pos):
			var wanted_slot = slot
			wanted_slot.set_item(_item, quantity)
