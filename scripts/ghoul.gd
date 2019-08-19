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
onready var explosion := preload("res://scenes/explosion.tscn").instance()


func _physics_process(delta: float) -> void:
    animation_loop()
    match state:
        "hit":
            state_hit("run")
        "death":
            state_death(explosion)
        _:
            state_default()
    gravity_loop(delta)


func state_default() -> void:
    # Animation adjustents
    sprite.flip_h = direction == 1

    # Decide direction
    if move_timer > 0:
        move_timer -=1
    else:
        move_timer = move_timer_length
        direction = 1 if randi() % 2 else -1
    direction_loop()

    # Actions
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
    move()
