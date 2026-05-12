extends CharacterBody2D

# Parámetros físicos ajustables desde el Inspector
@export var speed : float = 200.0
@export var jump_velocity : float = -350.0

@onready var animationPlayer = $AnimationPlayer
@onready var sprite2D = $Sprite2D

# Gravedad del proyecto
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var was_in_air : bool = false 

func _physics_process(delta: float) -> void:
	# 1. Aplicar Gravedad
	if not is_on_floor():
		velocity.y += gravity * delta
		was_in_air = true
	
	# 2. Manejar Salto (Añadido soporte para Tecla W)
	var jump_pressed = Input.is_action_just_pressed("ui_accept") or Input.is_key_pressed(KEY_W)
	
	if jump_pressed and is_on_floor():
		velocity.y = jump_velocity

	# 3. Movimiento Horizontal (Añadido soporte para A y D directamente)
	var direction = 0
	if Input.is_key_pressed(KEY_D):
		direction += 1
	if Input.is_key_pressed(KEY_A):
		direction -= 1
	
	# Si no se presionan A o D, intenta usar las flechas por defecto
	if direction == 0:
		direction = Input.get_axis("ui_left", "ui_right")
	
	if direction != 0:
		velocity.x = direction * speed
		sprite2D.flip_h = (direction == -1) 
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	# 4. Aplicar movimiento
	move_and_slide()
	
	# 5. Llamar a la lógica de animaciones
	animations(direction)

func animations(direction):
	if is_on_floor():
		if was_in_air:
			animationPlayer.play("impact_fall")
			was_in_air = false 

		if animationPlayer.current_animation != "impact_fall":
			if direction == 0:
				animationPlayer.play("Idle")
			else:
				animationPlayer.play("Run") 
	else:
		if velocity.y < 0:
			animationPlayer.play("Jump")
		else:
			animationPlayer.play("Fall")
