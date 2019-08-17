# ghoul.gd
# Wizard mob class (stationary)
# warning-ignore-all:unused_class_variable

extends Entity

# General
export var type := "mob"
export var jump_force := 300.0
export var health := 100

# Specific
export var move_timer_length := 300

# Inside
var state := "idle"
var move_timer := move_timer_length
onready var adventurer: KinematicBody2D = get_parent().find_node("adventurer") \
        as KinematicBody2D


func _physics_process(delta: float) -> void:
    animation_loop()
    match state:
        "attack_fireball":
            state_attack()
        "hit":
            state_hit()
        _:
            state_default()
    gravity_loop(delta)



func animation_loop():
    .animation_loop()
    if not adventurer:
        return
    sprite.flip_h = adventurer.transform.origin.x > transform.origin.x


func state_default() -> void:
    # Decide jump
    if move_timer > 0:
        move_timer -= 1
    else:
        if is_on_floor() and randi() % 2:
            jump()
        attack("fireball", false)
        move_timer = move_timer_length
    # Move
    move()


func state_attack() -> void:
    move()
    yield(sprite, "animation_finished")
    state = "idle"


func state_hit() -> void:
    move()
    yield(stun, "timeout")
    velocity.x = 0.0
    state = "idle"
