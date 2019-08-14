# adventurer.gd
# Main character class
# warning-ignore-all:unused_class_variable

extends Entity

export var type := "adventurer"  # see `take_damage()` method of Entity
export var move_speed := 100.0
export var jump_force := 200.0
export var hitstun_length := 15
export var health := 100  # see `take_damage()` method of Entity
export var hitstun_thrs := 5

var velocity := Vector2.ZERO
var direction := 0  # also used in camera script, see `camera.gd`
var animation := "idle"


func _physics_process(delta : float) -> void:
    # Wait for attack animation to finish
    var attacked = "attack" in animation
    if attacked:
        yield(sprite, "animation_finished")

    if hitstun_length - hitstun <= hitstun_thrs:  # was hit recently
        velocity = knockback * move_speed
    else:  # healthy state
        # moving direction: -1 / 0 / 1
        direction = int(Input.is_action_pressed("move_right")) - \
            int(Input.is_action_pressed("move_left"))
        # Calculate X-velocity
        velocity.x = 0.0 if attacked else direction * move_speed
        # Calculate Y-velocity
        if Input.is_action_just_pressed("jump") and is_on_floor():
            velocity.y = -jump_force
    velocity.y += world.gravity * delta

    # Make a move
    velocity = move_and_slide(velocity, world.floor_normal)

    # Take damage if there is any
    take_damage()

    # Update aimation
    if animation == "hit":  # wait for hit animation to finish
        yield(sprite, "animation_finished")
    animation = update_animation(velocity)
    if sprite.animation != animation:
        sprite.play(animation)


func update_animation(velocity : Vector2) -> String:
    var curr_animation := "idle"

    if abs(velocity.x) > 0.0:
        sprite.flip_h = velocity.x < 0.0
        curr_animation = "run"

    if Input.is_action_just_pressed("attack_upwards"):
        curr_animation = "attack_upwards"

    if not is_on_floor():
        curr_animation = "jump"

    if hitstun != 0:
        curr_animation = "hit"

    return curr_animation
