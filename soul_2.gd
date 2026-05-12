extends CharacterBody2D

@export var speed : float = 120.0 
@export var target_path : NodePath   
@export var stop_distance : float = 20.0 
@onready var animationPlayer = $AnimationPlayer
@onready var sprite2D = $Sprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var target : Node2D = null

func _ready():
	if target_path:
		target = get_node(target_path)

func _physics_process(delta: float) -> void:
	# Gravedad
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction = 0
	
	if target:
		var diff = target.global_position.x - global_position.x
		
		# Solo se mueve si está más lejos que la distancia de parada
		if abs(diff) > stop_distance:
			direction = sign(diff) #  1 (derecha) o -1 (izquierda)
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
	
	# Girar el Sprite
	if direction != 0:
		sprite2D.flip_h = (direction == -1)

	move_and_slide()
	
	# Animaciones simplificadas para el perseguidor
	handle_enemy_animations(direction)

func handle_enemy_animations(direction):
	if is_on_floor():
		if direction != 0:
			animationPlayer.play("Run")
		else:
			animationPlayer.play("idle")
	else:
		if velocity.y < 0:
			animationPlayer.play("Jump")
		else:
			animationPlayer.play("Fall")
