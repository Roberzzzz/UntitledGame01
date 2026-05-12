# LiquidStain.gd
extends Sprite2D

func _ready():
	rotation = randf_range(0, TAU)
	
	# Animación de desvanecimiento
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 4.0).set_delay(2.0)
	tween.tween_callback(queue_free)
