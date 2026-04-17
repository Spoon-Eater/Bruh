class_name Player
extends CharacterBody3D

@onready var Inventory = $HUD/Inventory
@onready var cam = $Head/camera
@onready var head = $Head
@onready var Pause_UI = $HUD/Pause_Menu
@onready var crosshair = $HUD/crosshair
@onready var pickup_ray: RayCast3D = $Head/camera/pickup_ray
@onready var item_picker: Marker3D = $item_picker
@onready var notification: Control = $HUD/Notification

var fullscreen: bool = false
var game_paused: bool = false
var in_inventory:= false

var health_changing: bool = false
var health: float = 475.0
var hunger: float = 475.0

var speed: float
var walk_speed = 7.0
var sprint_speed = 13.5
var jump_vel = 13.0

var gravity = 45.0

var mouse_sensitivity = .003
var default_mouse_sensitivity: float
var background_sensitivity = mouse_sensitivity / 27

var bob_freq = 1.4
var bob_amplitude = 0.09
var t_bob = 0.8

var default_fov = 90.0
var fov_change = 1.0

func _ready():
	cam.attributes.dof_blur_far_distance = 4
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	default_mouse_sensitivity = mouse_sensitivity

func _input(event):
	# mouse rotates cam
	if event is InputEventMouseMotion:
		if game_paused:
			return
		head.rotation.x -= event.relative.y * mouse_sensitivity
		self.rotation.y -= event.relative.x * mouse_sensitivity
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))

	if Input.is_action_just_released("inventory"):
		in_inventory = not in_inventory
		if in_inventory:
			Inventory.open_close(in_inventory)
			mouse_sensitivity = background_sensitivity
			dof_blur(true, 0.1)
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED
		else:
			Inventory.open_close(in_inventory)
			mouse_sensitivity = default_mouse_sensitivity
			dof_blur(false, 0.0)
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if Input.is_action_pressed("fullscreen"):
		fullscreen = !fullscreen
		if fullscreen == false:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	if Input.is_action_pressed("pause"):
		game_paused = !game_paused
		crosshair.visible = !game_paused
		dof_blur(true, 0.1)
		Pause_UI.open_close(game_paused)
func unpause() -> void:
	get_tree().paused = false
	game_paused = false
	dof_blur(false, 0.0)

func dof_blur(trigger: bool, amount: float):
	if trigger == true:
		cam.attributes.dof_blur_far_enabled = true
		cam.attributes.dof_blur_far_distance = amount
	else:
		cam.attributes.dof_blur_far_enabled = false

func _physics_process(delta):
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if in_inventory:
		direction = Vector3(0, 0, 0)

	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		direction += Vector3(direction.x * 1.2, 0, direction.z * 1.2)
		velocity.y = jump_vel

	if Input.is_action_pressed("sprint"):
		speed = sprint_speed
	else:
		speed = walk_speed

	# inertia and in air restricted move
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 6.3)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 6.3)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 4.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 4.0)

# bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	cam.transform.origin = head_bob(t_bob)

# fov changes
	var velocity_clamped = clamp(velocity.length(), 0.5, sprint_speed * 2)
	var target_fov = default_fov + fov_change * velocity_clamped
	cam.fov = lerp(cam.fov, target_fov, delta * 7.5)
	cam.fov = clamp(cam.fov, 90.0, 100.0)

	move_and_slide()

func head_bob(delta) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(delta * bob_freq) * bob_amplitude
	pos.x = cos(delta * bob_freq / 2) * bob_amplitude
	return pos

func full_inventory_notification():
	notification.inventory_full()
func dropped_item_notification():
	notification.dropped_item()
func pickup_notification(item_picked_up: item, quantity: int):
	notification.pickup_notification(item_picked_up, quantity)
