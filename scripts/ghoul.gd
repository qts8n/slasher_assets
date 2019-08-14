# ghoul.gd
# Fire ghouul mob class
# warning-ignore-all:unused_class_variable

extends Entity

export var type := "mob"  # see `take_damage()` method of Entity
export var move_speed := 20.0
export var jump_force := 200.0
export var damage := 1  # see `take_damage()` method of Entity
export var move_timer_length := 1200

var velocity := Vector2.ZERO
var direction := 0
var move_timer := 0
var jump_attempted := false


func _physics_process(delta : float) -> void:
    # Calculate random direction and velocity
    direction = randomize_direction()
    velocity.x = direction * move_speed

    # It tries to jump over an obstacle
    # OR
    # changes direction if fails miserably
    if is_on_wall() and is_on_floor():  # faced a wall
        if not jump_attempted:  # if it is first attempt to jump over
            jump_attempted = true
            velocity.y = -jump_force
        else:  # last attempt failed
            direction *= -1
            velocity.x *= -1.0
    elif is_on_floor():  # jump succeeded
        jump_attempted = false
    velocity.y += world.gravity * delta

    # Make a move
    velocity = move_and_slide(velocity, world.floor_normal)

    # Update sprite
    sprite.flip_h = direction == 1


func randomize_direction() -> int:
    if move_timer > 0:
        move_timer -=1
        return direction

    move_timer = move_timer_length
    return 1 if randi() % 2 else -1
