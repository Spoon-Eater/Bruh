#@tool
extends Node3D

@onready var floor: GPUParticles3D = $floor
@onready var ray: GPUParticles3D = $ray

var particles_color: Color = Color.GRAY

func update_rarity_particles(rarity: String):
	match rarity:
		"Shit":
			particles_color = Color.LIGHT_GRAY
		"Meh":
			particles_color = Color.LIME_GREEN
		"I mean it's alright":
			particles_color = Color.BLUE
		"Now we are talkin":
			particles_color = Color.MAGENTA
		"Good Stuff":
			particles_color = Color.YELLOW
		"YES":
			particles_color = Color.RED
	floor.process_material = floor.process_material.duplicate()
	floor.process_material.color = particles_color
	ray.process_material = ray.process_material.duplicate()
	ray.process_material.color = particles_color

func emitting(trigger: bool):
	if !trigger:
		floor.emitting = false
	else:
		floor.emitting = true

func emit_ray(trigger: bool):
	if !trigger:
		ray.emitting = false
	else:
		ray.emitting = true
