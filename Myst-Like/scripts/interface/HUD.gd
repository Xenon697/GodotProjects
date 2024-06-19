extends CanvasLayer


@onready var dot: TextureRect = $"Reticle Dot"


func _ready():
	Signal_Bus.interactable_in_range.connect(on_interactable_in_range)
	Signal_Bus.interactable_out_of_range.connect(on_interactable_out_of_range)


func on_interactable_in_range() -> void:
	dot.visible = true


func on_interactable_out_of_range() -> void:
	dot.visible = false
