extends AnimatedSprite

func _ready() -> void:
    var _connected = connect("animation_finished", self, "_destroy")

func _destroy() -> void:
    queue_free()
