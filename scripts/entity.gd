# entity.gd
# Basic entity class (use as abstract)

# TODO: split to hierarchy
# Entity -> Sentient (characters / mobs)
#        -> Item (not sentient)

extends KinematicBody2D

class_name Entity

onready var sprite: AnimatedSprite = $animated_sprite as AnimatedSprite

var direction := 0  # also used in camera script, see `camera.gd`
var velocity := Vector2.ZERO
var stun : SceneTreeTimer


func is_hit_registered(source: RayCast2D) -> bool:
    var hitbox = source.get_collider()
    if not hitbox:
        return false

    return hitbox.get_parent() == self


func direction_loop() -> void:
    velocity.x = direction * self.move_speed
    self.state = "run"
    if velocity.x == 0.0:
        self.state = "idle"
    if not is_on_floor():
        self.state = "jump"


func gravity_loop(delta: float) -> void:
    velocity.y += world.gravity * delta


func animation_loop() -> void:
    if Array(sprite.frames.get_animation_names()).has(self.state):
        sprite.play(self.state)


func move() -> void:
     velocity = move_and_slide(velocity, world.floor_normal)


func jump() -> void:
    self.state = "jump"
    velocity.y = -self.jump_force


func attack(type: String = "", dispatch = true) -> void:
    self.state = str("attack", "" if type.empty() else str("_", type))
    if dispatch:
        mm.emitg("get_hit", self)

    # Comment lines below to move while attacking
    direction = 0
    velocity.x = 0.0


func get_hit(from : Node2D) -> void:
    if from.type == self.type:
        return

    var from_ray = from.find_node("attack")
    if not from_ray or not is_hit_registered(from_ray):
        return

    self.state = "hit"
    self.health -= from.damage
    var raw = global_transform.origin - from.global_transform.origin
    velocity.x = raw.normalized().x * from.knockback_strength
    stun = get_tree().create_timer(from.knockback_length)
