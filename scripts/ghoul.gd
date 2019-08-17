# ghoul.gd
# Fire ghoul mob class
# warning-ignore-all:unused_class_variable

extends Entity

# General
export var type := "mob"
export var move_speed := 20.0
export var jump_force := 200.0
export var health := 100
export var damage := 1
export var knockback_strength := 15.0
export var knockback_length := 0.5

# Specific
export var move_timer_length := 1200

# Inside
var state := "run"
var move_timer := 0
var jump_attempted := false


func _physics_process(delta: float) -> void:
    sprite.flip_h = direction == 1
    match state:
        "hit":
            state_hit()
        _:
            state_default()
    gravity_loop(delta)


func state_default() -> void:
    # Decide direction
    if move_timer > 0:
        move_timer -=1
    else:
        move_timer = move_timer_length
        direction = 1 if randi() % 2 else -1

    # Decide jump
    if is_on_wall() and is_on_floor():
        if not jump_attempted:
            jump_attempted = true
            jump()
        else:
            direction *= -1
            velocity.x *= -1.0
    elif is_on_floor():
        jump_attempted = false

    # Move
    direction_loop()
    move()


func state_hit() -> void:
    move()
    yield(stun, "timeout")
    velocity.x = 0.0
    state = "run"
