extends Control

@onready var icon = $Slot/SlotBorder/icon
@onready var rarity = $Slot/SlotBorder/Rarity
@onready var quantity_label = $QuantityLabel
@onready var details_panel = $Details_Panel
@onready var item_name = $Details_Panel/Item_Name
@onready var item_description = $Details_Panel/Item_Description
@onready var item_rarity = $Details_Panel/Item_Rarity
@onready var inventory_manager: Node = get_parent().get_parent().get_parent().get_parent().get_parent().inventory_manager

var hovering: bool = false
var current_item = null

var hover_size = Vector2(120, 120)
var default_size = Vector2(100, 100)

var dragged: bool = false

# hides everyting needed to be
func _ready() -> void:
	details_panel.hide()

func _process(delta: float) -> void:
	# displaying the details panel
	if hovering == true:
		self.custom_minimum_size = lerp(self.custom_minimum_size, hover_size, delta * 7)
		if item:
			details_panel.visible = true
			details_panel.global_position = get_global_mouse_position() + Vector2(35, 0)
	else:
		self.custom_minimum_size = lerp(self.custom_minimum_size, default_size, delta * 12)
		details_panel.visible = false

	if dragged:
		details_panel.hide()
		icon.global_position = get_global_mouse_position() + Vector2(-50, -50)

# self exp
func set_empty_slot():
	current_item = null
	rarity.hide()
	icon.texture = null
	quantity_label.text = ""
	item_name.text = ""
	item_description.text = ""
	item_rarity.text = ""
# same
func set_item(new_item: item, quantity: int):
	current_item = new_item
	rarity.show()
	match new_item.rarity:
		"Shit":
			rarity.modulate = Color.LIGHT_GRAY
		"Meh":
			rarity.modulate = Color.LIME_GREEN
		"I mean it's alright":
			rarity.modulate = Color.BLUE
		"Now we are talkin":
			rarity.modulate = Color.MAGENTA
		"Good Stuff":
			rarity.modulate = Color.YELLOW
		"YES":
			rarity.modulate = Color.RED
	icon.texture = new_item.icon
	quantity_label.text = "x" + str(quantity)
	item_name.text = new_item._name
	item_description.text = new_item.description
	item_rarity.text = new_item.rarity

# check for a M1 click to show the slot menu
func _on_item_button_pressed() -> void:
	if current_item != null:
		dragged = true
		icon.top_level = true
		$Item_Button.mouse_filter = Control.MOUSE_FILTER_PASS
		quantity_label.hide()
		rarity.hide()
func _on_item_button_button_up() -> void:
	if current_item != null:
		dragged = false
		icon.top_level = false
		$Item_Button.mouse_filter = Control.MOUSE_FILTER_STOP
		quantity_label.show()
		rarity.show()
		_try_drop()

func _try_drop() -> void:
	var grid = get_parent()
	var target_slot = null
	for slot in grid.get_children():
		if slot == self:
			continue
		var rect = Rect2(slot.global_position, slot.size)
		if rect.has_point(get_global_mouse_position()):
			target_slot = slot
			break
	if target_slot != null:
		var temp_item: item = target_slot.current_item
		target_slot.set_item(current_item, inventory_manager.check_for_item(current_item)[1])
		inventory_manager.update_a_slot(target_slot.name.to_int(), current_item, inventory_manager.check_for_item(current_item)[1])
		if inventory_manager.check_for_item(temp_item) != [null]:
			set_item(temp_item, inventory_manager.check_for_item(temp_item)[1])
			inventory_manager.update_a_slot(name.to_int(), temp_item, inventory_manager.check_for_item(temp_item)[1])
		else:
			set_empty_slot()
			inventory_manager.update_a_slot(name.to_int(), preload("uid://jqkete66xnjp"), -1)
	icon.top_level = false
	icon.position = Vector2.ZERO
	icon.size = Vector2(100, 100)

# check if the mouse is hovering the slot
func _on_item_button_mouse_entered() -> void:
	hovering = true
	details_panel.visible = true
func _on_item_button_mouse_exited() -> void:
	hovering = false
	details_panel.visible = false
