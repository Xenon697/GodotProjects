class_name Player
extends CharacterBody3D

# ==============================================================================
# VARIABLES
# ==============================================================================

@export_category("Mouse Sensitivity")
@export var mouse_sense: float = 0.002

@export_category("Camera Control")
@export var min_pitch: float = -89.0
@export var max_pitch: float = 89.0
@export var normal_fov: float = 59.0
@export var zoom_fov: float = 30.0
var current_fov: float = normal_fov

@export_category("Gravity")
@export var gravity: float = 9.8 * 3

@export_category("Ground Movement")
@export var accel: float = 35.0
@export var move_speed: float = 2.0

@export_category("Head Bob")
var time: float
@export var bob_freq: float = 5.75
@export var bob_v_amp: float = 0.025
@export var bob_h_amp: float = 0.025
@export var cam_height: float = 1.6

@onready var cam: Camera3D = $Camera
@onready var light: SpotLight3D = $Camera/Flashlight
@onready var ray: RayCast3D = $"Camera/Interact Ray"

var flashlight_on: bool = false

# ==============================================================================
# PHYSICS FUNCTIONS
# ==============================================================================

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sense)
		transform = transform.orthonormalized()
		cam.rotate_x(-event.relative.y * mouse_sense)
		cam.rotation.x = clampf(cam.rotation.x, deg_to_rad(min_pitch), deg_to_rad(max_pitch))
		cam.transform = cam.transform.orthonormalized()


func apply_gravity(delta: float) -> void:
	velocity.y -= gravity * delta


func get_in_vec() -> Vector2:
	var in_vec: Vector2 = Input.get_vector("Left", "Right", "Forward", "Back")
	return in_vec


func get_dir() -> Vector3:
	var dir: Vector3 = transform.basis * Vector3(get_in_vec().x, 0.0, get_in_vec().y).normalized()
	return dir


func move_player(delta: float) -> void:
	velocity.z = lerpf(velocity.z, get_dir().z * move_speed, accel * delta)
	velocity.x = lerpf(velocity.x, get_dir().x * move_speed, accel * delta)


func stop_player(delta: float) -> void:
	velocity.z = lerpf(velocity.z, 0.0, accel * delta)
	velocity.x = lerpf(velocity.x, 0.0, accel * delta)


func do_head_bob(delta) -> void:
	time += delta
	cam.position.y = cam_height + abs(sin(bob_freq * time)) * bob_v_amp
	cam.position.x = (cos(bob_freq * time) * bob_h_amp) / 2.0


func stop_head_bob(delta: float) -> void:
	time += delta
	cam.position.y = lerpf(cam.position.y, cam_height, 15 * delta)
	cam.position.x = lerpf(cam.position.x, 0.0, 15 * delta)

# ------------------------------------------------------------------------------

func _physics_process(delta):
	if !is_on_floor():
		apply_gravity(delta)
	if get_dir():
		move_player(delta)
		do_head_bob(delta)
	else:
		stop_player(delta)
		stop_head_bob(delta)
	move_and_slide()

# ==============================================================================
# PROCESS FUNCTIONS
# ==============================================================================

func light_on() -> bool:
	light.visible = true
	return light.visible


func light_off() -> bool:
	light.visible = false
	return light.visible


func zoom_in() -> void:
	current_fov = zoom_fov


func zoom_out() -> void:
	current_fov = normal_fov

# ------------------------------------------------------------------------------

func _process(delta):
	cam.fov = lerpf(cam.fov, current_fov, 10.0 * delta)

	if Input.is_action_just_pressed("Flashlight") && !light.visible:
		light_on()
	elif Input.is_action_just_pressed("Flashlight") && light.visible:
		light_off()
	if Input.is_action_just_pressed("Zoom"):
		zoom_in()
	elif Input.is_action_just_released("Zoom"):
		zoom_out()
