# entity.gd
# Basic entity class (use as abstract)
# warning-ignore-all:unused_class_variable

extends KinematicBody2D

class_name Entity

onready var sprite : AnimatedSprite = $animated_sprite as AnimatedSprite

var hitstun := 0
var knockback := Vector2.ZERO


func take_damage() -> void:
    if self.hitstun > 0:
        self.hitstun -= 1
        return

    for body in $hitbox.get_overlapping_bodies():
        if body.get("damage") != null and body.get("type") != self.type:
            self.health -= body.get("damage")
            hitstun = self.hitstun_length
            knockback = (transform.origin - body.transform.origin).normalized()
