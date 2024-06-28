class_name PlayerController
extends CharacterBody3D

@export_category("Look Controls")
@export var look_sens: float
@export var min_pitch: float
@export var max_pitch: float

@export_category("Ground Movement")
@export var ground_accel: float
@export var jog_speed: float
@export var crouch_speed: float
@export var sprint_speed: float
