#@tool
extends RigidBody3D

# Nodes paths
@onready var MeshPos = $MeshPos
@onready var particles: Node3D = $Particles
@onready var _3d_label: Label3D = $"3D_label"
@onready var quantity_label: Label3D = $quantity_label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Item datas
@export var item_quantity: int = 1
@export var current_item: item

# Var for checking if the player can pickup or not (distance based)
var player_in_range: bool = false
# checks if the item is already picked up to avoid duplication
var picked_up: bool = false

# direct access to the player when he enters the zone
var player: Player

var item_pickup_procedural_anim_launched: bool = false

func _ready() -> void:
	
	if Engine.is_editor_hint():
		# 3D text
		if current_item._name:
			_3d_label.text = current_item._name
		if item_quantity > 1:
			quantity_label.text = "x"+str(item_quantity)

		# Create a 3D node in the editor
		if current_item.dropped_model:
			particles.update_rarity_particles(current_item.rarity)
			var mesh = current_item.dropped_model.instantiate()
			MeshPos.add_child(mesh)

	# prevent quantities bug
	if item_quantity > current_item.max_stack_number:
		item_quantity = current_item.max_stack_number
	if item_quantity != 1 and not current_item.is_stackable:
		item_quantity = 1
	if item_quantity <= 0:
		item_quantity = 1

	# 3D text
	if current_item._name:
		_3d_label.text = current_item._name
	if item_quantity > 1:
		quantity_label.text = "x"+str(item_quantity)
	else: quantity_label.text = ""

	# Create a 3D node ingame for the item look
	if current_item.dropped_model:
		var mesh = current_item.dropped_model.instantiate()
		MeshPos.add_child(mesh)
	# Hides the particles and manages their color
	particles.update_rarity_particles(current_item.rarity)
	particles.emitting(false)
	particles.emit_ray(false)

# handles picking up the item
func _input(_event: InputEvent) -> void:
	# Check if you click on pickup button and if you'r able to pick it up
	if Input.is_action_pressed("pickup") and player_in_range == true\
		 and picked_up == false and player.pickup_ray.get_collider()==self:
		picked_up = true
		pickup_item()

func _process(delta: float) -> void:
	if player_in_range and player.pickup_ray.get_collider()==self:
		particles.emit_ray(true)
	else: particles.emit_ray(false)

	if item_pickup_procedural_anim_launched:
		self.global_transform = lerp(self.global_transform, player.item_picker.global_transform, delta * 13)
		if global_position.distance_to(player.item_picker.global_position) < 0.5: hide()

# item pickup logic
func pickup_item():
# send the current_item var in the inventory and destroy itself
	if player.Inventory:
		if current_item.is_stackable:
			# where do i stack it ?
			var has_already_item: Array = player.Inventory.inventory_manager.check_for_item(current_item)
			if has_already_item != [null]:
				# check if the quantities match
				var already_item_quantity = has_already_item[1]
				if already_item_quantity+item_quantity <= has_already_item[0].max_stack_number:
					var total_quantity: int = already_item_quantity+item_quantity
					send_item_to_inventory(current_item, total_quantity, has_already_item[2])
				else:
					var available_place_in_slot: int = current_item.max_stack_number - has_already_item[1]
					var total_quantity: int = current_item.max_stack_number
					var where: int = has_already_item[2]
					send_item_to_inventory(current_item, total_quantity, has_already_item[2], false)
					var leftover_quantity: int = item_quantity-(current_item.max_stack_number-already_item_quantity)
					var has_empty_slot: Array = player.Inventory.inventory_manager.check_for_empty_slot()
					if has_empty_slot[0]:
						where = has_empty_slot[1]
						send_item_to_inventory(current_item, leftover_quantity, where)
					else:
						animation_player.stop()
						animation_player.play("partly_picked_up")
						item_quantity = leftover_quantity
						quantity_label.text = "x"+str(item_quantity)
						player.full_inventory_notification()
			else:
				# is there a slot to slap the new item.s in ?
				var has_empty_slot: Array = player.Inventory.inventory_manager.check_for_empty_slot()
				if has_empty_slot[0]:
					var where: int = has_empty_slot[1]
					send_item_to_inventory(current_item, item_quantity, where)
				else:
					picked_up = false
					animation_player.stop()
					animation_player.play("partly_picked_up")
					player.full_inventory_notification()
		else:
			# is there a slot to slap it in ?
			var has_empty_slot: Array = player.Inventory.inventory_manager.check_for_empty_slot()
			if has_empty_slot[0]:
				var where: int = has_empty_slot[1]
				send_item_to_inventory(current_item, item_quantity, where)
			else:
				picked_up = false
				animation_player.stop()
				animation_player.play("partly_picked_up")
				player.full_inventory_notification()
func send_item_to_inventory(what, how_many, where, destroy_self: bool = true):
	player.Inventory.inventory_manager.add_item(what, how_many, where)
	if destroy_self:
		item_pickup_procedural_anim_launched = true
		_3d_label.hide()
		quantity_label.hide()
		player.pickup_notification(current_item, item_quantity)
		await get_tree().create_timer(1).timeout
		self.queue_free()

# Check if the player is in the pickup zone or not and modify "player_in_range" var
func pickup_zone_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player = body
		player_in_range = true
		particles.emitting(true)
func pickup_zone_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player_in_range = false
		particles.emitting(false)
