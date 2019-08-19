# adventurer.gd
# Main character class
# warning-ignore-all:unused_class_variable

extends Entity

# General
export var type := "adventurer"
export var move_speed := 100.0
export var jump_force := 200.0
export var health := 100
export var damage := 20
export var knockback_strength := 500.0
export var knockback_length := 0.05

# Specific
export var dash_strength := 200.0

# Inside
var state := "idle"
onready var ray: RayCast2D = $hitbox/attack

func _physics_process(delta: float) -> void:
    animation_loop()
    match state:
        "attack_upwards", "attack_forward":
            state_attack()
        "hit":
            state_hit()
        _:
            state_default()
    gravity_loop(delta)


func state_default() -> void:
    # Animation adjustents
    if not is_on_floor():
        sprite.play("jump")
    if abs(velocity.x) > 0.0:
        sprite.flip_h = velocity.x < 0.0
        ray.cast_to.x = (-1 if sprite.flip_h else 1) * abs(ray.cast_to.x)

    # Decide direction
    direction = int(Input.is_action_pressed("move_right")) - \
            int(Input.is_action_pressed("move_left"))
    direction_loop()

    # Actions
    if Input.is_action_just_pressed("jump") and is_on_floor():
        jump()
    elif Input.is_action_just_pressed("attack_upwards"):
        attack("upwards")
    elif Input.is_action_just_pressed("attack_forward"):
        attack("forward")

    # Move
    move()


func state_attack() -> void:
    move()
    if state == "attack_forward":
        velocity.x = (-1 if sprite.flip_h else 1) * dash_strength
    yield(sprite, "animation_finished")
    state = "idle"


func _on_ghost_timer_timeout() -> void:
    if state != "attack_forward":
        return

    var ghost := preload("res://scenes/ghost.tscn").instance() as Sprite
    ghost.position = position
    ghost.texture = sprite.frames.get_frame(sprite.animation, sprite.frame)
    ghost.flip_h = sprite.flip_h
    ghost.z_index = sprite.z_index - 1
    get_parent().add_child(ghost)
