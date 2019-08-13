extends KinematicBody2D

onready var sprite : AnimatedSprite = $animation_sprite

export var move_speed := 75
export var jump_force := 150
export var gravity := 300
export var snapping := true  # Turns on/off snapping to the surface
export var thrh := 50.0  # Snapping threshold

var velocity := Vector2()
var direction := 1.0
var snap := false  # Snapped state flag

func _physics_process(delta : float) -> void:
    # Moving direction: -1 <= 0 <= 1
    direction = Input.get_action_strength("move_right") - \
        Input.get_action_strength("move_left")
    velocity.x = direction * move_speed
        
    if Input.is_action_just_pressed("jump") and (not snapping or snap):
        velocity.y = -jump_force
        snap = false
        
    velocity.y += gravity * delta
    if snapping:
        var snap_v = Vector2(0, 32) if snap else Vector2()
        velocity = move_and_slide_with_snap(velocity, snap_v, Vector2.UP, thrh)
    else:
        velocity = move_and_slide(velocity)
    
    # Check if landed
    # `is_on_floor()` method will work correctly only if snapping is enabled
    if snapping and is_on_floor() and not snap:
        snap = true
    update_animation(velocity)


func update_animation(velocity : Vector2) -> void:
    var animation := "idle"
    
    if abs(velocity.x) > 10.0:
        sprite.flip_h = velocity.x < 0
        animation = "run"
    
    # FIXME: Jumping animation not works without snapping
    if snapping and not is_on_floor():
        animation = "jump"
        
    if sprite.animation != animation:
        sprite.play(animation)
        