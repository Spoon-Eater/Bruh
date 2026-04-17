extends Control

@onready var icon = $Slot/SlotBorder/icon
@onready var rarity = $Slot/SlotBorder/Rarity
@onready var quantity_label = $QuantityLabel
@onready var details_panel = $Details_Panel
@onready var item_name = $Details_Panel/Item_Name
@onready var item_description = $Details_Panel/Item_Description
@onready var item_rarity = $Details_Panel/Item_Rarity
@onready var inventory_manager: Node
@onready var player: CharacterBody3D = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()
@onready var hotbar: Control
@onready var grid: GridContainer
@onready var slot_border: PanelContainer = $Slot/SlotBorder

const DROPPED_LOOT = preload("uid://dicpyav24qq4f")

var hovering: bool = false
var current_item = null

var hover_size = Vector2(120, 120)
var default_size = Vector2(100, 100)

var dragged: bool = false

var qty: int = -1

@export var is_hotbar: bool = false

# hides everyting needed to be
func _ready() -> void:
	details_panel.hide()

	if not is_hotbar:
		grid = get_parent()
		inventory_manager = get_parent().get_parent().get_parent().get_parent().get_parent().inventory_manager
		hotbar = get_parent().get_parent().get_parent().get_parent().get_parent().hotbar
		default_size = Vector2(100, 100)
		hover_size = Vector2(116, 116)
	else:
		grid = $"../../../../../TabContainer/Inventory/PanelContainer/GridContainer"
		hotbar = get_parent().get_parent().get_parent().get_parent()
		default_size = Vector2(75, 75)
		hover_size = Vector2(83, 83)
		custom_minimum_size = default_size

func update_panel_color(color = "white"):
	if color == "white": color = preload("uid://bpabkib8t7jrm")
	else: color = preload("uid://ct4b4t2f4wf04")
	slot_border["theme_override_styles/panel"] = color

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
		icon.global_position = get_global_mouse_position() - Vector2(size.x/2, size.y/2)

# self exp
func set_empty_slot():
	current_item = null
	rarity.hide()
	icon.texture = null
	quantity_label.text = ""
	item_name.text = ""
	item_description.text = ""
	item_rarity.text = ""
	qty = -1
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
	qty = quantity

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
	var target_slot = null
	for slot in grid.get_children():
		var rect = Rect2(slot.global_position, slot.size)
		if rect.has_point(get_global_mouse_position()):
			target_slot = slot
			break
	for hotslot in hotbar.h_box_container.get_children():
		var rect = Rect2(hotslot.global_position, hotslot.size)
		if rect.has_point(get_global_mouse_position()):
			target_slot = hotslot
			break
	if target_slot != null:
		var temp_item: item = target_slot.current_item
		var temp_qty = target_slot.qty
		target_slot.set_item(current_item, qty)
		inventory_manager.update_a_slot(target_slot.name.to_int(), current_item, qty, target_slot.is_hotbar)
		if inventory_manager.check_for_item(temp_item) != [null]:
			set_item(temp_item, temp_qty)
			inventory_manager.update_a_slot(name.to_int(), temp_item, temp_qty, is_hotbar)
		else:
			set_empty_slot()
			inventory_manager.update_a_slot(name.to_int(), preload("uid://jqkete66xnjp"), -1, is_hotbar)
	else: drop_item()
	icon.top_level = false
	icon.position = Vector2.ZERO
	icon.size = Vector2(100, 100)

func drop_item():
	var dropping_item = DROPPED_LOOT.instantiate()
	dropping_item.item_quantity = qty
	dropping_item.current_item = current_item
	get_tree().get_root().add_child(dropping_item)
	dropping_item.global_transform = player.global_transform
	set_empty_slot()
	inventory_manager.update_a_slot(name.to_int(), preload("uid://jqkete66xnjp"), -1, is_hotbar)
	icon.top_level = false
	icon.position = Vector2.ZERO
	icon.size = Vector2(100, 100)
	player.dropped_item_notification()

# check if the mouse is hovering the slot
func _on_item_button_mouse_entered() -> void:
	update_panel_color("white")
	hovering = true
	details_panel.visible = true
func _on_item_button_mouse_exited() -> void:
	update_panel_color("black")
	hovering = false
	details_panel.visible = false
