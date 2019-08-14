extends Position2D

onready var adventurer : Node = $".."

func _physics_process(_delta : float) -> void:
    update_pivot_angle()

# Changes camera direction
func update_pivot_angle() -> void:
    $offset.position.x = 100.0 * adventurer.direction
