class_name BaseState
extends RefCounted


func enter_state() -> void:
	pass


func handle_input(event: InputEvent) -> void:
	pass


func handle_unhandled_input(event: InputEvent) -> void:
	pass


func handle_physics_process(delta: float) -> void:
	pass


func handle_process(delta: float) -> void:
	pass


func exit_state() -> void:
	pass
