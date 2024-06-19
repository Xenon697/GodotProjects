class_name Interactable
extends Node3D

## Can the player interact with this object at this time?
@export var can_interact: bool


func _ready() -> void:
	Signal_Bus.wants_to_interact.connect(on_wants_to_interact)


func on_wants_to_interact() -> void:
	if can_interact:
		do_interaction()
	else:
		# TODO: Decide whether to play a universal fail sound or one unique for each type of interaction.
		# Play failed interaction SFX.
		return


func do_interaction() -> void:
	pass
