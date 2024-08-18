extends Area2D
class_name Player


signal hit

@export var speed := 400 # How fast the player will move (pixels/sec).
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
var screen_size: Vector2 # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity := Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		animated_sprite.play()
	else:
		animated_sprite.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		animated_sprite.animation = "walk"
		animated_sprite.flip_v = false
		animated_sprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		animated_sprite.animation = "up"
		animated_sprite.flip_v = velocity.y > 0


func _on_body_entered(_body: RigidBody2D) -> void:
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	collision_shape.set_deferred("disabled", true)


func start(pos: Vector2) -> void:
	position = pos
	show()
	collision_shape.disabled = false
