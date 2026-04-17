class_name item
extends Resource

# vars defining the item
@export_group("Basics")
@export var id: int
@export var _name: String
@export var description: String
@export_enum("Resource", "Building", "Tools", "Armor", "Consumable") \
	var type: String
@export_enum("Shit", "Meh", "I mean it's alright", "Now we are talkin", "Good Stuff", "YES") \
	var rarity: String

@export_group("Look")
@export var icon: CompressedTexture2D
@export var dropped_model: PackedScene
@export var _3D_position: Vector3 = Vector3.ZERO
@export var _3D_scale: Vector3 = Vector3(1, 1, 1)
@export var _3D_rotation: Vector3 = Vector3.ZERO

@export_group("Quantity")
@export var is_stackable: bool
@export var max_stack_number: int
